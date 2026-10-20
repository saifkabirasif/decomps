#!/usr/bin/env python3
"""Check that every ported region still matches the original ROM.

The decompilation is only meaningful if the parts that are done stay byte
for byte identical to the cartridge.  This tool compares the built ROM with
the original dump region by region and reports the first byte that differs.

Usage:
    python3 tools/verify.py --built build/uncharted_waters.sfc \
                             --original "../../.games/Uncharted Waters (USA).sfc"
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.regions import PORTED_REGIONS, Region  # noqa: E402
from ucw.rom import find_rom  # noqa: E402


def check_region(region: Region, built: bytes, original: bytes) -> list[int]:
    """Return the file offsets inside `region` that differ."""
    start = region.file_offset
    end = start + region.size
    if end > len(built) or end > len(original):
        return [start]
    return [
        start + i
        for i in range(region.size)
        if built[start + i] != original[start + i]
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--built", type=Path, required=True, help="the ROM we built")
    parser.add_argument("--original", type=Path, default=None, help="the original dump")
    parser.add_argument("--quiet", action="store_true", help="only report failures")
    args = parser.parse_args()

    original_path = args.original or find_rom()
    built = args.built.read_bytes()
    original = original_path.read_bytes()

    if len(built) != len(original):
        print(
            f"error: size mismatch, built {len(built)} bytes, "
            f"original {len(original)} bytes",
            file=sys.stderr,
        )
        return 1

    failures = 0
    total = 0
    for region in PORTED_REGIONS:
        mismatches = check_region(region, built, original)
        total += region.size
        if mismatches:
            failures += 1
            print(
                f"FAIL  {region.describe()}: {len(mismatches)} bytes differ, "
                f"first at file offset ${mismatches[0]:06X} "
                f"(cpu ${region.bank:02X}:"
                f"{mismatches[0] - region.bank * 0x8000 + 0x8000:04X})"
            )
        elif not args.quiet:
            print(f"ok    {region.describe()}")

    print()
    print(
        f"{len(PORTED_REGIONS) - failures}/{len(PORTED_REGIONS)} regions match "
        f"byte for byte ({total} bytes verified)"
    )
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
