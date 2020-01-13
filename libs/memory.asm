
#importonce
#import "../libs/module.asm"
#import "../libs/module.asm"


// ========================================================
// ////// MACROS //////////////////////////////////////////
// ========================================================

// --------------------------------------------------------
// MemoryClone -
// Clone a range of memory to the passe destination.
//
// Parameters:
//      from      = Start Memory Pointer to clone
//      to        = End Memory Pointer to clone
//      dest      = Destination Memory pointer
// --------------------------------------------------------
.macro MemoryClone(from, to, dest) {
                lda     #<from
                sta     MemMap.MEMORY.from
                lda     #>from
                sta     MemMap.MEMORY.from+1

                lda     #<dest
                sta     MemMap.MEMORY.dest
                lda     #>dest
                sta     MemMap.MEMORY.dest+1

                lda     #<to-from
                sta     MemMap.MEMORY.size+1
                lda     #>to-from
                sta     MemMap.MEMORY.size

                jsr     Memory.clone
}

// --------------------------------------------------------
// MemoryFill -
// Fill specified memory range with related byte.
//
// Parameters:
//      from            = Start Memory Pointer to fill
//      to              = End Memory Pointer to fill
//      fillByte        = Byte used to fill the range
// --------------------------------------------------------
.macro MemoryFill(from, to, fillByte) {
                lda     #<from
                sta     MemMap.MEMORY.from
                lda     #>from
                sta     MemMap.MEMORY.from+1

                lda     #<to-from
                sta     MemMap.MEMORY.size+1
                lda     #>to-from
                sta     MemMap.MEMORY.size

                lda     #fillByte
                jsr     Memory.fill
}

// --------------------------------------------------------
// MemoryClear -
// Fill specified memory range with Zero
//
// Parameters:
//      from            = Start Memory Pointer to fill
//      to              = End Memory Pointer to fill
// --------------------------------------------------------
.macro MemoryClear(from, to) {
                lda     #<from
                sta     MemMap.MEMORY.from
                lda     #>from
                sta     MemMap.MEMORY.from+1

                lda     #<to-from
                sta     MemMap.MEMORY.size+1
                lda     #>to-from
                sta     MemMap.MEMORY.size

                jsr     Memory.clear
}


.filenamespace Memory

* = * "Memory Lib"

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
// clone -
// Clone Memopry Range
//
// Parameters:
//      MemMap.MEMORY.from = Should contain the target
//                           pointer
//      MemMap.MEMORY.dest = Should contain the destination
//                           pointer
//      MemMap.MEMORY.size = Should contain the size to
//                           copy
// --------------------------------------------------------
clone: {
                stx     MemMap.MEMORY.tmpX
                sty     MemMap.MEMORY.tmpY
                sei
                ldy     #0
                ldx     MemMap.MEMORY.size
                beq     md2
        md1:    lda     (MemMap.MEMORY.from),y // move a page at a time
                sta     (MemMap.MEMORY.dest),y
                iny
                bne     md1
                inc     MemMap.MEMORY.from+1
                inc     MemMap.MEMORY.dest+1
                dex
                bne     md1
        md2:    ldx     MemMap.MEMORY.size+1
                beq     md4
        md3:    lda     (MemMap.MEMORY.from),y // move the remaining bytes
                sta     (MemMap.MEMORY.dest),y
                iny
                dex
                bne     md3
                cli
        md4:
                ldx     MemMap.MEMORY.tmpX
                ldy     MemMap.MEMORY.tmpY
                rts
}

// --------------------------------------------------------
// fill -
// Fill Memopry Range with byte loaded in A
//
// Parameters:
//      MemMap.MEMORY.dest = Should contain the destination
//                           pointer
//      MemMap.MEMORY.size = Should contain the size to
//                           fill
//      A                  = The byte to fill memory with
// --------------------------------------------------------
fill: {
                stx     MemMap.MEMORY.tmpX
                sty     MemMap.MEMORY.tmpY
                sei
                ldy     #0
                ldx     MemMap.MEMORY.size
                beq     md2
        md1:
                sta     (MemMap.MEMORY.dest),y
                iny
                bne     md1
                inc     MemMap.MEMORY.dest+1
                dex
                bne     md1
        md2:    ldx     MemMap.MEMORY.size+1
                beq     md4
        md3:
                sta     (MemMap.MEMORY.dest),y
                iny
                dex
                bne     md3
                cli
        md4:
                ldx     MemMap.MEMORY.tmpX
                ldy     MemMap.MEMORY.tmpY
                rts
}

// Clear Memory with 0
//
// MemMap.MEMORY.dest - Should contain the destination pointer
// MemMap.MEMORY.size - Should contain the size to copy

// --------------------------------------------------------
// clean -
// Clear Memory with 0
//
// Parameters:
//      MemMap.MEMORY.dest = Should contain the destination
//                           pointer
//      MemMap.MEMORY.size = Should contain the size to
//                           clean
// --------------------------------------------------------
clean: {
                lda     #00
                jmp     Memory.fill
}


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "Memory Lib Data"
module_type:            .byte Module.TYPES.LIB
version:                .byte 1, 1, 0

.encoding "screencode_mixed"
module_name:
        .text "memory"
        .byte 0


#import "../core/mem_map.asm"
#import "../core/screen.asm"

