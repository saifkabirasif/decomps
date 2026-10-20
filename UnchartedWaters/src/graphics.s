;
; Uncharted Waters (USA) - graphics mode updates
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8636-$8828).
;
; $0B74 selects what has to happen this frame:
;
;   0    a single pair of HDMA transfers
;   1    a block of tiles written through the transfer engine
;   2    the HDMA transfer repeated $0B77 times
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8636
    .ACCU 8
    .INDEX 16

; ---------------------------------------------------------------------------
; $8636: dispatch the pending graphics update
; ---------------------------------------------------------------------------
UpdateGraphics:
    REP #$10
    SEP #$20
    LDA $0B74
    LSR A
    BCS UpdateGraphicsTiles
    LDA $0B74
    CMP #$02
    BEQ UpdateGraphicsLoop
    PHP
    JSR SetupHdmaTransfer
    PLP
    BRA UpdateGraphicsDone
UpdateGraphicsLoop:
    PHP
    JSR SetupHdmaTransferLoop
    PLP
    BRA UpdateGraphicsDone
UpdateGraphicsTiles:
    PHP
    JSR WriteVramBlocks
    PLP
UpdateGraphicsDone:
    STZ $0B74
    RTS

; ---------------------------------------------------------------------------
; $865E: set up the two HDMA channels and run them
; ---------------------------------------------------------------------------
SetupHdmaTransfer:
    REP #$10
    SEP #$20
    LDA #$00
    STA $2115              ; VRAM address increment
    LDX $0B7B
    STX $2116              ; VRAM address
    LDX #$1808
    STX $4310              ; HDMA channel 1: mode and A bus
    LDX #$0B7D
    STX $4312              ; source address
    STZ $4314              ; source bank
    LDX #$0400
    STX $4315              ; size
    LDA #$02
    STA $420B              ; run HDMA channel 1
    LDA #$80
    STA $2115              ; VRAM address increment
    STX $4315              ; size
    LDX $0B7B
    STX $2116              ; VRAM address
    LDX #$1908
    STX $4310              ; HDMA channel 2: mode and A bus
    LDX #$0B7E
    STX $4312              ; source address
    STZ $4314              ; source bank
    LDA #$02
    STA $420B              ; run HDMA channel 2
    RTS

; ---------------------------------------------------------------------------
; $86AA: the same transfer, repeated $0B77 times
; ---------------------------------------------------------------------------
SetupHdmaTransferLoop:
    REP #$10
    SEP #$20
    LDY $0B77
    LDX $0B7B
    STX $0B79
SetupHdmaTransferLoopBody:
    SEP #$20
    LDA #$00
    STA $2115              ; VRAM address increment
    LDX $0B79
    STX $2116              ; VRAM address
    LDX #$1808
    STX $4310              ; HDMA channel 1: mode and A bus
    LDX #$0B7D
    STX $4312              ; source address
    STZ $4314              ; source bank
    LDX $0B75
    STX $4315              ; size
    LDA #$02
    STA $420B              ; run HDMA channel 1
    LDA #$80
    STA $2115              ; VRAM address increment
    STX $4315              ; size
    LDX $0B79
    STX $2116              ; VRAM address
    LDX #$1908
    STX $4310              ; HDMA channel 2: mode and A bus
    LDX #$0B7E
    STX $4312              ; source address
    STZ $4314              ; source bank
    LDA #$02
    STA $420B              ; run HDMA channel 2
    NOP
    DEY
    BEQ SetupHdmaTransferLoopEnd
    REP #$20
    LDA $0B79
    CLC
    ADC #$0020
    STA $0B79              ; next column
    BRA SetupHdmaTransferLoopBody
SetupHdmaTransferLoopEnd:
    RTS

; ---------------------------------------------------------------------------
; $8713: write $0B77 blocks of tiles into the VRAM
; ---------------------------------------------------------------------------
WriteVramBlocks:
    REP #$10
    SEP #$20
    LDA $0E19
    BEQ WriteVramBlocksInc
    LDA #$81
    JMP WriteVramBlocksStore
WriteVramBlocksInc:
    LDA #$80
WriteVramBlocksStore:
    STA $2115              ; VRAM address increment
    LDX $0B7B
    STX $0B79
    STX $30
    LDY $0B77
    REP #$20
    LDA $0B75
    ASL A
    STA $0B75              ; size in bytes
    LDA #$4300
    STA $38                ; DMA channel 0
WriteVramBlocksLoop:
    SEP #$20
    LDX #$1801
    STX $0B20              ; DMA mode and A bus: VRAM data
    LDX $3A
    STX $0B22              ; source address
    LDA $3C
    STA $0B24              ; source bank
    LDX $0B75
    STX $0B25              ; size
    LDX $30
    STX $2116              ; VRAM address
    LDA #$01
    STA $4C
    JSR $8512
    DEY
    BEQ WriteVramBlocksDone
    BMI WriteVramBlocksDone
    REP #$20
    LDA $3A
    CLC
    ADC $0B75
    STA $3A                ; next source
    BCC WriteVramBlocksNext
    ORA #$8000
    STA $3A
    SEP #$20
    INC $3C                ; the source crossed the $8000 boundary
    REP #$20
WriteVramBlocksNext:
    LDA $0B79
    CLC
    ADC #$0001
    STA $0B79              ; next column
    SEP #$20
    LDA $0E19
    BNE WriteVramBlocksCopy
    REP #$20
    LDA $0B79
    CLC
    ADC #$001F
    STA $0B79
WriteVramBlocksCopy:
    REP #$20
    LDA $0B79
    STA $30
    BRA WriteVramBlocksLoop
WriteVramBlocksDone:
    SEP #$20
    LDA $0DD8
    BEQ WriteVramBlocksEnd
    STZ $0B74
WriteVramBlocksEnd:
    RTS

; ---------------------------------------------------------------------------
; $87B0: the same, but into the OAM
; ---------------------------------------------------------------------------
WriteOamBlocks:
    REP #$10
    SEP #$20
    LDA #$80
    STA $2115
    LDX $0B7B
    STX $0B79
    STX $30
    LDY $0B77
    REP #$20
    LDA $0B75
    ASL A
    STA $0B75              ; size in bytes
    LDA #$4300
    STA $38                ; DMA channel 0
WriteOamBlocksLoop:
    SEP #$20
    LDX #$3981
    STX $0B20              ; DMA mode and A bus: OAM data
    LDX $3A
    STX $0B22              ; source address
    LDA $3C
    STA $0B24              ; source bank
    LDX $0B75
    STX $0B25              ; size
    LDX $30
    STX $2116
    LDA #$01
    STA $4C
    LDA $213A
    JSR $8512
    DEY
    BEQ WriteOamBlocksDone
    BMI WriteOamBlocksDone
    REP #$20
    LDA $3A
    CLC
    ADC $0B75
    STA $3A                ; next source
    BCC WriteOamBlocksNext
    ORA #$8000
    STA $3A
    SEP #$20
    INC $3C                ; the source crossed the $8000 boundary
    REP #$20
WriteOamBlocksNext:
    LDA $0B79
    CLC
    ADC #$0020
    STA $0B79              ; next column
    STA $30
    BRA WriteOamBlocksLoop
WriteOamBlocksDone:
    SEP #$20
    STZ $0B74
    RTS
