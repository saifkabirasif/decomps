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

### The script blocks and the text

The blocks that are not raw data are **scripts**: a stream of bytes that
tells the game what happens, with the text of the dialogue written into
the stream in the clear.  A string is a run of text that ends with a NUL
byte.  Inside the run there can be

* a line break, `$0A`, and
* a control code: the escape byte `$1B` followed by one command byte.

The control codes are commands of the script, a change of colour or a
wait for example, so they are kept when a string is edited.

That means the whole text of the game can be read and changed, and the
editor does exactly that.  It was checked by editing a line of the user
interface text, saving the cartridge and booting the result in Mesen:
the new text shows up in the memory of the running game.

The scripts are looked at from the outside, the interpreter is still
unknown.  The routine at `$9ABE` looks a block up by name in the table at
`$00:$F800` and the routine at `$9C7C` walks a table of 14 byte records.

### Colours

A palette is sixteen 16 bit words in the order `0bbbbggggrrrrrrrr`.  The
game writes the low byte of a colour into the CGRAM before the high one,
so in the ROM the words are **little endian**.  `Palette.ReadPalette` and
`Palette.WritePalette` in the editor take care of that.

### The colours of the game

The colour memory of the SNES holds 256 words of 15 bit colour.  The
emulator can read it, and the new `tools/cgramread.py` helper boots the
cartridge and dumps all sixteen palettes of the game:

```
palette  0: #000000 #985020 #C89860 #F8F8F8 #000000 #C85010 #E89830 #20D8D8 ...
palette  3: #000000 #602000 #884030 #C88850 #F8B888 #B8B8C6 #D8D8E8 #F8F8F8 ...
```

The script keeps a copy of the palette of the picture that is on the
screen at the work RAM address `$0CC8`; that copy is read as well.

The editor uses the colours to draw the tiles, so they look the way they
look in the game.

### Where the graphics are

A lot of the graphics of the game is **not** in one of the 38 named
blocks.  The table at `$00:$F800` only names the scripts, the font and
the character map; the tiles live in parts of the cartridge that the
table does not describe at all.

They were found by booting the game and looking at the video memory: what
the game copies into the video memory is a copy of the cartridge, so a
piece of the video memory can be looked for in the cartridge.  The
`tools/vramfind.py` helper does that and reports the places it found.
So far:

| File | Bank | Content |
|---|---|---|
| `$062730-$062BB0` | `$0C` | the tiles of the characters |
| `$086920-$086A40` | `$10` | a small set of tiles |
| `$0F52F0-$0F78B0` | `$1E` | a screen of text |

The tiles are 4bpp, the same format the decoder of the editor uses.

Because of that the editor now offers the whole cartridge as the first
entry of the asset list, and the graphics view takes a hexadecimal start
offset into it.

### The script blocks

The blocks that are not raw data hold the script of the game: the text
of the dialogue in the clear, with other bytes in between that the game
interprets.  All 38 blocks together hold 2560 strings and 41,544 bytes
of readable text, which is 19% of them.

What is known about the format:

* A string is a run of text that ends with a NUL byte.  Inside the run
  there can be a line break (`$0A`) and a control code, the escape byte
  `$1B` followed by one command byte.
* The control codes sit **inside** the text, sometimes even inside a
  word.  That is why "Ah, the legendary" and the next word are two
  strings, and why a sentence is spread over several of them.
* The bytes in between are not 65816 code, they do not point at the
  strings with a 16 bit offset, and they are not a dense LZ stream
  either.  What they are is still open.
* Every block starts with the two bytes `4C 03`.  The two bytes behind
  them name the kind of the script: `00 00` for the raw blocks, and
  `20 96`, `20 A5`, `20 B0`, `20 B8`, `20 D0` or `20 20` for the
  six kinds of script.

`tools/scriptdiff.py` works out what the bytes in between do: it
patches one byte of a block, boots the cartridge in the headless Mesen
harness and compares the video memory with the unpatched cartridge.

Getting a clean measurement out of that took some doing:

* The **video memory** is the only usable measurement.  The work memory
  of the game moves by some 14,000 bytes between two runs, the video
  memory does not move at all.
* The game shows its text in a box and moves on after a while, so the
  picture has to be taken at the same frame every time.  The tool looks
  for the picture of the introduction, remembers the frame it was on and
  then waits for exactly that frame in every later run.  Pass `--frame`
  to skip the search.

With that, patching one letter of a line of the introduction changes
6868 bytes of the video memory, while patching a byte of the text that
is not on the screen changes nothing.  That is the tool working.

### Open items

* Find the commands of the script, so that a line of dialogue can be
  given a new colour or a new pause.  The tool to find them is ready;
  the sweep over the code region of a block is a matter of time, at
  about 45 seconds a byte.
* Find the table that points at the graphics, so that the editor can
  list them the way it lists the named blocks.  At the moment the places
  have to be found with `tools/vramfind.py`.
* Find where the palettes come from.  The colours are put together at
  run time out of pieces that are spread over the whole cartridge, so
  they cannot be changed in the file yet.
* Locate the SPC700 program and disassemble it.  The code that talks to
  the APU is around `$B860` (it writes `$2140`); the pointer to the
  program it downloads is set up just before that.

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
* Text view that lists the text of **every** block, the dialogue of the
  game included, and writes an edited line back into the image.
* Sprites view that lists the twenty sprite groups of `sgdata` with their
  animation frames.
* Search view that looks for a string in the memory of the running game
  and says which block of the cartridge it came from.  That finds the
  strings the script splits up with control codes, which cannot be read
  out of the cartridge directly.
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
