;
; Uncharted Waters (USA) - screen mode, arithmetic helpers and OAM uploads
;
; Lifted byte for byte from the original cartridge
; (bank $00, $8CD2-$8D4B).
;

.INCLUDE "snes_lorom.i"

.BANK 0 SLOT 0
.ORGA $8CD2
    .ACCU 8
    .INDEX 16

; ---------------------------------------------------------------------------
; $8CD2: switch the screen mode
; ---------------------------------------------------------------------------
SetScreenMode:
    REP #$10
    SEP #$20
    STA $0B3E
    STA $2100              ; INIDISP
    RTS

; ---------------------------------------------------------------------------
; $8CDD: multiply the accumulator by the multiplier
;
; Returns the product in A and the high word in $4216.
; ---------------------------------------------------------------------------
Multiply:
    REP #$30
    STA $4202              ; multiplier
    NOP
    NOP
    NOP
    NOP
    LDA $4216
    RTS

; ---------------------------------------------------------------------------
; $8CEA: divide X by the accumulator
;
; The quotient ends up in $0B58 and the remainder in $0B5A.
; ---------------------------------------------------------------------------
Divide:
    REP #$10
    SEP #$20
    STX $4204              ; dividend
    STA $4206              ; divisor
    LDA #$03
DivideWait:
    NOP
    DEA
    BNE DivideWait
    LDX $4214
    STX $0B58              ; quotient
    LDX $4216
    STX $0B5A              ; remainder
    RTS

; ---------------------------------------------------------------------------
; $8D07: multiply the accumulator by the multiplier, 8 bit version
; ---------------------------------------------------------------------------
MultiplyByte:
    REP #$10
    SEP #$20
MultiplyByteWait:
    LDA $4212
    LSR A
    BCS MultiplyByteWait
    LDX $4218
    STX $0B51              ; product
    LDX $421A
    STX $0B53
    RTS

; ---------------------------------------------------------------------------
; $8D1E: upload the OAM buffer at $0900
; ---------------------------------------------------------------------------
UploadOamDirect:
    REP #$10
    SEP #$20
    LDX #$4300
    STX $38
    STZ $2102
    STZ $0B20
    LDA #$04
    STA $0B21
    LDX #$0900
    STX $0B22
    STZ $0B24
    LDX #$0220
    STX $0B25
    LDA #$01
    STA $4C
    JSR $8512
    STZ $0B56
    RTS
