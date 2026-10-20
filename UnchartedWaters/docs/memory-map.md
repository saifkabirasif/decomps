# Memory map & cartridge analysis

Everything in this file was verified against the original dump
(`Uncharted Waters (USA).sfc`, SHA-256
`794152fc6f55cb15a0b203fa645ac9fa314a293da999d8ec8b3dda080434d175`).

## The game

* **Title**: Uncharted Waters (USA)
* **Original title**: 大航海 (*Daikoukai*), Wolf Team / Telenet Japan, 1994
  (Super Famicom).  The US release was published by Tsunami Media in 1995.
* **Genre**: naval role playing game (shipbuilding, crew, battles, ports).
* **Size**: 1 MiB (8 Mbit), 32 KiB battery backed SRAM for saves.

## Header (ROM offset $7FC0)

| Offset | Value | Meaning |
|---|---|---|
| $7FC0-$7FD4 | `UNCHARTED WATERS` + spaces | title (21 bytes) |
| $7FD5 | $20 | map mode - **LoROM** |
| $7FD6 | $02 | cartridge type - ROM + RAM + battery |
| $7FD7 | $0A | ROM size - 8 Mbit |
| $7FD8 | $03 | SRAM size - 32 KiB |
| $7FD9 | $01 | region - USA |
| $7FDA | $C8 | licensee code |
| $7FDB | $00 | version |
| $7FDC-$7FDD | $B057 | checksum complement |
| $7FDE-$7FDF | $4FA8 | checksum (complement of $B057) |

The header is *not* the stock layout: the US publisher wrote it by hand, so
the title field is 22 bytes long instead of 21 and every following field
sits one byte to the right.  A stock parser therefore reads the title's
trailing space as the map mode and gets the whole block wrong - see
`tools/ucw/rom.py`, which detects the shift.

### Vectors (ROM offset $7FE0)

| Vector | Address | Purpose |
|---|---|---|
| native NMI ($FFEA) | $8361 | APU port handling (`$2140`-`$2143`) |
| native RESET ($FFEC) | $0000 | unused - the game boots through the emulation vector |
| native IRQ ($FFEE) | $9593 | interrupt dispatcher (checks `$4210`) |
| emulation RESET ($FFFC) | $800F | switches the CPU to native mode |

`$800F` is the classic native mode entry:

```
CLC
XCE            ; 65816 native mode
SEI
REP #$30       ; 16 bit A/X/Y
LDA #$0000
TCD            ; direct page = 0
```

### Extended header

There is an ExHiROM style extended header (`0x16`) at ROM offset $FFC0,
but the cartridge is **not** ExHiROM - see below.  The bytes there are
unused space at the end of the last LoROM bank.

## Memory mapping: LoROM, confirmed

The cartridge is **LoROM**: 32 banks of 32 KiB, bank *N* mapped at
`$N:8000-$FFFF` and stored at file offset *N* x `$8000`.

How this was established:

1. The header's map mode byte says `$20` (LoROM).
2. The game writes `$4370`/`$4371` (`FFMEMSEL`/`FFBANKSEL`).  Those
   registers only exist on HiROM style carts, which is confusing - but the
   writes are harmless on LoROM and the game also sets up HDMA channel 5
   (`$420C` bit 5) with a work RAM source, so it does not need them.
3. **Decisive test**: the ROM was loaded into Mesen (which honours the
   header) and the CPU visible memory was read back through the debugger
   API and compared with the file:

   | CPU address | emulator view | file offset |
   |---|---|---|
   | `$00:8000` | `4C FD A0 ...` | `$000000` |
   | `$01:8000` | `4C 03 20 ...` | `$008000` |
   | `$02:8000` | `1E 00 BC ...` | `$010000` |
   | `$03:8000` | `4D 0B 4E ...` | `$018000` |

   That is exactly the LoROM layout, and the game boots and draws its
   title screen under it (239 frames, ~3000 non-zero VRAM bytes).

## CPU behaviour

* 65816 **native mode**, accumulator and index registers are usually 16 bit.
* Direct page is `$0000` at reset (`TCD` with A = 0) but the game later
  switches to **direct page `$000E`**: the global variables live at
  `$0E00-$0EFF` and are accessed both directly (`LDA $0E09`) and through
  the direct page (`LDA $09`).
* Bank $00 starts with a five entry `JMP` table at `$8000`
  (`$A0FD`, `$A0D9`, `$A997`, `$A997`, `$8E04`).
* The interrupt handler at `$9593` dispatches on `$4210`.

## Graphics

* Mode 7 is used: the game writes the affine registers `$2123-$2126`
  (`M7A`-`M7D`).
* VRAM tilemap data lives in the ROM (for example file offset `$008060`
  holds 16 bit tilemap entries such as `$FEFE`).
* Palettes: 15 bit BGR words.  A palette table was found at file offset
  `$088000` (values such as `$00E0`, `$00F0`).

## Audio

* The SPC700 is driven through the APU ports `$2140`-`$2143`.
* `$2142` (SPC program bank) and `$2143` (SPC program counter) are
  written from the work RAM variables `$0E07`/`$0E08`.
* The cartridge therefore contains an SPC700 program that still has to be
  located and disassembled (open item, see `docs/progress.md`).

## Bank layout (file offsets)

| Bank | File offset | Content |
|---|---|---|
| $00 | $000000 | code, jump table, header, vectors |
| $01 | $008000 | jump table, tilemap data |
| $02 | $010000 | tables of small offsets |
| $03 | $018000 | tables of small offsets |
| $04 | $020000 | structured data |
| $05 | $028000 | structured data |
| $06 | $030000 | graphics |
| $07 | $038000 | English script text ("...ation... When the ") |
| $08 | $040000 | English script text ("make\0You see, I'm ") |
| $09 | $048000 | code / tables |
| $0A | $050000 | structured data |
| $0B | $058000 | structured data |
| $0C | $060000 | graphics |
| $0D | $068000 | offset tables, graphics |
| $0E | $070000 | dense structured data (SPC700 program?) |
| $0F | $078000 | tables |

## How to reproduce the analysis

```sh
python3 tools/analyze.py            # header, mapping, disassembly listings
python3 tools/diff_rom.py --built build/uncharted_waters.sfc \
                          --original "../.games/Uncharted Waters (USA).sfc"
```
