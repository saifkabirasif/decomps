;
; Uncharted Waters (USA) - bank07_test
;
; Lifted byte for byte from the original cartridge
; (bank $00, $7000-$70FF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $7000

    RTS
    CPY #$3C7F
    JSR $EAD0
    LDY $B8
    DEC $9F
    EOR ($7E,X)
    STA $FD2F80
    JMP $B95F
    LDX $30,Y
    AND $FC,S
    CMP $2F
    LDA $4B,X
    CLI
    SBC #$FE00
    MVP $3800,$79
    STA ($74,X)
    PLA
    AND $40,S
    SBC ($CB)
    BRL $6BF3
    LDY $9F00,X
    PHD
    JMP $FDC4,X
    CLD
    REP #$8F
    STA ($B0,X)
    CMP #$1178
    PLY
    SBC #$6497
    PLP
    CMP $EF,X
    CMP $B0,S
    ORA ($BF),Y
    STY $D6CF
    AND [$0000]
    CMP $18E507
    XCE
    SBC $6FFF55
    PLY
    LSR $8759,X
    DEC $F7,X
    BRK $67
    BRL $E215
    EOR $EA5921
    INC $9286
    TRB $FDFC
    LDX $01C6,Y
    TAS
    CMP $E748
    AND $8DE042
    SBC $B0
    ADC $A9FA,Y
    EOR $EFA1E7
    LDA $D51485
    CMP $19,S
    ADC $BED738
    SED
    EOR ($37)
    INC $A500,X
    REP #$FF
    SBC $42F825
    PLA
    CLV
    TRB $F8
    EOR ($9B,S),Y
    STA $7D4245
    XCE
    TSB $A5
    ORA #$42D2
    ROL $FC
    INA
    LSR $A5C2,X
    CMP [$0000]
    LDA $10B7B8
    LSR $21,X
    STP
    ADC $BC12,X
    XCE
    ASL $01FF,X
    BIT $3819,X
    BRK $DE
    ORA $4A,X
    BCC L7137
    CMP $4B17C9
    BCS L70CE
    RTL
    STA $26CC,Y
L70CE:
    EOR ($C5,X)
    ADC ($81,S),Y
    COP $76
    JSR $C0AC,X
    STA [$0000]
    PEA $B8A0
    ORA #$193C
    MVP $61BE,$59
    INC $C700,X
    CMP [$0000]
L70E8:
    BRL $0D72
    STA [$0000]
    SBC [$0000]
    BMI L70E8
    BRK $99
    LSR $F1A9
    ROR $66
    ROR $3E6E
    TSA
    AND $96D08E
