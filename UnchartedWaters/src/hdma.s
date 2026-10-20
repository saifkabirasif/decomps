;
; Uncharted Waters (USA) - HDMA, direct VRAM writes and window positions
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8C05-$8CD1).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8C05
    .ACCU 8
    .INDEX 16

; ---------------------------------------------------------------------------
; $8C05: start the HDMA channels the game needs this frame
; ---------------------------------------------------------------------------
UpdateHdma:
    SEP #$20
    REP #$10
    LDA $0DDA
    BEQ UpdateHdmaWindow
    LDA $0DD9
    AND #$80
    BEQ UpdateHdmaWindow
    LDA $0DDC
    STA $2123              ; window 1 left position
    LDA $0DDD
    STA $2124              ; window 1 top position
    LDA $0DDE
    STA $2125              ; window 1 right position
    LDA #$01
    STA $4370              ; HDMA channel 7: mode
    LDA #$26
    STA $4371              ; HDMA channel 7: A bus
    LDX #$0DDF
    STX $4372              ; HDMA channel 7: source address
    STZ $4374              ; HDMA channel 7: source bank
    LDA #$80
    BRA UpdateHdmaStart
UpdateHdmaWindow:
    LDA $0DF1
    BEQ UpdateHdmaStart
    LDA $0DD9
    AND #$20
    BEQ UpdateHdmaStart
    LDA $0DF2
    STA $4350              ; HDMA channel 5: mode
    LDA $0DF3
    STA $4351              ; HDMA channel 5: A bus
    LDX $0DF4
    STX $4352              ; HDMA channel 5: source address
    LDA $0DF6
    STA $4354              ; HDMA channel 5: source bank
    STA $4357              ; HDMA channel 5: indirect address
    STZ $0DF1
    LDA #$20
    STA $420C              ; enable HDMA channels 5 and 7
UpdateHdmaStart:
    LDA $0DD9
    STA $420C              ; enable the HDMA channels
    LDA #$02
    STA $0DDA
    RTS

; ---------------------------------------------------------------------------
; $8C79: write $0DF7 bytes straight into the VRAM
; ---------------------------------------------------------------------------
WriteVramDirect:
    REP #$30
    LDA $0DF7
    BEQ WriteVramDirectEnd
    LDX $0DFD
    LDY $0DFB
    LDA $0DF9
WriteVramDirectLoop:
    STA $2116              ; VRAM address
    STY $2118              ; VRAM data
    INA
    DEX
    BNE WriteVramDirectLoop
WriteVramDirectEnd:
    STZ $0DF7
    RTS

; ---------------------------------------------------------------------------
; $8C97: move the window position registers
; ---------------------------------------------------------------------------
UpdateWindowPosition:
    SEP #$30
    LDA $0E03
    BEQ UpdateWindowPositionEnd
    LDX $0B42
    LDY $0B43
    STX $211B              ; window 1 left position
    STY $211B
    LDX $0B44
    LDY $0B45
    STX $211C              ; window 1 top position
    STY $211C
    LDX $0B46
    LDY $0B47
    STX $211D              ; window 1 right position
    STY $211D
    LDX $0B48
    LDY $0B49
    STX $211E              ; window 1 bottom position
    STY $211E
    STZ $0E03
UpdateWindowPositionEnd:
    RTS
