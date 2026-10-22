"""Tests for the palettes of the cartridge."""

from __future__ import annotations

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import palettes  # noqa: E402
from ucw.rom import find_rom  # noqa: E402

#: Where the biggest table of palettes begins in the original cartridge.
KNOWN_TABLE = 0x012526


def make_table(count: int = 8, fill: int = 0x1234) -> bytes:
    """Build a run of palettes: colour zero is transparent."""
    data = bytearray()
    for _ in range(count):
        words = [0] + [fill] * (palettes.COLOURS - 1)
        for word in words:
            data += word.to_bytes(2, "little")
    return bytes(data)


def make_rom(blob: bytes, at: int = 0x1000) -> bytes:
    data = bytearray(0x8000)
    data[at : at + len(blob)] = blob
    return bytes(data)


def test_a_palette_round_trips_through_the_colour_parts():
    for red, green, blue in ((0, 0, 0), (255, 255, 255), (152, 80, 32)):
        word = palettes.encode(red, green, blue)
        assert palettes.decode(word) == (red & 0xF8, green & 0xF8, blue & 0xF8)


def test_a_run_of_palettes_is_found():
    table = make_table()
    tables = palettes.find_tables(make_rom(table))

    assert len(tables) == 1
    found = tables[0]
    assert found.start == 0x1000
    assert len(found.palettes) == 8
    assert all(palette.used for palette in found.palettes)


def test_a_short_run_is_not_a_table():
    assert palettes.find_tables(make_rom(make_table(count=4))) == []


def test_an_all_zero_run_is_not_a_table():
    # Padding of a cartridge passes the test of one palette, but a table
    # has to hold used palettes as well.
    assert palettes.find_tables(make_rom(bytes(32 * 16))) == []


def test_a_palette_can_be_written_back():
    data = bytearray(make_rom(make_table()))
    palette = palettes.find_tables(bytes(data))[0].palettes[2]
    colours = tuple(palettes.encode(red, 0, 0) for red in range(0, 256, 16))

    palettes.write(data, palette.offset, colours)

    written = palettes.find_tables(bytes(data))[0].palettes[2]
    assert written.colours == colours


def test_writing_a_bad_palette_is_refused():
    data = bytearray(make_rom(make_table()))
    with pytest.raises(ValueError):
        palettes.write(data, 0x1000, (0,) * 15)
    with pytest.raises(ValueError):
        palettes.write(data, 0x1000, (0x8000,) + (0,) * 15)


def test_the_original_cartridge_has_its_known_table():
    try:
        data = find_rom().read_bytes()
    except FileNotFoundError:
        pytest.skip("the original cartridge is not in .games")

    tables = palettes.find_tables(data)

    assert tables, "no palette table was found"
    assert tables[0].start == KNOWN_TABLE
    assert len(tables[0].palettes) >= 60
    # The first palette is the one the introduction shows.
    assert tables[0].palettes[0].colours[:4] == (0x0000, 0x1153, 0x3279, 0x7FFF)
