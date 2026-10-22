# Decisions

Why the project is built this way.  One entry per choice that would
otherwise be argued again.  Add a new one when a decision is made, and
say what it costs.

- **WLA DX for the assembly.**  It assembles the 65816 sources and links
  the cartridge; `make verify` compares the result with the dump.  The
  opcode tables of the disassembler are generated from WLA's own table,
  so the two can never disagree.

- **Byte-exactness is the gate.**  A region is "ported" only when
  `make verify` says it matches.  Analysis that is not proven stays in
  `docs/` as a claim with the command that shows it.

- **Python for analysis, C# for the editor.**  The tools walk the
  cartridge and drive the emulator; `UnchartedWaters.Core` repeats only
  the asset logic the editor needs (asset table, text, palettes, tiles).
  The two implementations are kept honest by tests on the real cartridge
  where it is present.

- **Avalonia on .NET 8, three projects** (`Core`, `Gui`, `Core.Tests`).
  One codebase for Windows and Linux, and the asset logic is testable
  without a window.

- **The ROM never leaves the machine.**  Dumps live in `.games/` (git
  ignored); CI builds tools and publishes binaries, never a cartridge.
  Cost: CI cannot run the tests that need the original dump, so those
  tests return quietly when it is absent.

- **The user pushes.**  The agent commits locally; `git push` is the
  user's.  Cost: the local branch can run ahead, which `make brief`
  reports.

- **Palettes are plain ROM data.**  Sixteen BGR555 words, little endian,
  32 bytes; not something the game synthesises.  The table search in
  `tools/palettes.py` is the source of truth.

- **Music last.**  The SPC700 program has not been located and does not
  block the graphics, text or palette work.  Cost: the sound editor is
  the last asset class to arrive.

- **The editor does not need the emulator for static assets.**  CGRAM is
  read only when the live state of the game is the question; palettes
  and text are edited straight from the image.

- **One page of state, one page of rules.**  Orientation is
  `AGENTS.md` + `docs/STATE.md` + `make brief`; the long documents are
  reference, not an introduction.  Cost: `STATE.md` has to be updated
  at the end of each session, or the handoff rots.
