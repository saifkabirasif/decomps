;
; Uncharted Waters (USA) - ROM skeleton
;
; Phase 1 of the decompilation: reproduce the cartridge's header and vector
; table byte for byte so every later change can be diffed against the
; original ROM.  The code itself lives in src/ and is added bank by bank.
;

.INCLUDE "snes_lorom.i"

; ---------------------------------------------------------------------------
; Bank 0 - header and vector table
; ---------------------------------------------------------------------------
.BANK 0 SLOT 0
.ORGA $FFC0

  ; $FFC0-$FFD4: game title, 21 bytes, padded with spaces
  .DB "UNCHARTED WATERS     "

  ; $FFD5: map mode - $20 = LoROM
  .DB $20
  ; $FFD6: cartridge type - ROM + RAM + battery
  .DB $02
  ; $FFD7: ROM size - $0A = 8 Mbit (1 MiB)
  .DB $0A
  ; $FFD8: SRAM size - $03 = 32 KiB
  .DB $03
  ; $FFD9: country - $01 = USA
  .DB $01
  ; $FFDA: licensee code
  .DB $C8
  ; $FFDB: version
  .DB $00
  ; $FFDC-$FFDD: checksum complement
  .DB $B0, $57
  ; $FFDE-$FFFF: checksum
  .DB $4F, $A8

  ; $FFE0-$FFE3: unused
  .DB $00, $00, $00, $00
  ; native mode vectors: COP, BRK, ABORT, NMI, RESET, IRQ
  .DW $0000
  .DW $0000
  .DW $0000
  .DW $8361                  ; NMI - APU port handling
  .DW $0000                  ; RESET (native) - unused, the game boots
                            ; through the emulation vector below
  .DW $9593                  ; IRQ - interrupt dispatcher

  ; $FFF0-$FFF3: unused
  .DB $00, $00, $00, $00
  ; emulation mode vectors: COP, unused, ABORT, NMI, RESET, IRQ/BRK
  .DW $0000
  .DW $0000
  .DW $0000
  .DW $0000
  .DW $800F                  ; RESET - switches the CPU to native mode
  .DW $0000
