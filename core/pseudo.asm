#importonce
#import "../core/mem_map.asm"
#import "../core/module.asm"


// ========================================================
// ////// PSEUDO COMMANDS /////////////////////////////////
// ========================================================

.pseudocommand phy {
                jsr     Pseudo._phy
}

.pseudocommand ply {
                jsr     Pseudo._ply
}

.pseudocommand phx {
                jsr     Pseudo._phx
}

.pseudocommand plx {
                jsr     Pseudo._plx
}

.pseudocommand phr {
                pha
                phx
                phy
}

.pseudocommand plr {
                plx
                ply
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
                lda     #$00
                sta     MemMap.CORE.xStackOffset
                sta     MemMap.CORE.yStackOffset
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

_phx: {
                pha                                 // Save A
                tya                                 // Tansfer Y in A
                pha                                 // Save Y as A
                inc     MemMap.CORE.xStackOffset    // Increment Stack offset
                ldy     MemMap.CORE.xStackOffset    // Load new Stack offset in Y
                txa                                 // Move X in A
                sta     MemMap.CORE.XStack, y       // Save X (as A) in YStack + offset (y)
                pla                                 // Load saved A (was Y)
                tay                                 // restore Y from A
                pla                                 // restore A
                rts
}

_plx: {
                pha                                 // Save A
                tya                                 // Tansfer X in A
                pha                                 // Save X as A
                ldx     MemMap.CORE.xStackOffset    // Load Stack offset
                lda     MemMap.CORE.XStack, x       // Load Y from stack
                tax
                dec     MemMap.CORE.xStackOffset    // Dcrement stack offset
                pla                                 // Load saved A (was X)
                tay                                 // restore X from A
                pla
                rts
}

_phy: {
                pha                                 // Save A
                txa                                 // Tansfer X in A
                pha                                 // Save X as A
                inc     MemMap.CORE.yStackOffset    // Increment Stack offset
                ldx     MemMap.CORE.yStackOffset    // Load new Stack offset in X
                tya                                 // Move Y in A
                sta     MemMap.CORE.YStack, x       // Save Y (as A) in XStack + offset (x)
                pla                                 // Load saved A (was X)
                tax                                 // restore X from A
                pla                                 // restore A
                rts
}

_ply: {
                pha                                 // Save A
                txa                                 // Tansfer X in A
                pha                                 // Save X as A
                ldx     MemMap.CORE.yStackOffset    // Load Stack offset
                ldy     MemMap.CORE.YStack, x       // Load Y from stack
                dec     MemMap.CORE.yStackOffset    // Dcrement stack offset
                pla                                 // Load saved A (was X)
                tax                                 // restore X from A
                pla                                 // restore A
                rts
}

// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Pseudo Data"
module_type:    .byte   Module.TYPES.CORE
version:        .byte   1, 0, 0

.encoding "screencode_mixed"
module_name:
                .text   "pseudo"
                .byte   0
