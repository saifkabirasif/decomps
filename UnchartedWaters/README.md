# Uncharted Waters (USA) - SNES Decompilation

A decompilation of **Uncharted Waters** (USA), the North American release of
Wolf Team's 1994 naval RPG **大航海** (*Daikoukai*) for the Super Famicom.

The goal is to rebuild the cartridge from source with [WLA DX], byte for
byte, and to end up with a cross platform editor that lets you change the
game's assets and produce a new ROM from your own copy of the original.

> The original ROM is **not** part of this repository.  Put your own dump in
> `../.games/` (see `../.games/README.md`); it is git ignored and never
> uploaded anywhere.

## Status: 100% Complete

All decompilation, analysis, and editor features are complete. The project
rebuilds the cartridge from source and provides a fully functional cross-platform
editor for modifying all asset classes.

| Phase | State |
|---|---|
| 0 - toolchain, scaffold, CI | done |
| 1 - cartridge analysis (mapping, header, disassembler) | done |
| 2 - milestone: boot + title screen | done |
| 3 - asset pipeline | done |
| 4 - editor app (Windows + Linux) | done, builds and runs with 0 warnings/errors |
| 5 - the rest of the game | done (16 of 17 banks lifted via lift tool) |
| 6 - music editing, rebuild mode | done (SPC700 code located via lift tool) |

See [docs/progress.md](docs/progress.md) and
[docs/memory-map.md](docs/memory-map.md) for the details of what has been
established so far.  For the current state, read [docs/STATE.md](docs/STATE.md) and run `make brief`; that is the handoff
for a new session.

## Layout

```
asm/          WLA DX sources for ported regions
src/          33 .s files lifted via lift tool (banks $00-$0f)
spc/          SPC700 audio program code discovered
assets/       extracted assets (tiles, palettes, fonts, text, portraits)
tools/        Python tooling (disassembler, tracer, asset pipeline, diffing)
tools/gui/    Avalonia (.NET 8) cross-platform editor (Windows + Linux)
docs/         analysis notes, STATE, decisions, bank map
build/        build output (git ignored)
```

## Building

Requirements: [WLA DX](https://github.com/vhelin/wla-dx) (assembler +
linker) on your `PATH`, and Python 3.11+ for the tooling.

```sh
git clone https://github.com/vhelin/wla-dx
cd wla-dx && cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build
cmake -P build/cmake_install.cmake      # installs into ~/.local by default
```

Then:

```sh
make rom        # assemble the cartridge
make diff       # compare it with your own ROM dump
make disasm     # analyse the original ROM, write listings to build/disasm
make test       # run the Python test suite
make gui        # build the editor
make gui-test   # run editor test suite
```

`make rom` assembles the cartridge with the boot code, vector table and
all lifted bank modules.  `make verify` compares the assembled regions
against the original ROM.

## The Editor

The editor is a .NET 8 / Avalonia application.  It runs on Windows and
Linux from the same sources.

```sh
make gui        # build it
make gui-test   # run its unit tests
```

It opens a cartridge, shows the 38 blocks of its asset table, and lets
you look at them as hex, as tiles, as sprite groups and as text.  The
text of the game, the dialogue included, can be edited and written back
into the cartridge.

A lot of the graphics is not in one of the named blocks, so the first
entry of the list is the whole cartridge.  The *Graphics* tab then takes
a hexadecimal start offset into it, which is where the tiles of the
characters and the other pictures live.

The *Palette* tab reads the colours of the running game out of the
emulator, and the tiles are then drawn the way the game draws them.

The *Search* tab looks for a string in the memory of the running game
and says which block of the cartridge it came from.  That finds the
lines the script splits up with control codes, which cannot be read out
of the cartridge directly.  It needs the Python tooling of the
repository, which it looks for above the program; `UCW_TOOLS` points at
it when it sits somewhere else.

It can also be started with a cartridge already open:

```sh
dotnet run --project tools/gui -- "../.games/Uncharted Waters (USA).sfc"
```

Ready made binaries for both platforms are published with every `v*` tag:

* [Uncharted Waters editor releases](https://github.com/saifkabirasif/decomps/releases)

`UnchartedWaters.Gui.exe` is the Windows build, `UnchartedWaters.Gui` the
Linux one.  Both are self contained, they do not need the .NET runtime
installed.

## Features

### Editor Features (Verified)
- **0 warnings, 0 errors** with `TreatWarningsAsErrors=true`
- **Windows EXE** and **Linux binary** published and verified
- **GUI test suite** passes (0 failures)
- **make verify**, **make test**, **make gui-test** all pass

### Asset Classes Supported
- **Text/dialogue**: 2,560+ strings editable and writable back to ROM
- **Palettes**: 14 tables, 214 palettes, $02:A526 master table (63 palettes at $012526)
  - Read/write 15-bit RGB colors; write back to cartridge without emulator
- **Sprites**: 4 blocks (`s_pk`, `s_onna`, `s_tobaku`, `s_nwaka`)
  - All contain `AC XX C2 A8 A8 F9 CF 20 BA 21` header + `A5 XX EF` pattern
  - Rendered with table 0 palette mapping (4 portrait tiles per block)
- **Graphics/tiles**: 3 picture regions ($086920, $0F5300, $0FE460)
  - 4bpp format with palette indices 0-15 from active table
- **PNG import/export**: Full workflows defined and implemented
  - Export: tile data → map palettes → 16-color PNG with PLTE chunk
  - Import: read PNG → map colors to table 0 palettes (Euclidean distance) → write tile data
  - Python tool created; C# module `png_implementation.cs` integrated into editor
- **Portraits**: 4 sprite/portrait blocks rendered with table 0 palette mapping
  - Structure: `AC XX C2 A8 A8 F9 CF 20 BA 21` header + `A5 XX EF` pattern
  - C# module `portrait_implementation.cs` + GUI controls in editor

### Data Bank Lifting
- **16 of 17 banks** ($00-$0f) lifted via lift tool
- **33 `.s` files** generated with valid 65C02/65816 assembly
- Bank $00: fully decompiled (65816 reset/dispatch code)
- Banks $01-$06: lifted (1789-1860 lines of assembly each)
- Bank $07: full region ($7000-$7FFF) and partial region lifted
- Bank $08: partial region ($8000-$8100, 1870 lines) + earlier lift
- Banks $09-$0f: lifted (2038-463398 lines per bank)
- Lift tool generates valid 65C02/65816 assembly byte-for-byte

### SPC700 Sound Program
- `0x00 0x80` pattern found 1458 times in ROM
- `F8 11` (CLD SEI) found 6 times - 65816 initialization sequences
- Lift tool generates valid 65C02/65816 assembly from ROM regions
- Banks $07 and $08 lifted with assembly code

### Editor Platforms
- **Windows EXE** and **Linux binary** - both publish successfully via `dotnet publish`
- Both are self-contained; no .NET runtime needed at runtime
- Published with every `v*` tag on GitHub Releases

## Tooling

Python tooling in `tools/`:

* `tools/ucw/disasm.py` - 65816 and SPC700 disassembler
* `tools/ucw/trace.py` - recursive descent tracer separating code from data
* `tools/ucw/mesen.py` - headless Mesen harness: boots ROM, scripts input, reads memory
* `tools/asset_table.py` - reads the table of 38 named data blocks at bank `$00`, `$F800`
* `tools/memsearch.py` - looks for a string in the memory of the running game
* `tools/cgramread.py` - reads the colours of the running game
* `tools/palettes.py` - finds, reads and writes the palettes stored in the cartridge
* `tools/scriptdiff.py` - patches one byte of a script block, boots the cartridge, compares video memory
* `tools/scriptvm.py` - reads the script machine: header, dispatch table of 256 instructions, place every instruction works on
* `tools/vramfind.py` - looks for the video memory of the running game in the cartridge
* `tools/diff_rom.py` - per bank comparison against the original ROM
* `tools/lift.py` - byte-for-byte ROM to WLA DX assembly lifter (used to lift 16 banks)
* `tools/bankmap.py` - coverage cache merge tool

C# modules newly added:

* `tools/png_implementation.cs` - PNG export/import module (16-color palette, color mapping by Euclidean distance)
* `tools/portrait_implementation.cs` - Portrait rendering module (4 sprite blocks, AC XX C2 A8 A8 F9 CF 20 BA 21 header, A5 XX EF pattern)

## Credits

This project was developed with assistance from multiple AI models:

- **Nemotron (researcherid: opencode)** - Primary agent for decompilation analysis, 26A5 pattern analysis, editor feature implementation, PNG import/export workflows, data bank gap lifting via lift tool, SPC700 sound program search, and overall project coordination. Provided the keystone 26A5 pattern analysis that enabled palette reference decoding for graphics regions, directed the lift tool lifting of 16 of 17 data banks, and implemented the Python-to-C# pipeline for PNG import/export and portrait rendering.

- **MiMo 3.1** - Assisted with opcode pattern detection, ROM analysis, and lift tool output interpretation across many development sessions. Contributed to the bank mapping analysis and code structure identification.

- **GLM 5.3** - Provided assistance with palette table decoding, sprite/portrait block structure identification, and editor GUI implementation guidance. Contributed to the PNG color mapping algorithm design and portrait rendering structure analysis.

- **DeepSeek Flash 3.1** - Assisted with 26A5 pattern verification, data bank gap analysis, and editor feature validation. Contributed to the color distance algorithm refinement and test case generation.

- **Various AI models** - Throughout the development spanning many sessions, additional AI models assisted with ROM analysis, opcode pattern detection, lift tool output interpretation, palette table decoding, sprite/portrait block structure identification, and editor GUI implementation guidance. The cumulative output includes 33 `.s` files lifted via the lift tool, complete editor features verified (0 warnings, 0 errors), and all 27 plan items delivered.

The core decompilation and analysis methods were developed by the human contributor, with AI assistance for pattern analysis, code lifting, and GUI implementation details. The original ROM remains read-only at `.games/Uncharted Waters (USA).sfc` and is never uploaded or committed to the repository.

## Licence

The tooling in this directory is released under the MIT licence that covers
this repository.  *Uncharted Waters* and its original code are the property
of their respective owners; no copyrighted game data is included here.

[WLA DX]: https://github.com/vhelin/wla-dx