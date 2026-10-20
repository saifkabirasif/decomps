"""Headless Mesen harness.

Drives the Mesen SNES core through its C API (MesenCore.so) so the project
can boot the original ROM, script input and compare frames without a GUI.
"""

from __future__ import annotations

import ctypes
import os
import time
from dataclasses import dataclass
from pathlib import Path

# --- enums ---------------------------------------------------------------
MEMORY_TYPE_SNES = 0
MEMORY_TYPE_SPC = 1
MEMORY_TYPE_SNES_PRG_ROM = 14
MEMORY_TYPE_SNES_WORK_RAM = 15
MEMORY_TYPE_SNES_SAVE_RAM = 16
MEMORY_TYPE_SNES_VIDEO_RAM = 17

CPU_TYPE_SNES = 0


class TimingInfo(ctypes.Structure):
    _fields_ = [
        ("Fps", ctypes.c_double),
        ("MasterClock", ctypes.c_uint64),
        ("MasterClockRate", ctypes.c_uint32),
        ("FrameCount", ctypes.c_uint32),
        ("ScanlineCount", ctypes.c_uint32),
        ("FirstScanline", ctypes.c_int32),
        ("CycleCount", ctypes.c_uint32),
    ]


def _find_core() -> Path:
    """Locate MesenCore.so (extracted by Mesen into its home folder)."""
    candidates = [
        Path.home() / ".config" / "Mesen2" / "MesenCore.so",
        Path.home() / ".config" / "Mesen" / "MesenCore.so",
    ]
    env = os.environ.get("MESEN_CORE")
    if env:
        candidates.insert(0, Path(env))
    for candidate in candidates:
        if candidate.exists():
            return candidate
    raise FileNotFoundError(
        "MesenCore.so not found. Run Mesen once so it extracts its runtime "
        "libraries, or set MESEN_CORE to the library path."
    )


class Mesen:
    """A headless Mesen instance."""

    def __init__(self, home: Path | None = None, verbose: bool = False) -> None:
        self.core_path = _find_core()
        self.home = Path(home) if home else Path.home() / ".config" / "Mesen2"
        self.home.mkdir(parents=True, exist_ok=True)
        self.verbose = verbose
        self._lib = ctypes.CDLL(str(self.core_path))
        self._setup()

    def _setup(self) -> None:
        lib = self._lib
        lib.InitializeEmu.restype = None
        lib.InitializeEmu.argtypes = [
            ctypes.c_char_p,  # home folder
            ctypes.c_void_p,  # window handle
            ctypes.c_void_p,  # dx viewer handle
            ctypes.c_bool,  # use software renderer
            ctypes.c_bool,  # no audio
            ctypes.c_bool,  # no video
            ctypes.c_bool,  # no input
        ]
        lib.LoadRom.restype = ctypes.c_bool
        lib.LoadRom.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
        lib.IsRunning.restype = ctypes.c_bool
        lib.IsRunning.argtypes = []
        lib.Stop.restype = None
        lib.Stop.argtypes = []
        lib.Release.restype = None
        lib.Release.argtypes = []
        lib.GetMemoryValue.restype = ctypes.c_ubyte
        lib.GetMemoryValue.argtypes = [ctypes.c_int, ctypes.c_uint32]
        lib.GetMemoryValues.restype = None
        lib.GetMemoryValues.argtypes = [
            ctypes.c_int,
            ctypes.c_uint32,  # start address
            ctypes.c_uint32,  # end address (inclusive)
            ctypes.POINTER(ctypes.c_ubyte),
        ]
        lib.GetTimingInfo.restype = TimingInfo
        lib.GetTimingInfo.argtypes = [ctypes.c_int]
        lib.SetKeyState.restype = None
        lib.SetKeyState.argtypes = [ctypes.c_uint16, ctypes.c_bool]
        lib.GetKeyCode.restype = ctypes.c_uint16
        lib.GetKeyCode.argtypes = [ctypes.c_char_p]
        lib.ResetKeyState.restype = None
        lib.ResetKeyState.argtypes = []
        lib.TakeScreenshot.restype = None
        lib.TakeScreenshot.argtypes = []
        lib.Pause.restype = None
        lib.Pause.argtypes = []
        lib.Resume.restype = None
        lib.Resume.argtypes = []
        lib.GetLog.restype = None
        lib.GetLog.argtypes = [ctypes.c_void_p, ctypes.c_int]

    # -- lifecycle ---------------------------------------------------------
    def init(self, software_renderer: bool = True, audio: bool = False) -> None:
        # InitDll() creates and initialises the emulator instance; without it
        # LoadRom() dereferences a null game client and crashes.
        self._lib.InitDll.restype = None
        self._lib.InitDll.argtypes = []
        self._lib.InitDll()
        self._lib.InitializeEmu(
            str(self.home).encode(),
            None,
            None,
            software_renderer,
            not audio,
            False,
            False,
        )

    def load_rom(self, path: Path | str) -> bool:
        ok = self._lib.LoadRom(str(path).encode(), None)
        if self.verbose:
            print(f"load_rom({path}) -> {ok}")
        return ok

    def release(self) -> None:
        """Stop the emulator.

        Do not call Release(): tearing the core down while the emulation
        thread is still alive crashes the process.  Letting the process exit
        is fine.
        """
        try:
            self._lib.Stop()
        except Exception:  # pragma: no cover - best effort teardown
            pass
        time.sleep(0.2)

    def program_counter(self) -> int:
        """The current program counter (16 bit in native mode)."""
        self._lib.GetProgramCounter.restype = ctypes.c_uint32
        self._lib.GetProgramCounter.argtypes = [ctypes.c_int, ctypes.c_bool]
        return int(self._lib.GetProgramCounter(CPU_TYPE_SNES, False))

    def init_debugger(self) -> None:
        """Enable the debugger API (needed for memory and PC access)."""
        self._lib.InitializeDebugger.restype = None
        self._lib.InitializeDebugger.argtypes = []
        self._lib.InitializeDebugger()

    # -- state -------------------------------------------------------------
    def frame_count(self) -> int:
        return int(self._lib.GetTimingInfo(CPU_TYPE_SNES).FrameCount)

    def read_memory(self, mem_type: int, address: int, length: int) -> bytes:
        """Read `length` bytes starting at `address`."""
        end = address + length - 1
        buf = (ctypes.c_ubyte * length)()
        self._lib.GetMemoryValues(mem_type, ctypes.c_uint32(address), ctypes.c_uint32(end), buf)
        return bytes(buf)

    def read_byte(self, mem_type: int, address: int) -> int:
        return int(self._lib.GetMemoryValue(mem_type, ctypes.c_uint32(address)))

    def log(self) -> str:
        size = 65536
        buf = ctypes.create_string_buffer(size)
        self._lib.GetLog(buf, size)
        return buf.value.decode("utf-8", "replace")

    # -- input -------------------------------------------------------------
    def key_code(self, name: str) -> int:
        return int(self._lib.GetKeyCode(name.encode()))

    def press(self, name: str, pressed: bool = True) -> None:
        self._lib.SetKeyState(self.key_code(name), pressed)

    def tap(self, name: str, frames: int = 3) -> None:
        """Press and release a key over the next `frames` frames."""
        self.press(name, True)
        self.wait_frames(frames)
        self.press(name, False)

    # -- running -----------------------------------------------------------
    def wait_frames(self, count: int, timeout: float = 30.0) -> int:
        """Wait until at least `count` more frames have been rendered."""
        target = self.frame_count() + count
        deadline = time.time() + timeout
        while time.time() < deadline:
            if self.frame_count() >= target:
                return self.frame_count()
            time.sleep(0.005)
        raise TimeoutError(
            f"emulator did not reach frame {target} (at {self.frame_count()})"
        )

    def run_frames(self, count: int) -> None:
        self.wait_frames(count)

    def screenshot(self) -> Path | None:
        """Take a screenshot; returns the newest PNG in the screenshots folder."""
        shots = sorted(self.home.glob("Screenshots/*.png"), key=lambda p: p.stat().st_mtime)
        before = shots[-1] if shots else None
        self._lib.TakeScreenshot()
        time.sleep(0.3)
        shots = sorted(self.home.glob("Screenshots/*.png"), key=lambda p: p.stat().st_mtime)
        if shots and (before is None or shots[-1] != before):
            return shots[-1]
        return shots[-1] if shots else None


@dataclass
class Probe:
    """Result of probing the emulator's view of memory."""

    name: str
    address: int
    data: bytes
