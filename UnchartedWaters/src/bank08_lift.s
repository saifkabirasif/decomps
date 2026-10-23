;
; Uncharted Waters (USA) - bank08_test
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8000-$80FF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8000

    JMP $A0FD
    JMP $A0D9
    JMP $A997
    JMP $A997
    JMP $8E04
    CLC
    XCE
    SEI
    REP #$30
    LDA #$0000
    TCD
    SEP #$20
    CLD
    LDA #$00
    PHA
    PLB
    LDA #$80
    STA $2100
    STZ $4200
    STZ $420C
    STZ $420B
    LDX #$08FC
    TXS
    LDA #$54
    STA $6C
    LDA #$60
    STA $6F
    REP #$20
    LDY #$0014
    LDX #$0000
L8041:
    LDA #$0000
    STA $1E00,X
    DEY
    BEQ L8052
    TXA
    CLC
    ADC #$000E
    TAX
    BRA L8041
L8052:
    LDA #$0000
    STA $46
    LDA #$F800
    STA $44
    LDY #$0008
    LDA [$0000]
    STA $42
    INY
    INY
    LDA [$0000]
    STA $40
    INY
    INY
    LDA [$0000]
    STA $4C
    LDA #$007E
    STA $46
    LDA #$2000
    STA $44
    JSR $9CBF
    REP #$10
    SEP #$20
    LDX #$FFFF
    STX $32
    LDX #$8000
    STX $35
    JSR $80A0
    JSR $8190
    JSR $82B3
    JSR $82E3
    JSR $8314
    JML [$00809C]
    JSR $007E
    REP #$10
    SEP #$20
    LDA #$00
    STA $2101
    STA $2102
    STA $2103
    STA $2105
    STA $2106
    STA $2107
    STA $2108
    STA $2109
    STA $210A
    STA $210B
    STA $210C
    STA $210D
    STA $210D
    STA $210E
    STA $210E
    STA $210F
    STA $210F
    STA $2110
    STA $2110
    STA $2111
    STA $2111
    STA $2112
    STA $2112
    STA $2113
    STA $2113
    STA $2114
    STA $2114
    LDA #$80
    STA $2115
    STA $211A
    STA $0000
