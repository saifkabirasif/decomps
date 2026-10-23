;
; Uncharted Waters (USA) - bank02_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $2000-$2FFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $2000

    LDY #$D004
    ROL A
    TAX
    ORA $F9,X
    COP $35
    SBC $12123E
    TDC
    STA $CFAF
    ROL $087F,X
    ROL $DB,X
    CLD
    INX
    CMP $0E069C
    TAY
    AND ($B8)
    INC $FA,X
    ADC $FF21A3
    SBC $FF8B,Y
    TSB $8870
    BVS L2020
    CLV
    RTI
    ASL $F8
    ROR $7CF2
    CMP $56,X
    PHP
L2037:
    BRL $1548
    STA $05,X
    EOR $EB0D
    EOR $FCDD
    ORA ($5B,X)
    CMP [$0000]
    ORA $47,S
    SBC $38FE7D
    TSB $25
    BRL $3069
    ADC [$0000]
    LDY $5F
    SBC [$0000]
    BIT $FF,X
    ADC $B2F604
    INX
    CPX #$18E0
    SBC $0E,S
    TRB $EF
    CMP ($3E,S),Y
    EOR [$0000]
    BIT #$D0B5
    INX
    ORA $B8FEAC
    PHA
    SBC $3E,S
    SBC $5478,Y
    EOR [$0000]
    STA [$0000]
    PLX
    ADC $0662B9
    AND $313FFC
    ROR $0F,X
    ORA ($11,X)
    BVS L20DD
    INX
    PER $1F34
    TXA
    JSR $0F5E
    LDA $A977
    AND $5A
    LSR A
    BNE L20BE
    ADC [$0000]
    STA [$0000]
    AND $1E,X
    PLX
    PEI ($FA)
    PHX
    BNE L2037
    SBC $DC64,X
    CMP $3A90FF
    ADC $83,X
    CMP #$B910
    BRK $90
    BIT $1248,X
    STA ($D2,S),Y
    TYX
    MVP $2CE8,$F5
L20BE:
    EOR $867946
    SBC $01BB
    LDA ($81)
    AND ($7D,S),Y
    LDA #$6D5D
    SBC $CFA4,X
    MVP $449A,$93
    AND $AF98,X
    SBC $CF6E85
    LDA $81E7EB
    EOR $7EFCF6
    INC $BFF5
    ORA $7FFE,X
    INC $36C3,X
    EOR $F5,X
    TAX
    PHP
    EOR $04,X
    CMP $E8503F
    STY $8835
    BRA L211A
    SBC [$0000]
    LDX #$085C
    DEC $C9CA,X
    STA ($FC),Y
    SBC $B4,S
    LDA $E9,S
    EOR $84,X
    COP $9C
    PHX
    SBC $C7
    LDY $6F,X
    EOR $1FD457
    XCE
    CLI
    STX $F9FD
L211A:
    AND $8A,X
    PHP
    TRB $FD
    LDY $7B
    BIT $4A59,X
    BPL L20E7
    PHP
    TRB $CE7A
    DEC $C217
    LDX $DA3C
    CPX $BD
    ADC $BE503E
    CMP ($CA,S),Y
    BVC L210E
    LDA $E9
    EOR $4E06CF
    STA [$0000]
    EOR $3535EB
    LDX $C5F8,Y
    TSX
    CMP $15243F
    ASL A
    JSR $2DA1,X
    AND $86
    ASL $A05D
    ASL $BE8C
    ADC $453A,X
    BVS L216D
    CLV
    BRL $9F62
    SBC $87E7,X
    LDA $E22D,X
    ORA $04
    JSL $16842A
    ORA ($BE,X)
    SBC ($78,X)
    CMP $6614,X
    INX
    ORA $8854
    CMP ($FF,X)
    LDA $016E
    PHP
    JML [$7F88C4]
    WAI
    ORA $674B
    INC $1765,X
    EOR #$C3DE
    SBC $933300
    STA $77FC,X
    LDX $D49B
    LDA [$0000]
    AND $221AFC
    PHX
    SBC $7BFFD5
    TSB $D5
    AND ($7B,S),Y
    TSB $FD
    XCE
    BRK $B7
    ROL $DD81
    ROL $B9,X
    AND $9DEE
    CMP [$0000]
    MVP $86FD,$23
    PEA $3E27
    BVC L21DF
    TSX
    AND $C0F3DB
    DEC $9048,X
    BEQ L21D9
    CPX #$205C
    EOR ($FE),Y
    SBC ($BA,S),Y
    LDA $B8C0
    RTS
    LDA $F07F,X
    CPY #$F9FC
    EOR $F3,X
    LDA $F47F33
    DEA
    ORA $0D
    COP $D8
    EOR ($11,X)
    AND $8729,Y
    ORA $FDBFB2
    INA
    PER $41DB
    ORA $1F
    LDA $16D802
    ORA $A9ADFE
    BPL L2251
    TAY
    CMP [$0000]
    BRA L21F9
    LDA [$0000]
    LDA $8102,Y
    PEA $8440
    PLD
    INC $2D5F,X
    EOR $F39D1C
    ROL $26BF,X
    CMP $136BF8
    JML [$17082A]
    CPX #$79FF
    ADC $7C
    ADC ($FA,X)
    STY $3737
    STA $D7,S
    JSR $BE87,X
    CPX $D864
    BRK $19
    CMP $F70457
    SED
    DEC $7F2B,X
    BNE L21F6
    CPX #$FF9B
    INC $06
    DEC $5F,X
    PLX
    ASL $82D5
    PHP
    JSR $AFA7,X
    JSR $79C8
    SBC $DF,X
    SBC ($6E,S),Y
    PHB
    DEC $908E,X
    ADC $57355F
    ROR $DF31,X
    ADC $E7EFBA
    ORA [$0000]
    SBC $4F4A,Y
    JSR $CFF0,X
    DEC $D43B,X
    SBC $D5,X
    CMP $80CB,X
    ADC ($F5),Y
    TDC
    LDA ($BF)
    LDA $AA78,X
    STA ($CB,X)
    SBC [$0000]
    STA $DEB78E
    LDY $D0,X
    SBC $890F
    LSR $68F7,X
    SBC $EE3EBF
    STZ $44D9,X
    ADC ($FE,X)
    AND $5F3636
    LDA $EFE0,Y
    SBC ($61),Y
    SBC $EE6FB4
    LDA ($2F,S),Y
    BEQ L22F7
    TRB $FBD7
    BIT $3D,X
    CMP [$0000]
    PHY
    LSR $3F
    SBC $CD607F
    CMP [$0000]
    INC $53,X
    CMP $E62ADF
    INA
    EOR [$0000]
    ROL A
    INC $2287,X
    CMP #$4578
    SEP #$4C
    ORA $B9,X
    JMP $98FE,X
    PHB
    ORA $8F6C75
    CMP ($E5,X)
    LDA $83CB,X
    WAI
    PLP
    EOR [$0000]
    SBC ($38)
    WAI
    ROL $54F9,X
    PLP
    CPY #$7C82
    ADC $D03C7B
    BEQ L22B6
    BIT $E1C6,X
    LDA $D580,X
    ORA ($6D,X)
    CPX $FC58
    CMP [$0000]
    AND $FF59,X
    PLD
    AND ($A2),Y
    CPY #$F702
    PHD
    ROL $BDF9,X
    AND ($9B,X)
    CLV
    ADC $BB,X
    SBC ($1E),Y
    EOR $100D70
    ORA ($0F,X)
    SBC #$0DBA
    CPX #$A543
    BIT $E0
    CPX $01
    CMP $EE6B36
    STA $0FFECE
    ORA $C955AF
    ASL A
    SEI
    EOR $723F30
    PHX
    CMP $502D66
    WAI
    RTI
    BIT #$FAFC
    AND $428BC5
    ADC $AA20D2
    ASL $E3E4,X
    ROL $AAF1,X
    TXY
    JSR $0074
    PER $825A
    ADC $7D70,Y
    SBC $FF1C7F
    EOR $E5,S
L2353:
    ROR $66FD,X
    PER $C158
    SBC $A3FC
    ADC [$0000]
    STY $38,X
    LDA $DA,X
    COP $BC
    ROR $49EB,X
    RTL
    STA [$0000]
    AND $2C13,X
    CMP [$0000]
    SBC $40,S
    ADC $AE,S
    XCE
    LDY $BF37
    EOR $DB8C
    ADC $AE,S
    BRK $D9
    CLI
    LSR $F92B
    SBC [$0000]
    ORA $B607,X
    AND $FA,S
    LDX $182F,Y
    ADC $F1
    ORA $F7C4,Y
    ADC $FCFE,X
    CMP #$9F42
    BRA L2409
    ORA ($00,S),Y
    LDA $F7EE1F
    CMP $56A1,X
    EOR $F8F3
    SBC $EF307E
L23A9:
    LDA [$0000]
    ADC $7F,X
    REP #$E4
    DEY
    SBC #$56DC
    XBA
    CMP $38081B
    AND #$F9F2
    INC $41
    SBC ($19,S),Y
    ROR $1D,X
    BVC L2379
    JSR $0DF4,X
    PHY
    BIT $F0
    EOR $0C,S
    BEQ L2435
    ASL $B730,X
    INX
    BVS L2353
    TXA
    CMP $84D8
    LDA ($19)
    EOR ($16,X)
    JSR $D16E
    BEQ L23A9
    DEC $10
    SBC $894A,X
    BCS L2395
    ASL $61
    ROR $975B,X
    ORA $E2,X
    CPX #$EC1F
    ORA ($F3,S),Y
    TSA
    BRK $79
    ORA $A2DD0C
    SEP #$81
    REP #$15
    INY
    SBC ($7F,S),Y
    SBC ($37),Y
    ADC $7E05,Y
    BRK $DF
    STA $28E360
    STA $DB3050
    STA $209481
    CMP ($78,X)
    TYX
    LDA $8318BD
    ORA ($AC,X)
    AND $4F265F
    STY $08,X
    AND $0E2525
    BCC L23E6
    STA $BF7B,X
    CMP $54FF,Y
    PHP
    SBC ($A1)
    SBC $0A15,X
L2435:
    COP $BD
    STZ $5663
    CMP ($5C,X)
    SBC #$00A3
    CLV
    BCC L24A3
    EOR $27,S
    STZ $F7,X
    STA $47C2FF
    SBC $B06320
    ADC $4B,X
    PLX
    TAS
    STA $7A1F30
    ROL $74,X
    ADC $F43495
    ORA $7A8C7F
    LDA ($B7)
    LDX $E9F9,Y
    JSR $044A,X
    LDA $CD7D,X
    STA ($79,S),Y
    CLV
    BIT $CD,X
    CMP $BF,S
    ADC $BF07FE
    LDA #$5A1A
    LSR $910A
    TSB $82B2
    ADC $F851
    XBA
    EOR ($4E)
    ASL $FE
    ADC $E54A60
    STX $E5
    SBC #$0E8B
    TAY
    MVN $CF2F,$03
    ROR $6859,X
    ORA [$0000]
    ADC $9556
    BRK $28
    JSL $01E141
L24A3:
    BRL $D2A8
    LDA ($EE),Y
    ADC ($E6)
    LDY $5F,X
    STA $80
    STA [$0000]
    SBC $6733
    SBC $5A7A,X
    EOR $F1A0
    TAX
    BPL L2461
    LDA $F6
    ROL A
    AND ($27,X)
    TSB $BC
    STA $6FFDB5
    ROR A
    SBC $A457,X
    LSR $A210
    BRK $F9
    EOR ($52,S),Y
    SBC #$59D4
    SEC
    CMP $5BD6,Y
    ORA #$7F9A
    TSA
    INA
    CMP $4B7F4F
    CMP #$2C07
    RTI
    SBC $81,X
    AND ($FA,X)
    SBC #$659A
    JSR $7431,X
    ORA $43DEF3
    STZ $DE,X
    PER $C8D3
    STA [$0000]
    ADC ($21)
    STZ $BF
    PEI ($3F)
    PLA
    PLA
    ADC #$EFC5
    INC $4C07,X
    AND $6AB007
    LDA [$0000]
    ADC ($04,X)
    EOR ($74)
    EOR ($FC,S),Y
    AND ($5D),Y
    CMP ($AA,X)
    JML $2F9E60
    LDX $1784,Y
    EOR $70,X
    SBC $9117BB
    LDY #$613A
    LSR $A4FB,X
    STA [$0000]
    SBC $DFCEE7
    XBA
    SBC $54,S
    STA [$0000]
    TAY
    MVN $2A86,$66
    INX
    CPY $BF
    TSX
    SBC ($82)
    LDA $AF05C0
    TAS
    BRK $EB
    SBC $2E,X
    INC $C1E9,X
    LDA $9F3F,X
    SBC $D0,X
    SBC $3F,X
    DEA
    EOR $A0
    EOR ($3E)
    SBC ($EB,S),Y
    SBC ($6F),Y
    STA [$0000]
    AND [$0000]
    BCC L25B5
    ASL $67
    LDA $76633A
    LDA ($0D,X)
    AND $18E01F
    JSR $D600
    AND #$C0EB
    BRK $DE
    PHD
    LSR A
    CMP #$F961
    CMP ($7C,X)
    ORA ($18,S),Y
    BNE L2524
    SBC $42DB6A
    TAY
    DEY
    EOR $B75F,X
    AND $002021
    SBC $F6D1,Y
    STA ($A0)
    BRA L25EE
    LDA $84DDAD
    LDA [$0000]
    BRA L259F
L259F:
    CPX #$67D6
    TSA
    TXS
    ADC ($C9,X)
    DEC $DB,X
    SEP #$77
    TSB $6BC3
    ORA $0F93F4
    ORA $24,S
    ROR A
    TSB $78
    PHP
    BMI L25FD
    XCE
    SEC
    BIT $18
    JMP $1C30
    CPX #$60
    PHX
    CMP ($C0,S),Y
    SED
    AND $3BB606
    PEA $E851
    ADC $DF971F
    ROL A
    LDY $9079,X
    AND $1C04,Y
    COP $35
    CMP ($0A,X)
    BMI L263A
    ADC $BF,X
    LDA $46E1,X
    PHD
    SBC ($01,X)
    BVS L2607
    STA $BC403F
    CMP $18B1A8
    LDA ($B5),Y
    BRK $80
    AND ($51,X)
    ROR A
    ROL $E176
    INA
    ASL $7F
L25FD:
    ORA [$0000]
    SBC $72,X
    COP $33
    SBC ($18)
    CMP $92F7
    SBC $84B444
    STA [$0000]
    EOR [$0000]
    CMP [$0000]
    JMP $BE80,X
    CMP $4F1F
    ADC $F209D4
    CMP $DC9C65
    INC $9B43,X
    CMP $87FD,Y
    STA $B7,S
    ASL $00
    ADC ($72),Y
    CPX $5C86
    CPY $A15F
    LDA $0689,X
    SBC $17E9
    STZ $45,X
L263A:
    LDA $225D,Y
    ADC #$CA
    SEC
    JMP $42FA
    ROR $15,X
    CMP ($B7),Y
    SBC $2AE996
    SBC $809393
    JSR $7AE4
    BVS L2629
    STA [$0000]
    ORA #$8E
    JSR $E807,X
    ORA #$B8
    TXY
    AND $F1A365
    ADC $28AD95
    BCS L266D
    BIT $94,X
    RTI
    ORA ($C4,X)
L266D:
    ORA $17754A
    JMP $9416
    BPL L26D4
    ASL $F66F
    CMP $670DF2
    XCE
    TRB $C0D7
    LDY #$50
    ORA $FA,X
    SBC ($FE)
    BPL L26D6
    TSB $94
    STA [$0000]
    TXA
    PHY
    STA $5E62,Y
    PEA $24BD
    LDA $BB,X
    LSR $806B,X
    INY
    BIT #$D0
    ORA [$0000]
    ASL $9377,X
    TRB $42A0
    DEX
    INX
    AND $41003F
    BRA L26FC
    EOR $8CE8
    LDA $7C,X
    BPL L26E2
    SBC [$0000]
    XBA
    CMP ($94)
    CPX $51E9
    TSB $F9
    CLD
    ADC $F92B,X
    JSR $9C8C
    EOR $28B0
    SBC $075B
    ORA $A707
    COP $9A
    STA $21EB,Y
    BPL L26E5
    PLP
L26D6:
    CPX $08
    ORA $11,X
    PEA $78FB
    AND $01
    AND $6B0013
    AND $E3,X
L26E5:
    TSX
    STA $9AB525
    ADC ($DD),Y
    CMP $B0,X
    LDA $57FE6F
    DEC $04,X
    PEA $F3A1
    PEA $B75B
    MVN $ADEC,$E7
    ORA ($37,X)
    LDX $6E,Y
    AND $EFCD,X
    INA
    LDA $3BFF80
    CPY $14
    PEA $0A02
    ORA ($04),Y
    ORA $06,S
    ORA ($FD,X)
    PHY
    CMP $4C,S
    BCS L26C4
    INA
    SED
    STP
    XBA
    LDA ($5C)
    ADC $E04018
    CLC
    STY $08
    LDA $F064
    SBC $36DB4C
    INC $DF,X
    JSR $5E70,X
    STA $18,S
    BVS L2743
    BMI L2741
    XCE
    RTS
    INA
    ROR A
    TRB $64
    LDY #$2A
L2741:
    ORA [$0000]
L2743:
    BRK $9D
    SBC $8317,Y
    PHK
    ORA $754A
    ADC [$0000]
    SBC $87,S
    BRK $F6
    ADC $5013,X
    INC $BB,X
    AND [$0000]
    CPY $4BFB
    ORA $DD5B,Y
    BRK $BF
    TSX
    CMP ($7C,X)
    ROL $F0B2,X
    BMI L26F8
    CMP $259A05
    ROR $46
    SBC ($AF)
    STA ($FA),Y
    SBC $F2
    MVP $0FFB,$DD
    ORA $2F3F40
    ORA $F9C3
    SBC $13F0,X
    STA ($11,X)
    CMP [$0000]
    LSR $00
    EOR [$0000]
    ROR $2E,X
    BCC L2808
    RTL
    AND $DB,X
    SBC $FF84B9
    BNE L2758
    CMP $F8A52A
    EOR #$81
    DEC $FF,X
    TDC
    LSR A
    ASL $13,X
    LDX $F4,Y
    EOR ($7C),Y
    EOR $9991,Y
    CPX #$FB
    BRL $711E
    TSB $7FAD
    SEI
    LDA $B2F4,Y
    CMP ($37,S),Y
    LSR $F6A3,X
    WAI
    ORA $2C,S
    LDA $3E,S
    SBC $40,S
    ROR $ED
    ADC $573020
    SBC $38
    AND $052A,Y
    AND $29,X
    STZ $C96F
    ORA $3B,X
    LDX $BFAF,Y
    ROR $50A9,X
    DEC $14
    TAY
    EOR $54
    TAX
    SBC ($2A),Y
    ORA $40,X
    LDX #$AF
    SBC $F479FB
    AND #$44
    BIT $19
    LSR $7D02
    SBC ($F8),Y
    EOR $C782,Y
    ADC $11F279
    LSR $2A80
    SBC ($AD),Y
    EOR $3ADF9C
    BEQ L2857
    SBC $29
L2808:
    WDM $FE
    BMI L27BB
    AND #$42
L280E:
    BPL L280E
    SBC [$0000]
    CMP $80CA73
    EOR $84C3,X
    STA $1E97EA
    CMP $C0,X
    PHX
    LDA $8A3089
    EOR $11,X
    ROL A
    SBC $7A
    BRK $48
    EOR [$0000]
    ADC $F544,Y
    PHP
    STA $F9,S
    DEC $84,X
    PLA
    ADC $880255
    STX $5B,Y
    STA $FCD9
    PHB
    DEC $C575
    STA [$0000]
    ORA ($B5,X)
    STZ $0198
    XBA
    PHY
    STA $837F28
    LDA [$0000]
    INC $FD5B,X
    ASL $72,X
L2857:
    RTS
    SBC $D414AA
    STA $DF,S
    LDA $BE82B3
    INC $900F,X
    CMP [$0000]
    STA [$0000]
    SBC $88EB13
    BIT $5850
    SBC [$0000]
    BMI L2834
    PLP
    ORA $AD,X
    SEC
    PHA
    TRB $39
    INC $A0E1,X
    JSR $3540,X
    STZ $BFF2
    BNE L28C4
    TXY
    LDA $9B,S
    ADC $FC,X
    ADC $08,X
    JSL $BEA01D
    JSR $B9C3
    TRB $08E7
    LDX $7695,Y
    LDA ($93,S),Y
    STY $BC
    SEC
    TRB $97
    AND $2778,X
    EOR $BF,X
    EOR ($BD),Y
    STA [$0000]
    STZ $D5F0
    ADC $CDA700
L28B1:
    DEC $F9
    LDA $F75C37
    TSA
    SBC $DD6EB8
    SBC $DDD5,X
    JSL $7C0A5F
    INC $FD27
    CLV
    LDY $A1DD
    LDY $B0CF
    JSR $2AF3,X
    XCE
    SEP #$6E
    AND $4C9F1B
    ROR $3D42,X
    BMI L28B1
    INX
    STA $3FE6
    ORA $07DE,X
    CPY #$2E
    JSR $A1CD,X
    STA $22FC1D
    AND $10,X
    SBC ($1F,S),Y
    ORA $76,S
    SBC $A5B20B
    TSA
    BRK $F1
    SBC $ACFD6B
    SBC $C55D94
    STA ($95,S),Y
    SBC $54507D
    LDY #$ED
    SBC $10,X
    ASL A
    CMP [$0000]
    CMP ($C8)
    ADC $6AF2
    ASL $4AF9,X
    EOR [$0000]
    STZ $F9,X
    ADC [$0000]
    TAY
L291D:
    TSB $A2
    CLC
    EOR $0001FA
    BMI L291D
    SBC ($12),Y
    CMP $EF9B,X
    AND $FED7,X
    ORA $79
    ADC $662025
    STA [$0000]
    CPY $EC
    ROL A
    SBC $A67F,Y
    STA ($1A,X)
    SBC ($47),Y
    ORA $88,X
    BRK $DB
    SBC ($2D,S),Y
    LDX #$92
    ADC $A942,X
    ORA $AA1F3E
    CLD
    CMP ($10,S),Y
    LDY $00
    CMP [$0000]
    CMP $4EF1
    BRK $8E
    EOR $F8FFFD
    CMP [$0000]
    PHK
    TSA
    SBC ($F8)
    REP #$60
    SBC $2FFF03
    BRK $C5
    JSR $3F9A
    PHB
    STX $E4
    ROL A
    ORA ($2F,X)
    XBA
    EOR ($21),Y
    STZ $EE50
    ADC [$0000]
    EOR $0A,X
    DEY
    WDM $89
    STA $B5FD40
    REP #$A1
    ADC ($08),Y
    TAY
    SBC $5A0DBE
    BRA L29E2
    SBC [$0000]
    ADC ($B1)
    LDA $87,S
    CLD
    SBC ($83,S),Y
L299B:
    LDA $3F87,Y
    BRA L299B
    DEC $1BFA,X
    AND $FDE7CF
    TYX
    AND $9C
    PLX
    DEC $16
    AND #$05B7
    ROR $AB,X
    EOR $46FFE8
    STZ $06,X
    SBC [$0000]
    STA ($92,X)
    AND ($A2)
    INC $700E,X
    EOR $BF,X
    SED
    LDA $1C60
    PLX
    ORA $D8,S
    BCC L29C2
    STA $023DF4
    STA $39,S
    EOR $0C6FCB
    ORA $15,S
    STA $0F30
    ROL $08,X
    BRK $CA
    DEC $F5
    LDA ($3A),Y
    SEP #$26
    SBC ($E2),Y
    AND [$0000]
    EOR $D7B87F
    ORA ($5F),Y
    TXA
    WDM $7A
L29F2:
    ASL A
    TXA
    ADC $05
    REP #$03
    CMP $00,X
    BCS L29F2
    EOR $F8BB8F
    SBC $FF,X
    EOR [$0000]
    EOR $92
    BVS L2A66
    EOR $FDEC
    CMP [$0000]
    ADC $E8,X
    ORA [$0000]
    INC $A7D1,X
    LDA ($19,X)
    LDA [$0000]
    STA ($AF,S),Y
    PHD
    BIT $84,X
    RTS
    JSR $8F3E,X
    STA [$0000]
    SBC ($D4),Y
    CPX $CC
    PHK
    PEA $25AB
    INC $FF02,X
    ADC $FA,S
    SBC $A2B1,X
    STA $5632FB
    BIT $32,X
    SBC [$0000]
    JSR $B5AC,X
    STA $358B98
    JSR $C2AE
    EOR #$6C
    SBC $5DC8,Y
    SEP #$02
    ORA ($7C),Y
    BRK $F0
    EOR $05BCF1
    BVS L2AD5
    CMP ($C9,X)
    SBC ($18)
    PHP
    STA $2A
    AND $8975F9
    DEC $40D4,X
    PEI ($C7)
L2A66:
    MVP $0840,$AB
    EOR ($FF),Y
    EOR $C466CF
    ORA $18,S
    CMP #$1B
    EOR ($C7,S),Y
    INC $6DA9
    BRK $A8
    EOR ($D5,X)
    AND $92C7,X
    LSR $0657,X
    CPX $92
    CPX $50
    ORA $E5E79D
    ADC [$0000]
    BRA L2A2F
    ADC [$0000]
    STA ($DD),Y
    SED
    STA $15
    LDA $A9F204
    SBC ($C1),Y
    SBC [$0000]
    CLC
    SBC $FE,X
    PEA $9042
    ASL $BE57
    COP $BA
    REP #$84
    BRA L2B21
    SBC $07,S
    AND $BF,S
    CMP [$0000]
    CMP $F98E54
    BRK $63
    ORA [$0000]
    SBC ($FF,X)
    ORA $F3F33E
    ASL $6DFB,X
    ORA $80A4,Y
    EOR $DE
    ADC $23A8D7
    ADC $5A40CD
    LDA [$0000]
    SBC $7C72
    BRK $47
    SBC $5F8D,X
    CMP [$0000]
    ADC $CE73,X
    SBC ($FE),Y
    LDA ($EF,S),Y
    LSR $8D00,X
    INX
    SBC #$11
    ADC #$D2
    LDX $75
    LDA $4D4FFB
    ROL $9D8A
    STA $0850DF
    BRA L2B39
    CPY #$03
    CMP ($C7),Y
    BRK $83
    STY $ED,X
    INA
    EOR [$0000]
    NOP
    CPX $9A
    RTS
    ADC $6B23,Y
    RTL
    EOR $575DF7
    LDA $7E,S
    JMP $0680,X
    SEI
    LSR $10E8
    ASL $2020,X
    PHY
    ASL $55B3
    LDA $FC
    CMP $D7FEE0
    ADC ($07),Y
    SBC $1A25FE
    AND ($9E)
L2B30:
    TSB $5C7A
    SBC [$0000]
    AND $18
    CLC
    TSB $56
    SBC $1A80,X
    LDA $2D9B
    STZ $1C,X
    EOR [$0000]
    TSA
    PHX
    ORA $0C,S
    ORA $F37FFE
    BNE L2B5C
    PLP
    BPL L2B30
    LDY $AABB,X
    BRK $70
    ROL $F64E,X
    STA [$0000]
L2B5B:
    INC $F5D5
    LDA $E23EE1
    PLX
    BRK $F6
    ADC $BEC3,X
    RTS
    AND $6D
    CPX $DFF5
    SBC [$0000]
    LDY #$1C
    BRK $A5
    LDA $CEE0B9
    EOR [$0000]
    AND $D8FA,Y
    CMP $02C1,Y
    AND $B9,S
    CMP $FE6E0B
    ASL $E5D6
    REP #$4A
    SEP #$E7
    REP #$20
    BVC L2B88
L2B91:
    BRK $EA
    AND $D9
    STZ $5F75
    ADC $61F102
    ROR $54,X
    CPY $67
    INY
    TCD
    ASL A
    ADC $B9CFED
    JMP $37E0,X
    AND ($54),Y
    ORA $852BD5
    BRA L2C28
    JSR $C707,X
    STA $6FE47F
    EOR $F6DDC4
    ORA $2A5454
    CPY #$02
    ORA ($95),Y
    BVS L2B5B
    ADC $C3036F
    ADC $B19F,X
    STX $2F,Y
    BRK $DC
    LDA [$0000]
    CLD
    INC $BF
    BNE L2BD8
    CPY $AB
    ASL $B962,X
    LSR $BF0D,X
    BRA L2BF8
    JSR $C3C3,X
    PLY
    EOR [$0000]
    EOR $45,S
    AND [$0000]
    PHA
    ROR $59,X
    ROR $FF02,X
    ROR $1F09
    ROR $BFFC,X
    SBC $91AC,X
    TXY
    XCE
    EOR ($83,X)
    BVC L2B91
    EOR ($E9,X)
    WAI
    STZ $FDB8,X
    ADC ($86,X)
    PHA
    WDM $04
    TSB $BDFB
    ADC $3683,Y
    ADC $50AC,Y
    EOR #$2F60
    JML [$895F1F]
    JMP $2C6F,X
    BNE L2C43
    TRB $1922
    AND $F860,Y
L2C28:
    BRK $07
    ASL $75
    STA $B8,X
    WDM $D5
    LDA ($A7,X)
L2C32:
    ROL $F678
    AND ($DC),Y
    STA ($01)
    ORA [$0000]
    PLB
    BIT $F5,X
    ROL A
    PLD
    JML $FCAB7D
    ADC $8680
    BVS L2C32
    ORA ($C3,S),Y
    LDA $77,S
    STA $A7FB43
    LDA $57,S
    CMP ($0F,S),Y
    BRA L2C52
    REP #$49
    AND $16FD78
    PLX
    STY $77
    EOR $F02BEB
    ADC $FE5A,X
    BPL L2C8E
    AND [$0000]
    DEX
    JSR $DEE1,X
    ADC [$0000]
    AND $9CD2,Y
    RTL
    CMP $170046
    EOR [$0000]
    ROR $BF97
    LDA $D4,S
    RTI
    PLX
    LSR $68
    TXY
    ORA ($BB),Y
    SBC ($D8,S),Y
    ORA [$0000]
    LDY $12,X
    BVC L2CF1
    BRL $2A6B
    EOR ($09,X)
    CMP $1F001C
    XCE
    REP #$A1
    SBC $B3320C
    LDA $34EF4D
    ORA ($31,X)
    EOR $7E301C
    STA ($81),Y
    JSL $2F2088
    STA $9E,S
    INC $C325,X
    SBC $25E4
    JMP $0ABA
    PLX
    JML [$28A805]
    CMP $75,S
    ASL A
    ROL $0257,X
    ROR $B5
    SBC ($DF,S),Y
    PLP
    DEC $FF,X
    MVP $2958,$B7
    ORA [$0000]
    DEC $0065
    JSL $1B9B2A
    STA [$0000]
    AND [$0000]
    LDX $F5CA,Y
    BVS L2CA6
    LDA [$0000]
    DEC $35F8
    BRK $F2
    AND [$0000]
    TSB $4FCF
    SBC [$0000]
    PLY
L2CF1:
    CMP $00,S
    ORA ($0E),Y
    SBC ($A7,S),Y
    INC $82
    INC $1A
    JMP $277C
    EOR $93E2,X
    SEP #$1F
    ORA $BC,S
    SBC $F720FE
    EOR $BA101C
    TXY
    EOR $1C9F,Y
    JSR $4EFF
    BMI L2D3A
    CLD
    LSR $1EB0
    RTS
    ROL A
    CPX $37
    JML [$28FCE7]
    STA [$0000]
    LDA [$0000]
    INC $FBDB,X
    TXY
    CPX $FF
    CPX $3E
    ORA ($FD,X)
    LDA ($30,S),Y
    TSB $349C
    AND $1BAF
    INC $18,X
L2D3A:
    JSL $27EF1C
    RTL
    PLP
    TSX
    ORA $3F8967
    BCS L2D8F
    EOR ($92)
    BRA L2DCA
    XBA
    TRB $EEB2
    ORA ($EF,X)
    STA $6E,S
    SBC $11AFAF
    TSX
    JSR $00B1,X
    CMP ($97)
    CMP ($1D,X)
    CMP ($FD,X)
    STA [$0000]
    STZ $B7
    CPY $3DA2
    ADC $004EA1
    SBC $2322,Y
    XCE
    PLD
    LDX $83B3,Y
    DEC $DA9F,X
    ADC $790C44
    AND $BF6800
    BVC L2DB6
    LDA $052E
    CMP ($3E)
    SBC $AB,X
    TRB $5F
    INC $97A2,X
    AND $C7FE81
    XCE
    BRA L2DB6
    ORA $D5
    JSR $800A
    EOR $E5,X
    JSL $45ED64
    CMP $2746,Y
    BPL L2D42
    CMP ($CF,S),Y
    ADC $1600
    TSB $FFDF
    CMP ($3E,S),Y
    LDX $02
    SBC $97,X
    BVC L2D36
    SBC $230F89
    TSB $73FF
    SBC $088C,Y
    EOR $05,S
    LDX #$8A
    MVP $51DC,$AA
    ADC $A80466
L2DCA:
    TAY
    STA $C9DF,X
    STA [$0000]
    ADC ($C8,X)
    ORA ($22),Y
    LDX #$14
    CMP $14802E
    STA $01,X
    ADC [$0000]
    XBA
    EOR [$0000]
    BRA L2D83
    TXS
    COP $18
    EOR $A7E98C
    CMP [$0000]
    TAY
    BPL L2E41
    CLC
    LDA [$0000]
    INY
    EOR $FDFF76
    TRB $AA
    BRL $1A94
    TXA
    LDX #$00
    DEC $21,X
    LDA [$0000]
    TDC
    ADC $30,X
    ASL $59B5
    BMI L2E0D
    TDC
    JMP $3FAF,X
    ORA $59,S
    LDA ($36)
    CMP $D461,X
    CMP $EA6B2C
    ORA ($88,S),Y
    PHP
    TAX
    STA [$0000]
    LSR $BBF6
    AND $8DF526
    INC $8201,X
    DEY
    BRK $86
    LDA $3BBB,Y
    AND ($F7,X)
    STA $CF7F55
    LSR $27
    ADC $0867,X
    DEA
    SBC $2BCD,Y
    SBC [$0000]
L2E41:
    PHD
    AND $F27C14
    AND [$0000]
    STY $89D7
    SBC ($14,X)
    EOR $DC643F
    CLI
    STY $80
    LDY #$1E
    TXA
    SBC $7B5F
    CMP $5F,S
    LSR $38
    STX $CE70
    DEC $6894,X
    BIT $DF0E,X
    AND $5EFB,Y
    JSR $E01C
    BIT $065C,X
    ADC $A0,S
    JSL $7F3D3E
    ADC [$0000]
    AND $0E105F
    SBC $031C,X
    ORA $3702
    BRK $9D
    LDA $01D676
    SEP #$05
    AND $FDAE05
    SBC $43C5
    TSB $3437
    CMP $F631,Y
    EOR $A5C0C0
    ADC ($DC,S),Y
    CMP $DF,S
    BEQ L2E6C
    BRK $A5
    ADC [$0000]
    SBC ($CA),Y
    LDA $EB30ED
    STA $260C22
    LSR $CECC,X
    BRK $88
    SBC $FFB3B1
    SBC [$0000]
    TYX
    STX $AB
    ROL $891F,X
    SBC $CAE9F1
    CLC
    MVN $003D,$74
    SBC $3FDFA7
    CLI
    SBC [$0000]
    ASL $0C9E
    STY $7F
    EOR $25B1BB
    PLP
    ASL A
    ORA $6C,X
    STA [$0000]
    EOR ($37,X)
    SBC $5D83FF
    TXA
    TAX
    TSB $A0F2
    DEY
    EOR $73
    STA $458A12
    RTI
    ORA $ADFE
    CMP [$0000]
    MVN $01BE,$2C
    ADC ($05,X)
    BVC L2F01
    PLP
    TRB $AE
    ADC $578304
    ORA $8B835F
    AND ($61)
    ASL $F5
    TYA
    ASL $14,X
    STX $F5
    ROR $90,X
    CLC
    AND $0C,S
    JSR $28C2,X
    EOR $D3,X
    CMP ($8F,X)
    PHX
    CLC
    EOR ($00,S),Y
    EOR [$0000]
    LDA $D1E6,X
    CPY #$37
    ADC $F17C,X
    AND [$0000]
    ORA ($C5,X)
    CLI
    DEC $00,X
    STA ($4B),Y
    CMP $6FF6F1
    TSA
    ROR $EDF3,X
L2F3E:
    RTI
    ADC [$0000]
    CLC
    BPL L2F2E
    AND $5C,S
    ORA [$0000]
    JSR $81F1
    JSL $D5FF39
    LSR $B8
    STX $FB,Y
    PLA
    ROL $2CD0
    BNE L2F3E
    AND $611804
    SBC $0CAB,X
    BPL L2EF8
    TCD
    RTS
    BCS L2FA5
    XCE
    JMP $24A9,X
    LDA $1218,X
    ORA $011E
    NOP
    EOR ($16),Y
    CPX #$01
    ASL $9501
    CPY $06
    TDC
    SEP #$41
    SBC ($6B),Y
    EOR [$0000]
    AND $630F,Y
    SBC $865996
    ADC $0AF1F1
    INX
    ROL A
    STA $15,X
    TRB $07
    PLX
    LDY $2D,X
    LSR $1B13,X
    PHX
    RTI
    SBC $C5,X
    PLP
    CMP $AC6683
    ORA [$0000]
    SBC $BD3BCE
    ASL A
    PLA
    AND $3311,Y
    LDX $8378,Y
    ORA $458E2E
    SBC $2D,X
    INC $5C20
    XBA
    XCE
    JMP $7DBB,X
    CPX $CE61
    CPX $45
    ORA $EE
    BRK $AE
    PLX
    LDA [$0000]
    ROR $EAE2,X
    ADC $0E7236
    ADC $B067
    LDA ($FE,X)
    JSR $1F63
    SBC $AB,S
    ROR $33,X
    TCD
    TCD
    JML [$70E37F]
    AND ($00)
    TSB $0F71
    TCD
    ORA $3B33DC
    EOR $7F3F,Y
    CMP $FFCD,Y
    SBC ($C9,S),Y
    BRK $8D
    ORA $C942BE
    ROL A
    EOR $36FFBA
    SBC $000000
