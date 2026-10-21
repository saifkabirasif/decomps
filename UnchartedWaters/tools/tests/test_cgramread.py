"""Tests for the tool that reads the colours of the running game."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from cgramread import CGRAM_ENTRIES, PALETTE_ENTRIES, _decode  # noqa: E402


def test_the_colour_memory_holds_the_right_number_of_colours():
    assert CGRAM_ENTRIES == 256
    assert PALETTE_ENTRIES == 16


def test_a_colour_word_is_split_into_its_parts():
    # The word is 0bbbbggggrrrrrrrr.
    assert _decode(0x7FFF) == (0xF8, 0xF8, 0xF8)
    assert _decode(0x0000) == (0, 0, 0)

    red = _decode(0x001F)
    assert red[0] == 0xF8
    assert red[1] == 0
    assert red[2] == 0

    green = _decode(0x03E0)
    assert green[0] == 0
    assert green[1] == 0xF8
    assert green[2] == 0

    blue = _decode(0x7C00)
    assert blue[0] == 0
    assert blue[1] == 0
    assert blue[2] == 0xF8
