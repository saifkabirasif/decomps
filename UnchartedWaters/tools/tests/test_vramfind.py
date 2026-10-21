"""Tests for the tool that finds the graphics in the video memory."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from vramfind import _where_in_blocks  # noqa: E402


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
    rom[0x8100:0x8110] = b"0123456789abcdef"

    hits = _where_in_blocks(bytes(rom), b"0123456789abcdef")

    assert len(hits) == 1
    assert hits[0]["name"] == "root"
    assert hits[0]["fileOffset"] == 0x8100
    assert hits[0]["assetOffset"] == 0x100


def test_finds_nothing_when_the_bytes_are_not_in_the_cartridge():
    rom = bytearray(0x20000)

    assert _where_in_blocks(bytes(rom), b"0123456789abcdef") == []
