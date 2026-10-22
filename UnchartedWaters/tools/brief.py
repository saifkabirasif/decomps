#!/usr/bin/env python3
"""Print the live state of the project in one screen.

This is the first command to run when the work is picked up, and the
first command for a new session or a new model.  Everything it prints is
read from the repository, the cartridge or the build, so the page cannot
go stale the way prose does.

Usage:
    python3 tools/brief.py
    python3 tools/brief.py --full
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from ucw.rom import find_rom, parse_header  # noqa: E402

#: The project root, one level above ``tools``.
PROJECT = Path(__file__).resolve().parents[1]

#: The handoff sheet.
STATE = PROJECT / "docs" / "STATE.md"

#: What the coverage sweep last wrote.
COVERAGE = PROJECT / "build" / "coverage.json"

#: A list marker at the start of a line: ``-``, ``*`` or ``1.``.
BULLET = re.compile(r"^\s*(?:[-*]|\d+\.)\s+")


def next_items(text: str) -> list[str]:
    """The items of the ``## Next`` section, joined and without markers."""
    items: list[str] = []
    inside = False
    for line in text.splitlines():
        if line.startswith("## "):
            if inside:
                break
            inside = line.strip().lower() == "## next"
            continue
        if not inside:
            continue
        stripped = line.strip()
        if not stripped:
            continue
        if BULLET.match(line):
            items.append(BULLET.sub("", stripped))
        elif items:
            # Wrapped lines of the item above.
            items[-1] = f"{items[-1]} {stripped}"
    return items


def human_bytes(size: int) -> str:
    """A size that is easy to read."""
    if size >= 1024 * 1024:
        return f"{size / (1024 * 1024):.1f} MiB"
    if size >= 1024:
        return f"{size / 1024:.0f} KiB"
    return f"{size} bytes"


def _run(command: list[str]) -> tuple[int, str]:
    """Run a command in the project, returning its status and output."""
    try:
        done = subprocess.run(
            command,
            cwd=PROJECT,
            capture_output=True,
            text=True,
            timeout=300,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        return 1, str(error)
    return done.returncode, (done.stdout + done.stderr).strip()


def _last_line(output: str) -> str:
    """The last line that is not make talking about itself."""
    lines = [
        line
        for line in output.splitlines()
        if line.strip() and not line.startswith(("make[", "make:"))
    ]
    return lines[-1] if lines else ""


def git_state() -> str:
    """The branch, the head, how it compares with origin, and dirt."""
    code, head = _run(["git", "rev-parse", "--short", "HEAD"])
    if code != 0:
        return "not a git repository"

    _, branch = _run(["git", "rev-parse", "--abbrev-ref", "HEAD"])
    _, status = _run(["git", "status", "--porcelain"])
    changed = sum(1 for line in status.splitlines() if line.strip())

    relation = ""
    code, counts = _run(
        ["git", "rev-list", "--count", "--left-right", "origin/main...HEAD"]
    )
    if code == 0 and counts:
        behind, ahead = (int(part) for part in counts.split())
        if ahead and behind:
            relation = f", {ahead} ahead and {behind} behind origin/main"
        elif ahead:
            relation = f", {ahead} ahead of origin/main (not pushed)"
        elif behind:
            relation = f", {behind} behind origin/main"
        else:
            relation = ", in sync with origin/main"

    dirt = "clean"
    if changed:
        dirt = f"{changed} uncommitted file{'s' if changed != 1 else ''}"
    return f"{branch or '?'} @ {head}{relation}, {dirt}"


def rom_state() -> str:
    """The cartridge that the checks will read, and its header checksum."""
    try:
        path = find_rom()
    except FileNotFoundError:
        return "not found - put your dump in .games/"
    data = path.read_bytes()
    header = parse_header(data)
    return (
        f"{path.name} ({human_bytes(len(data))}, "
        f"header checksum ${header.checksum:04X})"
    )


def verify_state() -> str:
    """Assemble the ported regions and report the comparison."""
    code, output = _run(["make", "verify"])
    if code != 0 and "not found" in output:
        return "toolchain missing - run make tools"
    summary = _last_line(output)
    if not summary:
        return "no output"
    return summary if code == 0 else f"FAILED - {summary}"


def palette_state() -> str:
    """The biggest palette table in the cartridge."""
    try:
        import palettes
    except ImportError as error:  # pragma: no cover - the file is local
        return str(error)

    try:
        data = find_rom().read_bytes()
    except FileNotFoundError:
        return "no cartridge"

    tables = palettes.find_tables(data)
    if not tables:
        return "no table found"
    first = tables[0]
    return (
        f"{len(first.palettes)} palettes at file ${first.start:06X} "
        f"(${first.start // 0x8000:02X}:"
        f"${0x8000 + first.start % 0x8000:04X}), "
        f"{len(tables)} tables in the cartridge"
    )


def coverage_state() -> str:
    """What the last coverage sweep saw the processor execute."""
    if not COVERAGE.exists():
        return "no cache - run python3 tools/bankmap.py --coverage 60"
    try:
        data = json.loads(COVERAGE.read_text())
    except (OSError, json.JSONDecodeError) as error:
        return f"unreadable: {error}"
    executed = data.get("executed", {})
    if not executed:
        return "empty"
    parts = [
        f"{bank}: {len(info.get('addresses', []))} addresses"
        for bank, info in sorted(executed.items())
    ]
    return ", ".join(parts)


def test_state(full: bool) -> str:
    """The test suites, run only when asked because they are slow."""
    if not full:
        return "run make test and make gui-test (or --full)"

    results: list[str] = []
    for label, target in (("python", "test"), ("editor", "gui-test")):
        command = ["make", target]
        if target == "gui-test":
            dotnet = shutil.which("dotnet")
            if dotnet is None:
                fallback = Path.home() / ".dotnet" / "dotnet"
                dotnet = str(fallback) if fallback.exists() else None
            if dotnet is None:
                results.append(f"{label}: dotnet not found")
                continue
            command.append(f"DOTNET={dotnet}")

        code, output = _run(command)
        summary = _last_line(output) or "no output"
        results.append(f"{label}: {'ok' if code == 0 else 'FAILED'} ({summary})")
    return "; ".join(results)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--full",
        action="store_true",
        help="also run the Python and editor test suites",
    )
    args = parser.parse_args()

    print("Uncharted Waters (USA) - brief")
    print(f"date      {date.today().isoformat()}")
    print(f"git       {git_state()}")
    print(f"rom       {rom_state()}")
    print(f"verify    {verify_state()}")
    print(f"tests     {test_state(args.full)}")
    print(f"palettes  {palette_state()}")
    print(f"coverage  {coverage_state()}")

    if STATE.exists():
        items = next_items(STATE.read_text())
        if items:
            print("next")
            for number, item in enumerate(items, 1):
                print(f"  {number}. {item}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
