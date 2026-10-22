#!/usr/bin/env python3
"""Find, read and write the palettes of the cartridge.

The game does not keep its palettes in the colour memory of the SNES as
a copy of the cartridge: it loads them from the cartridge with the
routine at $B77C, which copies the colours into the work RAM at $0CC8,
and the routine at $8A81 writes them into the colour memory.

The palettes themselves are plain data in the cartridge.  A palette is
sixteen 15 bit colours stored little endian, so 32 bytes.  They are kept
one after the other, and an unused palette is sixteen zero words.

The largest such table begins at bank $02:$A526 (file offset $012526).
It holds 63 palettes.  Smaller tables elsewhere in the cartridge hold the
palettes of the battles, the portraits and the ending.

Usage:
    python3 tools/palettes.py
    python3 tools/palettes.py --json
    python3 tools/palettes.py --table 0 --palette 3
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.rom import find_rom  # noqa: E402

#: Number of colours in a palette.
COLOURS = 16

#: Size of a palette in bytes.
SIZE = COLOURS * 2

#: A table has to hold at least this many palettes to be believed.
MIN_ROWS = 8

#: A table has to hold at least this many used palettes to be believed.
MIN_USED = 4


@dataclass(frozen=True)
class Palette:
    """One palette of the cartridge."""

    index: int
    offset: int
    colours: tuple[int, ...]

    @property
    def used(self) -> bool:
        """Is the palette used, or is it a hole in the table?"""
        return any(self.colours)

    def describe(self) -> str:
        return (
            f"palette {self.index:2d} at ${self.offset:06X} "
            f"({'used' if self.used else 'unused'})"
        )


@dataclass(frozen=True)
class Table:
    """A run of palettes in the cartridge."""

    start: int
    end: int
    palettes: tuple[Palette, ...]

    @property
    def used(self) -> int:
        return sum(1 for p in self.palettes if p.used)

    def describe(self) -> str:
        return (
            f"file ${self.start:06X}..${self.end:06X} "
            f"({len(self.palettes)} palettes, {self.used} used, "
            f"bank ${self.start // 0x8000:02X}:${0x8000 + self.start % 0x8000:04X})"
        )


def _words(data: bytes, offset: int) -> tuple[int, ...]:
    return tuple(
        data[offset + i] | (data[offset + i + 1] << 8)
        for i in range(0, SIZE, 2)
    )


def _palette_like(data: bytes, offset: int) -> bool:
    """Could the bytes at this offset be a palette?

    The first colour of a palette is transparent, so its word is zero,
    and every colour is fifteen bits wide, so no word has the top bit
    set.  A run of these is not something ordinary data does by chance,
    and an unused palette is all zeros and passes as well.
    """
    if offset < 0 or offset + SIZE > len(data):
        return False
    words = _words(data, offset)
    return words[0] == 0 and all(word <= 0x7FFF for word in words)


def find_tables(data: bytes) -> list[Table]:
    """Find the palettes of the cartridge, longest table first.

    An unused palette is all zeros and looks like the padding that fills
    the rest of a cartridge, so the empty rows at the two ends of a run
    are trimmed before the run is judged.  A table may still hold empty
    rows in its middle: the game keeps holes where a scene needs none.
    """
    tables: list[Table] = []
    offset = 0
    while offset + SIZE <= len(data):
        if not _palette_like(data, offset):
            offset += 2
            continue
        start = offset
        while offset + SIZE <= len(data) and _palette_like(data, offset):
            offset += SIZE
        end = offset

        # Trim the empty rows at the two ends of the run.
        while start < end and not any(_words(data, start)):
            start += SIZE
        while end > start and not any(_words(data, end - SIZE)):
            end -= SIZE

        count = (end - start) // SIZE
        used = sum(1 for i in range(count) if any(_words(data, start + i * SIZE)))
        if count >= MIN_ROWS and used >= MIN_USED:
            palettes = tuple(
                Palette(i, start + i * SIZE, _words(data, start + i * SIZE))
                for i in range(count)
            )
            tables.append(Table(start, end, palettes))
    tables.sort(key=lambda table: len(table.palettes), reverse=True)
    return tables


def decode(word: int) -> tuple[int, int, int]:
    """Turn a 15 bit colour into red, green and blue."""
    return (
        (word & 0x1F) << 3,
        ((word >> 5) & 0x1F) << 3,
        ((word >> 10) & 0x1F) << 3,
    )


def encode(red: int, green: int, blue: int) -> int:
    """Turn red, green and blue into a 15 bit colour."""
    return (red >> 3) | ((green >> 3) << 5) | ((blue >> 3) << 10)


def write(data: bytearray, offset: int, colours: tuple[int, ...]) -> None:
    """Write a palette back into the cartridge."""
    if len(colours) != COLOURS:
        raise ValueError(f"a palette holds {COLOURS} colours")
    for i, word in enumerate(colours):
        if not 0 <= word <= 0x7FFF:
            raise ValueError(f"colour {i} is not a 15 bit colour")
        data[offset + i * 2] = word & 0xFF
        data[offset + i * 2 + 1] = word >> 8


def _as_json(tables: list[Table]) -> str:
    return json.dumps(
        [
            {
                "start": table.start,
                "end": table.end,
                "bank": table.start // 0x8000,
                "address": 0x8000 + table.start % 0x8000,
                "palettes": [
                    {
                        "index": palette.index,
                        "offset": palette.offset,
                        "used": palette.used,
                        "colours": list(palette.colours),
                        "rgb": [list(decode(word)) for word in palette.colours],
                    }
                    for palette in table.palettes
                ],
            }
            for table in tables
        ],
        indent=2,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--json", action="store_true", help="print JSON")
    parser.add_argument("--table", type=int, default=0, help="which table")
    parser.add_argument("--palette", type=int, default=None,
                        help="show one palette of the table")
    args = parser.parse_args()

    data = (args.rom or find_rom()).read_bytes()
    tables = find_tables(data)

    if args.json:
        print(_as_json(tables))
        return 0

    if not tables:
        print("no palette table found")
        return 1

    if args.palette is None:
        for number, table in enumerate(tables):
            print(f"table {number}: {table.describe()}")
        return 0

    table = tables[args.table]
    palette = table.palettes[args.palette]
    print(palette.describe())
    print("word    red green blue")
    for i, word in enumerate(palette.colours):
        red, green, blue = decode(word)
        print(f"{i:2d}  ${word:04X}  {red:3d} {green:3d} {blue:3d}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
