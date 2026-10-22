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
| 2 - milestone: boot + title screen | in progress |
| 3 - asset pipeline | in progress |
| 4 - editor app (Windows + Linux) | in progress, builds and runs |
| 5 - the rest of the game | pending |
| 6 - music editing, rebuild mode | pending |

See [docs/progress.md](docs/progress.md) and
[docs/memory-map.md](docs/memory-map.md) for the details of what has been
established so far.  For where the work stands right now, read
[docs/STATE.md](docs/STATE.md) and run `make brief`; that is the handoff
for a new session.

## Layout

```
asm/     ROM skeleton: memory map, header, vector table
src/     the game itself, one file per module (coming next)
spc/     the SPC700 audio program (not yet located)
assets/  extracted assets (tiles, palettes, fonts, text, portraits)
tools/   Python tooling: disassembler, tracer, asset pipeline, diffing
tools/gui/  the editor app (C# / Avalonia)
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

At the moment `make rom` reproduces the cartridge's header, vector table and
the boot code exactly; the rest follows as each module is ported.

## The editor

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

## Tooling notes

* `tools/ucw/disasm.py` - 65816 and SPC700 disassembler.  The opcode tables
  are generated from WLA's own instruction table, so the disassembler and
  the assembler always agree.
* `tools/ucw/trace.py` - recursive descent tracer that separates code from
  data.
* `tools/ucw/mesen.py` - headless Mesen harness: boots a ROM, scripts
  input, reads CPU/VRAM/WRAM/SPC memory.
* `tools/asset_table.py` - reads the table of the 38 named data blocks the
  cartridge keeps at bank `$00`, `$F800`.
* `tools/memsearch.py` - looks for a string in the memory of the running
  game and reports which block of the cartridge it came from.
* `tools/cgramread.py` - reads the colours of the running game.
* `tools/palettes.py` - finds, reads and writes the palettes that are
  stored in the cartridge itself.
* `tools/scriptdiff.py` - patches one byte of a script block, boots the
  cartridge and compares the video memory, which shows what the byte
  does.
* `tools/scriptvm.py` - reads the script machine of the cartridge out of
  it: the header of a block, the dispatch table of its 256 instructions
  and the place in the block that every instruction works on.
* `tools/vramfind.py` - looks for the video memory of the running game in
  the cartridge, which shows where the graphics live.
* `tools/diff_rom.py` - per bank comparison against the original ROM.
* `tools/gui/UnchartedWaters.Core/` - the same ROM and asset handling for
  the editor, with unit tests next to it.

## Licence

The tooling in this directory is released under the MIT licence that covers
this repository.  *Uncharted Waters* and its original code are the property
of their respective owners; no copyrighted game data is included here.

[WLA DX]: https://github.com/vhelin/wla-dx
