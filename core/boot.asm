
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
                jsr     Boot.initIRQ    // Prepare IRQ
                jsr     Ram.init        // Init memory.
                jsr     Vic.init        // Init video
                cli
                jmp     warmStart
}

// --------------------------------------------------------
// initIRQ -
// Initialize Interrupt states after a cold start.
// Should never be executed as standard Init and should
// always be before it. This is extracted by c64 kernel
// routine IOINIT.
// --------------------------------------------------------
initIRQ: {
                lda     #$7F            // KILL INTERRUPTS
                sta     Cia.C1ICR
                sta     Cia.C2ICR

                sta     Cia.C1PRA       // TURN ON STOP KEY

                lda     #%00001000      // SHUT OFF TIMERS
                sta     Cia.C1CRA
                sta     Cia.C2CRA
                sta     Cia.C1CRB
                sta     Cia.C2CRB

                // CONFIGURE PORTS
                ldx     #$00            // SET UP KEYBOARD INPUTS
                stx     Cia.C1DDRB      // KEYBOARD INPUTS
                stx     Cia.C2DDRB      // USER PORT (NO RS-232)

                stx     Sid.FMVC       // TURN OFF SID

                dex                     // set X = $FF

                stx     Cia.C1DDRA      // KEYBOARD OUTPUTS

                lda     #%00000111      // SET SERIAL/VA14/15 (CLKHI)
                sta     Cia.C2PRA

                lda     #%00111111      // ;SET SERIAL IN/OUT, VA14/15OUT
                sta     Cia.C2DDRA

                // SET UP THE 6510 LINES
                lda     #%11100111      // MOTOR ON, HIRAM LOWRAM CHAREN HIGH
                sta     MC6502.ZR1      // set 1110 0111, motor off, enable I/O, enable KERNAL, Disable BASIC

                lda     #%00101111      // set 0010 1111, 0 = input, 1 = output
                sta     MC6502.ZR0      // save the 6510 I/O port direction register

                rts
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

