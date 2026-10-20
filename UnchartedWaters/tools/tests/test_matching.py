"""Check that the ported regions still match the original ROM byte for byte.

The test needs the original dump and a built ROM; it is skipped when either
is missing so the suite still runs on a machine without the game.
"""

from __future__ import annotations

import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))

from ucw.regions import PORTED_REGIONS  # noqa: E402
from ucw.rom import find_rom  # noqa: E402

BUILT = ROOT / "build" / "uncharted_waters.sfc"


def _original() -> bytes:
    try:
        return find_rom(ROOT).read_bytes()
    except FileNotFoundError:
        pytest.skip("the original ROM is not available")


@pytest.mark.parametrize("start,end,description", PORTED_REGIONS)
def test_ported_region_matches(start, end, description):
    original = _original()
    if not BUILT.exists():
        pytest.skip("no built ROM (run `make rom` first)")
    built = BUILT.read_bytes()
    assert len(built) == len(original), "the built ROM has the wrong size"
    mismatches = [
        start + i
        for i in range(end - start)
        if built[start + i] != original[start + i]
    ]
    assert not mismatches, (
        f"{description}: {len(mismatches)} bytes differ, "
        f"first at ${mismatches[0]:06X}"
    )
