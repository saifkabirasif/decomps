"""The regions of the original ROM that have been ported so far.

Offsets are *file* offsets in the 1 MiB LoROM image.  Each entry is
``(start, end, description)`` and the range is half open.
"""

from __future__ import annotations

PORTED_REGIONS: list[tuple[int, int, str]] = [
    (0x000000, 0x0000A0, "bank $00: entry table, native mode entry, boot setup"),
    (0x007FC0, 0x008000, "bank $00: header and vector table"),
]


def regions() -> list[tuple[int, int, str]]:
    """Return the ported regions."""
    return list(PORTED_REGIONS)


def coverage(rom_size: int) -> float:
    """Fraction of the ROM that has been ported."""
    total = sum(end - start for start, end, _ in PORTED_REGIONS)
    return total / rom_size if rom_size else 0.0
