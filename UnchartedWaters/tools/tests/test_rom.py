"""Tests for the ROM header parsing and the memory map models."""

from __future__ import annotations

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from ucw.map import MAPPINGS
from ucw.rom import checksum, checksum16, parse_header

# The cartridge's real header block (ROM offset 0x7FC0), built field by
# field so the layout stays readable.
HEADER_BYTES = (
    b"UNCHARTED WATERS     "  # $FFC0-$FFD4: title, 21 bytes
    + bytes([0x20])  # $FFD5: map mode - LoROM
    + bytes([0x02])  # $FFD6: cart type - ROM + RAM + battery
    + bytes([0x0A])  # $FFD7: ROM size - 8 Mbit
    + bytes([0x03])  # $FFD8: SRAM size - 32 KiB
    + bytes([0x01])  # $FFD9: country - USA
    + bytes([0xC8])  # $FFDA: licensee
    + bytes([0x00])  # $FFDB: version
    + bytes([0xB0, 0x57])  # $FFDC-$FFDD: checksum complement
    + bytes([0x4F, 0xA8])  # $FFDE-$FFFF: checksum
    + bytes(10)  # $FFE0-$FFE9: unused, COP, BRK, ABORT
    + (0x8361).to_bytes(2, "little")  # $FFEA: NMI
    + bytes(2)  # $FFEC: native RESET (unused)
    + (0x9593).to_bytes(2, "little")  # $FFEE: IRQ
    + bytes(12)  # $FFF0-$FFFB: unused, COP, unused, ABORT, NMI
    + (0x800F).to_bytes(2, "little")  # $FFFC: emulation RESET
    + bytes(2)  # $FFFE: emulation IRQ/BRK
)


def test_parse_header_fields():
    hdr = parse_header(HEADER_BYTES, 0)
    assert hdr.title == "UNCHARTED WATERS"
    assert hdr.map_mode == 0x20
    assert hdr.cart_type == 0x02
    assert hdr.rom_size == 0x0A
    assert hdr.sram_size == 0x03
    assert hdr.region == 0x01
    assert hdr.licensee == 0xC8
    assert hdr.checksum == 0x4FA8
    assert hdr.checksum_complement == 0xB057
    assert hdr.checksum ^ hdr.checksum_complement == 0xFFFF


def test_parse_header_vectors():
    hdr = parse_header(HEADER_BYTES, 0)
    assert hdr.vectors["native NMI"] == 0x8361
    assert hdr.vectors["native RESET"] == 0x0000
    assert hdr.vectors["native IRQ"] == 0x9593
    assert hdr.vectors["emu RESET"] == 0x800F


def test_checksums_are_stable():
    assert checksum(b"\x00" * 16) == 0
    assert isinstance(checksum16(b"\x01" * 32), int)


@pytest.mark.parametrize(
    "bank,addr,phys",
    [
        (0x00, 0x8000, 0x000000),
        (0x00, 0xFFFF, 0x007FFF),
        (0x01, 0x8000, 0x008000),
        (0x03, 0x8000, 0x018000),
        (0x0F, 0x8000, 0x078000),
        (0x1F, 0xFFFF, 0x0FFFFF),
    ],
)
def test_lorom_mapping(bank, addr, phys):
    assert MAPPINGS["lorom"].to_phys(bank, addr) == phys


def test_lorom_low_half_is_not_rom():
    """The low half of every LoROM bank is work RAM."""
    assert MAPPINGS["lorom"].to_phys(0x00, 0x0000) is None
    assert MAPPINGS["lorom"].to_phys(0x10, 0x4000) is None


def test_lorom_roundtrip():
    mapping = MAPPINGS["lorom"]
    for bank in range(0x20):
        phys = mapping.to_phys(bank, 0x8000)
        assert phys == bank * 0x8000
        assert mapping.from_phys(phys) == (bank, 0x8000)
