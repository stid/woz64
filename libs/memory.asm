
#importonce
#import "../libs/module.asm"


* = * "Memory Lib"

// ------------------------------------
//     MACROS
// ------------------------------------

.macro MemoryClone(from, to, dest) {
                lda #<from
                sta MemMap.MEMORY.from
                lda #>from
                sta MemMap.MEMORY.from+1

                lda #<dest
                sta MemMap.MEMORY.dest
                lda #>dest
                sta MemMap.MEMORY.dest+1

                lda #<to-from
                sta MemMap.MEMORY.size+1
                lda #>to-from
                sta MemMap.MEMORY.size

                jsr Memory.clone
}

.macro MemoryFill(from, to, fillByte) {
                lda #<from
                sta MemMap.MEMORY.from
                lda #>from
                sta MemMap.MEMORY.from+1

                lda #<to-from
                sta MemMap.MEMORY.size+1
                lda #>to-from
                sta MemMap.MEMORY.size

                lda #fillByte
                jsr Memory.fill
}

.macro MemoryClear(from, to) {
                lda #<from
                sta MemMap.MEMORY.from
                lda #>from
                sta MemMap.MEMORY.from+1

                lda #<to-from
                sta MemMap.MEMORY.size+1
                lda #>to-from
                sta MemMap.MEMORY.size

                jsr Memory.clear
}

// ------------------------------------
//     METHODS
// ------------------------------------

.filenamespace Memory

init: {
                    rts
}

toDebug: {
                    ModuleDefaultToDebug(module_name, version)
                    rts

}

// Clone Memopry Range
//
// MemMap.MEMORY.from - Should contain the target pointer
// MemMap.MEMORY.dest - Should contain the destination pointer
// MemMap.MEMORY.size - Should contain the size to copy
clone: {
                    sei
                    ldy #0
                    ldx MemMap.MEMORY.size
                    beq md2
    md1:            lda (MemMap.MEMORY.from),y // move a page at a time
                    sta (MemMap.MEMORY.dest),y
                    iny
                    bne md1
                    inc MemMap.MEMORY.from+1
                    inc MemMap.MEMORY.dest+1
                    dex
                    bne md1
    md2:            ldx MemMap.MEMORY.size+1
                    beq md4
    md3:            lda (MemMap.MEMORY.from),y // move the remaining bytes
                    sta (MemMap.MEMORY.dest),y
                    iny
                    dex
                    bne md3
                    cli
    md4:            rts
}

// Fill Memopry Range with byte loaded in A
//
// MemMap.MEMORY.dest - Should contain the destination pointer
// MemMap.MEMORY.size - Should contain the size to copy
// A - The byte to fill memory with
fill: {
                    sei
                    ldy #0
                    ldx MemMap.MEMORY.size
                    beq md2
    md1:
                    sta (MemMap.MEMORY.dest),y
                    iny
                    bne md1
                    inc MemMap.MEMORY.dest+1
                    dex
                    bne md1
    md2:            ldx MemMap.MEMORY.size+1
                    beq md4
    md3:
                    sta (MemMap.MEMORY.dest),y
                    iny
                    dex
                    bne md3
                    cli
    md4:            rts
}

// Clear Memory with 0
//
// MemMap.MEMORY.dest - Should contain the destination pointer
// MemMap.MEMORY.size - Should contain the size to copy
clear: {
                    lda #00
                    jmp Memory.fill
}


// ------------------------------------
//     DATA
// ------------------------------------

* = * "Memory Lib Data"
version:    .byte 1, 1, 0
.encoding "screencode_mixed"
module_name:
        .text "lib:memory"
        .byte 0

#import "../core/mem_map.asm"
#import "../core/screen.asm"

