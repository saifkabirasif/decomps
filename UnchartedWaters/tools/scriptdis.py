#!/usr/bin/env python3
"""Disassemble the program of a script block.

The blocks of the cartridge that hold the dialogue are the program of a
small machine that the game runs.  This tool turns such a program into
a listing, so that the script of the game can be read the way the game
reads it.

The machine is in bank `$00`:

* `$A0FD` is the machine itself,
* `$A797` is the dispatch table: 256 addresses, one for every
  instruction of the machine,
* every handler is a piece of code that says how many bytes the
  instruction takes and what it does with them.

Usage:
    python3 tools/scriptdis.py --block oukyu
    python3 tools/scriptdis.py --block oukyu --at 0x1918
    python3 tools/scriptdis.py --list
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from asset_table import parse_table  # noqa: E402
from scriptvm import DISPATCH_ADDRESS, read_dispatch, read_header  # noqa: E402
from ucw import disasm as D  # noqa: E402
from ucw.rom import Rom, find_rom  # noqa: E402

#: Where the machine reads the program from.
POINTER = 0x0006

#: The helpers that step over the operands of an instruction.
ONE_BYTE = (0xA73A, 0xA74C)
TWO_BYTES = (0xA76D, 0xA775)
ONE_OR_TWO = (0xA77F,)

#: The instruction that ends every handler.
LOOP = 0xA141

#: The names of the instructions that are known.  The instructions that
#: read or write a variable of the block are named after the place they
#: work on.
NAMES: dict[int, str] = {}

#: The instructions that read a variable of the block, and the place.
VARIABLES = {
    0x00: "read", 0x01: "read", 0x02: "read", 0x03: "read",
    0x04: "read", 0x05: "read", 0x06: "read", 0x07: "read",
    0x08: "read", 0x09: "read", 0x0A: "read", 0x0B: "read",
    0x0C: "read far", 0x0D: "read far", 0x0E: "read far", 0x0F: "read far",
    0x10: "read", 0x11: "read", 0x12: "read", 0x13: "read",
    0x14: "read", 0x15: "read", 0x16: "read", 0x17: "read",
    0x18: "read", 0x19: "read", 0x1A: "read", 0x1B: "read",
    0x20: "write", 0x21: "write", 0x22: "write", 0x23: "write",
    0x24: "write", 0x25: "write", 0x26: "write", 0x27: "write",
    0x28: "write", 0x29: "write", 0x2A: "write", 0x2B: "write",
}


def _decode_region(rom: Rom, start: int, end: int) -> dict[int, D.Insn]:
    """Every instruction of a stretch of the machine, by address."""
    out: dict[int, D.Insn] = {}
    for insn in D.disassemble_65816_tracked(
        rom.data[start - 0x8000:], start, end - start, True, True
    ):
        out[insn.address] = insn
    return out


def handler_rows(rom: Rom, address: int, limit: int = 40,
                 handlers: frozenset[int] = frozenset()) -> list[D.Insn]:
    """The instructions of one handler of the machine.

    A handler is often only a jump into a piece of code that many
    handlers share, so the code is followed until it comes back to the
    loop of the machine.
    """
    region = _decode_region(rom, 0xA100, 0xA997)
    seen: set[int] = set()
    order: list[D.Insn] = []
    stack = [address]
    while stack and len(order) < limit:
        at = stack.pop()
        if at in seen or at not in region:
            continue
        seen.add(at)
        insn = region[at]
        order.append(insn)
        if insn.mnemonic == "JMP":
            target = insn.operand.replace("$", "")
            if target == f"{LOOP:04X}":
                break
            try:
                target = int(target, 16)
            except ValueError:
                continue
            if target not in handlers:
                stack.append(target)
            continue
        if insn.mnemonic in ("RTS", "RTI", "STP"):
            break
        if insn.mnemonic == "JSR":
            try:
                target = int(insn.operand.replace("$", ""), 16)
            except ValueError:
                target = -1
            if target not in handlers:
                stack.append(target)
        elif insn.mnemonic in ("BCC", "BCS", "BNE", "BEQ", "BPL", "BMI",
                               "BVC", "BVS", "BRA"):
            try:
                stack.append(int(insn.operand.replace("$", ""), 16))
            except ValueError:
                pass
        stack.append(at + insn.size)
    return order


def operand_length(rom: Rom, table: list[int], opcode: int) -> int:
    """How many bytes the operands of an instruction take."""
    # The helpers are not followed when they happen to be the place of
    # a handler as well.
    handlers = frozenset(table) - frozenset(
        ONE_BYTE + TWO_BYTES + ONE_OR_TWO
    )
    helpers: set[int] = set()
    address = table[opcode]
    for _ in range(3):
        calls: set[int] = set()
        for insn in handler_rows(rom, address, handlers=handlers):
            if insn.mnemonic not in ("JSR", "JMP"):
                continue
            try:
                target = int(insn.operand.replace("$", ""), 16)
            except ValueError:
                continue
            if target in ONE_BYTE + TWO_BYTES + ONE_OR_TWO:
                helpers.add(target)
            elif target in table:
                calls.add(target)
        if not calls:
            break
        address = calls.pop()
    if helpers & set(ONE_OR_TWO):
        return -1
    if helpers & set(TWO_BYTES):
        return 2
    if helpers & set(ONE_BYTE):
        return 1
    return 0


def name_of(opcode: int) -> str:
    """The name of an instruction."""
    if opcode in NAMES:
        return NAMES[opcode]
    if opcode in VARIABLES:
        return VARIABLES[opcode]
    return f"op ${opcode:02X}"


def is_text(byte: int) -> bool:
    """Is this byte part of a piece of text?"""
    return byte == 0x0A or 0x20 <= byte < 0x7F


def disassemble(rom: Rom, table: list[int], data: bytes, start: int,
                end: int) -> list[str]:
    """Turn a program into a listing."""
    lengths = [operand_length(rom, table, op) for op in range(256)]
    lines = []
    at = start
    while at < end:
        opcode = data[at]
        length = lengths[opcode]
        if length < 0:
            # The byte that follows says how long the operand is.
            length = 2 if data[at + 1] & 0x80 else 1
        operand = data[at + 1 : at + 1 + length]
        shown = " ".join(f"{b:02X}" for b in operand)
        lines.append(
            f"  +{at:04X}  ${opcode:02X}   {name_of(opcode):<12} {shown}"
        )
        at += 1 + length
    return lines


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--block", default=None, help="the block to show")
    parser.add_argument("--at", type=lambda v: int(v, 0), default=None,
                        help="a place in the block to start at")
    parser.add_argument("--length", type=lambda v: int(v, 0), default=0x200,
                        help="how many bytes to show")
    parser.add_argument("--list", action="store_true",
                        help="show the instructions of the machine")
    args = parser.parse_args()

    rom = Rom(args.rom or find_rom())
    table = read_dispatch(rom.data)

    if args.list:
        print(f"the dispatch table is at bank $00, ${DISPATCH_ADDRESS:04X}\n")
        for opcode in range(256):
            length = operand_length(rom, table, opcode)
            text = "no operand" if length == 0 else (
                "one byte" if length == 1 else (
                    "two bytes" if length == 2 else "one or two bytes"))
            print(f"  ${opcode:02X} -> ${table[opcode]:04X}  "
                  f"{name_of(opcode):<12} {text}")
        return 0

    if not args.block:
        parser.error("use --block or --list")

    header = read_header(rom.data, args.block)
    asset = next(a for a in parse_table(rom.data) if a.name == args.block)
    data = rom.data[asset.file_offset : asset.file_offset + asset.length]

    start = args.at if args.at is not None else header.entry_in_block
    end = min(start + args.length, len(data))

    print(f"the block {args.block} starts its program at +{start:04X}")
    print(f"the instruction that runs first is ${table[0]:04X} "
          f"of the machine\n")
    for line in disassemble(rom, table, data, start, end):
        print(line)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
