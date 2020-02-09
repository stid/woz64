#importonce
#import "../hardware/mem_map.asm"
#import "../core/module.asm"


// ========================================================
// ////// PSEUDO MACROS ///////////////////////////////////
// ========================================================

.macro bitSet(bitMask, address) {
    lda #bitMask
    ora address
    sta address
}

.macro bitClear(bitMask, address) {
    lda #~bitMask
    and address
    sta address
}

.macro bitToggle(bitMask, address) {
    lda #bitMask
    eor address
    sta address
}

.macro bitTest(bitMask, address) {
    lda #bitMask
    bit address
}


// ========================================================
// ////// PSEUDO COMMANDS /////////////////////////////////
// ========================================================

.pseudocommand phy {
                sta     MemMap.CORE.tmpA
                tya
                pha
                lda     MemMap.CORE.tmpA
}

.pseudocommand ply {
                sta     MemMap.CORE.tmpA
                pla
                tay
                lda     MemMap.CORE.tmpA
}

.pseudocommand phx {
                sta     MemMap.CORE.tmpA
                txa
                pha
                lda     MemMap.CORE.tmpA
}

.pseudocommand plx {
                sta     MemMap.CORE.tmpA
                pla
                tax
                lda     MemMap.CORE.tmpA}

.pseudocommand phr {
                sta     MemMap.CORE.tmpA
                pha
                txa
                pha
                tya
                pha
                lda     MemMap.CORE.tmpA
}

.pseudocommand plr {
                pla
                tay
                pla
                txa
                pla
}

.filenamespace Pseudo
// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================

* = * "Pseudo Commands"

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


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Pseudo Data"
module_type:    .byte   Module.TYPES.CORE
version:        .byte   1, 1, 0

.encoding "screencode_mixed"
module_name:
                .text   "pseudo"
                .byte   0
