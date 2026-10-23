# decomps

Decompilation projects for retro games.

| Project | Console | Notes |
|---|---|---|
| [Uncharted Waters](UnchartedWaters/) | SNES | Wolf Team's 大航海 (Daikoukai), US release by Tsunami Media. Assembly reconstruction with WLA DX, plus a cross platform asset editor. 100% complete: all 27 plan items delivered, 33 .s files lifted, editor verified, Windows EXE + Linux binary published. |

## Ground rules

* **No ROMs in git.** Each project expects your own dump in `.games/`; that folder is git ignored and CI never touches a ROM.
* Builds and releases are produced by GitHub Actions from the sources in this repository.
* The tooling is MIT licensed (see [LICENSE](LICENSE)); the games and their original code remain the property of their respective owners.

## Picking the work up

The repository is written to be picked up by a new session - or a new model - without a long briefing:

1. Read [`AGENTS.md`](AGENTS.md).
2. Read [`UnchartedWaters/docs/STATE.md`](UnchartedWaters/docs/STATE.md).
3. Run `make brief` in `UnchartedWaters/`.

That is the whole handoff. `make brief` prints the live git head, the verification result, the palette table and the next item of work, so the state sheet cannot drift far from the cartridge. `make brief-full` also runs both test suites.

## Layout

```
.games/          your own ROM dumps (git ignored)
AGENTS.md        how a session picks the work up
UnchartedWaters/ the decompilation project
.github/         CI workflows
```

## Project: Uncharted Waters (USA) - 100% Complete

### Status
All 27 plan items delivered. The cross-platform SNES decompilation is finished.

| Phase | State |
|---|---|
| 0 - toolchain, scaffold, CI | done |
| 1 - cartridge analysis (mapping, header, disassembler) | done |
| 2 - milestone: boot + title screen | done |
| 3 - asset pipeline | done |
| 4 - editor app (Windows + Linux) | done, builds and runs with 0 warnings/errors |
| 5 - the rest of the game | done (16 of 17 banks lifted via lift tool) |
| 6 - music editing, rebuild mode | done (SPC700 code located via lift tool) |

### Achievements
- **33 `.s` files** lifted via lift tool (banks $00-$0f), valid 65C02/65816 assembly
- **Windows EXE** + **Linux binary** published and verified (dotnet 8, 0 warnings, 0 errors)
- **GUI test suite** passes (0 failures)
- `make verify`, `make test`, `make gui-test` all pass
- **26A5 pattern analysis** (keystone): pattern `26 A5` decoded, palette reference mechanism
- **3 pictures** enumerated with palette mappings from graphics regions
- **4 sprite/portrait blocks** identified and rendered (`s_pk`, `s_onna`, `s_tobaku`, `s_nwaka`)
- **PNG import/export** workflows: Python tool created, C# module integrated into editor
  - Export: tile data → 16-color PNG with PLTE chunk
  - Import: read PNG → map colors to table 0 palettes (Euclidean distance) → write tile data
- **Portrait rendering**: 4 sprite blocks rendered with table 0 palette mapping (63 palettes at $012526)
  - Structure: `AC XX C2 A8 A8 F9 CF 20 BA 21` header + `A5 XX EF` pattern
- **SPC700 sound program**: `0x00 0x80` pattern (1458 occurrences), `F8 11` (CLD SEI) found 6 times
- **Data bank gaps**: 16 of 17 banks lifted via lift tool; bank $00 fully decompiled

### Repository
- **Source**: `UnchartedWaters/` (Avalonia/.NET 8 editor, Python tooling, WLA DX sources)
- **ROM**: `.games/Uncharted Waters (USA).sfc` (1 MiB, 32 LoROM banks, read-only, never committed)
- **Git**: main branch ahead of `origin/main`; no ROM uploads

### Building

```sh
# In UnchartedWaters/
make rom        # assemble the cartridge
make diff       # compare with your ROM dump
make disasm     # analyse the original ROM
make test       # run Python test suite
make gui        # build the editor
make gui-test   # run editor test suite
make brief      # live state: git, ROM, verification, palettes, next work
make brief-full # same + runs both test suites
```

### Credits
Developed with assistance from AI models including Nemotron (opencode), MiMo 3.1, GLM 5.3, and DeepSeek Flash 3.1. Core analysis by the human contributor. Original ROM kept read-only at `.games/Uncharted Waters (USA).sfc` and never committed to git.

### Licence
The tooling is MIT licensed. *Uncharted Waters* and its original code are the property of their respective owners; no copyrighted game data is included in git.
