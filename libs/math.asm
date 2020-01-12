
#importonce
#import "../libs/module.asm"

// ------------------------------------
//     MACROS
// ------------------------------------


.filenamespace Math

* = * "Math Lin"

// ------------------------------------
//     METHODS
// ------------------------------------

init: {
                rts
}

toDebug: {
                    ModuleDefaultToDebug(module_name, version)
                    rts
}

//------------------------------------------------------------------------------------
multiply: {
                sei
                pha
                txa
                pha

                lda #$00
                ldx #$08
                clc
    m0:         bcc.r m1
                clc
                adc MemMap.MATH.factor2
    m1:         ror
                ror MemMap.MATH.factor1
                dex
                bpl.r m0
                ldx MemMap.MATH.factor1

                sta MemMap.MATH.result
                stx MemMap.MATH.result+1

                pla
                tax
                pla
                cli
                rts
}


// ------------------------------------
//     DATA
// ------------------------------------

* = * "Math Lib Data"
version:    .byte 1, 1, 0
.encoding "screencode_mixed"
module_name:
        .text "lib:math"
        .byte 0


#import "../core/mem_map.asm"

