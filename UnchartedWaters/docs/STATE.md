# State of the work

Updated: 2026-10-22.  This is the one page a new session reads in full.
`make brief` prints the live version of it (git head, verification,
palettes and the next item), so no commit hash is written here.

## Verified now

| Check | Command | Result |
|---|---|---|
| Assembly matches the cart | `make verify` | 14/14 regions, 3,468 bytes |
| Python tools | `make test` | 105 tests |
| Editor | `make gui-test` | 77 tests |
| Palette table | `python3 tools/palettes.py` | 14 tables; 63 palettes at `$02:A526` |

## Done

- Cartridge map: 1 MiB, 32 LoROM banks, 38 named blocks (285,564 bytes).
  All 65816 code is in bank `$00`; the other banks are data.
- Byte-exact regions: `$8000-$8D4C` plus the header.
- Script machine: machine `$A0FD`, dispatch `$A797` (256 opcodes),
  pointer at DP `$0006`, block in WRAM `$2000`; operand widths
  classified across 92,156 instructions.
- Text: 2,560 strings / 41,544 bytes over all 38 blocks; read and
  written in place, shorter edits padded with spaces.
- Palettes: plain ROM data (16 BGR555 words, little endian, 32 bytes);
  14 tables found; the editor reads and writes them without the
  emulator.
- Sprites: `sgdata` = 5-byte header + 20 records of 51 bytes; the editor
  lists groups and frames.
- Graphics: the 4bpp pipeline is understood - `$B23F` builds the list at
  `$0B96`, `$88F3` copies one 32-byte tile per entry into VRAM; six
  intro regions found by matching VRAM.
- Editor (Avalonia/.NET 8): hex view, graphics, text editing, sprites,
  palette editing, memory search, save.  v0.1.0 published for win-x64
  and linux-x64.
- CI: four workflows (tools, Python tests, editor tests, release); the
  cartridge never reaches CI.

## In flight

Nothing is half-written: the last change is committed and both suites
pass.  The next piece of work starts at item 1 below.

## Next

1. Decode the encoded script.  It is the keystone: the palette address
   `$02:A526` appears in the encoded data of bank `$01`, and the engine
   command table is at `$9A00` (71 entries; 43-47 pictures, 69-70
   palettes).  Decoding it yields the picture list, the
   picture-to-palette mapping and the portraits.
2. List the pictures in the editor with their palettes; add PNG
   import/export.
3. Derive the portraits from the picture list and the sprite tables.
4. Find the SPC700 sound program, then build the music editor.
5. Close the untraced gaps in bank `$00` (`$BF22-$CCAD`, `$DA5C-$E260`,
   `$D0CC-$D8AD`, `$F0AB-$FC0E`) and lift more of it to WLA DX.
6. Package a Windows exe with Mesen embedded.

## Addresses that matter

| Address | Meaning |
|---|---|
| `$A0FD` | script machine |
| `$A797` | script dispatch table (256 opcodes) |
| `$9A00` | engine command table, 71 entries (43-47 pictures, 69-70 palettes) |
| `$9C3D` | descriptor reader / pointer chase |
| `$B23F` | build the graphics list `$0B96` from the descriptor |
| `$88F3` | render the list to VRAM, one 32-byte (4bpp) tile per entry |
| `$B77C` | palette loader: copy from `$60`/`$62` into `$0CC8` |
| `$8A81` | write `$0CC8` to CGRAM (`$2121`/`$2122`) |
| `$02:A526` | palette table, 63 palettes (file `$012526`) |
| `$0B96` | graphics list: 3-byte ROM addresses |
| `$0CC8` | palette buffer (not a flat copy of the ROM palette) |
| `$F800` | asset table: 38 blocks, 16-byte records |
| `$8378`, `$9587` | joypad reads (patch sites for `tools/patchinput.py`) |

## Ruled out

- **Headless Mesen has no key map.**  `GetKeyCode` answers 0 for every
  name, so nothing pressed reaches the game.  `tools/patchinput.py`
  patches the two joypad reads to make a self-playing cart, but a static
  patch cannot produce a button *edge*, so it stalls on the character
  screen.
- **CGRAM is static during play.**  Palettes are loaded once, so
  watching the colour memory does not reveal which picture uses which
  palette.
- **`$0CC8` is not a flat copy of a ROM palette.**  Do not use it as the
  palette source; search the cartridge for the table instead.
- **The character-map screen does not use the 4bpp renderer.**  Its
  tiles are not in the ROM verbatim; something expands 4bpp to 8bpp at
  runtime, and that path is not traced yet.
- **Engine commands are not script instructions.**  The script machine
  never calls the engine; the command stream is encoded inside the
  blocks.

## Open questions

- What is the format of the encoded script / engine command stream?
- Which routine expands 4bpp to 8bpp for the character and portrait
  screens?
- Where do the portrait descriptors live?
- Where is the SPC700 program?

## Handoff

Paste this when starting with a new session or model:

> Read `AGENTS.md` and `UnchartedWaters/docs/STATE.md` only.  Run
> `make brief` in `UnchartedWaters/`.  Start at the first item under
> `Next`.  Do not push; commit locally.
