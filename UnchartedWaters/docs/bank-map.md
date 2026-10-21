# The map of the cartridge

The cartridge is a megabyte: 32 LoROM banks of 32 KiB.  This is what is
in it and what is still unknown.  `tools/bankmap.py` works it out and
prints it; this file is the written version of the same thing.

```sh
python3 tools/bankmap.py                    # the static map
python3 tools/bankmap.py --coverage 200    # and watch the game for three minutes
```

## The short version

| | |
|---|---|
| The cartridge | 1,048,576 bytes (1 MiB, 32 banks) |
| The asset table names | 38 blocks holding 285,564 bytes (27%) |
| The 65816 code | **13,758 bytes, all of it in bank `$00`** |
| The script machine | in bank `$00` as well, at `$A0FD` |
| Everything else | data: script programs, tiles, tables, sound |
| The largest unknown | banks `$03` and `$0A`-`$1F`: 17 banks, 544 KiB |

## Bank by bank

| Banks | What is in them | How much is understood |
|---|---|---|
| `$00` | the engine: boot code, PPU setup, the NMI handler, the transfer engine, the graphics engine, the script machine | 13,758 bytes traced; 3,468 of them already ported and byte for byte verified |
| `$01` | `root` (the script of the whole game), `sgdata` (the sprite graphics) | located; the script machine understood, the sprite table mapped |
| `$02` | `fdata` (the font), `cbmap0` (the character map) | located; the font is used by the editor |
| `$03` | **unknown** | nothing |
| `$04` | `initop`, `ibento`, `maituki` | script programs |
| `$05` | `cminato`, `jouriku`, `scom`, `sensou`, `senmain`, `senfe`, `kdata` (the sprite definitions) | script programs; `kdata` is mapped |
| `$06` | `uarugo`, `ucom`, `ending` | script programs |
| `$07` | `uminato`, `hantei`, `mdisp1`, `uminato2`, `um_sub`, `oukyu` | script programs |
| `$08` | `koueki`, `sakaba`, `s_nwaka`, `s_nsaso`, `s_nori`, `s_sake`, `s_onna`, `s_tobaku`, `s_ibent`, `s_card`, `s_bj` | script programs |
| `$09` | `s_pk`, `zousen`, `z_tyuuko`, `z_sinzou` | script programs |
| `$0A` | **unknown** | nothing |
| `$0B` | **unknown** | nothing |
| `$0C` | the character tiles | one region found (`$062730`) |
| `$0D` | **unknown** | nothing |
| `$0E` | **unknown** | nothing |
| `$0F` | **unknown** | nothing |
| `$10` | more tiles | one region found (`$086920`) |
| `$11` | **unknown** | nothing |
| `$12` | **unknown** | nothing |
| `$13` | **unknown** | nothing |
| `$14` | **unknown** | nothing |
| `$15` | **unknown** | nothing |
| `$16` | **unknown** | nothing |
| `$17` | **unknown** | nothing |
| `$18` | **unknown** | nothing |
| `$19` | **unknown** | nothing |
| `$1A` | **unknown** | nothing |
| `$1B` | **unknown** | nothing |
| `$1C` | **unknown** | nothing |
| `$1D` | **unknown** | one region found (`$0EAF20`) |
| `$1E` | the screen of the text | two regions found (`$0F5300`, `$0F5500`) |
| `$1F` | **unknown** | one region found (`$0FE460`) |

## How the map was made

### The code

The recursive descent tracer (`tools/ucw/trace.py`) follows calls and
branches from the known entry points and marks every byte it decodes as
code.  Three things had to be got right before it could be trusted:

* **The width of the machine.**  The width of the accumulator and of the
  index registers is part of the state of the machine, so it is handed
  on to the routines that are called and is still the same when they
  come back.  Before that the tracer read the code one byte off in
  places and found code that was not there.
* **BRK is not a branch.**  It starts with a B, but it is a trap, and
  the tracer used to walk over the empty space at the end of the
  cartridge two bytes at a time.
* **A table of long addresses looks like a row of long calls.**  The
  tracer is told which banks hold code, so that it does not follow the
  dispatch table of the script machine into nothing.

The tracer reaches 13,758 bytes in bank `$00`.  The places where the
running game was seen are used as starting points as well, and the ends
of the stretches that are still unknown are tried once more, so that
the code behind an indirect jump is found.

What is still not reached in bank `$00`:

| Stretch | Bytes |
|---|---|
| `$BF22-$CCAD` | 3,467 |
| `$F0AB-$FC0E` | 2,915 |
| `$DA5C-$E260` | 2,052 |
| `$D0CC-$D8AD` | 2,017 |
| `$E922-$F0A9` | 1,927 |
| `$E53A-$E920` | 998 |
| `$FC10-$FFC0` | 944 |
| `$B995-$BD0B` | 886 |

These are the parts of the engine that the introduction does not use.
Playing further into the game and watching it again finds more of them.

### That no other bank holds code

The running game is watched: the program counter is sampled over and
over for three minutes while the keys are pressed.  **Only bank `$00`
and the work RAM ever show up.**  Every other bank holds data.

### The graphics

What the game copies into the video memory is a copy of the cartridge,
so a tile of the video memory can be looked for in the cartridge.  The
tiles of the cartridge are indexed once, and every tile of every picture
the game shows is then looked up.  This found the graphics of the
introduction:

| File | Bank | Bytes | What it is |
|---|---|---|---|
| `$062730` | `$0C` | 1,152 | the tiles of the characters |
| `$086920` | `$10` | 288 | more tiles |
| `$0EAF20` | `$1D` | 128 | |
| `$0F5300` | `$1E` | 416 | the screen of the text |
| `$0F5500` | `$1E` | 9,152 | |
| `$0FE460` | `$1F` | 512 | |

Only the introduction was watched, so this is the start of the list and
not the end of it: every other picture of the game is still to be found
by playing through it.

### The tables of the graphics and the palettes

The engine keeps four tables in the work memory, and the graphics of the
game are put into the video memory through them (`src/graphics_groups.s`):

| Table | What it holds |
|---|---|
| `$0B96` | the list of the graphics blocks: three bytes each, the address low, the address high and the bank.  Every block is copied into the video memory with a DMA |
| `$0BBB`, `$0BC3` | where the sprites of a group are put on the screen |
| `$0BD4`, `$0C94` | a second list of graphics blocks |
| `$0CC8` | the colours: fifteen bit words, low byte first, copied into the colour memory two bytes at a time |

The tables in the work memory are **put together while the game runs**,
so the cartridge does not hold them as they are.  The graphics that are
loaded are the ones the script asks for.

The colours are copied into `$0CC8` by the routine at `$B812`, which
reads them one by one from the pointer in the direct page at `$0000`.
That routine is one of the handlers of the table at `$9A60`, which is
where the graphics groups are worked out.

### The script programs

Every script program starts with the mark `4C 03` and has the address
of the machine in the two bytes behind it.  The whole cartridge was
searched for that mark: every program that the asset table does not
name turned out to be a chance pair of bytes, so **there are no hidden
script programs**.  The script programs are the ones the asset table
names, and they live in banks `$01` and `$04` to `$09`.

### The keys do not work

The headless emulator does not get a key map, so `GetKeyCode` answers 0
for every name and nothing that is pressed reaches the game.  The game
therefore only ever plays the introduction, the title screen and the
menu on their own.  The rest of the game has to be reached some other
way: by making the key map work, or by changing the cartridge so that
it starts in the scene that is wanted.

## What is left

* Banks `$03` and `$0A` to `$1F` are the largest unknown: 17 banks,
  544 KiB, over half of the cartridge.  They hold the graphics of the
  game, the tables of the portraits and the sprites, and the sound.
* The pictures of the game have to be found by playing through it, one
  scene at a time, and every one of them added to the map.  The tables
  of the graphics are put together while the game runs, so the script
  says which pictures are wanted: working out the commands of the script
  that load the graphics is the way to the whole list.
* The tables that describe the portraits are nowhere to be seen yet.
* The sound program of the SPC700 has not been found.
* The engine of bank `$00` is only half traced: the parts that the
  introduction does not use are still to be found.
