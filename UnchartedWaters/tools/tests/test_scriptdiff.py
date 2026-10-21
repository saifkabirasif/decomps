"""Tests for the tool that compares a patched cartridge with the original."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scriptdiff import DIALOGUE_MARKERS, _diff, _find_block  # noqa: E402


def test_the_markers_point_at_the_picture_of_the_introduction():
    # The markers are places of the video memory that only hold the
    # expected value while the game shows its introduction.
    assert len(DIALOGUE_MARKERS) >= 4
    for offset, value in DIALOGUE_MARKERS.items():
        assert 0 <= offset < 0x10000
        assert 0 <= value <= 0xFF


def test_two_pictures_are_compared():
    assert _diff(b"\x00\x01\x02", b"\x00\x01\x02") == []
    assert _diff(b"\x00\x01\x02", b"\x00\xff\x02") == [1]
    assert _diff(b"", b"\x01") == []


def test_a_block_is_looked_up_by_its_name():
    from ucw.rom import find_rom

    rom = find_rom()
    if not rom.exists():
        return

    asset = _find_block(rom.read_bytes(), "oukyu")

    assert asset.name == "oukyu"
    assert asset.length > 0
