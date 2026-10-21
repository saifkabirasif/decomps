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
  Windows and Linux), `test-editor.yml` (editor build + xunit tests).

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
* The asset table at bank `$00`, `$F800` is parsed: 38 named blocks
  (`tools/asset_table.py`).  The numeric fields are stored **little endian**.
* Every block starts with the two bytes `4C 03`.  The two bytes behind the
  magic tell what the block holds:
  * `4C 03 00 00` - raw data that can be used as it is.  Only four blocks
    are like this: `sgdata` (the sprite table), `fdata` (font metrics and
    the character names), `cbmap0` (the character map) and `kdata` (the
    sprite definitions).
  * anything else - a script whose payload is stored in the cartridge's
    own encoded form.  That covers `root`, `initop`, `ibento` and the rest
    of the chapter logic as well as the `s_*` dialogue blocks, so **most
    of the cartridge is not directly editable yet**.  Decoding that form
    is the next big job.

### The sprite table

`sgdata` is **not** graphics, it is the table of the sprite groups.  After
the five byte header it holds twenty records of 51 bytes:

| Offset | Size | Content |
|---|---|---|
| 0 | 7 | parameters of the group |
| 7 | 1 | back pointer to the byte in front of the record |
| 8 | 1 | id of the group, `$A4` to `$A7` in sets of five |
| 9 | n*2 | animation frames, a tile and an offset each |
| - | 1 | `$FF` ends the frames |
| - | - | zero padding up to 51 bytes |

The record after the last one is empty, which ends the table.  The editor
shows the groups in its *Sprites* tab.

### Colours

A palette is sixteen 16 bit words in the order `0bbbbggggrrrrrrrr`.  The
game writes the low byte of a colour into the CGRAM before the high one,
so in the ROM the words are **little endian**.  `Palette.ReadPalette` and
`Palette.WritePalette` in the editor take care of that.

### Open items

* Find the tile graphics themselves.  They are **not** in the four raw
  blocks: neither `sgdata`, `cbmap0` nor `kdata` hold a plain 4bpp tile
  set, so the graphics are either inside the encoded blocks or behind
  another format.  The sprite groups only name the tiles, they do not
  carry them.
* Write a decoder for the encoded script blocks.
* Locate the SPC700 program and disassemble it.  The code that talks to
  the APU is around `$B860` (it writes `$2140`); the pointer to the
  program it downloads is set up just before that.
* Map the palettes: the table that points at them is built at runtime by
  the routine at `$9C3D`, so the addresses are not in the ROM as such.

## Phase 2 - milestone: boot + title screen (in progress)

Ported so far (all byte for byte identical to the original):

| Region | Content |
|---|---|
| `$8000-$800E` | entry point jump table |
| `$800F-$809F` | native mode entry, work RAM clear, PPU setup, main jump |
| `$80A0-$818F` | PPU setup |
| `$8190-$82B2` | global initialisation |
| `$82B3-$8360` | DMA setup |
| `$8361-$842F` | NMI handler |
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

* Port the main loop (`$90C9`-$9600`, the hottest code in the game).
* Recreate the tilemap and the font so the title screen appears.

## Phase 3 - editor app (in progress)

The cross platform editor is an Avalonia (C#) application under
`tools/gui/`.  It has three projects:

| Project | Content |
|---|---|
| `UnchartedWaters.Core` | ROM image, asset table, tile decoder, palette, text scanner - no UI dependencies so it can be tested on its own |
| `UnchartedWaters.Gui` | the Avalonia application |
| `UnchartedWaters.Core.Tests` | xunit tests for the core library |

What works today:

* Open a cartridge (also from the command line) and list the 38 assets.
* Hex view of the selected asset.
* Graphics view that decodes the tiles of the selected asset.
* Text view that lists the NUL terminated strings of the font and dialogue
  blocks, and writes an edited string back into the image.
* Sprites view that lists the twenty sprite groups of `sgdata` with their
  animation frames.
* Save the cartridge.

The tests cover the parts that are easy to get subtly wrong: the little
endian asset table, the 2bpp/4bpp/8bpp tile layouts, the ROM address
mapping, the string replacement rules, the sprite table and the byte
order of the palettes.

### Next

* Show the real CGRAM palette instead of the grey ramp.
* Edit palettes and portraits, not just the text.
* Import and export the graphics blocks as PNG.

## Later phases

* The rest of the game module by module.
* Music editing (needs the SPC700 program).
