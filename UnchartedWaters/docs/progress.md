# Progress log

## Phase 0 - toolchain and scaffold (done)

* `WLA DX` built from source (`vhelin/wla-dx`, CMake) - the 65816 assembler
  and linker we will build the ROM with.
* `Mesen 2.1.1` downloaded for testing; the core is also driven headlessly
  from Python through its C API (`tools/ucw/mesen.py`).
* Python tooling in `tools/ucw/`: 65816 and SPC700 disassemblers, memory map
  models, ROM/header parsing, a recursive descent code tracer.
* The opcode tables are generated from WLA's own instruction table so the
  disassembler can never disagree with the assembler
  (`tools/gen_opcode_tables.py`).
* CI: `build-tools.yml` (assembler build + opcode table drift check),
  `test-tools.yml` (pytest + ruff), `publish-exe.yml` (editor app for
  Windows and Linux).

## Phase 1 - cartridge analysis (mostly done)

* Header parsed; the US publisher's non standard 21/22 byte title field
  documented in `docs/memory-map.md`.
* Memory mapping **proven to be LoROM** by reading the emulator's memory
  view and comparing it with the file (see the table in
  `docs/memory-map.md`).
* Native mode entry, NMI/IRQ handlers, direct page `$0E`, HDMA channel 5,
  Mode 7 usage and the APU port protocol all identified.
* `asm/main.s` rebuilds the header and the vector table **byte for byte**
  identical to the original.

### Open items

* Locate the SPC700 program (likely bank $0E / file offset $070000) and
  disassemble it.
* Identify the compression used by the dense banks (custom Wolf Team
  codec?) and write an extractor.
* Map every asset (tiles, palettes, fonts, portraits, music).

## Phase 2 - milestone: boot + title screen (in progress)

Ported so far (all byte for byte identical to the original):

| Region | Content |
|---|---|
| `$8000-$800E` | entry point jump table |
| `$800F-$809F` | native mode entry, work RAM clear, PPU setup, main jump |
| `$FFC0-$FFFF` | header and vector table |

`tools/ucw/regions.py` keeps the list of ported regions and
`tools/tests/test_matching.py` fails if any of them stops matching the
original ROM.

### WLA quirks found so far

* **Immediate widths**: the original assembler sized immediates from the
  accumulator width only, so `LDX #$FC` in the boot code is encoded with an
  8 bit immediate even though the index registers are 16 bit at that point.
  The port pins such cases down with `.ACCU` / `.INDEX`.
* **Long indirect jumps**: `JML [$00809C]` assembles to a three byte
  instruction in the boot code, while the original uses the full 24 bit form
  (`DC 9C 80 00`).  Those four bytes are written out by hand in
  `src/boot.s`.

### Next

* Port the PPU setup routine at `$80A0`.
* Port the main loop (`$90C9`-`$9600`, the hottest code in the game).
* Recreate the tilemap and the font so the title screen appears.

## Later phases

* Asset pipeline (extract/pack) and the cross platform editor app.
* The rest of the game module by module.
* Music editing (needs the SPC700 program).
