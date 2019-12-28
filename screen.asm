#importonce
#import "math.asm"
#import "memory.asm"



// -----------------------
// MACROS
// -----------------------

* = * "Screen Routines"

.macro print(stringAddr) {
                lda #<stringAddr // Low byte
                ldx #>stringAddr // High byte
                jsr Screen.print
}

.macro cPrint() {
                jsr Screen.printPetChar
}

.macro ClearChunks(baseAddress, clearByte) {
                lda     #clearByte
                ldx     #0
        !loop:
                sta     baseAddress, x
                sta     baseAddress + $100, x
                sta     baseAddress + $200, x
                sta     baseAddress + $300, x
                inx
                bne.r   !loop-
}


.macro ClearScreen(clearByte) {
                ClearChunks(Screen.VIDEO_ADDR, clearByte)
}

.macro ClearColorRam(clearByte) {
                ClearChunks(Screen.COLOR_ADDR, clearByte)
}

.macro SetBorderColor(color) {
                lda     #color
                sta     $d020
}

.macro SetBackgroundColor(color) {
                lda     #color
                sta     $d021
}

.macro SetMultiColor1(color) {
                lda     #color
                sta     $d022
}

.macro SetMultiColor2(color) {
                lda     #color
                sta     $d023
}

.macro SetMultiColorMode() {
                lda	$d016
                ora	#16
                sta	$d016
}

.macro SetScrollMode() {
                lda     $D016
                eor     #%00001000
                sta     $D016
}

.filenamespace Screen


//------------------------------------------------------------------------------------
// CONSTANTS
//------------------------------------------------------------------------------------
.label  VIDEO_ADDR      = $0400
.label  COLOR_ADDR      = $D800
.label  COLUMN_NUM      = 40
.label  ROWS_NUM        = 25
.label  CR              = $8e
.label  BS              = $95




//------------------------------------------------------------------------------------
init: {
                lda     #$00
                sta     MemMap.SCREEN.CursorCol
                sta     MemMap.SCREEN.CursorRow
                rts
}

//------------------------------------------------------------------------------------
scrollUp: {
                pha
                clone(VIDEO_ADDR+40, VIDEO_ADDR+(COLUMN_NUM*(ROWS_NUM)), VIDEO_ADDR)

                // clear last line
                lda     #32
                ldx     #40
        !:
                sta     VIDEO_ADDR+(COLUMN_NUM*(ROWS_NUM-1)), x
                dex
                bpl     !-                                                  // x == -1
                dec     MemMap.SCREEN.CursorRow
                pla
                rts
}

//------------------------------------------------------------------------------------
printPetChar: {
                pha
                stx     MemMap.SCREEN.PrintPetCharX
                sty     MemMap.SCREEN.PrintPetCharY
                jsr     Screen.petToScreen
                jsr     Screen.printChar
                ldy     MemMap.SCREEN.PrintPetCharY
                ldx     MemMap.SCREEN.PrintPetCharX
                pla
                rts
}

//------------------------------------------------------------------------------------
printChar: {
                sei
                stx     MemMap.SCREEN.tempX
                cmp     #CR
                bne.r   !+
                jsr     screenNewLine
                iny
                jmp     exit
        !:
                cmp     #BS
                bne.r   !+
                ldx     MemMap.SCREEN.CursorCol
                cmp     #0
                beq     exit
                dec     MemMap.SCREEN.CursorCol
        !:
                // Store Base Video Address 16 bit
                ldx     #<VIDEO_ADDR         // Low byte
                stx     MemMap.SCREEN.TempVideoPointer
                ldx     #>VIDEO_ADDR         // High byte
                stx     MemMap.SCREEN.TempVideoPointer+1

                // Temp Save Y
                sty     MemMap.SCREEN.tempY

                //  CursorRow * 40
                ldy     MemMap.SCREEN.CursorRow
                sty     MemMap.MATH.factor1
                ldy     #COLUMN_NUM
                sty     MemMap.MATH.factor2
                jsr     Math.multiply

                //  Add mul result to TempVideoPointer
                clc
                pha
                lda     MemMap.MATH.result
                adc     MemMap.SCREEN.TempVideoPointer+1
                sta     MemMap.SCREEN.TempVideoPointer+1
                lda     MemMap.MATH.result+1
                adc     MemMap.SCREEN.TempVideoPointer
                sta     MemMap.SCREEN.TempVideoPointer

                ldy     MemMap.SCREEN.CursorCol
                cpy     #COLUMN_NUM                     // Is this > col num?
                bcc.r   noEndOfLine
                jsr     screenNewLine                   // Yes? Add new list first

                ldy     #1
                cpy     MemMap.SCREEN.ScrollUpTriggered
                bne     noScrollTriggered

                // Compensate Scroll
                sec
                lda     MemMap.SCREEN.TempVideoPointer
                sbc     #1
                sta     MemMap.SCREEN.TempVideoPointer
                bcs     !+
                dec     MemMap.SCREEN.TempVideoPointer+1
        !:

//------------------------------------------------------------------------------------
noScrollTriggered:
noEndOfLine:
                pla

                // This is a backspace
                cmp     #BS
                        bne !+
                        lda     #' '
                sta     (MemMap.SCREEN.TempVideoPointer), y
                jmp     exit

        !:
                // insert into screen
                sta     (MemMap.SCREEN.TempVideoPointer), y
                ldy     MemMap.SCREEN.tempY
                iny
                inc     MemMap.SCREEN.CursorCol

        exit:
                ldx     MemMap.SCREEN.tempX
                cli
                rts
}


//   ——————————————————————————————————————————————————————
//   print
//   ——————————————————————————————————————————————————————
//   ——————————————————————————————————————————————————————
//   preparatory ops: .a: low byte string address
//                    .x: high byte string address
//
//   returned values: none
//   ——————————————————————————————————————————————————————
print: {
                        ldy     #$00
                        sta     MemMap.SCREEN.TempStringPointer
                        stx     MemMap.SCREEN.TempStringPointer+1
        printLoop:
                        lda     (MemMap.SCREEN.TempStringPointer), y
                        cmp     #0
                        beq     exit
                        jsr     Screen.printChar
                        jmp     printLoop
        exit:
                        rts
}



//------------------------------------------------------------------------------------
screenNewLine: {
                        pha
                        lda     #0
                        sta     MemMap.SCREEN.CursorCol
                        lda     #ROWS_NUM-1
                        cmp     MemMap.SCREEN.CursorRow         // Are we at the screen bottom?
                        bne     noScrollUp
                        jsr     Screen.scrollUp
                        lda     #1                              // Yes - Scroll up
                        sta     MemMap.SCREEN.ScrollUpTriggered
                        jmp     done
        noScrollUp:
                        lda     #0
                        sta     MemMap.SCREEN.ScrollUpTriggered
        done:
                        inc     MemMap.SCREEN.CursorRow
                        pla
                        rts
}


//   ————————————————————————————————————————
//   petToScreen
//   ————————————————————————————————————————
//   ————————————————————————————————————————
//   preparatory ops: .a: pet byte to convert
//
//   returned values: .a: conv SCREEN char
//   ————————————————————————————————————————
petToScreen: {
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

#import "mem_map.asm"
