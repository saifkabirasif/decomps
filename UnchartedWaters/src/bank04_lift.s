;
; Uncharted Waters (USA) - bank04_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $4000-$4FFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $4000

    ORA $7A9F00
    SBC [$0000]
    EOR $840C,X
    ORA $EBFC6F
    ORA $BC07
    BRK $E0
    ORA ($F0,X)
    BRK $FF
    SBC #$C898
    STA [$0000]
    PLX
    CMP $2F,S
    SBC $1FEA6C
    BRK $40
    LDX #$02C0
    BRK $7F
    ORA $C3,S
    EOR ($DF,S),Y
    PLX
    LDA [$0000]
    SBC [$0000]
    BIT $FDDE,X
    INC $3F17,X
    ORA $C5EA,X
    TCD
    BRK $F5
    PHK
    ORA ($0C)
    SBC $95AB,X
    SBC $3FE6,Y
    ORA ($9C,S),Y
    LDX $3CF6,Y
    ROR $00,X
    CMP ($2F),Y
    AND $4F83F8
    ORA [$0000]
L4056:
    ROL $F9FD
    STA $0B,S
    ROR $FD4F,X
    XBA
    ORA $C77C7E
    LDA [$0000]
    SEI
    CMP $B9F3F9
    SBC $CB
    SBC $65
    STX $12,Y
    BRK $F2
    PLB
    PHK
    LSR $E00C,X
    EOR $DD6A,Y
    BMI L4056
    WDM $42
    RTL
    SBC $E3D800
    SBC $82F1,X
    ORA $E1F4F8
    AND $977C3E
    ORA $37
    SBC $060023
    INC $DF4B,X
    CMP $C666BF
    CMP $F23E,X
    AND ($21,X)
    DEC $025F
    ADC $2FE0,X
    ORA $A1E0,X
    CPY $E09F
    SBC ($0E),Y
    JSR $3FFC
    ADC $29F7
    AND #$2D2D
    CLI
    STA $B39E9E
    STY $1FB3
    SBC [$0000]
    ADC $771D1D
    STX $82
    PLB
    SBC $EF,X
    ASL $26
    ADC ($E0),Y
    SBC ($9D),Y
    ORA [$0000]
    SBC ($21,S),Y
    LDY $0D0D,X
    ASL $E8,X
    CPY #$CFCF
    CMP $80F7,X
    AND ($DD)
    SBC $8077,X
    ORA ($D4,X)
    DEC $97C4
    TXY
    ADC ($1F,S),Y
    PLX
    SBC ($66,S),Y
    CMP $198F,Y
    BRL $240E
    STP
    STX $FE,Y
    ORA ($02,X)
    SBC $40BF,Y
    BRK $58
    ROL $0E1B,X
    XCE
    REP #$BC
    CPX #$2F6F
    XBA
    SBC [$0000]
    LDY $7BE7,X
    STA [$0000]
    BRK $1F
    SBC $F33FD7
    ADC [$0000]
    INC $2F9D,X
    CMP ($F2),Y
    STA $E078BC
    EOR $DF,S
    AND ($B5),Y
    REP #$3E
    ROR $EEEE,X
    CMP [$0000]
    CMP ($81,X)
    ORA $4C,S
    AND $7B3F9B
    CMP ($12,S),Y
    ORA ($F0)
    BCC L4149
    ORA $32BC0F
    LSR $15F2,X
    ROL $0707,X
    AND $23,S
    RTS
    STA $AEAE3F
    STZ $B637
    ORA $30A517
    STX $00,Y
    BIT #$8F0B
    ORA ($B9)
    CMP ($C0),Y
    ASL $A9
    CMP $0047CB
    RTS
    AND $1FDC
    SBC $6B00F2
    INC $CBEF,X
    LDA $A2D3
    ORA $D8FB
    JMP $3C96
    ORA ($A0,X)
L4177:
    ORA [$0000]
    LDY $02F5,X
    INY
    BRK $3F
    AND ($F0)
    BRL $EF43
    XBA
    BIT #$BC7D
    STA $3787EF
    ORA $0BCFFF
    BRK $BF
    BEQ L4177
    STA [$0000]
    CMP $9F61
    STA $DDF0E0
    SBC ($4F,S),Y
    CPY #$E779
    BCS L4200
    STZ $03,X
    ORA ($15)
    CMP ($6F)
    ROR $F8,X
    CMP $B7,S
    ADC $69F0EC
    SBC [$0000]
    BRK $ED
    TSB $3F
    BIT $F478,X
    SBC ($FE,S),Y
    JMP $0FC1,X
    ORA $78F01E
    ADC $FF,X
    INC $CF00,X
    CMP [$0000]
    SBC ($8F),Y
    LDA $3F0079
    LDY $B0F1,X
    ORA $2F04E0
    ORA $F5007A
    ORA $BE73
    EOR $8D1FFE
    PLX
    TSB $1E
    LDA $01C7E5
    STY $78A9
    BRK $B5
    ORA $13E176
    BIT $C0F0,X
    ORA ($FF,X)
    CMP $E3,X
    XCE
    SBC $04,S
    SBC $3EF6FE
    BIT $7D,X
    CLC
    LDY #$981C
    EOR $43,S
    EOR ($41,X)
    CMP ($C3,X)
    SBC ($F1),Y
    STY $5B,X
    BRK $04
    STA [$0000]
    BCS L41C7
    CPX #$D9D9
    TXY
    PHB
    BCC L4299
    CMP $E226
    STA ($83,X)
    TSB $90E5
    CLD
    EOR ($B7,S),Y
    ORA [$0000]
    LDA ($3F),Y
    STA ($E9),Y
    STP
    ORA $E4,S
    EOR $FD
    JML $B835EB
    JSR $D720,X
    ASL $05,X
    STA [$0000]
    LDA ($83,S),Y
    TDC
    ADC ($E3,S),Y
    SBC $79,S
    CMP $6161,Y
    BRK $EC
    EOR $0F17
    STA $3EB4,X
    CMP #$514A
    ROL $4BAD
    EOR ($30),Y
    CPX $D1C7
    SEP #$C7
    CMP [$0000]
    SBC $8133
    STA $C5,X
    BPL L42A7
    LDA [$0000]
    AND $AE04,X
    SBC ($8A,S),Y
    EOR $9F4C,X
    BNE L426F
    RTS
    TYX
    LDY $1B1B,X
    ORA $8CB79D
    CMP $1B6E,Y
    CPY #$3100
    TXY
    SBC ($2A),Y
    LDA $7C2BFB
    CLC
    CMP $009F,X
    INC $1E75,X
    RTS
    SBC $0FD7,Y
    ADC $525278
    PHY
L4299:
    PHY
    CPX #$161D
    CMP $DCB3BE
    TRB $40
    CMP #$7DCB
    ADC ($73,S),Y
L42A8:
    ORA $0038,X
    SBC [$0000]
    EOR ($1E),Y
    TRB $FDFF
    BEQ L42A8
    ASL $7D
    LSR $B906,X
    ADC $7E6700
    EOR $D9EE5A
    SBC $37
    AND [$0000]
    SED
    ROR $D1
    CMP ($DD),Y
    STX $9F,Y
    STZ $1313
    NOP
    PHB
    ASL $3E
    LDX $596B
    STY $E0,X
    SBC ($E1,X)
    CMP ($BA,S),Y
    JSR $72CD
    STA $9301,Y
    AND [$0000]
    CLC
    LDX $ED6C,Y
    PLY
    DEC $2D60,X
    AND [$0000]
    TSX
    CMP $08
    JMP $7D94,X
    LDA $12B1,Y
    CLC
    AND $2EC42A
    ROL $C7,X
    CMP $C3,S
    SED
    ORA ($3F,X)
    ADC $19AD,Y
    ASL $C0
    ROR $CD,X
    ADC ($FC)
    XBA
    INC $3DA3
    AND $77C7,X
    CPY #$BFBF
    ADC $89DBFC
    LDA $7D38,Y
    ROR $D794
    ASL $7F,X
    CLD
    ROL $D82E
    NOP
    ADC $FC9C7F
    INC $1012
    SBC ($BF,X)
    ORA $0A,S
    LDA $2CE3,Y
    EOR ($F3)
    EOR $FC3F,X
    SBC ($84,X)
    ADC [$0000]
    SEI
    INC $63
    STZ $E01D,X
    STA ($5F)
    ASL $E861,X
    INX
    CMP [$0000]
    CPY #$8888
    ROR $7DF5,X
    STZ $D3,X
    CMP $BC,S
    CLD
    SBC [$0000]
    JMP $00AC,X
    DEC $C3F6,X
    ROL $CF13
    ADC ($CF,X)
    PLY
    SBC ($1F,X)
    STA $AAA6F0
    EOR $F0BF00
    CPX #$7F61
    LDA $C2E1FF
    STA $3CE8F3
    INC $2E7F
    SBC $3E0B
    BIT $00F9,X
    BRK $D6
    STZ $6E2B,X
    STA [$0000]
    INC $DD28,X
    CMP ($E5),Y
    CPX $5F
    CLD
    CLC
    SBC $4F,S
    LDA $68DCFA
    ADC [$0000]
    SBC $AB
    SBC $ABBE7C
    ORA ($F4,X)
    JSL $8FFFB5
    ORA ($F2)
    CMP #$EDE3
    EOR $111C
    STA $11,S
    TYX
    STA [$0000]
    EOR $18C9C5
    CMP $0202,Y
    BRK $3F
    EOR [$0000]
    CPX #$55E1
    CMP $FE,S
    ROR $C3C1,X
    ORA $ECFF1F
    STA $FA
    LDY $CF1E,X
    ORA $3C007F
    SBC $1380
    STX $1F37
    INC $CA3F,X
    BVS L439C
    CPX $5F
    AND $4078,X
    ADC ($00,X)
    BRK $7E
    BRK $19
    STX $973F
    JSR $D0DE,X
    SBC $F255,Y
    SBC $C02AE9
    WDM $42
    ORA [$0000]
    ASL $E8F9,X
    ORA $00BC07
    CPX #$E006
    STX $53,Y
    PHP
    SBC [$0000]
    EOR ($AA),Y
    ORA [$0000]
    INC $207F,X
    WAI
    AND #$8070
    ASL $23
    STZ $C13E,X
    DEC $CFCF,X
    CMP ($F4,X)
    SEI
    JSR $598B,X
    EOR $9FB2,Y
    BRK $0D
    ADC $052F8F
    ORA $B7F165
    BRK $5E
    INC $267F
    CMP $DFDF
    LDY $BC,X
    SEI
    AND #$CCCC
    ORA [$0000]
    STZ $9C83
    SBC $6A30CF
    ROL $0D0E,X
    LSR $7777,X
    ORA ($9F,X)
    DEC $0FB7
    SBC $E7,S
    EOR $B4BC,Y
    SEI
    CMP $7FFB7D
    CLD
    BRL $BC38
    STY $56
    INC $1FC4,X
    SBC [$0000]
    BRK $D4
    CMP $6CCD5C
    CMP $74746D
    CLI
    LDY $C5
    CMP $F4
    ORA ($C7),Y
    ORA ($D3,X)
    ADC $75,X
    STY $00
    SBC $F187,X
    INY
    INY
    BRK $AB
    CMP ($7C)
    INC $F2
    LDA [$0000]
    NOP
    STY $F5,X
    RTL
    ORA $00F644
    STA $0B8036
    STP
    ROL $DBB7,X
    DEC $6FF8,X
    BRK $F0
    SBC ($01,X)
    CMP $CBDEDE
    STA ($68,S),Y
    STX $7B,Y
    BIT $4770
    CMP $CF2D,Y
    ADC #$6983
    CMP ($4F,S),Y
    ADC $79
    ORA ($AC,X)
    ORA [$0000]
    STA $9D018F
    STA $27F2F2
    LSR $F2,X
    STZ $CB51,X
    SBC [$0000]
    LDA $04AD9D
    LDY $BC98,X
    STX $FB,Y
    PHK
    PER $20FA
    ADC $65
    STA $81
    JMP $0061,X
    CLV
    AND [$0000]
    LDA [$0000]
    ROL $C9CF
    ROR $728B,X
    INC $5726
    ASL $C0
    CMP $987E03
    CLD
    STA $8DF8,X
    STA $EDB2
    CPY #$B8B8
    CMP ($F3,X)
    CMP #$F0F3
    SBC ($3F,S),Y
    ASL $84F2,X
    BEQ L44AF
    BRK $D8
    ADC $1F1855
    ROL $F17C,X
    CPY $5C3F
    SEI
    AND [$0000]
    SEP #$69
    ADC $550379
    ORA [$0000]
    INC $E6,X
    ORA ($A9,X)
    TCD
    BIT $FA,X
    ROR $C4EE,X
    CPY $03
    NOP
    CLC
    STA [$0000]
    SBC ($9E,S),Y
    SBC ($C6,S),Y
    STA ($9F,X)
    ADC ($71),Y
    BRK $B6
    CPX $00BB
    ORA [$0000]
    ROL $43,X
    REP #$3F
    BRK $CA
    INC $80E3,X
    LDX $FD,Y
    EOR ($D7),Y
    LSR $E27A
    PHD
    STA $6FF67E
    ORA [$0000]
    TSB $0FFE
    LDY #$5B5B
    ADC ($7E,S),Y
    ADC $B966
    CPX $03C9
    CMP $DE9D,Y
    CLV
    INC $C19B
    ADC $0FF5
    PLA
    PLA
    BRK $09
    DEC $E378,X
    STA $5F
    SBC $8BE3F0
    EOR $0FF5F9
    AND $65E37E
    ADC $2C75F9
    ASL $55
    ORA ($47,S),Y
    PLX
    ROL $70
    BIT $0542
    LDX $B9B9,Y
    PHP
    SBC $D47B00
    LDA $93
    PEI ($2D)
    ORA #$AB7F
    SBC $CB
    AND ($CB,S),Y
    ADC ($00,S),Y
    BIT $0197
    DEX
    JSR $D1E4,X
    ORA $01F026
    SED
    BRK $F6
    TRB $846B
    TDC
    LDY $7EE5,X
    RTI
    STA $1771,Y
    ASL $F0
    INC $9F,X
    RTS
    STZ $569E,X
    STZ $071D,X
    AND $80E0,Y
    LSR $41
    PLX
    PHP
L45D0:
    LDY #$DA0C
    SEI
    ADC $EA,S
    AND [$0000]
    JMP $3BCB,X
    SBC $800E8B
    ASL $807E
    CMP $34
    BEQ L45B5
    STA $47FF,Y
    SBC [$0000]
    STA $FD
    SBC ($9C,X)
    LDA [$0000]
    SBC $8200,X
    AND $A77ACF
    AND $85FD,X
    TSB $9F
    BIT $88F0,X
L4600:
    AND $5FF1EF
L4604:
    SEI
    BMI L4600
    TSX
    COP $5F
    DEA
    DEA
    ADC ($22,X)
    XCE
    SEI
    ASL $7FEF,X
    LSR $4703,X
    XCE
    CMP $AB,S
    LDY $B6F3,X
    LDA $12,S
    BIT $F99E
    INA
    INA
    BRK $47
    ORA $3F,X
    BIT #$87FA
    TSB $9F
    ADC $82BA7D
    ORA $69E3CF
    SBC $CD,S
    ORA $F800C0
    SBC $AE7FE7
L463E:
    BEQ L4604
    AND $E3,S
    LDA $DCF8,X
    SBC ($BC,X)
    LDA ($F7,S),Y
    BMI L45D0
    BMI L463E
    EOR $5C5C,Y
    SBC ($E5,X)
    COP $F0
    ASL $97F5,X
    ROL $DA17,X
    CMP [$0000]
    SED
    ORA ($10,X)
    STA $52DBFA
    EOR ($5A)
    BRA L46C1
    EOR $3D,S
    LDA $8F,X
    INC $F1
    CMP ($F3,S),Y
    ROR $C0F8,X
    WAI
    TYX
    LDA $D8F1E6
    SBC ($00,S),Y
    AND [$0000]
    ADC $E1C2,Y
    CMP $1D7DAF
    STA ($1F,X)
    LDA $7C51E3
    SBC #$7DAF
    BRK $03
    STA $607A3E
    JSL $B37FE7
    ROL $C3F5,X
    ROL $C73E,X
    LDA $00,S
    SEI
    CMP [$0000]
    PLX
    CMP $130F,Y
    SEI
    ROR $DEF7,X
    BIT $3EC7,X
    SEI
    REP #$0D
    EOR $01DDF8
    LDA $813DFD
    ORA $BF,S
    AND $E1747F
    ADC $6DE3F8
L46C1:
    XCE
    CPY #$A303
    ORA $990F80
    CMP ($CF,X)
    PLX
    AND $80,X
    SEC
    STA $E1009F
    TCD
    BRK $E7
    SBC $8F00,X
    LDA [$0000]
    SED
    CMP $FA,S
    LDA $131F36
    CPY #$D7F8
    BRK $FF
    EOR $0BE1,X
    PLD
    LDY $B0F0,X
    SBC ($38)
    ORA $FE,X
    BEQ L46A0
    STP
    DEC $C780
    LDY $C3E5,X
L46FB:
    ORA [$0000]
    SBC [$0000]
    CMP [$0000]
    PHY
    BRL $3610
    DEC $00DE,X
    JMP $BCEB,X
    AND $8DF08D
    TSA
    SED
    CPY #$7F15
    ADC $F9,S
    LSR $4300,X
    TXA
    COP $F8
    SBC $ECFB8F
    ORA #$3C5F
    INC $D007
    STA $5D
    ORA $B972,X
    PHB
    DEC $7A7A,X
    BRK $74
    LSR $4E5E,X
    LSR $FE4F
    STA ($63,X)
    AND #$6FCB
    STZ $EF,X
    STA $71,S
    LDY $BED7,X
    PHA
    CPX #$C148
    CMP ($DB,X)
    STA $F8FF75
    LDX $DFCF,Y
    EOR [$0000]
    LDA $5C07FD
    TYA
    SEC
    ADC [$0000]
    JSR $7FAD,X
    INY
    INY
    JML [$FBDC80]
    MVP $FE17,$FF
    LDX $E0BF
    SBC [$0000]
    AND [$0000]
    EOR ($F7,S),Y
    ORA $E2,S
    LDA ($1E,S),Y
    BVS L46FB
    TCD
    STA $E613,X
    TDC
    JMP $4C24,X
    JMP $F60C
    ORA [$0000]
    ASL $F9C7,X
    INC $EB,X
    CMP [$0000]
    ADC [$0000]
    CMP [$0000]
    BMI L4754
    JSR $3737
    SEP #$B1
    SBC [$0000]
    SEI
    CPY #$3C
    DEC $03,X
    SBC ($1F,X)
    ROL $58BC
    ASL $EC
    INC $C7
    TSB $28FF
    WDM $42
    TSB $24BA
    LDY $3B,X
    AND [$0000]
    ADC ($61,X)
    NOP
    ASL A
    ASL $3D
    LDA $FEF26F
    ROL $DFE4
    LDX $855B
    STA $FE
    AND ($06),Y
    LDA $03D7,Y
    ADC [$0000]
    ROL $D8FE
    BCS L477F
    SBC $5D
    BRK $47
    SBC $CF37,Y
    ROL A
    CMP $F84FEF
    SBC $61F0AB
    AND $36F6E3
    REP #$63
    AND $23,S
    SBC $2EAC,Y
    ROL $E138
    BRK $BF
    LDX $B8,Y
    EOR [$0000]
    INC $41,X
    PHX
    ADC ($1F,X)
    CPY #$E2
    DEC $FE72
    TSB $00
    SBC $2CB57A
    LDA $81,S
    LDA [$0000]
    SEI
    LDA $EC42A7
    SBC ($00),Y
    AND $C37878
    BRK $27
    BNE L4835
    CMP ($FE,S),Y
    CPY $4A
    PLX
    STA [$0000]
    EOR $009DF0
    EOR $E1F5FF
    AND [$0000]
    JSR $ECEC,X
    AND $FCF837
    XBA
    SBC [$0000]
    CMP [$0000]
    AND $CFB2FC
    BRK $3A
    SBC ($02),Y
    SBC $8F7EDF
    CPY #$F2
    TAY
    INC $C597
    AND $004973
    ORA $E97CE6
    ADC [$0000]
    SBC $87C3,X
    ADC $E3D7E3
    CMP $67D5E1
    SBC $C7AB01
    SBC $8FC3,X
    ADC $7CD6F8
    SBC $01,X
    CMP $0801D1
    BRK $09
    JSR $940A,X
    ADC $0B803B
    ADC $1F437B
    SBC ($E7)
    AND [$0000]
    ORA $8C,S
    SBC ($DA)
    ORA ($27),Y
    SED
    STA $BEF74F
    CLC
    SBC ($B6)
    LDX $C0,Y
    SBC $5F4FFF
    AND $0018E0
    ADC $8500,X
    LDA [$0000]
    PLA
    REP #$2E
    RTS
    ORA $5858BB
    INC $9D04,X
    LDA $DC3E3E
    XCE
    PLP
    LDA ($5D,S),Y
    ORA ($00,X)
    STA $AD306F
    LDA [$0000]
    JSR $2080,X
    BRK $F2
    BRK $FF
    LDA $4AC0,X
    LDA $C10F3D
    XCE
    LDA [$0000]
    SBC $2173,X
    AND ($20,X)
    JSR $9600
    SBC [$0000]
    SBC #$C4FB
    BIT $D3EA,X
    AND [$0000]
    SBC $7FE5E3
    JML [$0759E2]
    CPX $2ECF
    STY $BF
    WAI
    LSR $BC34
    AND $2D2929
    LDA ($2D),Y
    STA $9C10,X
    STZ $D79D
    SBC ($AF),Y
    JSR $1B02,X
    PHB
    TAS
    ORA ($77,S),Y
    PLX
    SBC ($C0),Y
    COP $99
    ORA $81B0,Y
    STA ($CF,X)
    ORA $03,S
    CPX #$08
    ORA $05
    STA $F94C8F
    TSB $80
    AND $0DF46E
    ORA $B60D
    PLA
    AND [$0000]
    CLD
    STX $E08E
    JMP $8787
    ROR $EB1C,X
    SBC $4760,X
    EOR [$0000]
    CPY $EAC0
    STP
    LDX #$43
    LDA $D62200
    PHD
    CPY #$7E
    INC $E2,X
    AND $F8F05F
    CMP $9C73,Y
    LDA [$0000]
    ASL $05E0,X
    CMP [$0000]
    XCE
    STP
    PLA
    STX $7D,Y
    ORA ($64,X)
    BIT #$393F
    BRA L498E
    BIT $3FEA,X
    SBC $9F71,X
    NOP
    AND [$0000]
    LDA $78D04B
    DEC $2D,X
    BEQ L49CC
    ORA $CC,S
    AND $EAFC3F
    ORA ($12)
    ADC $27,X
    TSB $E2C0
    CMP $2F
    ORA $19DCB0
    AND $803D,X
    LDA $F2
    EOR ($60),Y
    DEC $E5CE
    STX $D9F3
    ROL $95F2,X
    JML $00EDCB
    ADC [$0000]
    CMP $DAB316
    ASL $9CF5,X
    SBC $09
    ORA #$FBBF
    BMI L4A0F
    TXY
    ORA $D63F1F
    STA $B6F853
    BMI L49CF
    ADC ($9E),Y
    EOR [$0000]
    RTI
    STA $7E5B,X
    ASL $ABCF,X
    BRK $78
    PLX
    PHB
    SBC $8FC3FC
    ORA [$0000]
    SBC [$0000]
    AND $3FF1F5
    STZ $5FE3,X
    AND $F100F9
    LDA $BB12,Y
    ASL $FE27,X
    LDA ($C3,X)
    EOR [$0000]
    JSR $8F01,X
    CMP [$0000]
    RTS
    TYA
    SBC $52,X
    EOR ($6F)
    ADC $1BE3F7
    ROR $E9BF,X
    CPX #$09
    SBC $0003,X
    STA $EABCCF
    PLX
    XBA
    PLD
    LDY $F8,X
    REP #$F2
    ORA ($36),Y
    ROL $6F89,X
    SEI
    CMP $00,X
    AND [$0000]
    EOR $9B9F,Y
    SBC ($CB)
    LDA ($7C,S),Y
    BIT $F51E
L4A0A:
    SBC $1F
    BRK $27
    JMP $CD7E,X
    CPY #$3C6A
    LDA $22CBEA
    JML [$F3BFFB]
    LDX $7930
    TXA
    ORA #$24D2
    BIT $FE
    ROR $77,X
    AND [$0000]
    SBC $1A,S
    SBC $0062C7
    STZ $C3C1,X
    SBC [$0000]
L4A34:
    ADC $9DFF,X
    SED
    PEI ($6B)
    AND $78
    CMP ($91,X)
    ASL $E002
    BRK $4F
    ORA $FBC7D4
    SED
    AND $A5E14F
    TSA
    SBC $BFC2EA
    BEQ L4A34
L4A53:
    CMP #$3C00
    ROR $F8,X
    SEI
    SBC $2F27,Y
    JSR $4361,X
    JSR $2FF6,X
    SED
    INC $74,X
    INC $C7,X
    ROR $D5
    INC $E1,X
    SBC ($6C,X)
    SBC ($8C),Y
    STA $E3E3
    RTS
    CLV
    BIT #$6767
    LDA #$B3FE
    SBC $16EF,Y
    AND $97,X
    CMP [$0000]
    CPY #$BBBB
    STZ $39,X
    AND [$0000]
    BEQ L4A0A
    ADC ($6F),Y
    DEY
    SBC $1E
    BCS L4A53
    STZ $3F00,X
    ADC $8FA9,X
    INC $F1,X
    AND $D2F09E
    STA $D5FF,X
    SBC $FF,S
    SBC ($C7,X)
    STA ($00,S),Y
    SEI
    CMP $B1,X
    EOR $E1F0BF
    CMP $B7FAEF
    ORA $55E3F0
    LSR $7E53,X
    ADC $6194,X
    SEC
    WAI
    SBC ($F1),Y
    ROR $19,X
    CMP $80A72D
    LDA [$0000]
    WAI
    MVP $FDD4,$ED
    PLY
    WAI
    EOR $01F094
    BIT $6003
    LDX $FB
    DEC $43DE,X
    BMI L4AA5
    SBC $CFEE,X
    CPX #$219D
    ROL $1600,X
    BVS L4B66
    CLC
    BEQ L4A79
    PLB
    EOR $E1F0BF
    AND $4F
    XCE
    STA $01001E
    ASL $F01E,X
    INC $1F09,X
    STA $9C6BE0
    LDA $13F3ED
    LDY $EB3C,X
    ROR $007B,X
    LDA $1F,X
    EOR $BCF0F0
    AND $B94F8D
    SBC ($61,S),Y
    ORA ($1C)
    INC $F5F1,X
    PHP
    BRK $11
    ROR $B4F1,X
    STA [$0000]
    LDA ($8F,S),Y
    SBC $F1,S
    CMP ($E3,S),Y
    CPY #$80E3
    ORA $3DF1F6
    DEC $3E00,X
    ASL $D7C3,X
    SBC [$0000]
    INC $87,X
    ORA $D678DE
    JSR $7FF6,X
    AND $E0E0BF
    ADC $7F00,Y
    DEC $9FA8,X
    JSR $83F1,X
    LDA $ED7DA7
    STA $3F
    JMP $5BE1,X
    ADC $1FB27B
    BRK $B8
    BEQ L4B03
    ORA $A752EA
    BIT $EA
    SBC ($BF),Y
    BEQ L4B4A
    ADC ($8F),Y
    SBC $8F87,X
    PLX
    SBC $00,S
    PHD
    LDA $559FC1
    SBC $3FE1F9
    INC $A8F1,X
    LDA $82FDFC
    STA [$0000]
    JMP $00ED,X
    TCD
    AND $C4E15E
    LDA $A3EBFC
    AND $E7F0BF
    ADC [$0000]
    EOR [$0000]
    AND $00EC7C
    AND $1FD57C
    JMP $0FF8,X
    INC $FAAF,X
    PLX
    TSB $1F
    STA $F04BE7
L4BAC:
    CLV
    LDA [$0000]
    TSB $E5FB
    STA $CB39FB
    BIT #$71E6
    ADC ($78),Y
    RTI
    ASL $FF,X
    CLC
    STX $00,Y
    SBC $7125,X
    LDX $0101
    COP $DF
    AND $2E,S
    TSA
    CPX $C0
    BCS L4B80
    ROR $C9FC,X
    ADC [$0000]
    LDA ($FE),Y
    SBC ($71)
    ASL $02CC
    COP $03
    XCE
    RTS
    JMP $D9D9
    CPX $3009
    CMP ($7E),Y
    TAY
    INC $C4
    CPY $C0
    AND [$0000]
    SED
    SED
    AND $D05280
    TCD
    TCD
    ORA $7D,X
    ADC $94EE
    ORA $575E,X
    CMP $30AC01
    BEQ L4BAC
    AND ($31),Y
    LDY $E0BA,X
    PHD
    SBC $07,X
    ORA [$0000]
    SED
L4C10:
    CMP $BB8F00
    ADC $0E17
    SED
    LDY $DDE5,X
    TSB $1A5E
    EOR [$0000]
    CPY #$7979
    ASL $CAEC
    ORA #$3E59
    STA [$0000]
    JMP $2E63
    ADC $FDCF00
    CMP $6586
    SEP #$96
    WAI
    TSB $2A6C
    ADC #$0EDB
    PHP
    SEI
    CPY #$40
    STA ($A1,S),Y
    PHD
    LDY #$BE
    BNE L4C10
    ORA [$0000]
    CMP $650C,Y
    STX $6F,Y
    BRK $E3
    EOR $F0
    JML [$BE9E9E]
    DEX
    BCS L4C30
    TSB $00DF
    RTI
    AND ($00)
    TXA
    REP #$98
    ORA [$0000]
    CMP $EBC0,Y
    LDA $FC0C,X
    ROR $9F6A
    DEC $2370
    AND $38,S
    ADC [$0000]
    PEI ($FF)
    AND ($21,X)
    ADC ($73,S),Y
    LDX $B6,Y
    STX $B0
    STX $63
    ORA [$0000]
    CMP $1F
    AND [$0000]
    CPY $6F25
    CPY #$F8F8
    TYA
    LDA $13FB,Y
    BRK $13
    EOR ($80),Y
    CPX #$8787
    STA $16,S
    ADC $7F
    ADC ($31,S),Y
    SBC $FC,X
    ADC [$0000]
    LDA ($B3,S),Y
    SBC $4B
    ROR $CB3C
    SBC [$0000]
    TDC
    STX $07,Y
    ROR $CE
    TSB $80
    CMP $063198
    PHP
    PHK
    TCD
    BRA L4D06
    LDA $B60F,Y
    EOR ($00),Y
    COP $F9
    SBC $9C,S
    STZ $CDCD
    BRA L4C98
    LDA #$E87F
    SEC
    STA $C9FF9B
    AND $C8,X
L4CD4:
    TSB $1893
L4CD7:
    STA $74F37D
    ORA $970D
    BVC L4CD7
    ORA $D860,Y
    ADC $1F1F
    REP #$4C
    INA
    JML $3A8934
    BRA L4CD4
    ORA ($00,X)
    CMP $1A3FBD
    SBC $83
    PLD
    ORA $FBBB1F
    PLP
    CPY #$8181
    BVS L4C90
    INC $D435,X
    JMP $B966,X
    ORA $4A0450
    ORA $01D3,X
    EOR $3EEE,Y
    LDY #$6F94
L4D15:
    STA ($9F,S),Y
    ADC $3E6F,X
    DEX
    AND [$0000]
    ASL $F6
    AND ($33,S),Y
    LDA $01B9,Y
    ORA ($F8),Y
    DEC $960B,X
    XCE
    AND ($70)
    INX
    CPX $F2DA
    CMP ($98,S),Y
    CMP ($47,S),Y
    SBC $CB83,Y
    CMP [$0000]
    TRB $89D8
    TSA
    BRK $B5
    AND $1EFF13
    BEQ L4D94
    EOR ($C6)
    TSA
    LDA $2ECEE0
    TSB $F797
    SBC $0117,Y
    ROR $BF,X
    LDA $0F0F
    XCE
    BRL $EC97
    ROR $0D,X
    BRK $E6
    DEA
    CPY $9FC9
    SED
    EOR [$0000]
    RTS
    AND $BA
    ORA $03F3F3
    BRK $3F
    JSL $6D74A3
    BPL L4D15
    CMP [$0000]
    CMP $C3,S
    STA ($C1,X)
    ORA [$0000]
    CLD
    TAS
    CMP [$0000]
    ORA [$0000]
    SBC $9837
    BIT $01,X
    ADC $4747,X
    TYX
    DEC $58,X
    TSB $00D7
    STA ($0C,X)
    SEP #$FE
    CLV
    SBC $9E
    STX $8E,Y
    ADC $FF89CC
    TSB $1303
    ORA $4AAC,X
    ORA $DC19FF
    JMP $004C
    WAI
    CMP [$0000]
    JMP $3CD8
L4DB1:
    TXS
    BRA L4DB1
    BRK $F9
    EOR $3E3760
    ADC $4A
    CPY $00
    SBC $3E
    TSB $3D9C
    TYX
    STA $BAF387
    LDX $00CB,Y
    EOR $2DFC9B
    BCS L4E35
    EOR $FD9B0F
    CLD
    STX $3E,Y
    LSR A
    STZ $C0E5
    TDC
    TDC
    ROL $01,X
    CPX $2DBE
    LDA [$0000]
    ADC ($0F)
    SED
    TSB $2DB6
    CMP $F3E5,Y
    EOR [$0000]
    PHD
    STA $CDE7FD
    BRK $97
    EOR [$0000]
    ORA ($77,X)
    ASL $4EDF,X
    LSR $C7E7,X
    TCD
    BRK $7F
    DEC $3EE7
    ADC $7D81C2
    BRK $8C
    CPY #$1F
    TCD
    AND $08
    TRB $00C7
    SBC $72F00E
    LSR $6889
    JSR $F303,X
    SBC [$0000]
    SBC $9CDF1F
    BIT $0003,X
    ORA $1F00F3
    ORA $3F,S
    EOR #$80
    XCE
    ORA [$0000]
    SBC [$0000]
L4E35:
    AND $D93AFF
    ORA ($05,X)
    ORA [$0000]
    ORA [$0000]
    ORA $401E29
    EOR #$F8
    STA ($F8),Y
    CMP ($68,X)
    SED
    PLP
    MVP $7840,$92
    JSR $F77F,X
    BRA L4DF3
    CPX #$E0
    PER $4E9B
    BRA L4E5B
L4E5B:
    LDY $E0,X
    BRA L4E5E
    ORA #$F6
    SBC $E650E5
    AND $A4C7C0
    LSR $3B43,X
    CPY #$00
    ROR $898C
    CPY #$91
    INX
    CMP $6D,X
    STA $6E1225
    LDA $A912F0
    ORA $125A
    SBC [$0000]
    PHX
    AND $81
    ORA $38F6A4
    ADC $F949,X
    INC $1CFE,X
    EOR $5C,S
    PLD
    BRK $42
    AND $360E
    AND $54
    ADC $65F227
    ORA $D03413
    COP $EB
    STY $901F
    PHP
    ADC $2821FF
    SBC #$28
    BEQ L4ECC
    JSR $037F,X
    JML $1B8094
    PHB
    PHA
    ORA #$41
    MVP $1063,$01
    BRA L4ECC
    AND $D13E1A
    SBC $321630
    LDA $17084C
L4ECD:
    ORA $E1
    RTS
    JSR $1C00,X
    JSR $671E,X
    PLX
    BRK $1E
    BPL L4EC3
    ORA $17
    ASL $0344
    ASL $94
    BPL L4EDF
    ORA ($D2,S),Y
    ORA $99008B
    BEQ L4ECD
    INC $F0FF,X
    LDA ($FD)
    STZ $A1
    ADC $CBF8
    STA $EFE6EF
    CMP $D1A5CF
    STA $B9,S
    JSR $4BFD,X
    ORA $F07B
    SBC [$0000]
    XCE
    EOR $CFC0B7
    CPY #$80
    LDA $675A06
    EOR ($FA,S),Y
    WDM $52
    EOR ($B5,X)
    CPX $3C3F
    LDA $9E9A9F
    ADC ($ED,X)
    ADC ($73,S),Y
    SBC $8A3B,X
    CPX $96
    ORA ($61,S),Y
    BRK $73
    AND ($FF,X)
    SBC [$0000]
    SBC $9ED0F9
    PHK
    CMP $F0CF,Y
    SBC ($84,S),Y
    JSR $E799,X
    CMP ($F6),Y
    ASL $DC,X
    JSR $F288,X
    STA $551EBC
    CPX #$A7
    AND $CAC2,X
    SBC [$0000]
    AND [$0000]
    ADC #$1D
    ADC $C2,S
    BRK $FF
    REP #$FF
    STA ($F3,X)
    CMP $828044
    ROL A
    STX $01DA
    LDA $AB,X
    CMP $782834
    TAY
    ORA $BF3F
L4F6E:
    ADC $A0C189
    STA $CC,S
    ORA $1F7F07
    PHP
    CPX $0B
    SEI
    ORA $B650
    BNE L4FCB
    EOR $E0C1
    SBC $B1,S
    PHD
    SED
    SED
    BRA L4F83
    LDY #$E0F8
    CLD
    XCE
    SBC $39D6
    STA ($42,S),Y
    SBC ($0D)
    SBC $AD6E
    JML [$5F3FA9]
    ORA $8BDD
    AND $3D7F0C
    SBC $FF34EC
    DEA
    STZ $5F17,X
    LDA $5C6F25
    INC $634F
    CMP [$0000]
    LDX $A5,Y
    STA $FF5FFF
    STA ($AF,X)
    LDA $265B,Y
    ROR $A0,X
    PER $C125
    SBC [$0000]
    CPY #$DEFF
L4FCB:
    CMP ($DD,X)
    CMP $DB,S
    STA [$0000]
    ORA [$0000]
    ADC [$0000]
    LSR $7D01
    PLP
    PEI ($E1)
    BRA L4FC0
    SBC $81E780
    CMP $018F03
    ORA [$0000]
    ORA ($83,X)
    BVS L4F6E
    SBC $B5318B
    STA $3DC4
    CMP [$0000]
    JSR $4141,X
    ROR $FD1C,X
    AND ($3C,X)
    JSR $8CA9
    ADC #$0000
