#importonce
#import "../core/pseudo.asm"
#import "../core/system.asm"
#import "../libs/print.asm"
#import "../core/module.asm"
#import "../hardware/vic.asm"
#import "../devices/keyboard.asm"
#import "../devices/video.asm"
#import "../hardware/mem_map.asm"

.filenamespace StidShell

* = * "StidShell Routines"

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================

.const          R       =       $52
.const          CR      =       $0d
.const          BS      =       $14

.const          MAX_CMD_BUFFER  = 40


.namespace MODE {
    .label      MEMORY  = $48
    .label      HELP    = $4D

}


// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


init: {
                jsr StidShell.clear
                rts
}

start: {
                PrintLine(lineString)
                PrintLine(aboutString)
                PrintLine(lineString)
                jsr     StidShell.printRegs

                jmp     StidShell.loop
}

clear: {
                lda     #-1
                sta     MemMap.STID_SHELL.pos
                lda     #0
                sta     MemMap.STID_SHELL.sAddr
                sta     MemMap.STID_SHELL.eAddr

                rts
}



//------------------------------------------------------------------------------------
loop: {
                jsr     Keyboard.waitForKey

                cmp     #CR
                beq     cr

                cmp     #BS
                beq     backspace
        inputChar:
                jsr     StidShell.push                 // Char in Buffer
                cpy     #MAX_CMD_BUFFER
                beq     loop
                PrintChar()
                jmp     loop
        backspace:
                jsr     StidShell.backspace
                PrintChar()
                jmp     loop

        cr:
                jsr     StidShell.push                 // CR in Buffer
                jsr     Video.screenNewLine
                jsr     StidShell.exec
                jsr     Video.screenNewLine
                jsr     StidShell.clear
                jmp     loop
}

toDebug: {
                ModuleToDebug(module_type, module_name, version)
                rts
}

push: {
                ldy     MemMap.STID_SHELL.pos
                iny
                cpy     #MAX_CMD_BUFFER
                beq     done
                sty     MemMap.STID_SHELL.pos
                sta     MemMap.STID_SHELL.buffer, y
        done:
                rts
}

backspace: {
                ldy     MemMap.STID_SHELL.pos
                cpy     #-1
                beq     done
                dey
                sty     MemMap.STID_SHELL.pos
        done:
                rts
}

exec: {
        ldy     #0
        lda     MemMap.STID_SHELL.buffer, y

        sta     MemMap.STID_SHELL.mode            // Store as mode

        cmp     #StidShell.MODE.HELP      // H
        beq     cmdHelp

        cmp     #StidShell.MODE.MEMORY    // M
        beq     cmdMemory

        rts

        cmdHelp:
                rts

        cmdMemory: {
                loop:
                        iny
                        lda     MemMap.STID_SHELL.buffer, y
                        cmp     $20
                        beq     loop
                        cmp     #CR
                        beq     done


                done:
                        rts
        }
}


printRegs: {
        PrintLine(regString)
        lda     $02
        jsr     Print.byteToHex
        PrintChar()
        txa
        PrintChar()
        lda     $03
        jsr     Print.byteToHex
        PrintChar()
        txa
        PrintChar()
        rts
}


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "StidShell Data"
module_type:    .byte   Module.TYPES.PROG
version:        .byte   0, 0, 1

.encoding "screencode_mixed"
module_name:
                .text   "stid-shell"
                .byte   0

aboutString:
                .text   "stid mon 0.0.1"
                .byte   Video.CR, 0
lineString:
                .text   "----------------------------------------"
                .byte   Video.CR, 0

regString:
                .text   "    pc   sr ac xr yr sp"
                .byte   Video.CR
                .text   ";  "
                .byte   0


#import "../hardware/mem_map.asm"
