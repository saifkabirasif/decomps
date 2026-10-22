# Working in this repository

Decompilation projects for retro games.  The active project is
`UnchartedWaters/`: SNES *Uncharted Waters* (USA), rebuilt as byte-exact
WLA DX assembly with a cross-platform asset editor in Avalonia.

## Read first

1. This file.
2. `UnchartedWaters/docs/STATE.md` - where the work stands, what is next.
3. `UnchartedWaters/docs/decisions.md` - why the project is built this way.
4. Only when the task touches that area: `UnchartedWaters/docs/bank-map.md`,
   `.../memory-map.md`, `.../progress.md` (history, append only).

Then run `make brief` inside `UnchartedWaters/` for the live state.  Do
not read the whole `docs/` tree to get oriented.

## Hard rules

- **Never upload or commit a ROM.**  Dumps live in `.games/`, which is
  git ignored; CI never sees one.  Never add a `.sfc`, `.smc`, `.fig`,
  `.spc` or a patch file to git.
- **Never `git push`.**  Commit locally; the user pushes.
- **Do not trust prose over the cartridge.**  Every claim in `STATE.md`
  has a command that proves it.  Run the command before building on it.
- **The ROM is read-only input** unless the task is explicitly about
  writing an edited image (the editor's save, `tools/palettes.py`).
- **Do not change the byte-exact regions to make a build pass.**  If
  `make verify` fails, the source is wrong; find out why.

## Commands

Run from `UnchartedWaters/`.

| Command | What it does |
|---|---|
| `make brief` | live state: git, ROM, verification, palettes, next work |
| `make brief-full` | the same, and runs both test suites |
| `make verify` | assemble and compare the ported regions (fast) |
| `make test` | Python test suite |
| `make gui` | build the editor (needs .NET 8) |
| `make gui-test` | editor test suite |
| `make rom` | assemble the cartridge |

Toolchain: WLA DX (`wla-65816`, `wlalink`), Python 3, .NET 8.  The ROM
belongs at `../.games/Uncharted Waters (USA).sfc`.  Mesen 2 lives in
`~/.config/Mesen2`; `tools/ucw/mesen.py` drives it headlessly.

## Layout

```
UnchartedWaters/
  asm/ src/ spc/     WLA DX sources for the ported regions
  tools/             analysis tools (Python)
  tools/ucw/         65816/SPC700 disassemblers, tracing, Mesen harness
  tools/gui/         the editor: Core + Gui + Core.Tests (Avalonia)
  tools/tests/       Python tests
  docs/              STATE, decisions, bank map, memory map, progress
.github/workflows/   CI: tools, tests, editor, release
```

## How to work

- Start from the `Next` list in `STATE.md`; do not invent a new direction
  without saying why the list is wrong.
- Make the smallest change that moves an item, and run the command that
  proves it.
- Add tests next to the code; the Python and editor suites are the gate.
- Commit in small steps.  The message says what changed and why.
- At the end of a session, update `UnchartedWaters/docs/STATE.md`: the
  date, what moved, what is next, and anything newly ruled out.  That
  file is the handoff.

## Done means

`make test`, `make gui-test` and `make verify` pass, the change is
committed, and `STATE.md` describes the new position.
