.filenamespace MemMap
#importonce

.const SHELL_BUFFER_ADDR    = $1000         // 256 bytes (3000-30FF)
.const XSTACK_ADDRESS       = $1100         // 256 bytes (3100-31FF)
.const YSTACK_ADDRESS       = $1200         // 256 bytes (3200-32FF)
.const KEYB_RAM_CODE        = $1300         // Safe to use > $1400

*=$2 "ZERO PAGE" virtual

.namespace CORE {
    //  PHx/PLx pseudo commands
    yStackOffset:      .byte 0              // Y Stack offset used by phy/ply
    xStackOffset:      .byte 0              // X Stack offset used by phx/plx
    .label XStack       = XSTACK_ADDRESS    // 256 bytes phy/ply stack buffer pointer
    .label YStack       = YSTACK_ADDRESS    // 256 bytes phx/plx stack buffer pointer
}

.namespace PRINT {
    TempStringPointer:  .word 0             // Pointer to string address as it get printend to screen
}

.namespace SCREEN {
    TempVideoPointer:   .word 0             // Pointer to video mem used to target char pos
    CursorCol:          .byte 0             // Actual cursor column position
    CursorRow:          .byte 0             // Actual cursor row position
    ScrollUpTriggered:  .byte 0             // Set to 1 if a scroll up was triggered
}

.namespace MATH {
    factor1:            .byte 0             // Factor 1 used in MUL ops
    factor2:            .byte 0             // Factor 2 used in MUL ops

    result:             .word 0             // 16 Bit math operation result
}

.namespace KEYBOARD {
    KeyR:                .byte 0
    SYS_Keyd:            .fill $10,0
    SYS_Ndx:             .byte 0
    SYS_Xmax:            .byte 0
    SYS_Shflag:          .byte 0
    SYS_Sfdx:            .byte 0
    SYS_Lstx:            .byte 0
    SYS_Delay:           .byte 0
    SYS_Kount:           .byte 0
    SYS_Lstshf:          .byte 0

    .label keybRamCode   = KEYB_RAM_CODE
}

.namespace MEMORY {
    from:                .word 0
    dest:                .word 0
    size:                .word 0
}

.namespace MODULE {
    versionPtr:          .word 0
}

.namespace SHELL {
    pos:                 .byte 0
    MODE:                .byte 0
    L:                   .byte 0
    H:                   .byte 0
    YSAV:                .byte 0
    STL:                 .byte 0
    STH:                 .byte 0
    XAML:                .byte 0
    XAMH:                .byte 0

    .label buffer        = SHELL_BUFFER_ADDR  // 256 bytes
}



