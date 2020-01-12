#importonce
#import "print.asm"

// ------------------------------------
//     MACROS
// ------------------------------------
.macro ModulePrintVersion(stringAddr) {
                lda #<stringAddr // Low byte
                ldx #>stringAddr // High byte
                jsr Module.printVersion
}

.macro ModuleDefaultToDebug(module_name, version) {
                PrintLine(module_name)
                ModulePrintVersion(version)
                PrintNewLine()
}

.filenamespace Module

* = * "Module Lb"

// ------------------------------------
//     METHODS
// ------------------------------------

init: {
                rts
}

toDebug: {
                ModuleDefaultToDebug(module_name, version)
                rts
}

//------------------------------------------------------------------------------------
printVersion: {
                .break
                sta MemMap.MODULE.versionPtr
                stx MemMap.MODULE.versionPtr+1
                ldy #0
                jsr printNext
                lda #'.'
                PrintChar()
                jsr printNext
                lda #'.'
                PrintChar()
                jsr printNext
                rts
    printNext:
                lda (MemMap.MODULE.versionPtr), y
                clc
                adc #$30
                PrintChar()
                iny
                rts

}


// ------------------------------------
//     DATA
// ------------------------------------

* = * "Module Lib Data"
version:    .byte 1, 0, 0

.encoding "screencode_mixed"
module_name:
        .text "lib:module"
        .byte 0

#import "../core/mem_map.asm"

