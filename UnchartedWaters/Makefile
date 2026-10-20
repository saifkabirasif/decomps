# Uncharted Waters (USA) - decompilation project
#
# Targets:
#   make rom    assemble the ROM with WLA DX (assembler + linker)
#   make diff   compare the built ROM against the original dump
#   make verify check every ported region byte for byte
#   make disasm analyse the original ROM and write disassembly listings
#   make test   run the Python test suite
#   make gui    build the editor app (needs the .NET SDK)
#   make gui-test   run the editor's xunit tests
#
# The original ROM is *not* part of this repository: put your own copy in
# ../../.games/ (see ../../.games/README.md).

WLA        ?= wla-65816
WLALINK    ?= wlalink
PYTHON     ?= python3
DOTNET     ?= dotnet

BUILD_DIR  := $(CURDIR)/build
DISASM_DIR := $(BUILD_DIR)/disasm
ROM_BUILT  := $(BUILD_DIR)/uncharted_waters.sfc
GUI_DIR    := $(CURDIR)/tools/gui
GUI_SLN    := $(GUI_DIR)/UnchartedWaters.sln

# The name is kept in its own variable: "make" would otherwise try to expand
# the "(USA)" part as a variable reference.
ROM_NAME   := Uncharted Waters (USA).sfc
ROM_ORIG   := $(CURDIR)/../.games/$(ROM_NAME)

ASM_SOURCES := $(wildcard asm/*.s) $(wildcard src/*.s) $(wildcard spc/*.s)
OBJECTS     := $(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

.PHONY: all rom tools disasm diff verify test clean check-toolchain gui gui-test

all: rom

# --- toolchain ------------------------------------------------------------
tools:
	@command -v $(WLA) >/dev/null 2>&1 || { \
		echo "error: $(WLA) not found. Build WLA DX with:"; \
		echo "  git clone https://github.com/vhelin/wla-dx && cd wla-dx"; \
		echo "  cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build"; \
		echo "  cmake -P build/cmake_install.cmake"; \
		exit 1; }
	@command -v $(WLALINK) >/dev/null 2>&1 || { \
		echo "error: $(WLALINK) not found (it comes with WLA DX)"; exit 1; }

check-toolchain: tools
	@$(WLA) --version || true

# --- build ----------------------------------------------------------------
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(WLA) -I $(CURDIR)/asm -o $@ $<

# The link file lists the objects explicitly, so it has to be regenerated
# whenever a source file is added.
asm/linkfile: $(ASM_SOURCES)
	@printf '[objects]\n' > $@
	@for src in $(ASM_SOURCES); do \
		obj=$$(basename $$src .s); \
		printf 'build/%s/%s.o\n' "$$(dirname $$src)" "$$obj" >> $@; \
	done

rom: tools $(OBJECTS) asm/linkfile
	@mkdir -p $(BUILD_DIR)
	$(WLALINK) asm/linkfile $(ROM_BUILT)
	@echo "built $(ROM_BUILT)"

# --- analysis -------------------------------------------------------------
disasm:
	@mkdir -p $(DISASM_DIR)
	$(PYTHON) tools/analyze.py --out $(DISASM_DIR)

# --- verification ---------------------------------------------------------
diff: rom
	$(PYTHON) tools/diff_rom.py --built $(ROM_BUILT) --original "$(ROM_ORIG)"

verify: rom
	$(PYTHON) tools/verify.py --built $(ROM_BUILT) --original "$(ROM_ORIG)"

test:
	$(PYTHON) -m pytest tools/tests -q

# --- editor app -----------------------------------------------------------
# The GUI is a .NET solution.  The binaries are published by CI, this is
# only for working on it locally.

gui:
	@command -v $(DOTNET) >/dev/null 2>&1 || { \
		echo "error: $(DOTNET) not found. Install the .NET 8 SDK from"; \
		echo "  https://dotnet.microsoft.com/download/dotnet/8.0"; \
		exit 1; }
	$(DOTNET) build $(GUI_SLN) -c Release

gui-test:
	$(DOTNET) test $(GUI_SLN) -c Release

clean:
	rm -rf $(BUILD_DIR)
