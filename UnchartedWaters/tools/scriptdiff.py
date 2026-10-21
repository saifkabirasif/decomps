#!/usr/bin/env python3
"""Find out what a byte in a script block of the cartridge does.

The script blocks hold the text of the game in the clear, with other bytes
in between that the game interprets.  This tool works out what those
bytes are by changing them and looking at what the game does
afterwards: the cartridge is patched, the game is booted and the video
and work memory are compared with a run of the unpatched cartridge.

A byte that changes the text on the screen commands the text, a byte that
changes the colours is a colour command, and so on.

Usage:
    python3 tools/scriptdiff.py --block s_nwaka --sweep 8-40
    python3 tools/scriptdiff.py --block s_nwaka --at 0x10 --value 0x00
    python3 tools/scriptdiff.py --block s_nwaka --sweep 8-40 --json
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import tempfile
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from asset_table import parse_table  # noqa: E402

#: The keys that are pressed to get the game going.
KEYS = ("Enter", "X", "Z")

#: How long to wait before the memory is looked at.  The game shows its
#: text in a box and moves on after a while, so the memory is only read
#: once the picture has stopped changing.  That way every run ends at the
#: same place, whatever the speed of the machine.
STABLE_READS = 3

#: How long to wait between two reads, in seconds.
SETTLE = 0.7

#: The picture has to have changed at least this often before a steady
#: picture is accepted.  The game starts with a few screens that do not
#: move, and the interesting one comes later.
MIN_CHANGES = 4

#: How long to wait at most before the memory is read anyway.
MAX_WAIT = 180.0

#: How many frames after the start of the introduction are looked at, and
#: how far apart they are.  A window of zero looks at one picture only,
#: which gives the cleanest result: two runs of the same cartridge then
#: do not differ at all.  A wider window catches a command that changes
#: the text a little later, but the runs drift apart a little as well.
WINDOW = 0
WINDOW_STEP = 150

#: A few places of the video memory that only hold the expected value when
#: the game shows the text of the introduction.  The tool waits for them,
#: so that every run ends at the same place whatever the speed of the
#: machine is.
#: The frame the introduction of the game is on the screen.  It is
#: worked out the first time the tool runs and then used for every run.
DIALOGUE_FRAME = None

DIALOGUE_MARKERS = {
    0x0010: 0x10,
    0x0046: 0x00,
    0x007E: 0x06,
    0x00BA: 0x6C,
    0x00F8: 0xC7,
    0x012A: 0x00,
    0x0162: 0x0C,
    0x0194: 0x00,
}



def _load_mesen():
    """Import the Mesen harness, with the library path set up."""
    home = Path.home() / ".config" / "Mesen2"
    os.environ.setdefault("LD_LIBRARY_PATH", str(home))
    from ucw.mesen import (  # noqa: E402
        MEMORY_TYPE_SNES_VIDEO_RAM,
        MEMORY_TYPE_SNES_WORK_RAM,
        Mesen,
    )

    return Mesen, MEMORY_TYPE_SNES_VIDEO_RAM, MEMORY_TYPE_SNES_WORK_RAM


def _boot(rom_path: Path, picture: bytes | None = None):
    """Boot the cartridge and return the video and the work memory.

    When a picture is given, the game is run until that exact picture is
    on the screen.  That pins every run to the same place, whatever the
    speed of the machine is.
    """
    Mesen, video_type, work_type = _load_mesen()

    mesen = Mesen()
    mesen.init()
    if not mesen.load_rom(rom_path):
        raise RuntimeError(f"the emulator refused to load {rom_path}")

    mesen.init_debugger()

    for key in KEYS:
        try:
            mesen.tap(key, 3)
        except Exception:
            pass

    # The text on the screen moves on, so the picture has to be taken at
    # the same frame every time.  The frame the introduction starts on is
    # worked out once and then used for every run.  When a picture is
    # given, the game is run until that picture is on the screen, which
    # pins every run to the same place.
    global DIALOGUE_FRAME
    if DIALOGUE_FRAME is None:
        # The game shows its text in a box and moves on after a while, so
        # the frame is looked for by watching for the picture of the
        # introduction, or for the picture that was asked for.
        deadline = time.time() + MAX_WAIT
        best = -1
        while time.time() < deadline:
            video = mesen.read_memory(video_type, 0, 0x10000)
            if picture is not None:
                same = sum(1 for a, b in zip(video, picture) if a == b)
                if same > best:
                    best = same
                    DIALOGUE_FRAME = mesen.frame_count()
                if same == len(picture):
                    break
            elif all(
                video[off] == value for off, value in DIALOGUE_MARKERS.items()
            ):
                break
            time.sleep(SETTLE)
        if picture is not None:
            print(f"the picture that was asked for was {best} of "
                  f"{len(picture)} bytes", flush=True)
    else:
        try:
            mesen.wait_frames(DIALOGUE_FRAME, timeout=MAX_WAIT)
        except Exception:
            pass
        video = mesen.read_memory(video_type, 0, 0x10000)

    # The text on the screen moves on, so one picture only shows the part
    # of the dialogue that is being read at that moment.  With a window
    # of more than one frame a few pictures after each other are taken,
    # so that a command which changes any of the lines that are read in
    # that stretch shows up.
    frames = b""
    for step in range(0, max(1, WINDOW), WINDOW_STEP):
        try:
            mesen.wait_frames(DIALOGUE_FRAME + step, timeout=MAX_WAIT)
        except Exception:
            pass
        frames += mesen.read_memory(video_type, 0, 0x10000)
    video = frames

    work = mesen.read_memory(work_type, 0, 0x10000)
    mesen.release()

    return video, work


def _diff(a: bytes, b: bytes) -> list[int]:
    """The places where the two pictures differ."""
    return [i for i, (x, y) in enumerate(zip(a, b)) if x != y]


def _find_block(rom: bytes, name: str):
    """Look a block of the cartridge up by name."""
    for asset in parse_table(rom):
        if asset.name == name:
            return asset
    raise SystemExit(f"there is no block called {name!r}")


def run(
    rom_path: Path,
    block: str,
    probes: list[tuple[int, int | None]],
    picture: bytes | None = None,
    save_picture: Path | None = None,
) -> dict:
    """Run the probes and report what changed."""
    original = rom_path.read_bytes()
    asset = _find_block(original, block)
    base = original[asset.file_offset : asset.file_offset + asset.length]

    print(f"block {block}: {len(base)} bytes at file 0x{asset.file_offset:06X}", flush=True)

    print("running the unpatched cartridge twice for the comparison...", flush=True)
    video0, work0 = _boot(rom_path, picture)
    if save_picture is not None:
        save_picture.write_bytes(video0[:0x10000])
        print(f"  the picture was written to {save_picture}", flush=True)
    video1, work1 = _boot(rom_path, picture)
    noise_video = len(_diff(video0, video1))
    noise_work = len(_diff(work0, work1))
    print(
        f"  two runs of the same cartridge differ by {noise_video} bytes of "
        f"video and {noise_work} bytes of work memory",
        flush=True,
    )

    results = []
    for offset, value in probes:
        if offset < 0 or offset >= len(base):
            continue

        # Without a value the byte is changed to something else, so that
        # the effect of the place can be seen.  A letter is changed into
        # another letter, because a byte outside the letters is not drawn
        # at all and would show nothing.
        if value is not None:
            written = value
        elif 0x20 <= base[offset] < 0x7F:
            written = ord("X") if base[offset] != ord("X") else ord("Y")
        else:
            written = base[offset] ^ 0xFF
        patched = bytearray(original)
        patched[asset.file_offset + offset] = written

        path = Path(tempfile.gettempdir()) / "ucw-scriptdiff.sfc"
        path.write_bytes(patched)
        try:
            video, work = _boot(path, picture)
        finally:
            path.unlink(missing_ok=True)

        video_diff = _diff(video0, video)
        work_diff = _diff(work0, work)

        results.append(
            {
                "offset": offset,
                "value": written,
                "original": base[offset],
                "videoBytes": len(video_diff),
                "workBytes": len(work_diff),
                "firstVideo": video_diff[0] if video_diff else None,
                "firstWork": work_diff[0] if work_diff else None,
            }
        )

        print(
            f"  +0x{offset:04X}: ${base[offset]:02X} -> ${written:02X}"
            + f": {len(video_diff)} bytes of video, {len(work_diff)} bytes of work memory",
            flush=True,
        )

    print(f"the introduction is on the screen at frame {DIALOGUE_FRAME}", flush=True)

    return {
        "block": block,
        "frame": DIALOGUE_FRAME,
        "fileOffset": asset.file_offset,
        "size": len(base),
        "noiseVideo": noise_video,
        "noiseWork": noise_work,
        "probes": results,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=None, help="cartridge to use")
    parser.add_argument("--block", required=True, help="the block to work on")
    parser.add_argument("--at", type=lambda v: int(v, 0), default=None,
                        help="the offset inside the block to change")
    parser.add_argument("--value", type=lambda v: int(v, 0), default=None,
                        help="the byte to write, keep the old one if not given")
    parser.add_argument("--sweep", default=None,
                        help="a range of offsets to try, e.g. 8-40")
    parser.add_argument("--step", type=int, default=1,
                        help="only try every n-th offset of the range")
    parser.add_argument("--picture", type=Path, default=None,
                        help="a picture of the video memory to run the game up to")
    parser.add_argument("--save-picture", type=Path, default=None,
                        help="write the picture of the run to this file")
    parser.add_argument("--window", type=int, default=None,
                        help="how many frames after the introduction to look "
                             "at, in steps of 150 frames")
    parser.add_argument("--frame", type=int, default=None,
                        help="the frame the introduction is on the screen, "
                             "so that the search can be skipped")
    parser.add_argument("--json", action="store_true", help="print the result as JSON")
    args = parser.parse_args()

    rom = args.rom
    if rom is None:
        from ucw.rom import find_rom  # noqa: E402

        rom = find_rom()

    probes: list[tuple[int, int | None]] = []
    if args.sweep:
        start, _, end = args.sweep.partition("-")
        step = max(1, args.step)
        probes = [
            (o, None)
            for o in range(int(start, 0), int(end, 0) + 1, step)
        ]
    if args.at is not None:
        probes.append((args.at, args.value))

    if not probes:
        parser.error("nothing to try, use --at or --sweep")

    if args.frame is not None:
        global DIALOGUE_FRAME
        DIALOGUE_FRAME = args.frame

    if args.window is not None:
        global WINDOW
        WINDOW = args.window

    try:
        picture = args.picture.read_bytes() if args.picture else None
        result = run(rom, args.block, probes, picture, args.save_picture)
    except Exception as exc:  # pragma: no cover - the emulator can fail in many ways
        print(f"error: {exc}", file=sys.stderr)
        return 1

    if args.json:
        print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
