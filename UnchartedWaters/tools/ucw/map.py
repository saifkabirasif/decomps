"""SNES memory map models.

Every mapping converts between a CPU address (``bank:addr``) and a physical
ROM offset.  ``Uncharted Waters`` uses a non standard header, so the mapping
is verified empirically (see docs/memory-map.md) rather than assumed.
"""

from __future__ import annotations

from dataclasses import dataclass  # noqa: F401


@dataclass(frozen=True)
class _Unused:
    """Placeholder kept so the module keeps a dataclass import."""

    value: int = 0


class Mapping:
    """Base class: a mapping is a pure function of the CPU address."""

    name = "base"

    def to_phys(self, bank: int, addr: int) -> int | None:
        raise NotImplementedError

    def from_phys(self, phys: int) -> tuple[int, int] | None:
        raise NotImplementedError

    def visible(self, bank: int, addr: int) -> bool:
        return self.to_phys(bank, addr) is not None


class LoROM(Mapping):
    """32 KiB banks at $8000-$FFFF; $00-$1F are real, $20-$3F mirror them."""

    name = "LoROM"

    def to_phys(self, bank: int, addr: int) -> int | None:
        if bank >= 0x80:
            # FastROM area; only reachable with the fast map mode.
            bank -= 0x80
        if bank >= 0x40:
            return None
        if bank >= 0x20:
            bank -= 0x20
        if addr >= 0x8000:
            return (bank * 0x8000) + (addr - 0x8000)
        # In LoROM the low half of every bank is work RAM, never ROM.
        return None

    def from_phys(self, phys: int) -> tuple[int, int] | None:
        if phys >= 0x200000:
            return None
        bank = phys // 0x8000
        return bank & 0x3F, 0x8000 + (phys % 0x8000)


class HiROM(Mapping):
    """64 KiB banks; $00-$3F, low half of each bank visible at $0000-$7FFF."""

    name = "HiROM"

    def to_phys(self, bank: int, addr: int) -> int | None:
        if bank >= 0x80:
            bank -= 0x80
        if bank >= 0x40:
            return None
        base = bank * 0x10000
        if addr >= 0x8000:
            return base + (addr - 0x8000)
        return base + 0x8000 + addr

    def from_phys(self, phys: int) -> tuple[int, int] | None:
        if phys >= 0x400000:
            return None
        bank = phys // 0x10000
        offset = phys % 0x10000
        if offset >= 0x8000:
            return bank & 0x3F, 0x8000 + (offset - 0x8000)
        return bank & 0x3F, offset


class ExHiROM(Mapping):
    """64 KiB banks for $00-$1F (SPC700 visible), mirrored for $20-$3F."""

    name = "ExHiROM"

    def to_phys(self, bank: int, addr: int) -> int | None:
        if bank >= 0x80:
            bank -= 0x80
        if bank >= 0x40:
            return None
        if bank >= 0x20:
            bank -= 0x20
        base = bank * 0x10000
        if addr >= 0x8000:
            return base + (addr - 0x8000)
        return base + 0x8000 + addr

    def from_phys(self, phys: int) -> tuple[int, int] | None:
        if phys >= 0x200000:
            return None
        bank = phys // 0x10000
        offset = phys % 0x10000
        if offset >= 0x8000:
            return bank & 0x1F, 0x8000 + (offset - 0x8000)
        return bank & 0x1F, offset


MAPPINGS: dict[str, Mapping] = {
    "lorom": LoROM(),
    "hirom": HiROM(),
    "exhirom": ExHiROM(),
}
