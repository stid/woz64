#importonce
#import "../libs/math.asm"
#import "../libs/memory.asm"
#import "../core/module.asm"
#import "../core/pseudo.asm"


// ========================================================
// ////// MACROS //////////////////////////////////////////
// ========================================================


* = * "Screen Lib"

// --------------------------------------------------------
// ScreenClearChunks -
// Fast clear screen mem chunks.
//
// Parameters:
//      baseAddress      = Pointer to screen orcolor map Address
//      clearByte        = Byte to use to clear screen
// --------------------------------------------------------
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


// --------------------------------------------------------
// ScreenClear -
// Fast clear screen characters mem.
//
// Parameters:
//      clearByte        = Byte to use to clear screen
// --------------------------------------------------------
.macro ScreenClear(clearByte) {
                ScreenClearChunks(Screen.VIDEO_ADDR, clearByte)
}

// --------------------------------------------------------
// ScreenClear -
// Fast clear screen Color Ram.
//
// Parameters:
//      clearByte        = Byte to use to clear screen
// --------------------------------------------------------
.macro ScreenClearColorRam(clearByte) {
                ScreenClearChunks(Screen.COLOR_ADDR, clearByte)
}

// --------------------------------------------------------
// ScreenSetBorderColor -
// Set Screen border color.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro ScreenSetBorderColor(color) {
                lda     #color
                sta     $d020
}

// --------------------------------------------------------
// ScreenSetBackgroundColor -
// Set Screen Backfground color.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro ScreenSetBackgroundColor(color) {
                lda     #color
                sta     $d021
}

// --------------------------------------------------------
// ScreenSetMultiColor1 -
// Set Screen Muticolor 1.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro ScreenSetMultiColor1(color) {
                lda     #color
                sta     $d022
}

// --------------------------------------------------------
// ScreenSetMultiColor2 -
// Set Screen Muticolor 2.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro ScreenSetMultiColor2(color) {
                lda     #color
                sta     $d023
}

// --------------------------------------------------------
// ScreenSetMultiColorMode -
// Set Screen Muticolor 2.
//
// Parameters:
//      color   = https://www.c64-wiki.com/wiki/Multicolor_Bitmap_Mode
// --------------------------------------------------------
.macro ScreenSetMultiColorMode() {
                lda	$d016
                ora	#16
                sta	$d016
}

.filenamespace Screen

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================

.label  VIDEO_ADDR      = $0400
.label  COLOR_ADDR      = $D800
.label  COLUMN_NUM      = 40
.label  ROWS_NUM        = 25
.label  CR              = $8e
.label  BS              = $95


// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


// --------------------------------------------------------
// init -
// Module Init.
// --------------------------------------------------------
init: {
                lda     #$00
                sta     MemMap.SCREEN.CursorCol
                sta     MemMap.SCREEN.CursorRow
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
// scrollUp -
// Scroll the entire screen UP - 1 line
// --------------------------------------------------------
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


// --------------------------------------------------------
// sendChar -
// Send a single char to the screen. Auto handle line feed,
// end of screen scrolling and Backspace.
//
// Parameters:
//      A       = Character to Print SCREEN ASCII
// --------------------------------------------------------
sendChar: {
                sei
                phx
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
                phy

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
                ply
                iny
                inc     MemMap.SCREEN.CursorCol

        exit:
                plx
                cli
                rts
}

// --------------------------------------------------------
// screenNewLine -
// Insert a New Line to screen - auto handle screen bottom
// linit scroll.
// --------------------------------------------------------
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

* = * "Screen Lib Data"
module_type:            .byte Module.TYPES.LIB
version:                .byte 1, 0, 0
module_name:
        .text "screen"
        .byte 0

#import "../core/mem_map.asm"
