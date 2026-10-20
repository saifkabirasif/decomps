#!/usr/bin/env python3
"""Parse the asset file table of the original cartridge.

The table lives at bank $00, $F800 and holds one 16 byte record per asset:

    offset 0   8 bytes   name, NUL padded ASCII
    offset 8   2 bytes   ROM bank the data lives in
    offset 10  2 bytes   CPU address inside that bank
    offset 12  2 bytes   length in bytes
    offset 14  2 bytes   flags

The records are stored in the order the game loads them, so the length of
one record is the offset of the next one.

Usage:
    python3 tools/asset_table.py [--rom PATH] [--json]
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass, asdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.rom import find_rom  # noqa: E402

#: Where the table starts (bank $00, CPU address).
TABLE_ADDRESS = 0xF800
#: Size of one record.
RECORD_SIZE = 16
#: Number of records in the table.
RECORD_COUNT = 38
#: Every block of the cartridge starts with these two bytes.
BLOCK_MAGIC = b"\x4c\x03"


@dataclass(frozen=True)
class Asset:
    """One named block of data inside the ROM."""

    name: str
    bank: int
    address: int
    length: int
    flags: int

    @property
    def file_offset(self) -> int:
        """Offset of the block inside the ROM image."""
        return self.bank * 0x8000 + (self.address - 0x8000)

    @property
    def end_offset(self) -> int:
        return self.file_offset + self.length

    def describe(self) -> str:
        return (
            f"{self.name:<10} bank ${self.bank:02X} ${self.address:04X} "
            f"${self.length:05X} bytes  file ${self.file_offset:06X}"
        )


def block_kind(data: bytes, offset: int) -> str:
    """Say what a block holds.

    All 38 blocks start with the two bytes ``4C 03``.  A block whose next
    two bytes are zero holds raw data that can be used as it is: the
    sprite graphics, the font, the character map and the sprite
    definitions.  Every other block holds a script whose payload is
    stored in the cartridge's own encoded form.

    The four raw blocks are ``sgdata`` (sprite graphics), ``fdata`` (font
    and character names), ``cbmap0`` (character map) and ``kdata``
    (sprite definitions).
    """
    if data[offset : offset + 2] != BLOCK_MAGIC:
        return "no header"
    if data[offset + 2 : offset + 4] == b"\x00\x00":
        return "raw data"
    return "encoded script"


def parse_table(data: bytes, offset: int = TABLE_ADDRESS - 0x8000) -> list[Asset]:
    """Parse the asset table out of the ROM image."""
    assets: list[Asset] = []
    for index in range(RECORD_COUNT):
        base = offset + index * RECORD_SIZE
        raw_name = data[base : base + 8]
        name = raw_name.split(b"\x00")[0].decode("latin-1")
        bank = int.from_bytes(data[base + 8 : base + 10], "little")
        address = int.from_bytes(data[base + 10 : base + 12], "little")
        length = int.from_bytes(data[base + 12 : base + 14], "little")
        flags = int.from_bytes(data[base + 14 : base + 16], "little")
        if not name:
            break
        assets.append(Asset(name, bank, address, length, flags))
    return assets


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None)
    parser.add_argument("--json", action="store_true", help="print JSON")
    args = parser.parse_args()

    rom = (args.rom or find_rom()).read_bytes()
    assets = parse_table(rom)

    if args.json:
        print(json.dumps([asdict(a) | {"file_offset": a.file_offset} for a in assets], indent=2))
        return 0

    total = 0
    for asset in assets:
        kind = block_kind(rom, asset.file_offset)
        print(f"{asset.describe()}  {kind}")
        total += asset.length
    print()
    print(f"{len(assets)} assets, {total} bytes "
          f"({total / len(rom) * 100:.1f}% of the ROM)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
