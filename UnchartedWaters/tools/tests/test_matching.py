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


@pytest.mark.parametrize("region", PORTED_REGIONS, ids=lambda r: r.name)
def test_ported_region_matches(region):
    original = _original()
    if not BUILT.exists():
        pytest.skip("no built ROM (run `make rom` first)")
    built = BUILT.read_bytes()
    assert len(built) == len(original), "the built ROM has the wrong size"

    start = region.file_offset
    mismatches = [
        start + i
        for i in range(region.size)
        if built[start + i] != original[start + i]
    ]
    assert not mismatches, (
        f"{region.describe()}: {len(mismatches)} bytes differ, "
        f"first at file offset ${mismatches[0]:06X}"
    )


def test_regions_do_not_overlap():
    for index, first in enumerate(PORTED_REGIONS):
        for second in PORTED_REGIONS[index + 1 :]:
            assert not (
                first.bank == second.bank
                and first.start < second.end
                and second.start < first.end
            ), f"{first.name} overlaps {second.name}"
