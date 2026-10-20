"""Tests for the ROM diffing tool."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from diff_rom import bank_report, compare


def test_compare_identical():
    data = bytes(range(256))
    matching, compared = compare(data, data)
    assert matching == compared == 256


def test_compare_detects_differences():
    a = b"\x00" * 100
    b = b"\x00" * 99 + b"\x01"
    matching, compared = compare(a, b)
    assert compared == 100
    assert matching == 99


def test_bank_report_covers_every_bank():
    original = bytes(0x10000)
    built = bytearray(0x10000)
    built[0x0100] = 0xFF
    built = bytes(built)
    report = bank_report(built, original)
    assert len(report) == 2
    bank, matching, size, diffs = report[0]
    assert bank == 0
    assert size == 0x8000
    assert matching == 0x8000 - 1
    assert diffs == [0x0100]

    bank, matching, size, diffs = report[1]
    assert bank == 1
    assert matching == 0x8000
    assert diffs == []
