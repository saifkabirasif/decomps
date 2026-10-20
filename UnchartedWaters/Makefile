# Uncharted Waters (USA) - decompilation project
#
# Targets:
#   make rom    assemble the ROM with WLA DX (assembler + linker)
#   make disasm analyse the original ROM and write disassembly listings
#   make diff   compare the built ROM against the original dump
#   make test   run the Python test suite
#
# The original ROM is *not* part of this repository: put your own copy in
# ../../.games/ (see ../../.games/README.md).

WLA        ?= wla-65816
WLALINK    ?= wlalink
PYTHON     ?= python3

BUILD_DIR  := $(CURDIR)/build
DISASM_DIR := $(BUILD_DIR)/disasm
ROM_BUILT  := $(BUILD_DIR)/uncharted_waters.sfc
ROM_ORIG   := $(CURDIR)/../.games/Uncharted Waters (USA).sfc

ASM_SOURCES := $(wildcard asm/*.s) $(wildcard src/*.s) $(wildcard spc/*.s)
OBJECTS     := $(patsubst %.s,$(BUILD_DIR)/%.o,$(notdir $(ASM_SOURCES)))

.PHONY: all rom tools disasm diff test clean check-toolchain

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

rom: tools $(BUILD_DIR)/asm/main.o
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

test:
	$(PYTHON) -m pytest tools/tests -q

clean:
	rm -rf $(BUILD_DIR)
