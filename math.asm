#importonce
.filenamespace Math

#import "mem_map.asm"

multiply: {
                stx MemMap.MATH_SPACE.multiTmpX
                pha
                lda #$00
                ldx #$08
                clc
    m0:         bcc.r m1
                clc
                adc MemMap.MATH_SPACE.factor2
    m1:         ror
                ror MemMap.MATH_SPACE.factor1
                dex
                bpl.r m0
                ldx MemMap.MATH_SPACE.factor1

                sta MemMap.MATH_SPACE.result
                stx MemMap.MATH_SPACE.result+1

                pla
                ldx MemMap.MATH_SPACE.multiTmpX

                rts

}