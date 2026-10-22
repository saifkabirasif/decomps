# decomps

Decompilation projects for retro games.

| Project | Console | Notes |
|---|---|---|
| [Uncharted Waters](UnchartedWaters/) | SNES | Wolf Team's 大航海 (Daikoukai), US release by Tsunami Media. Assembly reconstruction with WLA DX, plus a cross platform asset editor. |

## Ground rules

* **No ROMs in git.** Each project expects your own dump in `.games/`;
  that folder is git ignored and CI never touches a ROM.
* Builds and releases are produced by GitHub Actions from the sources in
  this repository.
* The tooling is MIT licensed (see [LICENSE](LICENSE)); the games and their
  original code remain the property of their respective owners.

## Picking the work up

The repository is written to be picked up by a new session - or a new
model - without a long briefing:

1. Read [`AGENTS.md`](AGENTS.md).
2. Read [`UnchartedWaters/docs/STATE.md`](UnchartedWaters/docs/STATE.md).
3. Run `make brief` in `UnchartedWaters/`.

That is the whole handoff.  `make brief` prints the live git head, the
verification result, the palette table and the next item of work, so the
state sheet cannot drift far from the cartridge.  `make brief-full` also
runs both test suites.

## Layout

```
.games/          your own ROM dumps (git ignored)
AGENTS.md        how a session picks the work up
UnchartedWaters/ the decompilation project
.github/         CI workflows
```
