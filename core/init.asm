
#importonce
#import "../libs/memory.asm"
#import "../libs/math.asm"
#import "../libs/print.asm"
#import "../core/keyboard.asm"
#import "../core/screen.asm"
#import "../libs/module.asm"
#import "../progs/woz_shell.asm"

.filenamespace Init

* = * "Init Core"


// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================

// --------------------------------------------------------
// init -
// Module Init.
// --------------------------------------------------------
init: {
            // Init All Modules
            jsr Memory.init
            jsr Math.init
            jsr Print.init
            jsr Keyboard.init
            jsr Screen.init
            jsr WozShell.init
            jsr Module.init
            rts
}

// --------------------------------------------------------
// toDebug -
// Print debug info.
// --------------------------------------------------------
toDebug: {
            // Debug All Modules
            ModuleToDebug(module_type, module_name, version)
            jsr Keyboard.toDebug
            jsr Screen.toDebug
            jsr Module.toDebug
            jsr Memory.toDebug
            jsr Print.toDebug
            jsr Math.toDebug
            jsr WozShell.toDebug
            rts
}



// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Init Core Data"
module_type:            .byte Module.TYPES.CORE
version:                .byte 1, 1, 0

.encoding "screencode_mixed"
module_name:
        .text "init"
        .byte 0


#import "../core/mem_map.asm"

