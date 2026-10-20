;
; Uncharted Waters (USA) - the four graphic groups
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8870-$8B1F).
;
; $0B87 selects which group is updated:
;
;   1  a block of tiles is copied into the VRAM.  The list of blocks is
;      the table of (address low, address high, bank) triples at $0B96.
;   2  the OAM entries of a group of sprites are repositioned, either
;      absolutely (table at $0BBB) or relative to the old value
;      (table at $0BC3).
;   3  a second tile block is copied into the VRAM, using the tables at
;      $0BD4 and $0C94.
;   4  a palette is copied into the CGRAM, using the table at $0CC8.
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8870
    .ACCU 8
    .INDEX 16

; ---------------------------------------------------------------------------
; $8870: dispatch the pending graphic group update
; ---------------------------------------------------------------------------
UpdateGraphicsGroup:
    REP #$10
    SEP #$20
    LDA $0B87
    BEQ UpdateGraphicsGroupFour
    CMP #$01
    BNE UpdateGraphicsGroupTwoCheck
    LDA $0B88
    BEQ UpdateGraphicsGroupOneJump
    LDX $0BA4
    STX $0BA6
    LDX #$0000
    STX $0BAA
    STZ $0B88
UpdateGraphicsGroupOneJump:
    JMP LoadGraphicTiles
UpdateGraphicsGroupTwoCheck:
    CMP #$02
    BNE UpdateGraphicsGroupThreeCheck
    LDA $0B88
    BEQ UpdateGraphicsGroupTwoJump
    LDX $0BAF
    STX $0BB1
    LDX #$0000
    STX $0BB5
    STZ $0B88
UpdateGraphicsGroupTwoJump:
    JMP UpdateGraphicSprites
UpdateGraphicsGroupThreeCheck:
    CMP #$03
    BNE UpdateGraphicsGroupFour
    LDA $0B88
    BEQ UpdateGraphicsGroupThreeJump
    LDX $0BD2
    STX $0CB6
    LDX #$0000
    STX $0CB8
    STZ $0B88
UpdateGraphicsGroupThreeJump:
    JMP UpdateGraphicTilesTwo
UpdateGraphicsGroupFour:
    CMP #$04
    BNE UpdateGraphicsGroupEnd
    LDA $0B88
    BEQ UpdateGraphicsGroupFourJump
    LDX $0CC6
    STX $0DC8
    LDX #$0000
    STX $0DCA
    STZ $0B88
UpdateGraphicsGroupFourJump:
    JMP UpdateGraphicPalette
UpdateGraphicsGroupEnd:
    RTS

; ---------------------------------------------------------------------------
; $88E6: group 1 - copy a list of tile blocks into the VRAM
; ---------------------------------------------------------------------------
LoadGraphicTiles:
    REP #$30
    LDA $0BA6
    CMP $0BA4
    BCS LoadGraphicTilesStart
    JMP LoadGraphicTilesNext
LoadGraphicTilesStart:
    LDX #$0000
    STX $0BA6
    LDA $0BAA
    CMP $0BA8
    BCC LoadGraphicTilesColumn
    BNE LoadGraphicTilesColumn
    STX $0BAA
    BRA LoadGraphicTilesRow
LoadGraphicTilesColumn:
    INC $0BAA
LoadGraphicTilesRow:
    DEA
    BMI LoadGraphicTilesBlock
    INX
    INX
    INX
    BRA LoadGraphicTilesRow
LoadGraphicTilesExit:
    JMP LoadGraphicTilesNext
LoadGraphicTilesBlock:
    LDY $0B92
    SEP #$20
    LDA #$01
    STA $0B20              ; DMA mode
    LDA #$18
    STA $0B21              ; A bus: VRAM data
    LDA $0B96,X
    STA $0B22              ; source address low
    STA $0BAC
    LDA $0B97,X
    STA $0B23              ; source address high
    STA $0BAD
    LDA $0B98,X
    STA $0B24              ; source bank
    STA $0BAE
    LDX #$4300
    STX $38
    LDA #$01
    STA $4C
    LDX $0BA2
    STX $30
    STX $2116              ; VRAM address
    REP #$20
    LDA $0B90
    ASL A
    STA $0B25              ; size
LoadGraphicTilesTransfer:
    PHP
    JSR $8512
    PLP
    DEY
    BEQ LoadGraphicTilesEnd
    LDA #$1801
    STA $0B20              ; DMA mode and A bus: VRAM data
    LDA $0B90
    ASL A
    STA $0B25              ; size
    CLC
    ADC $0BAC
    ORA #$8000
    STA $0BAC
    STA $0B22              ; source address
    BCC LoadGraphicTilesBank
    SEP #$20
    INC $0BAE              ; the source crossed the $8000 boundary
LoadGraphicTilesBank:
    SEP #$20
    LDA $0BAE
    STA $0B24              ; source bank
    REP #$20
    TXA
    CLC
    ADC #$0020
    TAX
    STA $30
    STA $2116              ; VRAM address
    BRA LoadGraphicTilesTransfer
LoadGraphicTilesNext:
    INC $0BA6
LoadGraphicTilesEnd:
    RTS

; ---------------------------------------------------------------------------
; $899E: group 2 - reposition the OAM entries of a group of sprites
; ---------------------------------------------------------------------------
UpdateGraphicSprites:
    REP #$30
    LDA $0BB1
    CMP $0BAF
    BCS UpdateGraphicSpritesStart
    INC $0BB1
    BRA UpdateGraphicSpritesEnd
UpdateGraphicSpritesStart:
    LDY #$0000
    LDX $0BB9
    STZ $0BB1
    LDA $0BB5
    BNE UpdateGraphicSpritesMove
    SEP #$20
UpdateGraphicSpritesCopy:
    LDA $0BBB,Y
    STA $0902,X            ; the new position of the sprite
    INX
    INX
    INX
    INX
    INY
    CPY $0BB7
    BCC UpdateGraphicSpritesCopy
    BRA UpdateGraphicSpritesNext
UpdateGraphicSpritesMove:
    SEP #$20
UpdateGraphicSpritesMoveLoop:
    LDA $0BC3,Y
    CLC
    ADC $0902,X
    STA $0902,X            ; move the sprite relative to its old spot
    INX
    INX
    INX
    INX
    INY
    CPY $0BB7
    BCC UpdateGraphicSpritesMoveLoop
UpdateGraphicSpritesNext:
    REP #$20
    INC $0BB5
    LDA $0BB5
    CMP $0BB3
    BCC UpdateGraphicSpritesDone
    BEQ UpdateGraphicSpritesDone
    STZ $0BB5
UpdateGraphicSpritesDone:
    SEP #$20
    LDA #$01
    ORA $0B56
    STA $0B56
UpdateGraphicSpritesEnd:
    RTS

; ---------------------------------------------------------------------------
; $8A02: group 3 - copy a second set of tiles into the VRAM
; ---------------------------------------------------------------------------
UpdateGraphicTilesTwo:
    REP #$30
    LDA $0CB6
    CMP $0BD2
    BCC UpdateGraphicTilesTwoNext
    LDX #$0000
    TXY
    STX $0CB6
    LDA $0CB8
    CMP $0BD0
    BCC UpdateGraphicTilesTwoRow
    STZ $0CB8
    BRA UpdateGraphicTilesTwoColumn
UpdateGraphicTilesTwoRow:
    INC $0CB8
UpdateGraphicTilesTwoColumn:
    DEA
    BMI UpdateGraphicTilesTwoBlock
    INX
    INX
    INX
    BRA UpdateGraphicTilesTwoColumn
UpdateGraphicTilesTwoBlock:
    LDA #$0010
    STA $0CBA              ; sixteen rows
    LDA $0BCE
    AND $0CB4
UpdateGraphicTilesTwoLine:
    LSR A
    PHA
    BCC UpdateGraphicTilesTwoSkip
    LDA #$1801
    STA $0B20              ; DMA mode and A bus: VRAM data
    LDA $0BD5,X
    STA $0B23              ; source address high
    LDA $0BD4,X
    STA $0B22              ; source address low
    LDA #$0020
    STA $0B25              ; size
    LDA $0C94,Y
    STA $2116              ; VRAM address
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
UpdateGraphicTilesTwoSkip:
    TXA
    CLC
    ADC #$000C
    TAX
    INY
    INY
    PLA
    DEC $0CBA
    BNE UpdateGraphicTilesTwoLine
UpdateGraphicTilesTwoNext:
    REP #$20
    INC $0CB6
    RTS

; ---------------------------------------------------------------------------
; $8A81: group 4 - copy a palette into the CGRAM
; ---------------------------------------------------------------------------
UpdateGraphicPalette:
    REP #$30
    LDA $0DC8
    CMP $0CC6
    BCS UpdateGraphicPaletteStart
    JMP UpdateGraphicPaletteNext
UpdateGraphicPaletteStart:
    LDA $0CB4
    BNE UpdateGraphicPaletteSetup
    JMP UpdateGraphicPaletteNext
UpdateGraphicPaletteSetup:
    LDX #$0000
    TXY
    STX $0DC8
    LDA $0DCA
    PHA
    CMP $0CC4
    BCC UpdateGraphicPaletteRow
    STZ $0DCA
    BRA UpdateGraphicPaletteTax
UpdateGraphicPaletteRow:
    INC $0DCA
UpdateGraphicPaletteTax:
    TAX
UpdateGraphicPaletteColumn:
    DEX
    BMI UpdateGraphicPaletteColors
    TYA
    CLC
    ADC $0CC0
    ADC $0CC0
    TAY
    BRA UpdateGraphicPaletteColumn
UpdateGraphicPaletteColors:
    LDA $0CB4
    AND #$0001
    BEQ UpdateGraphicPaletteSecond
    LDX $0CC0
    SEP #$20
    LDA $0CBC
    STA $2121              ; CGRAM address
UpdateGraphicPaletteWrite:
    LDA $0CC8,Y
    STA $2122              ; CGRAM data (low)
    INY
    LDA $0CC8,Y
    STA $2122              ; CGRAM data (high)
    INY
    DEX
    BNE UpdateGraphicPaletteWrite
UpdateGraphicPaletteSecond:
    REP #$20
    PLA
    TAX
    LDY #$0080
UpdateGraphicPaletteSkip:
    DEX
    BMI UpdateGraphicPaletteDone
    TYA
    CLC
    ADC $0CC2
    ADC $0CC2
    TAY
    BRA UpdateGraphicPaletteSkip
UpdateGraphicPaletteDone:
    LDA $0CB4
    AND #$0002
    BEQ UpdateGraphicPaletteNext
    LDX $0CC2
    SEP #$20
    LDA $0CBE
    STA $2121              ; CGRAM address
UpdateGraphicPaletteWrite2:
    LDA $0CC8,Y
    STA $2122              ; CGRAM data (low)
    INY
    LDA $0CC8,Y
    STA $2122              ; CGRAM data (high)
    INY
    DEX
    BNE UpdateGraphicPaletteWrite2
UpdateGraphicPaletteNext:
    REP #$20
    INC $0DC8
    RTS
