"""The regions of the original ROM that have been ported so far.

Every entry describes a contiguous run of bytes that the decompilation
reproduces byte for byte.  The regions are used by ``tools/verify.py`` and
``tools/tests/test_matching.py`` to prove that a change to the assembly did
not break the parts that are already done.
"""

from __future__ import annotations

from dataclasses import dataclass

#: Size of one LoROM bank in bytes.
BANK_SIZE = 0x8000


@dataclass(frozen=True)
class Region:
    """A ported run of code or data.

    ``bank`` and the address range are CPU addresses: bank 0, $8430 is the
    byte at file offset $0430 of the ROM image.
    """

    bank: int
    start: int
    end: int
    name: str
    source: str = ""

    @property
    def size(self) -> int:
        return self.end - self.start

    @property
    def file_offset(self) -> int:
        """Offset of the region inside the ROM image."""
        return self.bank * BANK_SIZE + (self.start - BANK_SIZE)

    def describe(self) -> str:
        return (
            f"bank ${self.bank:02X} ${self.start:04X}-${self.end:04X} "
            f"({self.size} bytes, {self.source or 'unassigned'})"
        )


PORTED_REGIONS: list[Region] = [
    Region(0x00, 0x8000, 0x80A0, "boot sequence", "src/boot.s"),
    Region(0x00, 0x80A0, 0x8190, "PPU setup", "src/ppu.s"),
    Region(0x00, 0x8190, 0x82B3, "global variable initialisation", "src/init.s"),
    Region(0x00, 0x82B3, 0x8361, "DMA setup routines", "src/dma.s"),
    Region(0x00, 0x8361, 0x8430, "NMI handler", "src/vblank.s"),
    Region(0x00, 0x8430, 0x8512, "sprite, palette and tile uploads", "src/sprites.s"),
    Region(0x00, 0x8512, 0x8636, "VRAM/CGRAM/OAM transfer engine", "src/transfer.s"),
    Region(0x00, 0x8636, 0x8829, "graphics mode updates", "src/graphics.s"),
    Region(0x00, 0x8829, 0x8870, "character flash effect", "src/flash.s"),
    Region(0x00, 0x8870, 0x8B20, "the four graphic groups", "src/graphics_groups.s"),
    Region(0x00, 0x8B20, 0x8C05, "window masks and background scrolling", "src/window.s"),
    Region(0x00, 0x8C05, 0x8CD2, "HDMA and window positions", "src/hdma.s"),
    Region(0x00, 0x8CD2, 0x8D4C, "screen mode, arithmetic and OAM upload", "src/system.s"),
    Region(0x00, 0xFFC0, 0x10000, "header and vector table", "asm/main.s"),
]


def regions() -> list[Region]:
    """Return the ported regions."""
    return list(PORTED_REGIONS)


def coverage(rom_size: int) -> float:
    """Fraction of the ROM that has been ported."""
    total = sum(region.size for region in PORTED_REGIONS)
    return total / rom_size if rom_size else 0.0


def overlaps(a: Region, b: Region) -> bool:
    """True when two regions cover the same bytes."""
    return (
        a.bank == b.bank and a.start < b.end and b.start < a.end
    )
