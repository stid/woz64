#importonce
.filenamespace Math

#import "mem_map.asm"

* = * "Math Routines"

multiply: {
                stx MemMap.MATH.multiTmpX
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
                ldx MemMap.MATH.multiTmpX

                rts

}