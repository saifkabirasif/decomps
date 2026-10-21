#!/usr/bin/env python3
"""Read the colour memory of the running game.

The game keeps its palettes in the colour memory of the SNES, 256 words
of 15 bit colour in the order 0bbbbggggrrrrrrrr.  The words are read
from the memory of the emulator, so the editor can show the real colours
of the game and use them to draw the tiles.

The script of the game also keeps a copy of the palette of the picture
that is on the screen at the work RAM address $0CC8.

Usage:
    python3 tools/cgramread.py [--rom PATH] [--json]
    python3 tools/cgramread.py --palette 3
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

#: The number of colours in the colour memory.
CGRAM_ENTRIES = 256

#: The number of colours in one palette.
PALETTE_ENTRIES = 16

#: The work RAM address where the script keeps the palette of the picture
#: that is on the screen.
SCRIPT_PALETTE = 0x0CC8


def _load_mesen():
    """Import the Mesen harness, with the library path set up."""
    home = Path.home() / ".config" / "Mesen2"
    os.environ.setdefault("LD_LIBRARY_PATH", str(home))
    from ucw.mesen import Mesen  # noqa: E402

    return Mesen


def _decode(word: int) -> tuple[int, int, int]:
    """Turn a colour word into its red, green and blue part."""
    return (
        (word & 0x1F) << 3,
        ((word >> 5) & 0x1F) << 3,
        ((word >> 10) & 0x1F) << 3,
    )


def read(rom_path: Path | None = None) -> dict:
    """Boot the cartridge and read its colours."""
    Mesen = _load_mesen()

    if rom_path is None:
        from ucw.rom import find_rom  # noqa: E402

        rom_path = find_rom()

    mesen = Mesen()
    mesen.init()
    if not mesen.load_rom(rom_path):
        raise RuntimeError(f"the emulator refused to load {rom_path}")

    time.sleep(2.0)
    mesen.init_debugger()
    time.sleep(1.0)

    # The colour memory of the SNES.
    cgram = mesen.read_memory(19, 0, CGRAM_ENTRIES * 2)

    # The copy of the palette of the script.
    script = mesen.read_memory(15, SCRIPT_PALETTE, PALETTE_ENTRIES * 2)

    mesen.release()

    palettes = []
    for index in range(CGRAM_ENTRIES // PALETTE_ENTRIES):
        words = []
        for k in range(PALETTE_ENTRIES):
            at = (index * PALETTE_ENTRIES + k) * 2
            words.append(cgram[at] | (cgram[at + 1] << 8))

        palettes.append(
            {
                "index": index,
                "words": words,
                "colors": [_decode(w) for w in words],
            }
        )

    script_words = [script[2 * k] | (script[2 * k + 1] << 8) for k in range(PALETTE_ENTRIES)]

    return {
        "palettes": palettes,
        "scriptPalette": {
            "address": f"${SCRIPT_PALETTE:04X}",
            "words": script_words,
            "colors": [_decode(w) for w in script_words],
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None, help="cartridge to boot")
    parser.add_argument("--palette", type=int, default=None, help="show one palette only")
    parser.add_argument("--json", action="store_true", help="print the result as JSON")
    args = parser.parse_args()

    try:
        result = read(args.rom)
    except Exception as exc:  # pragma: no cover - the emulator can fail in many ways
        print(f"error: {exc}", file=sys.stderr)
        return 1

    if args.json:
        print(json.dumps(result, indent=2))
        return 0

    for palette in result["palettes"]:
        if args.palette is not None and palette["index"] != args.palette:
            continue

        colors = " ".join(f"#{r:02X}{g:02X}{b:02X}" for r, g, b in palette["colors"])
        print(f"palette {palette['index']:2d}: {colors}")

    script = result["scriptPalette"]
    colors = " ".join(f"#{r:02X}{g:02X}{b:02X}" for r, g, b in script["colors"])
    print(f"the palette of the script at {script['address']}: {colors}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
