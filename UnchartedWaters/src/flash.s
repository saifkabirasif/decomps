;
; Uncharted Waters (USA) - character flash effect
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8829-$886F).
;
; The routine alternates the palette byte of one OAM entry between the
; normal colour ($0B66) and white ($F0), which is how the game makes a
; character "flash" while they are talking.
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8829
    .ACCU 8
    .INDEX 16

FlashCharacter:
    REP #$10
    SEP #$20
    LDA $0B62
    BNE FlashCharacterWait
    LDA $0B63
    BEQ FlashCharacterEnd
    LDA #$00
    STA $0B63
    BRA FlashCharacterBlank
FlashCharacterWait:
    DEC $0B6C
    BNE FlashCharacterEnd
    LDA #$0A
    STA $0B6C              ; ten frames between two flashes
    LDA $0B63
    EOR #$FF
    STA $0B63
    BEQ FlashCharacterBlank
    LDX $0B64
    LDA $0B66
    STA $0901,X            ; the normal palette byte of the sprite
    LDA #$01
    BRA FlashCharacterFlag
FlashCharacterBlank:
    LDX $0B64
    LDA #$F0
    STA $0901,X            ; white
    LDA #$01
FlashCharacterFlag:
    ORA $0B56
    STA $0B56              ; ask for another NMI pass
FlashCharacterEnd:
    RTS
