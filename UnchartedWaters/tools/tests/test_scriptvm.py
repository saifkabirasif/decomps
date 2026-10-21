"""Tests for the tool that reads the script machine of the cartridge."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scriptvm import (  # noqa: E402
    DISPATCH_ADDRESS,
    OPCODE_COUNT,
    SCRIPT_RAM,
    group_handlers,
    read_dispatch,
    read_handlers,
    read_header,
)


def _rom():
    from ucw.rom import find_rom

    path = find_rom()
    return path.read_bytes() if path.exists() else None


def test_the_dispatch_table_holds_256_addresses():
    rom = _rom()
    if rom is None:
        return

    table = read_dispatch(rom)

    assert len(table) == OPCODE_COUNT
    # every handler lives in the bank where the machine itself lives
    assert all(0x8000 <= address <= 0xFFFF for address in table)


def test_the_instructions_share_their_code_in_groups():
    rom = _rom()
    if rom is None:
        return

    groups = group_handlers(read_dispatch(rom))

    # four groups of instructions share their code
    assert len(groups[0xA2D6]) == 15
    assert len(groups[0xA2E4]) == 15
    assert len(groups[0xA2FA]) == 15
    assert len(groups[0xA2F2]) == 16
    # and the ones that are not used all point at the same place
    assert len(groups[0xA733]) == 38


def test_the_handlers_carry_a_place_in_the_block():
    rom = _rom()
    if rom is None:
        return

    handlers = read_handlers(rom)

    # the first twelve instructions read the variables of the block,
    # from the last one down to the first
    places = [handlers[o] for o in range(12)]
    assert places == list(range(-0x17, 0x00, 2))
    # the instructions that do not fit that shape are the ones that
    # read further along the block
    assert 0x0C not in handlers


def test_the_header_of_a_block_says_where_the_program_starts():
    rom = _rom()
    if rom is None:
        return

    header = read_header(rom, "oukyu")

    assert header.raw[:2] == b"\x4c\x03"
    assert header.is_script
    assert header.interpreter == 0x21BA
    assert header.entry_in_block == 0x00B0

    # the blocks of the same kind start at the same place
    assert read_header(rom, "s_nwaka").entry_in_block == 0x00B8
    assert read_header(rom, "root").entry_in_block == 0x0020


def test_the_blocks_of_raw_data_hold_no_program():
    rom = _rom()
    if rom is None:
        return

    header = read_header(rom, "sgdata")

    assert not header.is_script
    assert header.entry == 0


def test_the_program_starts_a_little_way_into_the_block():
    rom = _rom()
    if rom is None:
        return

    header = read_header(rom, "oukyu")

    assert SCRIPT_RAM == 0x2000
    assert header.entry == SCRIPT_RAM + 0x00B0


def test_the_dispatch_table_sits_where_it_should():
    assert DISPATCH_ADDRESS == 0xA797


def test_the_disassembler_follows_the_width_changes_of_the_code():
    from ucw.disasm import disassemble_65816_tracked

    # SEP #$20 makes the accumulator eight bit again, so the immediate
    # of the LDA that follows is one byte short
    code = bytes([0xE2, 0x20, 0xA9, 0x11, 0xC2, 0x20, 0xA9, 0x22, 0x33])

    sizes = [i.size for i in disassemble_65816_tracked(code, 0, 4)]

    assert sizes == [2, 2, 2, 3]
