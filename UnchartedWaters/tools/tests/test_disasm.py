"""Tests for the 65816 / SPC700 disassembler."""

from __future__ import annotations

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from ucw.disasm import decode_65816, decode_spc700, disassemble_65816
from ucw.opcodes_65816 import TABLE as OP_65816
from ucw.spc700_table import TABLE as OP_SPC700


def test_all_65816_opcodes_are_known():
    assert len(OP_65816) == 256
    assert set(OP_65816) == set(range(256))


def test_all_spc700_opcodes_are_known():
    assert len(OP_SPC700) == 256
    assert set(OP_SPC700) == set(range(256))


@pytest.mark.parametrize(
    "raw,mnemonic,operand",
    [
        (bytes([0x4C, 0xFD, 0xA0]), "JMP", "$A0FD"),
        (bytes([0x20, 0xBB, 0x88]), "JSR", "$88BB"),
        (bytes([0x8D, 0x09, 0x0E]), "STA", "$0E09"),
        (bytes([0x9C, 0x0C, 0x42]), "STZ", "$420C"),
        (bytes([0xA9, 0x01]), "LDA", "#$01"),
        (bytes([0xEB]), "XBA", ""),
        (bytes([0xDA]), "PHX", ""),
        (bytes([0x5A]), "PHY", ""),
        (bytes([0x5C, 0x9C, 0x80, 0x00]), "JML", "$00809C"),
        (bytes([0xDC, 0x9C, 0x80, 0x00]), "JML", "[$00809C]"),
        (bytes([0x22, 0x00, 0x80, 0x00]), "JSL", "$008000"),
        (bytes([0x18]), "CLC", ""),
        (bytes([0xE8]), "INX", ""),
        (bytes([0xB9, 0x00, 0x21]), "LDA", "$2100,Y"),
        (bytes([0xBD, 0x00, 0x21]), "LDA", "$2100,X"),
        (bytes([0x99, 0x00, 0x21]), "STA", "$2100,Y"),
        (bytes([0x81, 0x00]), "STA", "($00,X)"),
        (bytes([0x91, 0x00]), "STA", "($00),Y"),
        (bytes([0xC2, 0x30]), "REP", "#$30"),
        (bytes([0xE2, 0x20]), "SEP", "#$20"),
    ],
)
def test_decode_65816(raw, mnemonic, operand):
    insn = decode_65816(raw, 0x8000)
    assert insn.mnemonic == mnemonic
    assert insn.operand == operand
    assert insn.size == len(raw)


def test_16_bit_immediate():
    """In 16 bit mode an immediate operand is two bytes wide."""
    insn = decode_65816(bytes([0xA9, 0x34, 0x12]), 0x8000, m16=True)
    assert insn.mnemonic == "LDA"
    assert insn.operand == "#$1234"
    assert insn.size == 3


def test_relative_branch_target():
    # BNE with a negative offset
    insn = decode_65816(bytes([0xD0, 0xFE]), 0x8000)
    assert insn.mnemonic == "BNE"
    assert insn.operand == "$8000"


def test_disassemble_respects_instruction_sizes():
    data = bytes([0x4C, 0xFD, 0xA0, 0x8D, 0x09, 0x0E, 0x60])
    insns = list(disassemble_65816(data, 0x8000, 3))
    assert [i.mnemonic for i in insns] == ["JMP", "STA", "RTS"]
    assert [i.address for i in insns] == [0x8000, 0x8003, 0x8006]


def test_decode_spc700():
    insn = decode_spc700(bytes([0x3F, 0x34, 0x12]), 0x0100)
    assert insn.mnemonic == "call"
    assert insn.operand == "$1234"

    insn = decode_spc700(bytes([0xE4, 0x42]), 0x0100)
    assert insn.mnemonic == "mov"
    assert insn.operand == "a,$42"

    insn = decode_spc700(bytes([0x60]), 0x0100)
    assert insn.mnemonic == "clrc"


def test_spc700_table_is_not_mutated_by_decoding():
    """Decoding must not consume the shared operand offset lists."""
    before = {op: list(args) for op, (_size, _fmt, args) in OP_SPC700.items()}
    for op in range(256):
        size = OP_SPC700[op][0]
        decode_spc700(bytes(size), 0)
    after = {op: list(args) for op, (_size, _fmt, args) in OP_SPC700.items()}
    assert before == after
