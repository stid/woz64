#importonce
#import "../libs/math.asm"
#import "../libs/memory.asm"
#import "../core/module.asm"
#import "../core/pseudo.asm"


// ========================================================
// ////// MACROS //////////////////////////////////////////
// ========================================================

* = * "Device: Video"

// --------------------------------------------------------
// VideoClearChunks -
// Fast clear screen mem chunks.
//
// Parameters:
//      baseAddress      = Pointer to screen orcolor map Address
//      clearByte        = Byte to use to clear screen
// --------------------------------------------------------
.macro VideoClearChunks(baseAddress, clearByte) {
                lda     #clearByte
                ldx     #0
        !loop:
                sta     baseAddress, x
                sta     baseAddress + $100, x
                sta     baseAddress + $200, x
                sta     baseAddress + $300, x
                inx
                bne     !loop-
}



// --------------------------------------------------------
// VideoClear -
// Fast clear screen characters mem.
//
// Parameters:
//      clearByte        = Byte to use to clear screen
// --------------------------------------------------------
.macro VideoClear(clearByte) {
                VideoClearChunks(Video.VIDEO_ADDR, clearByte)
}

// --------------------------------------------------------
// VideoClear -
// Fast clear screen Color Ram.
//
// Parameters:
//      clearByte        = Byte to use to clear screen
// --------------------------------------------------------
.macro VideoClearColorRam(clearByte) {
                VideoClearChunks(Video.COLOR_ADDR, clearByte)
}

// --------------------------------------------------------
// VideoSetBorderColor -
// Set Video border color.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro VideoSetBorderColor(color) {
                lda     #color
                sta     $d020
}

// --------------------------------------------------------
// VideoSetBackgroundColor -
// Set Video Backfground color.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro VideoSetBackgroundColor(color) {
                lda     #color
                sta     $d021
}

// --------------------------------------------------------
// VideoSetMultiColor1 -
// Set Video Muticolor 1.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro VideoSetMultiColor1(color) {
                lda     #color
                sta     $d022
}

// --------------------------------------------------------
// VideoSetMultiColor2 -
// Set Video Muticolor 2.
//
// Parameters:
//      color        = https://www.c64-wiki.com/wiki/Color
// --------------------------------------------------------
.macro VideoSetMultiColor2(color) {
                lda     #color
                sta     $d023
}

// --------------------------------------------------------
// VideoSetMultiColorMode -
// Set Video Muticolor 2.
//
// Parameters:
//      color   = https://www.c64-wiki.com/wiki/Multicolor_Bitmap_Mode
// --------------------------------------------------------
.macro VideoSetMultiColorMode() {
                lda	$d016
                ora	#16
                sta	$d016
}

.filenamespace Video

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
                sta     MemMap.VIDEO.CursorCol
                sta     MemMap.VIDEO.CursorRow
                lda     #%00000000
                sta     MemMap.VIDEO.StatusBitsA
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
                dec     MemMap.VIDEO.CursorRow
                pla
                rts
}


// --------------------------------------------------------
// sendChar -
// Send a single char to the screen. Auto handle line feed,
// end of screen scrolling and Backspace.
//
// Parameters:
//      A       = Character to Print VIDEO ASCII
// --------------------------------------------------------
sendChar: {
                sei
                phx
                cmp     #CR
                bne     !+
                jsr     screenNewLine
                iny
                jmp     exit
        !:
                cmp     #BS
                bne     !+
                ldx     MemMap.VIDEO.CursorCol
                cmp     #0
                beq     exit
                dec     MemMap.VIDEO.CursorCol
        !:
                // Store Base Video Address 16 bit
                ldx     #<VIDEO_ADDR         // Low byte
                stx     MemMap.VIDEO.TempVideoPointer
                ldx     #>VIDEO_ADDR         // High byte
                stx     MemMap.VIDEO.TempVideoPointer+1

                // Temp Save Y
                phy

                //  CursorRow * 40
                ldy     MemMap.VIDEO.CursorRow
                sty     MemMap.MATH.factor1
                ldy     #COLUMN_NUM
                sty     MemMap.MATH.factor2
                jsr     Math.multiply

                //  Add mul result to TempVideoPointer
                pha

                clc
                lda     MemMap.MATH.result
                adc     MemMap.VIDEO.TempVideoPointer+1
                sta     MemMap.VIDEO.TempVideoPointer+1
                lda     MemMap.MATH.result+1
                adc     MemMap.VIDEO.TempVideoPointer
                sta     MemMap.VIDEO.TempVideoPointer

                ldy     MemMap.VIDEO.CursorCol
                cpy     #COLUMN_NUM                     // Is this > col num?
                bcc     noEndOfLine
                jsr     screenNewLine                   // Yes? Add new line first

                bitTest(%00000001, MemMap.VIDEO.StatusBitsA)
                bne     noScrollTriggered

                // Compensate Scroll
                sec
                lda     MemMap.VIDEO.TempVideoPointer
                sbc     #40
                sta     MemMap.VIDEO.TempVideoPointer
                bcs     !+
                dec     MemMap.VIDEO.TempVideoPointer+1
        !:

        noScrollTriggered:
        noEndOfLine:
                pla
                // This is a backspace
                cmp     #BS
                bne     !+
                lda     #' '
                sta     (MemMap.VIDEO.TempVideoPointer), y
                ply
                jmp     exit
        !:
                // insert into screen
                sta     (MemMap.VIDEO.TempVideoPointer), y
                ply
                iny
                inc     MemMap.VIDEO.CursorCol

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
                        sta     MemMap.VIDEO.CursorCol
                        lda     #ROWS_NUM-1
                        cmp     MemMap.VIDEO.CursorRow         // Are we at the screen bottom?
                        bne     noScrollUp
                        jsr     Video.scrollUp

                        bitSet(%00000001, MemMap.VIDEO.StatusBitsA)

                        jmp     done
        noScrollUp:

                        bitClear(%00000001, MemMap.VIDEO.StatusBitsA)
        done:
                        inc     MemMap.VIDEO.CursorRow
                        pla
                        rts
}

* = * "Device: Video Data"
module_type:            .byte Module.TYPES.DEVICE
version:                .byte 1, 0, 1
module_name:
        .text "video"
        .byte 0

#import "../hardware/mem_map.asm"
