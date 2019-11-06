#importonce
#import "math.asm"
#import "mem_map.asm"

// -----------------------
// MACROS
// -----------------------

.macro print(stringAddr) {
        lda #<stringAddr // Low byte
        ldx #>stringAddr // High byte
        jsr Screen.print
}

.macro ClearScreen(screen, clearByte) {
	lda #clearByte
	ldx #0
!loop:
	sta screen, x
	sta screen + $100, x
	sta screen + $200, x
	sta screen + $300, x
	inx
	bne !loop-
}

.macro ClearColorRam(clearByte) {
	lda #clearByte
	ldx #0
!loop:
	sta $D800, x
	sta $D800 + $100, x
	sta $D800 + $200, x
	sta $D800 + $300, x
	inx
	bne !loop-
}

.macro SetBorderColor(color) {
	lda #color
	sta $d020
}

.macro SetBackgroundColor(color) {
	lda #color
	sta $d021
}

.macro SetMultiColor1(color) {
	lda #color
	sta $d022
}

.macro SetMultiColor2(color) {
	lda #color
	sta $d023
}

.macro SetMultiColorMode() {
	lda	$d016
	ora	#16
	sta	$d016
}

.macro SetScrollMode() {
	lda $D016
	eor #%00001000
	sta $D016
}

.filenamespace Screen


// -----------------------
// CONSTANTS
// -----------------------

.namespace constants {
    .label  VIDEO_ADDR           = $0400
    .label  COLUMN_NUM           = 40
    .label  ROWS_NUM             = 25
}


// -----------------------
// CODE
// -----------------------

init: {
                lda #$00
                sta MemMap.SCREEN_SPACE.CursorCol
                sta MemMap.SCREEN_SPACE.CursorRow
                rts
}

printChar: {

                // New Line
                cmp #13
                bne.r !+
                jsr screenNewLine
                iny
                rts
!:
                // Store Base Video Address 16 bit
                ldx #<constants.VIDEO_ADDR         // Low byte
                stx MemMap.SCREEN_SPACE.TempVideoPointer
                ldx #>constants.VIDEO_ADDR         // High byte
                stx MemMap.SCREEN_SPACE.TempVideoPointer+1

                // Temp Save Y
                sty MemMap.SCREEN_SPACE.tempY

                //  CursorRow * 40
                ldy MemMap.SCREEN_SPACE.CursorRow
                sty MemMap.MATH_SPACE.factor1
                ldy #constants.COLUMN_NUM
                sty MemMap.MATH_SPACE.factor2
                jsr Math.multiply

                //  Add mul result to TempVideoPointer
                clc
                pha
                lda MemMap.MATH_SPACE.result
                adc MemMap.SCREEN_SPACE.TempVideoPointer+1
                sta MemMap.SCREEN_SPACE.TempVideoPointer+1
                lda MemMap.MATH_SPACE.result+1
                adc MemMap.SCREEN_SPACE.TempVideoPointer
                sta MemMap.SCREEN_SPACE.TempVideoPointer
                pla

                // Add column
                ldy MemMap.SCREEN_SPACE.CursorCol
                sta (MemMap.SCREEN_SPACE.TempVideoPointer), y

                ldy MemMap.SCREEN_SPACE.tempY
                iny

                inc MemMap.SCREEN_SPACE.CursorCol
                lda MemMap.SCREEN_SPACE.CursorCol
                cmp #constants.COLUMN_NUM+1
                bcc exita

                // CursorCol > COLUMN_NUM ? new line
                jsr screenNewLine
exita:
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
                ldy #$00
                sta MemMap.SCREEN_SPACE.TempStringPointer
                stx MemMap.SCREEN_SPACE.TempStringPointer+1
    printLoop:
                lda (MemMap.SCREEN_SPACE.TempStringPointer), y
                cmp #0
                beq exit
                jsr Screen.printChar
                jmp printLoop
    exit:
                rts
}

screenNewLine: {
                lda #0
                sta MemMap.SCREEN_SPACE.CursorCol
                inc MemMap.SCREEN_SPACE.CursorRow
                rts
}

