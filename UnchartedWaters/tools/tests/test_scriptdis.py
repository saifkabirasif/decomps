"""Tests for the tool that disassembles the program of a script block."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scriptdis import (  # noqa: E402
    ONE_BYTE,
    ONE_OR_TWO,
    TWO_BYTES,
    operand_length,
)
from scriptvm import read_dispatch  # noqa: E402


def _rom():
    from ucw.rom import Rom, find_rom

    path = find_rom()
    return Rom(path) if path.exists() else None


def test_the_helpers_that_step_over_the_operands_are_found():
    rom = _rom()
    if rom is None:
        return

    table = read_dispatch(rom.data)

    # The instructions that read a variable of the block take nothing.
    for opcode in (0x00, 0x04, 0x0B, 0x0C, 0x21, 0x2B):
        assert operand_length(rom, table, opcode) == 0


def test_the_instructions_that_take_an_operand_are_found():
    rom = _rom()
    if rom is None:
        return

    table = read_dispatch(rom.data)

    # $81 reads one byte of the program, $8C reads two.
    assert operand_length(rom, table, 0x81) == 1
    assert operand_length(rom, table, 0x8C) == 2
    # $A0 reads one or two, depending on the byte that follows.
    assert operand_length(rom, table, 0xA0) == -1


def test_the_helpers_are_the_ones_the_machine_uses():
    # The helpers live in the machine, in bank $00.
    for helper in ONE_BYTE + TWO_BYTES + ONE_OR_TWO:
        assert 0xA700 <= helper <= 0xA800
