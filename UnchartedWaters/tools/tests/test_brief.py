"""Tests for the state brief that starts a session."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import brief  # noqa: E402


def test_reads_the_next_items():
    text = (
        "# State\n"
        "## Next\n"
        "1. Decode the script.\n"
        "- Add the pictures.\n"
        "\n"
        "## Open questions\n"
        "- Where?\n"
    )

    assert brief.next_items(text) == [
        "Decode the script.",
        "Add the pictures.",
    ]


def test_joins_a_wrapped_item():
    text = (
        "## Next\n"
        "1. Decode the script.\n"
        "   It is the keystone.\n"
        "2. Add pictures.\n"
    )

    assert brief.next_items(text) == [
        "Decode the script. It is the keystone.",
        "Add pictures.",
    ]


def test_without_a_next_section():
    assert brief.next_items("# State\n## Done\n- x\n") == []


def test_stops_at_the_next_heading():
    assert brief.next_items("## Next\n- one\n## Done\n- two\n") == ["one"]


def test_sizes_are_easy_to_read():
    assert brief.human_bytes(512) == "512 bytes"
    assert brief.human_bytes(2048) == "2 KiB"
    assert brief.human_bytes(1048576) == "1.0 MiB"


def test_the_state_sheet_has_next_work():
    text = (brief.PROJECT / "docs" / "STATE.md").read_text()

    assert brief.next_items(text)
