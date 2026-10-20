#!/usr/bin/env python3
"""Lift a region of the original ROM into a WLA DX source file.

This is the work horse of the porting work: the bytes are turned into
assembly mechanically, and the result is then edited by hand (labels,
comments, structure).  The lifter follows the original's immediate widths -
the accumulator width decides them, the index width only matters for LDX and
LDY - and keeps direct page addresses as they are.

Usage:
    python3 tools/lift.py $8361 $83C0 --title "NMI handler" --out src/vblank.s
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.disasm import decode_65816  # noqa: E402
from ucw.rom import find_rom  # noqa: E402

BRANCHES = ("BRA", "BEQ", "BNE", "BCS", "BCC", "BMI", "BPL", "BVS", "BVC")
ABSOLUTE = re.compile(r"^\$[0-9A-F]{4}$")


def label_for(address: int) -> str:
    return f"L{address:04X}"


def scan(data: bytes, start: int, m16: bool, x16: bool) -> set[int]:
    """Find the branch targets inside the region."""
    targets: set[int] = set()
    pos = 0
    while pos < len(data):
        insn = decode_65816(data[pos:], start + pos, m16, x16)
        if insn.mnemonic in ("REP", "SEP"):
            flags = insn.raw[1] if len(insn.raw) > 1 else 0
            if flags & 0x20:
                m16 = insn.mnemonic == "REP"
            if flags & 0x10:
                x16 = insn.mnemonic == "REP"
        if insn.mnemonic in BRANCHES:
            targets.add(int(insn.operand[1:5], 16))
        pos += insn.size
    return targets


def lift(data: bytes, start: int, m16: bool, x16: bool) -> str:
    """Return the assembly for the region."""
    targets = scan(data, start, m16, x16)
    lines: list[str] = []
    pos = 0
    while pos < len(data):
        address = start + pos
        insn = decode_65816(data[pos:], address, m16, x16)
        mnemonic, operand = insn.mnemonic, insn.operand
        if mnemonic in ("REP", "SEP"):
            flags = insn.raw[1] if len(insn.raw) > 1 else 0
            if flags & 0x20:
                m16 = mnemonic == "REP"
            if flags & 0x10:
                x16 = mnemonic == "REP"

        if address in targets:
            lines.append(f"{label_for(address)}:")
        text = f"    {mnemonic}"
        if operand:
            if mnemonic in BRANCHES:
                text += f" {label_for(int(operand[1:5], 16))}"
            elif mnemonic in ("JSR", "JMP") and ABSOLUTE.match(operand):
                text += f" ${int(operand[1:5], 16):04X}"
            else:
                text += f" {operand}"
        lines.append(text)
        pos += insn.size
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("start")
    parser.add_argument("end")
    parser.add_argument("--title", default="", help="module title")
    parser.add_argument("--out", type=Path, default=None, help="write a .s file")
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--bank", type=int, default=0)
    parser.add_argument("--m16", type=int, choices=[0, 1], default=1)
    parser.add_argument("--x16", type=int, choices=[0, 1], default=1)
    args = parser.parse_args()

    rom = find_rom().read_bytes() if args.rom is None else args.rom.read_bytes()

    def parse(text: str) -> int:
        return int(text.replace("$", "").upper(), 16)

    start = parse(args.start)
    end = parse(args.end)
    offset = args.bank * 0x8000 + (start - 0x8000)
    data = rom[offset : offset + (end - start)]

    body = lift(data, start, bool(args.m16), bool(args.x16))
    if args.out is None:
        print(body)
        return 0

    text = f""";
; Uncharted Waters (USA) - {args.title or "lifted routine"}
;
; Lifted byte for byte from the original cartridge
; (bank ${args.bank:02X}, ${start:04X}-${end - 1:04X}).
;

.INCLUDE "snes_lorom.i"

.BANK {args.bank} SLOT {args.bank}
.ORGA ${start:04X}

{body}
"""
    args.out.write_text(text)
    print(f"wrote {args.out} (${start:04X}-${end - 1:04X})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
