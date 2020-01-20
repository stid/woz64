#importonce
.filenamespace Vic
// https://www.c64-wiki.com/wiki/VIC
// https://www.c64-wiki.com/wiki/Page_208-211

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================

.label          VICREG = $D000

.label          CR2 = $D016  // Control register 2


* = * "VIC Functions"

init: {
                ldx     #47
    px4:
                lda tvic-1, x
                sta VICREG-1, x
                dex
                bne px4
                rts
}

* = * "VIC Init Data"

tvic:
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $9B, $37, $00, $00, $00, $08, $00
    .byte $14, $0F, $00, $00 ,$00, $00, $00, $00
    .byte $0E, $06, $01, $02, $03, $04, $00, $01
    .byte $02, $03, $04, $05, $06, $07, $4C

