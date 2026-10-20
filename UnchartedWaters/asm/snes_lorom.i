;
; SNES LoROM memory map for WLA DX.
;
; "Uncharted Waters" (USA) is a 1 MiB LoROM cartridge: 32 banks of 32 KiB,
; with bank N mapped at $N:8000-$FFFF.  This was verified against the
; cartridge's own header and by comparing the emulator's view of memory
; with the ROM image (see docs/memory-map.md).
;

.MEMORYMAP
  SLOTSIZE $8000
  DEFAULTSLOT 0
  SLOT 0 $8000
.ENDME

.ROMBANKSIZE $8000
.ROMBANKS 32

.EMPTYFILL $00
