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

## Phase 2 - milestone: boot + title screen (next)

* Move the reset path, the native mode entry and the interrupt dispatcher
  from the ROM into `src/`.
* Recreate the PPU setup, the tilemap and the font.
* Verify with `make diff` and by booting the built ROM in Mesen.

## Later phases

* Asset pipeline (extract/pack) and the cross platform editor app.
* The rest of the game module by module.
* Music editing (needs the SPC700 program).
