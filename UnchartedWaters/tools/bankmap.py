#!/usr/bin/env python3
"""Make a map of the whole cartridge.

The cartridge is a megabyte of 65816 code, script programs, tile
graphics and tables, and only a part of it is described by the asset
table at the start of the cartridge.  This tool works out what is in
every bank and how much of it is still unknown.

It has two halves:

* the **static** half, which needs no emulator: the named blocks of the
  asset table, the script programs, the code the recursive descent tracer
  can reach from the known entry points, and the bytes that are left
  over.
* the **live** half, which boots the cartridge and watches where the
  program counter goes and what the game copies into the video memory.
  That finds the banks that hold code the tracer cannot reach, and the
  places where the graphics live.

Usage:
    python3 tools/bankmap.py                  # the static map
    python3 tools/bankmap.py --coverage 60    # and watch the game for a minute
    python3 tools/bankmap.py --json
"""

from __future__ import annotations

import argparse
import collections
import json
import os
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from asset_table import parse_table  # noqa: E402
from ucw.map import LoROM  # noqa: E402
from ucw.regions import PORTED_REGIONS  # noqa: E402
from ucw.rom import Rom, parse_header  # noqa: E402
from ucw.trace import trace_rom  # noqa: E402

#: The mark every script program starts with.
SCRIPT_MAGIC = b"\x4c\x03"

#: The keys that are pressed to get the game going.
KEYS = ("Enter", "X", "Z")

#: The size of one tile of graphics in the video memory.
TILE_SIZE = 32


def _bank_of(physical: int) -> int:
    return physical // 0x8000


def entry_points(rom: Rom) -> list[tuple[int, int]]:
    """The places the tracer starts from."""
    header = parse_header(rom.data)
    entries = [
        (0, address)
        for address in header.vectors.values()
        if 0x8000 <= address <= 0xFFFF
    ]
    entries += [(region.bank, region.start) for region in PORTED_REGIONS]
    entries.append((0, 0x8000))
    return sorted(set(entries))


def script_marks(rom: Rom) -> dict[int, list[int]]:
    """The places a script program starts, per bank.

    A real program starts with the mark and has the address of the
    machine in the two bytes behind it; a chance pair of bytes does not.
    """
    data = rom.data
    found: dict[int, list[int]] = collections.defaultdict(list)
    at = data.find(SCRIPT_MAGIC)
    while at >= 0:
        if data[at + 4 : at + 6] == b"\xba\x21":
            found[_bank_of(at)].append(at)
        at = data.find(SCRIPT_MAGIC, at + 1)
    return found


def named_blocks(rom: Rom) -> dict[int, list[dict]]:
    """The blocks of the asset table, per bank."""
    blocks: dict[int, list[dict]] = collections.defaultdict(list)
    for asset in parse_table(rom.data):
        blocks[asset.bank].append(
            {
                "name": asset.name,
                "address": f"${asset.address:04X}",
                "length": asset.length,
                "fileOffset": asset.file_offset,
            }
        )
    return blocks


#: A gap has to hold at least this many instructions before the tracer
#: is believed to have found code and not data.
MIN_INSTRUCTIONS = 8

#: Only the bank with the engine in it holds code; the tracer is not
#: allowed to look for code in the others, or it finds it in the script
#: programs and in the tables.
CODE_BANK = 0

#: The banks that hold code, as the running game showed.
CODE_BANKS = {0}


def traced_code(
    rom: Rom, observed: set[tuple[int, int]] | None = None
) -> tuple[set[int], list[tuple[int, str]], int]:
    """The code the tracer reaches, and the targets it could not follow.

    The tracer can only follow what it can see, so the places where the
    running game was seen are used as starting points as well.  What it
    does not reach is tried once more from the ends of the stretches that
    are still unknown; the code often continues just after the part that
    is known.

    Only a stretch that decodes into a real run of instructions is
    believed: data decodes into instructions as well, and the game is
    full of data.
    """
    entries = list(entry_points(rom))
    if observed:
        entries += sorted(observed)
    entries = sorted(set(entries))

    code: set[int] = set()
    unresolved: list[tuple[int, str]] = []
    rounds = 0
    while True:
        result = trace_rom(rom, LoROM(), entries, long_call_banks=CODE_BANKS)
        rounds += 1
        grew = len(result.code) > len(code)
        code = result.code
        unresolved = result.unresolved
        if not grew or rounds > 12:
            break

        fresh = []
        for start, end in unknown_runs(code, CODE_BANK):
            for at in (start, end - 2):
                if at in code:
                    continue
                probe = trace_rom(rom, LoROM(), [(CODE_BANK, 0x8000 + at)],
                                 long_call_banks=CODE_BANKS)
                found = probe.functions.get(0x8000 + at)
                if found is None or len(found.insns) < MIN_INSTRUCTIONS:
                    continue
                fresh.append((CODE_BANK, 0x8000 + at))
        if not fresh:
            break
        entries = sorted(set(entries) | set(fresh))

    return code, unresolved, rounds


def unknown_runs(known: set[int], bank: int) -> list[tuple[int, int]]:
    """The stretches of a bank that nothing is known about.

    The stretches are given as offsets in the file of the cartridge.
    """
    base = bank * 0x8000
    runs = []
    start = None
    for offset in range(0x8000):
        if base + offset in known:
            if start is not None:
                runs.append((base + start, base + offset))
                start = None
        elif start is None:
            start = offset
    if start is not None:
        runs.append((base + start, base + 0x8000))
    return runs


def _load_mesen():
    """Import the Mesen harness, with the library path set up."""
    home = Path.home() / ".config" / "Mesen2"
    os.environ.setdefault("LD_LIBRARY_PATH", str(home))
    from ucw.mesen import (  # noqa: E402
        MEMORY_TYPE_SNES_VIDEO_RAM,
        MEMORY_TYPE_SNES_WORK_RAM,
        Mesen,
    )

    return Mesen, MEMORY_TYPE_SNES_VIDEO_RAM, MEMORY_TYPE_SNES_WORK_RAM


def sweep(seconds: float, keys: tuple[str, ...], rom_path: Path) -> dict:
    """Watch the game and report where the code and the graphics are.

    The program counter is sampled over and over, which shows which
    banks ever hold code.  The video memory is looked at as well: what
    the game copies into it is a copy of the cartridge, so a piece of
    the video memory can be looked for in the cartridge.

    The keys are pressed on and on while the game runs, so that the
    scenes that are only reached by playing are looked at as well.
    """
    Mesen, video_type, work_type = _load_mesen()
    rom = rom_path.read_bytes()

    mesen = Mesen()
    mesen.init()
    if not mesen.load_rom(rom_path):
        raise RuntimeError("the emulator refused to load the cartridge")
    time.sleep(1.5)
    mesen.init_debugger()

    executed: collections.Counter[int] = collections.Counter()
    pictures: list[bytes] = []
    deadline = time.time() + seconds
    next_key = time.time() + 2.0
    key_at = 0
    while time.time() < deadline:
        try:
            executed[mesen.program_counter()] += 1
        except Exception:
            break
        if time.time() >= next_key and keys:
            try:
                mesen.tap(keys[key_at % len(keys)], 3)
            except Exception:
                pass
            key_at += 1
            next_key = time.time() + 2.0
            pictures.append(mesen.read_memory(video_type, 0, 0x10000))

    vram = mesen.read_memory(video_type, 0, 0x10000)
    mesen.release()

    # Which places of the cartridge were copied into the video memory?
    # The tiles of the cartridge are indexed once, so that every tile of
    # every picture can be looked up without searching the whole file
    # again and again.
    index: dict[bytes, list[int]] = collections.defaultdict(list)
    for at in range(0, len(rom) - TILE_SIZE, TILE_SIZE):
        index[rom[at : at + TILE_SIZE]].append(at)

    graphics = []
    for picture in pictures + [vram]:
        for at in range(0, len(picture) - TILE_SIZE, TILE_SIZE):
            piece = picture[at : at + TILE_SIZE]
            if len(set(piece)) < 4:
                continue
            graphics.extend(index.get(piece, ()))

    # Merge the pieces that sit next to each other.
    regions = []
    for where in sorted(set(graphics)):
        if regions and where <= regions[-1][1] + TILE_SIZE:
            regions[-1][1] = max(regions[-1][1], where + TILE_SIZE)
        else:
            regions.append([where, where + TILE_SIZE])

    per_bank: dict[int, dict] = {}
    for pc, count in executed.items():
        bank = pc >> 16
        entry = per_bank.setdefault(bank, {"samples": 0, "addresses": set()})
        entry["samples"] += count
        entry["addresses"].add(pc & 0xFFFF)

    return {
        "executed": {
            f"${bank:02X}": {
                "samples": entry["samples"],
                "addresses": sorted(entry["addresses"]),
            }
            for bank, entry in sorted(per_bank.items())
        },
        "graphics": [
            {"fileOffset": start, "length": end - start}
            for start, end in regions
        ],
    }


#: Where the places the game was seen are kept between the runs.
COVERAGE_FILE = Path("build/coverage.json")


def observed_addresses() -> set[tuple[int, int]]:
    """The places the running game was seen at, from an earlier run."""
    path = Path(__file__).resolve().parents[1] / COVERAGE_FILE
    if not path.exists():
        return set()
    try:
        data = json.loads(path.read_text())
    except (OSError, ValueError):
        return set()
    seen = set()
    for bank, info in data.get("executed", {}).items():
        number = int(bank.lstrip("$"), 16)
        for address in info.get("addresses", []):
            seen.add((number, address))
    return seen


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--coverage", type=float, default=0.0,
                        help="watch the game for this many seconds")
    parser.add_argument("--keys", default=",".join(KEYS),
                        help="the keys to press before watching")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    rom_path = args.rom
    if rom_path is None:
        from ucw.rom import find_rom  # noqa: E402

        rom_path = find_rom()

    rom = Rom(rom_path)
    code, unresolved, rounds = traced_code(rom, observed_addresses())
    blocks = named_blocks(rom)
    marks = script_marks(rom)

    banks = []
    for bank in range(len(rom.data) // 0x8000):
        known = {p for p in code if _bank_of(p) == bank}
        runs = unknown_runs(known, bank)
        biggest = max((end - start for start, end in runs), default=0)
        banks.append(
            {
                "bank": bank,
                "code": len(known),
                "blocks": blocks.get(bank, []),
                "scripts": marks.get(bank, []),
                "unknownBytes": 0x8000 - len(known),
                "biggestUnknown": biggest,
            }
        )

    result = {
        "size": len(rom.data),
        "banks": banks,
        "unresolved": [{"address": f"${a:04X}", "why": why} for a, why in unresolved],
        "namedBytes": sum(
            block["length"] for bank in banks for block in bank["blocks"]
        ),
    }

    if args.coverage > 0:
        keys = tuple(k for k in args.keys.split(",") if k)
        result["coverage"] = sweep(args.coverage, keys, rom_path)
        # Keep the places the game was seen, so that the next run of the
        # map can start the tracer there.
        cache = Path(__file__).resolve().parents[1] / COVERAGE_FILE
        cache.parent.mkdir(parents=True, exist_ok=True)
        cache.write_text(json.dumps(result["coverage"], indent=1))
        print(f"\nthe places the game was seen are kept in {cache}")

    if args.json:
        print(json.dumps(result, indent=2, default=str))
        return 0

    total = len(rom.data)
    print(f"the cartridge is {total} bytes ({total // 1024} KiB, "
          f"{len(rom.data) // 0x8000} banks)")
    print(f"the asset table names {len(parse_table(rom.data))} blocks holding "
          f"{result['namedBytes']} bytes "
          f"({result['namedBytes'] * 100 // total}%)")
    print(f"the tracer reaches {len(code)} bytes of code "
          f"(after {rounds} rounds of filling the gaps)\n")

    print(f"{'bk':>3} {'code':>6} {'unknown':>8} {'biggest':>8}  what is in it")
    for bank in banks:
        names = ", ".join(b["name"] for b in bank["blocks"])
        if not names and bank["scripts"]:
            names = f"{len(bank['scripts'])} script programs"
        print(f" {bank['bank']:02X} {bank['code']:6d} {bank['unknownBytes']:8d} "
              f"{bank['biggestUnknown']:8d}  {names}")

    if unresolved:
        print("\nthe tracer could not follow these targets:")
        for address, why in unresolved:
            print(f"  ${address:04X}: {why}")

    coverage = result.get("coverage")
    if coverage:
        print("\nthe banks the game ran code in:")
        for bank, info in coverage["executed"].items():
            print(f"  {bank}: {len(info['addresses']):5d} addresses, "
                  f"{info['samples']} samples")
        print("\nthe places of the cartridge that were copied into the "
              "video memory:")
        for region in coverage["graphics"]:
            print(f"  file 0x{region['fileOffset']:06X} "
                  f"({region['length']} bytes, bank {region['fileOffset'] // 0x8000:02X})")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
