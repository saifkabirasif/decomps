;
; Uncharted Waters (USA) - bank05_test
;
; Lifted byte for byte from the original cartridge
; (bank $00, $5000-$5FFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $5000

    ROL $4B1E
    AND ($B6)
    EOR $EAFC2E
    CMP ($2B)
    PHY
    ORA ($60,X)
    STY $DC07
    TSA
    RTL
    ROL $8BB6,X
    AND [$0000]
    ROL $5DC8,X
    LSR A
    LDA $B1B1BF
    BRK $CE
    AND $A2,S
    JSL $5D612E
    TRB $DF31
    LDA $F136
    TRB $AE
    ORA ($F5,X)
    LDA $0F,S
    BMI L4FBC
    ROR $6D91,X
    STA $9909,X
    STA $6F0FAF
    SED
    ORA ($73,S),Y
L5043:
    ORA ($FD,X)
    TSB $06
    ADC $40D8,Y
    STA ($9F),Y
    CMP $51,X
    BVC L50CF
    ORA $D3
    STA $28
    PEA $B2BA
    CMP $0BDFBC
    PLD
    CPY #$17D4
    ORA $62,X
    DEC $80,X
    XBA
    ADC $6B2A,X
    EOR ($3D)
    AND [$0000]
    EOR $470E8D
    EOR [$0000]
    TRB $381C
    LDA $A3A0,Y
    CLC
    PLP
    BPL L509D
    CMP [$0000]
    ROR $5720,X
    STY $0CC5
    AND ($21,X)
    BRK $B7
    LSR $0BB0,X
    BRK $A1
    ROR $8B,X
    BCS L5043
    BRK $8A
    EOR $684CDF
    CMP $9F970F
    BCS L510B
    LSR $29,X
    LDA [$0000]
    JSR $01E6,X
    ADC $EBA775
    STZ $0F
    BRK $A7
    ORA $63ABFA
    SBC $F75C,X
    INA
    SEC
    NOP
    PLA
    EOR $60
    STZ $DE,X
    LDX $43
    CLV
    CLV
    STX $3B
    LDY $BDC3,X
    ROL $AF72,X
    ADC ($BC),Y
    BMI L5058
    ROR $0459
    CPX $1D
L50CF:
    STA $B708,X
    LSR $C070
    BPL L50DF
    INA
    CLD
    XCE
    ORA ($D5,S),Y
    AND ($50,X)
    ORA ($36,X)
    BMI L5111
    PER $7EE6
    BIT $D40C,X
    PHD
    CMP $28D356
    LDA ($00),Y
    INC $0423,X
    EOR $56F3,Y
    EOR $0E
    ADC ($44,X)
    BCS L50EE
    SBC ($A8,S),Y
    ORA ($03,X)
    CMP ($58,X)
    ORA $B1,S
    SBC ($51)
L5105:
    LDA ($41,S),Y
    CPX $0B
    ORA ($15,S),Y
L510B:
    STA ($B1)
    LDA ($81),Y
    STY $FA1D
    ADC $EC,X
    ORA $7B,S
    BIT $DB2E,X
    STA [$0000]
    STA $C4769F
    LSR $3B,X
    SBC $87,X
    ORA ($8F,X)
    ORA $80,S
    AND $DF
    PLB
    EOR $87
    PHD
    EOR $1C,S
    PHP
    STY $B0
    BNE L50B7
    CMP ($E0,X)
    CMP $FF,S
    STX $E3
    MVN $DBC3,$81
    ORA $1A
    BRA L5105
    SBC $C0E8E0
    BEQ L5128
    CPY #$3655
    AND $09,S
    BIT $7049
    AND $7F,X
    PHP
    SBC $2DDB38
    PLY
    COP $4B
L515A:
    AND $F8
    PHP
    BRK $38
    BRK $C3
    CPY $A0E7
    CMP $513A60
    ORA ($F1,X)
    AND #$F8C8
    STZ $D75A
    SBC $14,S
    JML $FCB094
    LDA $CC
    RTS
    ADC $3F16CF
    DEC $3A,X
    STZ $84,X
    STA $E0C0
    SBC $EBC75B
    CMP [$0000]
    LDA ($BA,X)
    ADC $0E
    EOR $7F,X
    BIT $78,X
    EOR $83035F
    ORA ($FF,S),Y
    PHD
    ORA ($9B,S),Y
    STX $99
    ORA #$6D0A
    SBC $0013
    STA $06460B
    AND $0AE6
    BRK $D8
    CLD
    BMI L5189
    AND $17CFD0
    INX
    SBC $2441A0
    MVN $A169,$D0
    ROL $3E,X
    INX
    LDY #$9046
    BRA L5228
    BRK $0F
    EOR $C0E7CE
    BRA L515A
    AND $AA,X
    LDA ($D5),Y
    STA $8D9E,X
    CMP $4F,X
    BRK $A7
    SBC $0CA625
    BNE L51F5
    EOR $433641
    LDA ($2D)
    TAS
    CPY #$2FC2
    CLV
    SBC $8E8E1A
    PLY
    ORA $2086,X
    RTI
    AND $D2,S
    ORA $801D
    SBC $CB0C,Y
    RTL
    EOR [$0000]
    SED
    ORA $09F8,Y
    TAS
    LDY $0035
    INC $BF,X
    CMP [$0000]
    COP $2C
    TAX
    CMP ($25,X)
    LDA [$0000]
    PHY
    ORA $F4
    ORA $5A,X
    LDY $A0D6,X
    PEA $4400
    ASL $B4,X
    BCS L523F
    CPX #$6043
    SBC $A0AD,Y
    CPY #$EB67
    REP #$0F
    ORA [$0000]
    TCD
    EOR [$0000]
    LSR A
    SED
    CMP ($E8,X)
L5232:
    LDA ($08),Y
    STX $13C4
    PHP
    TRB $E8F2
    STA ($E1,X)
    LDY $75
L523F:
    PEA $009C
    TSB $1E
    TCD
    LDX $E7
    INC $AC
    LSR A
    LDA [$0000]
    STZ $F3,X
    TRB $B8
    ROL A
    EOR $88,S
    ASL $3C85,X
    TYX
    JML $65CAF1
    SBC [$0000]
    CLI
    BIT $8645,X
    SBC ($80),Y
    ADC $86,S
    LDA $02,X
    STA ($9E,X)
    ADC $C09133
    SED
    INC $FE90,X
    TRB $FEF0
    SEC
    INC $0778,X
    WAI
    ASL $3802,X
    LDA $02
    ADC [$0000]
    TSB $D396
    ORA $43
    SBC $000CF7
    JSR $0C08,X
    STZ $19,X
    STA [$0000]
    ADC $F804
    BMI L52E9
    TXY
    SBC ($7A),Y
    BPL L5232
    CMP ($5C),Y
    LDX $FC80
    STA $4E97,Y
    STA [$0000]
    ADC ($9C,X)
    BRK $C3
    STY $EC,X
    SBC #$7D3F
    ADC $02E2D7
    ORA $793B7B
    TSA
    AND $640104
    LDA [$0000]
    PLA
    STY $52
    ADC #$B2CF
    ORA $74D3,X
    BRK $5F
    PLB
    CMP $D3C4,Y
    DEC $29,X
    STY $BA
    ORA $08,X
    ASL A
    SBC $F806,Y
    EOR $FF,S
    AND ($FF),Y
    AND $DF81,Y
    JSR $10E1,X
    CMP $902F
    SED
    EOR $03
    AND $68DF6E
L52E9:
    INX
    ORA $EE78,X
    BCC L52F3
    ORA #$8413
    LDA $585B
    SBC [$0000]
    RTS
    BIT $B41A
    PHX
    PHP
    ASL $32
    ORA ($17,X)
    ROL $7757
    STZ $AF,X
    ORA ($1A),Y
    ADC $A3,X
    PHP
    LDA ($BD)
    SBC ($2E,S),Y
    AND #$F868
    CMP ($40)
    CMP ($DD,X)
    SBC ($84),Y
    DEC $FE,X
    STA [$0000]
    BRK $68
    ADC $0E,X
    BIT $6A06,X
    INC $54F1,X
    STA ($E7,X)
    STA $A0,S
    CPX $8B
    XCE
    BIT #$D7AC
    XBA
L5331:
    EOR ($D0),Y
    BEQ L5331
    SED
    TSB $55
    ORA ($FB,X)
    LDX $9B82,Y
    CMP $2F91
    SBC $71,S
    ADC ($55),Y
    BIT $C2A8,X
    CMP ($FD)
    ORA $1F
    COP $2F
    CLD
    PLP
    BCS L52E9
    BRK $FA
    JML $5B977C
    PHA
    LDA [$0000]
    SBC [$0000]
    AND $E84208
    SBC ($38,X)
    JMP $FF18,X
    ROR $16FF
    ROL $2D09,X
    NOP
    COP $BE
    AND [$0000]
    INC $BC
    STA $32D7,X
    RTI
    SED
    JML [$83F891]
    STA ($6F,X)
    AND #$2BD0
    EOR $7F63
    ROL A
    BPL L53E3
    SBC ($00,X)
    CLV
    STA ($86,X)
    BRK $C7
    LDA $02E9
    STZ $18,X
    STX $A425
    CLD
    LDY $7C63
    CPY $37
    DEC $26
    TAS
    JML $727451
    TDC
    ORA $7C
    BRK $60
    ROR A
    SBC $1B,S
    ROR $7D
    ORA ($2D)
    MVP $91F2,$04
    AND $732A
    STY $34,X
    ROL $2A,X
    STA $E0FA,X
    ORA $BE35BF
    STA ($EC,X)
    EOR $276899
    TSA
    LDA $50
    BRK $89
    ADC ($B2,S),Y
    LDA ($14,X)
    SBC #$4D5F
    EOR $0E9E
    ROL A
    INY
    AND $44AA
    SBC $25
    BPL L537C
    STY $F1BA
    AND $3BAA7C
    SBC #$C957
    SBC ($C9,X)
    INY
    SBC $2948ED
    AND ($15,X)
    SED
    BIT #$3BE0
    DEX
    ORA $87,S
    XBA
    EOR ($A8,S),Y
    STA $D560
    EOR $D708
    LDA [$0000]
    PHD
    ADC $470D84
    SEI
    CPY #$0027
    ADC $1C,S
    TSB $FA
L5410:
    CMP $8D0F,Y
    LDA $7712,Y
    BPL L5421
    BVC L5410
    EOR $E5,S
    AND ($7F,X)
    CLI
    SBC $D9,X
L5421:
    SBC ($4F)
    LDA $F0E5D9
    PHD
    TAS
    TDC
    BRK $F9
    BRA L540F
    CPY #$E381
    ORA $B75B,X
    ORA $9D0260
L5438:
    LDA ($58),Y
    PHD
    PLY
    ADC $03,S
    ORA $FA1F,X
    INX
    BIT $EB,X
    ORA [$0000]
    STA [$0000]
    ORA [$0000]
    INX
    BIT #$0507
    ORA ($B9,X)
    JMP $9F4D,X
    DEX
    BNE L5438
    SBC $FC4E,X
    LSR $DF,X
    LSR A
    AND $819480
L5460:
    STA ($38,X)
    AND ($E1,S),Y
    ROR $F420,X
    MVP $FFBD,$20
    EOR $7D,S
    BVS L54D3
    CPY #$8C60
    CMP [$0000]
    ROR A
    STZ $18,X
    AND [$0000]
    PLX
    AND $3F,S
    BNE L5460
    PER $7CF9
    STY $D6,X
    STP
    JSL $F8BE2D
    LDX $736C
    AND $750146
    BIT #$DCB4
    LDA $331C,X
    ADC $C2,S
    ROL $9B7F
    CLD
    BRL $2D16
    ADC ($DF,S),Y
    ROR $7A41
    TCD
L54A4:
    PLY
    ROR $45
    TSB $55
    CPY $8A
    ASL $3305
    CPX $0415
    EOR $F6
    ASL $D048
    ORA ($8F,X)
    LDX $DFA6
    BMI L5516
    CMP $DDD52F
    COP $F8
    ROL A
    EOR $FA
    AND ($6D,X)
    SBC [$0000]
    BIT $19
    AND [$0000]
    PEA $ECBF
    ORA [$0000]
L54D3:
    CMP $2F01,Y
    CPX #$180E
    ADC $44F144
    JMP $7540
    NOP
    SBC $C51975
    ASL $65
    ASL $EA
    CMP $20,S
    ADC $8C,X
    ORA $8A71DF
    EOR $F139,X
    ADC $C7034A
    ORA $87,S
    ADC [$0000]
    EOR ($28),Y
    ADC ($72),Y
    CLC
    DEY
    PLX
    LDY #$FC80
    BNE L5558
    JSR $FF1C,X
    COP $81
    TXS
    SBC [$0000]
    SBC $2CA350
    STX $FA
L5516:
    RTI
    BRK $A8
    CPX #$5000
    BVC L54A4
    STP
    TXY
    CLC
    SEI
    AND $CC57,Y
    AND $46,S
    TSB $33
    PHK
    AND $4C,X
    ROR $74,X
    SBC ($85,X)
    SBC $EF7CAC
    DEA
    TSB $3C
    XCE
    EOR $9BF8,X
    BRA L5597
    CMP ($1D)
    EOR $7DBB49
    TSB $8868
    ROR $EB89
    TAX
    LDY $8B
    CMP ($41,X)
    AND [$0000]
    ORA #$224A
    SBC $B6E693
    LDA $DB0926
    XCE
    INC $05
    AND ($04,S),Y
    ORA $EF
    SBC $CD,X
    PHX
    DEX
    ORA $2B03DE
    SEI
    AND $51,S
    BRK $EE
    PLX
    TXA
    JML [$F2E3E4]
    BVC L55C4
    ROR $5F,X
    PEI ($D5)
    SBC #$E70B
    SBC ($F1),Y
    SBC ($E1),Y
    SBC $A2
    TSX
    SBC $A7FDFE
    RTI
    ORA $EEC989
    SBC [$0000]
    SBC [$0000]
    CMP [$0000]
    CMP ($7F,S),Y
    SEC
L5597:
    ADC ($87,X)
    ADC $00AF1C
    SBC $ABD867
L55A1:
    PEA $5B2D
    RTI
    SBC ($62)
    AND [$0000]
    ASL $FF,X
    SBC $03C7DB
    JMP $7ABF
    BIT $E7
    BVS L5611
    BMI L55A1
    SBC $B2AD8B
    SBC $E1,X
    JSL $DFF77A
    ORA $5F,S
L55C4:
    ROR $89D1,X
    LDA [$0000]
    CMP $79
    JMP $C0F4,X
    SBC ($81,X)
    CPY #$6721
    LDA $3A8C,X
    TYX
    LDX $8A
    INC $4B
    ASL $0049,X
    BRA L55A1
    LDX $E487
    SBC $59,S
    SBC $FADC,X
    SBC [$0000]
    TXS
    DEC $42D0
    STA $09,X
    TSB $61
    LDX $A8
    AND [$0000]
    WDM $09
    COP $51
    EOR $2709,X
    BNE L565A
    SBC $64,X
    SEI
    ADC #$1EB1
    AND $B945,Y
    TSX
    CMP $74,X
    SBC $FFFFF5
    AND $1800F5
    STA $B12F83
    LDA $7497,X
    BRK $89
    ORA $A1A705
    LSR $AC
    PEA $4CCF
    BVC L5653
    PEA $E87C
    AND $CB,X
    ADC ($E0,S),Y
    BRK $3F
    AND $EB,X
    LDX $8566
    CMP $6D,X
    LDY $D438
    CMP $A5FC
    EOR [$0000]
    BRA L55F5
    LDA $13,S
    ROR $53B3,X
    STZ $F1AE
    ADC $9CA56D
    LDX $037B,Y
    ADC $E8ED4D
    DEC $16D4,X
    ADC ($7F),Y
    BIT #$C9EF
    ADC $3EFE,X
    ROR $18F7,X
    TCD
    ADC $2CBF1E
    ADC $047C8C
    NOP
    ORA #$CCB1
    INC $82,X
    EOR $AF0B,Y
    AND $3410,X
    JSR $301D,X
    TRB $545F
    ORA $1CDF,X
    BEQ L5692
    PHK
    COP $B8
    WAI
    JMP $4EB0,X
    ADC $FC7FFE
    ADC $FB970A
    BIT $60
    TRB $18
    ADC $82EC20
    AND $F0,S
    TAY
    JSR $4781,X
    CMP $32A7F5
    TSB $9C
    EOR $64038B
    SBC ($7B,S),Y
    LSR $E3E7
    AND ($D7,S),Y
    CMP ($70),Y
    CMP ($CA,X)
L56B4:
    BRK $E7
    BRK $B0
    AND $77909B
    DEY
    EOR $40
    BRK $C2
    ADC [$0000]
    SBC #$3EE2
    BIT $BC
    ROR $BF,X
L56CA:
    ADC $C9A079
    BMI L567C
    BVS L56E5
    SEI
    EOR $F91FE0
    LDA $C7FEFD
    ORA ($00,X)
    BVC L56B4
    CMP $A024,X
    CLV
    TYX
    EOR #$715F
    PLB
L56E8:
    ADC ($16),Y
    LDA $EF76,X
    ORA $79AFBB
    CMP ($16),Y
    LDA $7A,S
    WAI
    CPY #$C0CE
    DEC $F00F,X
    AND [$0000]
    WDM $F5
    LDA #$D61D
    STA ($81,X)
    ORA $73,S
    TSB $C1
    RTS
    CMP #$4D4B
    BIT #$B282
    STA $39378B
    LDX $F5,Y
    LDY $E611
    ADC ($3F,X)
    AND $9AB9,Y
    INC $8D45,X
    ROR $9A06,X
    JSL $4F8368
    ADC $AFB6,X
    TDC
    JML $BD0387
    TRB $24
    STP
    LDA $23,X
    AND ($F7),Y
    SBC $7B
    EOR [$0000]
    EOR $6CE9FD
    BCS L56E8
    BRA L56CA
    SBC $FE8D,X
    CPX #$10F2
    BRK $86
    STA $3506A7
    CMP ($F0),Y
    INC $6197,X
    XBA
    EOR $0E
    LDA ($66),Y
    LDA $4884,X
    BIT $2FE0,X
    BIT $00BE,X
    PLP
    STA ($09),Y
    ADC ($CE)
    TYA
    ROL $8880
    CPX #$F867
    ROL $2054
    EOR ($AE),Y
    CMP $0C03C2
    STZ $FBE1
    JML $3FFE18
    ROL $F718
    CPX #$B903
    ORA $B63A2C
    LDA $E2CB,X
    CMP $FD
    AND $FC3F09
    CMP [$0000]
    JSR $B3A2,X
    INC $178B,X
    BRK $39
    ORA $91406C
    INY
    LDA $0FFCFC
    SED
    SBC $FEF259
    COP $FD
    ORA ($C1,X)
    PLX
    AND $29,S
    EOR $FE84,Y
    ORA $1C903F
    CMP #$737C
    EOR $58A7A0
    SBC ($57,S),Y
    TAY
    LDA ($5E,X)
    TAY
    STA $5F8644
    BRK $AF
    LDA [$0000]
    LDA ($A1,X)
    STA $D7,S
    CMP $3C,S
    CMP ($2C,S),Y
    SBC $F90EF1
    ASL $FC
    ORA $CB,S
    BIT $6A,X
    ASL $00E9
    CMP ($69,S),Y
    STA [$0000]
    WAI
    SEC
    CMP $18E7FF
    CMP [$0000]
    STA $7C,S
    STA ($7E,X)
    BVS L57A2
    LSR A
    EOR ($BE,X)
    LDY #$FD0D
    SBC $FF,S
    PHK
    PEA $AF26
    LSR $C7C4
    EOR ($54,X)
    LDA ($2F,S),Y
    XCE
    SBC $103E10
    PHD
    CPX $DA93
    LDY $CB6C,X
    SBC $F9EE,X
    CMP $8FC120
    BVS L587A
    ADC [$0000]
    PLY
    PLX
    JMP $6C6B
    BMI L5883
    LSR $9E
    ORA ($AD,X)
    EOR #$07F8
    SBC ($0D)
    SBC $C5,X
    ASL A
    JSR $76E0
    LDA [$0000]
    XCE
    LDA #$00F2
    TAY
    JSR $B85C
    SED
    STA ($3F)
    TSB $ED9F
    INC $3E
    SBC $99C3,Y
    TSB $E6F3
    SBC $0F78
    BEQ L5844
    PLX
    STA $AC,S
    RTS
    BRK $78
    CPX $FF
    SBC $AA32
    DEX
    STA [$0000]
    RTS
    TXS
    SBC $8F4B01
    TYA
    SBC ($C7)
    ROL $D815
    AND $BF82AB
    ADC $4B5E,X
    PLX
    ORA $F4
    PHD
    TAY
    EOR [$0000]
    RTI
    LDA $4D5582
    PLX
    ROR $37,X
    CPY #$027E
L5883:
    AND $BA,S
    INC $8E68,X
    INX
    STA $FF
    BRL $1E89
    LDY $4F24,X
    INC $3BD5
    AND ($70,X)
    TSB $B0
    TAX
    SBC $3FFF55
    CMP ($94),Y
    EOR $AAAA5F
    ORA $15,X
    AND ($0A,X)
    ROL $CC5F,X
    EOR $A0,X
    TSB $4886
    JSR $5500
    JSR $BFC3
    TAX
    STA $8C28,X
    CMP $AA3098
    LDY $30D9,X
    BRK $37
    JMP $82B0,X
    JMP $12D9,X
    ROL $43A5,X
    CMP [$0000]
    STA $3397
    ORA $FEAB2F
    SED
    DEC $B2FC
    LDA $5FCBEA
    SBC $18,X
    BRK $34
    LSR $580A,X
    INC $BFE2,X
    BPL L5912
    NOP
    STX $E7
    STX $AA97
    COP $84
    SBC ($19,S),Y
    SEP #$B0
    XCE
    ADC $7D0F,Y
    AND $7F60,Y
    EOR $5FD8CE
    ADC $ABFED5
    ASL A
    STA $61273F
    ADC $547D,Y
    AND [$0000]
    LDA $08A3FE
    CMP $42
    STA $8BEA97
    TSB $4C7C
    SED
    STA $567C2C
    LDA $EBA2,X
    STX $38
    AND ($9D)
    JMP $CFE9,X
    PER $509C
    PEI ($7F)
    ORA $29CB,X
    CLC
    SBC $87FB
    PLX
    PLX
    CMP $AA,X
    STA ($FD,X)
    AND $BDD2,X
    LDA $92,S
    PLY
    TYX
    ASL $43,X
    TAS
    LDX $BE80,Y
    ADC $1343FB
    ORA $8DEC
    AND $BD2F8E
    TRB $792D
    BIT $97
    PLD
    PLX
    INC $9D,X
    SBC $5449,Y
    LDY $245C,X
    SBC [$0000]
    PLB
    PLP
    CMP $F5D1EC
    ROR $8445
    LDY #$1B
    ADC ($BA,X)
    AND $FA2F,X
    BRL $5B84
    EOR ($3A,S),Y
    LDA $17,X
    TRB $B60B
    DEY
    TSA
    CPY $0A9E
    ASL A
    ORA ($79,X)
    SBC $3004D8
    TCD
    STA $31,S
    BIT #$AF
    LDA $71F87B
    RTL
    AND $46,X
    ADC $FFDCD6
    EOR [$0000]
    XCE
    PHB
    ADC $FE51,X
    LDX $53A8
    BVC L59CF
    PLP
    TSB $7C
    DEC $AC24,X
    PHY
    SBC $AE1D,Y
    ORA ($DD),Y
    SBC $6DD7E3
    EOR [$0000]
    ASL $6872
    BIT #$EA
    ROL A
    ADC $719F,X
    SBC $D5CF
    CMP ($7F)
    RTS
    STX $D8,Y
    PLB
    PLB
    STA $0FB7
    TSX
L59CF:
    AND ($88,S),Y
    CLV
    CMP $B700,Y
    LDX $CFA1,Y
    ORA ($8E,X)
    INC $C565
    LDY $01C2,X
    BRA L59EB
    JSL $187226
    BRK $38
    SBC $65
    BIT $7FF7,X
    LDX $BE,Y
    BRK $6C
    BEQ L5A41
    TAY
    CPX $A4
    SBC $F1FD,X
    COP $2F
    ORA [$0000]
    AND $0AD580
    EOR $FA6F,X
    LDA [$0000]
    BIT #$15
    TAX
    STP
    JML $F07CEA
    BIT $9776,X
    EOR #$B4
    CMP $CAFFB5
    LDA ($EF,S),Y
    ORA ($90)
    JSR $009F
    ORA $5E4AFE
    DEC $49FF
    CPY $1B41
    WAI
    MVP $C200,$95
    ROL A
    CMP $08,X
    DEC $5F6A,X
    TXA
    STZ $8022
    EOR $54437E
    ADC $2EA7,Y
    DEC $DB,X
    TYX
L5A41:
    ORA $F0D9,X
    ADC $0B79,Y
    STA ($00,X)
    TSX
    STA [$0000]
    LDA $40979F
    TSX
    ADC $6199,Y
    CMP $9F72F0
    LDY $9002
    AND $EA6C
    STP
    EOR $36CA3F
    STA ($3B,S),Y
    TXA
    ASL $B9
    ASL $B8
    ADC $4C00
    ORA ($06)
    PEA $58DE
    STA $52,X
    LDA $2FCA,Y
    CMP ($AC,X)
    JMP $EA00,X
    ADC $FC
    ORA $1460,X
    STZ $5D
    EOR $F7C2AA
    STA $8FE820
    SBC $763A86
    EOR $44
    ORA $06,X
    LDX $36
    ORA $BA49,X
    PEA $8DC7
    TAY
    ORA ($A1,S),Y
    AND $FD,X
    INX
    ORA $AA
    ROL A
    STA $D2,X
    ADC [$0000]
    CMP $50
    SBC $7CE019
    ADC [$0000]
    ADC $01F55C
    ORA ($61),Y
    TAY
    CPY #$A8
    RTI
    STA ($A5,S),Y
    SBC $BA,S
    INC $C4D3,X
    SBC $801595
    ROL A
    ORA ($D1)
    TDC
    LSR $DC,X
    AND $76989B
    ADC [$0000]
    ADC $00317A
    ASL $72,X
    CPY #$56
    TAY
    ORA $E145,X
    PLY
    DEA
    ROR A
    ADC [$0000]
    AND $EADB00
    EOR $7E
    STY $58,X
    STA $21CE30
    INC $F5
    CMP #$70
    TXS
    SEI
    COP $A2
    ADC ($97,S),Y
    CMP [$0000]
    LDY $EDA4,X
    ADC $46,X
    BPL L5AE1
    EOR [$0000]
    ADC $724601
    SBC $5FBC75
    SEP #$DB
    JMP $2FAB
    AND ($FD)
    ADC $F8E8,Y
    PLB
    PHD
    EOR ($70),Y
    TXY
    JSR $17DB,X
    STX $00
    INC $88D7,X
    TDC
    LDA $E8,X
    TSB $F0
    LDA $F038,X
    CMP $DF77
    LDA $B7EBEF
    BRK $87
    ORA ($3B),Y
    PEA $BE21
    ORA ($C8),Y
    LDA $1F,X
    LDA ($89,X)
    RTI
    ADC ($9F),Y
    SED
    ORA ($C1)
    ROR $194A,X
    PLX
    LDX $13
    TAX
    DEC $8FF6
    ORA $EC80
    PHK
    LDY $F0
    SBC ($D0)
    SBC $AF38,X
    PHK
    STZ $281A
    BRK $82
    TAX
    BCC L5B5B
    ORA [$0000]
    AND $00,S
    INC $A833,X
    SBC ($4F,X)
    CPX $AD00
    ORA $F46300
    TSX
    PER $BA82
    JSR $4FE4,X
    TYA
    BRK $12
    INY
    JML $081052
    JML [$7AB3B5]
    EOR $CB31A8
    CMP $7E,X
    STA $F1EA
    ROR A
    BRK $8B
    STA ($50)
    SBC $4EFC,X
    ROR $4E3E,X
    ROL $56
    DEC $9378
    CMP ($FF,X)
    PLP
    SBC $E99554
    ROL $0DC2,X
    SBC $5F,X
    JSL $04FA16
    SBC $6215B0
    TSB $82
    XBA
    CPX $85FB
    SBC $1E24B0
    LDY $7D,X
    CLD
    BIT $10
    ADC $7B62,X
    STA [$0000]
    RTS
    ROL A
    AND $A737,X
    ADC ($37)
    BCC L5BDE
    RTL
    EOR $A966,X
    BIT $9D99
    CMP $0ABF05
    JMP $54F8,X
    SED
L5BDE:
    TAY
    CPX #$40
    JSL $9B76F0
    BIT $B1
    AND $FAF221
    CMP [$0000]
    AND ($A1,S),Y
    BNE L5C50
    LDX $48
    ASL $3D
    LDX $C508,Y
    CMP $8A,S
    TXA
    BVC L5C0D
    JMP $7565
    BRK $4F
    ADC $863B,X
    ORA ($EE),Y
    WDM $04
    INC $1E34,X
L5C0C:
    SEI
L5C0D:
    SEI
    EOR $846B,X
    STZ $E2FD
    DEC $F600,X
    WDM $2E
    ROR $D6C3,X
    SBC [$0000]
    SBC ($56),Y
    LDA ($8F),Y
    STA $EF90,Y
    JSR $B600,X
    INX
    JML [$D89B7D]
    PHD
    CMP $EF,S
    TYX
    ROL $C762
    BEQ L5C0C
    STA [$0000]
    LDY $EB,X
    STA ($53,X)
    ADC $458F
    ADC ($2F,S),Y
    PER $D5D3
    PER $7A4B
    STA ($F2,S),Y
    EOR $AFB7DF
    SEI
    WDM $24
L5C50:
    EOR $CB,S
    LDX $35,Y
    LDA $05,S
    LDA #$D7
    LDX $FE37,Y
    ROL $440D
    INC $F9,X
    ROL $0AE4
    NOP
    CPX #$0A
    EOR $51,X
    ADC $63,S
    INC $F9,X
    ROR A
    LDA ($C7)
    LDA [$0000]
    EOR ($7B),Y
    SBC $A98D,Y
    SBC $B592,Y
    STA ($37)
    EOR $FA,X
    AND $0077,X
    PLX
    PEA $2608
    COP $99
    LDX $42,Y
    SED
    CLC
    STA ($6A,S),Y
    STA ($7A,S),Y
    JSL $AEDC29
    ADC [$0000]
    DEC $817D,X
    TXY
L5C98:
    ORA [$0000]
    EOR ($F3),Y
    LDX #$40
    LDX $76,Y
    BRL $289F
L5CA3:
    WAI
    JSR $CFDA
    PHD
    CMP $F77A,Y
    BRK $7C
    EOR $18BF,X
    LSR $9808
    SBC $40,X
    LDY $052F,X
    JML [$B21817]
    CLD
    LDA $F1
    AND $FA,X
    NOP
    NOP
    EOR $E76C16
    ORA ($F9,X)
    SBC $4B44
    BIT #$D2
    LDA [$0000]
    LSR $8416,X
    ROL $4495
    ORA $BD,X
    INC $F493,X
    LDA $8C,S
    ADC ($15,S),Y
    PHD
    ASL A
    SEP #$8A
    DEC $57AA,X
    ASL $C595
    ORA $BD,X
    PLD
    DEY
    TXY
    ORA ($EA)
    TAX
    CMP $3E,X
    LDX $13
    LSR $31,X
    PLD
    CMP ($BE,X)
    TAX
    BVC L5D4D
    BRA L5CA3
    INC $00
    INC $F6,X
    LDA ($11,S),Y
    TYA
    INC $C234,X
    LSR $41FE,X
    TAX
    STA $D3231D
    PLY
    SBC $00,X
    SBC [$0000]
    BCC L5C98
    BIT $91AD
    PHX
    PLA
    JMP $7C1F
    LDA ($C0,X)
    BRK $FF
    INA
    STZ $FF0E
    PHY
    LDA $51,S
    REP #$3D
    AND [$0000]
    STX $EE,Y
    AND $42
    CMP $00E7,Y
    ROR $DFB8
    SBC [$0000]
    LDA $FBBF,X
    TCD
    TDC
    SBC $290F
    SBC $F6823B
    ADC $AE3700
    INC $1F,X
L5D4D:
    AND $94,S
    SED
    JML [$97FF04]
    CMP [$0000]
    INC $6978
    BRK $42
    LDY $9696,X
    SBC $57C4,X
    ROR $170C
    STA [$0000]
    EOR ($89),Y
    TYX
    STX $7317
    BRK $17
    SBC $1A5E,Y
    ROR $26,X
    SBC ($8D),Y
    LDA $DC
    INX
    SEP #$5F
    STX $F1,Y
    LDA #$FE00
    LDA $9145
    SEP #$B7
    SBC $3EEA
    BRA L5DCF
    PHB
    SED
    CMP $00,X
    LDA [$0000]
    LDY $DE
    SBC $42,X
    ROL $3E,X
    EOR $C5
    STY $97
    ADC ($4E,X)
    SEI
    BVS L5DA7
    LDA $FEE6
    ORA ($F5,X)
    CMP #$13
    SEI
    WAI
L5DA7:
    PLX
    ORA $CA
    CMP $CF,S
    NOP
    ORA $E0,X
    CPY $2F
    PHP
    LDA $A85750
    CMP ($AB,X)
    MVN $5EF3,$6C
    SEC
    CPX #$BC
    STA ($FC,X)
    WDM $1C
    EOR $EBEC00
    ADC $3F,S
    ADC $0BE3,X
    CMP ($F2),Y
    CMP $34,S
    ADC [$0000]
    JSR $9CC4
    BRK $EB
    STX $49
    JSR $8C2F,X
    SBC ($5F,X)
    SBC ($F2,S),Y
    INY
    CMP ($CF)
    ROR $C3A5
    JSR $2AE5,X
    MVP $7C00,$5E
    STA $E6
    CMP $C1D84B
    LDY $EC54,X
    EOR #$5E
    ROL $27
    AND $61FC00
    STA $649F
    BEQ L5E7B
    ADC #$AC
    JMP $E5E1
    TYX
    PLY
    CLI
    AND [$0000]
    JSR $1D53
    ROL $E1
    SBC $0A56,Y
    CMP $5E,X
    CLV
    DEC $FDAF
    COP $17
    LSR $F109
    PLB
    BVS L5E88
    SBC [$0000]
    PHB
    TSB $50
    AND $FD,S
    CPY #$1B
    ROL A
    SBC $D5,S
    ORA $FA
    CMP ($E0),Y
    ADC [$0000]
    PLA
    PHP
    ASL A
    SBC $00,X
    EOR $FC,X
    STA $9D
    ADC $DE6C,X
    CMP $D8C3,Y
    LDX $3BB6,Y
    TCD
    BCS L5EB2
    BRK $F6
    STA $34,S
    PHP
    AND $3221BE
    ROR $B839,X
    ORA $33CD,Y
    LDX $C4F0,Y
    LDA ($F8),Y
    BNE L5E60
L5E60:
    SBC #$21
    BPL L5EE0
    INC $2FF4,X
    ORA $1B97,X
    STA [$0000]
    AND ($31,X)
    SED
    CPY $DF
    ADC $09A5
    BRK $A0
    REP #$72
    STA $72
    ROR $B0CC,X
    AND #$4CBF
    CLI
    INC $BD
    TRB $4C
    SED
    PEI ($22)
L5E88:
    LDA $2874,X
L5E8B:
    PLA
    TAY
    EOR $AD732A
    BEQ L5EEF
    LDY #$F2F3
    BRK $88
    STA ($B8,S),Y
    XCE
    ORA $C7107E
    EOR ($04,S),Y
    DEC $FE,X
    ADC $8F,S
    TYX
    ADC ($D8,X)
    ORA $D92A20
    TSA
    TAY
    ORA ($F3,X)
    ADC [$0000]
L5EB2:
    CLC
    BRL $9DD3
    TAS
    STA [$0000]
    BRK $61
    LDA $821D,X
    STZ $C35F,X
    SBC #$76FE
    ADC $08,X
    LDY $E9BF,X
    BVS L5EDF
    ADC $00E1DD
    STA [$0000]
    SBC ($53,X)
    SBC $2361D5
    BEQ L5E8B
    EOR [$0000]
    PEI ($C7)
    ROR $18,X
L5EDF:
    CMP $9F,S
    STZ $F2
    AND $54
    PLB
    STZ $BDB5,X
    RTS
    BRA L5E9E
    AND $10B09C
    CMP $FF,X
    CMP $0798
    ORA ($40,X)
    SBC $EDF069
    LDA $47445C
    CPY #$FFE0
    BIT $00,X
    AND ($7F,X)
    ADC $57E38C
    BIT $6FB2,X
    ORA ($00,S),Y
    TYA
    CMP $AE
    REP #$C0
    INC $C3F5,X
    TSB $D7FF
    BPL L5ED0
    XCE
    CPX $0D70
    ADC $97E300
    ADC $F0F8
    ROL $3619,X
    ORA ($2F,S),Y
    REP #$20
    SEP #$25
    CLD
    ADC $08
    LDY $584C,X
    EOR $7E5F,Y
    TSX
    LDA $078285
    LDX $C1F9
L5F41:
    ADC $170F94
    STA [$0000]
    LDX #$3F82
    ORA $3F,S
    PHD
    TSB $4F
    CPY $B1
    BVS L5F64
    BPL L5FD0
    AND $F6F01E
    STA $38,S
    CLD
    CMP ($5E,X)
    SED
    PLP
    TRB $04
    CPY #$BE1E
    AND [$0000]
    JSR $ED81,X
    LDX $8708,Y
    ORA $9600,X
    SBC [$0000]
    CPX #$C7D4
    ORA $8729
    ORA [$0000]
    TCD
    ASL $879D
    STA [$0000]
    RTS
    BRK $2F
    ROR $98,X
    TXA
    COP $21
    SBC ($FC,X)
    SBC $1734,Y
    ASL A
    INX
    SBC [$0000]
    CPX #$901E
    INA
    TAS
    SEC
    TRB $04
    EOR $05AF0A
    CMP $53
    BVS L5F41
    BVS L5F98
    SBC $3CEDFA
    LDY $78EB
    EOR ($BD),Y
    RTI
    CMP $50D4,X
    SBC $31BFAA
    ASL $7F
    COP $A1
    AND [$0000]
    ROR A
    ORA $68,S
    ROL $BCF2,X
    SEC
    EOR $78,X
    ADC ($A4),Y
    XBA
    SBC ($E2),Y
    TRB $2F
    SBC $EAFC,X
    SBC $78503A
    TXA
    CMP $02
    BRK $2A
    SEP #$31
    CPX $C3
    ORA $61A5EB
    ROL A
    SBC ($A2),Y
    LDA ($C5,X)
    INC $2AA8,X
    ORA [$0000]
    TXA
L5FE9:
    ASL $EA,X
    CMP [$0000]
    ORA $CC,X
    BVC L5FE9
    ROR $CB07
    TAY
    LDA #$C5
    CPX $7F6A
    EOR [$0000]
    EOR [$0000]
    INC $0000,X
