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

The scripts are programs of a machine of their own; that machine is
worked out further down.  The routine at `$9ABE` looks a block up by
name in the table at `$00:$F800` and the routine at `$9C7C` walks a table
of 14 byte records.

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

### The script machine

The blocks that are not raw data are **programs**.  They are not 65816
code and they are not compressed; they are the program of a small
machine that the game runs.  The machine lives in bank `$00` and the
game copies a block into the work memory at `$2000` before it runs it.

That was found by tracing the game.  The program counter of the running
game is sampled twice, once while the game shows its background and once
while it shows a line of dialogue, and the places that only show up
during the dialogue are looked at.  Almost all of them are in bank `$00`.
The one that is not is a short piece of code in the work memory at
`$21BA`:

```
$21BA: JSL $008000        ; and $008000 is $8000 in bank $00,
$21BE: JSL $008003        ; which jumps to $A0FD
$21C2: JSL $008000
```

`$A0FD` is the machine.  It takes the block out of the stack, sets the
pointer to the block in the direct page and reads the program one byte
at a time.

**The loop of the machine** is at `$A141`:

```
$A141: SEP #$20
$A143: LDY #$0000
$A146: LDA [$0000]        ; the instruction
$A148: REP #$20
$A14A: INC $06            ; on to the next byte of the program
$A14C: AND #$00FF
$A14F: PHA
$A150: ASL A              ; the instruction times two
$A151: TAX
$A152: LDA $00A797,X      ; where the code of the instruction is
$A156: STA $00
$A158: PLX                ; and now X holds the instruction itself
$A159: JMP [$0000]        ; and it runs
```

**The dispatch table** of the machine is at `$00:$A797`: 256 addresses,
one for every instruction, read as 16 bit little endian numbers.  The
handler of an instruction is five bytes long and carries the place in the
block that the instruction works on:

```
$A15C: LDA #$FFE9        ; the instruction $00 works on the place -$17
$A15F: BNE $A196
$A196: CLC
$A197: ADC $04           ; the place is relative to the start of the block
$A199: STA $00
$A19B: LDA ($00),Y
$A19D: STA $0A
$A19F: JMP $A141         ; back to the loop
```

The instructions come in groups:

| Instructions | What they do |
|---|---|
| `$00`-`$0B` | read one of the variables of the block |
| `$0C`-`$0F` | read further along the block |
| `$10`-`$1B` | the same, into another place |
| `$20`-`$2B` | write a variable of the block |
| `$40`-`$4F` | one shared piece of code for sixteen instructions |
| `$50`-`$5F`, `$60`-`$6F`, `$71`-`$7F` | the same |
| `$80`-`$EA` | an instruction each |
| `$EB`-`$FE` | not used |

Two places in the direct page work as registers of the machine: `$0A`
and `$0E`.  The instructions `$60`-`$6F` put the low half of their own
number on the stack, and `$71`-`$7F` add it to `$0A`.  The instructions
from `$80` up take their operand out of the program: `$81` reads one
byte, `$82` reads one byte unless the byte before it says otherwise, and
so on.

**The header of a block** says where its program starts:

```
4C 03 XX 20  BA 21  00 00
```

The two bytes behind the mark are the place in the work memory where the
program starts, and `$21BA` is the machine itself.  The blocks of the
same kind start at the same place in the block:

| Kind | Place in the block | Blocks |
|---|---|---|
| `$2020` | `$0020` | `root` |
| `$2096` | `$0096` | `initop`, `ibento`, `maituki`, `jouriku`, `scom`, `sensou`, `uarugo`, `ucom`, `ending`, `uminato`, `cminato` |
| `$20A5` | `$00A5` | `senmain`, `senfe` |
| `$20B0` | `$00B0` | `hantei`, `mdisp1`, `uminato2`, `um_sub`, `oukyu`, `koueki`, `sakaba`, `s_card`, `zousen` |
| `$20B8` | `$00B8` | `s_nwaka`, `s_nsaso`, `s_nori`, `s_sake`, `s_onna`, `s_tobaku`, `s_ibent`, `s_bj`, `s_pk` |
| `$20D0` | `$00D0` | `z_tyuuko`, `z_sinzou` |

The four blocks that hold raw data (`sgdata`, `fdata`, `cbmap0`,
`kdata`) have no program.

`tools/scriptvm.py` reads all of this out of the cartridge.

### Reading the programs

The program of a block can be listed.  `tools/scriptdis.py` walks it:
the dispatch table says where the code of every instruction is, and the
code of an instruction says how many bytes its operands take.

The machine keeps the pointer to the program in the direct page at
`$0006`, so the game itself says where the program is: the pointer was
watched while the game played the introduction, and the places it stood
at were the places the instructions are.  Every instruction that the
watching showed agrees with what the code of the handler says.

Walking the programs of all the blocks gives 92,156 instructions.  Only
0.7% of them are instructions the machine has no code for, where in
plain data about 8% would be.  So the programs are read right, and the
place each block starts its program is right as well.

### What loads the graphics

Not the script.  The machine never touches the tables of the graphics:
there is not one instruction of the machine that writes `$0B87`, `$0B96`
or `$0CC8`.  And the pictures are not in the cartridge as a table of
addresses either: the longest run of address triples in the whole
cartridge is a repeating pattern in bank `$0D`, not a list.

So the engine of the game builds the list of the pictures while it runs,
and the code that does it is in the part of bank `$00` that the
introduction never reaches.  That part is still to be traced, and the
game has to be played to reach it.

### Playing the game without a keyboard

The headless emulator has no key map, so nothing that is pressed reaches
the game.  But the game reads the joypad of the SNES in two places, and
both are in the cartridge:

* `$8378: CMP $4210` - the buttons A, B, X, Y, L and R,
* `$9587: CMP $4211` - the direction pad.

Both are three bytes long, so they can be changed for a comparison that
does not depend on the emulator at all.  The comparison leaves the carry
set when no button is pressed, so changing it to one that always leaves
the carry clear makes the game think a button is pressed.

`tools/patchinput.py` makes such a cartridge.  With it the game walks
past the introduction on its own and comes to a screen that shows the
map of the characters, which it holds on to because it is waiting for a
button.  The parts of the engine that only the later scenes use can then
be traced.

### The text of the dialogue

The text is written into the program of the block in the clear.  A string
is a run of text that ends with a NUL byte.  Inside the run there can be

* a line break, `$0A`, and
* a control code: the escape byte `$1B` followed by one command byte.

The control codes are commands of the text itself, a change of colour or
a wait for example, so they are kept when a string is edited.

The sentences are spread over several strings, because the machine
prints a string at a time.  "Ah, the legendary" and the rest of the
sentence are two strings, and the word "kingdom" is in a third one.

All 38 blocks together hold 2560 strings and 41,544 bytes of readable
text, which is 19% of them.

The text does not stand at the end of the block, it stands **in** the
program.  In `initop` the text of the opening runs from `$1D3E` to
`$20C6` and the program carries on after it, with the bytes of the
instructions and their operands.  So the strings are the data of the
program, and the instructions point at them.

The control codes of the text are the escape byte `$1B` followed by one
byte.  In `initop` the codes `$1B W`, `$1B P` and `$1B F` are used; the
`$1B W` looks like the end of a line and `$1B P` and `$1B F` like the
start of a new page and a new picture.

How an instruction points at a string is not known yet: no plain 16 bit
number in the program points at one of the strings, whatever base it is
measured from.

### Open items

* Work out what the instructions of the script machine do.  The dispatch
  table is known and every instruction has its own piece of code, so
  this is now a matter of reading that code.  The instruction that
  prints a line of dialogue and the one that waits for the player are
  the ones worth having first: with them the editor can show the
  dialogue of the game as it will be read.
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
