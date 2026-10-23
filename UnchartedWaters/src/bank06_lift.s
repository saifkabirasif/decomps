;
; Uncharted Waters (USA) - bank06_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $6000-$6FFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $6000

    MVN $8233,$54
    EOR #$8DD0
    ADC $03,X
    CPY $78
    AND ($10,X)
    AND $A104A3
    DEX
    AND $475F
    EOR ($C9,S),Y
    ADC $64C80F
    ROR $1B34
    INC $9555,X
    TAS
    NOP
    ORA ($FD,X)
    SBC $1D89
    BCC L602F
    EOR $4A
    STA ($67),Y
    CLC
L602F:
    ADC ($7D)
    SBC $DBC0,Y
    PHX
    STA $3F
    LSR $10F6,X
    BRL $3F5F
    CMP $3C,X
    PEI ($F5)
    CMP $75,X
    RTI
    ADC $E057,X
    LDX $17DB
    TXA
    STA $A635FD
    AND ($06,S),Y
    AND $2F18
    ORA $3EFF,Y
    ORA $3A0E39
    TSB $083C
    ADC $3E0626
    TSB $1810
    ORA ($19),Y
    ORA [$0000]
    ASL $1816,X
    TRB $18
    PHA
    ADC [$0000]
    CPY #$743B
    CPY #$E074
    STA $FD6F70
    CLC
    ORA ($0C,S),Y
    PHP
    ORA [$0000]
    STY $C03F
    SBC $60E0C0
    STZ $10,X
    TAS
    PHP
    TSB $00D6
    ORA [$0000]
    TXA
    AND $CF3C1B
    AND $1B13F5
    ORA [$0000]
    EOR $80F3
    EOR [$0000]
    BMI L609E
    CPX #$30DC
    ROL $1610
    PHP
    CMP $340619
    SED
    ORA $302009
    BPL L60C9
    SBC $081A00
    PHP
    BRK $06
    BRK $2C
    TYX
    CLC
    AND $EB3B0C
    INX
    ORA $0BCD3C
L60C9:
    AND $1C4190
    ORA [$0000]
    INC $BF19,X
    ORA ($C7,S),Y
    COP $7C
    SEC
    DEC $7C
    LDA $77EFC2
    BRL $6D42
    CLI
    BPL L60E3
L60E3:
    SEC
    SEC
    JSR $447C,X
    REP #$82
    LDX #$3A02
    SBC $C12231
    CMP [$0000]
L60F3:
    TSA
    ASL $F82D
    AND $8F1603
    INA
    STA [$0000]
    LDA ($41,S),Y
    ROL $18,X
    ADC $F736
    LSR $20,X
    BNE L6169
    LDY #$40C0
    SBC $009080
    ORA [$0000]
    ROL $24,X
    JSR $C000
    RTS
    RTI
    INY
    ADC $27BF47
    CMP ($7D),Y
    PEA $3DF3
    PHD
    ROL $F809,X
    EOR [$0000]
    ORA ($7F),Y
    SBC ($36)
    JSR $D0C0
    JSR $20F0
    INX
    INC $E810
L6137:
    BMI L6137
    ADC $E0D0,X
    BMI L60F3
    BRK $70
    STA $CC20A0
    INC $7D30
    ROR $20,X
    ORA [$0000]
    STA $FFC12E
    ASL $0F38
    SBC [$0000]
    ORA $FE3D
    AND ($16,S),Y
    ASL $CF17,X
    CLC
    ORA $32,X
    PHX
    LDA ($B6,S),Y
    BRL $2865
    BRA L6166
    ADC $E13EC0
    STA $1C6672
    ADC $82FE0B
    BRA L6137
    RTI
    SBC $7220
    INC $12
L617B:
    TRB $E204
    CMP $3F21FC
    ORA $FC3B98
    ORA $F0FD,Y
    ORA [$0000]
    ROR A
    TXY
    TRB $7F57
    JSR $F089
    CPY #$F038
    CPY $2738
    CMP $D3181C
    SBC [$0000]
    ORA $3830F0
    PHP
    ORA $D1,S
    BRA L61B9
    STZ $000C
    EOR $2C,S
    COP $00
    STA $F9170D
    STZ $FF06,X
    TYA
    SBC $FFFD46
    ADC ($7F,X)
    BMI L61BE
    EOR ($F9,S),Y
    RTI
    ADC $9F93FF
    LDA $21D840
    ADC [$0000]
    CMP [$0000]
    PHP
    TCD
    CLI
    AND $359B,X
    ASL A
    STP
    XCE
    TSB $58
    SEP #$FB
    CPY $43
    CPX $7100
    JSR $230E,X
    TRB $CFCF
    AND $AE9A6C
    SBC ($0B)
    BIT $B5,X
    LDY $B7
    AND ($AA,X)
    BVS L617B
    EOR ($38,S),Y
    SBC $FC48FD
    DEY
    CMP $EFE800
    ADC $F70F
    ADC $87DFC7
    DEC $16
    PHA
    AND $AB,S
    JML [$A57474]
    INC $20BF,X
    CMP $9F,X
    STA [$0000]
    WAI
    CPY $DF80
    STZ $FE1A,X
    AND $7F
L621F:
    CMP $63,X
    JMP $4015
    SBC $CB00DC
    BRK $5E
    BRK $9E
    BRK $FF
    JSR $7B00,X
    BRK $95
    ORA $0A,X
    ASL A
    SBC $346F6F
    BIT $B3,X
    LDA ($FB,S),Y
    XCE
    SBC $7B7B,X
    STY $84
    ROR A
    ADC $38FFFC
    TRB $FC08
    PLP
    LSR $7E0C,X
L6250:
    INC $FE3C,X
    BPL L62D1
    PLA
    LDY $83A8,X
    ROL $BE
    CPX #$70
    AND $28,S
    LDY #$AC
    BRA L621F
    DEA
    ORA $E7
    BRA L6250
    RTI
    LDA ($B1),Y
    RTS
    BRK $0E
    DEC $00
    ADC ($FA,X)
    LDA $D3,S
    PLA
    BIT #$03
    LDA $72,S
    PHB
    ORA $DE
    WAI
    SBC $87,S
    TSB $1F
    CPX $8D
    BRK $57
    LDA ($8F,S),Y
    SBC $03
    LDA $67
    AND $FF7FC3
    STA ($BF,X)
    ORA ($2F,X)
    BNE L62AA
    LSR A
    BRK $BF
    AND $FD
    PHP
    PHP
    WAI
    TSB $048D
    EOR $DE
    BRK $D0
    PEA $00F3
    ADC $00,X
    STY $6D
    CLV
    ROR $116E,X
    LDA [$0000]
    BRL $1219
    STZ $5551
    JML [$5E00D9]
    EOR $FF
    TSB $AC31
    ADC $55
    SBC $59F4,Y
    SBC $D1
    PEI ($74)
    DEC $F6
    STP
    SBC $2254,X
    BRK $15
L62D1:
    BRK $C4
    ROL $017E,X
    LDX $0209
    LSR $00,X
    STA $D1C500
    STA $A1,X
    STA ($5E,S),Y
    WDM $F7
L62E5:
    ASL $B8
    STA $B1F480
    JMP $6CDD
    BRK $CA
    PLB
    ROR $3300
    ORA $F8,X
    ORA $0F,X
    PHP
    BCC L630A
    ORA $6A,X
    CMP $01,S
    AND $07BB,X
    STX $0E
    BEQ L62FE
    RTS
    ADC $0098FD
    STA $5F89A1
    BVS L6390
    CLV
    LDX $F0,Y
    LSR $45
    SBC $B0
    STZ $F3
    AND $F640A6
    INC $EA
    BRK $90
    JSR $813F,X
    ORA $1CF0,X
    BEQ L63A7
    ADC $CF0E8C
    STA [$0000]
    SBC $FA,X
    ORA #$8C
    CMP $A0,S
    PHB
    ORA $FE9FE1
    AND #$BF
    AND #$3F
    DEA
    STA $E4458E
    LDA #$18
    NOP
    SBC #$2B
    ADC $68
    JSR $8D1F
    SBC $2951,X
    SBC [$0000]
    ORA [$0000]
    BMI L62E5
    LDA ($10,S),Y
    EOR ($96,S),Y
    STA $DD706D
    AND $27F708
    PHA
    LDA ($15,X)
    ORA $AE214D
    SBC $DC,S
    AND $62D3C7
    JSR $FC7F
    LDA $DB
    MVN $E5B4,$8F
    LDA [$0000]
    INC $58F9,X
    RTI
    SBC $D858A3
    PLD
    LDA $F9E7,X
    INY
    SBC $1080A3
    LDA [$0000]
    BNE L63B0
L6390:
    DEY
    SED
    AND ($FF),Y
    TAX
    CMP ($04,S),Y
    JSR $F739,X
    EOR [$0000]
    PLD
    LSR $1200
    PEI ($1F)
    CMP $F40D,X
    TSB $98
L63A7:
    BMI L63E8
    SBC $42D8D5
    ADC $F8C3,X
L63B0:
    ADC $FE,S
    INX
    LDY #$4C
    LDY $D1
    CPX $8DF7
    BIT #$AE
    ORA ($12,X)
    CMP $E10347
    BIT #$FE
    LDX $3F,Y
    ROL $987C
    LDA $8E8F6D
    LDA $FFE4
    ORA ($40,S),Y
    ORA ($FE,X)
    TAS
    STA $B745,X
    SBC $D6,X
    ORA $EB7C02
    ASL $0B4E
    BIT $46,X
    RTS
    PLB
    PHD
    ORA $18,S
L63E8:
    PHA
    REP #$94
    ORA ($F8,S),Y
    STA [$0000]
    ADC $00
    TDC
    INC $4CBA,X
    PLY
    SBC $3FAD,X
    STA $7F,S
    ORA ($96,X)
    ADC $B7F050
    LDA [$0000]
    EOR $F4
    PHB
    STX $6F,Y
    TAX
    AND $420024
    ADC ($A8,X)
    CMP $2D649A
    PEI ($5F)
    BIT $BF,X
    EOR $64,X
    PHP
    STZ $4512
    ADC ($5B,S),Y
    SBC $98,X
    SBC $DD,X
    CMP $DF549A
    AND $5A
    ADC $29EB,X
    STA $927C75
    ADC $B7D2D2
    DEC $04,X
    CMP ($3C),Y
    TAX
    ADC $AB01B5
    LDX $7C95,Y
    CMP $A23A,X
    CMP #$B7
    PEI ($70)
    ROR $17D4,X
    INC $5FCB,X
    SBC ($1F,S),Y
    CMP $19,X
    BNE L6453
L6453:
    BRK $EF
    AND $A3
    CMP $1F02,X
    TXA
    JSR $0001,X
    TRB $1B
    ROR $3D91
    LSR $60
    STA $FCCC0F
    ORA $C1,S
    JML $ECE01F
    ORA ($00)
    BRK $80
    BRK $00
    BRK $30
    BRK $00
    BRK $22
    BRK $00
    BRK $01
    BRK $06
    CMP $C4B3,Y
    STX $59
    BPL L6474
    SBC $857C00
    STA ($7E,X)
    INC $2011
    BRK $08
    BRK $20
    BRK $03
    BRK $00
    BRK $02
    BRK $00
    BRK $00
    BRK $80
    SBC $9C7B,X
    SEI
    STA $21
    INC $609F,X
    CMP [$0000]
    SED
    ORA [$0000]
    STA ($02),Y
    BRK $00
    BRK $02
    BRK $00
    BRK $00
    BRK $20
    BRK $00
    BRK $00
    BRK $E8
    ORA $0769D7
    SED
    SBC ($CF)
    CMP #$36
    TRB $FFC1
    BRK $CE
    AND #$00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $22
    BRK $00
    BRK $10
    BRK $80
    SBC $9C7B,X
    SEI
    STA $21
    INC $609F,X
    CMP [$0000]
    SED
    ORA [$0000]
    STA ($02),Y
    BRK $00
    BRK $02
    BRK $00
    BRK $00
    BRK $20
    BRK $00
    BRK $00
    BRK $E8
    ORA $0769D7
    SED
    SBC ($CF)
    CMP #$36
    TRB $FFC1
    BRK $CE
    AND #$00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $22
    BRK $00
    BRK $10
    BRK $6E
    STA ($3D),Y
    LSR $60
    STA $FCCC0F
    ORA $C1,S
    JML $ECE01F
    ORA ($00)
    BRK $80
    BRK $00
    BRK $30
    BRK $00
    BRK $22
    BRK $00
    BRK $01
    BRK $06
    CMP $C4B3,Y
    STX $59
    BPL L6534
    SBC $857C00
    STA ($7E,X)
    INC $2011
    BRK $08
    BRK $20
    BRK $03
L6557:
    BRK $00
    BRK $02
    BRK $00
    BRK $00
    BRK $71
    STX $E13D
    STA $667E,Y
    STA $27D0,Y
    ROR $99
    BCC L65D5
    ORA $0051
    BRK $02
    BRK $00
    BRK $00
    BRK $08
    BRK $00
    BRK $08
    BRK $A2
    BRK $07
    SED
    SBC ($0E,S),Y
    CMP #$57
    INC $09,X
    SBC $F6F2
    ORA #$F9
    ASL $F0
    ADC $00
    BRK $00
    BRK $20
    BRK $00
L6597:
    BRK $00
    BRK $00
    BRK $00
    BRK $0A
    BRK $80
    ADC $9CB04F
    ADC $AF
    BMI L6557
    ADC $9FA04F
    RTS
    SBC $001016
    BRK $00
    COP $00
    RTI
    BRK $00
    BRK $10
    BRK $00
    BRK $00
    BRK $18
    INC $D4
    TAS
    STA $6AE6,Y
    STA ($0A,S),Y
    ADC [$0000]
    TXS
    ORA #$76
    DEC $0111,X
    BRK $20
    BRK $00
L65D5:
    BRK $04
    BRK $80
    BRK $01
    BRK $80
    BRK $20
    BRK $80
    ADC $9CB04F
    ADC $AF
    BMI L6597
    ADC $9FA04F
    RTS
    SBC $001016
    BRK $00
    COP $00
    RTI
    BRK $00
    BRK $10
    BRK $00
    BRK $00
    BRK $18
    INC $D4
    TAS
    STA $6AE6,Y
    STA ($0A,S),Y
    ADC [$0000]
    TXS
    ORA #$76
    DEC $0111,X
    BRK $20
    BRK $00
    BRK $04
    BRK $80
    BRK $01
    BRK $80
    BRK $20
    BRK $71
    STX $E13D
    STA $667E,Y
    STA $27D0,Y
    ROR $99
    BCC L6695
    ORA $0051
    BRK $02
    BRK $00
    BRK $00
    BRK $08
    BRK $00
    BRK $08
    BRK $A2
    BRK $07
    SED
    SBC ($0E,S),Y
    CMP #$57
    INC $09,X
    SBC $F6F2
    ORA #$F9
    ASL $F0
    ADC $00
    BRK $00
    BRK $20
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $0A
    BRK $08
L6661:
    BPL L6661
    ORA $0F1F00
    ORA $440F07
L666B:
    BRA L666B
    XCE
    BRK $FB
    SBC ($FB),Y
    CPX #$0DF1
    ORA $FE,S
    SBC $FDFF00
    SBC $05FDF8
    ORA $E6,S
    JSR $FC00,X
    PHB
    COP $FA
    JSR $FE9E,X
    ORA $C4,S
    DEC $7F49
    SBC $FE7F3E
    STA ($00,X)
L6695:
    STX $01
    PHB
    ORA [$0000]
    ORA #$AC
    SBC $1F2F0F
    AND $3F5E1F
    SED
    CMP $F600,X
    TSB $2A
    INC $FFFE,X
    ADC $979FFB
    ORA $24003F
    RTI
    AND $9FBF0F
    EOR $8FDF8F
    LDA $E7FECF
    BRK $E7
    CMP $E7,S
    STA ($C3,X)
    DEY
    EOR $04A06F
    BEQ L66C7
    STA $000791
    ORA [$0000]
    LSR $2828,X
    PHD
    CPX #$E000
    CPY #$12A3
    CPX #$E0D0
L66E2:
    BEQ L666A
    CMP ($67,S),Y
    RTS
    ROL A
    XCE
    ADC $9E45
    XCE
    CMP $8FF71E
    CMP $1A83
    SBC $77,X
    CPY $C76B
    ORA $A7,S
    CMP $D7,S
    SBC $F0,S
    SBC [$0000]
    SBC $0577F3
    JMP $1F60
    ROL A
    ORA $1C9B88
    ORA #$09
    INC $EF,X
    STZ $8ED7,X
    CLD
    CMP $1CF186
    AND $26F47F
    TXY
    ROL $FBFD,X
    ORA [$0000]
    ORA $03,S
    ORA ($83,X)
    STA ($9F,S),Y
    STA $4AFF,Y
    ADC [$0000]
    BRK $46
    LSR $7537,X
    SBC $DF9FFF
    STA [$0000]
    STA [$0000]
    BRK $80
    PEA $4000
    BRA L66E2
    PER $5027
    EOR ($C9,X)
    ASL $13,X
    BRK $08
    LSR A
    LDA ($98)
    ADC ($50),Y
    STA $491446
    ORA ($0B),Y
    BRK $4C
    BRK $C6
    EOR $5608,Y
    SBC ($91)
    STZ $82,X
    STZ $BD,X
    ADC ($30,S),Y
    BRA L6784
    ASL $810E
    ROL $FF
    CMP $E2620C
    TSB $CB
    EOR $FF4C,Y
    STA ($33,X)
    PLP
    STA $CB,X
    TSB $6C17
    DEX
    PLD
    BCS L675B
    ROL $E51F,X
L6784:
    MVN $1316,$B0
    PEA $F87C
    PLP
    WDM $5F
    JSR $C63C,X
    JSR $A851
    INC $33BC,X
    SBC ($7D)
    SBC [$0000]
    MVP $BC71,$69
    AND $8090,X
    WAI
    STX $C7
    BRL $7A2B
    BRA L6766
    CPY #$0044
    COP $01
    ORA ($00,X)
    AND ($49),Y
    SBC ($0C,S),Y
    BRK $1C
    PHP
    PLA
    LDY $278F,X
    CMP [$0000]
    ASL A
    BRK $A2
    ASL $4170
    ORA #$BE
    SBC ($C7,X)
    SBC $805207
    TSB $6822
L67CF:
    INC $25
    PEI ($84)
    BRL $8615
    EOR $3E7D7B
    ROR $583C,X
    DEC $BE
    JMP $FEF8,X
    JMP $78FC,X
    PLX
    STA $FC,X
    EOR ($45,S),Y
    ORA $72,S
    ORA ($EE,X)
    ADC ($CB)
    LDA $9CBD
    CMP $83
    BRK $30
    ORA ($95,S),Y
    RTS
    ORA ($B5)
    INY
    PHP
    TAY
    PLX
    CPX #$7696
    CMP ($6F,X)
    LDX #$2C2F
    CLC
    BIT $5C18,X
    SEC
    CMP $BC
    SEI
    PLP
    PLA
    PLP
    CLC
    SBC $13D2,X
    SBC $FEF9A3
    CMP ($E9,X)
    EOR ($19,X)
    TAS
    TSB $0E82
    CMP [$0000]
    ADC $2A,X
    JSL $5A8D12
    BEQ L67C2
L682D:
    CMP $2B5C89
    TSA
    BMI L682D
    BNE L67CF
    PLX
    TAY
    STX $F1,Y
    SBC $0C7C88
    BPL L68A5
    LDA [$0000]
    ORA [$0000]
    CMP [$0000]
    AND $405C,X
    STY $2D
    ORA $B0BB5D
    AND $E4A9,X
    ADC $3DE6,Y
    EOR ($00,X)
    STZ $636B
    TAS
    SBC $BF6D
    CMP $6E2D,X
    BRL $6E2F
    SBC $0B22,Y
    CPY $6CD0
    ORA $7F2C,Y
    EOR $C7
    SBC $BF7EB7
    ROR $3A2D,X
    ROR $5F3F,X
    STX $3F
    LDX $6ED1,Y
    CPX $F4
    ASL $0106
    LDX $05F7
    ORA $F0D8
    PHY
    ADC $23,S
    ADC $ECEE
    LDY $6A
    CMP $6EEB3E
    JMP $AF9F,X
    BPL L68CA
    SBC $FCFE54
    PHP
    CMP [$0000]
    SBC [$0000]
    SBC [$0000]
L68A5:
    STA $54,S
    SBC $45EB,X
    SEI
    SBC $580879
    LSR $03A0
    STY $EE,X
    ORA $AD,S
    ROR $444B
    ADC $1F75,Y
L68BC:
    LDA $38
    JSR $EF70
    SBC $2688E7
    INC $4867,X
    JSL $30FF9F
    COP $AF
    BEQ L68B3
    STA ($E2,X)
    CMP ($E1,X)
    ORA $1C,S
    LDA [$0000]
    LDY $A7,X
    TCD
    LDA ($BF,S),Y
    JMP $FFF0,X
    STZ $7C78
    BRK $C0
    BRK $BC
    CPY #$BD2F
    CMP ($17,S),Y
    SBC $E07F,X
    ROL $333F
    ORA $01A88E
    AND ($D9)
    CPX #$807A
    CPY #$8539
    EOR $A801BF
    SBC $BE
    ADC ($05,S),Y
    SBC [$0000]
    LDX $1D5F,Y
    SBC [$0000]
    TDC
    JSR $6C3C,X
    BMI L6986
    BRK $0F
    STA $CAC9,Y
    ORA [$0000]
    SBC $0BEE4E
    SBC [$0000]
    MVN $0E01,$EE
    TSB $76
    BCC L68BC
    RTL
    ORA $C1E8,X
    CPX $30E9
    LDX $F2DB,Y
    SBC ($D3,X)
    SBC ($BC,X)
    JMP $F87D
    ORA [$0000]
    TAS
    MVP $EAC1,$EC
    SBC [$0000]
    XBA
    DEC $F3F1,X
    INY
    LDX $E3
    CMP ($A3,X)
    CMP ($E2,X)
    SBC $FBF3,X
    ROL $3899,X
    CMP $7F6813
    LDA $FB63,X
    ADC [$0000]
    ADC [$0000]
    AND [$0000]
    SBC $C3CD,X
    SBC $7C,S
    STA $9A,S
    RTS
    SBC ($C0,X)
    DEC $7F22
    SBC $73BFF3
    ADC $335F33
    AND $9F13A6
    PLB
    STZ $79,X
    REP #$F7
    SBC ($40,X)
    SBC $2A
    EOR ($37,X)
    CMP $8777F9
    STA $752503
    STZ $2D73,X
    EOR [$0000]
    ORA $CB8CBF
    TDC
    PHX
    INC $7E3F,X
    DEC $A1
    SBC $C7BB1F
    DEC $E1,X
L69A2:
    AND ($6C)
    STZ $D913
    CMP $03
    STA $7F13
    BRL $1441
    ROL $01
    LDX $73,Y
    SBC ($F4)
    JML $5ADD02
    MVP $079D,$90
    SBC $457900
    ADC $A3,X
    AND #$FF6E
    ADC $DE8BF3
    AND $EEFE
    BEQ L69A2
    CPX #$8163
    STA $F6,S
    BIT #$3DF3
    ASL $3CFE
    SBC $F8E6
    LDY $7EBD,X
    ORA $78,S
    RTL
    RTS
    ADC $E18F
    STZ $33
    CMP ($05,X)
    PLB
    CMP [$0000]
    XBA
    CMP [$0000]
    AND ($98)
    SBC [$0000]
    TSA
    CLI
    SBC $80
    CMP $83,S
    STA ($27),Y
    STX $7C
    INY
    CMP [$0000]
    JML [$05DEFF]
    BIT #$DFFE
    CMP $79,S
    TXY
    CMP ($83,X)
    ORA ($9F,X)
    STP
    STA ($E7)
    PLP
    LSR $D04F,X
    CMP $0387C0
    JMP $D196,X
    ORA $D15A,X
    ADC ($F5)
    TRB $68
    CPX $D8
    PLP
    STA $4C,X
    SBC ($49),Y
    STA $65D2,X
    ADC #$8630
    COP $B5
    DEC $56,X
    CMP ($1F,S),Y
    TDC
    EOR [$0000]
    ADC ($9F),Y
    TAS
    ADC ($18,X)
    PHP
    ORA [$0000]
    LDA $45DD
    TYX
    CMP $25
    TSA
    LDA [$0000]
    PHB
    CMP $E0,X
    LDA $64D7C7
L6A53:
    LDA $8770,Y
    CPY #$AF25
    LDY $C8B7,X
    ORA [$0000]
    STX $602C
    DEY
    INX
    TYA
    ORA $3EDDFF
    BRA L6AA8
    TAS
    DEC $C320,X
    TDC
    ADC ($1E),Y
    PHX
    TSA
    INA
    BRL $78E6
    SBC ($4B,X)
    CLI
    CPY $3B28
    ORA $A03FDF
    RTI
    PHP
    EOR ($2B)
    CPX #$DF2D
    EOR $13
    EOR $F0,X
    CMP ($C9,X)
    INX
    INC $874F,X
    STA $D67801
    STZ $FA6A
    PLB
    LDX $B6DF,Y
    TXY
    STA $7F6437
    BIT #$18E1
    STA $C1,S
    JSR $43A7,X
    STA ($C3,X)
    AND $DC41,Y
    ORA $5D,S
    CPY $96
    BIT $984F
    CMP $E90D,X
    AND $1C03BF
    BCC L6A53
    ORA $E0E77F
    SBC $23E3FD
    LDX $F001
    CPY $4FAD
    TSB $B7B7
    BVS L6B4B
    PLP
    ROR $DB43,X
    BCC L6B56
    ADC [$0000]
    ORA ($F8,S),Y
    CPY #$7726
    SEC
    CPX #$2078
    RTS
    DEC $26F6,X
    NOP
    STA $7D,X
    ADC ($88,S),Y
    LDA $E0C7,X
    TCD
    BIT $8C3C,X
    LDA ($D2,S),Y
    ORA ($A5)
    XBA
    PLD
    SED
    CLC
    PEI ($86)
    SBC ($09),Y
    SBC $DDFA,X
    ASL $6740
    LDY $24
    TSB $C3
    AND $28,X
    STA $DD67,Y
    CMP $A74C,Y
    CMP ($5D,S),Y
    ADC $96EF,Y
    LDA ($CC)
    ADC [$0000]
    EOR $1E076D
    ADC $BF1DED
    INX
    LDA [$0000]
    SBC [$0000]
    DEC $F9E2
    CMP $2E,X
    AND #$1A44
    ASL $DD
    ADC $F9
    CMP $23FD,X
    BIT $C2CF
    EOR ($FE,X)
    CMP ($1A,X)
    ASL $B303,X
    ROR $D5,X
    LDA $33,X
    TXA
    JMP $C102
    BRL $E30A
L6B4B:
    ORA [$0000]
    AND $B4
    CMP ($31,X)
    LDA $1FE59D
    ORA $7D,S
    CPX #$BA13
    ADC ($A3),Y
    ADC $C0
    ADC ($0B)
    ROR $7422,X
    AND $F8
    ASL $9E
    STA $D7,S
    SBC $11
    JMP $797F
    SBC $F8,X
    ADC $35,S
    CPX #$FC7A
    ORA $A877E4
    ADC ($73,S),Y
    JML [$8A6860]
    STZ $7CBF,X
    RTI
    MVP $C9DF,$F6
    BRK $8B
    AND $4F55,X
    ADC $B005,X
    ADC $F9D2,Y
    CPX #$30F9
    STA $34CE39
    SBC ($41)
    LDA $1C6F78
    ASL $BC08,X
    LDA ($AD),Y
    ROL $EF,X
    ORA ($25),Y
    AND [$0000]
    ADC ($5D,X)
    EOR $70E1
    STA $5301,Y
    INC $6B49
    LDX $4C95,Y
L6BB8:
    ADC ($7E)
    TSB $9E18
    AND $0A16,X
    CMP [$0000]
    SBC $5DCCC6
    SED
    SBC $D6FFEE
    SBC $718903
    STA $C8,X
    BCS L6B93
    ADC $60
    CMP ($68,X)
    AND [$0000]
    SBC $07,X
    LDA $4C,S
    CMP ($00)
    PLX
    RTS
    STX $4D
    STZ $AB,X
    BRK $3E
    AND $8ED6
    ORA $0020B9
    STA [$0000]
    BPL L6BB8
    CMP ($21,X)
    INX
    LDA $23,S
    ORA ($86,X)
    LDX $74E2,Y
    RTI
    ROR $F82C,X
    BMI L6C3A
    STA $460FBD
    ORA ($90,X)
    SBC [$0000]
    BPL L6C09
    DEC $8B1F,X
    ORA $B126A8
    LSR $EF
    SBC $7D,S
    STZ $03
    ORA $68F5
    TXY
    EOR ($7C,X)
    RTS
    TSB $3E
    WDM $1C
    ORA $E0,S
    SBC $1F,S
    TRB $53B5
    LDA [$0000]
    PLY
L6C2E:
    SBC $24
    PLX
    SBC [$0000]
    ORA $C3,S
    AND $C39C95
    JSR $023C,X
    CPX #$4DEA
    STP
    CMP $55
    BIT $AC,X
    CMP ($3D),Y
    CPY #$41A5
    WDM $CA
    CMP #$323F
    CPX #$0C42
    LDA $56
    INC $F140,X
    LDY $01,X
    TAX
    STX $C1C0
    ORA ($A2,X)
    CLC
    ADC ($E2),Y
    SBC $08
    LDA $08,S
    BCC L6C2E
    ORA $7C,X
    LSR $D9
    CMP [$0000]
    ORA [$0000]
    ORA [$0000]
    JSR $2C46
    ORA ($5E),Y
    BCC L6C48
    PHK
    LDY $E038,X
L6C7C:
    ASL $59
    BIT $7F21
    BPL L6C7C
    LDY #$861C
    DEY
    CMP $20F07F
    STA ($E7,X)
    TSB $5EF8
    CLV
    JSR $344C
    JSR $4386,X
    SBC ($00),Y
    ORA ($77,X)
    CMP $BCB0,X
    EOR $00,S
    CPY $3F
    BPL L6CD6
    LDA $6BE0,Y
    CPY $0006
    ADC $02,S
    ROL $10CD,X
    SEC
    CPY #$F8C7
    SEC
    ADC [$0000]
    AND $14,S
    BRK $C6
    AND [$0000]
    CLD
    STZ $F732,X
    LDA $FBC0
    TDC
    AND $9455,Y
    CPX #$070A
    ORA $5D,X
    ADC $57E97F
    ADC [$0000]
    AND [$0000]
    JMP $9648
    BCC L6CFC
    ORA $233FDC
    JSR $DCE0,X
    CPX #$D820
    EOR $4015A2
    CPX $D4
    AND ($70)
    SBC $FC,S
    TRB $4A52
    LSR $08,X
    STX $20
    LSR A
    STY $88,X
    ORA $70
    STA $3FC718
L6CFD:
    SEC
    CMP $AF
    EOR $5EB690
    ROR $C87A,X
    CPY $F8
    TSA
    JSR $3FC4,X
    LDA $BE
    STA ($04,X)
    JMP $2583
    DEX
    LSR $4F16,X
    INY
    INC $5A,X
    BVC L6CFD
    CPX #$70A8
    CMP ($1E)
    SBC $C1F5
    ROL $C6,X
    STX $DE
    ROL A
    TRB $3856
    MVN $FF38,$6F
    ASL $5D50
    LDA [$0000]
    TXY
    LDA ($7E),Y
    ROR $297C,X
    STP
    STY $7E
    TXA
    BRL $CEF4
    ROR A
    INC $0099,X
    EOR ($52)
    ADC $B6,S
    AND $E19E81
    PHB
    TAS
    BRK $9A
    CMP $D0E2,Y
    BIT #$BD5B
    JSR $D86F
    ROR A
    STA [$0000]
    ORA $1A8900
    EOR ($76,X)
    DEC $D3AD
    BNE L6DC4
    LDX #$1C32
    ADC $C4,X
    BRK $C4
    ORA ($F3)
    LSR A
    LSR $99
    CMP ($CB)
    SED
    CMP $9896,Y
    JSR $00EC,X
    PHK
    JML $892D0F
    BIT #$6268
    TSB $1D7F
    LDA ($B1),Y
    MVP $08FB,$00
    EOR $384A,Y
    STA $A861BE
    ORA $7F88,X
    AND $717A,X
    EOR ($00)
    ADC ($CF,S),Y
    TAS
    DEC $BB20
    AND ($C3)
    REP #$F8
    ORA [$0000]
    BRK $4A
    ORA $89
    TDC
    EOR [$0000]
    AND ($E6)
    DEA
    EOR $FD16,Y
L6DB8:
    PLY
    RTI
    AND $00B7,Y
    NOP
    ORA ($4D),Y
    JML [$5C6DAB]
L6DC4:
    SBC [$0000]
    ORA $0199
    ORA ($D3),Y
    INY
    PHX
    BRK $EF
    STX $4A
    ADC $FFF8,X
    CMP $99A203
    LDA $9E40B1
    AND ($1E,S),Y
    BRK $1F
    TXY
    AND ($62,X)
    STA $5F8770
    STZ $64,X
    ORA $56
    STA [$0000]
    CMP #$1FEF
    RTS
    BRK $B1
    BRA L6DD9
    AND $D1,S
    LDA ($FB,S),Y
    AND $57
    CMP ($BB)
    DEC $D410
    BRK $4C
L6E02:
    ROL $6E94,X
    ADC $F7BF,Y
    LSR A
    CMP [$0000]
    AND ($BD,S),Y
    PER $6E51
    CPX #$90F9
    CPY #$5E65
    XBA
    PLY
    STA $B4
    ROR $7C
    ADC [$0000]
    BRK $29
    PLD
    SBC ($01)
    ADC $722E,Y
    BCS L6DB8
    LDA ($D3,S),Y
    PLD
    ROR $19
    BRK $13
    EOR $BAA2C8
    ORA $4E,S
    EOR ($CB),Y
    SEC
    ADC $3D
    PHA
    SBC $84,S
    ASL $17,X
    CMP [$0000]
    JSR $028E
    JSR $4855
L6E47:
    PHP
    BRK $1E
    PHP
    SBC $060D,X
    COP $07
    AND $33,X
    LDA ($29),Y
    ASL $1F
    LDA [$0000]
    JMP $8E45
    STY $8C
    DEY
    BVC L6E47
    BPL L6E02
    RTS
    EOR $6AAF
    TYX
    STY $00
    TYA
    EOR $23,S
    LDX #$0A00
    CMP $51BE59
    CMP $0605,X
    JSR $080A,X
    AND ($11),Y
    ADC ($21),Y
    LDY $11CE,X
    AND ($3E)
    DEA
    ORA $19001C
    BRK $21
    ROL $DF99
    LDY $B3CC
    STX $60B0
    SEI
    BPL L6EA5
    EOR ($CC,X)
    CMP [$0000]
    BIT #$A84F
    CMP $5166,X
    EOR $13A3,Y
    SBC #$0F11
L6EA5:
    ORA #$45E1
    ASL A
    AND $119F
    CMP #$0900
    SBC $9C5515
    BCC L6EC7
    LDA $8880
    ORA [$0000]
    STA $AEEAFC
    CMP [$0000]
    CMP $5EFA6D
    BVS L6EC9
    STP
L6EC7:
    SBC $0542,Y
    TSB $09
    ADC $F9CE,X
    EOR $0497
    EOR $9E40,X
    ADC $A787,Y
    LDY $F0,X
    BCC L6EA4
    STX $6688
    TSA
    ADC ($2B,X)
    BCC L6EE4
L6EE4:
    DEY
    ROL $36,X
    LDA [$0000]
    SEI
    BVS L6F0C
    BMI L6EFE
    CMP $FD3714
L6EF2:
    INA
    SEP #$03
    JML [$52BFE0]
    ORA #$06EF
    LDA [$0000]
L6EFE:
    SEP #$90
    BRA L6F02
L6F02:
    STZ $D8FF,X
    CPX #$DC
    ORA $AFFE,Y
    SBC ($1A,X)
L6F0C:
    BPL L6F2C
    DEC $EAA8
    LSR $95,X
    ORA #$DFFC
    LDA $4FC531
    ORA $39BB7F
    PEI ($95)
    STA ($10,S),Y
    TSB $0E08
    BRA L6F2B
    CMP $FF,S
    AND $6D9C,X
L6F2C:
    TAY
    ORA $F019
    CPX $05
    DEC $1A3D,X
    ORA [$0000]
    ORA ($0D),Y
    PHD
    INC $21
    AND $421C,X
    STA $B5
    RTS
    ORA ($00,S),Y
    PHD
    LSR $5A,X
    BMI L6EFA
    LDX $7841
    BPL L6F6E
    ROR A
    SBC ($1E)
    PLA
    PLA
    BIT #$00C0
    LDY #$F7
    TYA
    SBC $D2F3,X
    XCE
    BIT $52E5,X
    SBC $04F0
    TSB $08
    PHP
    BIT #$F4BF
    BVC L6EF2
    ORA $7E
    LDY #$B6
    STA $22,S
    RTL
    ORA $25
    BCS L6F46
    DEY
    STX $6888
    ROL $53,X
    EOR #$00D0
    INY
    BEQ L6FA3
    BRK $DF
    PLP
    BIT $2F53,X
    STZ $77
    SBC #$84BD
    BRL $2C3C
    BIT $E502,X
    EOR $9E2401
    ADC ($09,S),Y
    BIT $EF,X
    PLY
    LDA $00BD03
    DEC $D1EF,X
L6FA3:
    ORA $8B3087
    AND $B2F853
    ROR $43,X
    BVC L6FAF
L6FAF:
    SBC ($C9),Y
    TRB $DAF6
    WAI
    LDY #$64
    SEC
    LDA $FF
    BVS L7028
    XCE
    LSR A
    ROR $F179,X
    SBC ($03)
    TXA
    WAI
    BEQ L6FB9
    SBC $F0
    PLP
    CLV
    BRK $23
    STA $89EE70
    EOR $97,S
    SBC $CB63F6
    TRB $FE87
    ADC $040AB0
    STP
    ADC $BF4F38
    PHP
    SBC $F8A0,Y
    STZ $66,X
    BRK $FF
    BIT $89D8
    ORA [$0000]
    CMP [$0000]
    LDA $1B93,Y
    ADC ($5F,S),Y
    ASL $3FFF,X
    ORA $E707CF
    EOR ($FD,X)
