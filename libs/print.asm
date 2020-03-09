
#importonce
#import "math.asm"
#import "../devices/video.asm"
#import "../core/module.asm"


// ========================================================
// ////// MACROS //////////////////////////////////////////
// ========================================================

.macro PrintLine(stringAddr) {
                lda     #<stringAddr // Low byte
                ldx     #>stringAddr // High byte
                jsr     Print.printLine
}

.macro PrintChar() {
                jsr     Print.printPetChar
}

.macro PrintNewLine() {
                jsr     Video.screenNewLine
}


.filenamespace Print

* = * "Print Lib"

// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


// --------------------------------------------------------
// init -
// Module Init.
// --------------------------------------------------------
init: {
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

// --------------------------------------------------------
// printPetChar -
// Convert a Char from PET ASCII and print it out on Video
//
// Parameters:
//      A       = PET ASCII char to print
// --------------------------------------------------------
printPetChar: {
                phr
                jsr     Print.petCharToVideoChar
                jsr     Video.sendChar
                plr
                rts
}

// --------------------------------------------------------
// printLine -
// Print a Null terminated VIDEO ASCII string to screen.
//
// Parameters:
//      A       = low byte string address
//      X       = low byte string address
// --------------------------------------------------------
printLine: {
                ldy     #$00
                sta     MemMap.PRINT.TempStringPointer
                stx     MemMap.PRINT.TempStringPointer+1
        printLoop:
                lda     (MemMap.PRINT.TempStringPointer), y
                cmp     #0
                beq     exit
                jsr     Video.sendChar
                jmp     printLoop
        exit:
                rts
}

// --------------------------------------------------------
// byteToHex -
// Convert a byte to an HEX value
//
// Parameters:
//      Y       = Byte to Convert
//
// Result:
//      A       = msn ascii char result
//      X       = lns ascii char result
// --------------------------------------------------------
byteToHex:      {
                pha
                jsr !+
                tax
                pla
                lsr
                lsr
                lsr
                lsr

        !:	and #$0f
                cmp #$0a
                bcc !+
                adc #6

        !:	adc #'0'
                rts
}

// --------------------------------------------------------
// petCharToVideoChar -
// Convert a PET ASCII Char to a VIDEO ASCII Char
//
// Parameters:
//      A       = PET ASCII Byte to Convert
//
// Result:
//      A       = Converted ASCII VIDEO Char
// --------------------------------------------------------
petCharToVideoChar: {
        // $00-$1F
                cmp     #$1f
                bcs     !+
                sec
                adc     #128
                jmp     convDone
        // $20-$3F
        !:
                cmp     #$3f
                bcs     !+
                jmp     convDone
        // $40-$5F
        !:
                cmp     #$5f
                bcs     !+
                sec
                sbc     #$40
                jmp     convDone
        // $60-$7F
        !:
                cmp     #$7F
                bcs     !+
                sec
                sbc     #32
                jmp     convDone
        // $80-$9F
        !:
                cmp     #$9F
                bcs     !+
                sec
                adc     #64
                jmp     convDone
        // $A0-$BF
        !:
                cmp     #$BF
                bcs     !+
                sec
                sbc     #64
                jmp     convDone
        // $C0-$DF
        // $E0-$FE
        !:
                cmp     #$FE
                bcs     !+
                sec
                sbc     #128
                jmp     convDone
        // $FF
        !:
                lda     $5E
        convDone:
                rts
}


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Print Lib Data"
module_type:    .byte   Module.TYPES.LIB
version:        .byte   1, 0, 0

.encoding       "screencode_mixed"
module_name:
                .text   "print"
                .byte   0

#import "../hardware/mem_map.asm"

