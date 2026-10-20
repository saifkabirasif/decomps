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

## Layout

```
.games/          your own ROM dumps (git ignored)
UnchartedWaters/ the decompilation project
.github/         CI workflows
```
