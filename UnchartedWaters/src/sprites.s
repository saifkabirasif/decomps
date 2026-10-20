;
; Uncharted Waters (USA) - sprite (OAM), palette (CGRAM) and tile uploads
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8430-$8511).
;
; The three routines here only fill in a DMA descriptor at $0B20-$0B27 and
; then hand over to the transfer engine at $8512, which works out how the
; block has to be split to stay inside the $8000-$FFFF window of VRAM.
;
;   $0B20  DMA mode register ($43x0)
;   $0B21  A bus destination ($43x1): $18 = VRAM, $22 = CGRAM, $39 = OAM
;   $0B22  source address ($43x2/$43x3)
;   $0B24  source bank ($43x4)
;   $0B25  transfer size ($43x5/$43x6)
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8430
    .ACCU 8               ; the NMI handler leaves the accumulator 8 bit wide
    .INDEX 16              ; and the index registers 16 bit wide

; ---------------------------------------------------------------------------
; $8430: copy the 544 byte OAM buffer at $0900 into the OAM
; ---------------------------------------------------------------------------
UploadOam:
    REP #$10
    SEP #$20
    LDX #$4300
    STX $38                ; DMA channel the descriptor is written to
    STZ $2102              ; OAM address = 0
    STZ $0B20              ; DMA mode: general purpose
    LDA #$04
    STA $0B21              ; A bus destination
    LDX #$0900
    STX $0B22              ; source address
    STZ $0B24              ; source bank
    LDX #$0220
    STX $0B25              ; 544 bytes = 128 sprites
    JSR $8512
    RTS

; ---------------------------------------------------------------------------
; $8457: copy a palette block into the CGRAM
; ---------------------------------------------------------------------------
UploadCgram:
    REP #$10
    SEP #$20
    LDX #$4310
    STX $38                ; DMA channel 1
    LDA $0B4A
    STA $30
    STZ $31
    STA $2121              ; CGRAM write address
    STZ $0B20              ; DMA mode: general purpose
    LDA #$22
    STA $0B21              ; A bus destination: CGRAM data
    LDX $0B4B
    STX $0B22              ; source address
    LDA $0B4D
    STA $0B24              ; source bank
    LDX $0B4E
    STX $0B25              ; transfer size
    JSR $8512
    RTS

; ---------------------------------------------------------------------------
; $8488: copy a block of tiles into the VRAM
;
; The destination is a list of $0800 byte rows; when the last row only
; partly fits, $0B6D keeps the remainder so that the next call can finish
; it off.
; ---------------------------------------------------------------------------
UploadVram:
    SEP #$20
    REP #$10
    LDX #$4300
    STX $38                ; DMA channel 0
    LDX $0B72
    STX $30
    STX $2116              ; VRAM write address
    LDA #$80
    STA $2115              ; VRAM address increment
    LDA $0B57
    STA $0B20              ; DMA mode
    BMI UploadVramOam
    LDA #$18
    BRA UploadVramDest
UploadVramOam:
    LDA $213A
    LDA #$39
UploadVramDest:
    STA $0B21              ; A bus destination
    LDX $0B6F
    STX $0B22              ; source address
    LDA $0B71
    STA $0B24              ; source bank
    REP #$20
    LDA $0B6D
    CMP #$0800
    BCC UploadVramWrap
    SEC
    SBC #$0800
    STA $0B6D
    LDA #$0800
    BRA UploadVramSize
UploadVramWrap:
    LDX #$0000
    STX $0B6D
UploadVramSize:
    STA $0B25              ; transfer size
    CLC
    LDA $0B72
    ADC #$0400
    STA $0B72              ; next row
    CLC
    LDA $0B6F
    ADC #$0800
    BCC UploadVramSource
    CLC
    ADC #$8000
    PHA
    PHP
    SEP #$20
    INC $0B71              ; the source crossed the $8000 boundary
    PLP
    PLA
UploadVramSource:
    STA $0B6F
    SEP #$20
    LDA #$01
    STA $4C
    JSR $8512
    LDX $0B6D
    BNE UploadVramDone
    STZ $0B57
UploadVramDone:
    RTS
