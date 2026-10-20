;
; Uncharted Waters (USA) - the VRAM/CGRAM/OAM transfer engine
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8512-$8635).
;
; $8512 works out how a DMA block has to be cut up so that it never crosses
; the $8000-$FFFF window of VRAM, copies the DMA descriptor from $0B20 to
; the channel registers and kicks the transfer off.  $85B5 performs the
; actual register writes for the three kinds of destination the game uses.
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8512
    .ACCU 8
    .INDEX 16

; ---------------------------------------------------------------------------
; $8512: transfer the block described by $0B20-$0B27
; ---------------------------------------------------------------------------
TransferEngine:
    REP #$10
    SEP #$20
    PHY
    PHX
    LDX #$0001             ; number of chunks still to transfer
    STZ $0DFF              ; chunks already transferred
    REP #$20
    LDA $0B25              ; requested size
    STA $4E
    STA $50
    DEA
    CLC
    ADC $0B22              ; destination + size - 1
    BCC TransferEngineDone ; still inside the same $8000 window
    BNE TransferEngineSplit
    LDA $0B22
    CMP #$FFFF
    BEQ TransferEngineEnd
    INX
TransferEngineEnd:
    DEC $0B25
    DEC $0B25
    SEP #$20
    INC $0DFF
    BRA TransferEngineStart
TransferEngineSplit:
    REP #$30
    INX
    STA $4E
    INC $4E
    LDA $50
    SEC
    SBC $4E
    STA $50
    LSR A
    BCC TransferEngineShort
    LDA $50
    CMP #$0001
    BEQ TransferEngineFull
    INX
TransferEngineFull:
    DEA
    STA $0B25
    DEC $4E
    SEP #$20
    INC $0DFF
    INC $0DFF
TransferEngineStart:
    LDA $0B21
    STA $0E00              ; the kind of destination
    BRA TransferEngineDone
TransferEngineShort:
    LDA $50
    STA $0B25
TransferEngineDone:
    SEP #$20
    TXA
    CMP $0DFF
    BNE TransferEngineCopy ; more chunks to go
    JSR $85B5
    BRA TransferEngineNext
TransferEngineCopy:
    LDY #$0000
TransferEngineCopyLoop:
    LDA $0B20,Y
    STA ($38),Y
    INY
    CPY #$0007
    BNE TransferEngineCopyLoop
    LDA $4C
    STA $420B              ; start the DMA
TransferEngineNext:
    DEX
    BEQ TransferEngineEnd2
    LDA $0DFF
    BNE TransferEngineDone
    INC $0B24              ; the block wrapped: continue in the next window
    LDY #$8000
    STY $0B22
    LDY $4E
    STY $0B25
    BRA TransferEngineDone
TransferEngineEnd2:
    PLX
    PLY
    RTS

; ---------------------------------------------------------------------------
; $85B5: write the transfer to VRAM ($18), CGRAM ($22) or OAM ($39)
; ---------------------------------------------------------------------------
WriteDestination:
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
    BEQ WriteVram
    CMP #$22
    BEQ WriteCgram
    CMP #$39
    BEQ WriteOam
WriteWait:
    NOP
    BRA WriteWait
WriteVram:
    LDA #$80
    STA $2115              ; VRAM address increment
    LDX $30
    STX $2116              ; VRAM address
    LDA [$32]
    STA $2118              ; VRAM data (low)
    LDA [$35]
    STA $2119              ; VRAM data (high)
    INX
    STX $2116
    BRA WriteDone
WriteCgram:
    LDA $30
    STA $2121              ; CGRAM address
    LDA [$32]
    STA $2122              ; CGRAM data (low)
    LDA [$35]
    STA $2122              ; CGRAM data (high)
    BRA WriteDone
WriteOam:
    LDA #$80
    STA $2115
    LDX $30
    STX $2116
    LDA $213A
    LDA $2139
    STA [$32]
    LDA $213A
    STA [$35]
    INX
    STX $2116
    LDA $213A
WriteDone:
    INC $0B24
    LDX #$8001
    STX $0B22
    LDX $4E
    STX $0B25
    PLX
    RTS
