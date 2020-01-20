#importonce
#import "../libs/print.asm"

// ========================================================
// ////// MACROS //////////////////////////////////////////
// ========================================================

// --------------------------------------------------------
// ModulePrintVersion -
// Print out module version in the form of MAJ.MIN.REV.
// Exanple: 1.3.0.
//
// Parameters:
//      versionPtr      = Pointer to string Address
// --------------------------------------------------------
.macro ModulePrintVersion(versionPtr) {
                lda     #<versionPtr                // Low byte
                ldx     #>versionPtr                // High byte
                jsr     Module.printVersion
}

// --------------------------------------------------------
// ModulePrintType -
// Print out module Type based on Module.TYPES defs
//
// Parameters:
//      versionPtr      = Pointer to module type address
// --------------------------------------------------------
.macro ModulePrintType(typePtr) {
                lda     typePtr
                jsr     Module.printType
}

// --------------------------------------------------------
// ModuleToDebug -
// Print out default module information.
//
// Parameters:
//      moduleType      = Pointer to module type address
//      moduleName      = Pointer to module name address
//      moduleVersion   = Pointer to module version address
// --------------------------------------------------------
.macro ModuleToDebug(moduleType, moduleName, moduleVersion) {
                ModulePrintType(moduleType)
                lda     #':'
                PrintChar()
                PrintLine(moduleName)
                lda     #$20
                PrintChar()
                ModulePrintVersion(moduleVersion)
                PrintNewLine()
}


.filenamespace Module

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================

.namespace TYPES {
    .label      MAIN            = 00
    .label      LIB             = 01
    .label      PROG            = 02
    .label      CORE            = 03
    .label      DEVICE          = 04

}


* = * "Module Lib"

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
// printVersion -
// Print out module version
//
// Parameters:
//      A       = Version High Pointer
//      X       = Version Low Pointer
// --------------------------------------------------------
printVersion: {
                sta     MemMap.MODULE.versionPtr
                stx     MemMap.MODULE.versionPtr+1
                ldy     #0
                jsr     printNext               // Major
                lda     #'.'
                PrintChar()
                jsr     printNext               // Minor
                lda     #'.'
                PrintChar()
                jsr     printNext               // Revision
                rts
    printNext:
                lda     (MemMap.MODULE.versionPtr), y
                clc
                adc     #$30
                PrintChar()
                iny
                rts
}

// --------------------------------------------------------
// printType -
// Print out module type based on Module Module.TYPES
//
// Parameters:
//      A       = Module Type
// --------------------------------------------------------
printType: {
                cmp     #Module.TYPES.MAIN
                bne     !+
                PrintLine(type_main)
                rts
        !:
                cmp     #Module.TYPES.LIB
                bne     !+
                PrintLine(type_lib)
                rts
        !:
                cmp     #Module.TYPES.CORE
                bne     !+
                PrintLine(type_core)
                rts
        !:
                cmp     #Module.TYPES.DEVICE
                bne     !+
                PrintLine(type_device)
                rts
        !:
                cmp     #Module.TYPES.PROG
                bne     !+
                PrintLine(type_prog)
        !:
                rts
}


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Module Lib Data"
module_type:    .byte   Module.TYPES.CORE
version:        .byte   1, 2, 0

.encoding "screencode_mixed"
module_name:
                .text   "module"
                .byte   0

// Modile Type Names
type_main:
                .text   "main"
                .byte   0
type_core:
                .text   "core"
                .byte   0
type_lib:
                .text   "lib"
                .byte   0
type_prog:
                .text   "prog"
                .byte   0

type_device:
                .text   "device"
                .byte   0

#import "../core/mem_map.asm"

