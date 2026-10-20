"""Tests for the asset table of the cartridge."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from asset_table import (  # noqa: E402
    BLOCK_MAGIC,
    RECORD_SIZE,
    TABLE_ADDRESS,
    Asset,
    block_kind,
    parse_table,
)

#: The first three records of the original cartridge, taken from the ROM.
#: The numeric fields are stored little endian.
RECORDS = bytes(
    [
        0x72, 0x6F, 0x6F, 0x74, 0x00, 0x00, 0x00, 0x00,  # "root"
        0x01, 0x00, 0x00, 0x80, 0xAE, 0x75, 0x00, 0x00,
        0x73, 0x67, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00,  # "sgdata"
        0x01, 0x00, 0xAE, 0xF5, 0x88, 0x12, 0x00, 0x00,
        0x66, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00, 0x00,  # "fdata"
        0x02, 0x00, 0x36, 0x88, 0xD8, 0x37, 0x00, 0x00,
    ]
)


def make_rom() -> bytes:
    """Build a small image with the records in the table."""
    offset = TABLE_ADDRESS - 0x8000
    data = bytearray(offset + len(RECORDS))
    data[offset : offset + len(RECORDS)] = RECORDS
    return bytes(data)


def test_parses_the_records():
    assets = parse_table(make_rom())

    assert [a.name for a in assets] == ["root", "sgdata", "fdata"]


def test_reads_the_numeric_fields_little_endian():
    assets = parse_table(make_rom())

    root = assets[0]
    assert root.bank == 1
    assert root.address == 0x8000
    assert root.length == 0x75AE
    assert root.flags == 0


def test_computes_the_file_offset():
    assets = parse_table(make_rom())

    assert assets[0].file_offset == 0x008000
    assert assets[1].file_offset == 0x00F5AE
    assert assets[2].file_offset == 0x010836


def test_stops_at_the_first_empty_record():
    assert parse_table(bytes(0x8000)) == []


def test_every_block_starts_with_the_magic():
    data = bytearray(0x8000)
    data[TABLE_ADDRESS - 0x8000 : TABLE_ADDRESS - 0x8000 + len(RECORDS)] = RECORDS

    # The raw blocks have two zero bytes behind the magic, the script
    # blocks have something else there.
    assert block_kind(bytes(data), 0x008000) == "no header"

    raw = BLOCK_MAGIC + b"\x00\x00" + bytes(8)
    assert block_kind(raw, 0) == "raw data"

    script = BLOCK_MAGIC + b"\xb8\x20" + bytes(8)
    assert block_kind(script, 0) == "encoded script"


def test_describes_a_block():
    asset = Asset("root", 1, 0x8000, 0x75AE, 0)

    assert "root" in asset.describe()
    assert "$008000" in asset.describe()


def test_record_size_is_the_size_of_the_table_entry():
    assert RECORD_SIZE == 16
