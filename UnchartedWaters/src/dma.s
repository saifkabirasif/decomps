;
; Uncharted Waters (USA) - DMA setup routines
;
; Lifted byte for byte from the original cartridge
; (bank $00, $82B3-$8360).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $82B3
    .ACCU 8               ; the boot code leaves the accumulator 8 bit wide
    .INDEX 16              ; and the index registers 16 bit wide

    SEP #$30
    LDA #$09
    LDX #$18
    LDY #$4C
    STZ $4C
    STA $4300
    LDA #$00
    STA $2116
    STA $2117
    STA $420C
    STX $4301
    STY $4302
    STA $4303
    STA $4304
    STA $4305
    STA $4306
    LDX #$01
    STX $420B
    RTS
    SEP #$30
    LDA #$08
    LDX #$22
    LDY #$4C
    STA $4300
    LDA #$00
    STA $4C
    STA $4D
    STA $2121
    STA $420C
    STX $4301
    STY $4302
    STA $4303
    STA $4304
    STA $4305
    LDX #$02
    STX $4306
    LDX #$01
    STX $420B
    RTS
    REP #$30
    LDA #$F000
    LDX #$0000
    LDY #$0080
L831F:
    STA $0900,X
    INX
    INX
    INX
    INX
    DEY
    BNE L831F
    LDA #$0000
    TAX
    LDY #$0010
L8330:
    STA $0B00,X
    INX
    INX
    DEY
    BNE L8330
    RTS
    SEP #$20
    REP #$10
    LDX #$9AA0
    STX $CE
    LDA #$00
    STA $D0
    JSR $B855
    RTS
    SEP #$20
    SEI
    LDA #$A1
    STA $4200
    LDA #$24
    STA $4109
    STZ $410A
    STZ $4107
    STZ $4108
    RTS
