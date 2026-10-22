#!/usr/bin/env python3
"""Make a cartridge that plays itself.

The headless emulator has no key map, so nothing that is pressed reaches
the game.  But the game reads the joypad of the SNES in two places, and
both are three bytes long in the cartridge:

    $8378: CMP $4210    the buttons A, B, X, Y, L and R
    $9587: CMP $4211    the direction pad

The comparison leaves the carry set when no button is pressed, so
changing it to a comparison that always leaves the carry clear makes
the game think a button is pressed, and changing it the other way makes
it think no button is pressed.

Usage:
    python3 tools/patchinput.py --out /tmp/auto.sfc --press
    python3 tools/patchinput.py --out /tmp/auto.sfc --release
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.rom import find_rom  # noqa: E402

#: Where the game reads the joypad, and what it reads.
JOYPAD_READS = ((0x8378, 0x4210), (0x9587, 0x4211))


def patch(data: bytes, pressed: bool) -> bytes:
    """Change the two places where the game reads the joypad."""
    out = bytearray(data)
    # CMP #$0001 always leaves the carry clear, which the game reads as
    # a button that is pressed; CMP #$0000 always leaves it set.
    replacement = bytes([0xE9, 0x01, 0x00]) if pressed else bytes([0xE9, 0x00, 0x00])
    for address, register in JOYPAD_READS:
        at = address - 0x8000
        original = bytes([0xCD, register & 0xFF, (register >> 8) & 0xFF])
        if out[at : at + 3] != original:
            raise SystemExit(
                f"the cartridge does not read ${register:04X} at ${address:04X}; "
                f"it has {out[at:at+3].hex(' ')} there"
            )
        out[at : at + 3] = replacement
    return bytes(out)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--out", type=Path, required=True,
                        help="the cartridge to write")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--press", action="store_true",
                       help="the game thinks a button is pressed")
    group.add_argument("--release", action="store_true",
                       help="the game thinks no button is pressed")
    args = parser.parse_args()

    rom_path = args.rom or find_rom()
    out = patch(rom_path.read_bytes(), args.press)
    args.out.write_bytes(out)
    print(f"wrote {args.out} ({len(out)} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
