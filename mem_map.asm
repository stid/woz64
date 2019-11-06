.filenamespace MemMap
#importonce

.const base = $10


.namespace SCREEN_SPACE {
    .label  TempVideoPointer    = base      // W
    .label  TempStringPointer   = base+2    // W
    .label  CursorCol           = base+4
    .label  CursorRow           = base+5
    .label  tempY               = base+6
}

.namespace MATH_SPACE {
    .label  factor1           = base+7
    .label  factor2           = base+8
    .label  multiTmpX         = base+9
    .label  result            = base+10    // W
}