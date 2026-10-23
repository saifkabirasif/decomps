;
; Uncharted Waters (USA) - bank08_partial
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8000-$8FFF).
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
    STA $211B
    LDA #$01
    STA $211B
    LDA #$00
    STA $211C
    STA $211C
    STA $211D
    STA $211D
    STA $211E
    LDA #$01
    STA $211E
    LDA #$00
    STA $211F
    STA $211F
    STA $2120
    STA $2120
    STA $2123
    STA $2124
    STA $2125
    STA $2126
    STA $2127
    STA $2128
    STA $2129
    STA $212A
    STA $212B
    STA $212C
    STA $212D
    STA $212E
    STA $212F
    LDA #$30
    STA $2130
    STZ $2131
    LDA #$E0
    STA $2132
    LDA #$04
    STA $2133
    LDX #$0000
    STA $4200
    LDA #$FF
    STA $4201
    LDA #$00
    STA $4202
    STA $4203
    STA $4204
    STA $4205
    STA $4206
    STA $4207
    STA $4208
    STA $4209
    STA $420A
    STA $420D
    RTS
    LDX #$0120
    STX $0B27
    LDA #$8F
    STA $0B3E
    LDA #$00
    LDX #$0000
    STA $0E19
    STA $0B4A
    STX $0B4B
    STA $0B4D
    STX $0B4E
    STA $0B50
    STX $0B51
    STX $0B53
    STA $0B55
    STA $0E03
    STA $0DD8
    INC $0DD8
    STA $0B56
    STA $0B57
    STX $0B58
    STX $0B5A
    STX $0B5C
    STA $0B5E
    STA $0B62
    STA $0B63
    STA $0B6C
    STX $0B64
    STX $0B67
    STX $0B69
    STA $0B6B
    STX $0B6D
    STX $0B6F
    STA $0B71
    STX $0B72
    STA $0B74
    STX $0B75
    STX $0B77
    STX $0B79
    STX $0B7B
    STX $0B7D
    STA $0B7F
    STA $0B80
    STA $0B87
    STA $0B88
    STA $0DD9
    STX $0DDA
    STX $0DDC
    STA $0DDE
    STX $0DDF
    STX $0DE1
    STX $0DE3
    STX $0DE5
    STX $0DE7
    STX $0DE9
    STX $0DEB
    STX $0DED
    STX $0DEF
    STA $0DF1
    STA $0DF2
    STA $0DF3
    STX $0DF4
    STA $0DF6
    STA $0B86
    STX $0DF7
    STX $0DF9
    STX $0DFB
    STX $0DFD
    STA $0E09
    STA $0E04
    STA $0E05
    STA $0E07
    STA $0E08
    STA $0E06
    STX $0E0A
    STX $0E0C
    STX $0E0E
    STX $0E10
    STX $0E12
    STX $0E14
    STA $0E16
    LDA #$13
    STA $0DD6
    STA $0DD7
    LDA #$00
    STA $0DCC
    STX $0BA2
    STX $0BCE
    STX $0CB4
    LDY #$000B
L829A:
    STA $0B96,Y
    DEY
    BPL L829A
    LDY #$00BF
L82A3:
    STA $0BD4,Y
    DEY
    BPL L82A3
    LDY #$001F
L82AC:
    STA $0C94,Y
    DEY
    BPL L82AC
    RTS
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
    REP #$10
    SEP #$20
    LDX #$4300
    STX $38
    STZ $2102
    STZ $0B20
    LDA #$04
    STA $0B21
    LDX #$0900
    STX $0B22
    STZ $0B24
    LDX #$0220
    STX $0B25
    JSR $8512
    RTS
    REP #$10
    SEP #$20
    LDX #$4310
    STX $38
    LDA $0B4A
    STA $30
    STZ $31
    STA $2121
    STZ $0B20
    LDA #$22
    STA $0B21
    LDX $0B4B
    STX $0B22
    LDA $0B4D
    STA $0B24
    LDX $0B4E
    STX $0B25
    JSR $8512
    RTS
    SEP #$20
    REP #$10
    LDX #$4300
    STX $38
    LDX $0B72
    STX $30
    STX $2116
    LDA #$80
    STA $2115
    LDA $0B57
    STA $0B20
    BMI L84AA
    LDA #$18
    BRA L84AF
L84AA:
    LDA $213A
    LDA #$39
L84AF:
    STA $0B21
    LDX $0B6F
    STX $0B22
    LDA $0B71
    STA $0B24
    REP #$20
    LDA $0B6D
    CMP #$0800
    BCC L84D4
    SEC
    SBC #$0800
    STA $0B6D
    LDA #$0800
    BRA L84DA
L84D4:
    LDX #$0000
    STX $0B6D
L84DA:
    STA $0B25
    CLC
    LDA $0B72
    ADC #$0400
    STA $0B72
    CLC
    LDA $0B6F
    ADC #$0800
    BCC L84FD
    CLC
    ADC #$8000
    PHA
    PHP
    SEP #$20
    INC $0B71
    PLP
    PLA
L84FD:
    STA $0B6F
    SEP #$20
    LDA #$01
    STA $4C
    JSR $8512
    LDX $0B6D
    BNE L8511
    STZ $0B57
L8511:
    RTS
    REP #$10
    SEP #$20
    PHY
    PHX
    LDX #$0001
    STZ $0DFF
    REP #$20
    LDA $0B25
    STA $4E
    STA $50
    DEA
    CLC
    ADC $0B22
    BCC L857A
    BNE L8546
    LDA $0B22
    CMP #$FFFF
    BEQ L8539
    INX
L8539:
    DEC $0B25
    DEC $0B25
    SEP #$20
    INC $0DFF
    BRA L856D
L8546:
    REP #$30
    INX
    STA $4E
    INC $4E
    LDA $50
    SEC
    SBC $4E
    STA $50
    LSR A
    BCC L8575
    LDA $50
    CMP #$0001
    BEQ L855F
    INX
L855F:
    DEA
    STA $0B25
    DEC $4E
    SEP #$20
    INC $0DFF
    INC $0DFF
L856D:
    LDA $0B21
    STA $0E00
    BRA L857A
L8575:
    LDA $50
    STA $0B25
L857A:
    SEP #$20
    TXA
    CMP $0DFF
    BNE L8587
    JSR $85B5
    BRA L859A
L8587:
    LDY #$0000
L858A:
    LDA $0B20,Y
    STA ($38),Y
    INY
    CPY #$0007
    BNE L858A
    LDA $4C
    STA $420B
L859A:
    DEX
    BEQ L85B2
    LDA $0DFF
    BNE L857A
    INC $0B24
    LDY #$8000
    STY $0B22
    LDY $4E
    STY $0B25
    BRA L857A
L85B2:
    PLX
    PLY
    RTS
    REP #$30
    PHX
    LDA $0B25
    LSR A
    CLC
    ADC $30
    STA $30
    SEP #$20
    LDA $0B24
    STA $34
    INA
    STA $37
    LDA $0E00
    CMP #$18
    BEQ L85DD
    CMP #$22
    BEQ L85F7
    CMP #$39
    BEQ L8608
L85DA:
    NOP
    BRA L85DA
L85DD:
    LDA #$80
    STA $2115
    LDX $30
    STX $2116
    LDA [$0000]
    STA $2118
    LDA [$0000]
    STA $2119
    INX
    STX $2116
    BRA L8626
L85F7:
    LDA $30
    STA $2121
    LDA [$0000]
    STA $2122
    LDA [$0000]
    STA $2122
    BRA L8626
L8608:
    LDA #$80
    STA $2115
    LDX $30
    STX $2116
    LDA $213A
    LDA $2139
    STA [$0000]
    LDA $213A
    STA [$0000]
    INX
    STX $2116
    LDA $213A
L8626:
    INC $0B24
    LDX #$8001
    STX $0B22
    LDX $4E
    STX $0B25
    PLX
    RTS
    REP #$10
    SEP #$20
    LDA $0B74
    LSR A
    BCS L8655
    LDA $0B74
    CMP #$02
    BEQ L864E
    PHP
    JSR $865E
    PLP
    BRA L865A
L864E:
    PHP
    JSR $86AA
    PLP
    BRA L865A
L8655:
    PHP
    JSR $8713
    PLP
L865A:
    STZ $0B74
    RTS
    REP #$10
    SEP #$20
    LDA #$00
    STA $2115
    LDX $0B7B
    STX $2116
    LDX #$1808
    STX $4310
    LDX #$0B7D
    STX $4312
    STZ $4314
    LDX #$0400
    STX $4315
    LDA #$02
    STA $420B
    LDA #$80
    STA $2115
    STX $4315
    LDX $0B7B
    STX $2116
    LDX #$1908
    STX $4310
    LDX #$0B7E
    STX $4312
    STZ $4314
    LDA #$02
    STA $420B
    RTS
    REP #$10
    SEP #$20
    LDY $0B77
    LDX $0B7B
    STX $0B79
L86B7:
    SEP #$20
    LDA #$00
    STA $2115
    LDX $0B79
    STX $2116
    LDX #$1808
    STX $4310
    LDX #$0B7D
    STX $4312
    STZ $4314
    LDX $0B75
    STX $4315
    LDA #$02
    STA $420B
    LDA #$80
    STA $2115
    STX $4315
    LDX $0B79
    STX $2116
    LDX #$1908
    STX $4310
    LDX #$0B7E
    STX $4312
    STZ $4314
    LDA #$02
    STA $420B
    NOP
    DEY
    BEQ L8712
    REP #$20
    LDA $0B79
    CLC
    ADC #$0020
    STA $0B79
    BRA L86B7
L8712:
    RTS
    REP #$10
    SEP #$20
    LDA $0E19
    BEQ L8721
    LDA #$81
    JMP $8723
L8721:
    LDA #$80
    STA $2115
    LDX $0B7B
    STX $0B79
    STX $30
    LDY $0B77
    REP #$20
    LDA $0B75
    ASL A
    STA $0B75
    LDA #$4300
    STA $38
L873F:
    SEP #$20
    LDX #$1801
    STX $0B20
    LDX $3A
    STX $0B22
    LDA $3C
    STA $0B24
    LDX $0B75
    STX $0B25
    LDX $30
    STX $2116
    LDA #$01
    STA $4C
    JSR $8512
    DEY
    BEQ L87A5
    BMI L87A5
    REP #$20
    LDA $3A
    CLC
    ADC $0B75
    STA $3A
    BCC L877F
    ORA #$8000
    STA $3A
    SEP #$20
    INC $3C
    REP #$20
L877F:
    LDA $0B79
    CLC
    ADC #$0001
    STA $0B79
    SEP #$20
    LDA $0E19
    BNE L879C
    REP #$20
    LDA $0B79
    CLC
    ADC #$001F
    STA $0B79
L879C:
    REP #$20
    LDA $0B79
    STA $30
    BRA L873F
L87A5:
    SEP #$20
    LDA $0DD8
    BEQ L87AF
    STZ $0B74
L87AF:
    RTS
    REP #$10
    SEP #$20
    LDA #$80
    STA $2115
    LDX $0B7B
    STX $0B79
    STX $30
    LDY $0B77
    REP #$20
    LDA $0B75
    ASL A
    STA $0B75
    LDA #$4300
    STA $38
L87D2:
    SEP #$20
    LDX #$3981
    STX $0B20
    LDX $3A
    STX $0B22
    LDA $3C
    STA $0B24
    LDX $0B75
    STX $0B25
    LDX $30
    STX $2116
    LDA #$01
    STA $4C
    LDA $213A
    JSR $8512
    DEY
    BEQ L8823
    BMI L8823
    REP #$20
    LDA $3A
    CLC
    ADC $0B75
    STA $3A
    BCC L8815
    ORA #$8000
    STA $3A
    SEP #$20
    INC $3C
    REP #$20
L8815:
    LDA $0B79
    CLC
    ADC #$0020
    STA $0B79
    STA $30
    BRA L87D2
L8823:
    SEP #$20
    STZ $0B74
    RTS
    REP #$10
    SEP #$20
    LDA $0B62
    BNE L883E
    LDA $0B63
    BEQ L886F
    LDA #$00
    STA $0B63
    BRA L885F
L883E:
    DEC $0B6C
    BNE L886F
    LDA #$0A
    STA $0B6C
    LDA $0B63
    EOR #$FF
    STA $0B63
    BEQ L885F
    LDX $0B64
    LDA $0B66
    STA $0901,X
    LDA #$01
    BRA L8869
L885F:
    LDX $0B64
    LDA #$F0
    STA $0901,X
    LDA #$01
L8869:
    ORA $0B56
    STA $0B56
L886F:
    RTS
    REP #$10
    SEP #$20
    LDA $0B87
    BEQ L88CA
    CMP #$01
    BNE L8894
    LDA $0B88
    BEQ L8891
    LDX $0BA4
    STX $0BA6
    LDX #$0000
    STX $0BAA
    STZ $0B88
L8891:
    JMP $88E6
L8894:
    CMP #$02
    BNE L88AF
    LDA $0B88
    BEQ L88AC
    LDX $0BAF
    STX $0BB1
    LDX #$0000
    STX $0BB5
    STZ $0B88
L88AC:
    JMP $899E
L88AF:
    CMP #$03
    BNE L88CA
    LDA $0B88
    BEQ L88C7
    LDX $0BD2
    STX $0CB6
    LDX #$0000
    STX $0CB8
    STZ $0B88
L88C7:
    JMP $8A02
L88CA:
    CMP #$04
    BNE L88E5
    LDA $0B88
    BEQ L88E2
    LDX $0CC6
    STX $0DC8
    LDX #$0000
    STX $0DCA
    STZ $0B88
L88E2:
    JMP $8A81
L88E5:
    RTS
    REP #$30
    LDA $0BA6
    CMP $0BA4
    BCS L88F3
    JMP $899A
L88F3:
    LDX #$0000
    STX $0BA6
    LDA $0BAA
    CMP $0BA8
    BCC L8908
    BNE L8908
    STX $0BAA
    BRA L890B
L8908:
    INC $0BAA
L890B:
    DEA
    BMI L8916
    INX
    INX
    INX
    BRA L890B
    JMP $899A
L8916:
    LDY $0B92
    SEP #$20
    LDA #$01
    STA $0B20
    LDA #$18
    STA $0B21
    LDA $0B96,X
    STA $0B22
    STA $0BAC
    LDA $0B97,X
    STA $0B23
    STA $0BAD
    LDA $0B98,X
    STA $0B24
    STA $0BAE
    LDX #$4300
    STX $38
    LDA #$01
    STA $4C
    LDX $0BA2
    STX $30
    STX $2116
    REP #$20
    LDA $0B90
    ASL A
    STA $0B25
L895A:
    PHP
    JSR $8512
    PLP
    DEY
    BEQ L899D
    LDA #$1801
    STA $0B20
    LDA $0B90
    ASL A
    STA $0B25
    CLC
    ADC $0BAC
    ORA #$8000
    STA $0BAC
    STA $0B22
    BCC L8983
    SEP #$20
    INC $0BAE
L8983:
    SEP #$20
    LDA $0BAE
    STA $0B24
    REP #$20
    TXA
    CLC
    ADC #$0020
    TAX
    STA $30
    STA $2116
    BRA L895A
    INC $0BA6
L899D:
    RTS
    REP #$30
    LDA $0BB1
    CMP $0BAF
    BCS L89AD
    INC $0BB1
    BRA L8A01
L89AD:
    LDY #$0000
    LDX $0BB9
    STZ $0BB1
    LDA $0BB5
    BNE L89CF
    SEP #$20
L89BD:
    LDA $0BBB,Y
    STA $0902,X
    INX
    INX
    INX
    INX
    INY
    CPY $0BB7
    BCC L89BD
    BRA L89E5
L89CF:
    SEP #$20
L89D1:
    LDA $0BC3,Y
    CLC
    ADC $0902,X
    STA $0902,X
    INX
    INX
    INX
    INX
    INY
    CPY $0BB7
    BCC L89D1
L89E5:
    REP #$20
    INC $0BB5
    LDA $0BB5
    CMP $0BB3
    BCC L89F7
    BEQ L89F7
    STZ $0BB5
L89F7:
    SEP #$20
    LDA #$01
    ORA $0B56
    STA $0B56
L8A01:
    RTS
    REP #$30
    LDA $0CB6
    CMP $0BD2
    BCC L8A7B
    LDX #$0000
    TXY
    STX $0CB6
    LDA $0CB8
    CMP $0BD0
    BCC L8A20
    STZ $0CB8
    BRA L8A23
L8A20:
    INC $0CB8
L8A23:
    DEA
    BMI L8A2B
    INX
    INX
    INX
    BRA L8A23
L8A2B:
    LDA #$0010
    STA $0CBA
    LDA $0BCE
    AND $0CB4
L8A37:
    LSR A
    PHA
    BCC L8A6D
    LDA #$1801
    STA $0B20
    LDA $0BD5,X
    STA $0B23
    LDA $0BD4,X
    STA $0B22
    LDA #$0020
    STA $0B25
    LDA $0C94,Y
    STA $2116
    STA $30
    LDA #$4300
    STA $38
    SEP #$20
    LDA #$01
    STA $4C
    PHP
    JSR $8512
    PLP
    REP #$20
L8A6D:
    TXA
    CLC
    ADC #$000C
    TAX
    INY
    INY
    PLA
    DEC $0CBA
    BNE L8A37
L8A7B:
    REP #$20
    INC $0CB6
    RTS
    REP #$30
    LDA $0DC8
    CMP $0CC6
    BCS L8A8E
    JMP $8B1A
L8A8E:
    LDA $0CB4
    BNE L8A96
    JMP $8B1A
L8A96:
    LDX #$0000
    TXY
    STX $0DC8
    LDA $0DCA
    PHA
    CMP $0CC4
    BCC L8AAB
    STZ $0DCA
    BRA L8AAE
L8AAB:
    INC $0DCA
L8AAE:
    TAX
L8AAF:
    DEX
    BMI L8ABD
    TYA
    CLC
    ADC $0CC0
    ADC $0CC0
    TAY
    BRA L8AAF
L8ABD:
    LDA $0CB4
    AND #$0001
    BEQ L8AE1
    LDX $0CC0
    SEP #$20
    LDA $0CBC
    STA $2121
L8AD0:
    LDA $0CC8,Y
    STA $2122
    INY
    LDA $0CC8,Y
    STA $2122
    INY
    DEX
    BNE L8AD0
L8AE1:
    REP #$20
    PLA
    TAX
    LDY #$0080
L8AE8:
    DEX
    BMI L8AF6
    TYA
    CLC
    ADC $0CC2
    ADC $0CC2
    TAY
    BRA L8AE8
L8AF6:
    LDA $0CB4
    AND #$0002
    BEQ L8B1A
    LDX $0CC2
    SEP #$20
    LDA $0CBE
    STA $2121
L8B09:
    LDA $0CC8,Y
    STA $2122
    INY
    LDA $0CC8,Y
    STA $2122
    INY
    DEX
    BNE L8B09
L8B1A:
    REP #$20
    INC $0DC8
    RTS
    SEP #$20
    LDA $0DCC
    BEQ L8B57
    REP #$10
    LDX $0DCE
    CPX $0DD0
    BNE L8B52
    LDA $0DCD
    BNE L8B3E
    LDX $0DD2
    INC $0DCD
    BRA L8B44
L8B3E:
    LDX $0DD4
    STZ $0DCD
L8B44:
    STX $212C
    STX $0DD6
    LDX #$0000
    STX $0DCE
    BRA L8B57
L8B52:
    REP #$20
    INC $0DCE
L8B57:
    RTS
    REP #$10
    SEP #$20
    LDA $0B7F
    STA $2106
    LDA $0B86
    BEQ L8B8E
    STZ $0B86
    LDX #$0000
L8B6D:
    DEC $0B81
    BEQ L8B76
    INX
    INX
    BRA L8B6D
L8B76:
    LDA $0B82
    STA $210D,X
    LDA $0B83
    STA $210D,X
    LDA $0B84
    STA $210E,X
    LDA $0B85
    STA $210E,X
L8B8E:
    LDX $0E0A
    BEQ L8C04
    REP #$30
    LDA $0E17
    CMP $0E14
    BCS L8BA2
    INC $0E17
    BRA L8C04
L8BA2:
    STZ $0E17
    LDA $0E0C
    CLC
    ADC $0E10
    AND #$03FF
    STA $0E0C
    LDA $0E0E
    CLC
    ADC $0E12
    AND #$03FF
    STA $0E0E
    SEP #$20
    LDX #$0000
    LDA $0E16
    BNE L8BCE
    LDY #$0001
    BRA L8BD8
L8BCE:
    LDY #$0000
L8BD1:
    DEA
    BEQ L8BD8
    INX
    INX
    BRA L8BD1
L8BD8:
    LDA $0E0C
    STA $210D,X
    LDA $0E0D
    STA $210D,X
    LDA $0E0E
    STA $210E,X
    LDA $0E0F
    STA $210E,X
    CPY #$0000
    BEQ L8BFD
    LDY #$0000
    LDX #$0002
    BRA L8BD8
L8BFD:
    REP #$30
    DEC $0E0A
    SEP #$20
L8C04:
    RTS
    SEP #$20
    REP #$10
    LDA $0DDA
    BEQ L8C3E
    LDA $0DD9
    AND #$80
    BEQ L8C3E
    LDA $0DDC
    STA $2123
    LDA $0DDD
    STA $2124
    LDA $0DDE
    STA $2125
    LDA #$01
    STA $4370
    LDA #$26
    STA $4371
    LDX #$0DDF
    STX $4372
    STZ $4374
    LDA #$80
    BRA L8C6D
L8C3E:
    LDA $0DF1
    BEQ L8C6D
    LDA $0DD9
    AND #$20
    BEQ L8C6D
    LDA $0DF2
    STA $4350
    LDA $0DF3
    STA $4351
    LDX $0DF4
    STX $4352
    LDA $0DF6
    STA $4354
    STA $4357
    STZ $0DF1
    LDA #$20
    STA $420C
L8C6D:
    LDA $0DD9
    STA $420C
    LDA #$02
    STA $0DDA
    RTS
    REP #$30
    LDA $0DF7
    BEQ L8C93
    LDX $0DFD
    LDY $0DFB
    LDA $0DF9
L8C89:
    STA $2116
    STY $2118
    INA
    DEX
    BNE L8C89
L8C93:
    STZ $0DF7
    RTS
    SEP #$30
    LDA $0E03
    BEQ L8CD1
    LDX $0B42
    LDY $0B43
    STX $211B
    STY $211B
    LDX $0B44
    LDY $0B45
    STX $211C
    STY $211C
    LDX $0B46
    LDY $0B47
    STX $211D
    STY $211D
    LDX $0B48
    LDY $0B49
    STX $211E
    STY $211E
    STZ $0E03
L8CD1:
    RTS
    REP #$10
    SEP #$20
    STA $0B3E
    STA $2100
    RTS
    REP #$30
    STA $4202
    NOP
    NOP
    NOP
    NOP
    LDA $4216
    RTS
    REP #$10
    SEP #$20
    STX $4204
    STA $4206
    LDA #$03
L8CF6:
    NOP
    DEA
    BNE L8CF6
    LDX $4214
    STX $0B58
    LDX $4216
    STX $0B5A
    RTS
    REP #$10
    SEP #$20
L8D0B:
    LDA $4212
    LSR A
    BCS L8D0B
    LDX $4218
    STX $0B51
    LDX $421A
    STX $0B53
    RTS
    REP #$10
    SEP #$20
    LDX #$4300
    STX $38
    STZ $2102
    STZ $0B20
    LDA #$04
    STA $0B21
    LDX #$0900
    STX $0B22
    STZ $0B24
    LDX #$0220
    STX $0B25
    LDA #$01
    STA $4C
    JSR $8512
    STZ $0B56
    RTS
    REP #$10
    SEP #$20
    LDX #$4310
    STX $38
    LDA $0B4A
    STA $30
    STZ $31
    STA $2121
    STZ $0B20
    LDA #$22
    STA $0B21
    LDX $0B4B
    STX $0B22
    LDA $0B4D
    STA $0B24
    LDX $0B4E
    STX $0B25
    LDA #$02
    STA $4C
    JSR $8512
    STZ $0B56
    RTS
    SEP #$20
    REP #$10
    LDA $4E
    PHA
    LDA $50
    PHA
    LDA #$80
    STA $2115
    LDX #$4300
    STX $38
    LDX $0B72
    STX $30
    STX $2116
    LDA $0B57
    STA $0B20
    BMI L8DAC
    LDA #$18
    BRA L8DB1
L8DAC:
    LDA $213A
    LDA #$39
L8DB1:
    STA $0B21
    LDX $0B6F
    STX $0B22
    LDA $0B71
    STA $0B24
    REP #$20
    LDA $0B6D
    STA $0B25
    SEP #$20
    LDA #$01
    STA $4C
    JSR $8512
    STZ $0B57
    REP #$20
    PLA
    STA $50
    PLA
    STA $4E
    RTS
    PHP
    REP #$30
    PHA
    PHX
    PHY
    PHB
    SEP #$20
    LDA #$00
    PHA
    PLB
    REP #$20
    LDA #$0000
    STA $68
    LDA $0052
    AND #$00FF
    ASL A
    TAX
    JSR $99F0,X
    REP #$30
    PLB
    PLY
    PLX
    PLA
    PLP
    RTS
    PHP
    REP #$30
    PHA
    PHX
    PHY
    PHB
    SEP #$20
    LDA #$00
    PHA
    PLB
    REP #$20
    LDA #$0000
    STA $68
    LDA $0052
    AND #$00FF
    ASL A
    TAX
    JSR $99F0,X
    REP #$30
    LDA $68
    STA $0A
    PLB
    PLY
    PLX
    PLA
    PLP
    RTL
    SEP #$30
    LDA $54
    STA $3D
    LDA $55
    STA $3E
    LDA #$7E
    STA $3F
    RTS
    SEP #$20
    LDA #$8F
    JSR $8CD2
    STZ $0DD8
    INC $0DD8
    STZ $4200
    LDA #$04
    STA $2133
    JSR $8E2F
    SEP #$30
    LDY #$00
    LDA [$0000]
    STA $0B3F
    STA $2101
    TAX
    AND #$03
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    STZ $0B2A
    STA $0B2B
    TXA
    AND #$18
    LSR A
    LSR A
    LSR A
    TAX
    LDA #$00
    CLC
L8E7A:
    ADC #$10
    DEX
    BPL L8E7A
    ADC $0B2B
    AND #$70
    STZ $0B2C
    STA $0B2D
    LDA [$0000]
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA $9A9A,X
    STA $0B40
    INY
    INY
    LDA [$0000]
    STA $2105
    STA $0B29
    INY
    INY
    LDA [$0000]
    STA $2107
    AND #$FC
    STZ $0B2E
    STA $0B2F
    INY
    INY
    LDA [$0000]
    STA $2108
    AND #$FC
    STZ $0B30
    STA $0B31
    INY
    INY
    LDA [$0000]
    STA $2109
    AND #$FC
    STZ $0B32
    STA $0B33
    INY
    INY
    LDA [$0000]
    STA $210A
    AND #$FC
    STZ $0B34
    STA $0B35
    INY
    INY
    LDA [$0000]
    STA $210B
    AND #$F0
    STZ $0B38
    STA $0B39
    LDA [$0000]
    ASL A
    ASL A
    ASL A
    ASL A
    STZ $0B36
    STA $0B37
    INY
    INY
    LDA [$0000]
    STA $210C
    AND #$F0
    STZ $0B3C
    STA $0B3D
    LDA [$0000]
    ASL A
    ASL A
    ASL A
    ASL A
    STZ $0B3A
    STA $0B3B
    RTS
    SEP #$30
    JSR $8E2F
    REP #$10
    SEP #$20
    STZ $0B56
    LDA #$04
    STA $2133
    LDA $0DD6
    STA $212C
    LDA $0DD7
    STA $212D
    STA $0B41
    STZ $420C
    STZ $420B
    LDX #$4300
    STX $38
    LDA #$01
    XBA
    LDX $0B2E
    STX $30
    STX $2116
    LDA #$18
    LDY #$0000
    JSR $9058
    LDA $0B56
    STA $4C
    JSR $8512
    STZ $0B56
    LDA #$02
    XBA
    LDA #$10
    STA $38
    LDX $0B30
    STX $30
    STX $2116
    LDA #$18
    JSR $9058
    LDA $0B56
    STA $4C
    JSR $8512
    STZ $0B56
    LDA #$04
    XBA
    LDA #$20
    STA $38
    LDX $0B32
    STX $30
    STX $2116
    LDA #$18
    JSR $9058
    LDA $0B56
    STA $4C
    JSR $8512
    STZ $0B56
    LDA #$80
    STA $2115
    LDX $0B32
    STX $2116
    LDX #$0400
L8FAA:
    STZ $2118
    STZ $2119
    DEX
    BNE L8FAA
    LDA #$08
    XBA
    LDA #$30
    STA $38
    LDX $0B2A
    STX $30
    STX $2116
    LDA #$18
    JSR $9058
    LDA $0B56
    STA $4C
    JSR $8512
    STZ $0B56
    LDA #$10
    XBA
    LDA #$40
    STA $38
    LDX $0B2C
    STX $30
    STX $2116
    LDA #$18
    JSR $9058
    LDA $0B56
    STA $4C
    JSR $8512
    STZ $0B56
    LDA #$20
    XBA
    LDA #$50
    STA $38
    LDX $0B36
    STX $30
    STX $2116
