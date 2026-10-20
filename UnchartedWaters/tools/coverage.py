#!/usr/bin/env python3
"""Sample the emulator's program counter to find the hot code of the game.

The recursive descent tracer can only find code that is reachable through
calls it can follow.  Running the game and watching where the CPU actually
behaves tells us which other banks hold code, and gives us a set of entry
points to feed back into the tracer.

Usage:
    python3 tools/coverage.py [--rom PATH] [--seconds 5] [--interval 0.005]
"""

from __future__ import annotations

import argparse
import collections
import os
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.mesen import Mesen  # noqa: E402
from ucw.rom import find_rom  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--seconds", type=float, default=6.0)
    parser.add_argument("--interval", type=float, default=0.004)
    parser.add_argument("--top", type=int, default=40)
    args = parser.parse_args()

    os.environ.setdefault(
        "LD_LIBRARY_PATH", str(Path.home() / ".config" / "Mesen2")
    )
    rom = args.rom or find_rom()

    mesen = Mesen()
    mesen.init()
    if not mesen.load_rom(rom):
        print("error: the emulator refused to load the ROM", file=sys.stderr)
        return 1
    time.sleep(2.0)
    mesen.init_debugger()

    samples: collections.Counter[int] = collections.Counter()
    deadline = time.time() + args.seconds
    while time.time() < deadline:
        try:
            samples[mesen.program_counter()] += 1
        except Exception:
            break
        time.sleep(args.interval)

    total = sum(samples.values())
    print(f"collected {total} samples over {args.seconds:.0f}s")
    print(f"distinct addresses: {len(samples)}")
    print()
    print("hottest addresses:")
    for pc, count in samples.most_common(args.top):
        bank = pc >> 16
        print(f"  bank ${bank:02X}:{pc & 0xFFFF:04X}  {count:6} samples")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
