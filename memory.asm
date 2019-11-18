#importonce

#import "mem_map.asm"

* = * "Memory Routines"

.macro clone(from, to, dest) {
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

        jsr Memory._clone
}

.filenamespace Memory


// move memory down
//
//   from = source start address
//   to = destination start address
//   size = number of bytes to move
//
_clone: {
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
md4:            rts
}