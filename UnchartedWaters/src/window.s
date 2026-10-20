;
; Uncharted Waters (USA) - window masks and background scrolling
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8B20-$8C04).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8B20
    .ACCU 8
    .INDEX 16

; ---------------------------------------------------------------------------
; $8B20: move the window mask on or off
; ---------------------------------------------------------------------------
UpdateWindowMask:
    SEP #$20
    LDA $0DCC
    BEQ UpdateWindowMaskEnd
    REP #$10
    LDX $0DCE
    CPX $0DD0
    BNE UpdateWindowMaskCount
    LDA $0DCD
    BNE UpdateWindowMaskSecond
    LDX $0DD2
    INC $0DCD
    BRA UpdateWindowMaskStore
UpdateWindowMaskSecond:
    LDX $0DD4
    STZ $0DCD
UpdateWindowMaskStore:
    STX $212C              ; window mask settings
    STX $0DD6
    LDX #$0000
    STX $0DCE
    BRA UpdateWindowMaskEnd
UpdateWindowMaskCount:
    REP #$20
    INC $0DCE
UpdateWindowMaskEnd:
    RTS

; ---------------------------------------------------------------------------
; $8B58: update the background scroll and the window positions
; ---------------------------------------------------------------------------
UpdateScroll:
    REP #$10
    SEP #$20
    LDA $0B7F
    STA $2106              ; BG1 horizontal scroll
    LDA $0B86
    BEQ UpdateScrollWindows
    STZ $0B86
    LDX #$0000
UpdateScrollWait:
    DEC $0B81
    BEQ UpdateScrollWrite
    INX
    INX
    BRA UpdateScrollWait
UpdateScrollWrite:
    LDA $0B82
    STA $210D,X            ; window 1 left position
    LDA $0B83
    STA $210D,X
    LDA $0B84
    STA $210E,X            ; window 1 right position
    LDA $0B85
    STA $210E,X
UpdateScrollWindows:
    LDX $0E0A
    BEQ UpdateScrollEnd
    REP #$30
    LDA $0E17
    CMP $0E14
    BCS UpdateScrollMove
    INC $0E17
    BRA UpdateScrollEnd
UpdateScrollMove:
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
    BNE UpdateScrollSecond
    LDY #$0001
    BRA UpdateScrollWrite2
UpdateScrollSecond:
    LDY #$0000
UpdateScrollWait2:
    DEA
    BEQ UpdateScrollWrite2
    INX
    INX
    BRA UpdateScrollWait2
UpdateScrollWrite2:
    LDA $0E0C
    STA $210D,X
    LDA $0E0D
    STA $210D,X
    LDA $0E0E
    STA $210E,X
    LDA $0E0F
    STA $210E,X
    CPY #$0000
    BEQ UpdateScrollDone
    LDY #$0000
    LDX #$0002
    BRA UpdateScrollWrite2
UpdateScrollDone:
    REP #$30
    DEC $0E0A
    SEP #$20
UpdateScrollEnd:
    RTS
