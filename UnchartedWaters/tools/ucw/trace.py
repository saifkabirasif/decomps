"""Recursive descent code tracer for 65816 ROMs.

Starting from a set of entry points the tracer follows calls and branches,
marks every byte it decodes as code and everything it lands on as data.
The result is a reliable map of "where the code lives", which is the first
thing we need for a decompilation.
"""

from __future__ import annotations

from dataclasses import dataclass, field

from .disasm import Insn, decode_65816
from .map import Mapping
from .rom import Rom


@dataclass
class Function:
    """A traced routine."""

    address: int
    insns: list[Insn] = field(default_factory=list)
    calls: set[int] = field(default_factory=set)
    tail_calls: set[int] = field(default_factory=set)

    @property
    def end(self) -> int:
        return self.insns[-1].address + self.insns[-1].size if self.insns else self.address


@dataclass
class TraceResult:
    """Everything the tracer learned about a ROM."""

    code: set[int] = field(default_factory=set)
    data: set[int] = field(default_factory=set)
    functions: dict[int, Function] = field(default_factory=dict)
    unresolved: list[tuple[int, str]] = field(default_factory=list)

    @property
    def matched(self) -> int:
        return len(self.code)


class Tracer:
    """Follows code from entry points using a recursive descent algorithm."""

    def __init__(self, rom: Rom, mapping: Mapping, max_insns: int = 4000) -> None:
        self.rom = rom
        self.mapping = mapping
        self.max_insns = max_insns
        # The accumulator width (the M flag).  The game spends most of its
        # time in 16 bit mode, and immediate operands depend on it.
        self.m16 = True
        self.result = TraceResult()
        self._visited: set[tuple[int, int]] = set()

    # -- helpers -----------------------------------------------------------
    def _read(self, bank: int, addr: int, count: int) -> bytes | None:
        """Read `count` bytes of CPU visible memory."""
        out = bytearray()
        for i in range(count):
            a = (addr + i) & 0xFFFF
            phys = self.mapping.to_phys(bank, a)
            if phys is None or phys >= len(self.rom.data):
                return None
            out.append(self.rom.data[phys])
        return bytes(out)

    def _mark_data(self, bank: int, addr: int, count: int) -> None:
        for i in range(count):
            a = (addr + i) & 0xFFFF
            phys = self.mapping.to_phys(bank, a)
            if phys is not None:
                self.result.data.add(phys)

    # -- tracing -----------------------------------------------------------
    def trace(self, bank: int, addr: int, depth: int = 0) -> Function | None:
        """Trace a routine at bank:addr, returning the function it found."""
        if depth > 64:
            return None
        key = (bank, addr)
        if key in self._visited:
            return self.result.functions.get(addr)
        self._visited.add(key)
        func = Function(address=addr)
        self.result.functions[addr] = func
        cur_bank, cur_addr = bank, addr
        visited_here: set[int] = set()

        while True:
            if cur_addr in visited_here:
                break
            visited_here.add(cur_addr)

            raw = self._read(cur_bank, cur_addr, 4)
            if raw is None:
                self.result.unresolved.append((cur_addr, "unmapped"))
                break
            insn = decode_65816(raw, cur_addr, self.m16)
            if insn.mnemonic == ".byte":
                # Not a valid instruction: we have run into data.
                phys = self.mapping.to_phys(cur_bank, cur_addr)
                if phys is not None:
                    self.result.data.add(phys)
                self.result.unresolved.append((cur_addr, "invalid opcode"))
                break
            if len(func.insns) > self.max_insns:
                self.result.unresolved.append((cur_addr, "function too long"))
                break
            func.insns.append(insn)

            phys = self.mapping.to_phys(cur_bank, cur_addr)
            if phys is not None:
                self.result.code.add(phys)
                for i in range(insn.size):
                    p2 = self.mapping.to_phys(cur_bank, cur_addr + i)
                    if p2 is not None:
                        self.result.code.add(p2)
                        self.result.data.discard(p2)

            mnemonic = insn.mnemonic
            operand = insn.operand

            if mnemonic in ("REP", "SEP"):
                # Bit 5 of the operand selects the M flag (accumulator width).
                flags = raw[1] if len(raw) > 1 else 0
                if flags & 0x20:
                    self.m16 = mnemonic == "SEP"

            if mnemonic in ("JSR", "JSL"):
                if mnemonic == "JSR":
                    target = self._target16(operand)
                    if target is None:
                        break
                    func.calls.add(target)
                    self.trace(cur_bank, target, depth + 1)
                    # return address
                    cur_addr = (cur_addr + insn.size) & 0xFFFF
                    continue
                # JSL: long call, follow into the new bank
                long = self._target24(operand)
                if long is None:
                    break
                target_bank = (long >> 16) & 0xFF
                target_addr = long & 0xFFFF
                func.calls.add(long)
                self.trace(target_bank, target_addr, depth + 1)
                cur_bank, cur_addr = cur_bank, (cur_addr + insn.size) & 0xFFFF
                continue

            if mnemonic in ("JMP", "JML"):
                if mnemonic == "JMP":
                    if operand.startswith("("):
                        # indirect jump: mark the pointer table as data
                        self._mark_indirect(cur_bank, operand, depth)
                        break
                    target = self._target16(operand)
                    if target is None:
                        break
                    func.tail_calls.add(target)
                    self.trace(cur_bank, target, depth + 1)
                    break
                long = self._target24(operand)
                if long is None:
                    break
                target_bank = (long >> 16) & 0xFF
                target_addr = long & 0xFFFF
                func.tail_calls.add(long)
                self.trace(target_bank, target_addr, depth + 1)
                break

            if mnemonic.startswith("B") and mnemonic not in ("BIT", "BRA"):
                # conditional branch: follow the target, continue after it
                target = self._target16(operand)
                if target is None:
                    cur_addr = (cur_addr + insn.size) & 0xFFFF
                    continue
                func.tail_calls.add(target)
                self.trace(cur_bank, target, depth + 1)
                cur_addr = (cur_addr + insn.size) & 0xFFFF
                continue

            if mnemonic in ("RTS", "RTI", "STP", "BRK", "JML", "WAI"):
                break

            cur_addr = (cur_addr + insn.size) & 0xFFFF

        return func

    @staticmethod
    def _target16(operand: str) -> int | None:
        """Parse a 16 bit operand such as ``$1234``."""
        try:
            return int(operand.lstrip("$"), 16)
        except ValueError:
            return None

    @staticmethod
    def _target24(operand: str) -> int | None:
        """Parse a 24 bit operand such as ``$123456``."""
        try:
            return int(operand.lstrip("$"), 16)
        except ValueError:
            return None

    def _mark_indirect(self, bank: int, operand: str, depth: int) -> None:
        """Mark the target of an indirect jump/long jump as a jump table."""
        try:
            if operand.startswith("([$"):
                addr = int(operand[3:7], 16)
            elif operand.startswith("($"):
                addr = int(operand[2:6], 16)
            else:
                return
        except ValueError:
            return
        raw = self._read(bank, addr, 4)
        if raw is None:
            return
        # A long pointer table: bank + 16 bit address
        self._mark_data(bank, addr, 4)
        long = int.from_bytes(raw, "little")
        target_bank = (long >> 16) & 0xFF
        target_addr = long & 0xFFFF
        self.trace(target_bank, target_addr, depth + 1)


def trace_rom(
    rom: Rom,
    mapping: Mapping,
    entries: list[tuple[int, int]],
) -> TraceResult:
    """Trace every entry point and return the combined result."""
    tracer = Tracer(rom, mapping)
    for bank, addr in entries:
        tracer.trace(bank, addr)
    return tracer.result


def render_listing(
    rom: Rom,
    mapping: Mapping,
    result: TraceResult,
    bank: int,
    start: int = 0x8000,
    end: int = 0xFFFF,
) -> str:
    """Render a disassembly listing for one bank range."""
    from .disasm import disassemble_65816

    lines = []
    addr = start
    while addr <= end:
        raw = rom.data
        phys = mapping.to_phys(bank, addr)
        if phys is None or phys >= len(raw):
            addr += 1
            continue
        if phys in result.code:
            chunk = bytes(raw[phys : phys + 8])
            insn = decode_65816(chunk, addr)
            lines.append(f"${addr:04X}: {insn}")
            addr += insn.size
        else:
            lines.append(f"${addr:04X}: {raw[phys]:02X}        .byte ${raw[phys]:02X}")
            addr += 1
    return "\n".join(lines)
