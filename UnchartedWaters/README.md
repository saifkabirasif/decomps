# Uncharted Waters (USA) - SNES decompilation

A decompilation of **Uncharted Waters** (USA), the North American release of
Wolf Team's 1994 naval RPG **大航海** (*Daikoukai*) for the Super Famicom.

The goal is to rebuild the cartridge from source with [WLA DX], byte for
byte, and to end up with a cross platform editor that lets you change the
game's assets and produce a new ROM from your own copy of the original.

> The original ROM is **not** part of this repository.  Put your own dump in
> `../.games/` (see `../.games/README.md`); it is git ignored and never
> uploaded anywhere.

## Status

| Phase | State |
|---|---|
| 0 - toolchain, scaffold, CI | done |
| 1 - cartridge analysis (mapping, header, disassembler) | mostly done |
| 2 - milestone: boot + title screen | next |
| 3 - asset pipeline | pending |
| 4 - editor app (Windows + Linux) | pending |
| 5 - the rest of the game | pending |
| 6 - music editing, rebuild mode | pending |

See [docs/progress.md](docs/progress.md) and
[docs/memory-map.md](docs/memory-map.md) for the details of what has been
established so far.

## Layout

```
asm/     ROM skeleton: memory map, header, vector table
src/     the game itself, one file per module (coming next)
spc/     the SPC700 audio program (not yet located)
assets/  extracted assets (tiles, palettes, fonts, text, portraits)
tools/   Python tooling: disassembler, tracer, asset pipeline, diffing
docs/    analysis notes
build/   build output (git ignored)
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
make rom        # assemble build/uncharted_waters.sfc
make diff       # compare it with your own ROM dump
make disasm     # analyse the original ROM, write listings to build/disasm
make test       # run the Python test suite
```

At the moment `make rom` reproduces the cartridge's header and vector table
exactly; the code follows as each module is ported.

## Tooling notes

* `tools/ucw/disasm.py` - 65816 and SPC700 disassembler.  The opcode tables
  are generated from WLA's own instruction table, so the disassembler and
  the assembler always agree.
* `tools/ucw/trace.py` - recursive descent tracer that separates code from
  data.
* `tools/ucw/mesen.py` - headless Mesen harness: boots a ROM, scripts
  input, reads CPU/VRAM/WRAM/SPC memory.
* `tools/diff_rom.py` - per bank comparison against the original ROM.

## Licence

The tooling in this directory is released under the MIT licence that covers
this repository.  *Uncharted Waters* and its original code are the property
of their respective owners; no copyrighted game data is included here.

[WLA DX]: https://github.com/vhelin/wla-dx
