;
; Uncharted Waters (USA) - bank09_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $B000-$BFFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $B000

    LDY $AF,X
    LDA $BF
    XBA
    LDA #$8503
    LDA $BE25EB
    BEQ LB03F
    STZ $BA
LB010:
    CLC
    ROL A
    BCS LB019
    SEC
    ROR $BA
    BRA LB010
LB019:
    LDA $BA
    AND $BE
    STA $BA
    BNE LB033
    LDA $C0
    STA $BE
LB025:
    JSR $AEEE
    JSR $AE8D
    BCC LB030
    JMP $AFB4
LB030:
    JMP $AFAA
LB033:
    LDA $BA
    STA $BE
    JSR $AE8D
    BCC LB03F
    JMP $AFB4
LB03F:
    LDA $BE
    JSR $B1D7
    LDX $A5
    STX $A8
    JSR $AF0C
    LDA $BE
    EOR #$85FF
    CPY #$A5A6
    BMI LB05D
    JSR $AF51
    BCC LB05D
    JMP $AFB4
LB05D:
    LDX $A8
    STX $A5
    JSR $AF21
    LDX $A5
    CPX $A3
    BCS LB079
    ROR $BF
    PHP
    JSR $AF51
    BCC LB076
    PLP
    JMP $AFB4
LB076:
    PLP
    ROL $BF
LB079:
    LDX $A8
    STX $A5
    LDA $C0
    EOR #$85FF
    LDX $0129,Y
    BNE LB08A
    JMP $AFAA
LB08A:
    JSR $AEFD
    JSR $AF36
    BCS LB025
    LDA $BE
    STA $C0
    LDA #$85FF
    LDX $C420,Y
    LDA ($4C),Y
    ASL A
    BCS LB0C1
    PLA
    LDX $0390
    JMP $AFB4
    JSR $AED0
    LDA $BE
    BNE LB0BA
    LDY $B6
    CPY $B8
    BEQ LB0B8
    JMP $AFA5
LB0B8:
    CLC
    RTS
LB0BA:
    LDY $A5
    PHY
    LDA $BE
    PHA
    JSR $AED0
    LDA $BE
    STA $BF
    PLA
    STA $BE
    LDY $A5
    STY $C0
    PLY
    STY $A5
    REP #$20
    LDA $A1
    CLC
    ADC #$0010
    STA $97
    LDA $A5
    STA $94
    JSR $B21E
    ASL $94
    ASL $94
    ASL $94
    LDA $A5
    AND #$000F
    LSR A
    CLC
    ADC $94
    STA $94
    LDA $58
    STA $97
    JSR $B21E
    ASL $99
    ASL $99
    LDA $5C
    CLC
    ADC $99
    STA $94
    SEP #$20
    LDA $5A
    STA $96
    LDY $A5
    CPY $C0
    BEQ LB155
    JSR $B15F
LB114:
    JSR $AEFD
    LDY $A5
    CPY $C0
    BEQ LB155
    LDY #$0000
    STY $97
    STY $99
    LDY $97
    LDA [$0000]
    LDY $99
    STA [$0000]
    INC $97
    INC $99
    LDY $97
    LDA [$0000]
    LDY $99
    STA [$0000]
    INC $97
    LDY #$0010
    STY $99
    LDY $97
    LDA [$0000]
    LDY $99
    STA [$0000]
    INC $97
    INC $99
    LDY $97
    LDA [$0000]
    LDY $99
    STA [$0000]
    BRA LB114
LB155:
    LDA $BF
    STA $BE
    JSR $B15F
    JMP $B0A8
    LDA $BE
    EOR #$FF
    STA $BA
    LDY #$0000
    STY $97
    STY $99
    LDY $97
    LDA [$0000]
    AND $BE
    STA $BB
    LDY $99
    LDA [$0000]
    AND $BA
    ORA $BB
    STA [$0000]
    INC $97
    INC $99
    LDY $97
    LDA [$0000]
    AND $BE
    STA $BB
    LDY $99
    LDA [$0000]
    AND $BA
    ORA $BB
    STA [$0000]
    INC $97
    LDY #$0010
    STY $99
    LDY $97
    LDA [$0000]
    AND $BE
    STA $BB
    LDY $99
    LDA [$0000]
    AND $BA
    ORA $BB
    STA [$0000]
    INC $97
    INC $99
    LDY $97
    LDA [$0000]
    AND $BE
    STA $BB
    LDY $99
    LDA [$0000]
    AND $BA
    ORA $BB
    STA [$0000]
    RTS
    LDY #$0000
    LDA [$0000]
    INY
    ORA [$0000]
    LDY #$0010
    ORA [$0000]
    INY
    ORA [$0000]
    EOR #$FF
    RTS
    EOR #$FF
    STA $C0
    LDY #$0000
    LDA [$0000]
    AND $C0
    STA [$0000]
    INY
    LDA [$0000]
    AND $C0
    STA [$0000]
    LDY #$0010
    LDA [$0000]
    AND $C0
    STA [$0000]
    INY
    LDA [$0000]
    AND $C0
    STA [$0000]
    RTS
    PHP
    REP #$30
    PHA
    LDY #$0000
    STY $99
    LDY #$0010
LB208:
    LDA $94
    LSR A
    BCC LB214
    CLC
    LDA $99
    ADC $97
    STA $99
LB214:
    ROR $99
    ROR $94
    DEY
    BNE LB208
    PLA
    PLP
    RTS
    PHP
    REP #$30
    PHA
    LDY #$0000
    STY $99
    LDY #$0010
LB22A:
    ASL $94
    ROL $99
    SEC
    LDA $99
    SBC $97
    BCC LB239
    STA $99
    INC $94
LB239:
    DEY
    BNE LB22A
    PLA
    PLP
    RTS
    REP #$10
    SEP #$20
    LDA $5E
    BEQ LB25D
    LDX $64
    JSR $9C3D
    STY $64
    STX $66
    SEP #$20
    STZ $0B87
    STZ $0B88
    INC $0B88
    LDA $5E
LB25D:
    BNE LB262
    JMP $B315
LB262:
    LDA $56
    STA $0B8C
    STZ $0B8D
    LDA $5A
    STA $0B90
    STZ $0B91
    XBA
    LDA $58
    STA $0B8E
    STZ $0B8F
    LDA $5C
    STA $0B92
    STZ $0B93
    REP #$30
    STA $4202
    LDA $60
    DEA
    STA $0BA8
    STZ $0BAA
    LDX $62
    STX $0BA4
    STX $0BA6
    LDA $4216
    ASL A
    STA $0B94
    SEP #$20
    LDA $54
    CMP #$01
    BEQ LB2B1
    CMP #$02
    BEQ LB2B6
    LDX $0B32
    BRA LB2B9
LB2B1:
    LDX $0B2E
    BRA LB2B9
LB2B6:
    LDX $0B30
LB2B9:
    REP #$20
    LDA $0B8E
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC $0B8C
    STA $0BA2
    TXA
    CLC
    ADC $0BA2
    STA $0BA2
    LDX $65
    STX $0B97
    STX $0B8A
    LDX $64
    STX $0B96
    STX $0B89
    LDA $0BA8
    SEP #$20
    DEA
    LDY #$0003
    LDX $0B94
LB2EE:
    XBA
    PHP
    JSR $B316
    PLP
    LDA $0B89
    STA $0B96,Y
    LDA $0B8A
    STA $0B97,Y
    LDA $0B8B
    STA $0B98,Y
    INY
    INY
    INY
    XBA
    DEA
    BPL LB2EE
    SEP #$20
    INC $0B87
    INC $0B88
    RTS
    PHP
    REP #$30
    PHA
    PHX
    PHY
    TXA
    CLC
    ADC $0B89
    ORA #$8000
    STA $0B89
    BCC LB32E
    SEP #$20
    INC $0B8B
LB32E:
    REP #$30
    PLY
    PLX
    PLA
    PLP
    RTS
    REP #$10
    LDX $5E
    JSR $9C3D
    STY $5E
    STX $60
    SEP #$20
    STZ $0B87
    STZ $0B88
    INC $0B88
    REP #$30
    LDA $54
    ASL A
    ASL A
    STA $0BB9
    LDA $5A
    DEA
    STA $0BB3
    STZ $0BB5
    SEP #$20
    LDA $56
    STA $0BB7
    STZ $0BB8
    LDX $5C
    STX $0BAF
    STX $0BB1
    LDA $58
    BNE LB38E
    LDX $0BB9
    LDA #$F0
    XBA
    LDA $0BB7
LB37C:
    XBA
    LDA #$F0
    STA $0901,X
    INX
    INX
    INX
    INX
    XBA
    DEA
    BNE LB37C
    LDA #$00
    BRA LB395
LB38E:
    PHP
    JSR $B3A4
    PLP
    LDA #$02
LB395:
    STA $0B87
    STA $0B88
    LDA #$01
    ORA $0B56
    STA $0B56
    RTS
    REP #$10
    SEP #$20
    LDA #$04
    LDX $54
    PHP
    JSR $8CEA
    PLP
    LDX $5E
    STX $3D
    LDA $60
    STA $3F
    LDA #$00
    STA $0B56
    REP #$20
    LDA #$0000
    SEC
    SBC $3D
    STA $0E01
    LDA $54
    ASL A
    ASL A
    TAX
    LDY #$0000
    STY $0BCB
    SEP #$20
    LDA $56
    STA $0B5C
    LDA [$0000]
    STA $0900,X
    INY
    CPY $0E01
    BNE LB3EB
    PHP
    JSR $922B
    PLP
LB3EB:
    LDA [$0000]
    STA $0901,X
    INY
    CPY $0E01
    BNE LB3FB
    PHP
    JSR $922B
    PLP
LB3FB:
    LDA [$0000]
    STA $0902,X
    PHX
    LDX $0BCB
    STA $0BBB,X
    PLX
    INY
    CPY $0E01
    BNE LB413
    PHP
    JSR $922B
    PLP
LB413:
    LDA [$0000]
    STA $0903,X
    INY
    CPY $0E01
    BNE LB423
    PHP
    JSR $922B
    PLP
LB423:
    LDA [$0000]
    STA $0BCD
    INX
    INX
    INX
    INX
    INY
    CPY $0E01
    BNE LB437
    PHP
    JSR $922B
    PLP
LB437:
    PHX
    PHY
    LDY $0B5A
    CPY #$0004
    BEQ LB443
    BRA LB44C
LB443:
    LDY #$0000
    STY $0B5A
    INC $0B58
LB44C:
    DEY
    BMI LB453
    ASL A
    ASL A
    BRA LB44C
LB453:
    XBA
    LDY $0B5A
    INC $0B5A
    LDX $0B58
    LDA $9A96,Y
    AND $0B00,X
    STA $0B00,X
    XBA
    ORA $0B00,X
    STA $0B00,X
    LDX $0BCB
    LDA $0BCD
    AND #$02
    BEQ LB47E
    LDA $0B40
    AND #$0F
    BRA LB487
LB47E:
    LDA $0B40
    AND #$F0
    LSR A
    LSR A
    LSR A
    LSR A
LB487:
    STA $0BC3,X
    INX
    STX $0BCB
    PLY
    PLX
    DEC $0B5C
    BEQ LB498
    JMP $B3DB
LB498:
    RTS
    REP #$10
    LDX $62
    JSR $9C3D
    STY $62
    STX $64
    SEP #$20
    STZ $0B87
    STZ $0B88
    INC $0B88
    LDA $5A
    BEQ LB4E4
    REP #$30
    LDX $0BCE
    BNE LB4CB
    LDA $5C
    DEA
    STA $0BD0
    STZ $0CB8
    LDX $5E
    STX $0BD2
    STX $0CB6
LB4CB:
    JSR $B4ED
    JSR $B54F
    REP #$20
    LDA $60
    STA $0CB4
    SEP #$20
    LDA #$03
    STA $0B87
    STA $0B88
    BRA LB4EC
LB4E4:
    JSR $B59B
    REP #$20
    STZ $0CB4
LB4EC:
    RTS
    REP #$30
    LDY $54
    TYX
    CLC
    LDA #$0001
LB4F6:
    DEY
    BMI LB4FC
    ASL A
    BRA LB4F6
LB4FC:
    ORA $0BCE
    STA $0BCE
    TXA
    ORA #$0C00
    STA $4202
    NOP
    NOP
    NOP
    NOP
    NOP
    LDA $4216
    TAX
    LDA $63
    STA $0BD5,X
    STA $0B8A
    LDA $62
    STA $0BD4,X
    STA $0B89
    INX
    INX
    INX
    TXY
    SEP #$20
    LDA $0BD0
    DEA
    LDX #$0020
LB52F:
    PHP
    JSR $B316
    PLP
    XBA
    LDA $0B89
    STA $0BD4,Y
    LDA $0B8A
    STA $0BD5,Y
    LDA $0B8B
    STA $0BD6,Y
    INY
    INY
    INY
    XBA
    DEA
    BPL LB52F
    RTS
    REP #$30
    LDA $54
    ASL A
    TAX
    SEP #$20
    LDA $56
    CMP #$02
    BEQ LB587
    CMP #$01
    BEQ LB57E
    CMP #$00
    BNE LB59A
    REP #$30
    LDA $58
    AND #$01FF
    CMP #$0100
    BCS LB576
    LDY $0B2A
    BRA LB58E
LB576:
    AND #$00FF
    LDY $0B2C
    BRA LB58E
LB57E:
    REP #$30
    LDA $58
    LDY $0B36
    BRA LB58E
LB587:
    REP #$30
    LDA $58
    LDY $0B38
LB58E:
    STY $58
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC $58
    STA $0C94,X
LB59A:
    RTS
    REP #$30
    LDA #$0000
    TAX
LB5A1:
    STA $0C94,X
    INX
    INX
    CPX #$0020
    BNE LB5A1
    TAX
LB5AC:
    STA $0BD4,X
    INX
    INX
    CPX #$00C0
    BNE LB5AC
    STZ $0CB4
    STZ $0BCE
    SEP #$20
    STZ $0B87
    INC $0B88
    RTS
    SEP #$20
    LDA $54
    CMP #$03
    BCC LB5D4
    REP #$10
    LDX $56
    STX $0CB4
LB5D4:
    STA $0B87
    INC $0B88
    RTS
    REP #$30
    LDY $56
    LDA $54
    ASL A
    ASL A
    TAX
    PHX
    LDA $58
    BMI LB5FD
    SEP #$20
LB5EB:
    PHA
    CLC
    ADC $0900,X
    STA $0900,X
    INX
    INX
    INX
    INX
    PLA
    DEY
    BNE LB5EB
    BRA LB618
LB5FD:
    REP #$20
    EOR #$FFFF
    INA
    SEP #$20
LB605:
    PHA
    SEC
    SBC $0900,X
    EOR #$FF
    INA
    STA $0900,X
    INX
    INX
    INX
    INX
    PLA
    DEY
    BNE LB605
LB618:
    LDY $56
    PLX
    REP #$20
    LDA $5A
    BMI LB635
    SEP #$20
LB623:
    PHA
    CLC
    ADC $0901,X
    STA $0901,X
    INX
    INX
    INX
    INX
    PLA
    DEY
    BNE LB623
    BRA LB650
LB635:
    REP #$20
    EOR #$FFFF
    INA
    SEP #$20
LB63D:
    PHA
    SEC
    SBC $0901,X
    EOR #$FF
    INA
    STA $0901,X
    INX
    INX
    INX
    INX
    PLA
    DEY
    BNE LB63D
LB650:
    SEP #$20
    LDA #$01
    ORA $0B56
    STA $0B56
    RTS
    REP #$30
    LDY $56
    LDA $54
    ASL A
    ASL A
    TAX
    SEP #$20
    LDA #$F0
LB668:
    STA $0901,X
    INX
    INX
    INX
    INX
    DEY
    BNE LB668
    LDA #$01
    ORA $0B56
    STA $0B56
    RTS
    SEP #$20
    REP #$10
    LDA $5C
    BEQ LB6A4
    LDA $54
    STA $0DD2
    LDA $56
    STA $0DD4
    LDA $58
    STA $0DD3
    STA $5A
    STA $0DD5
    LDX $5E
    STX $0DD0
    STX $0DCE
    STZ $0DCD
    LDA $5C
LB6A4:
    STA $0DCC
    RTS
    SEP #$30
    LDA $54
    TAX
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    XBA
    LDA #$1F
    AND $0B3F
    STA $0B3F
    XBA
    ORA $0B3F
    STA $0B3F
    STA $2101
    LDA $9A9A,X
    STA $0B40
    RTS
    REP #$10
    SEP #$20
    LDA $5A
    STA $3F
    LDY $58
    STY $3D
    JMP $B6E9
    REP #$10
    LDX $58
    JSR $9C3D
    SEP #$20
    TXA
    STA $3F
    STY $3D
    SEP #$20
    STZ $0B56
    LDA #$04
    LDX $54
    PHP
    JSR $8CEA
    PLP
    LDA $56
    STA $0B5C
    REP #$20
    LDA #$0000
    SEC
    SBC $3D
    STA $0E01
    LDA $54
    ASL A
    ASL A
    TAX
    LDY #$0000
    SEP #$20
LB711:
    LDA #$04
    STA $0BCB
LB716:
    LDA [$0000]
    STA $0900,X
    INY
    CPY $0E01
    BNE LB726
    PHP
    JSR $922B
    PLP
LB726:
    INX
    DEC $0BCB
    BNE LB716
    LDA [$0000]
    INY
    CPY $0E01
    BNE LB739
    PHP
    JSR $922B
    PLP
LB739:
    PHX
    PHY
    LDY $0B5A
    CPY #$0004
    BEQ LB745
    BRA LB74E
LB745:
    LDY #$0000
    STY $0B5A
    INC $0B58
LB74E:
    DEY
    BMI LB755
    ASL A
    ASL A
    BRA LB74E
LB755:
    XBA
    LDY $0B5A
    INC $0B5A
    LDX $0B58
    LDA $9A96,Y
    AND $0B00,X
    STA $0B00,X
    XBA
    ORA $0B00,X
    STA $0B00,X
    PLY
    PLX
    DEC $0B5C
    BEQ LB778
    BRA LB711
LB778:
    INC $0B56
    RTS
    REP #$10
    SEP #$20
    LDA $58
    BEQ LB79A
    LDX $60
    JSR $9C3D
    STY $60
    STX $62
    SEP #$20
    STZ $0B87
    STZ $0B88
    INC $0B88
    LDA $58
LB79A:
    BNE LB79F
    JMP $B839
LB79F:
    LDA $58
    CMP #$01
    BNE LB7B9
    LDA $54
    STA $0CBC
    STZ $0CBD
    LDA $56
    STA $0CC0
    STZ $0CC1
    XBA
    JMP $B7CA
LB7B9:
    LDA $54
    STA $0CBE
    STZ $0CBF
    LDA $56
    STA $0CC2
    STZ $0CC3
    XBA
    REP #$30
    LDA $5E
    STA $0CB4
    LDA $5A
    DEA
    STA $0CC4
    STZ $0DCA
    LDX $5C
    STX $0CC6
    STX $0DC8
    LDX $60
    STX $3D
    LDA $62
    STA $3F
    SEP #$20
    LDX #$0000
    LDA $58
    CMP #$01
    BEQ LB7F8
    LDX #$0080
LB7F8:
    LDA $0CC4
    INA
LB7FC:
    PHA
    REP #$20
    LDA $0CC0
    ASL A
    TAY
    LDA $58
    CMP #$0001
    BEQ LB810
    LDA $0CC2
    ASL A
    TAY
LB810:
    SEP #$20
LB812:
    LDA [$0000]
    STA $0CC8,X
    REP #$20
    INC $3D
    BNE LB824
    LDA #$8000
    STA $3D
    INC $3F
LB824:
    SEP #$20
    INX
    DEY
    BNE LB812
    PLA
    DEA
    BNE LB7FC
    SEP #$20
    LDA #$04
    STA $0B87
    INC $0B88
    RTS
    STZ $0CB4
    RTS
    REP #$30
    PHA
    PHX
    LDA #$8000
    STA $0E01
    STA $CE
    LDY #$0000
    SEP #$20
    INC $D0
    REP #$20
    PLX
    PLA
    RTS
    PHP
    REP #$30
    LDA #$0000
    TAY
    SEC
    SBC $CE
    STA $0E01
    LDA #$BBAA
LB865:
    CMP $2140
    BNE LB865
    SEP #$20
    LDA #$CC
    BRA LB8AA
    LDA [$0000]
    INY
    CPY $0E01
    BNE LB87D
    PHP
    JSR $B83D
    PLP
LB87D:
    XBA
    LDA #$00
    BRA LB897
LB882:
    XBA
    LDA [$0000]
    INY
    CPY $0E01
    BNE LB890
    PHP
    JSR $B83D
    PLP
LB890:
    XBA
LB891:
    CMP $2140
    BNE LB891
    INA
LB897:
    REP #$20
    STA $2140
    SEP #$20
    DEX
    BNE LB882
LB8A1:
    CMP $2140
    BNE LB8A1
LB8A6:
    ADC #$03
    BEQ LB8A6
LB8AA:
    PHA
    SEP #$20
    LDA [$0000]
    INY
    CPY $0E01
    BNE LB8BA
    PHP
    JSR $B83D
    PLP
LB8BA:
    XBA
    LDA [$0000]
    XBA
    INY
    CPY $0E01
    BNE LB8C9
    PHP
    JSR $B83D
    PLP
LB8C9:
    TAX
    LDA [$0000]
    INY
    CPY $0E01
    BNE LB8D7
    PHP
    JSR $B83D
    PLP
LB8D7:
    XBA
    LDA [$0000]
    XBA
    INY
    CPY $0E01
    BNE LB8E6
    PHP
    JSR $B83D
    PLP
LB8E6:
    REP #$20
    STA $2142
    SEP #$20
    CPX #$0001
    LDA #$00
    ROL A
    STA $2141
    ADC #$7F
    PLA
    STA $2140
LB8FC:
    CMP $2140
    BNE LB8FC
    BVC LB906
    JMP $B870
LB906:
    SEP #$20
    STZ $2140
    STZ $2141
    STZ $2142
    STZ $2143
    PLP
    RTS
    SEP #$20
    LDA $54
    STA $0E05
    LDA $56
    STA $0E06
    LDA #$01
    STA $0E04
    RTS
    SEP #$20
    LDA #$00
    STA $0E05
    STA $0E06
    INA
    STA $0E04
    RTS
    SEP #$20
    LDA $2140
    STA $68
    LDA $2142
    STA $69
    RTS
    SEP #$20
    STZ $0E07
    INC $0B55
LB94C:
    LDA $0B55
    BNE LB94C
    LDA $54
    STA $0E07
    LDA $55
    STA $0E08
    RTS
    REP #$10
    LDX $54
    JSR $9C3D
    STY $54
    STX $56
    REP #$10
    SEP #$20
    LDY $54
    STY $CE
    LDA $56
    STA $D0
    LDA #$01
    STA $0E09
    LDA #$FF
    STA $2140
    JSR $B855
    LDA #$00
    STA $0E09
    STA $0E04
    STA $0E05
    STA $0E07
    STA $0E08
    STA $0E06
    RTS
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
    BRK $00
