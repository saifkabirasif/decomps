"""65816 / SPC700 disassembler used by the Uncharted Waters tooling.

The opcode tables are generated from WLA DX' own instruction table (see
``tools/gen_opcode_tables.py``), so the disassembler always agrees with the
assembler we use to build the ROM.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterator

from .opcodes_65816 import TABLE as _OP_65816
from .spc700_table import TABLE as _OP_SPC700


@dataclass(frozen=True)
class Insn:
    """A single decoded instruction."""

    address: int
    size: int
    raw: bytes
    mnemonic: str
    operand: str

    def __str__(self) -> str:
        raw = " ".join(f"{b:02X}" for b in self.raw)
        text = self.mnemonic
        if self.operand:
            text += " " + self.operand
        return f"{raw:<12} {text}"


def _u8(data: bytes) -> int:
    return data[0] if len(data) > 0 else 0


def _u16(data: bytes) -> int:
    return int.from_bytes(data[0:2], "little") if len(data) > 1 else 0


def _u24(data: bytes) -> int:
    return int.from_bytes(data[0:3], "little") if len(data) > 2 else 0


def _render(mode: str, data: bytes, pc: int, template: str) -> str:
    """Render the operand text for `mode` given the instruction bytes."""
    if mode == "imp":
        return ""
    if mode == "acc":
        return "A"
    if mode == "imm8":
        return f"#${_u8(data):02X}"
    if mode == "imm16":
        return f"#${_u16(data):04X}"
    if mode == "dp":
        return f"${_u8(data):02X}"
    if mode == "dpidx":
        reg = "Y" if ",Y" in template else "X"
        return f"${_u8(data):02X},{reg}"
    if mode == "absidx":
        reg = "Y" if ",Y" in template else "X"
        return f"${_u16(data):04X},{reg}"
    if mode == "ind":
        return f"(${_u8(data):02X})"
    if mode == "indx":
        return f"(${_u8(data):02X},X)"
    if mode == "indy":
        return f"(${_u8(data):02X}),Y"
    if mode == "sry":
        return f"(${_u8(data):02X},S),Y"
    if mode == "sr":
        return f"${_u8(data):02X},S"
    if mode == "indlong":
        # direct page indirect long: dp byte + bank byte
        return f"[${_u16(data):04X}]"
    if mode == "indlongabs":
        # long indirect: a 24 bit pointer
        return f"[${_u24(data):06X}]"
    if mode == "abs":
        return f"${_u16(data):04X}"
    if mode == "long":
        return f"${_u24(data):06X}"
    if mode == "block":
        return f"${_u16(data):04X},${data[2]:02X}"
    if mode == "rel":
        off = _u8(data)
        if off > 127:
            off -= 256
        return f"${(pc + 2 + off) & 0xFFFF:04X}"
    if mode == "rel16":
        off = _u16(data)
        if off > 32767:
            off -= 65536
        return f"${(pc + 3 + off) & 0xFFFF:04X}"
    return ""


def decode_65816(
    data: bytes, pc: int, m16: bool = False, x16: bool = False
) -> Insn:
    """Decode one 65816 instruction at `pc` inside `data`.

    `m16` is the width of the accumulator (the M flag) and `x16` the width of
    the index registers (the X flag).  They decide how wide immediate
    operands are: LDX/LDY follow the index width, everything else follows the
    accumulator width.
    """
    opcode = data[0]
    mnemonic, mode, size, template = _OP_65816[opcode]
    # REP/SEP always take an 8 bit operand, whatever the accumulator width.
    if mode == "imm8" and mnemonic not in ("REP", "SEP", "COP", "WDM"):
        wide = x16 if mnemonic in ("LDX", "LDY") else m16
        if wide:
            mode = "imm16"
            size += 1
    raw = data[:size]
    operand = _render(mode, raw[1:], pc, template)
    # WLA calls the long forms JMP/JSR, the hardware manuals call them
    # JML/JSL - show the hardware names, they are clearer.
    if mnemonic == "JMP" and mode == "long":
        mnemonic = "JML"
    elif mnemonic == "JSR" and mode == "long":
        mnemonic = "JSL"
    elif mnemonic == "JMP" and mode == "indlongabs":
        mnemonic = "JML"
    elif mnemonic == "SWA":
        mnemonic = "XBA"
    elif mnemonic == "TCS":
        mnemonic = "TAS"
    elif mnemonic == "TSC":
        mnemonic = "TSA"
    return Insn(pc, size, raw, mnemonic, operand)


def disassemble_65816(data: bytes, start: int, count: int) -> Iterator[Insn]:
    """Yield up to `count` decoded instructions from `data`."""
    pos = 0
    for _ in range(count):
        if pos >= len(data):
            return
        insn = decode_65816(data[pos:], start + pos)
        yield insn
        pos += insn.size



def decode_spc700(data: bytes, pc: int) -> Insn:
    """Decode one SPC700 instruction at `pc` inside `data`."""
    opcode = data[0]
    size, fmt, args = _OP_SPC700[opcode]
    args = list(args)
    raw = data[:size]

    out = []
    idx = 0
    while idx < len(fmt):
        ch = fmt[idx]
        if ch == "*":
            kind = fmt[idx + 1]
            idx += 2
            off = args.pop(0)
            if kind == "b":
                out.append(f"{raw[off]:02X}")
            elif kind == "w":
                out.append(f"{int.from_bytes(raw[off:off + 2], 'little'):04X}")
            elif kind == "m":
                word = int.from_bytes(raw[off:off + 2], "little")
                out.append(f"{word & 0x1FFF:04X},{word >> 13:02X}")
            elif kind == "r":
                off8 = raw[off]
                if off8 > 127:
                    off8 -= 256
                out.append(f"${(pc + size + off8) & 0xFFFF:04X}")
        else:
            out.append(ch)
            idx += 1
    text = "".join(out)
    parts = text.split(None, 1)
    mnemonic = parts[0]
    operand = parts[1] if len(parts) > 1 else ""
    return Insn(pc, size, raw, mnemonic, operand)


def disassemble_spc700(data: bytes, start: int, count: int) -> Iterator[Insn]:
    """Yield up to `count` decoded SPC700 instructions from `data`."""
    pos = 0
    for _ in range(count):
        if pos >= len(data):
            return
        insn = decode_spc700(data[pos:], start + pos)
        yield insn
        pos += insn.size
