
#importonce
#import "../libs/memory.asm"
#import "../libs/math.asm"
#import "../libs/print.asm"
#import "../core/keyboard.asm"
#import "../core/screen.asm"
#import "../progs/woz_shell.asm"

.filenamespace Init



* = * "Init Core"

// ------------------------------------
//     METHODS
// ------------------------------------

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

toDebug: {
            // Debug All Modules
            ModuleDefaultToDebug(module_name, version)
            jsr Keyboard.toDebug
            jsr Screen.toDebug
            jsr Module.toDebug
            jsr Memory.toDebug
            jsr Print.toDebug
            jsr Math.toDebug
            jsr WozShell.toDebug
            rts
}



// ------------------------------------
//     DATA
// ------------------------------------

* = * "Init Core Data"
version:    .byte 1, 0, 0
module_name:
        .text "core:init"
        .byte 0
#import "../core/mem_map.asm"

