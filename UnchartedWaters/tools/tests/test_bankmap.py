"""Tests for the tool that maps the cartridge."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from bankmap import (  # noqa: E402
    SCRIPT_MAGIC,
    _bank_of,
    named_blocks,
    script_marks,
    unknown_runs,
)


def _rom():
    from ucw.rom import Rom, find_rom

    path = find_rom()
    return Rom(path) if path.exists() else None


def test_every_script_program_is_named():
    rom = _rom()
    if rom is None:
        return

    named = set()
    for block in named_blocks(rom).values():
        for entry in block:
            named.update(
                range(entry["fileOffset"], entry["fileOffset"] + entry["length"])
            )

    # Every real program starts with the mark and has the address of the
    # machine behind it; a chance pair of bytes does not.
    for marks in script_marks(rom).values():
        for at in marks:
            assert at in named, f"a script program at {at:06X} is not named"
            assert rom.data[at : at + 2] == SCRIPT_MAGIC


def test_the_script_marks_have_the_machine_behind_them():
    rom = _rom()
    if rom is None:
        return

    for marks in script_marks(rom).values():
        for at in marks:
            assert rom.data[at + 4 : at + 6] == b"\xba\x21"


def test_the_named_blocks_are_in_the_banks_they_say():
    rom = _rom()
    if rom is None:
        return

    for bank, blocks in named_blocks(rom).items():
        for block in blocks:
            assert _bank_of(block["fileOffset"]) == bank
            assert block["length"] > 0


def test_the_unknown_runs_are_the_bytes_that_are_left():
    # The code of bank $00 starts at the very beginning of the file.
    known = {0x0000, 0x0001, 0x0004}
    runs = unknown_runs(known, 0)

    assert (0x0002, 0x0004) in runs
    assert (0x0005, 0x8000) in runs
    assert all(start < end for start, end in runs)
