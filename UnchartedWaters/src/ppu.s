;
; Uncharted Waters (USA) - PPU setup
;
; Ported byte for byte from the original cartridge (bank $00, $80A0-$818F).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0

; ---------------------------------------------------------------------------
; $80A0: reset every PPU register
; ---------------------------------------------------------------------------
.ORGA $80A0

PpuInit:
    REP #$10               ; 16 bit index registers
    SEP #$20               ; 8 bit accumulator

    LDA #$00
    STA $2101              ; OAM address
    STA $2102              ; OAM data
    STA $2103              ; OAM write address
    STA $2105              ; background mode
    STA $2106              ; mosaic
    STA $2107              ; BG1 screen base
    STA $2108              ; BG2 screen base
    STA $2109              ; BG3 screen base
    STA $210A              ; BG4 screen base
    STA $210B              ; BG1/BG2 tile data
    STA $210C              ; BG3/BG4 tile data
    STA $210D              ; OBJ tile data
    STA $210D
    STA $210E              ; BG1/BG2 tilemap
    STA $210E
    STA $210F              ; BG3/BG4 tilemap
    STA $210F
    STA $2110              ; BG1/BG2 character base
    STA $2110
    STA $2111              ; BG3/BG4 character base
    STA $2111
    STA $2112              ; BG3/BG4 character base
    STA $2112
    STA $2113              ; OBJ character base
    STA $2113
    STA $2114              ; BG tilemap increment
    STA $2114

    LDA #$80
    STA $2115              ; VRAM address increment
    STA $211A              ; VRAM latch and data
    STA $211B

    LDA #$01
    STA $211B

    LDA #$00
    STA $211C              ; VRAM address
    STA $211C
    STA $211D
    STA $211D
    STA $211E              ; horizontal scroll
    LDA #$01
    STA $211E
    LDA #$00
    STA $211F              ; vertical scroll
    STA $211F
    STA $2120              ; video mode
    STA $2120
    STA $2123              ; mode 7 matrix
    STA $2124
    STA $2125
    STA $2126
    STA $2127              ; window mask settings
    STA $2128
    STA $2129
    STA $212A
    STA $212B
    STA $212C
    STA $212D
    STA $212E
    STA $212F

    LDA #$30
    STA $2130              ; colour addition select
    STZ $2131              ; colour addition
    LDA #$E0
    STA $2132              ; colour maths
    LDA #$04
    STA $2133              ; screen mode
    LDX #$0000
    STA $4200              ; enable NMI

    LDA #$FF
    STA $4201              ; I/O port
    LDA #$00
    STA $4202
    STA $4203
    STA $4204
    STA $4205
    STA $4206
    STA $4207
    STA $4208
    STA $4209
    STA $420A
    STA $420D
    RTS
