#!/usr/bin/env python3
"""Search the memory of a running game for a string.

The game copies its text out of the cartridge and into the work RAM of the
SNES, and the script splits some of the strings up with control codes, so
a string can be hard to find in the ROM itself.  This tool boots the
cartridge in the headless Mesen harness, looks for a string in the work
RAM of the running game and reports where the bytes came from.

Usage:
    python3 tools/memsearch.py --find "Navigator" [--rom PATH]
    python3 tools/memsearch.py --find "King" --keys Enter,X --frames 300
    python3 tools/memsearch.py --find "Navigator" --json
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

#: How much of the work RAM is looked at.
WORK_RAM_SIZE = 0x10000


def _load_mesen():
    """Import the Mesen harness, with the library path set up."""
    home = Path.home() / ".config" / "Mesen2"
    os.environ.setdefault("LD_LIBRARY_PATH", str(home))
    from ucw.mesen import MEMORY_TYPE_SNES_WORK_RAM, Mesen  # noqa: E402

    return Mesen, MEMORY_TYPE_SNES_WORK_RAM


def _find_in_blocks(rom: bytes, needle: bytes) -> list[dict]:
    """Find the bytes in the named blocks of the cartridge."""
    hits = []
    for asset in parse_table(rom):
        data = rom[asset.file_offset : asset.file_offset + asset.length]
        at = data.find(needle)
        if at < 0:
            continue

        hits.append(
            {
                "name": asset.name,
                "fileOffset": asset.file_offset + at,
                "assetOffset": at,
                "bank": asset.bank,
                "address": asset.address + at,
            }
        )

    return hits


def _hits_in_memory(memory: bytes, needle: bytes, limit: int) -> list[dict]:
    """Find the bytes in the memory, case insensitively."""
    hits = []
    lowered = needle.lower()
    haystack = memory.lower()

    at = haystack.find(lowered)
    while at >= 0 and len(hits) < limit:
        hits.append({"memoryOffset": at})
        at = haystack.find(lowered, at + 1)

    return hits


def search(
    rom_path: Path,
    needle: str,
    keys: list[str] | None = None,
    frames: int = 120,
    limit: int = 40,
) -> dict:
    """Boot the cartridge and look for the needle in its work RAM."""
    Mesen, memory_type = _load_mesen()

    rom = rom_path.read_bytes()
    wanted = needle.encode("latin-1", "replace")

    mesen = Mesen()
    mesen.init()
    if not mesen.load_rom(rom_path):
        raise RuntimeError(f"the emulator refused to load {rom_path}")

    # The emulator needs a moment before the debugger can be used.
    time.sleep(2.0)
    mesen.init_debugger()

    for key in keys or []:
        try:
            mesen.tap(key, 3)
        except Exception:
            pass
        time.sleep(0.7)

    if frames > 0:
        try:
            mesen.wait_frames(frames, timeout=30.0)
        except Exception:
            pass

    memory = mesen.read_memory(memory_type, 0, WORK_RAM_SIZE)
    mesen.release()

    results = []
    for hit in _hits_in_memory(memory, wanted, limit):
        offset = hit["memoryOffset"]
        # Show a bit of the text around the hit.
        lo = max(0, offset - 8)
        hi = min(len(memory), offset + len(wanted) + 24)
        context = memory[lo:hi].decode("latin-1", "replace")

        results.append(
            {
                "memoryOffset": offset,
                "memoryAddress": f"${offset:04X}",
                "text": context,
                "blocks": _find_in_blocks(rom, memory[offset : offset + len(wanted)]),
            }
        )

    return {
        "needle": needle,
        "frames": frames,
        "keys": keys or [],
        "hits": results,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None, help="cartridge to boot")
    parser.add_argument("--find", required=True, help="the text to look for")
    parser.add_argument(
        "--keys",
        default="",
        help="keys to press before the search, separated by commas",
    )
    parser.add_argument("--frames", type=int, default=120, help="frames to run")
    parser.add_argument("--limit", type=int, default=40, help="most hits to report")
    parser.add_argument("--json", action="store_true", help="print the result as JSON")
    args = parser.parse_args()

    rom = args.rom
    if rom is None:
        from ucw.rom import find_rom  # noqa: E402

        rom = find_rom()

    keys = [k.strip() for k in args.keys.split(",") if k.strip()]

    try:
        result = search(rom, args.find, keys, args.frames, args.limit)
    except FileNotFoundError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    except Exception as exc:  # pragma: no cover - the emulator can fail in many ways
        print(f"error: {exc}", file=sys.stderr)
        return 1

    if args.json:
        print(json.dumps(result, indent=2))
        return 0

    hits = result["hits"]
    if not hits:
        print(f"{args.find!r} was not found in the work RAM")
        return 0

    print(f"{len(hits)} hits for {args.find!r} in the work RAM:")
    for hit in hits:
        blocks = hit["blocks"]
        if blocks:
            where = ", ".join(
                f"{b['name']} +0x{b['assetOffset']:04X}" for b in blocks
            )
        else:
            where = "not in the cartridge"

        print(f"  {hit['memoryAddress']}  {where}")
        print(f"      {hit['text']!r}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
