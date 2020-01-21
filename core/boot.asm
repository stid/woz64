
#importonce
#import "../core/pseudo.asm"
#import "../core/module.asm"

#import "../core/system.asm"
#import "../hardware/cia.asm"
#import "../hardware/sid.asm"
#import "../hardware/mc6502.asm"
#import "../hardware/ram.asm"
#import "../hardware/vic.asm"

.filenamespace Boot


* = * "Boot Core"

// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================

// --------------------------------------------------------
// coldstart -
// Power ON initialization
// --------------------------------------------------------
coldStart: {
                ldx     #$FF
                sei
                txs
                cld
                stx     Vic.CR2         // Set Video Bits
                jsr     Cia.init
                jsr     Sid.init
                jsr     MC6502.init
                jsr     Ram.init        // Init memory.
                jsr     Vic.init        // Init video
                cli
                jmp     warmStart
}

// --------------------------------------------------------
// warmStart -
// Restore pressed or program restart after first Power ON
// --------------------------------------------------------
warmStart: {
                sei
                jsr     Boot.init           // Init Self as Module
                cli

                jsr     System.start        // Start Core System

                //      If System Exit - reboot
                //      TODO: We can print a message here
                //      and delay a bit...
                jmp     warmStart
}

// --------------------------------------------------------
// init -
// Module Init.
// --------------------------------------------------------
init: {
                // Sequence matter
                jsr     Module.init
                jsr     Pseudo.init
                jsr     System.init
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


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Boot Core Data"
module_type:    .byte   Module.TYPES.CORE
version:        .byte   1, 0, 0

.encoding "screencode_mixed"
module_name:
                .text   "boot"
                .byte   0


#import "../hardware/mem_map.asm"

