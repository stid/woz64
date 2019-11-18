.filenamespace MemMap
#importonce

.const ZPAGE_BASE = $2


.namespace SCREEN {
    .label  TempVideoPointer                = ZPAGE_BASE      // 2 bytes
    .label  TempStringPointer               = ZPAGE_BASE+2    // 2 bytes
    .label  CursorCol                       = ZPAGE_BASE+4    // 1 byte
    .label  CursorRow                       = ZPAGE_BASE+5    // 1 byte
    .label  tempY                           = ZPAGE_BASE+6    // 1 byte
    .label  tempX                           = ZPAGE_BASE+7    // 1 byte
    .label  PrintPetCharY                   = ZPAGE_BASE+8    // 1 byte
    .label  PrintPetCharX                   = ZPAGE_BASE+9    // 1 byte
    .label  ScrollUpTriggered               = ZPAGE_BASE+10    // 1 byte
}

.namespace MATH {
    .label  factor1                         = ZPAGE_BASE+11    // 1 byte
    .label  factor2                         = ZPAGE_BASE+12    // 1 byte
    .label  multiTmpX                       = ZPAGE_BASE+13    // 1 byte
    .label  result                          = ZPAGE_BASE+14   // 2 bytes
}

.namespace KEYB2 {
    .label KeyR                             = ZPAGE_BASE+37 // 1 bytes
    .label SYS_Keyd                         = ZPAGE_BASE+38 // 10 bytes
    .label SYS_Ndx                          = ZPAGE_BASE+48 // 1 bytes
    .label SYS_Xmax                         = ZPAGE_BASE+49 // 1 bytes
    .label SYS_Shflag                       = ZPAGE_BASE+50 // 1 bytes
    .label SYS_Sfdx                         = ZPAGE_BASE+51 // 1 bytes
    .label SYS_Lstx                         = ZPAGE_BASE+52 // 1 bytes
    .label SYS_Delay                        = ZPAGE_BASE+53 // 1 bytes
    .label SYS_Kount                        = ZPAGE_BASE+54 // 1 bytes
    .label SYS_Lstshf                       = ZPAGE_BASE+55 // 1 bytes
}

.namespace MEMORY {
    .label from                             = ZPAGE_BASE+56 // 2 bytes
    .label dest                             = ZPAGE_BASE+58 // 2 bytes
    .label size                             = ZPAGE_BASE+60 // 2 bytes
}

.namespace SHELL {
    .label pos                               = ZPAGE_BASE+62 // 1 bytes
    .label MODE                              = ZPAGE_BASE+63 // 1 bytes
    .label L                                 = ZPAGE_BASE+64 // 1 bytes
    .label H                                 = ZPAGE_BASE+65 // 1 bytes
    .label YSAV                              = ZPAGE_BASE+66 // 1 bytes
    .label STL                               = ZPAGE_BASE+67 // 1 bytes
    .label STH                               = ZPAGE_BASE+68 // 1 bytes
    .label XAML                              = ZPAGE_BASE+69 // 1 bytes
    .label XAMH                              = ZPAGE_BASE+70 // 1 bytes

    .label buffer                            = $3000         // 256 bytes

}