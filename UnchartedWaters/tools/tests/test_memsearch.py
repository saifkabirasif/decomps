"""Tests for the memory search helper."""

from __future__ import annotations

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from asset_table import parse_table  # noqa: E402
from memsearch import _find_in_blocks, _hits_in_memory  # noqa: E402


def test_finds_the_bytes_in_the_memory():
    memory = b"....Navigator: ...."

    hits = _hits_in_memory(memory, b"Navigator", limit=10)

    assert len(hits) == 1
    assert hits[0]["memoryOffset"] == 4


def test_the_search_in_memory_ignores_the_case():
    memory = b"navigator"

    hits = _hits_in_memory(memory, b"NAVIGATOR", limit=10)

    assert len(hits) == 1


def test_the_search_in_memory_finds_nothing():
    assert _hits_in_memory(b"nothing here", b"Navigator", limit=10) == []


def test_the_search_in_memory_honours_the_limit():
    memory = b"aa" * 100

    hits = _hits_in_memory(memory, b"aa", limit=5)

    assert len(hits) == 5


def test_finds_the_bytes_in_the_blocks():
    rom = bytearray(0x20000)
    # The asset table lives at $00:$F800 and points at a block in bank 1.
    table = 0x7800
    rom[table:table + 16] = bytes(
        [
            0x72, 0x6F, 0x6F, 0x74, 0, 0, 0, 0,
            0x01, 0x00, 0x00, 0x80, 0x00, 0x10, 0x00, 0x00,
        ]
    )
    # The block starts at file offset $008000, so put the marker $100 into it.
    rom[0x8100:0x8107] = b"Navigator"

    hits = _find_in_blocks(bytes(rom), b"Navigator")

    assert len(hits) == 1
    assert hits[0]["name"] == "root"
    assert hits[0]["fileOffset"] == 0x8100
    assert hits[0]["assetOffset"] == 0x100


def test_finds_nothing_when_the_bytes_are_not_in_the_cartridge():
    rom = bytearray(0x20000)

    assert _find_in_blocks(bytes(rom), b"Navigator") == []


def test_the_asset_table_of_the_cartridge_can_be_read():
    from ucw.rom import find_rom

    rom = find_rom()
    if not rom.exists():
        pytest.skip("the original cartridge is not here")

    assets = parse_table(rom.read_bytes())

    assert len(assets) == 38
    assert assets[0].name == "root"
