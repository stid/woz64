
#importonce
#import "../libs/module.asm"
#import "../libs/module.asm"


.filenamespace Math

* = * "Math Lin"

// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


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

// --------------------------------------------------------
// multiply -
// 8 Bit in to 16 Bit out Multiplier
//
// Parameters:
//      MemMap.MATH.factor1       = 8 Bit Factor 1
//      MemMap.MATH.factor2       = 8 Bit Factor 2
//
// Result
//      MemMap.MATH.result        = 16 bit result
// --------------------------------------------------------
multiply: {
                sei
                pha
                txa
                pha

                lda     #$00
                ldx     #$08
                clc
        m0:     bcc.r   m1
                clc
                adc     MemMap.MATH.factor2
        m1:     ror
                ror     MemMap.MATH.factor1
                dex
                bpl.r   m0
                ldx     MemMap.MATH.factor1

                sta     MemMap.MATH.result
                stx     MemMap.MATH.result+1

                pla
                tax
                pla
                cli
                rts
}


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Math Lib Data"
module_type:    .byte Module.TYPES.LIB
version:        .byte 1, 1, 0

.encoding "screencode_mixed"
module_name:
                .text "math"
                .byte 0


#import "../core/mem_map.asm"

