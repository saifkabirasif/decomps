;
; Uncharted Waters (USA) - bank03_lift
;
; Lifted byte for byte from the original cartridge
; (bank $00, $3000-$3FFF).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $3000

    ADC ($FF)
    BIT #$0B7D
    STA $8AB2
    STZ $F7,X
    ORA $B106,X
    SBC $30E2,X
    REP #$01
    ADC ($26,X)
    ROL $7C
    CMP [$0000]
    STA ($23,X)
    CMP $0368FF
    STY $91
    LDA $F611FE
    SBC $EB9BB9
    STP
    LDA $E9,X
    STY $6E
    STY $B7,X
    ORA $0E,S
    EOR $BD1B13
    STZ $BF
    SEI
    ADC #$00E4
    BNE L3049
    CMP $A6
    EOR ($C9,X)
    SBC $8C,S
    ROR $584A,X
    ROR $FF20,X
L3049:
    AND $FF67
    EOR ($FE,X)
    JSL $FC0767
    TDC
    SBC ($6B)
    JMP $FFBE,X
    TDC
    SBC $606977
    LDA $2F517C
    CMP [$0000]
    INC $1C
    ORA ($FE,X)
    SBC $B1
    LSR $CB07,X
    SBC [$0000]
    SBC $CBF9F2
    TSX
    LDX $F6
    ORA $673D87
    ROL $6300,X
    CPY $FF
    STY $E0,X
    ASL $FD0A,X
    ADC ($DA),Y
    SBC $A10D
    TYX
    TSB $4E
    EOR ($A1,S),Y
    TSA
    STA [$0000]
    XCE
    ADC [$0000]
    TDC
    ORA $7E,X
    ROR $EE,X
    LDA ($00,S),Y
    AND $36FE1D
    WDM $DB
    COP $F7
    SBC $11,S
    INY
    ADC $06DBF6
    ORA $4C5EA7
    CLC
    REP #$0A
    STA [$0000]
    PHX
    SBC ($10,X)
    ASL A
    ADC $20F0F0
    EOR ($51),Y
    LDX $17
    STA ($22)
    STA ($FE),Y
    EOR $16,X
    LSR $BC3F
    DEY
    SEI
    EOR [$0000]
    JSR $300C
    TRB $0860
    XCE
    LDA $F6AA,X
    ADC ($FD),Y
    SBC [$0000]
    BMI L3117
    INC $80,X
    EOR $566038
    TDC
    ADC $58,X
    ORA $0619FC
    CMP $7C,S
    CMP $F8,S
    RTS
    CMP $8B,X
    AND ($0D)
    CMP $340A8F
    CPX $3DE2
    CMP $A0,S
    SBC $A855E9
    TAX
    EOR $A8,X
    BRA L3114
    BIT $D6AE,X
    PLD
    EOR [$0000]
    SBC $F163,Y
    SBC [$0000]
    ORA $00D9FA
    PHP
    BRK $FD
    RTS
    LDA $7F53,X
    CMP $98,X
    LDA $E5BF46
    SBC [$0000]
    PLA
    SEC
    WAI
    TAS
    CPX #$5DF2
    BRK $38
    PHK
    STA $7D1B
    LDA $95008C
    SBC ($86)
    LDA $EB1C,Y
    ADC ($62),Y
    PLD
    LSR $CC,X
    AND $39FE,Y
    BRK $3F
    AND #$0342
    INC $1FF9,X
    AND [$0000]
    CPX $0C
    CMP ($ED),Y
    XCE
    BRK $77
    LSR $D2,X
    CMP $7FFA
    AND $271BFB
    LDA [$0000]
    TXA
    EOR #$1E17
    ORA $7F,S
    WAI
    XCE
    PHY
    ROR $54,X
    BIT $C6,X
    CPX #$1CEF
    BRA L31CC
    DEA
    TDC
    MVN $C985,$51
    MVN $8AA8,$15
    ORA $EC,S
    SBC [$0000]
    PHD
    ORA $FD26,Y
    ADC [$0000]
    JMP $0120
    ROL A
    INY
    ADC [$0000]
    ORA $7E05,X
    ROR $40,X
    STY $CA4A
    BPL L3142
    ADC ($A7,X)
    LDA $739573
    PLP
    RTL
    ADC $DB,S
    PLD
    AND [$0000]
    SBC $5DDBE5
    SBC [$0000]
    PLD
    AND [$0000]
    INC $DF0F
    RTS
    JMP $6BBF
    STA $45DDEE
    ADC $11FD
    ORA ($A8)
    BIT $50
    RTS
    TSB $90EC
    RTI
    LDX $5E97,Y
    EOR $B0679B
    AND $354400
    CMP [$0000]
L31CC:
    CPY $86
    CLI
    WAI
    ADC $24,X
    STA $11DD,X
    SBC $CDDE96
    STY $7FB8
    ORA $90
    SBC $29BE69
    ROL A
    BRK $BF
    AND $1FC2,X
    AND $D9D8DB
    INC $E474,X
    AND [$0000]
    BMI L317A
    ADC $1A97FC
    STA [$0000]
    CMP $4B,S
    XBA
    LDA $80
    ORA ($61),Y
    EOR [$0000]
    AND $2F07CD
    STA ($2F)
    BIT #$E4E0
    ADC $C63851
    ORA [$0000]
    SEC
    ORA $80
    ROR A
    EOR $B39988
    AND ($2C)
    CPY #$DA0A
    PLA
    ORA $A1DC,X
    ADC ($1A),Y
    STZ $609F,X
    BIT $17
    LDX $40E4,Y
    ORA ($BE,X)
    BVS L31D4
    CLC
    STZ $60
    SBC [$0000]
    EOR $523BFE
    CLD
    CMP $818914
    ROR $7E93,X
    CMP ($09,X)
    CMP $076B2D
    AND #$7E01
    ASL $B1B4
    AND ($61)
    ADC [$0000]
    ASL $F8F0
    RTI
    ORA ($FD)
    BVS L3259
L3259:
    STZ $1E60
    CPX #$1F00
    EOR $BC
    SBC $FCE8,X
    BRL $428F
    STZ $18
    PLA
    SBC $6010
    CLC
    BRL $9AA8
    TRB $45
    RTI
    ORA $077FAC
    LDX $03F1,Y
    ADC $531EDD
    SED
    SBC [$0000]
    BRK $1E
    AND $AE90D8
    PHD
    SBC [$0000]
    SBC ($8B,X)
    LDA [$0000]
    LDA $13DD,Y
    STY $FE,X
    SEI
    BRK $1E
    ADC $8439,X
    ORA ($1F),Y
    SED
    SBC $6B97
    MVP $EBFB,$10
    PHB
    SBC $62356A
    ADC [$0000]
    ORA ($14),Y
    LDA ($7F),Y
    CMP $75,X
    LDA $90F8
    XBA
    SBC $65D700
    STA $17D8
    BNE L327A
    LDA $5610
    LSR $FA5E,X
    LDX $30,Y
    EOR $9900,Y
    TAS
    ORA $FA371D
    ADC $09,X
    AND $2B7E,Y
    ROR $D212,X
    CLV
L32D7:
    PHX
    BRK $F2
    REP #$5C
    ADC $4617
    CLC
    JML [$235F71]
    LDY $871F
    SBC [$0000]
    INY
    ADC $386A00
    LDX $C20F
    BRK $9F
    ADC $EFBE8E
    CMP $F2F057
    CMP $B371C4
    TRB $38
    LDX #$4122
    STA $694B
    INC $C2DD,X
    PHP
    EOR ($FF),Y
    EOR ($A0,X)
    TAY
    RTI
    ORA $22
    BRA L3356
    ADC $DF92
    JSR $8244
    STA $DF4101
    INA
    LDX #$0F01
    TAS
    BIT $43,X
    SBC ($7E)
    INX
    STX $79
    TSB $7FBF
    ROR $FEBF,X
    INC $8D0C,X
    BVS L32D7
    JSR $FF47,X
    CMP $708CE9
    STZ $6081,X
    CMP $A7,X
    ASL A
    DEX
    XCE
    CMP ($1E,S),Y
    SBC $278A,X
    CMP $F95463
    PLD
    ROR A
    ORA $3D,X
    COP $6A
    TSB $94
L3356:
    ORA $240620
    ORA ($12),Y
    PHD
    EOR $7E
    AND $40F7,X
    CLV
    LDX #$C151
    JSR $B903,X
    STA $27
    ADC $416ED9
    PHA
    EOR $19,S
    TSA
    PLB
    CMP #$2AAF
    TSB $87
    SED
    ADC [$0000]
    ORA $FC,X
    DEY
    BRA L33F9
    SBC $4202,X
    ROR $99
    AND ($FC,S),Y
    AND $78BD,X
    PHP
    PHK
    AND [$0000]
    EOR $82,X
    LDA $E3448A
    ROL A
    JSL $0344DC
    AND ($29)
    ORA ($40)
    WAI
    INC $9F33,X
    LDX $3747,Y
    XCE
    SBC $4F20EC
    JSR $D9D8
    LDA $47
    TAY
    BVC L33F7
    DEY
    TSB $DA
    SBC [$0000]
    STA $7C26,Y
    WDM $59
    LDX $D556,Y
    RTI
    TSB $93
    ORA $E1,S
    EOR $02,S
    ROR $88A8,X
    SBC ($9B)
    ORA ($BA)
    SBC $9F
    BIT $4B
    ASL A
    MVP $F0FF,$E1
    TXY
    COP $1F
    INC $C437
    PER $F3C0
    INC $EC,X
    EOR ($57,S),Y
    AND $B504
    SBC $00D92A
    ADC $B6E1
    EOR $3FF184
    LDA $F2AE,X
    STA $D1604F
    LDA $0B224A
    SBC $54F4B6
    SEC
    BVC L340B
    WAI
    ORA ($FE),Y
    EOR ($A8)
    COP $82
    CPY $04
    INC $0416,X
    ORA $28
    STP
    JML [$01F9EC]
    LDX $8BD4,Y
    ORA $FAE3,Y
    ASL $23
    CMP $17,X
    INC $8FFC,X
    TAY
    TAY
    WDM $18
    DEX
    ROL A
    PHB
    EOR $6F,S
    SBC ($1F)
    SBC $ED38,X
    LDA [$0000]
    JSR $54BF
    STA $48FD,X
    NOP
    BVC L33E4
    BRL $8944
    ROL A
    TSX
L3441:
    LDX #$205E
    TAX
    JSL $FD0214
    LDA $23,S
    SBC $B68CD7
    DEY
    CMP ($70)
    LSR $A27C
    TAX
    TAS
    ORA $041A0F
    SBC [$0000]
    LSR $A8,X
    JMP $3EE7
    CPY #$FF5D
    TXS
    CLV
    SBC [$0000]
    CPY #$E014
    RTI
    ORA $78CFAA
    ORA $92BE
    SED
L3475:
    RTI
    CPX #$F420
    AND $3EE8D8
    AND #$0D72
    ROL $09,X
    PLY
    ORA $60
    BCC L3475
    ROL $C001,X
    ASL $A0,X
    ADC ($FD,X)
    ADC $F7E5E8
    RTI
    AND $2A7C80
    CPY #$FC25
    REP #$6A
    STA $A5
    PHY
    EOR $A94D56
    CMP $8E3804
    DEY
    ORA $D270ED
    PLX
    JSR $7E8E,X
    LDA [$0000]
    CLC
    STA $B9E2,X
    ROR A
    BVC L3441
    STY $FD12
    ADC [$0000]
    NOP
    AND $CBE0,Y
    EOR [$0000]
    BRK $9E
    ORA ($2F,X)
    ASL $F180,X
    CMP $4C289C
    ORA $DF,X
    RTS
    BCS L3472
    EOR $AA,X
    WAI
    STA [$0000]
    SBC $3E7507
    AND $9BC2,X
    AND $140482
    PLP
    LDA $607F4F
    BEQ L34CA
    ORA ($8A,X)
    ORA [$0000]
    AND $D6,X
    STY $CB,X
    JSR $9F1A,X
    JSL $7E5F1A
    SBC $E81EA6
    RTI
    BVC L3486
    ADC $10,X
    ROL $8031,X
    TYX
    AND ($70)
    LSR $48FD,X
    BCC L350D
    LDY $2DDB,X
    LDA #$C0F0
    ADC $9700,Y
    PHD
    STA $C2A59E
    LDA $E1E4
    CPY #$FCFC
    ADC [$0000]
    ADC $23F8,Y
    ORA ($7E),Y
    ORA [$0000]
    TXA
    ADC ($5F,X)
    SED
    BIT $F8,X
    LDA $14
    BRA L357B
    ROL $A855,X
    JML [$DB20F8]
    STA $140A5D
    JML [$EC20EF]
    STA ($9F),Y
    PLP
    ORA ($B5,X)
    CMP $435FF5
    ASL $E518,X
    LDA $6A44,X
    BVC L34D5
    JML [$430550]
    TYX
    EOR $27,X
    PLX
    CPX $01
    ORA $02
    EOR $FA08,Y
    CPY #$DBFA
    STA $3BCF83
    SED
    SBC ($17,S),Y
    EOR $54,S
    ORA $82
    EOR ($AA),Y
    STA $5FFE,Y
    PLX
    ADC $108AEA
    SBC ($53,X)
    EOR $EA513A
    DEY
    ROL A
    ORA ($7F),Y
L3586:
    PLX
    MVN $F37F,$05
    ADC ($6B,X)
    CMP ($8A),Y
    TSB $FD
    JSL $9FF4AA
    CMP ($6F),Y
    DEC $06FE
    SBC $4E78
    BCS L3586
    XCE
    EOR [$0000]
    AND $843C5A
    CPY #$5FC0
    ROL $F0AF
    EOR $FFBDFC
    INC $5E00,X
    BRK $00
    BRK $0F
    LDX $8600,Y
L35BA:
    BRA L35BA
    INC $6666,X
    PER $B626
    SBC $6060,X
    STZ $64
    JMP $187C,X
    AND ($64),Y
    CPX $A370
    SEC
    SEC
    SEI
    ROL $4B
    ORA ($03,S),Y
    SBC [$0000]
    BIT $903C,X
    ORA ($24,X)
    BIT $E0
    STZ $10E0,X
    LDY #$6C6C
    ROR $76,X
    JMP $AC0C
    BPL L361C
    LDA $03
    JSR $39FC,X
    SBC #$2E66
    STY $F7
    SBC [$0000]
    LDA [$0000]
    BIT $57,X
    EOR $D22811
    STA $5EC603
    STA $F9,X
    ADC ($06),Y
    LDA $E306,X
    LDY $E4E4,X
    ROR $B76E
    SBC $B070
    BVS L3654
    ORA ($3A)
    DEA
    ORA ($3C,X)
    SBC ($A7),Y
    SED
    AND $5E06
    EOR $7002,X
    ADC $F4EE,Y
    CMP $9B01
L362A:
    ASL $420E
    LDY $78
    ASL $16,X
    ROL $783E,X
    SBC $7DFF
    ORA [$0000]
    STY $01
    LDA [$0000]
    AND $72
    ORA #$B600
    SBC [$0000]
    JSL $BD0003
    JML $8FAE67
    CMP ($5A)
    STX $B1,Y
    CPY #$E76D
    ORA [$0000]
    INC $AB
    CMP $646D,X
L365A:
    WDM $42
    LSR $81
    LSR $60
    LDA $E5
    EOR ($6F,S),Y
    AND $F11A00
    LDA $32,S
    PER $5289
    BPL L36DF
    ORA #$0808
    JSL $D083E4
    ASL $5BAF,X
    EOR $95D1E7
    EOR [$0000]
    CPY #$C2CD
    REP #$76
    ROL $1E1E,X
    LDY #$3B7C
    TYA
L368B:
    TSA
    ORA ($1E,S),Y
    ORA $F0E2
    BEQ L362A
    BIT #$855C
    RTS
    SBC [$0000]
    JML $F1ED5C
    BCC L369A
    BMI L3711
    LSR $01B6
    AND $8F7315
    TXY
    CMP [$0000]
    DEX
    REP #$A3
    BEQ L365A
    INA
    STA $1A,S
    SBC $A6589B
    TAY
    TRB $6E
    STA $2020,Y
    CPY #$4040
    ADC ($79)
    STA $0DE5,Y
    RTI
    BEQ L368B
    AND $8FAC8D
    LDA $0CF0,X
    STA $7F
    BIT $02EA,X
    LDY #$74F8
    ROR $9F7E,X
    PLX
    CMP $ECC42D
L36DF:
    CPX $8FAC
    PLY
    XCE
    PHP
    BRA L371D
    REP #$AB
    SEI
    CPX $0705
    JSR $85DC,X
    CPX $F0F1
    SEI
    ORA [$0000]
    STA $0A1B1F
    SBC $0B0A
    PHD
L36FE:
    ADC ($DC),Y
    ADC [$0000]
    PHP
    PLP
    JMP $4C9D
    STA $878703
    CPY $CA74
    DEC $CE80
L3711:
    BIT $EE
    CMP #$03B5
    JMP $6E39,X
    SBC $7EC7
    STY $5C,X
    CMP ($D1),Y
    AND ($33,S),Y
    ORA ($13,S),Y
    LDY $B2,X
    TSA
    TSB $E180
    SBC ($31,X)
    AND $9C9C00
    BRA L36BE
    SBC $7B,S
    JSR $67E9,X
    ADC $87EB,X
    ADC $8FFC,X
    EOR [$0000]
    BRK $1E
    STA $8F3D18
    STA $DF
    BIT $EF6B,X
    SBC $25B256
    BRK $C7
    ADC $C1,S
    SEI
    SEI
    BIT $9EE0,X
    TDC
    STA $1E023D
    SBC ($00),Y
    ORA $050FDB
    LDA ($E4),Y
    TSB $04
    PLD
    EOR $1FC3C3
    AND $9725CA
    CMP [$0000]
    CMP ($C1,X)
    INY
    LDX $C8,Y
    LDA [$0000]
    RTL
    RTL
    ORA ($D8),Y
    BRA L36FE
    ORA $6D0065
    BIT $7294
    STA $4D,X
    LDX $E5E5,Y
    EOR $7947,X
    ROL $2D,X
    PHK
    ROL $F1CA,X
    SBC ($6E),Y
    ADC $DBDB,Y
    ADC $6B,S
    ORA $DE,X
    DEC $C7C0,X
    BRA L3794
    STA ($52,S),Y
    INC $31EE
    STA $388F
    ORA $ACDCDC
    ORA [$0000]
    INC $4597,X
    PLA
    BRA L381D
    SBC ($85,S),Y
    BCS L37D8
    CPY $73
    TSB $16
    ROL $C2E6,X
    TYX
    ORA ($4F,X)
    TYX
    ADC $E2F513
    ADC ($9F),Y
    ORA [$0000]
    ROL $5BF5,X
    AND $FF
    BRA L37D2
    BNE L3794
    LDA [$0000]
    EOR $8FB78F
    TYX
    BEQ L37EB
    STZ $EF7C,X
    EOR ($E0)
    RTL
    BRK $E8
    SBC [$0000]
    ORA $7A72BE
    PLY
    JSR $5A5A,X
    LSR $4E5E,X
    LSR $D99E
    ROR $0005,X
    STA $17,S
    DEC $E7
    DEC $B5F9,X
    LDA ($8C),Y
    SBC $A9F93E
    ORA $30,X
    STA [$0000]
    EOR $8F82,X
    ADC [$0000]
    CLI
    SBC ($AD),Y
    SBC $E3,S
    STZ $DFF6,X
    ROL $6500,X
    CMP $8BA7,X
L381D:
    SBC $F1,X
    ORA $1E,X
    CPX #$3867
    ROR $AF
    ROR $C4A7
    LDA ($C7),Y
    BRK $F7
    SBC ($17,X)
    BIT $DEF8,X
    AND ($F0)
    DEY
    CMP [$0000]
    SEI
    CPX $46
    BRK $57
    SED
    SBC $5907,Y
    PER $9EBC
    ROL $8552,X
    ORA $7C4008
    NOP
    BRK $AD
    AND $F7F04F
    LDA $DA,S
    COP $45
    SBC $EB2368
    SBC $1D00,X
    STZ $17
    TYA
    ADC $63,S
    SEI
    MVN $1DE1,$1D
    PHP
    EOR $02B79E
    AND $D3A008
    ADC $300C0A
    ADC $FE,S
    ASL $8006,X
    EOR $8D
    ORA ($58,S),Y
    CPX $D2FD
L387F:
    ADC ($71),Y
    LDA $C3C0,X
    CLD
    CLD
    BIT #$F958
    PEI ($F8)
    EOR $73
    EOR [$0000]
    AND ($30,X)
    LDA ($3C,S),Y
    LDA $F85C,Y
    SED
    BRA L38A6
    INX
    CMP $039B
    BRA L386C
    ADC $BDEB,Y
    PHP
    BIT #$F84F
L38A6:
    INY
    ROL $A155,X
    CMP $7979D8
    STA ($7E,S),Y
    ORA $F70D
    REP #$3C
    LSR $BC7E,X
    CMP [$0000]
    COP $7C
    NOP
    LDY $3F
    JSR $87F1,X
    LDA [$0000]
    PEA $E59A
    LDA [$0000]
    ORA $728F,Y
    ORA ($67,X)
    LDA $02C0,Y
    INC $85,X
    EOR $E5495F
    INC $07F4,X
    CPX $2307
    AND $2E,S
    ROL $E5BC
    CMP $F9060C
    PLP
    LDY $AE65
    BRK $C2
    CMP $9E,S
    STZ $72FD,X
    BRK $87
    STA ($1F,X)
    SBC $4D
    ADC ($7D),Y
    BRA L387F
    AND $96F05F
    PEA $4730
    ORA ($75,X)
    JML [$373939]
    STA ($BE,X)
    PEA $7D07
    CLC
    LDA ($F5,S),Y
    ASL $841F,X
    STY $3C
    LDA $2ABF1E
    STA $042B6C
    AND $783D,X
L3920:
    CMP ($77)
    ADC [$0000]
    ROR $C7C6,X
    SBC $5F00F1
    SEI
    SBC ($53,X)
    EOR $0BDC7B
    CMP $8678,X
    STA $C76F3C
    SBC $3801,Y
    BRK $2F
    SBC $2FC7EB
    BIT $A0F0,X
    LDA $5FFF,X
    SED
    SED
    MVP $2380,$3F
    ORA [$0000]
L3950:
    STA $59A3E3
    STZ $74,X
    CPY $C4
    JML [$2E1BC7]
    CMP $BDFDC5
    CPX #$6161
    LDA $E3D4,Y
    SBC $CD,S
    LDA ($B1),Y
    INC $C7,X
    BRA L3950
    BCS L3920
    LDA $18980B
    SBC $AF30DA
    EOR ($52)
    TYX
    LDX $C2ED,Y
    ADC $1FE3F8
    BRK $FC
    CPX $3F6B
    JMP $85E1,X
    SBC $79FD4F
    ORA $BFE13C
    SBC [$0000]
    AND $00F1E4
    LDA ($7E,S),Y
    STA $C3FEC7
    CLV
    SBC [$0000]
    ROR $02A7
    ADC $FD,S
    STZ $72DC,X
    EOR ($18,X)
    ROL A
    LDY $3E5C
    CLV
    CLV
    SBC $17
    CMP $F72CD9
    BRK $65
    CPX #$DE5F
    ADC $3694,X
    WAI
    EOR $00,X
    LDA [$0000]
    INY
    LDY $06BC,X
    BIT $CF,X
    LDA ($2C),Y
    PHA
    INY
    ASL $00F8,X
    ADC $C3F81F
    ORA $94F0FF
    PHB
    INC $CFA7,X
    AND [$0000]
    LDA ($BA),Y
    CMP $3F0779
    COP $E2
    AND ($7C,S),Y
    INC $5D6F
    SBC $DFE6,Y
    PEA $D9D9
    STA $8D8F
    SEP #$5F
    ROR $E678
    CMP $99,S
    STA $9B9B,Y
    CMP ($93,X)
    STA ($07,S),Y
    CLC
    SBC $8E47,Y
    ADC $F989B1
    STA $F9,S
    ROR $FF,X
    DEA
    INC $89B7
    ROR $84FF
    AND [$0000]
    CMP #$BF00
    EOR $F09F
    CLD
    LDA [$0000]
    SBC $F950BF
    ADC $00A7B2
    EOR $E0DE,Y
    ADC $B3
    STA [$0000]
    SBC ($1F),Y
    STA $07EDF8
    LSR $9F05,X
    JSR $00E1,X
    STA $CA784F
    EOR $7F
    ORA $B0E5,X
    WAI
    RTL
    STA $7C2045
    INC $BE
    LDA $18,X
    CMP [$0000]
    ASL $DFF4
    PEA $8181
    WAI
    ADC $1C,S
    LDX $C8
    LDA [$0000]
    INY
    LDA [$0000]
    STA $F3,S
    SBC ($B1,S),Y
    PLB
    CPY $2638
    STA $646530
    ORA #$B909
    AND [$0000]
    ROR $EC
    AND $3200,Y
    ROL $C7E6,X
    INY
    EOR ($CE,S),Y
    TXY
    AND $13D65B
    CPY #$ED
    SBC $FB03
    ADC $F8EC,Y
    EOR ($01,S),Y
    STA $40D41A
    LSR A
    COP $A0
    ADC [$0000]
    SED
    SBC [$0000]
    CLC
    DEC $006F
    ORA $F67EAF
    ORA ($3F),Y
    SBC $1FE3,X
    LDA $5E69E3
    BEQ L3A6B
    ORA #$0BF1
    BRK $0B
    LDX $FDCF,Y
    CMP ($0B)
    SBC ($79,S),Y
    ORA $FACFBE
    JSR $60E1,X
    JSR $9401,X
    BEQ L3AAA
    BRK $F7
    LDA $8FF7,X
    EOR $6F39BC
    CPY #$6E
    SBC $F8D238
    SBC $282CCD
    ASL $0D1C
    CMP $EFCF,X
    EOR $55,X
    STY $30C5
    PLB
    COP $3E
    CMP ($9C,X)
    STZ $17C0
    DEY
    STA $FEF0F8
    ORA ($C1,X)
    AND [$0000]
    LDA $ED7F,Y
    SBC $7E,S
    JMP $77C7,X
    SED
    JML [$ACF378]
    ADC $70FC41
    LDA $30,X
    CMP [$0000]
    ADC $4C4C8F
    CMP $78FBC7
    ORA $EDBF0F
    PHP
    BIT $B5D1,X
    ORA #$0037
    JSL $82AEFD
    TAS
    AND $3F005C
    STA ($E1,X)
    ORA ($02),Y
    BEQ L3B50
    ROL $857A,X
    ORA $43E71F
    PHD
    ORA $BDDA78
    AND [$0000]
    LDX $2BFB
    EOR $B8C2,X
    LSR $F1,X
    PEA $090B
    LDX $EEBC,Y
    ADC $6F
    ASL $C2E1,X
    STA $00,S
    EOR $3382F7
L3B50:
    CMP $C7A75E
    STA $04FACE
    PHD
    SBC $AFE1FC
    AND $F1F900
    ORA $43E3CF
    CMP [$0000]
    SED
    CMP ($BD)
    AND $EAF76B
    LDX #$17
    JMP $E97C,X
    BRK $75
    AND $1FE3FB
    AND $EBD078
    LSR $C7FD
    AND $B3F09E
    ADC $9F
    STZ $E1,X
    SBC $0178,X
    BRL $7B0D
    JSR $85F9,X
    ROL $CF4F,X
    ADC $79,S
    PER $2DD9
    ADC [$0000]
    AND ($36),Y
    JMP $E8E8
    INX
    LDA $8827,X
    DEY
    DEA
    ORA ($B0),Y
    CMP $F0010F
    AND #$013F
    INX
    LSR $5B36
    TCD
    ADC $6D907F
    SBC ($80),Y
    LDA ($71,S),Y
    ROL $1B,X
    XCE
    AND $7F0780
    XCE
    TYX
    SBC $5B60,Y
    BEQ L3BFB
    STA $0B0BFB
    ORA $CB1F80
    ADC $43FB
    AND #$5EE3
    JSR $19C5,X
    ROR $30FB,X
    ORA #$F63C
    LDX $1D1D
    ADC ($9E)
    AND [$0000]
    AND [$0000]
    STY $7C,X
    BRK $F8
    CPY #$1D
    ASL $B6FD
    LDX $44AB,Y
    EOR $D62B,X
    CMP $8FC2E4
    STA $65B577
    ADC $2F20
    SBC $C28601
    LDA $F89F00
    JML [$F8FC0B]
    LDA ($C7,S),Y
    STX $9B,Y
    SBC #$40E7
    SBC $61ED63
    STA [$0000]
    CMP #$DD7B
    JMP $8BA3,X
    SBC $29EEF0
    STY $59,X
    LDY $5B03,X
    INC $2818
    CPY #$8E
    XCE
    STA $039D,X
    JMP $B1E5
    ORA ($CB,X)
    ORA $BF87,X
    SBC ($62,S),Y
    CMP $6D16,Y
    ROL $C22C,X
    CMP $982079
    JSR $E51F
    ROL $7BD1
    TDC
    INC $C7A6,X
    DEC $AD31,X
    REP #$8D
    INC $9E9E,X
    EOR $F4,S
    INA
    AND $23B023
    ROL $2E6F,X
    ROL $BBCF
    ROL $85E6,X
    AND $6D4FFA
    STA [$0000]
    ORA $947E0F
    ORA ($11),Y
    AND $81178D
    ORA [$0000]
    RTS
    STX $37,Y
    CPY #$5A
    LDA [$0000]
    CMP $3FCF80
    ROR $13E1,X
    SBC $FF,S
    STA $C8F8C0
    CMP $C7E97E
    AND $D4787C
    CMP $0127,Y
    STZ $4FF8,X
    STX $84F2
    CMP $F9,S
    ASL $E0DA,X
    LDA [$0000]
    EOR [$0000]
    ASL $2A
    LDY $402A
    LSR A
    EOR $6CC7C7
    SEP #$18
    LDA $FF1009
    SBC ($FD,S),Y
    AND $0440,X
    PLX
    PHB
    BRA L3D2B
    LDA $63BF80
    AND [$0000]
    SBC [$0000]
    TSX
    LDA $F28181
    INX
    STA ($26,S),Y
    STZ $0D09
    EOR $3F3FFB
    LSR $3C7D
    SBC $0CBFC4
    AND $1B39,Y
    TAS
    STX $8E,Y
    DEC $D1
    BRK $DD
    LDA $E8,S
    SBC $375E00
    TXS
    WAI
    STZ $60,X
    STA $00D78B
    BIT $50
    ROL $B7F2,X
    ORA $0FF1FA
    EOR $F6F51E
    ORA $9B7F53
    LDY $EC46,X
    EOR [$0000]
    CLC
    PEA $EEDF
    LDY $9F,X
    STA $603B94
    ADC $F8661F
    STA $51517D
    CMP $97D9,Y
    BRA L3CBE
    CMP $00E5B8
L3D2B:
    COP $EC
    ORA ($C9,S),Y
    XCE
    PHX
    CPY #$45
    BRK $7E
    TSA
    ADC $0F73,Y
    SBC $FA1F69
    SBC $76,S
    LDA $E8162E
    SBC ($06,S),Y
    CPX #$F2
    AND ($7F,S),Y
    SBC ($C6,X)
    ORA $CC923C
    CLV
    CLV
    ROL $0080,X
    SBC ($B3)
    SBC $E0C0FC
    STZ $BDD7
    BMI L3D1B
    LDA $7B9085
    DEC $52F4,X
    EOR ($5A)
    PHY
    ROL A
    SBC ($73,S),Y
    ADC ($07,S),Y
    PHX
    ADC $C0FA,X
    BIT $9E,X
    PHP
    LDA $72C4E9
    ADC ($37)
    STX $37
    ORA ($FC,S),Y
    JMP $D4EB,X
    AND $E8FDAB
    STP
    STZ $74,X
    CMP $C4,S
    CPY $0E
    EOR $7C07,X
    PLX
    STA $E0
    ORA $E77600
    SBC [$0000]
    SBC $34345D
    EOR #$7C3F
    SBC ($8F,X)
    ORA $F8E9FC
    AND $F8F000
    CPY $07
    LDX $C3F0,Y
    AND $EFF31C
    SBC ($C2)
    AND ($1F),Y
    LDX $BA,Y
    DEC $DD40,X
    ORA $2C,S
    DEC $FAB9,X
    STA ($CB),Y
L3DC3:
    AND $B91802
    XCE
    ASL $5E
    ASL $13B4,X
    EOR [$0000]
    SBC ($AD,S),Y
    SBC $E8D7,Y
    EOR [$0000]
    LDY $778B,X
    BRK $5E
    TXY
    LDY $AF17
    BEQ L3DC3
    EOR $7A0F
    BEQ L3D9E
    BNE L3DED
    JSR $0048,X
    STA $E93C3F
    PHB
    AND $FFF3A7
    CMP $8F,S
    STA $0F007C
    EOR $00E2FC
    CMP $0BEB7C
    ADC $9EFC,X
    LDA [$0000]
    WAI
    CMP $F44ABC
    PHP
    EOR $8900,X
    LSR $F5
    ORA [$0000]
    TCD
    EOR $13,X
    STA $13ACFB
    BIT #$8B89
    CPX $D38B
    CMP ($C1,S),Y
    ADC [$0000]
    LDA $B0B0,Y
    LSR $C25C,X
    LDA $5858F0
    SED
    SED
    ROL $4BE0,X
    LDA $C209,Y
    CPX #$4E
    BRK $79
    LDA $3CF83B
    DEC $2E,X
    ORA ($EF,X)
    ADC $BDF3,Y
    AND $ACFAAA
    AND ($9A,S),Y
    EOR $4E3F,X
    LDA ($B1),Y
    CMP $E36B,Y
    SBC $00,S
    SBC $E9BD
    LDA $4F2B
    STA ($D8),Y
    CMP [$0000]
    BIT $36EC,X
    ROR $C71E
    ADC $C038,X
    STA $A4FE,X
    LDY $B4
    LDY $92,X
    CMP $D900,X
    BIT #$787F
    SEP #$07
    JML $6CCF6E
    LDA $F72C1F
    ADC $E0
    SBC #$00D9
    AND [$0000]
    SEI
    SBC ($99),Y
    ADC $1EF1FA
    ORA $147FCB
    CLC
    CPX $FE
    ASL $84
    ADC ($F7),Y
    LDA $29,S
    STA $55F9F9
    CMP $0909C1
    EOR $5CEE,Y
    CPX $6E
    STY $C2,X
    JML [$698069]
    STZ $FE
    INC $0485,X
    AND $7FFBCF
    ASL $2DF6,X
    CMP $F7E5,Y
    PHX
    RTS
    EOR $FBE6,X
    XCE
    TSA
    STA ($A5),Y
    AND $12587A
    CMP ($10,X)
    LDX $D7,Y
    BRK $65
    DEC $17
    INY
    BIT $89CF
    PLX
    SEI
    BRA L3F52
    JML $4848FE
    PLA
    PLA
    SBC #$126F
    STZ $FC,X
    CPX #$00
    SBC $13
    AND $9AF3BC
    DEC $DFF4,X
    PLY
    AND $F9C8,X
    DEC $F33B,X
    BIT $2A
    BRK $17
    DEC $D2F8,X
    LSR $D5B8,X
    ORA ($F4,S),Y
    SBC $BE1F,Y
    SED
    CMP $BC,X
    JML $03FABF
    LDA [$0000]
    CMP $89B5CE
    PLX
    SBC ($72)
    ROR $FF53
    TXA
    LDA $007171
    STA $F8F173
    ROL $F3B2
    AND ($01,S),Y
    LDA [$0000]
    LDA $5700,X
    ROR $DC37
    SEI
    JML [$BF6FB5]
    BEQ L3F17
    LDA $7FCB,Y
    CPX #$C2
    WAI
    ORA $01787F
    SBC $35,S
    ADC $D17CFA
    ORA ($0B,S),Y
    ORA $BC1F
    INX
    SBC ($80,S),Y
    SBC ($97,S),Y
    LSR $C13D
    STA $4BE197
    EOR $8F00FD
    LDA $C7A77E
    INC $01C7
    WAI
    SBC $379C,X
    PHX
    ADC ($33,S),Y
    INC $FA7B,X
    ADC ($CA,S),Y
    STY $80
    STY $FE
    SBC $7DFF,X
    LDX $9F
    ASL $F7
    EOR $002FF5
    PHA
    WAI
    BRK $B5
L3F81:
    ADC $E3F0FF
    LDA $FF2F,Y
    CPX #$04
    LDY $D70F
    SBC ($7E,S),Y
    SED
    CMP $CF,S
    CMP $BD00FC
    STZ $CE01,X
    SED
    WAI
    PEI ($CF)
    REP #$EC
    STA $4E27,X
    BEQ L3FA9
    STA $7F4700
    SBC [$0000]
    ORA [$0000]
    SBC $C123B8
    AND $1E007A
    ORA $0FF5FB
    BRK $17
    ROR $67CE,X
    JSR $55B3,X
    LSR $F827,X
    BEQ L3F81
    ORA ($B8,X)
    ADC $5E,S
    CMP [$0000]
    ROR $00F8,X
    CMP [$0000]
    SEI
    CMP ($F8)
    SBC ($FF,S),Y
    PLX
    BIT $C7D4,X
    ORA [$0000]
    TXS
    DEC $26,X
    STA ($D0,X)
    CMP ($87),Y
    SBC $87E1,X
    EOR $BEF79E
    ORA $7E,X
    INC $44D8,X
    JMP $7C80,X
    SBC $8B18,X
    PLD
    BEQ L3FA7
    EOR [$0000]
    LDA $6BE1E0
    CMP $000000
