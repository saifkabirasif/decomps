"""Loading and header analysis for SNES ROM images."""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from pathlib import Path

DEFAULT_ROM_NAME = "Uncharted Waters (USA).sfc"

# Cartridge type codes (SNES internal header).
CART_TYPES = {
    0x00: "ROM only",
    0x01: "ROM + RAM",
    0x02: "ROM + RAM + battery",
    0x03: "ROM + RAM + battery (large)",
    0x04: "ROM + RAM + battery + RTC",
    0x05: "ROM + RAM + battery + rumble",
    0x10: "ROM + RAM + battery + RAM",
    0x13: "ROM + RAM + battery + RTC + RAM",
    0x15: "ROM + RAM + battery + RAM (large)",
    0x16: "ROM + RAM + battery + RTC + RAM (large)",
    0x20: "ROM only (slow)",
    0x22: "ROM + RAM (slow)",
    0x24: "ROM + RAM + battery (slow)",
    0x25: "ROM + RAM + battery + RAM (slow)",
    0x30: "ROM only (fast)",
    0x32: "ROM + RAM (fast)",
    0x34: "ROM + RAM + battery (fast)",
    0x35: "ROM + RAM + battery + RAM (fast)",
    0x43: "SuperFX",
    0x45: "SuperFX + RAM",
    0x4A: "SuperFX + RAM + battery",
    0xE3: "Satellaview",
    0xF3: "Satellaview + RAM + battery",
}

# ROM size codes (SNES internal header).
ROM_SIZES = {
    0x00: "none",
    0x01: "2 KiB",
    0x02: "4 KiB",
    0x03: "8 KiB",
    0x05: "16 KiB",
    0x06: "32 KiB",
    0x07: "64 KiB",
    0x08: "128 KiB",
    0x09: "256 KiB",
    0x0A: "512 KiB",
    0x0B: "1 MiB",
    0x0C: "2 MiB",
    0x0D: "4 MiB",
    0x0E: "8 MiB",
    0x0F: "16 MiB",
    0x10: "32 MiB",
    0x11: "64 MiB",
    0x12: "128 MiB",
}

# Alternative table used by some publishers: sizes expressed in megabits.
ROM_SIZES_MBIT = {
    0x08: "2 Mbit (256 KiB)",
    0x09: "4 Mbit (512 KiB)",
    0x0A: "8 Mbit (1 MiB)",
    0x0B: "16 Mbit (2 MiB)",
    0x0C: "32 Mbit (4 MiB)",
    0x0D: "64 Mbit (8 MiB)",
    0x0E: "128 Mbit (16 MiB)",
}

# SRAM size codes.
SRAM_SIZES = {
    0x00: "none",
    0x01: "2 KiB",
    0x02: "8 KiB",
    0x03: "32 KiB",
    0x04: "128 KiB",
    0x05: "64 KiB",
}

# Country codes.
REGIONS = {
    0x00: "Japan",
    0x01: "USA",
    0x02: "Europe",
    0x03: "Sweden/Scandinavia",
    0x04: "Finland",
    0x05: "Denmark",
    0x06: "France",
    0x07: "Netherlands",
    0x08: "Spain",
    0x09: "Germany",
    0x0A: "Italy",
    0x0B: "China",
    0x0C: "Indonesia",
    0x0D: "Korea",
    0x0E: "Common",
    0x0F: "Canada",
    0x10: "Brazil",
    0x11: "Australia",
}

# Map mode codes.
MAP_MODES = {
    0x20: "LoROM",
    0x21: "HiROM",
    0x23: "LoROM + FastROM",
    0x25: "HiROM + FastROM",
    0x30: "LoROM + SlowROM",
    0x31: "HiROM + SlowROM",
    0x32: "LoROM + FastROM + SlowROM",
    0x33: "HiROM + FastROM + SlowROM",
    0x35: "ExHiROM",
    0x36: "ExHiROM + FastROM",
    0x37: "ExHiROM + SlowROM",
}


def find_rom(start: Path | None = None) -> Path:
    """Locate the original ROM inside the repository's .games folder."""
    here = Path(__file__).resolve()
    roots = [Path.cwd(), *here.parents]
    for root in roots:
        candidate = root / ".games" / DEFAULT_ROM_NAME
        if candidate.exists():
            return candidate
    raise FileNotFoundError(
        f"Could not find {DEFAULT_ROM_NAME!r} in any .games folder. "
        "Copy your own dump there (see .games/README.md)."
    )


def checksum(data: bytes) -> int:
    """The SNES ROM checksum (8 bit, carry compensated)."""
    total = 0
    for byte in data:
        total += byte
        if total > 0xFF:
            total = (total & 0xFF) - 1
    return total & 0xFF


def checksum16(data: bytes) -> int:
    """Alternative 16 bit SNES checksum (high byte counts carry adjustments)."""
    total = 0
    for byte in data:
        total = ((total << 1) & 0xFFFF) | (total >> 15)
        total = (total + byte) & 0xFFFF
    return total


@dataclass
class Header:
    """Parsed SNES internal header (plus the quirks of this particular cart)."""

    offset: int
    title: str = ""
    map_mode: int | None = None
    cart_type: int | None = None
    rom_size: int | None = None
    sram_size: int | None = None
    region: int | None = None
    licensee: int | None = None
    version: int | None = None
    title_len: int = 21
    checksum_complement: int | None = None
    checksum: int | None = None
    vectors: dict[str, int] = field(default_factory=dict)
    raw: bytes = b""

    def describe(self) -> str:
        lines = [f"header at ROM offset ${self.offset:06X}"]
        if self.title:
            lines.append(f"  title         : {self.title!r}")
        if self.map_mode is not None:
            lines.append(
                f"  map mode      : ${self.map_mode:02X}"
                f" ({MAP_MODES.get(self.map_mode, 'unknown')})"
            )
        if self.cart_type is not None:
            lines.append(
                f"  cart type     : ${self.cart_type:02X}"
                f" ({CART_TYPES.get(self.cart_type, 'unknown')})"
            )
        if self.rom_size is not None:
            lines.append(
                f"  rom size      : ${self.rom_size:02X}"
                f" ({ROM_SIZES.get(self.rom_size, 'unknown')})"
            )
        if self.sram_size is not None:
            lines.append(
                f"  sram size     : ${self.sram_size:02X}"
                f" ({SRAM_SIZES.get(self.sram_size, 'unknown')})"
            )
        if self.region is not None:
            lines.append(
                f"  region        : ${self.region:02X}"
                f" ({REGIONS.get(self.region, 'unknown')})"
            )
        if self.licensee is not None:
            lines.append(f"  licensee      : ${self.licensee:02X}")
        if self.version is not None:
            lines.append(f"  version       : ${self.version:02X}")
        if self.checksum is not None:
            lines.append(
                f"  checksum      : ${self.checksum:04X}"
                f" (complement ${self.checksum_complement:04X})"
            )
        for name, addr in self.vectors.items():
            lines.append(f"  vector {name:<13}: ${addr:04X}")
        return "\n".join(lines)


def parse_header(data: bytes, offset: int = 0x7FC0) -> Header:
    """Parse a SNES internal header at `offset`.

    This cart's US publisher wrote a 22 byte title instead of the standard
    21, which pushes every following field one byte to the right and
    overwrites the map mode byte with a space.  The parser therefore detects
    the shift by looking for a plausible map mode code.
    """
    title_len = 21
    if data[offset + 0x15] not in MAP_MODES and data[offset + 0x16] in MAP_MODES:
        title_len = 22

    hdr = Header(offset=offset, raw=bytes(data[offset : offset + 0x40]))
    hdr.title = data[offset : offset + title_len].rstrip(b"\x00 ").decode(
        "latin-1", "replace"
    )
    base = offset + title_len
    hdr.map_mode = data[base + 0x00]
    hdr.cart_type = data[base + 0x01]
    hdr.rom_size = data[base + 0x02]
    hdr.sram_size = data[base + 0x03]
    hdr.region = data[base + 0x04]
    hdr.licensee = data[base + 0x05]
    hdr.version = data[base + 0x06]
    hdr.checksum_complement = int.from_bytes(data[base + 0x07 : base + 0x09], "big")
    hdr.checksum = int.from_bytes(data[base + 0x09 : base + 0x0B], "big")
    hdr.title_len = title_len

    # Native vectors live at $FFE0-$FFEF (COP, BRK, ABORT, NMI, RESET, IRQ);
    # the first four bytes are unused.  Emulation vectors follow at $FFF0.
    native = offset + 0x24
    emulation = offset + 0x34
    for i, name in enumerate(["COP", "BRK", "ABORT", "NMI", "RESET", "IRQ"]):
        hdr.vectors[f"native {name}"] = int.from_bytes(
            data[native + i * 2 : native + i * 2 + 2], "little"
        )
    for i, name in enumerate(["COP", "unused", "ABORT", "NMI", "RESET", "IRQ/BRK"]):
        hdr.vectors[f"emu {name}"] = int.from_bytes(
            data[emulation + i * 2 : emulation + i * 2 + 2], "little"
        )
    return hdr


class Rom:
    """A loaded ROM image."""

    def __init__(self, path: Path | str | None = None) -> None:
        self.path = Path(path) if path else find_rom()
        self.data = self.path.read_bytes()
        self.sha256 = hashlib.sha256(self.data).hexdigest()
        self.size = len(self.data)

    # -- basic access ----------------------------------------------------
    def __len__(self) -> int:
        return self.size

    def byte(self, offset: int) -> int:
        return self.data[offset]

    def slice(self, offset: int, length: int) -> bytes:
        return self.data[offset : offset + length]

    def bank(self, index: int) -> bytes:
        """Return 64 KiB bank `index` (physical ROM offset = index * 0x10000)."""
        start = index * 0x10000
        return self.data[start : start + 0x10000]

    # -- headers ----------------------------------------------------------
    def header(self) -> Header:
        return parse_header(self.data)

    def extended_header(self) -> dict[str, int | None]:
        """Parse the ExHiROM style extended header that sits at $00:FFC0."""
        base = 0xFFC0
        if self.size <= base:
            return {}
        blob = self.data[base : base + 0x40]
        if not blob or blob[0] != 0x16:
            return {}
        return {
            "version": blob[0],
            "maker": int.from_bytes(blob[1:3], "big"),
            "game": int.from_bytes(blob[3:5], "big"),
            "expansion_ram": blob[5],
            "cart_subnumber": int.from_bytes(blob[0x17:0x19], "big"),
            "native_region": int.from_bytes(blob[0x19:0x1B], "big"),
            "checksum": int.from_bytes(blob[0x3C:0x3E], "big"),
            "checksum_complement": int.from_bytes(blob[0x3A:0x3C], "big"),
        }
