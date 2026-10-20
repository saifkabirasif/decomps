;
; Uncharted Waters (USA) - NMI handler
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8361-$842F).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8361

    SEI
    REP #$30
    PHA
    PHX
    PHY
    PHB
    PHD
    LDA $4C
    PHA
    LDA $4E
    PHA
    LDA $50
    PHA
    SEP #$20
    LDA #$00
    PHA
    PLB
    CMP $4210
    LDA $0E09
    BNE L83A0
    LDA $0E04
    BEQ L8394
    LDA $0E05
    STA $2140
    LDA $0E06
    STA $2141
    STZ $0E04
L8394:
    LDA $0E07
    STA $2142
    LDA $0E08
    STA $2143
L83A0:
    LDA #$80
    STA $2100
    LDA #$01
    STA $4200
    LDA #$00
    STA $420C
    JSR $8829
    JSR $8870
    JSR $8B20
    JSR $8B58
    JSR $8C79
    JSR $8C97
    SEP #$20
    LDA $0B56
    BEQ L83EF
    LSR A
    BCC L83DA
    LDA #$01
    STA $4C
    JSR $8430
    LDA #$FE
    AND $0B56
    STA $0B56
L83DA:
    LDA $0B56
    AND #$02
    STA $0B56
    BEQ L83EF
    LDA $0B56
    STA $4C
    JSR $8457
    STZ $0B56
L83EF:
    LDA $0B57
    BEQ L83F7
    JSR $8488
L83F7:
    LDA $0B74
    BEQ L8406
    BMI L8403
    JSR $8636
    BRA L8406
L8403:
    JSR $87B0
L8406:
    JSR $8D07
    JSR $8C05
    STZ $0B55
    SEP #$20
    STZ $0B55
    LDA $0B3E
    STA $2100
    LDA #$81
    STA $4200
    REP #$30
    PLA
    STA $50
    PLA
    STA $4E
    PLA
    STA $4C
    PLD
    PLB
    PLY
    PLX
    PLA
    RTI
