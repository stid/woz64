#importonce
#import "../core/module.asm"
#import "../libs/memory.asm"


.filenamespace Keyboard


// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================


.const CIA1_KeybWrite    = $DC00
.const CIA1_KeybRead     = $DC01

.const cSYS_DelayValue   = 32
.const cKeybW_Row1       = $FE

.const  RASTER_LINE     = $d012



* = * "Device: Keyboard"

// ========================================================
// ////// METHODS ROM /////////////////////////////////////
// ========================================================

// --------------------------------------------------------
// init -
// Module Init.
// --------------------------------------------------------
init: {
                lda     #64
                sta     MemMap.KEYBOARD.SYS_Lstx
                sta     MemMap.KEYBOARD.SYS_Sfdx

                lda     #cSYS_DelayValue
                sta     MemMap.KEYBOARD.SYS_Delay

                lda     #6
                sta     MemMap.KEYBOARD.SYS_Kount

                lda     #0
                sta     MemMap.KEYBOARD.SYS_Shflag
                sta     MemMap.KEYBOARD.SYS_Lstshf

                sta     MemMap.KEYBOARD.SYS_Ndx

                lda     #10
                sta     MemMap.KEYBOARD.SYS_Xmax

                // Clone self altering Methods to RAM
                MemoryClone(cloneStart, cloneEnd, MemMap.KEYBOARD.keybRamCode)
                rts
}

// --------------------------------------------------------
// waitForKey -
// Loop until a new key is available.
//
// Result:
//      A       = Pressed key code
// --------------------------------------------------------
waitForKey: {
        loop:
                lda     #$FF
        raster:
                cmp     RASTER_LINE         // Raster done?
                bne     raster
                jsr     Keyboard.ReadKeyb
                jsr     Keyboard.GetKey
                bcs     loop
                rts
}

// --------------------------------------------------------
// toDebug -
// Print debug info.
// --------------------------------------------------------
toDebug: {
                ModuleToDebug(module_type, module_name, version)
                rts
}

// ========================================================
// ////// KEYMAPPING ROM //////////////////////////////////
// ========================================================

KeyMapVec:
        .word KeyMap1, KeyMap2, KeyMap3, KeyMap4

// Unshifted
KeyMap1:
        .byte $14, $0D, $1D, $88, $85, $86, $87, $11
        .byte $33, $57, $41, $34, $5A, $53, $45, $01
        .byte $35, $52, $44, $36, $43, $46, $54, $58
        .byte $37, $59, $47, $38, $42, $48, $55, $56
        .byte $39, $49, $4A, $30, $4D, $4B, $4F, $4E
        .byte $2B, $50, $4C, $2D, $2E, $3A, $40, $2C
        .byte $5C, $2A, $3B, $13, $01, $3D, $5E, $2F
        .byte $31, $5F, $04, $32, $20, $02, $51, $03
        .byte $FF

// Shifted
KeyMap2:
        .byte $94, $8D, $9D, $8C, $89, $8A, $8B, $91
        .byte $23, $D7, $C1, $24, $DA, $D3, $C5, $01
        .byte $25, $D2, $C4, $26, $C3, $C6, $D4, $D8
        .byte $27, $D9, $C7, $28, $C2, $C8, $D5, $D6
        .byte $29, $C9, $CA, $30, $CD, $CB, $CF, $CE
        .byte $DB, $D0, $CC, $DD, $3E, $5B, $BA, $3C
        .byte $A9, $C0, $5D, $9e, $01, $3D, $DE, $3F
        .byte $21, $5F, $04, $22, $A0, $02, $D1, $83
        .byte $FF

// Commodore
KeyMap3:
        .byte $94, $8D, $9D, $8C, $89, $8A, $8B, $91
        .byte $96, $B3, $B0, $97, $AD, $AE, $B1, $01
        .byte $98, $B2, $AC, $99, $BC, $BB, $A3, $BD
        .byte $9A, $B7, $A5, $9B, $BF, $B4, $B8, $BE
        .byte $29, $A2, $B5, $30, $A7, $A1, $B9, $AA
        .byte $A6, $AF, $B6, $DC, $3E, $5B, $A4, $3C
        .byte $A8, $DF, $5D, $93, $01, $3D, $DE, $3F
        .byte $81, $5F, $04, $95, $A0, $02, $AB, $83
        .byte $FF

// Control
KeyMap4:
        .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
        .byte $1C, $17, $01, $9F, $1A, $13, $05, $FF
        .byte $9C, $12, $04, $1E, $03, $06, $14, $18
        .byte $1F, $19, $07, $9E, $02, $08, $15, $16
        .byte $12, $09, $0A, $92, $0D, $0B, $0F, $0E
        .byte $FF, $10, $0C, $FF, $FF, $1B, $00, $FF
        .byte $1C, $FF, $1D, $FF, $FF, $1F, $1E, $FF
        .byte $90, $06, $FF, $05, $FF, $FF, $11, $FF
        .byte $FF


// ========================================================
// ////// METHODS RAM /////////////////////////////////////
// ========================================================

* = * "Keyboard Ram"

cloneStart:
// Code between cloneStart & cloneEnd is cloned in RAM
// at Init time. The logic alter the code itself for
// performance and so can't be executed directly in ROM.
// See .pseudopc $1000 directive below.


// --------------------------------------------------------
// ReadKeyb -
// Read Keyboard input - if any- should be called in a loop
// getKey should be used after to chek if and what key was
// pressed.
//
// Example:
//        loop:
//                jsr Keyboard.ReadKeyb
//                jsr Keyboard.GetKey
//                bcs loop
//               // Key here is in A
// --------------------------------------------------------
.pseudopc MemMap.KEYBOARD.keybRamCode {
ReadKeyb: {
                lda     #<KeyMap1
                sta     @SMC_Vec
                lda     #>KeyMap1
                sta     @SMC_Vec + 1

                // Clear Shift Flag
                lda     #$40
                sta     MemMap.KEYBOARD.SYS_Sfdx

                lda     #0
                sta     MemMap.KEYBOARD.SYS_Shflag

                sta     CIA1_KeybWrite
                ldx     CIA1_KeybRead
                cpx     #$FF
                beq     @Cleanup

                ldy     #$00

                lda     #7
                sta     MemMap.KEYBOARD.KeyR

                lda     #cKeybW_Row1
                sta     @SMC_Row + 1
        @SMC_Row:
                lda     #0

                sta     CIA1_KeybWrite

        @Loop_Debounce:
                lda     CIA1_KeybRead
                cmp     CIA1_KeybRead
                bne     @Loop_Debounce

                ldx     #7
        @Loop_Col:
                lsr
                bcs     @NextKey
                sta     @SMC_A + 1

                lda     @SMC_Vec:$FFFF,Y

                // If <4 then is Stop or a Shift Key
                cmp     #$05
                bcs     @NotShift // Not Shift

                cmp     #$03
                beq     @NotShift // Stop Key

                // Accumulate shift key types (SHIFT=1, COMM=2, CTRL=4)
                ora     MemMap.KEYBOARD.SYS_Shflag
                sta     MemMap.KEYBOARD.SYS_Shflag
                bpl     @SMC_A

        @NotShift:
                sty     MemMap.KEYBOARD.SYS_Sfdx

        @SMC_A:
                lda     #0

        @NextKey:
                iny
                dex
                bpl     @Loop_Col

                sec
                rol     @SMC_Row + 1
                dec     MemMap.KEYBOARD.KeyR
                bpl     @SMC_Row

                jmp     @ProcKeyImg

// Handles the key repeat
        @Process:
                ldy     MemMap.KEYBOARD.SYS_Sfdx
        @SMC_Key:
                lda     $FFFF,Y
                tax
                cpy     MemMap.KEYBOARD.SYS_Lstx
                beq     @SameKey

                ldy     #cSYS_DelayValue
                sty     MemMap.KEYBOARD.SYS_Delay     // Repeat delay counter
                bne     @Cleanup

        @SameKey:
                and     #$7F
                ldy     MemMap.KEYBOARD.SYS_Delay
                beq     @EndDelay
                dec     MemMap.KEYBOARD.SYS_Delay
                bne     @Exit

        @EndDelay:
                dec     MemMap.KEYBOARD.SYS_Kount
                bne     @Exit

                ldy     #$04
                sty     MemMap.KEYBOARD.SYS_Kount
                ldy     MemMap.KEYBOARD.SYS_Ndx
                dey
                bpl     @Exit

// Updates the previous key and shift storage
        @Cleanup:
                ldy     MemMap.KEYBOARD.SYS_Sfdx
                sty     MemMap.KEYBOARD.SYS_Lstx
                ldy     MemMap.KEYBOARD.SYS_Shflag
                sty     MemMap.KEYBOARD.SYS_Lstshf

                cpx     #$FF
                beq     @Exit
                txa
                ldx     MemMap.KEYBOARD.SYS_Ndx
                cpx     MemMap.KEYBOARD.SYS_Xmax
                bcs     @Exit

                sta     MemMap.KEYBOARD.SYS_Keyd,X
                inx
                stx     MemMap.KEYBOARD.SYS_Ndx

        @Exit:
                lda     #$7F
                sta     CIA1_KeybWrite
                rts

        @ProcKeyImg:
                lda     MemMap.KEYBOARD.SYS_Shflag
                cmp     #$03 // C= + SHIFT
                bne     @SetDecodeTable
                cmp     MemMap.KEYBOARD.SYS_Lstshf
                beq     @Exit

        @SetDecodeTable:
                asl
                cmp     #8   // CONTROL
                bcc     @Cont
                lda     #$06
        @Cont:  tax
                lda     KeyMapVec,X
                sta     @SMC_Key + 1
                lda     KeyMapVec + 1,X
                sta     @SMC_Key + 2
                jmp     @Process
}

// --------------------------------------------------------
// GetKey -
// Get latest pressed key - if any. Should be used in
// conjuction with ReadKeyb.
//
// Result:
//      A       = Pressed key code or 0
// --------------------------------------------------------
GetKey: {

                lda     MemMap.KEYBOARD.SYS_Ndx
                bne     @IsKey

        @NoKey:
                lda     #255 // Null
                sec
                rts

        @IsKey:
                ldy     MemMap.KEYBOARD.SYS_Keyd
                ldx     #0
        @Loop:
                lda     MemMap.KEYBOARD.SYS_Keyd + 1,X
                sta     MemMap.KEYBOARD.SYS_Keyd,X
                inx
                cpx     MemMap.KEYBOARD.SYS_Ndx
                bne     @Loop
                dec     MemMap.KEYBOARD.SYS_Ndx
                tya
                clc
                rts

}}

* = * "Keyboard Ram End"

cloneEnd:

// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Device: Keyboard Data"
module_type:    .byte   Module.TYPES.DEVICE
version:        .byte   1, 1, 0

.encoding "screencode_mixed"
module_name:
                .text   "keyboard"
                .byte   0


#import "../hardware/mem_map.asm"

