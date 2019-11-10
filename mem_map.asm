.filenamespace MemMap
#importonce

.const ZPAGE_BASE = $2


.namespace SCREEN_SPACE {
    .label  TempVideoPointer                = ZPAGE_BASE      // 2 bytes
    .label  TempStringPointer               = ZPAGE_BASE+2    // 2 bytes
    .label  CursorCol                       = ZPAGE_BASE+4    // 1 byte
    .label  CursorRow                       = ZPAGE_BASE+5    // 1 byte
    .label  tempY                           = ZPAGE_BASE+6    // 1 byte
    .label  tempX                           = ZPAGE_BASE+7    // 1 byte
}

.namespace MATH_SPACE {
    .label  factor1                         = ZPAGE_BASE+8    // 1 byte
    .label  factor2                         = ZPAGE_BASE+9    // 1 byte
    .label  multiTmpX                       = ZPAGE_BASE+10    // 1 byte
    .label  result                          = ZPAGE_BASE+11   // 2 bytes
}

.namespace KEYB_SPACE {
    .label ScanResult                       = ZPAGE_BASE+13   // 8 bytes
    .label BufferNew                        = ZPAGE_BASE+21   // 3 bytes
    .label KeyQuantity                      = ZPAGE_BASE+24   // 1 byte
    .label NonAlphaFlagX                    = ZPAGE_BASE+25   // 1 byte
    .label NonAlphaFlagY                    = ZPAGE_BASE+26   // 1 byte
    .label TempZP                           = ZPAGE_BASE+27   // 1 byte
    .label SimultaneousKeys                 = ZPAGE_BASE+28   // 1 byte

    // TODO: Need $FF init
    .label BufferOld                        = ZPAGE_BASE+28   // 1 byte
    .label Buffer                           = ZPAGE_BASE+29   // 4 byte
    .label BufferQuantity                   = ZPAGE_BASE+33   // 1 byte
    .label SimultaneousAlphanumericKeysFlag = ZPAGE_BASE+34   // 1 byte

    .label  TempX                           = ZPAGE_BASE+35    // 1 byte
    .label  TempY                           = ZPAGE_BASE+36    // 1 byte
}

.namespace KEYB2_SPACE {
    .label KeyR                             = ZPAGE_BASE+37
    .label SYS_Keyd                         = ZPAGE_BASE+38 // 10 bytes
    .label SYS_Ndx                          = ZPAGE_BASE+48 // 10 bytes
    .label SYS_Xmax                         = ZPAGE_BASE+49 // 1 bytes
    .label SYS_Shflag                       = ZPAGE_BASE+50 // 1 bytes
    .label SYS_Sfdx                         = ZPAGE_BASE+51 // 1 bytes
    .label SYS_Lstx                         = ZPAGE_BASE+52 // 1 bytes
    .label SYS_Delay                        = ZPAGE_BASE+53 // 1 bytes
    .label SYS_Kount                        = ZPAGE_BASE+54 // 1 bytes
    .label SYS_Lstshf                       = ZPAGE_BASE+55 // 1 bytes
}