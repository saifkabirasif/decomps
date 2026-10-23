;
; Uncharted Waters (USA) - bank0a_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $A000-$AFFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $A000

    ORA $8D21
    ASL $8D21
    ASL $E221
    BPL L9FCD
    JSR $00A2
    LDY #$8E01
    TAS
    AND ($8C,X)
    TAS
    AND ($8E,X)
    TRB $8E21
    TRB $8E21
    ORA $8E21,X
    ORA $8E21,X
    ASL $8C21,X
    ASL $8E21,X
    JSR $8E21
    JSR $9C21
    WDM $0B
    STZ $0B44
    STZ $0B46
    STZ $0B48
    STY $0B43
    STY $0B49
    RTS
    SEP #$30
    LDA $54
    STA $211F
    LDA $55
    STA $211F
    LDA $56
    STA $2120
    LDA $57
    STA $2120
    RTS
    REP #$30
    LDA $54
    STA $0B42
    LDA $56
    STA $0B44
    LDA $58
    STA $0B46
    LDA $5A
    STA $0B48
    SEP #$20
    INC $0E03
LA073:
    LDA $0E03
    BNE LA073
    RTS
    REP #$30
    LDX $58
    JSR $9C3D
    STX $5A
    STY $58
    JSR $9EA4
    RTS
    REP #$30
    LDX $5E
    JSR $9C3D
    STY $5E
    STX $60
    JSR $9F1B
    RTS
    SEP #$30
    LDA $54
    STA $2130
    LDA $56
    STA $2131
    LDA $58
    STA $2132
    RTS
    SEP #$20
    REP #$10
    LDA $54
    STA $0DF2
    LDA $56
    STA $0DF3
    LDX $58
    STX $0DF4
    LDA $5A
    STA $0DF6
    LDA #$20
    STA $0DD9
    LDA #$01
    STA $0DF1
    RTS
    SEP #$20
    REP #$10
    LDA $54
    STZ $0DD9
    STZ $0DF1
    RTS
    LDY #$0000
    TSA
    CLC
    ADC #$03
    BRK $1B
    CLC
    ADC #$08
    BRK $85
    ASL A
    TYX
    LDA ($0A),Y
    STA $52,X
    INY
    INY
    TYA
    CMP #$16
    BRK $D0
    SBC ($20,S),Y
    CMP $A58D,X
    PLA
    STA $0A
    RTL
    SEP #$20
    PLA
    PLA
    PLA
    STA $0C
    PLA
    STA $0A
    PLA
    STA $0B
    PLA
    STA $00
    PLA
    STA $01
    PLA
    STA $02
    REP #$10
    LDX #$0000
    LDY #$0009
LA11B:
    LDA $00,X
    PHA
    INX
    DEY
    BPL LA11B
    REP #$20
    TSA
    STA $04
    CLC
    CLD
    LDY #$0001
    ADC [$0000]
    TAS
    CLC
    LDA $0A
    ADC #$0003
    STA $06
    SEP #$20
    LDA $0C
    STA $08
    LDA #$7E
    PHA
    PLB
    SEP #$20
    LDY #$0000
    LDA [$0000]
    REP #$20
    INC $06
    AND #$00FF
    PHA
    ASL A
    TAX
    LDA $00A797
    STA $00
    PLX
    JMP $0000
    LDA #$FFE9
    BNE LA196
    LDA #$FFEB
    BNE LA196
    LDA #$FFED
    BNE LA196
    LDA #$FFEF
    BNE LA196
    LDA #$FFF1
    BNE LA196
    LDA #$FFF3
    BNE LA196
    LDA #$FFF5
    BNE LA196
    LDA #$FFF7
    BNE LA196
    LDA #$FFF9
    BNE LA196
    LDA #$FFFB
    BNE LA196
    LDA #$FFFD
    BNE LA196
    LDA #$FFFF
LA196:
    CLC
    ADC $04
    STA $00
    LDA ($00),Y
    STA $0A
    JMP $A141
    LDY #$0015
    BNE LA1B4
    LDY #$0013
    BNE LA1B4
    LDY #$0011
    BNE LA1B4
    LDY #$000F
LA1B4:
    LDA ($04),Y
    STA $0A
    JMP $A141
    LDA #$FFE9
    BNE LA1F5
    LDA #$FFEB
    BNE LA1F5
    LDA #$FFED
    BNE LA1F5
    LDA #$FFEF
    BNE LA1F5
    LDA #$FFF1
    BNE LA1F5
    LDA #$FFF3
    BNE LA1F5
    LDA #$FFF5
    BNE LA1F5
    LDA #$FFF7
    BNE LA1F5
    LDA #$FFF9
    BNE LA1F5
    LDA #$FFFB
    BNE LA1F5
    LDA #$FFFD
    BNE LA1F5
    LDA #$FFFF
LA1F5:
    CLC
    ADC $04
    STA $00
    LDA ($00),Y
    STA $0E
    JMP $A141
    LDY #$0015
    BNE LA213
    LDY #$0013
    BNE LA213
    LDY #$0011
    BNE LA213
    LDY #$000F
LA213:
    LDA ($04),Y
    STA $0E
    JMP $A141
    LDA #$FFE9
    BNE LA254
    LDA #$FFEB
    BNE LA254
    LDA #$FFED
    BNE LA254
    LDA #$FFEF
    BNE LA254
    LDA #$FFF1
    BNE LA254
    LDA #$FFF3
    BNE LA254
    LDA #$FFF5
    BNE LA254
    LDA #$FFF7
    BNE LA254
    LDA #$FFF9
    BNE LA254
    LDA #$FFFB
    BNE LA254
    LDA #$FFFD
    BNE LA254
    LDA #$FFFF
LA254:
    CLC
    ADC $04
    STA $00
    LDA $0A
    STA ($00),Y
    JMP $A141
    LDY #$0015
    BNE LA272
    LDY #$0013
    BNE LA272
    LDY #$0011
    BNE LA272
    LDY #$000F
LA272:
    LDA $0A
    STA ($04),Y
    JMP $A141
    LDA #$FFE9
    BNE LA2B3
    LDA #$FFEB
    BNE LA2B3
    LDA #$FFED
    BNE LA2B3
    LDA #$FFEF
    BNE LA2B3
    LDA #$FFF1
    BNE LA2B3
    LDA #$FFF3
    BNE LA2B3
    LDA #$FFF5
    BNE LA2B3
    LDA #$FFF7
    BNE LA2B3
    LDA #$FFF9
    BNE LA2B3
    LDA #$FFFB
    BNE LA2B3
    LDA #$FFFD
    BNE LA2B3
    LDA #$FFFF
LA2B3:
    CLC
    ADC $04
    STA $00
    LDA ($00),Y
    PHA
    JMP $A141
    LDY #$0015
    BNE LA2D0
    LDY #$0013
    BNE LA2D0
    LDY #$0011
    BNE LA2D0
    LDY #$000F
LA2D0:
    LDA ($04),Y
    PHA
    JMP $A141
    TXA
    AND #$000F
    STA $0A
    JMP $A141
    STY $0A
    JMP $A141
    TXA
    AND #$000F
    STA $0E
    JMP $A141
    STY $0E
    JMP $A141
    TXA
    AND #$000F
    PHA
    JMP $A141
    TXA
    AND #$000F
    CLC
    ADC $0A
    STA $0A
    JMP $A141
    JSR $A77F
    BCC LA30E
    JSR $A74C
LA30E:
    LDA ($00),Y
    STA $0A
    JMP $A141
    JSR $A775
    LDA ($00),Y
    STA $0A
    JMP $A141
    JSR $A74C
LA322:
    LDA ($00),Y
    STA $0E
    JMP $A141
    JSR $A77F
    BCC LA322
    JSR $A775
    LDA ($00),Y
    STA $0E
    JMP $A141
    JSR $A74C
LA33B:
    LDA $0A
    STA ($00),Y
    JMP $A141
    JSR $A77F
    BCC LA33B
    JSR $A775
    LDA $0A
    STA ($00),Y
    JMP $A141
    JSR $A74C
LA354:
    LDA ($00),Y
    PHA
    JMP $A141
    JSR $A77F
    BCC LA354
    JSR $A775
    LDA ($00),Y
    PHA
    JMP $A141
    JSR $A77F
    LDA $00
    STA $0A
    JMP $A141
    JSR $A77F
    LDA $00
    STA $0E
    JMP $A141
    JSR $A73A
LA37F:
    STA $0A
    JMP $A141
    JSR $A76D
    BCC LA37F
    JSR $A73A
LA38C:
    STA $0E
    JMP $A141
    JSR $A76D
    BCC LA38C
    JSR $A73A
    PHA
    JMP $A141
    JSR $A76D
    PHA
    JMP $A141
    JSR $A73A
LA3A7:
    ADC $0A
    STA $0A
    JMP $A141
    JSR $A76D
    BCC LA3A7
    JSR $A77F
    SEP #$30
    LDA ($00),Y
    STA $0A
    STY $0B
    REP #$30
    JMP $A141
    JSR $A775
    SEP #$30
    LDA ($00),Y
    STA $0A
    STY $0B
    REP #$30
    JMP $A141
    JSR $A77F
    SEP #$30
    LDA ($00),Y
    STA $0E
    STY $0F
    REP #$30
    JMP $A141
    JSR $A775
    SEP #$30
    LDA ($00),Y
    STA $0E
    STY $0F
    REP #$30
    JMP $A141
    JSR $A77F
    SEP #$20
    LDA $0A
    STA ($00),Y
    REP #$20
    JMP $A141
    JSR $A775
    SEP #$20
    LDA $0A
    STA ($00),Y
    REP #$20
    JMP $A141
    JSR $A77F
    SEP #$20
    LDA #$00
    XBA
    LDA ($00),Y
    REP #$20
    PHA
    JMP $A141
    JSR $A775
    SEP #$20
    LDA #$00
    XBA
    LDA ($00),Y
    REP #$20
    PHA
    JMP $A141
    LDA $0A
    STA $00
    JMP $A439
    JSR $A775
    JSR $A452
    LDY #$0000
    JMP $A47B
    LDA $0A
    STA $00
    JMP $A44C
    JSR $A775
    JSR $A452
    JMP $A141
    LDA $06
    PHA
    PHK
    JSR $A45B
    PLA
    RTS
    SEP #$20
    LDA #$7E
    STA $02
    REP #$20
    JML [$200000]
    ADC $A0A7
    BRK $00
    TAX
    SEP #$20
LA46F:
    LDA ($0A),Y
    STA ($0E),Y
    DEX
    BNE LA46F
    REP #$20
    JMP $A141
    JSR $A73A
LA47E:
    STA $00
    TSA
    ADC $00
    TAS
    JMP $A141
    JSR $A76D
    BCC LA47E
LA48C:
    JSR $A76D
    STA $06
    JMP $A141
    LDA $0A
    BNE LA48C
LA498:
    JSR $A76D
    JMP $A141
    LDA $0A
    BEQ LA48C
    BNE LA498
LA4A4:
    JSR $A73A
    ADC $06
    STA $06
    JMP $A141
    LDA $0A
    BNE LA4A4
LA4B2:
    JSR $A73A
    JMP $A141
    LDA $0A
    BEQ LA4A4
    BNE LA4B2
LA4BE:
    JSR $A73A
    ADC $06
    STA $06
    JMP $A141
    LDA $0A
    BNE LA4BE
LA4CC:
    JSR $A73A
    JMP $A141
    LDA $0A
    BEQ LA4BE
    BNE LA4CC
    LDA [$0000]
    TAX
    INC $06
    INC $06
    LDY #$0000
    DEX
    BMI LA4F8
    LDA [$0000]
    INY
    INY
    CMP $0A
    BEQ LA4F8
    CLC
    LDA $06
    ADC #$0004
    STA $06
    JMP $A4DF
LA4F8:
    LDA [$0000]
    STA $06
    JMP $A141
    CLC
    LDA [$0000]
    ADC $0A
    STA $0A
    INY
    INY
    LDA $0A
    CMP [$0000]
    BCC LA512
    INY
    INY
    BCS LA51C
LA512:
    LDA $0A
    ASL A
    ADC $06
    STA $06
    LDY #$0006
LA51C:
    LDA [$0000]
    STA $06
    JMP $A141
    LDA ($0A),Y
    STA $0A
    JMP $A141
    SEP #$30
    LDA ($0A),Y
    STA $0A
    STY $0B
    REP #$30
    JMP $A141
    PLA
    STA $0E
    LDA $0A
    STA ($0E),Y
    JMP $A141
    PLA
    STA $0E
    SEP #$20
    LDA $0A
    STA ($0E),Y
    REP #$20
    JMP $A141
    LDA $0A
    PHA
    JMP $A141
    PLA
    STA $0E
    JMP $A141
    LDY #$0000
    STY $00
    LDY #$0010
LA563:
    LDA $0A
    LSR A
    BCC LA56F
    CLC
    LDA $00
    ADC $0E
    STA $00
LA56F:
    ROR $00
    ROR $0A
    DEY
    BNE LA563
    JMP $A141
    JSR $A58F
    JMP $A141
    JSR $A5C8
    JSR $A58F
    LDA $0B
    BPL LA58C
    JMP $A6CD
LA58C:
    JMP $A141
    LDY #$0000
    STY $00
    LDY #$0010
LA597:
    ASL $0A
    ROL $00
    SEC
    LDA $00
    SBC $0E
    BCC LA5A6
    STA $00
    INC $0A
LA5A6:
    DEY
    BNE LA597
    RTS
    JSR $A5C8
    JSR $A58F
    LDA $00
    STA $0A
    LDA $0C
    BPL LA5BB
    JMP $A6CD
LA5BB:
    JMP $A141
    JSR $A58F
    LDA $00
    STA $0A
    JMP $A141
    SEP #$20
    LDA $0B
    STA $0D
    EOR $0F
    STA $0C
    REP #$20
    LDA $0A
    BPL LA5DE
    SEC
    TYA
    SBC $0A
    STA $0A
LA5DE:
    LDA $0E
    BPL LA5E8
    SEC
    TYA
    SBC $0E
    STA $0E
LA5E8:
    RTS
    CLC
    LDA $0A
    ADC $0E
    STA $0A
    JMP $A141
    SEC
    LDA $0A
    SBC $0E
    STA $0A
    JMP $A141
    LDX $0E
    BNE LA604
LA601:
    JMP $A141
LA604:
    ASL $0A
    DEX
    BEQ LA601
    BNE LA604
    LDA $0A
    BPL LA61E
    LDX $0E
    BNE LA616
LA613:
    JMP $A141
LA616:
    SEC
    ROR $0A
    DEX
    BEQ LA613
    BNE LA616
LA61E:
    LDX $0E
    BNE LA625
LA622:
    JMP $A141
LA625:
    LSR $0A
    DEX
    BEQ LA622
    BNE LA625
    LDA $0A
    AND $0E
    STA $0A
    JMP $A141
    LDA $0A
    ORA $0E
    STA $0A
    JMP $A141
    LDA $0A
    EOR $0E
    STA $0A
    JMP $A141
    LDA $0A
    CMP $0E
    BNE LA64E
    INY
LA64E:
    STY $0A
    JMP $A141
    LDA $0A
    CMP $0E
    BEQ LA65A
    INY
LA65A:
    STY $0A
    JMP $A141
    SEC
    LDA $0A
    SBC $0E
    BPL LA667
    INY
LA667:
    STY $0A
    JMP $A141
    SEC
    LDA $0E
    SBC $0A
    BPL LA674
    INY
LA674:
    STY $0A
    JMP $A141
    SEC
    LDA $0E
    SBC $0A
    BMI LA681
    INY
LA681:
    STY $0A
    JMP $A141
    SEC
    LDA $0A
    SBC $0E
    BMI LA68E
    INY
LA68E:
    STY $0A
    JMP $A141
    LDA $0A
    CMP $0E
    BCS LA69A
    INY
LA69A:
    STY $0A
    JMP $A141
    LDA $0E
    CMP $0A
    BCS LA6A6
    INY
LA6A6:
    STY $0A
    JMP $A141
    LDA $0E
    CMP $0A
    BCC LA6B2
    INY
LA6B2:
    STY $0A
    JMP $A141
    LDA $0A
    CMP $0E
    BCC LA6BE
    INY
LA6BE:
    STY $0A
    JMP $A141
    LDA $0A
    BNE LA6C8
    INY
LA6C8:
    STY $0A
    JMP $A141
    SEC
    TYA
    SBC $0A
    STA $0A
    JMP $A141
    LDA $0A
    EOR #$FFFF
    STA $0A
    JMP $A141
    LDA $0A
    LDX $0E
    STX $0A
    STA $0E
    JMP $A141
    INC $0A
    JMP $A141
    DEC $0A
    JMP $A141
    ASL $0A
    JMP $A141
    JSR $A76D
    LDY #$000A
    JSR $AD49
    JMP $A141
    JSR $A76D
    LDY #$000A
    JSR $AD1A
    JMP $A141
    JSR $A76D
    LDY #$000E
    JSR $AD61
    JMP $A141
    LDX #$0009
    LDA $04
    TAS
    SEP #$20
LA726:
    PLA
    STA $00,X
    DEX
    BPL LA726
    REP #$20
    INC $00
    JML [$000000]
    BRK $00
    BRK $4C
    EOR ($A1,X)
    SEP #$20
    LDA #$00
    XBA
    LDA [$0000]
    BPL LA746
    XBA
    DEA
    XBA
LA746:
    REP #$20
    INC $06
    CLC
    RTS
    SEP #$20
    LDA #$00
    XBA
    LDA [$0000]
    BPL LA75E
    XBA
    DEA
    XBA
    REP #$20
    INA
    JMP $A764
LA75E:
    REP #$20
    INA
    INA
    INA
    INA
    CLC
    ADC $04
    STA $00
    INC $06
    CLC
    RTS
    LDA [$0000]
    INC $06
    INC $06
    CLC
    RTS
    LDA [$0000]
    STA $00
    INC $06
    INC $06
    CLC
    RTS
    CLC
    LDA [$0000]
    BPL LA788
    INA
    JMP $A78C
LA788:
    INA
    INA
    INA
    INA
    CLC
    ADC $04
    STA $00
    INC $06
    INC $06
    CLC
    RTS
    JML $A161A1
    ROR $A1
    RTL
    LDA ($70,X)
    LDA ($75,X)
    LDA ($7A,X)
    LDA ($7F,X)
    LDA ($84,X)
    LDA ($89,X)
    LDA ($8E,X)
    LDA ($93,X)
    LDA ($B1,X)
    LDA ($AC,X)
    LDA ($A7,X)
    LDA ($A2,X)
    LDA ($BB,X)
    LDA ($C0,X)
    LDA ($C5,X)
    LDA ($CA,X)
    LDA ($CF,X)
    LDA ($D4,X)
    LDA ($D9,X)
    LDA ($DE,X)
    LDA ($E3,X)
    LDA ($E8,X)
    LDA ($ED,X)
    LDA ($F2,X)
    LDA ($10,X)
    LDX #$A20B
    ASL $A2
    ORA ($A2,X)
    INA
    LDX #$A21F
    BIT $A2
    AND #$2EA2
    LDX #$A233
    SEC
    LDX #$A23D
    WDM $A2
    EOR [$0000]
    JMP $51A2
    LDX #$A26F
    ROR A
    LDX #$A265
    RTS
    LDX #$A279
    ROR $83A2,X
    LDX #$A288
    STA $92A2
    LDX #$A297
    STZ $A1A2
    LDX #$A2A6
    PLB
    LDX #$A2B0
    CMP $C8A2
    LDX #$A2C3
    LDX $DFA2,Y
    LDX #$A2D6
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    DEC $A2,X
    SBC $E4A2
    LDX #$A2E4
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    CPX $A2
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    SBC ($A2)
    ORA $A3,S
    PLX
    LDX #$A2FA
    PLX
    LDX #$A2FA
    PLX
    LDX #$A2FA
    PLX
    LDX #$A2FA
    PLX
    LDX #$A2FA
    PLX
    LDX #$A2FA
    PLX
    LDX #$A2FA
    PLX
    LDX #$A733
    PHD
    LDA $06,S
    LDA $1F,S
    LDA $29,S
    LDA $38,S
    LDA $42,S
    LDA $51,S
    LDA $5A,S
    LDA $7C,S
    LDA $84,S
    LDA $89,S
    LDA $91,S
    LDA $96,S
    LDA $9D,S
    LDA $A4,S
    LDA $AE,S
    LDA $33,S
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA $D3,S
    LDA $F3,S
    LDA $0F,S
    LDY $15
    LDA $C3,S
    LDA $2E,S
    LDA $E3,S
    LDA $47,S
    LDA $01,S
    LDY $5F
    LDA $1F,S
    LDY $49
    LDY $66
    LDY $7B
    LDY $87
    LDY $23
    LDA $37
    LDA $33
    LDA [$0000]
    LDA $55
    LDA $5B
    LDA $7F
    LDA $97
    LDA #$A579
    TAX
    LDA $BE
    LDA $E9
    LDA $F3
    LDA $FD
    LDA $1E
    LDX $0B
    LDX $47
    LDX $53
    LDX $5F
    LDX $79
    LDX $6C
    LDX $86
    LDX $93
    LDX $AB
    LDX $9F
    LDX $B7
    LDX $C3
    LDX $CD
    LDX $D6
    LDX $E0
    LDX $33
    LDA [$0000]
    LDA [$0000]
    LDX $F0
    LDX $F5
    LDX $2A
    LDA $41
    LDA $FF
    LDY $8C
    LDY $94
    LDY $9E
    LDY $D8
    LDY $2C
    LDX $35
    LDX $3E
    LDX $42
    LDY $68
    LDA $72,S
    LDA $FA,S
    LDX $06
    LDA [$0000]
    LDA [$0000]
    LDY $AE
    LDY $B8
    LDY $BE
    LDY $C8
    LDY $D2
    LDY $36
    LDY $2F
    LDY $33
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    LDA [$0000]
    JSR $06B7
    REP #$20
    INC $06
    AND #$00FF
    ASL A
    TAX
    LDA $00A9AF
    STA $00
    LDA #$A140
    PHA
    JMP $0000
    ORA $AA35AA
    LDA ($AA,S),Y
    REP #$AA
    ADC $AB
    BIT #$9AAB
    PLB
    TAX
    PLB
    PHX
    PLB
    REP #$AB
    SBC ($AB)
    BRL $3C76
    LDY $ACA2
    LDA ($AC)
    REP #$AC
    CMP ($AC)
    SEP #$AC
    SBC ($AC)
    COP $AD
    ASL A
    LDA $AD13
    RTS
    LDY $AC2A
    SEC
    LDY $AC72
    EOR ($AC)
    JMP $7CAC
    PLB
    STA $D1AA,X
    TAX
    CPX $2CAA
    PLB
    TSA
    PLB
    EOR #$AB
    EOR [$0000]
    JSR $27AC
    LDY $AC29
    ADC ($AB,S),Y
    LDA $E9AB,Y
    PLB
    CMP ($AB),Y
    ORA ($AC,X)
    ORA ($AB),Y
    RTI
    TAX
    STA ($AA,S),Y
    STY $12
    STY $14
    LDY #$0020
LAA16:
    LDA $0A
    LSR A
    BCC LAA29
    CLC
    LDX #$FFFC
LAA1F:
    LDA $16,X
    ADC $12,X
    STA $16,X
    INX
    INX
    BNE LAA1F
LAA29:
    LSR $14
    ROR $12
    ROR $0C
    ROR $0A
    DEY
    BNE LAA16
    RTS
    JSR $AA43
    LDA $1D
    BPL LAA3F
    JMP $AB65
LAA3F:
    RTS
    JMP $AA68
    SEP #$20
    LDA $0D
    STA $1F
    EOR $11
    STA $1E
    REP #$20
    LDA $0C
    BPL LAA56
    JSR $AB65
LAA56:
    LDA $10
    BPL LAA68
    LDX #$FFFC
LAA5D:
    LDA #$0000
    SBC $12,X
    STA $12,X
    INX
    INX
    BNE LAA5D
LAA68:
    LDA #$0000
    STA $12
    STA $14
    LDY #$0020
LAA72:
    ASL $0A
    ROL $0C
    ROL $12
    ROL $14
    SEC
    LDA $12
    SBC $0E
    STA $00
    LDA $14
    SBC $10
    BCC LAA8F
    STA $14
    LDA $00
    STA $12
    INC $0A
LAA8F:
    DEY
    BNE LAA72
    RTS
    JSR $AA68
    STY $1E
    LDX #$0002
    BNE LAAA3
    JSR $AA43
    LDX #$0002
LAAA3:
    LDA $12,X
    STA $0A,X
    DEX
    DEX
    BPL LAAA3
    LDA $1E
    BMI LAAB0
    RTS
LAAB0:
    JMP $AB65
    CLC
    LDX #$FFFC
LAAB7:
    LDA $0E,X
    ADC $12,X
    STA $0E,X
    INX
    INX
    BNE LAAB7
    RTS
    SEC
    LDX #$FFFC
LAAC6:
    LDA $0E,X
    SBC $12,X
    STA $0E,X
    INX
    INX
    BNE LAAC6
    RTS
    CLC
    LDY #$FFFF
    LDX #$FFFC
LAAD8:
    TYA
    ADC $12,X
    STA $12,X
    INX
    INX
    BNE LAAD8
    TAX
    BPL LAAE5
    RTS
LAAE5:
    ASL $0A
    ROL $0C
    JMP $AAD1
    CLC
    LDA $0C
    BPL LAAF2
    SEC
LAAF2:
    PHP
    CLC
    LDY #$FFFF
    LDX #$FFFC
LAAFA:
    TYA
    ADC $12,X
    STA $12,X
    INX
    INX
    BNE LAAFA
    TAX
    BPL LAB08
    PLP
    RTS
LAB08:
    PLP
    PHP
    ROR $0C
    ROR $0A
    JMP $AAF3
    CLC
    LDY #$FFFF
    LDX #$FFFC
LAB18:
    TYA
    ADC $12,X
    STA $12,X
    INX
    INX
    BNE LAB18
    TAX
    BPL LAB25
    RTS
LAB25:
    LSR $0C
    ROR $0A
    JMP $AB11
    LDX #$0002
LAB2F:
    LDA $0A,X
    EOR #$FFFF
    STA $0A,X
    DEX
    DEX
    BPL LAB2F
    RTS
    LDX #$0002
LAB3E:
    LDA $0A,X
    AND $0E,X
    STA $0A,X
    DEX
    DEX
    BPL LAB3E
    RTS
    LDX #$0002
LAB4C:
    LDA $0A,X
    ORA $0E,X
    STA $0A,X
    DEX
    DEX
    BPL LAB4C
    RTS
    LDX #$0002
LAB5A:
    LDA $0A,X
    EOR $0E,X
    STA $0A,X
    DEX
    DEX
    BPL LAB5A
    RTS
    SEC
    LDX #$FFFC
LAB69:
    TYA
    SBC $0E,X
    STA $0E,X
    INX
    INX
    BNE LAB69
    RTS
    JSR $AB7C
    LDA $0A
    EOR #$0001
    RTS
    LDX #$0002
LAB7F:
    LDA $0A,X
    BNE LAB96
    DEX
    DEX
    BPL LAB7F
    BMI LABA7
    LDX #$0002
LAB8C:
    LDA $0A,X
    CMP $0E,X
    BNE LABA7
    DEX
    DEX
    BPL LAB8C
LAB96:
    INY
    STY $0A
    RTS
    LDX #$0002
LAB9D:
    LDA $0A,X
    CMP $0E,X
    BNE LAB96
    DEX
    DEX
    BPL LAB9D
LABA7:
    STY $0A
    RTS
    JSR $AC0A
    BPL LABB0
    INY
LABB0:
    TYA
    BVC LABB6
    EOR #$0001
LABB6:
    STA $0A
    RTS
    JSR $AC0A
    BCS LABBF
    INY
LABBF:
    STY $0A
    RTS
    JSR $AC15
    BPL LABC8
    INY
LABC8:
    TYA
    BVC LABCE
    EOR #$0001
LABCE:
    STA $0A
    RTS
    JSR $AC15
    BCS LABD7
    INY
LABD7:
    STY $0A
    RTS
    JSR $AC15
    BMI LABE0
    INY
LABE0:
    TYA
    BVC LABE6
    EOR #$0001
LABE6:
    STA $0A
    RTS
    JSR $AC15
    BCC LABEF
    INY
LABEF:
    STY $0A
    RTS
    JSR $AC0A
    BMI LABF8
    INY
LABF8:
    TYA
    BVC LABFE
    EOR #$0001
LABFE:
    STA $0A
    RTS
    JSR $AC0A
    BCC LAC07
    INY
LAC07:
    STY $0A
    RTS
    LDA $0A
    CMP $0E
    STY $0A
    LDA $0C
    SBC $10
    RTS
    LDA $0E
    CMP $0A
    STY $0A
    LDA $10
    SBC $0C
    RTS
    LDA $0A
    BPL LAC27
    LDY #$FFFF
LAC27:
    STY $0C
    RTS
LAC2A:
    TYX
    LDA [$0000]
    STA $0A,X
    INY
    INY
    CPY #$0004
    BNE LAC2A
    BEQ LAC44
LAC38:
    TYX
    LDA [$0000]
    STA $0E,X
    INY
    INY
    CPY #$0004
    BNE LAC38
LAC44:
    LDA $06
    ADC #$0003
    STA $06
    RTS
    LDY #$FFFF
    TYA
    BNE LAC55
    LDA #$0001
LAC55:
    CLC
    ADC $0A
    STA $0A
    TYA
    ADC $0C
    STA $0C
    RTS
    PLY
    PLA
    STA $0E
    PHY
    LDY #$0002
LAC68:
    TYX
    LDA $0A,X
    STA ($0E),Y
    DEY
    DEY
    BPL LAC68
    RTS
    LDX #$0002
LAC75:
    LDA $0A,X
    LDY $0E,X
    STA $0E,X
    STY $0A,X
    DEX
    DEX
    BPL LAC75
    RTS
    JSR $A77F
    LDY #$0002
LAC88:
    TYX
    LDA ($00),Y
    STA $0A,X
    DEY
    DEY
    BPL LAC88
    RTS
    JSR $A77F
    LDY #$0002
LAC98:
    TYX
    LDA ($00),Y
    STA $0E,X
    DEY
    DEY
    BPL LAC98
    RTS
    JSR $A77F
    LDY #$0002
LACA8:
    TYX
    LDA $0A,X
    STA ($00),Y
    DEY
    DEY
    BPL LACA8
    RTS
    JSR $A77F
    LDY #$0002
    PLX
LACB9:
    LDA ($00),Y
    PHA
    DEY
    DEY
    BPL LACB9
    PHX
    RTS
    JSR $A775
    LDY #$0002
LACC8:
    TYX
    LDA ($00),Y
    STA $0A,X
    DEY
    DEY
    BPL LACC8
    RTS
    JSR $A775
    LDY #$0002
LACD8:
    TYX
    LDA ($00),Y
    STA $0E,X
    DEY
    DEY
    BPL LACD8
    RTS
    JSR $A775
    LDY #$0002
LACE8:
    TYX
    LDA $0A,X
    STA ($00),Y
    DEY
    DEY
    BPL LACE8
    RTS
    JSR $A775
    LDY #$0002
    PLX
LACF9:
    LDA ($00),Y
    PHA
    DEY
    DEY
    BPL LACF9
    PHX
    RTS
    LDA #$000A
    STA $00
    JMP $ACB5
    PLX
    PLA
    STA $0E
    PLA
    STA $10
    PHX
    RTS
    LDA $0A
    STA $00
    JMP $ACC5
    PHA
    TYA
    LDA $00,X
    STA $00
    LDY #$0000
    LDA ($00),Y
    STA $0A
    SEP #$20
    XBA
    REP #$20
    AND #$00FF
    TXA
    BEQ LAD37
LAD32:
    LSR $0A
    DEX
    BNE LAD32
LAD37:
    PLA
    JSR $AD93
    LDA $0A
    AND $0C
    STA $0A
    LDA #$0000
    TAX
    LDY #$0001
    RTS
    JSR $AD1A
    LDA $0C
    EOR #$FFFF
    STA $000C
    LSR A
    AND $0A
    BEQ LAD5F
    LDA $0A
    ORA $0C
    STA $0A
LAD5F:
    TXA
    RTS
    PHA
    TYX
    LDA $00,X
    STA $00
    JSR $AD93
    PLA
    SEP #$20
    XBA
    REP #$20
    AND #$00FF
    TXA
    BEQ LAD7D
LAD76:
    ASL $0A
    ASL $0C
    DEX
    BNE LAD76
LAD7D:
    LDA $0A
    AND $0C
    STA $0A
    LDA $0C
    EOR #$FFFF
    AND ($00),Y
    ORA $0A
    STA ($00),Y
    TXA
    LDY #$0001
    RTS
    AND #$00FF
    TAY
    LDA #$0000
    STA $0C
LAD9C:
    SEC
    ROL $0C
    DEY
    BNE LAD9C
    RTS
    REP #$30
    LDA #$FFFF
    STA $68
    LDA $54
    BEQ LADE7
    CMP #$0021
    BCS LADE7
    STA $9B
    ASL A
    ASL A
    ASL A
    STA $9F
    LDA $56
    BEQ LADE7
    CMP #$0021
    BCS LADE7
    ASL A
    ASL A
    ASL A
    STA $9D
    LDA $9F
    ASL A
    ASL A
    PHA
    SEC
    SBC #$0010
    STA $A1
    PLA
    STA $94
    LDA $56
    STA $97
    JSR $B1FC
    LDA $94
    SEC
    SBC #$0018
    STA $A3
    STZ $68
LADE7:
    RTS
    REP #$30
    LDA #$FFFF
    STA $68
    LDA $54
    CMP $9F
    BCC LADF8
    JMP $AE67
LADF8:
    LDA $56
    CMP $9D
    BCC LAE01
    JMP $AE67
LAE01:
    PHB
    LDA $56
    LSR A
    LSR A
    LSR A
    STA $94
    LDA $9F
    ASL A
    ASL A
    STA $97
    JSR $B1FC
    LDA $56
    AND #$0007
    ASL A
    CLC
    ADC $94
    STA $A5
    LDA $54
    LSR A
    LSR A
    LSR A
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC $A5
    STA $A5
    LDA #$BFFF
    STA $B4
    STA $B6
    STA $B8
    CLC
    ADC #$FE3E
    STA $B2
    DEA
    DEA
    DEA
    STA $AC
    STA $AE
    STA $B0
    CLC
    ADC #$FF6A
    STA $AA
    LDA $54
    AND #$0007
    TAY
    INY
    SEP #$20
    LDA #$00
LAE55:
    SEC
    ROR A
    DEY
    BNE LAE55
    STA $BE
    JSR $AF93
    BCS LAE66
    LDX #$0000
    STX $68
LAE66:
    PLB
    RTS
    LDY $AE
    STZ $97
    STZ $98
    DEY
    LDA $A5
    STA ($97),Y
    DEY
    LDA $A6
    STA ($97),Y
    DEY
    LDA $BE
    STA ($97),Y
    CPY $AA
    BPL LAE83
    LDY $AC
LAE83:
    CPY $B0
    BEQ LAE8B
    STY $AE
    CLC
    RTS
LAE8B:
    SEC
    RTS
    LDY $B6
    STZ $97
    STZ $98
    DEY
    LDA $A5
    STA ($97),Y
    DEY
    LDA $A6
    STA ($97),Y
    DEY
    LDA $BE
    STA ($97),Y
    CPY $B2
    BPL LAEA8
    LDY $B4
LAEA8:
    CPY $B8
    BEQ LAEB0
    STY $B6
    CLC
    RTS
LAEB0:
    SEC
    RTS
    LDY $B0
    STZ $97
    STZ $98
    DEY
    LDA ($97),Y
    STA $A5
    DEY
    LDA ($97),Y
    STA $A6
    DEY
    LDA ($97),Y
    STA $BE
    CPY $AA
    BPL LAECD
    LDY $AC
LAECD:
    STY $B0
    RTS
    LDY $B8
    STZ $97
    STZ $98
    DEY
    LDA ($97),Y
    STA $A5
    DEY
    LDA ($97),Y
    STA $A6
    DEY
    LDA ($97),Y
    STA $BE
    CPY $B2
    BPL LAEEB
    LDY $B4
LAEEB:
    STY $B8
    RTS
    REP #$20
    PHA
    LDA $A5
    SEC
    SBC #$0020
    STA $A5
    PLA
    SEP #$20
    RTS
    REP #$20
    PHA
    LDA $A5
    CLC
    ADC #$0020
    STA $A5
    PLA
    SEP #$20
    RTS
    REP #$20
    PHA
    LDA $A5
    BIT #$000F
    BNE LAF19
    SEC
    SBC $A1
LAF19:
    DEA
    DEA
    STA $A5
    PLA
    SEP #$20
    RTS
    REP #$20
    PHA
    LDA $A5
    INA
    INA
    BIT #$000F
    BNE LAF30
    CLC
    ADC $A1
LAF30:
    STA $A5
    PLA
    SEP #$20
    RTS
    REP #$20
    PHA
    LDA $A1
    CLC
    ADC #$0010
    STA $97
    LDA $A5
    STA $94
    JSR $B21E
    LDA #$000E
    CMP $99
    PLA
    SEP #$20
    RTS
    JSR $B1C4
    ORA $C0
    STA $BB
    CMP #$FF
    BEQ LAF8B
    LDA #$80
    STA $BE
LAF60:
    CLC
    ROL $BB
    BCS LAF83
    LDA $BF
    AND #$01
    BEQ LAF76
    JSR $AE68
    BCS LAF92
    LDA $BF
    AND #$FE
    STA $BF
LAF76:
    LDA $BB
    BNE LAF7C
    BRA LAF91
LAF7C:
    SEC
    ROR $BE
    BCC LAF60
    BRA LAF91
LAF83:
    LDA $BF
    ORA #$01
    STA $BF
    BRA LAF7C
LAF8B:
    LDA $BF
    ORA #$01
    STA $BF
LAF91:
    CLC
LAF92:
    RTS
    LDA #$7F
    STA $A7
    PHA
    PLB
    JSR $AE68
    BCS LAFB4
    STZ $BE
    JSR $AE68
    BCS LAFB4
    JSR $AE8D
    BCS LAFB4
LAFAA:
    JSR $AEB2
    LDA $BE
    BNE LAFB5
    JMP $B0A0
LAFB4:
    RTS
LAFB5:
    JSR $B1C4
    STA $BF
    AND $BE
    BEQ LAFCE
    PHA
    ASL $BE
    LDA #$FF
    EOR $BE
    STA $BE
    PLA
    BIT $BE
    BNE LAFAA
    BRA LAFDF
LAFCE:
    JSR $AF36
    BCS LAFF6
    JSR $AEEE
    JSR $B1C4
    STA $BF
    ORA #$00
    BEQ LAFCE
LAFDF:
    STZ $BE
LAFE1:
    CLC
    ROR A
    BCS LAFEA
    SEC
    ROL $BE
    BRA LAFE1
LAFEA:
    LDA $BE
    BNE LAFFA
    JSR $AEFD
    JSR $B1C4
    STA $BF
LAFF6:
    LDA #$FF
    STA $BE
LAFFA:
    JSR $AE8D
    BCC LB002
    JMP $0000
