#!/usr/bin/env python3
"""Lift a region of the original ROM into WLA DX assembly.

The port is mechanical to begin with: lift the bytes, then rename the labels
and add the comments by hand.  The lifter follows the original's immediate
widths (the accumulator width decides them) and keeps the direct page
addresses as they are.

Usage:
    python3 tools/port.py $8190 $82B3 --m16 0 > src/init.s
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.disasm import decode_65816  # noqa: E402
from ucw.rom import find_rom  # noqa: E402

# Instructions whose operand is a plain 16 bit address.
_ABS = re.compile(r"^\$[0-9A-F]{4}$")


def label_for(address: int) -> str:
    return f"L{address:04X}"


def lift(data: bytes, start: int, m16: bool, x16: bool) -> tuple[str, list[int]]:
    """Return (assembly text, addresses that need a label)."""
    # First pass: find the branch targets so the labels can be placed at the
    # right address.
    label_targets: set[int] = set()
    pos = 0
    scan_m16, scan_x16 = m16, x16
    while pos < len(data):
        address = start + pos
        insn = decode_65816(data[pos:], address, scan_m16, scan_x16)
        if insn.mnemonic in ("REP", "SEP"):
            flags = insn.raw[1] if len(insn.raw) > 1 else 0
            if flags & 0x20:
                scan_m16 = insn.mnemonic == "REP"
            if flags & 0x10:
                scan_x16 = insn.mnemonic == "REP"
        if insn.mnemonic in (
            "BRA", "BEQ", "BNE", "BCS", "BCC", "BMI", "BPL", "BVS", "BVC"
        ):
            label_targets.add(int(insn.operand[1:5], 16))
        pos += insn.size

    lines: list[str] = []
    pos = 0
    while pos < len(data):
        address = start + pos
        insn = decode_65816(data[pos:], address, m16, x16)
        raw = insn.raw
        mnemonic = insn.mnemonic
        operand = insn.operand

        if mnemonic in ("REP", "SEP"):
            flags = raw[1] if len(raw) > 1 else 0
            if flags & 0x20:
                m16 = mnemonic == "REP"
            if flags & 0x10:
                x16 = mnemonic == "REP"

        text = f"    {mnemonic}"
        if operand:
            if mnemonic in ("BRA", "BEQ", "BNE", "BCS", "BCC", "BMI", "BPL", "BVS", "BVC"):
                target = int(operand[1:5], 16)
                text += f" {label_for(target)}"
            elif mnemonic in ("JSR", "JMP"):
                if _ABS.match(operand):
                    target = int(operand[1:5], 16)
                    text += f" ${target:04X}"
                else:
                    text += f" {operand}"
            else:
                text += f" {operand}"
        if address in label_targets:
            lines.append(f"{label_for(address)}:")
        lines.append(text)
        pos += insn.size

    return "\n".join(lines), sorted(label_targets)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("start")
    parser.add_argument("end")
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--m16", type=int, choices=[0, 1], default=1)
    parser.add_argument("--x16", type=int, choices=[0, 1], default=1)
    args = parser.parse_args()

    rom = find_rom().read_bytes() if args.rom is None else args.rom.read_bytes()

    def parse(text: str) -> tuple[int, int]:
        text = text.replace("$", "").upper()
        if ":" in text:
            bank, addr = text.split(":")
            return int(bank, 16), int(addr, 16)
        return 0, int(text, 16)

    bank, start = parse(args.start)
    _, end = parse(args.end)
    offset = bank * 0x8000 + (start - 0x8000)
    data = rom[offset : offset + (end - start)]

    text, targets = lift(data, start, bool(args.m16), bool(args.x16))
    print(text)
    print("; branch targets:", ", ".join(label_for(t) for t in targets))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
