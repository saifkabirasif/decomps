;
; Uncharted Waters (USA) - boot sequence
;
; Ported byte for byte from the original cartridge (bank $00, $8000-$805F).
;
; The original assembler sized immediate operands from the accumulator
; width only, so we pin the width down explicitly with .ACCU / .INDEX.
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0

; ---------------------------------------------------------------------------
; $8000: entry point table
; ---------------------------------------------------------------------------
.ORGA $8000

    JMP $A0FD
    JMP $A0D9
    JMP $A997
    JMP $A997
    JMP $8E04

; ---------------------------------------------------------------------------
; $800F: native mode entry (the emulation mode RESET vector points here)
; ---------------------------------------------------------------------------
.ORGA $800F

NativeEntry:
    CLC
    XCE                    ; leave emulation mode
    SEI
    REP #$30               ; 16 bit A, X and Y
    LDA #$0000
    TCD                    ; direct page = 0
    SEP #$20               ; 8 bit A
    CLD
    LDA #$00
    PHA
    PLB                    ; data bank = 0
    LDA #$80
    STA $2100              ; force blank
    STZ $4200              ; clear NMI, IRQ and auto joypad
    STZ $420C              ; disable HDMA
    STZ $420B
    .INDEX 8
    LDX #$FC             ; the original assembler sized this as 8 bit
    .INDEX 16
    PHP
    TXS                    ; stack = $01FC
    LDA #$54
    STA $6C                ; $006C - video mode / palette related
    LDA #$60
    STA $6F                ; $006F - table pointer
    REP #$20               ; 16 bit A
    LDY #$0014
    LDX #$0000

ClearWramLoop:
    LDA #$0000
    STA $1E00,X
    DEY
    BEQ ClearWramDone
    TXA
    CLC
    ADC #$000E
    TAX
    BRA ClearWramLoop

ClearWramDone:
    LDA #$0000
    STA $46                ; $0046 - counter
    LDA #$F800
    STA $44                ; $0044 - pointer to the tile table
    LDY #$0008

    LDA [$44],Y
    STA $42
    INY
    INY
    LDA [$44],Y
    STA $40
    INY
    INY
    LDA [$44],Y
    STA $4C

    LDA #$007E
    STA $46
    LDA #$2000
    STA $44
    JSR $9CBF

    REP #$10               ; 16 bit index registers
    SEP #$20               ; 8 bit accumulator
    LDX #$FFFF
    STX $32
    LDX #$8000
    STX $35

    JSR $80A0              ; PPU setup
    JSR $8190
    JSR $82B3
    JSR $82E3
    JSR $8314
    ; JML [$00809C] - jump through the main routine table.
    ; WLA sizes the long pointer from the surrounding code and emits a
    ; three byte instruction here, while the original uses the full 24 bit
    ; form (DC 9C 80 00), so the bytes are written out by hand.
    .DB $DC, $9C, $80, $00
    JSR $007E
