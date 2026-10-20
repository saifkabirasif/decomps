# .games

Drop your own copies of the original game ROMs in this folder. They are
**git-ignored** and never uploaded anywhere (CI builds only the tools and the
editor app — it never touches a ROM).

Expected file names (defaults used by the tooling):

| Game | File |
|---|---|
| Uncharted Waters | `Uncharted Waters (USA).sfc` |
| EarthBound | `EarthBound (USA).sfc` |

Both are 1:1 dumps — no copier header, no patch applied.

Every tool in this repo takes the ROM path as an argument (or uses the default
above) and validates it by size + SHA-256 before doing anything, so a wrong
or modded dump fails loudly instead of producing garbage output.
