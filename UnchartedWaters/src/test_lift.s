;
; Uncharted Waters (USA) - test_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $0000-$00FF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $0000

    ORA ($0F,X)
    LDA $063300
    AND $2F18
    ORA $0F3E,Y
    SBC $0E39,X
    DEA
    TSB $083C
    AND $06
    ROL $0CFF,X
    BPL L0032
    ORA ($19),Y
    ORA [$0000]
    ASL $E3,X
    CLC
    TRB $18
    EOR $1C
    CPY #$FF00
    CPX #$74C0
    CPX #$709F
    ADC $13FB18
L0032:
    TSB $0708
    ORA [$0000]
    AND ($C0,X)
    CPY #$E0FF
    RTS
    STZ $10,X
    TAS
    PHP
    TSB $BD00
    ORA [$0000]
    BIT #$00F0
    BCS L00AB
    LDA ($60),Y
    BEQ L0001
    JSR $6040
    LDY $99
    ADC ($A5),Y
    ORA ($FF,X)
    ORA ($1F,X)
    ASL $FF
    CLC
    SBC $BFFF00
    ADC $01D856
    ORA ($06,X)
    TSB $18
    CLC
    STA $0DAF7F
    ROL A
    SBC $8AFF4D
    SBC $3D09BF
    PHP
    INC $FF2C,X
    TRB $FFFE
    CPX #$1832
    EOR $18,X
    STA ($73)
    STZ $7F
    STA $E03CBD
    JSR $FF1F,X
    SED
    BPL L00D0
    ROL $9F85
    ORA $FF8FFF
    ADC [$0000]
    SBC $35CE17
    BPL L00A0
L00A0:
    ORA $520FBF
    LDY $8F8F
    ADC [$0000]
    ORA [$0000]
L00AB:
    AND ($02)
    LSR $60FF,X
    BIT $FE05
    INX
    ADC $E2,S
L00B6:
    SBC $0157AF
    STA ($98,X)
    EOR $FE,X
    PEA $07FF
    SBC $128C03
    BRA L0107
    STA [$0000]
    LDA $1F,X
    LDA [$0000]
    SBC #$4030
L00D0:
    AND $753272
    CPX $7A35
    DEA
    ORA $98,X
    PLX
    PLY
    LDA ($F5,X)
    SBC $3F003F
    AND ($3A)
    BMI L0123
    SEC
    BEQ L0160
    ADC [$0000]
    BVS L00B6
    LDA ($8E,S),Y
    STA $FF
    JML [$BABADC]
    CMP $BFDD,X
    LDA $90811F
    ROL $83,X
    CMP $0000,X
