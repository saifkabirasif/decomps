#!/usr/bin/env python3
"""Read the script machine of the cartridge.

The blocks of the cartridge that hold the dialogue are not text with a
few marks in it: they are the program of a small machine that the game
runs.  The block is copied into the work memory and the game walks
through it, one byte at a time.

This tool reads the tables of that machine out of the cartridge:

* the **header** of a block, which says where in the block the program
  starts,
* the **dispatch table**, which says where the code of every one of the
  256 instructions of the machine is,
* the **handlers** themselves, which are five bytes long and carry the
  place in the block that the instruction works on.

Usage:
    python3 tools/scriptvm.py                    # the tables
    python3 tools/scriptvm.py --block oukyu      # the header of a block
    python3 tools/scriptvm.py --json
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from asset_table import parse_table  # noqa: E402
from ucw.rom import find_rom  # noqa: E402

#: Where the dispatch table of the machine is, in bank $00.
DISPATCH_ADDRESS = 0xA797

#: How many instructions the machine has.
OPCODE_COUNT = 256

#: The two bytes every block of the cartridge starts with.
BLOCK_MAGIC = b"\x4c\x03"

#: Where the game copies a block to, in the work memory.
SCRIPT_RAM = 0x2000

#: Where the program of a block starts, taken from the header.
ENTRY_OFFSET = 2

#: Where the machine keeps the pointer to the block it is running.
POINTER_ADDRESS = 0x0000


@dataclass(frozen=True)
class BlockHeader:
    """The start of a block of the cartridge."""

    name: str
    entry: int
    interpreter: int
    flags: int
    raw: bytes

    @property
    def is_script(self) -> bool:
        """Does this block hold a program of the script machine?"""
        return (
            self.raw[:2] == BLOCK_MAGIC
            and SCRIPT_RAM <= self.entry < SCRIPT_RAM + 0x100
        )

    @property
    def entry_in_block(self) -> int:
        """Where in the block the program starts."""
        return self.entry - SCRIPT_RAM


def read_header(rom: bytes, name: str) -> BlockHeader:
    """Read the header of a block of the cartridge."""
    for asset in parse_table(rom):
        if asset.name != name:
            continue
        raw = rom[asset.file_offset : asset.file_offset + 8]
        return BlockHeader(
            name=name,
            entry=raw[ENTRY_OFFSET] | (raw[ENTRY_OFFSET + 1] << 8),
            interpreter=raw[4] | (raw[5] << 8),
            flags=raw[6] | (raw[7] << 8),
            raw=raw,
        )
    raise SystemExit(f"there is no block called {name!r}")


def read_dispatch(rom: bytes) -> list[int]:
    """Read the dispatch table: where the code of every instruction is."""
    offset = DISPATCH_ADDRESS - 0x8000
    table = []
    for i in range(OPCODE_COUNT):
        table.append(rom[offset + 2 * i] | (rom[offset + 2 * i + 1] << 8))
    return table


def read_handlers(rom: bytes) -> dict[int, int]:
    """Read the place in the block that every instruction works on.

    Every handler is five bytes: ``LDA #<place>`` followed by a branch
    that is always taken.  The place is a signed offset from the start
    of the program of the block.
    """
    table = read_dispatch(rom)
    handlers: dict[int, int] = {}
    for opcode, address in enumerate(table):
        offset = address - 0x8000
        if rom[offset] != 0xA9:  # LDA #imm
            continue
        place = rom[offset + 1] | (rom[offset + 2] << 8)
        if place >= 0x8000:
            place -= 0x10000
        handlers[opcode] = place
    return handlers


def group_handlers(table: list[int]) -> dict[int, list[int]]:
    """Put the instructions that share their code together."""
    groups: dict[int, list[int]] = {}
    for opcode, address in enumerate(table):
        groups.setdefault(address, []).append(opcode)
    return groups


def show_handler(rom: bytes, opcode: int, length: int = 12) -> list[str]:
    """Show the code of the handler of an instruction."""
    from ucw.disasm import disassemble_65816_tracked

    table = read_dispatch(rom)
    address = table[opcode]
    offset = address - 0x8000
    lines = []
    for insn in disassemble_65816_tracked(rom[offset:], address, length, True, True):
        lines.append(f"  ${insn.address:04X}: {insn.mnemonic:8s} {insn.operand}")
    return lines


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None, help="cartridge to use")
    parser.add_argument("--block", default=None, help="a block to show the header of")
    parser.add_argument("--handler", default=None,
                        help="show the code of an instruction, e.g. 00 or 8d")
    parser.add_argument("--json", action="store_true", help="print the result as JSON")
    args = parser.parse_args()

    rom_path = args.rom or find_rom()
    rom = rom_path.read_bytes()

    table = read_dispatch(rom)
    groups = group_handlers(table)

    result = {
        "dispatchAddress": DISPATCH_ADDRESS,
        "instructions": len(table),
        "groups": {
            f"${address:04X}": [f"${o:02X}" for o in opcodes]
            for address, opcodes in sorted(groups.items())
        },
    }

    if args.block:
        header = read_header(rom, args.block)
        result["block"] = {
            "name": header.name,
            "raw": header.raw.hex(" "),
            "entry": f"${header.entry:04X}",
            "entryInBlock": f"${header.entry_in_block:04X}",
            "interpreter": f"${header.interpreter:04X}",
            "flags": f"${header.flags:04X}",
            "isScript": header.is_script,
        }

    if args.handler:
        opcode = int(args.handler, 0)
        result["handler"] = {
            "opcode": f"${opcode:02X}",
            "address": f"${table[opcode]:04X}",
            "code": show_handler(rom, opcode),
        }

    if args.json:
        print(json.dumps(result, indent=2))
        return 0

    print(f"the dispatch table is at bank $00, ${DISPATCH_ADDRESS:04X}")
    print(f"the machine has {len(table)} instructions "
          f"({len(groups)} of them share their code)\n")
    for address, opcodes in sorted(groups.items()):
        names = ", ".join(f"${o:02X}" for o in opcodes)
        if len(names) > 70:
            names = f"${opcodes[0]:02X}..${opcodes[-1]:02X} ({len(opcodes)})"
        print(f"  ${address:04X}: {names}")

    if args.block:
        header = read_header(rom, args.block)
        print(f"\nthe header of {header.name}: {header.raw.hex(' ')}")
        print(f"  the program starts ${header.entry_in_block:04X} into the block")
        print(f"  the interpreter is at ${header.interpreter:04X} "
              f"in the work memory")

    if args.handler:
        opcode = int(args.handler, 0)
        print(f"\nthe instruction ${opcode:02X} is handled at "
              f"${table[opcode]:04X}:")
        for line in show_handler(rom, opcode):
            print(line)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
