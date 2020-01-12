
#importonce
#import "math.asm"
#import "../core/screen.asm"
#import "../libs/module.asm"

* = * "Print Lib"

// ------------------------------------
//     MACROS
// ------------------------------------
.macro PrintLine(stringAddr) {
                lda #<stringAddr // Low byte
                ldx #>stringAddr // High byte
                jsr Print.printLine
}

.macro PrintChar() {
                jsr Print.printPetChar
}

.macro PrintNewLine() {
                jsr Screen.screenNewLine
}


.filenamespace Print
// ------------------------------------
//     METHODS
// ------------------------------------

//------------------------------------------------------------------------------------
init: {
                rts
}

//------------------------------------------------------------------------------------
toDebug: {
                ModuleDefaultToDebug(module_name, version)
                rts
}

//------------------------------------------------------------------------------------
printPetChar: {
                pha
                stx     MemMap.SCREEN.PrintPetCharX
                sty     MemMap.SCREEN.PrintPetCharY
                jsr     Print.petCharToScreenChar
                jsr     Screen.sendChar
                ldy     MemMap.SCREEN.PrintPetCharY
                ldx     MemMap.SCREEN.PrintPetCharX
                pla
                rts
}

//   ——————————————————————————————————————————————————————
//   printLine
//   ——————————————————————————————————————————————————————
//   ——————————————————————————————————————————————————————
//   preparatory ops: .a: low byte string address
//                    .x: high byte string address
//
//   returned values: none
//   ——————————————————————————————————————————————————————
printLine: {
                        ldy     #$00
                        sta     MemMap.SCREEN.TempStringPointer
                        stx     MemMap.SCREEN.TempStringPointer+1
        printLoop:
                        lda     (MemMap.SCREEN.TempStringPointer), y
                        cmp     #0
                        beq     exit
                        jsr     Screen.sendChar
                        jmp     printLoop
        exit:
                        rts
}

//   ————————————————————————————————————
//   btohex
//   ————————————————————————————————————
//   ————————————————————————————————————
//   preparatory ops: .a: byte to convert
//
//   returned values: .a: msn ascii char
//                    .x: lsn ascii char
//                    .y: entry value
//   ————————————————————————————————————
byteToHex:      {
                    pha                   //save byte
                    and #%00001111        //extract lsn
                    tax                   //save it
                    pla                   //recover byte
                    lsr                   //extract...
                    lsr                   //msn
                    lsr
                    lsr
                    pha                   //save msn
                    txa                   //lsn
                    jsr binhex1           //generate ascii lsn
                    tax                   //save
                    pla                   //get msn & fall thru
    //
    //   convert nybble to hex ascii equivalent...
    binhex1:        cmp #$0a
                    bcc binhex2           //in decimal range
                    sbc #$09              //hex compensate
                    rts
    binhex2:        eor #%00110000        //finalize nybble
                    rts                   //done
}


//   ————————————————————————————————————————
//   petToScreen
//   ————————————————————————————————————————
//   ————————————————————————————————————————
//   preparatory ops: .a: pet byte to convert
//
//   returned values: .a: conv SCREEN char
//   ————————————————————————————————————————
petCharToScreenChar: {
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


// ------------------------------------
//      DATA
// ------------------------------------

* = * "Print Lib Data"
version:    .byte 1, 0, 0
.encoding "screencode_mixed"
module_name:
        .text "lib:print"
        .byte 0

#import "../core/mem_map.asm"

