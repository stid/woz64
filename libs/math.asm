
#importonce
#import "../core/module.asm"


// ========================================================
// ////// MACROS //////////////////////////////////////////
// ========================================================

.macro inc16(addreess) {
                inc     addreess
                bne     !+
                inc     addreess +1
        !:
}


.macro dec16(addreess) {
                lda     addreess
                bne     !+
                dec     addreess+1
        !:      dec     addreess
}

.macro asl16(valueA, resultAddress) {
                .if (valueA > resultAddress) {
                        clc
                        lda     valueA
                        asl
                        sta     resultAddress
                        lda     valueA+1
                        rol
                        sta     resultAddress+1
                } else {
                        asl     valueA+0
                        rol     valueA+1
                }
}



.macro add16(valueA, valueB, resultAddress) {
                .if (valueA != valueB) {
                        clc
                        lda valueA
                        adc valueB
                        sta resultAddress
                        lda valueA+1
                        adc valueB+1
                        sta resultAddress+1
                }
                else {
                        .break
                        asl16(valueA, resultAddress)
                }
}

.macro sub16(valueA, valueB, resultAddress) {
                sec
                lda     valueA
                sbc     valueB
                sta     resultAddress
                lda     valueA+1
                sbc     valueB+1
                sta     resultAddress+1
}


.filenamespace Math

* = * "Math Lib"

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
        m0:     bcc     m1
                clc
                adc     MemMap.MATH.factor2
        m1:     ror
                ror     MemMap.MATH.factor1
                dex
                bpl     m0
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


#import "../hardware/mem_map.asm"

