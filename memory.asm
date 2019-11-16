#importonce
.filenamespace Memory

#import "mem_map.asm"

* = * "Memory Routines"

// move memory down
//
//   from = source start address
//   to = destination start address
//   size = number of bytes to move
//
clone:
                ldy #0
                ldx MemMap.MEMORY_SPACE.size
                beq md2
md1:            lda (MemMap.MEMORY_SPACE.from),y // move a page at a time
                sta (MemMap.MEMORY_SPACE.to),y
                iny
                bne md1
                inc MemMap.MEMORY_SPACE.from+1
                inc MemMap.MEMORY_SPACE.to+1
                dex
                bne md1
md2:            ldx MemMap.MEMORY_SPACE.size+1
                beq md4
md3:            lda (MemMap.MEMORY_SPACE.from),y // move the remaining bytes
                sta (MemMap.MEMORY_SPACE.to),y
                iny
                dex
                bne md3
md4:            rts
