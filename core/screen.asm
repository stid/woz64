#importonce
#import "../libs/math.asm"
#import "../libs/memory.asm"
#import "../libs/module.asm"

// ------------------------------------
//     MACROS
// ------------------------------------

* = * "Screen Module"

.macro ScreenClearChunks(baseAddress, clearByte) {
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


.macro ScreenClear(clearByte) {
                ScreenClearChunks(Screen.VIDEO_ADDR, clearByte)
}

.macro ScreenClearColorRam(clearByte) {
                ScreenClearChunks(Screen.COLOR_ADDR, clearByte)
}

.macro ScreenSetBorderColor(color) {
                lda     #color
                sta     $d020
}

.macro ScreenSetBackgroundColor(color) {
                lda     #color
                sta     $d021
}

.macro ScreenSetMultiColor1(color) {
                lda     #color
                sta     $d022
}

.macro ScreenSetMultiColor2(color) {
                lda     #color
                sta     $d023
}

.macro ScreenSetMultiColorMode() {
                lda	$d016
                ora	#16
                sta	$d016
}

.macro ScreenSetScrollMode() {
                lda     $D016
                eor     #%00001000
                sta     $D016
}

.filenamespace Screen


// ------------------------------------
//     COSTANTS
// ------------------------------------
.label  VIDEO_ADDR      = $0400
.label  COLOR_ADDR      = $D800
.label  COLUMN_NUM      = 40
.label  ROWS_NUM        = 25
.label  CR              = $8e
.label  BS              = $95


// ------------------------------------
//     METHODS
// ------------------------------------

//------------------------------------------------------------------------------------
init: {
                lda     #$00
                sta     MemMap.SCREEN.CursorCol
                sta     MemMap.SCREEN.CursorRow
                rts
}

toDebug: {
                    ModuleDefaultToDebug(module_name, version)
                    rts
}

//------------------------------------------------------------------------------------
scrollUp: {
                pha
                MemoryClone(VIDEO_ADDR+40, VIDEO_ADDR+(COLUMN_NUM*(ROWS_NUM)), VIDEO_ADDR)

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
sendChar: {
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

        noScrollTriggered:
        noEndOfLine:
                pla

                // This is a backspace
                cmp     #BS
                        bne     !+
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


* = * "Screen Module Data"
version:    .byte 1, 0, 0
module_name:
        .text "core:screen"
        .byte 0

#import "../core/mem_map.asm"
