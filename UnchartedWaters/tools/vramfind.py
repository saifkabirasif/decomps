#!/usr/bin/env python3
"""Find what in the cartridge ended up in the video memory of the game.

The game copies its tiles and its maps into the video memory of the
SNES.  What sits in there is a copy of the cartridge, so a piece of the
video memory can be looked for in the cartridge to find out where the
graphics live.

Usage:
    python3 tools/vramfind.py [--rom PATH] [--bytes 64] [--top 20]
    python3 tools/vramfind.py --json
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from asset_table import parse_table  # noqa: E402

#: The video memory of the SNES.
VIDEO_RAM_SIZE = 0x10000


def _load_mesen():
    """Import the Mesen harness, with the library path set up."""
    home = Path.home() / ".config" / "Mesen2"
    os.environ.setdefault("LD_LIBRARY_PATH", str(home))
    from ucw.mesen import MEMORY_TYPE_SNES_VIDEO_RAM, Mesen  # noqa: E402

    return Mesen, MEMORY_TYPE_SNES_VIDEO_RAM


def _where_in_blocks(rom: bytes, needle: bytes) -> list[dict]:
    """Find the bytes in the named blocks of the cartridge."""
    hits = []
    for asset in parse_table(rom):
        data = rom[asset.file_offset : asset.file_offset + asset.length]
        at = data.find(needle)
        if at >= 0:
            hits.append(
                {
                    "name": asset.name,
                    "fileOffset": asset.file_offset + at,
                    "assetOffset": at,
                }
            )

    return hits


def scan(rom_path: Path, size: int, top: int) -> list[dict]:
    """Boot the cartridge and look for the video memory in the cartridge."""
    Mesen, memory_type = _load_mesen()

    rom = rom_path.read_bytes()

    mesen = Mesen()
    mesen.init()
    if not mesen.load_rom(rom_path):
        raise RuntimeError(f"the emulator refused to load {rom_path}")

    time.sleep(2.0)
    mesen.init_debugger()
    time.sleep(1.0)

    vram = mesen.read_memory(memory_type, 0, VIDEO_RAM_SIZE)
    mesen.release()

    found = []
    for at in range(0, len(vram) - size, size):
        piece = vram[at : at + size]
        if len(set(piece)) < 4:
            # Nothing but a few values, that is empty memory.
            continue

        blocks = _where_in_blocks(rom, piece)
        if blocks:
            found.append(
                {
                    "vramOffset": at,
                    "vramAddress": f"${at:04X}",
                    "blocks": blocks,
                }
            )

    return found[:top]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None, help="cartridge to boot")
    parser.add_argument("--bytes", type=int, default=64, help="size of the piece to look for")
    parser.add_argument("--top", type=int, default=20, help="most hits to report")
    parser.add_argument("--json", action="store_true", help="print the result as JSON")
    args = parser.parse_args()

    rom = args.rom
    if rom is None:
        from ucw.rom import find_rom  # noqa: E402

        rom = find_rom()

    try:
        found = scan(rom, args.bytes, args.top)
    except Exception as exc:  # pragma: no cover - the emulator can fail in many ways
        print(f"error: {exc}", file=sys.stderr)
        return 1

    if args.json:
        print(json.dumps(found, indent=2))
        return 0

    if not found:
        print("nothing of the video memory was found in the cartridge")
        return 0

    print(f"{len(found)} pieces of the video memory are in the cartridge:")
    for hit in found:
        where = ", ".join(f"{b['name']} +0x{b['assetOffset']:04X}" for b in hit["blocks"])
        print(f"  VRAM {hit['vramAddress']}  ->  {where}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
