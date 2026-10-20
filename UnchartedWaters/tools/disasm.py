#!/usr/bin/env python3
"""Disassemble a region of the original ROM.

The cartridge is a 1 MiB LoROM image, so CPU address $N:8000-$FFFF lives at
file offset N * $8000.  The decoder tracks the accumulator and index widths
so that 16 bit immediates are decoded correctly.

Usage:
    python3 tools/disasm.py $8100 $8160            # CPU addresses
    python3 tools/disasm.py --file 0x008000 0x40   # raw file offsets
    python3 tools/disasm.py --spc 0x070000 0x40    # SPC700 code
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.disasm import decode_65816, decode_spc700  # noqa: E402
from ucw.rom import find_rom  # noqa: E402


def parse_cpu_address(text: str) -> tuple[int, int]:
    """Parse ``$8100`` or ``$01:8100`` into (bank, address)."""
    text = text.replace("$", "").upper()
    if ":" in text:
        bank, addr = text.split(":")
        return int(bank, 16), int(addr, 16)
    return 0, int(text, 16)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("start", help="start address, e.g. $8100 or $01:8100")
    parser.add_argument("end", nargs="?", help="end address (exclusive)")
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--file", nargs=2, metavar=("OFFSET", "LENGTH"))
    parser.add_argument("--spc", nargs=2, metavar=("OFFSET", "LENGTH"))
    parser.add_argument(
        "--m16", type=int, choices=[0, 1], default=1,
        help="accumulator width at the start address (1 = 16 bit)",
    )
    parser.add_argument(
        "--x16", type=int, choices=[0, 1], default=1,
        help="index register width at the start address (1 = 16 bit)",
    )
    args = parser.parse_args()

    rom = find_rom().read_bytes() if args.rom is None else args.rom.read_bytes()

    if args.spc:
        offset = int(args.spc[0], 0)
        length = int(args.spc[1], 0)
        data = rom[offset : offset + length]
        pos = 0
        while pos < len(data):
            insn = decode_spc700(data[pos:], offset + pos)
            print(f"{insn.address:06X}: {insn}")
            pos += insn.size
        return 0

    if args.file:
        offset = int(args.file[0], 0)
        length = int(args.file[1], 0)
        start_addr = 0x8000
        data = rom[offset : offset + length]
    else:
        bank, start_addr = parse_cpu_address(args.start)
        if args.end:
            _, end_addr = parse_cpu_address(args.end)
        else:
            end_addr = start_addr + 0x100
        offset = bank * 0x8000 + (start_addr - 0x8000)
        data = rom[offset : offset + (end_addr - start_addr)]

    pos = 0
    m16 = bool(args.m16)
    x16 = bool(args.x16)
    while pos < len(data):
        insn = decode_65816(data[pos:], start_addr + pos, m16, x16)
        if insn.mnemonic in ("REP", "SEP"):
            flags = insn.raw[1] if len(insn.raw) > 1 else 0
            if flags & 0x20:
                m16 = insn.mnemonic == "REP"
            if flags & 0x10:
                x16 = insn.mnemonic == "REP"
        print(f"{insn.address:04X}: {insn}")
        pos += insn.size
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
