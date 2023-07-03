#importonce
.filenamespace Vic

// VIC registers and constants
// For more information, refer to:
// https://www.c64-wiki.com/wiki/VIC
// https://www.c64-wiki.com/wiki/Page_208-211

// Base address for VIC registers
.label VICREG = $D000

// Control register 2
.label CR2 = $D016

// Interrupt enabled register
.label INTE = $D01A

// Raster counter register
.label RCNT = $D012


* = * "VIC Functions"

// Initialize the VIC registers with values from the tvic array
init: {
    ldx #47            // Set index to 47 (the number of bytes in tvic)
load_loop:            // Start of loop to load tvic values into VIC registers
    lda tvic-1, x     // Load the byte from tvic at position x into the accumulator
    sta VICREG-1, x   // Store the byte in the accumulator into the VIC register at position x
    dex               // Decrement the index
    bne load_loop     // If the index is not zero, repeat the loop
    rts               // Return from subroutine
}

* = * "VIC Init Data"

// Initial values for the VIC registers
tvic:
    // The following bytes are loaded into the VIC registers in the init subroutine
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $9B, $37, $00, $00, $00, $08, $00
    .byte $14, $0F, $00, $00 ,$00, $00, $00, $00
    .byte $0E, $06, $01, $02, $03, $04, $00, $01
    .byte $02, $03, $04, $05, $06, $07, $4C
