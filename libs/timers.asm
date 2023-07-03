
#importonce
#import "../core/module.asm"


// ========================================================
// ////// MACROS //////////////////////////////////////////
// ========================================================

.filenamespace Timers

* = * "Timers Lib"

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
delayOne: {
    pha
    lda     #$00
    sta     MemMap.TIMERS.counter

loop1:
    lda     #$fb // wait for vertical retrace

loop2:
    cmp     $d012 // until it reaches 251th raster line ($fb)
    beq     waitForNextLine
    jmp     loop2 // loop back if not yet at the 251th raster line

waitForNextLine:
    lda     $d012 // make sure we reached

loop3:
    cmp     $d012 // the next raster line so next time we
    beq     loop1 // jump back to the main loop if still on the same raster line

    inc     MemMap.TIMERS.counter // increase frame counter
    lda     MemMap.TIMERS.counter // check if counter
    cmp     #$32 // reached 50
    bne     loop1 // if not, jump back to the main loop

exit:
    pla
    rts
}


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Timers Lib Data"
module_type:    .byte Module.TYPES.LIB
version:        .byte 1, 0, 0

.encoding "screencode_mixed"
module_name:
                .text "timers"
                .byte 0


#import "../hardware/mem_map.asm"

