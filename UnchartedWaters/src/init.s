;
; Uncharted Waters (USA) - global variable initialisation
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8190-$82B2).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8190
    .ACCU 8               ; the boot code leaves the accumulator 8 bit wide
    .INDEX 16              ; and the index registers 16 bit wide

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
