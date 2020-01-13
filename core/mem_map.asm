.filenamespace MemMap
#importonce

.const SHELL_BUGGER_ADDR    = $3000
.const XSTACK_ADDRESS       = $3100
.const YSTACK_ADDRESS       = $3200

*=$2 "ZERO PAGE" virtual

.namespace CORE {
    yStackOffset:      .byte 0
    xStackOffset:      .byte 0

    .label XStack       = XSTACK_ADDRESS  // 256 bytes
    .label YStack       = YSTACK_ADDRESS  // 256 bytes
}

.namespace SCREEN {
    TempVideoPointer:   .word 0
    TempStringPointer:  .word 0
    CursorCol:          .byte 0
    CursorRow:          .byte 0
    ScrollUpTriggered:  .byte 0
}

.namespace MATH {
    factor1:            .byte 0
    factor2:            .byte 0
    result:             .word 0
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

    .label buffer        = SHELL_BUGGER_ADDR  // 256 bytes
}



