;
; Uncharted Waters (USA) - bank01_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $1000-$1FFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $1000

    WDM $6A
    INX
    LDA $B31B,X
    LDA [$0000]
    ADC [$0000]
    ADC [$0000]
    DEY
    DEY
    LDX $57,Y
    EOR [$0000]
    ROR $F6,X
    ADC [$0000]
    ADC [$0000]
    TSB $D4
    ORA [$0000]
    INC $8BF2,X
    BRK $93
    INC $0A,X
    ADC $E1
    PHB
    ORA #$7DD1
    LDY $20B4,X
    ORA ($68,X)
    INC $47AC,X
    EOR [$0000]
    LSR $F5,X
    CMP $2ECF,Y
    JMP $B8AE,X
    STA ($40),Y
    CMP ($11,S),Y
    ASL A
    TAY
    INC $587D,X
    CMP $00C014
    TSX
    CMP $DF
    CMP ($1E,S),Y
    JMP $81BE
    EOR $37
    ADC $D71D5A
    RTS
    LSR $B57D,X
    ROR A
    ADC ($A7,S),Y
    BPL L1060
    ROR $77
    STA [$0000]
    ORA [$0000]
    DEC $D0F3
    DEY
    SBC $839FAB
    ROR $57
    STP
    SBC $4B
    TYX
    TYX
    RTS
    RTS
    BIT $6A,X
    CLV
    CPX $59
    INC $E4C6,X
    LDA [$0000]
    ROR $10E8,X
    EOR ($81),Y
    ADC $7E9D
    LDA $9BCF,Y
    JSR $577F,X
    TYX
    SBC [$0000]
    ADC ($FB),Y
    STA $81,S
    PEA $0415
    DEY
    STY $02,X
    STA [$0000]
    TRB $8F
    ASL $B5
    ROR $03
L10A3:
    STA $5E
    BMI L10A3
    EOR $04
    TSA
    INC $D9,X
    BCC L106A
    LDX $3C22,Y
    DEA
    ORA $B04FE0
    BCS L1084
    XBA
    SBC ($85)
    STX $01D5
    LDA #$7F37
    BMI L10C2
    CPX #$D4EA
    CLC
    AND [$0000]
    STZ $69C0
    LDA ($E3),Y
    STA $10
    TSB $8BF3
    SBC $41,S
    MVN $0093,$8C
    ORA ($10)
    XBA
    BIT $D7,X
    TYA
    TRB $03
    LDA $E39F28
    BIT #$1060
    STA $D10360
    PHY
    AND $13
    TXA
    EOR $2C,X
    SEI
    COP $FB
    CLC
    CPX #$10C2
    CPX #$9E8D
    DEC $E4,X
    ADC $EC,S
    ASL $201D
    CMP [$0000]
    CMP $40F8,X
    INC $EC50,X
    BVS L110C
    TSB $0D30
L1110:
    JSR $2018
    TRB $F842
    SEC
    EOR ($36,X)
    PER $8134
    PLD
    SBC $5D70,Y
    EOR $86,S
    PHD
    SED
    ORA ($C8),Y
    STA $203A8B
    BRA L118A
    TXS
    RTI
    EOR $3E40C5
    ADC ($FD),Y
    EOR [$0000]
    ADC $EB,S
    ROL $7A
    JMP $740E
    CLV
    STZ $8D92
    AND $790028
    ADC ($D2),Y
    CLC
    LDY #$CA46
    ORA $BA5A,X
    STA $DB5286
    ORA ($81,X)
    BPL L1110
    RTI
    PHX
    ADC $BEEEF1
    COP $CA
    CMP $7F,X
    BCS L1112
    INC $7FDD
    STA [$0000]
    SBC $EEBA5B
    STA [$0000]
    AND $C900,X
    BRK $06
    ADC [$0000]
    LDA $D2DC7B
    ROR $FFBA
    TYX
    CMP [$0000]
    SBC $7DDD36
    BIT $99
    PLB
    TCD
    BIT #$EEEA
    ADC $0D5D76
    INC $07BE
    AND ($FC)
    ROR $EE
    CLV
    AND [$0000]
    AND $FF89,X
    STP
    BRK $EF
    INC $36FB
    SBC $F7,S
    CPY $6A
    LSR A
    CPX $FE
    SBC $09,S
    CMP $BC9F,X
    STP
    MVP $DD15,$B0
    EOR $EF3D86
    BRK $1F
    PLX
    ROL $2F,X
    LDA $DDE1,X
    STA $F57381
    AND $30,X
    PHY
    SBC $C802B2
    NOP
    LDA $C7C7D6
    PER $0B07
    EOR $08EB8D
    ADC ($D3),Y
    STA ($E3),Y
    SBC $BAD1B7
    EOR $1A,S
    INC $00F0,X
    BRA L1210
    SBC $6BAC,X
    SBC $7F,X
    ORA $032C18
    ORA $39504B
    XCE
    STA $1EA9
    LDY $0AEA
    TSB $01
    TXY
    STA $EF5F,X
    SBC ($C5)
    SBC ($A1,X)
    LDA $E5C2BD
    ORA ($A2,X)
    BIT $7F10,X
    CLI
    LDA [$0000]
    CLC
    RTI
    CMP $4E,S
    SBC $1B,S
    PLX
    CLD
    STA [$0000]
    ORA $C7FA65
    SBC $4232
    EOR $EFDA26
    BEQ L1291
    SBC $E0EFE3
    LDA $04E0C2
    ADC $3B8304
    CLD
    PER $2A5B
    SBC ($DA)
    EOR $00B836
    PHY
    BIT $7CF0
    EOR ($1C,S),Y
    PLX
    LDX $4D,Y
    LDA $22F971
    ROR $0FDB,X
    BRK $DC
    LDA [$0000]
    CLV
    SBC ($8A),Y
    PLX
    JMP $C3B0,X
    RTL
    ROR $B8BF,X
    EOR $A0,X
    AND $3A,S
    JML [$1B5DFD]
    SBC ($4F),Y
    STZ $7F
    JSR $4247,X
    AND ($D7)
    XCE
    SBC $F51069
    ROR $6CB2,X
    TCD
    LDA $37,X
    JSR $4B64,X
    CMP $38E7
    CMP [$0000]
    CMP [$0000]
    ORA ($F1),Y
    SBC $78FCBB
    ASL A
    CMP $9466,X
    PEI ($46)
    LDA $C85F,X
    LDX $CED1,Y
L1291:
    CMP ($CA),Y
    CMP $863737
    PEA $B300
    JML $988464
    SED
    ORA ($42,S),Y
    ADC $B02F,X
    TXY
    CMP ($CC,S),Y
    CMP $A6AE
    AND $A1DF67
    ADC #$BC65
    XBA
    BNE L1284
    ADC ($1D)
    BRK $F6
    ORA $CFC5
    TAX
    INC $C8ED,X
    ASL $A9
    CMP $6A,S
    BRK $8A
    STP
    WAI
    AND $7FA6
    LDA $B86BEB
    SBC ($40,X)
    INC $0005,X
    STA $F9AC
    DEC $57E7,X
    CMP ($AD,X)
    SBC [$0000]
    TYA
    PLA
    EOR ($E2),Y
    SBC ($7D,X)
    EOR [$0000]
    STZ $7201
    SBC $043D6F
    INC $A7
    CLI
    LSR $B0FF
    LDY $18
    COP $1C
    STY $18
    LSR $B4
    CLC
    ADC $3F,S
    LDY #$E0FE
    LDA $A0FBBD
    STA $5BEDFE
    SBC $301420
    ASL A
    ORA $39
    ADC $EEE88C
    SBC $A73A,X
    AND $D7,X
    STZ $8B3F,X
    ORA $40
    LSR A
    TYX
    ROR A
    AND $84D24A
    BRA L1317
    ADC ($78)
    ORA [$0000]
    PHB
    BNE L12E6
    COP $E4
    TYA
    TDC
    CMP ($FF,X)
    ORA $09FF
    STA ($99)
    SED
    SBC $5E,X
    AND $1B,X
    ADC [$0000]
    LDA $A7C005
    SBC ($BA),Y
    SBC $A3C8,X
    LDA ($AF,X)
    STX $FD
    TRB $F33A
    EOR $F43D8C
    AND $44
    LDY $C57C,X
    NOP
    STY $EDF0
    SBC $AFFE,Y
    ADC $277B,Y
    XCE
    BRK $ED
    BIT $7C
    LDA $12BD97
    LDA ($C7)
    ORA ($EF,X)
    LDY $C9BE,X
    PHP
    ADC ($E7),Y
    ORA $F4C917
    SBC $7F41E0
    STA $01637C
    INC $4C9B
    ADC [$0000]
    ROR $D7C7
    SEP #$E7
    BIT #$07
    ADC $F0800F
    RTI
    TSB $80
    BRL $FA65
    LDA $87E0,Y
    ADC $D8AE9A
    JSR $7C10
    LSR $48
    ORA ($90,X)
    ROR $226A,X
    BIT $7D,X
    ADC ($AA,S),Y
    LDX #$0012
    DEX
    CMP ($7E)
    LDA $EDB2,X
    SBC $F13580
    BMI L1414
    ASL $62
    COP $06
    SBC $A1FC88
    TSX
    TRB $E2
    STA [$0000]
    AND ($77),Y
    CMP $FC11EE
    LDA $C5402F
    SBC $B013A2
    JMP $CEFF
    SBC $4A3EEE
    PHK
    XBA
    SBC $ECFFEA
    SED
    LDA ($08)
    XCE
    LDY $7F3F,X
    SEC
    ROR $BEB6,X
    TSB $B8
    AND $3EBF0F
    CMP ($E1,S),Y
    BCS L141F
    CMP $67004C
    STA $141B00
    AND ($A2),Y
    SBC $98FFB3
    ORA ($FD,X)
    EOR $9D7B
    ADC [$0000]
    ROR $16,X
    JMP $DC75
    ORA $00FE,X
    LSR $5E,X
    CMP $2C,S
    LDA $BE33,Y
    BIT $CB,X
    LDA $DCBB,X
    AND $8F82DC
    REP #$D6
    ORA $63FDEC
    LDA $99,S
    SBC $DB
    LDY $8D,X
    SBC $0854F4
    TAX
    TRB $17
    STA ($06),Y
    STZ $36,X
    PLD
    SBC $2B0C,X
    CMP [$0000]
    NOP
    ORA $47,S
    MVN $3C80,$E2
    ORA ($65,S),Y
    INC $73
    COP $F1
    LDA $6ED73F
    STA $BB7FC3
    EOR ($BE,X)
    EOR ($03,S),Y
    ORA $EDCF,X
    ROR A
    SED
    SBC $FDC0
    EOR $41,S
    CMP ($00),Y
    SBC $BDBE
    SBC #$94
    STY $3C3F
    TDC
    EOR $52B9BA
    BVC L1477
    CPX $1D
    STA [$0000]
    CMP $83D5,X
    ROL $6D9B,X
    PLX
    TSB $0D76
    CMP $1F9EBF
    ADC $31D985
    PLY
    EOR $131602
    INX
    COP $96
    BRK $70
    INC $3C0D
    CMP $8392,X
    ORA [$0000]
    ORA ($0A)
    EOR $0DE8,Y
    CLV
    AND ($F5,S),Y
    SBC $A7E4,Y
    LSR $26FF
    LSR $0F76
    EOR $2853C7
    CLI
    CLI
    BRA L14A1
    AND [$0000]
    SBC [$0000]
    SBC $1FB8D2
    SBC $47,S
    JML [$DD1030]
    ADC $6CD5D9
    AND $7A6D8F
    DEC $11
    EOR $F9,S
    DEC $1D
    ORA $BBFA34
    SBC $5A,X
    ORA $205E
    LDY $58
    LSR $9F,X
    PLP
    LDA $BA,X
    AND ($0C,S),Y
    LSR $38
    TSB $D0
    SEI
    CPY #$F41A
    BEQ L156E
    LDX $F5,Y
    CLI
    CMP [$0000]
    SBC $621768
    ORA $3041,Y
    ROR A
L14FC:
    BPL L14FC
    BMI L1508
    BPL L150A
    AND $1804,Y
    ORA $9A
    EOR #$0F
    ADC $3A0F,X
    CLD
    ORA $F5B61C
    ADC [$0000]
    ORA $B237CC
    CMP $B63F6C
    ROR $88
    ORA [$0000]
    TXA
    ORA $5E
    ORA ($D6,X)
    ADC $3E6ED6
    JSR $E4FB,X
    ORA $D8DB,X
    TSB $A6
    LSR $40
    LDY $79B5,X
    BIT #$FA
    SBC ($E1)
    PHD
    BRK $71
    EOR $364F,X
    SBC ($E6)
    TRB $B59E
    PHY
    ROL $3E,X
    PLB
    STA $09,X
    ORA #$BE
    ADC ($D0)
    BRL $D4A3
    STA [$0000]
    AND ($07,X)
    JSR $2FC0,X
    ORA $0B,X
    LSR A
    JMP $DEEA,X
    SBC $7F00DD
    LDA ($33),Y
    PEI ($7D)
    SBC $CF,X
    ADC [$0000]
    CPX $FCDC
    CPY $1597
    JMP $D0EB,X
    LDA ($F7)
    CLI
    TSB $F5
    LDA #$4A
    NOP
    STY $FA,X
    STA [$0000]
    TCD
    LDA [$0000]
    ORA $A7,S
    LDA $5F3E,X
    PLD
    RTL
    PLB
    AND $00D94C
    BMI L154B
    SEI
    PEI ($EC)
    STA ($51)
    EOR $1B2F
    EOR ($83),Y
    JSR $D939
    SED
    ROL $F76F,X
    SBC $19,X
    ORA ($1F,S),Y
    AND $00
    AND $F8D9,Y
    ROL $F5F7,X
    CLV
    ORA ($81)
    RTL
    LDX $0039
    ORA $48
    ROR $7CEC,X
    ADC ($88,S),Y
    LDA $9E0308
    ASL $E634,X
    AND #$4D
    ADC $7D
    LDY $39,X
    PLY
    AND ($F7)
    ROR $DA,X
    CMP $82C2D8
    STA [$0000]
    CMP $85
    LSR $0068
    DEC $8F03
    CLD
    CPY $60
    ROL $427C,X
    SBC $43,X
    JML $878CDA
    NOP
    JMP $10F7,X
    STA $7EBD,X
    STA $5B9F,X
    STY $5C
    ORA ($F7),Y
    SEC
    SBC ($3B),Y
    COP $0D
    CMP [$0000]
    DEC $FA,X
    DEX
    RTL
    STA $FE3C6F
    INC $823B
    INC $45DD,X
    TCD
    LDA [$0000]
    XCE
    SBC $8BD14F
    AND $F90B,Y
    SBC [$0000]
    JML [$A5B772]
    BVS L165B
    AND [$0000]
    ASL $040C,X
    SBC $2EF8,X
    TDC
    RTL
    ADC ($75,X)
    SBC $8B,S
    SBC $9775F1
    ORA $D5FB
    SBC $F416,Y
    STA $54C70F
    JSR $CE58
    MVN $28B0,$04
    PHP
    CMP $D347,X
    SBC ($D0)
    STP
    SBC [$0000]
    CPY $C0DA
    ORA #$09
    BVS L1630
    PHY
    DEY
    ROR $FF
    SBC ($16,S),Y
    LDA ($AA,X)
    ADC ($FE,X)
    EOR $3A,X
    DEA
    EOR $3AE8,X
    CMP $2FDA,Y
    CMP $02
    LDA $87DB
    ADC $9E14,Y
    PHK
    PEI ($B6)
    INC $5D,X
    STA $BD
    LDX $7F,Y
    SBC [$0000]
    EOR $DC,S
    STY $87
    INC $BBDA,X
    LDX #$ADD4
    JMP $1C22,X
    SBC ($9D,S),Y
    TRB $6260
    SBC $C5,X
    CPY #$5610
    SBC $BAFAC3
    CMP $FE,X
    AND $8795DA
    TYX
    CPY #$F080
    CPY #$38F0
    LDA [$0000]
    ADC ($0D,S),Y
    EOR ($38,X)
    ADC ($10,X)
    WDM $B9
    JSR $6E5A
    ADC ($09)
    ORA ($75,X)
    CMP ($CD,X)
    PHB
    ORA $9FC748
    ADC $B8549F
    LDX $56
    SBC ($DD)
    JMP $037E
    TXY
    ORA $A7EF92
    CPX #$D3AE
    SBC ($86)
    DEC $FF,X
    EOR $740020
    SBC $9B6E1F
    TYX
    ADC $D538
    WAI
    ASL A
    DEC $C383,X
    ORA $EED0DF
    AND [$0000]
    BRK $C4
    JSR $C500
    LDX $069D
    STA [$0000]
    ADC $1273,Y
    PHA
    INC $C1D6,X
    DEA
    STP
    ADC $178900
    LDA $24,S
    AND $046CF8
    CLV
    LSR $7707,X
    TSB $DA9F
    XBA
    PER $4B77
    COP $0C
    COP $BC
    XCE
    CMP ($20,S),Y
    ROR $01
    SBC [$0000]
    SBC ($A2,S),Y
    STY $AF
    INC $DD51,X
    EOR $D93D88
    BRK $BA
    EOR $0CA330
    ASL $DFE0,X
    ADC ($22),Y
    CPX #$710B
    CMP ($00),Y
    ADC [$0000]
    PER $66FB
    TRB $AE
    ORA $55,S
    LDX #$7F8B
    PLX
    CMP ($26)
    INC $00
    BNE L16FE
    CLC
    STZ $9107
    SBC [$0000]
    BCS L17B4
    JMP $0E62
    STA $C107,X
    MVN $882F,$AE
    BRK $EE
    PLB
L175A:
    SBC ($23,S),Y
    BNE L174F
    EOR ($5F),Y
    LDX $3018,Y
    AND $004D67
    CMP [$0000]
    BRK $7F
    JSR $B244
    SBC $4B0056
    LDA ($F4,X)
    LDA $7BF9,X
    REP #$75
    BIT $E01C,X
    SBC [$0000]
    STA $7B592D
    ADC $F9F9,Y
    ADC [$0000]
    SBC [$0000]
    ADC $FCB4,X
    ROR $FB,X
    SBC [$0000]
    AND ($5F,S),Y
    SBC $867A07
    PLD
    BRK $F7
    SED
    SBC $596379
    STX $23
    ROL $F35F
    MVP $024E,$45
    STA $57FB00
    INC $E0A5,X
    ADC [$0000]
    ROL $8DC0
    STA $9DFF44
    BRA L175A
    ASL $67
    AND ($E2,X)
    DEC $EAA6
    TDC
    CMP ($7E,X)
    STP
    LDY $93,X
    EOR ($00),Y
    SBC $D7
    SED
    XBA
    CMP $F3BC,X
    LDY $8B97,X
    BIT $366F,X
    SBC $2E2E,Y
    ORA $8466,Y
    LDA $81FF
    JMP $2050,X
    ORA $27,S
    LDX #$7E00
    ADC ($D9,X)
    ADC [$0000]
    SBC $E677A0
    ADC ($D7)
    SBC $D9BC,X
    EOR ($43)
    SBC ($F6,X)
    CPY #$16FE
    ROR $E8CA,X
    ORA $75D0
    STA $E9BA0C
    PEI ($E9)
    SBC #$EF87
    SBC $F7
    TAX
    EOR ($7C,S),Y
    BRA L187F
    LDX $488A
    BPL L186C
    EOR [$0000]
    TSB $245B
    SBC $661847
    PHP
    TDC
    TSB $17
    PHP
    CLD
    CPX #$31F8
    STA $B1D8FE
    AND $5C01,X
    SBC $000CFC
    TXA
    TRB $7384
    SBC #$0639
    LDA ($AB),Y
    TSX
    SBC $FF,X
    RTI
    CLC
    STZ $08,X
    SEI
    TSB $38
    ORA [$0000]
    AND ($0C)
    JSR $19AF,X
    TYX
    ORA $C7F9CF
    CMP $10
    LDX $D23C,Y
    ORA $F8
    CMP $3728,Y
    ADC ($9D,S),Y
    ROL $D2
    EOR $00,S
    LDA ($53),Y
    BIT #$0FB7
    STA $6E
    EOR [$0000]
    CMP $73
L186C:
    PHA
    REP #$84
    ORA [$0000]
    TRB $21
    ADC $CDBE,X
    SBC [$0000]
    STA ($FE,X)
    CMP $D895,X
    SBC $EFEDBC
    LDX $028D,Y
    TXA
    ORA $EC,X
    INC $E7,X
    LDA [$0000]
    LDA $09C1,Y
    ADC $AA
    SBC $7ADF76
    STZ $FFE3
    BCS L18D9
    PHY
    LDY #$40AD
    EOR [$0000]
    ASL $C9AC,X
    LDA $8BC3,X
    STZ $A5,X
    SBC $3BFF52
    STY $81,X
    CMP $643FC1
    SBC $F829,X
    STP
    AND $030852
    SBC $FE
    EOR ($4F,S),Y
    AND ($DF),Y
    JML [$C1BDAF]
    CMP $52,X
    DEC $0238
    PHB
    ORA ($AB,S),Y
    SBC $078E,Y
    BRL $DBEF
    EOR $FEF68A
    BPL L18E0
    DEC $65D8
    SBC $4F9CE1
    STY $AC
L18E0:
    SBC $79,S
    SBC $2619,X
    BRK $F1
    LDA ($6F,S),Y
    TRB $88B3
    INC $56F3,X
    LDX $30,Y
    STA $D8C33D
    CMP $083F45
    TXS
    SEC
    LDA $EF38,Y
    INX
    INC $FABC,X
    STA $797F34
    PHB
    ROL $7A3B,X
    LDA $ACE6FE
    EOR $A0E1DF
    CMP ($C9,X)
    LDA $4FC797
    JML $35A309
    PER $0ED1
    JML [$87CC00]
    STZ $B9
    STY $FB,X
    SBC [$0000]
    STX $CFF7
    INY
    SBC $DF57F4
    LDX $43
    SBC #$F31E
    INC $06,X
    TSB $10
    TDC
    ORA [$0000]
    INC $C7,X
    EOR $94,S
    TSX
    EOR ($6F,X)
    RTL
    XCE
    STA $501484
    ROR $EB7F
    AND $A0A0,X
    EOR $53,X
    ORA ($D4,X)
    SBC $803FC2
    ADC $77,S
    STA $C3EB
    LDX $65,Y
    LDA $D83F,X
    LDY $C102
    PLP
    SBC $0D8B,Y
    PHK
    CLI
    STZ $40,X
    CMP $23
    BRK $67
    STZ $C7,X
    PLY
    TSX
    TSA
    ORA $F8,S
    TSB $4FEA
    JML [$6BA01F]
    BRK $20
    ADC $8B50,Y
    AND $B65DFE
    ADC $41,X
    AND $C664,X
    ADC ($28,X)
    STA $D6
    LDA $D2F62C
    EOR $16BF40
    INC $80E7
    LDX $D9F3,Y
    LDA ($99,X)
    TRB $A17F
    AND $A816
    BMI L19A6
    ROR $A1BA,X
    XCE
    ORA [$0000]
    SBC $DA424F
    DEC $A9FE
    ORA $BE87C6
L19BA:
    ADC ($88),Y
    EOR $D735C4
    CLV
    EOR ($0C)
    ROL $18
    SBC $273C43
    CLC
    ASL $3C60,X
    CPY #$06A2
    CLC
    INA
    LSR $C1A6,X
    SED
    AND ($80,X)
    EOR $EB,X
    STA $F7F1FC
L19DE:
    AND $1A
    AND ($0D)
    ADC $DD,X
    ASL A
    DEA
    EOR [$0000]
    JSL $AF6018
    TXS
    PHP
    BRA L19FF
    ROR $BC,X
    SBC ($7F),Y
    AND $F5AE,Y
    ADC ($6C,S),Y
    SBC $1F,S
    SBC $E911,X
    TXA
L19FF:
    CPY #$A37C
    TAS
    STA [$0000]
    ROL $608B
    SBC $D3D1,Y
    BCC L19DE
    STZ $83,X
    EOR $FC72,X
    LDX $F3DC,Y
    AND $845F,Y
    ROR A
    AND $D2A92C
    DEC $AFF7
    LDA $042ABE
    PLX
    WAI
    PEA $1F38
    SBC $C3FE,X
    PEI ($91)
    ROL $40B2
    LSR A
    BRA L19BA
    BRK $F6
    CMP $E76B2F
    XBA
    BRK $92
    ORA $DD1E4B
    CPY $48BD
    ORA $51A7,X
    SBC $2A78FB
    SBC $77EF,X
    ADC $86,S
    PHA
    LDX $2D20
    STA ($42,X)
    STA ($7A,S),Y
    AND ($8A)
    PLX
    EOR $DCB4
    EOR $08206F
    LDA $FA,S
    LDA $85,S
    ADC $3FE5
    EOR [$0000]
    LDA [$0000]
    BRK $5D
    BIT $86
    ADC $BD67
    SBC #$AC00
    INC $920C,X
    STZ $AB,X
    EOR $53FF16
    STA $9B,S
    TCD
    PLA
    BNE L1AC0
    AND $D02F8F
    BEQ L1AA6
    LDA $FF,X
    LDA $58B7
    INC $09
    INX
    STZ $27,X
    LDA $F377B7
    ASL $BDD6,X
    LDX $D4FC,Y
    STA $77,X
    EOR [$0000]
    BIT $4C10
    EOR [$0000]
    SBC ($EB,X)
    ROR $AD,X
    LDA #$0ABE
    EOR $C94CF3
    CMP $00F611
    JSR $CE33,X
    TYX
    STX $D6F6
    AND $3BE1
    SBC $DD
    BRK $FC
    JML [$C991B8]
    LDX $CFD7,Y
    SBC ($09)
    SED
    ROR $61,X
    EOR $67,S
    BEQ L1AD6
L1AD6:
    XCE
    EOR $1B75,X
    ASL $1BBF
    AND $C67D50
    ROL $9FA4
    ADC $65F7DD
    LDA ($7D,X)
    SBC $DEEF,X
    LSR $00,X
    SBC ($21),Y
    ORA ($36,S),Y
    SBC $9BF88F
    CMP ($7D,X)
    AND [$0000]
L1AFB:
    PLP
    ORA $548AC0
    ADC $DFDD,Y
    LDY #$9764
    TRB $6C0D
    SBC ($9F),Y
    BCS L1AFB
    SBC $2A,X
    TRB $50
    BRL $1396
    BVC L1B0A
    ASL A
    ROL A
    MVN $C363,$F1
    STZ $4F
    JMP $7E90
    JSR $BF2F,X
    CMP $C483,X
    ASL $FE,X
    ADC ($7A)
    CMP $8447,X
    JMP $A066
    STA $3B5B21
    STX $60,Y
    ADC ($97,X)
    BIT $1201,X
    CLD
    STZ $3EE4
    RTL
    CMP [$0000]
    LDY $CF
    SBC $9171
    SBC $46FAE7
    SBC $200CB8
    PLX
    INY
    ASL $D8
    EOR $1C,S
    INC $0806,X
    RTI
    TSB $2804
    RTI
    LDA $FC,S
    AND [$0000]
    JSR $DF2C
    LSR $7B6F,X
L1B68:
    SBC ($70),Y
    ASL $20F6
    CLC
    STZ $18
    INC $07
    AND $08,X
    CPY #$1428
    LSR $EF83,X
    STZ $03
    ADC $55,X
    BCS L1B68
    RTS
    BRK $EE
L1B83:
    ASL $FB9F
    TYA
    CMP $F8,S
    STZ $CF,X
    STY $8AAF
    ROL $00F9,X
    CLD
    LDA $7AFB,X
    PLX
    STA $4D15
    INX
    EOR $B66FCE
    INC $AA7E,X
    INC $F298,X
    ADC [$0000]
    AND $0D,S
L1BA8:
    SBC $34
    LDY $FF73
    ADC [$0000]
    LDA #$26DC
    CLI
    SBC $00DD,Y
    SBC $6E40,X
    WDM $CE
    AND [$0000]
    ORA [$0000]
    STZ $FB
    EOR ($60,X)
    SBC $0092BF
    CMP $FB05CF
    INC $F357,X
    TCD
    STY $EF
    BRL $270C
    SBC ($00)
    CMP ($41,X)
    ADC ($49)
    PHD
    CMP [$0000]
    LDX $0F26
    BRA L1BA8
    BRA L1B83
    LDA $F2AE3D
    LDA $CAB838
    AND ($5B,S),Y
    ORA $8EEC
    LDY $10
    PLA
    AND $EE6F42
    TYA
    ADC $5DD3,X
    INX
    STX $28
    LDA [$0000]
    STA [$0000]
    JSR $AD9C,X
    XCE
    ADC $CBFF,Y
    LDA [$0000]
    LDY $B7,X
    WDM $57
    PLP
    BVC L1BC6
    ADC $C67350
    PLX
    LDY $9E,X
    STX $EF
    PHP
    STA [$0000]
    SEI
    PLD
    STY $0A
    ORA $91
    LDA $8093
    SBC ($EB)
    ADC ($E6,X)
    BRA L1C36
    PHP
    LDX $4476,Y
    BRA L1BB4
    JSL $48359F
    XCE
    SBC ($17,X)
    TCD
    JMP $FE2F,X
    AND [$0000]
    LDX $CBF7,Y
    TAY
    BRK $1C
    SBC ($96,X)
    ADC $AAB7F7
    TSX
    SEI
    AND ($86)
    LSR $09
    INC $23F0,X
    TAS
    STA $2B6F
    SBC $3B23,X
    ORA $2593A0
    ORA $FF0580
    STA ($EB),Y
    ADC $2D9EC9
    SBC $D0DF75
    AND $86,X
    BPL L1C73
L1C73:
    CMP $79275C
    JSR $3EE6,X
    INC $67,X
    ROR $C46D,X
    JML [$CF9C1C]
    ORA ($3F,X)
    ORA ($94,X)
    JML [$B6067F]
    ROL $D81C,X
    CMP $EF,S
    EOR $A630F8
    CLI
    LSR $9F30
    SBC [$0000]
    INC $06,X
    LDA $3E
    ADC $A050BC
    STZ $FF97,X
    CPX $77
    LDX $7166,Y
    JSR $0E31,X
    ROR $EA,X
    ROL $2E,X
    TRB $C003
    TSB $4D03
    XBA
    CMP [$0000]
    LDY $6A
    STA $DB11,X
    ADC ($83),Y
    ORA $C15E9E
    CMP $E7,X
    SED
    ORA $CA
    CPY #$9085
    RTS
    STA ($A7)
    LDX #$E668
    LDA ($FD,X)
    LDA $5F78,Y
    ADC $CC6A23
    DEC $0F
    ADC $ABFB45
    ORA ($A8,S),Y
    TAY
    ASL $B7EA
    LDA [$0000]
    ADC ($93)
    LSR A
    ADC ($A6),Y
    BRK $D5
    ASL $F7
    ROL $8ECB,X
    CPX $34
    PLY
    SBC $2AFF59
    ASL $39EA
    JMP $884A
    BRA L1D4A
    BRK $65
    XBA
    STA [$0000]
    STA $FFC4BA
    TXS
    EOR $21517B
    STA $D563EE
    EOR [$0000]
    ADC $C6,X
    LDY $8F,X
    EOR $9C73EC
    JSR $3762,X
    CMP $8ACAD8
    STY $14,X
    JSR $E4E5,X
    ADC $1D64
    ORA ($58,X)
    STA $BAE5,X
    INC $0F0D,X
    AND [$0000]
    BCC L1D06
    CMP $F501DF
    LDA $B7,S
    EOR $765046
    ROR $C2F4,X
    PHX
L1D4A:
    PHK
    SBC [$0000]
    JSR $9850,X
    STZ $1E95,X
    ADC $BA6F00
    DEX
    LDA ($6B)
    LDA $EB3F3E
    EOR $6AB8,Y
    SBC $EAFF45
    STA ($5C),Y
    CMP [$0000]
    SBC [$0000]
    JML $002B06
    TXS
    LSR $3FFC
    JMP $7322,X
    AND $0D,S
    PEI ($FF)
    ADC $F3
    SEI
    CPY $83
    STA $ED,S
    SBC $B8
    AND [$0000]
    EOR $BD0661
    TRB $29B7
    LSR $776F,X
    SBC $E571,Y
    PLA
    PHP
    JSR $C2C0,X
    COP $AF
    DEC $96,X
    LDA ($B0,X)
    SBC $DC2B55
    AND [$0000]
    EOR $DB2657
    INC $67D7,X
    TYA
    TXS
    INC $19C6,X
    PLX
    LDA $33
    STX $91F7
    AND $02
    LSR $E1CE
    LDY $DEEF
    BVC L1DE7
    INA
    CMP $2815
    PLP
    MVN $711C,$71
    ORA $AA,X
    BRL $22B0
    JSR $28C3,X
    TXA
    BPL L1D82
    PLX
    INC $081F
    INC $EB40
    STX $0A
    CPY $FF
    ORA ($A5,X)
    AND $F8BF,Y
    WAI
    STA $0AA177
    XCE
    ADC ($AC,S),Y
    ADC $4001E8
    PHK
    ORA [$0000]
    INA
    CMP $436758
    STZ $7E,X
    SBC $E1,S
    INA
    JSR $5D87
    WAI
    ADC $1BEF,X
    DEC $37,X
    PHK
    INX
    SBC $A1D8
    ASL A
    ASL $FB61
    BIT #$5713
    CPY $7D
    JSR $FB0C,X
    EOR ($08,X)
    LDA $7F17B7
    SBC $6C2B,X
    LDX $CF,Y
    SBC $FFDB35
    CMP [$0000]
    CPX #$787B
    BMI L1DC7
    SBC ($C1,X)
    ORA $F61B
    STP
    CMP $00,X
    CMP ($0D,X)
    CLC
    INC $BF,X
    XBA
    STZ $0D,X
    EOR $8B3E,X
    ORA $042B6E
    LDA ($58)
    STY $F7,X
    ADC $11
    PLP
    XBA
    CMP $2E
    AND $6ED71F
    SBC ($B7),Y
    WDM $50
    CMP $52
    BIT $344A
    ASL $80
    SEC
    AND $ABF26F
    ROL $FC78,X
    AND $C87CFB
    SBC $6F8177
    ORA ($0D)
    ORA $C7,X
    LDX $3108
    TSB $1882
    SBC $9016FD
    BRA L1EAF
    STZ $9E
    EOR $31,X
    LDY $40F4,X
    EOR ($A0),Y
    TAY
    XCE
    SBC ($80),Y
    TSB $24ED
    STA $F57723
    LDA ($F8)
    TAX
    ASL $27A1,X
    RTS
    TSX
    AND $20001B
    SBC $5B7E41
    TAS
    CPY $EB
    CLC
    SBC $5F
    JML $20EF7C
    SBC $CA258E
    SED
L1EAF:
    STA $F90D
    LDA $E7CC,X
    ADC ($43),Y
    ADC $0F,S
    EOR $B9,S
    PLX
    SBC $529A,Y
    MVN $874E,$FF
    ASL $06
    TRB $57
    ROL $F2F5,X
    SBC $A6
    PLB
    ORA ($1F,X)
    TRB $35
    STA [$0000]
    ASL $9B,X
    PLA
    SBC $785555
    EOR $22
    CMP [$0000]
    ASL $5F,X
    CMP $7E33E4
    TXY
    SED
    ROL $ECE1
    ROL $04,X
    PLX
    EOR $37D6,X
    ORA [$0000]
    ORA #$F06B
    ADC [$0000]
    REP #$7E
    CMP $00A5,Y
    PLX
    CPX #$E45D
    AND $A14A,X
    ADC ($58,X)
    CMP ($B6)
    STA $F683,Y
L1F09:
    EOR $71,S
    CPX $1BD4
    ORA ($6A),Y
    ADC $2B89D1
    PLD
    ROL $B6
    ORA $F6C0,Y
    NOP
    BIT #$0A91
    ASL A
    SBC $CBE1,X
    ORA $15,X
    JSR $2FE2,X
    ROR $4F,X
    LSR A
    CMP $1F
    AND ($B0,S),Y
    BCS L1F30
L1F30:
    JMP $C5C4
    AND $3F,X
    XCE
    DEC $8B
    BCS L1F32
    SBC $05,S
    LDA ($6C,S),Y
    LDA $45FF,Y
    CLI
    AND [$0000]
    JMP $F801
    LDA $057356
    SBC $557F,X
    SBC $A245,X
    ASL A
    EOR ($D5,X)
    ROL A
    EOR $2AE4,X
    STA $AFA008
    CLV
    SEC
    LSR $F1
L1F60:
    ORA $20,X
    TAY
    BVC L1F60
    BVC L1F09
    TAX
    BVC L1FBF
    ORA ($44),Y
    ASL $10D1
    CMP $DF93FE
    NOP
    WAI
    LDA [$0000]
    JSR $1101
    CMP ($08,S),Y
    BCC L1F82
    CMP ($FA,S),Y
    ADC #$20FA
    PEI ($4C)
    PHD
    TSB $AE
    DEC $1A,X
    INY
    BRK $FD
    PHB
    STY $63
    ROL $DBB4,X
    EOR $311E
    ORA $EA62F8
    BEQ L1FB0
    ROL A
    BRA L1FB3
    ROL $CAC0,X
    ORA $A0E8
    SED
    LDY $3800
    AND [$0000]
    COP $A6
    AND [$0000]
    TYA
L1FB0:
    ROL $F4,X
    ORA $78E8,X
    STA $3300,X
    STA ($3A,X)
    ROL $96,X
    ORA $AF63AC
    AND $CA079C
    EOR $1B,S
    LDA ($40),Y
    TDC
    ORA $037288
    XBA
    LDA $6E7F
    SBC [$0000]
    ADC $A8,X
    TRB $BE
    TXY
    CMP $ED88,Y
    DEA
    BPL L1FC5
    ADC $FB,X
    ADC $9D
    CMP $4035
    AND $F3F9,X
    CMP ($DB),Y
    SEI
    EOR $9F67,Y
    AND $3D
    SBC $03E8
    SBC $9F52,Y
    SEC
    STA $0DD1,X
    AND ($9E),Y
    CMP ($ED),Y
    COP $FF
