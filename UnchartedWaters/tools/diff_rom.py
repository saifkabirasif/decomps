#!/usr/bin/env python3
"""Compare a built ROM against the original cartridge dump.

The decompilation is only meaningful if we can show byte for byte how much
of the original ROM we reproduce.  This tool reports:

  * the overall match percentage
  * a per bank breakdown (LoROM banks are 32 KiB)
  * the first differing addresses of every bank

Usage:
    python3 tools/diff_rom.py --built build/uncharted_waters.sfc \
                              --original "../../.games/Uncharted Waters (USA).sfc"
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.rom import find_rom  # noqa: E402

BANK_SIZE = 0x8000  # LoROM banks are 32 KiB


def compare(built: bytes, original: bytes) -> tuple[int, int]:
    """Return (matching bytes, compared bytes)."""
    length = min(len(built), len(original))
    matching = sum(1 for a, b in zip(built[:length], original[:length]) if a == b)
    return matching, length


def bank_report(built: bytes, original: bytes) -> list[tuple[int, int, int, list[int]]]:
    """Per bank: (bank number, matching bytes, size, first differing offsets)."""
    report = []
    count = max(len(built), len(original)) // BANK_SIZE
    for bank in range(count):
        start = bank * BANK_SIZE
        end = start + BANK_SIZE
        a = built[start:end]
        b = original[start:end]
        matching = sum(1 for x, y in zip(a, b) if x == y)
        diffs = [start + i for i, (x, y) in enumerate(zip(a, b)) if x != y]
        report.append((bank, matching, BANK_SIZE, diffs[:8]))
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--built", type=Path, required=True, help="the ROM we built")
    parser.add_argument("--original", type=Path, default=None, help="the original dump")
    parser.add_argument("--verbose", action="store_true")
    args = parser.parse_args()

    original_path = args.original or find_rom()
    built = args.built.read_bytes()
    original = original_path.read_bytes()

    matching, compared = compare(built, original)
    percent = (matching / compared * 100) if compared else 0.0
    print(f"built   : {args.built} ({len(built)} bytes)")
    print(f"original: {original_path} ({len(original)} bytes)")
    print(f"matching: {matching}/{compared} bytes ({percent:.2f}%)")
    if len(built) != len(original):
        print(f"warning: size mismatch ({len(built)} vs {len(original)})")

    print()
    print("per 32 KiB bank:")
    for bank, match, size, diffs in bank_report(built, original):
        pct = match / size * 100
        flag = "" if pct == 100 else "  <-"
        first = ", ".join(f"${d:06X}" for d in diffs) if diffs else ""
        print(f"  bank ${bank:02X}: {match:5}/{size} ({pct:5.1f}%) {first}{flag}")
    return 0 if percent > 99.9 else 1


if __name__ == "__main__":
    raise SystemExit(main())
