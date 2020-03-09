//---------------------------------------
// c64 deadtest diagnostic 781220
// disassembly by worldofjani.com
//---------------------------------------
//
.const a00 = $00
.const a01 = $01
.const a02 = $02
.const a03 = $03
.const a09 = $09
.const a0a = $0a
.const a0b = $0b
.const a0c = $0c
.const a10 = $10
//
.const p09 = $09
.const p0b = $0b
//


//---------------------------------------
        * = $e000 "Main"

        sei
        ldx #$ff
        txs
        cld
        lda #$e7
        sta a01
        lda #$37
        sta a00
        jmp ie183

ie010:  lda #<ead8      //font
        ldx #>ead8
        sta a09
        stx a0a
        lda #<$0800
        ldx #>$0800
        sta a0b
        stx a0c
        ldx #$01
        ldy #$00
ie024:  lda (p09),y
        sta (p0b),y
        iny
        bne ie024
        inc a0a
        inc a0c
        dex
        bpl ie024
        ldx #$04
ie034:  lda $e7ee,x
        sta $dc07,x
        lda $e7f2,x
        sta $dd07,x
        dex
        bne ie034
        ldx #$00
        stx a02
        stx a03
        ldx #$00
ie04b:  lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #$06
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne ie04b
        ldx #$27
ie06c:  lda e8a6,x      //box upper part
        sta $0630,x
        lda #$02         //red
        sta $da30,x
        dex
        bpl ie06c
        ldx #$00
ie07c:  lda e8ce,x
        cmp #$ff
        beq ie08a
        sta $0658,x
        inx
        jmp ie07c

ie08a:  ldx #$00
ie08c:  lda e9bf,x      //color
        cmp #$ff
        beq ie09a
        sta $da58,x
        inx
        jmp ie08c

ie09a:  ldx #$27
ie09c:  lda eab0,x      //box lower part
        sta $0748,x
        lda #$02         //red
        sta $db48,x
        dex
        bpl ie09c
        lda #$08
        sta $dc0f
        sta $dd0f
        lda #$48
        sta $dc0e
        lda #$08
        sta $dd0e

ie0bc:  ldx #$2f
ie0be:  lda e7bf-1,x      //vic/d000- values
        sta $cfff,x
        dex
        bne ie0be
        ldx #$18
ie0c9:  lda e817,x      //c-64 dead test rev 781220
        sta $0408,x
        dex
        bpl ie0c9
        ldx #$04
ie0d4:  lda e830,x      //count
        sta $07c0,x
        dex
        bpl ie0d4
        lda a02
        and #$0f
        ora #$30
        sta $07c9
        lda a02
        lsr
        lsr
        lsr
        lsr
        and #$0f
        ora #$30
        sta $07c8
        lda a03
        and #$0f
        ora #$30
        sta $07c7
        lda a03
        lsr
        lsr
        lsr
        lsr
        and #$0f
        ora #$30
        sta $07c6
        lda #$37
        sta a01
        jmp ie2fa        //zeropage test

ie110:  jmp ie351        //stack page test

ie113:  jsr ie6d9
        jsr ie3a6        //screen ram test
        jsr ie6d9
        jsr ie406        //color ram test
        jsr ie6d9
        jsr ie46a        //ram test

        lda #<ead8      //font
        ldx #>ead8
        sta a09
        stx a0a
        lda #<$0800
        ldx #>$0800
        sta a0b
        stx a0c
        ldx #$01
        ldy #$00
ie139:  lda (p09),y
        sta (p0b),y
        iny
        bne ie139
        inc a0a
        inc a0c
        dex
        bpl ie139
        jsr ie6d9
        jsr ie5bc        //sound test
        sed
        lda #$01
        clc
        adc a02
        sta a02
        lda #$00
        adc a03
        sta a03
        cld
        lda #$e7
        sta a01
        lda #$37
        sta a00
        lda #$00
        sta $d418
        ldx #$00
        lda #$20
ie16d:  sta $0400,x
        sta $0500,x
        inx
        bne ie16d
        ldx #$2e
        lda #$20
ie17a:  sta $0600,x
        dex
        bpl ie17a
        jmp ie0bc

ie183:  lda #$00
        sta $d020
        sta $d021
        ldx #$15
        ldy #$00
ie18f:  lda $e7f7,x      //memtest pattern
        sta $0100,y
        sta $0200,y
        sta $0300,y
        sta $0400,y
        sta $0500,y
        sta $0600,y
        sta $0700,y
        sta $0800,y
        sta $0900,y
        sta $0a00,y
        sta $0b00,y
        sta $0c00,y
        sta $0d00,y
        sta $0e00,y
        sta $0f00,y
        iny
        bne ie18f
        txa
        ldx #$00
        ldy #$00
ie1c7:  dey
        bne ie1c7
        dex
        bne ie1c7
        tax
ie1ce:  lda $0100,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0200,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0300,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0400,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0500,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0600,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0700,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0800,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0900,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0a00,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0b00,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0c00,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0d00,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0e00,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        lda $0f00,y
        cmp $e7f7,x      //memtest pattern
        bne ie24c
        iny
        beq ie24f
        jmp ie1ce

ie24c:  jmp ie25a

ie24f:  dex
        bmi ie257
        ldy #$00
        jmp ie18f

ie257:  jmp ie010        //memtest ok

ie25a:  eor $e7f7,x      //memtest pattern
        tax
        and #$fe
        bne ie267
        ldx #$08
        jmp ie2a5        //mem error flash

ie267:  txa
        and #$fd
        bne ie271
        ldx #$07
        jmp ie2a5        //mem error flash

ie271:  txa
        and #$fb
        bne ie27b
        ldx #$06
        jmp ie2a5        //mem error flash

ie27b:  txa
        and #$f7
        bne ie285
        ldx #$05
        jmp ie2a5        //mem error flash

ie285:  txa
        and #$ef
        bne ie28f
        ldx #$04
        jmp ie2a5        //mem error flash

ie28f:  txa
        and #$df
        bne ie299
        ldx #$03
        jmp ie2a5        //mem error flash

ie299:  txa
        and #$bf
        bne ie2a3
        ldx #$02
        jmp ie2a5        //mem error flash

ie2a3:  ldx #$01         //mem error flash
ie2a5:  txs
ie2a6:  lda #$01
        sta $d020
        sta $d021
        txa
        ldx #$7f
        ldy #$00
ie2b3:  dey
        bne ie2b3
        dex
        bne ie2b3
        tax
        lda #$00
        sta $d020
        sta $d021
        txa
        ldx #$7f
        ldy #$00
ie2c7:  dey
        bne ie2c7
        dex
        bne ie2c7
ie2cd:  dey
        bne ie2cd
        dex
        bne ie2cd
        tax
        dex
        beq ie2da
        jmp ie2a6

ie2da:  ldx #$00
        ldy #$00
ie2de:  dey
        bne ie2de
        dex
        bne ie2de
ie2e4:  dey
        bne ie2e4
        dex
        bne ie2e4
ie2ea:  dey
        bne ie2ea
        dex
        bne ie2ea
ie2f0:  dey
        bne ie2f0
        dex
        bne ie2f0
        tsx
        jmp ie2a6

ie2fa:  ldx #$08
ie2fc:  lda e835,x      //zeropage test
        sta $0450,x
        dex
        bpl ie2fc
        ldx #$13
ie307:  lda $e7f7,x      //memtest pattern
        ldy #$12
ie30c:  sta $0000,y
        iny
        bne ie30c
        txa
        ldx #$00
        ldy #$00
ie317:  dey
        bne ie317
        dex
        bne ie317
        tax
        lda $e7f7,x      //memtest pattern
        ldy #$12
ie323:  cmp $0000,y
        bne ie33b
        iny
        bne ie323
        dex
        bpl ie307
        lda #$0f         //"o"
        sta $045d
        lda #$0b         //"k"
        sta $045e
        jmp ie110

ie33b:  eor $e7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta $045d
        lda #$01         //"a"
        sta $045e
        lda #$04         //"d"
        sta $045f
        jmp ie4c1

ie351:  ldx #$09
ie353:  lda e83e,x      //stack page
        sta $0478,x
        dex
        bpl ie353
        ldx #$13
ie35e:  lda $e7f7,x      //memtest pattern
        ldy #$00
ie363:  sta $0100,y
        iny
        bne ie363
        txa
        ldx #$00
        ldy #$00
ie36e:  dey
        bne ie36e
        dex
        bne ie36e
        tax
        lda $e7f7,x      //memtest pattern
ie378:  cmp $0100,y
        bne ie390
        iny
        bne ie378
        dex
        bpl ie35e
        lda #$0f         //"o"
        sta $0485
        lda #$0b         //"k"
        sta $0486
        jmp ie113

ie390:  eor $e7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta $0485
        lda #$01         //"a"
        sta $0486
        lda #$04         //"d"
        sta $0487
        jmp ie4c1

ie3a6:  ldx #$09
ie3a8:  lda e863,x      //screen ram
        sta $04a0,x
        dex
        bpl ie3a8
        ldx #<$0400
        ldy #>$0400
        stx a09
        sty a0a
ie3b9:  ldy #$00
        lda (p09),y
        pha
        ldx #$13
ie3c0:  lda $e7f7,x      //memtest pattern
        sta (p09),y
        txa
        ldx #$00
ie3c8:  dex
        bne ie3c8
        tax
        lda (p09),y
        cmp $e7f7,x      //memtest pattern
        bne ie3f0
        dex
        bpl ie3c0
        pla
        sta (p09),y
        inc a09
        bne ie3df
        inc a0a
ie3df:  lda a0a
        cmp #$08
        bne ie3b9
        lda #$0f         //"o"
        sta $04ad
        lda #$0b         //"k"
        sta $04ae
        rts

ie3f0:  eor $e7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta $04ad
        lda #$01         //"a"
        sta $04ae
        lda #$04         //"d"
        sta $04af
        jsr ie4c1

ie406:  ldx #$08
ie408:  lda e850,x      //color ram test
        sta $04c8,x
        dex
        bpl ie408
        ldx #<$d800
        ldy #>$d800
        stx a09
        sty a0a
        ldy #$00
ie41b:  ldy #$00
        lda (p09),y
        pha
        ldx #$0b
ie422:  lda $e80b,x
        sta (p09),y
        txa
        ldx #$00
ie42a:  dex
        bne ie42a
        tax
        lda (p09),y
        and #$0f
        cmp $e80b,x
        bne ie454
        dex
        bpl ie422
        pla
        sta (p09),y
        inc a09
        bne ie443
        inc a0a
ie443:  lda a0a
        cmp #$dc
        bne ie41b
        lda #$0f         //"o"
        sta $04d5
        lda #$0b         //"k"
        sta $04d6
        rts

ie454:  eor $e80b,x
        tax
        lda #$02         //"b"
        sta $04d5
        lda #$01         //"a"
        sta $04d6
        lda #$04         //"d"
        sta $04d7
        jmp ie4c1

ie46a:  ldx #$07
ie46c:  lda e848,x      //ram test
        sta $04f0,x
        dex
        bpl ie46c
        ldx #<$0800
        ldy #>$0800
        stx a09
        sty a0a
ie47d:  ldy #$00
        ldx #$13
ie481:  lda $e7f7,x      //memtest pattern
        sta (p09),y
        txa
        ldx #$7f
ie489:  dex
        bne ie489
        tax
        lda (p09),y
        cmp $e7f7,x      //memtest pattern
        bne ie4ae
        dex
        bpl ie481
        inc a09
        bne ie49d
        inc a0a
ie49d:  lda a0a
        cmp #$10
        bne ie47d
        lda #$0f         //"o"
        sta $04fd
        lda #$0b         //"k"
        sta $04fe
        rts

ie4ae:  eor $e7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta $04fd
        lda #$01         //"a"
        sta $04fe
        lda #$04         //"d"
        sta $04ff
ie4c1:  txa
        and #$01
        beq ie4e0
        lda #$02         //"b"
        sta $06a4
        lda #$01         //"a"
        sta $06a5
        lda #$04         //"d"
        sta $06a6
        lda #$02         //red
        sta $daa4
        sta $daa5
        sta $daa6
ie4e0:  txa
        and #$02
        beq ie4ff
        lda #$02         //"b"
        sta $0699
        lda #$01         //"a"
        sta $069a
        lda #$04         //"d"
        sta $069b
        lda #$02         //red
        sta $da99
        sta $da9a
        sta $da9b
ie4ff:  txa
        and #$04
        beq ie51e
        lda #$02         //"b"
        sta $06cc
        lda #$01         //"a"
        sta $06cd
        lda #$04         //"d"
        sta $06ce
        lda #$02         //red
        sta $dacc
        sta $dacd
        sta $dace
ie51e:  txa
        and #$08
        beq ie53d
        lda #$02         //"b"
        sta $06c1
        lda #$01         //"a"
        sta $06c2
        lda #$04         //"d"
        sta $06c3
        lda #$02         //red
        sta $dac1
        sta $dac2
        sta $dac3
ie53d:  txa
        and #$10
        beq ie55c
        lda #$02         //"b"
        sta $06f4
        lda #$01         //"a"
        sta $06f5
        lda #$04         //"d"
        sta $06f6
        lda #$02         //red
        sta $daf4
        sta $daf5
        sta $daf6
ie55c:  txa
        and #$20
        beq ie57b
        lda #$02         //"b"
        sta $06e9
        lda #$01         //"a"
        sta $06ea
        lda #$04         //"d"
        sta $06eb
        lda #$02         //red
        sta $dae9
        sta $daea
        sta $daeb
ie57b:  txa
        and #$40
        beq ie59a
        lda #$02         //"b"
        sta $071c
        lda #$01         //"a"
        sta $071d
        lda #$04         //"d"
        sta $071e
        lda #$02         //red
        sta $db1c
        sta $db1d
        sta $db1e
ie59a:  txa
        and #$80
        beq ie5b9
        lda #$02         //"b"
        sta $0711
        lda #$01         //"a"
        sta $0712
        lda #$04         //"d"
        sta $0713
        lda #$02         //red
        sta $db11
        sta $db12
        sta $db13
ie5b9:  jmp ie5b9

ie5bc:  ldx #$09
ie5be:  lda e859,x      //sound test
        sta $0518,x
        dex
        bpl ie5be
        lda #$14
        sta $d418
        lda #$00
        sta $d417
        lda #$3e
        sta $d405
        lda #$ca
        sta $d406
        lda #$00
        sta $d412
        lda #$02
ie5e2:  pha
        ldx #$06
ie5e5:  lda e86d,x
        sta $d401
        lda e874,x
        sta $d400
        pla
        tay
        lda e89a,y
        sta $d402
        lda e89d,y
        sta $d403
        lda e897,y
        sta $d404
        tya
        pha
        lda #$6a
        jsr ie6b7
        lda #$00
        sta $d404
        lda #$00
        jsr ie6b7
        dex
        bne ie5e5
        lda #$00
        sta $d417
        lda #$18
        sta $d418
        lda #$3e
        sta $d40c
        lda #$ca
        sta $d40d
        ldx #$06
ie62f:  lda e87b,x
        sta $d408
        lda e882,x
        sta $d407
        pla
        tay
        lda e89a,y
        sta $d409
        lda e89d,y
        sta $d40a
        lda e897,y
        sta $d40b
        tya
        pha
        lda #$6a
        jsr ie6b7
        lda #$00
        sta $d40b
        lda #$00
        jsr ie6b7
        dex
        bne ie62f
        lda #$00
        sta $d417
        lda #$1f
        sta $d418
        lda #$3e
        sta $d413
        lda #$ca
        sta $d414
        ldx #$06
ie679:  lda e889,x
        sta $d40f
        lda e890,x
        sta $d40e
        pla
        tay
        lda e89a,y
        sta $d410
        lda e89d,y
        sta $d411
        lda e897,y
        sta $d412
        tya
        pha
        lda #$6a
        jsr ie6b7
        lda #$00
        sta $d412
        lda #$00
        jsr ie6b7
        dex
        bne ie679
        pla
        tay
        dey
        tya
        bmi ie6b6
        jmp ie5e2

ie6b6:  rts

ie6b7:  cmp #$00
        beq ie6ca
        tay
        txa
        pha
        tya
        tax
ie6c0:  ldy #$ff
ie6c2:  dey
        bne ie6c2
        dex
        bne ie6c0
        pla
        tax
ie6ca:  rts

                         //not referenced?
        lda #$37
        sta a01
        lda #$48
        sta $dc0e
        lda #$08
        sta $dd0e
ie6d9:  lda $dc0b
        clc
        asl
        bcc ie6ed
        lda #$10         //"p"
        sta $07db
        lda #$0d         //"m"
        sta $07dc
        clc
        bcc ie6f7
ie6ed:  lda #$01         //"a"
        sta $07db
        lda #$0d         //"m"
        sta $07dc
ie6f7:  lda $dc0b
        and #$7f
        ldy #$01
        bne ie732
ie700:  sta $07d3        //xx-00-00
        stx $07d4
        lda #$2d         //"-"
        sta $07d5
        lda $dc0a
        ldy #$02
        bne ie732
ie712:  sta $07d6        //00-xx-00
        stx $07d7
        lda #$2d         //"-"
        sta $07d8
        lda $dc09
        ldy #$03
        bne ie732
ie724:  sta $07d9        //00-00-xx
        stx $07da
        lda $dc08
        clc
        bcc ie76b
        ldy #$00
ie732:  pha
        sty a10
        ldy #$04
        bne ie741
ie739:  ldy a10
        tax
        pla
        lsr
        lsr
        lsr
        lsr
ie741:  and #$0f
        cmp #$0a
        bmi ie74c
        sec
        sbc #$09
        bne ie74e
ie74c:  ora #$30
ie74e:  cpy #$01
        beq ie700
        cpy #$02
        beq ie712
        cpy #$03
        beq ie724
        cpy #$04
        beq ie739
        cpy #$05
        beq ie792
        cpy #$06
        beq ie7a4
        cpy #$07
        beq ie7b6
        rts

ie76b:  lda $dd0b
        clc
        asl
        bcc ie77f
        lda #$10         //"p"
        sta $07e6
        lda #$0d         //"m"
        sta $07e7
        clc
        bcc ie789
ie77f:  lda #$01         //"a"
        sta $07e6
        lda #$0d         //"m"
        sta $07e7
ie789:  lda $dd0b
        and #$7f
        ldy #$05
ie790:  bne ie732
ie792:  sta $07de        //xx-00-00
        stx $07df
        lda #$2d         //"-"
        sta $07e0
        lda $dd0a
        ldy #$06
        bne ie790
ie7a4:  sta $07e1        //00-xx-00
        stx $07e2
        lda #$2d         //"-"
        sta $07e3
        lda $dd09
        ldy #$07
        bne ie790
ie7b6:  sta $07e4        //00-00-xx
        stx $07e5
        lda $dd08
        rts

e7bf:
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$1b,$00,$00,$00,$00,$08,$00
        .byte $12,$00,$00,$00,$00,$00,$00,$00
        .byte $03,$01,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00

e7ee:  .byte $00,$00,$00,$00
e7f2:  .byte $00,$00,$00,$00,$80

e7f7:  .byte $00,$55,$aa,$ff,$01,$02,$04,$08     // memtest pattern
        .byte $10,$20,$40,$80,$fe,$fd,$fb,$f7     //
        .byte $ef,$df,$bf,$7f                     //

e80b:  .byte $00,$05,$0a,$0f,$01,$02,$04,$08
        .byte $0e,$0d,$0b,$07


.encoding "screencode_mixed"
e817:  .text "c-64 dead test rev 781220"
e830:  .text "count"
e835:  .text "zero page"
e83e:  .text "stack page"
e848:  .text "ram test"
e850:  .text "color ram"
e859:  .text "sound test"
e863:  .text "screen ram"

e86d:  .byte $11,$15,$19,$22,$19,$15,$11         // soundtest
e874:  .byte $25,$9a,$b1,$4b,$b1,$9a,$25         //
e87b:  .byte $22,$2b,$33,$44,$33,$2b,$22         //
e882:  .byte $4b,$34,$61,$95,$61,$34,$4b         //
e889:  .byte $44,$56,$66,$89,$66,$56,$44         //
e890:  .byte $95,$69,$c2,$2b,$c2,$69,$95         //
e897:  .byte $45,$11,$25                         //
e89a:  .byte $00,$00,$00                         //
e89d:  .byte $08,$00,$00,$09,$00,$28,$ff,$1f     //
        .byte $af                                 //


e8a6:  .byte $20,$20,$20,$20,$20,$20,$20,$20     // box upper part
        .byte $20,$20,$20,$20,$20,$20,$22,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$23

e8ce:  .byte $20,$20,$20,$20,$20,$20,$20,$20     // box text. 4164 etc.
        .byte $20,$20,$20,$20,$20,$20,$27,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$34,$31,$36,$34,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$27
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$27,$20
        .byte $20,$20,$20,$20,$15,$39,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$15
        .byte $32,$31,$20,$20,$20,$20,$20,$27
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$27,$20
        .byte $20,$20,$20,$20,$15,$31,$30,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$15
        .byte $32,$32,$20,$20,$20,$20,$20,$27
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$27,$20
        .byte $20,$20,$20,$20,$15,$31,$31,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$15
        .byte $32,$33,$20,$20,$20,$20,$20,$27
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$27,$20
        .byte $20,$20,$20,$20,$15,$31,$32,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$15
        .byte $32,$34,$20,$20,$20,$20,$20,$27
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$27,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$20
        .byte $20,$20,$20,$20,$20,$20,$20,$27
        .byte $ff

e9bf:  .byte $06,$06,$06,$06,$06,$06,$06,$06     //color
        .byte $06,$06,$06,$06,$06,$06,$02,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$02
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$02,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$02
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$02,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$02
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$02,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$02
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$02,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$02
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$02,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$06
        .byte $06,$06,$06,$06,$06,$06,$06,$02
        .byte $ff

eab0:  .byte $20,$20,$20,$20,$20,$20,$20,$20     //box lower part
        .byte $20,$20,$20,$20,$20,$20,$24,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$25

ead8:  .byte $00,$00,$00,$00,$00,$00,$00,$00     //font
        .byte $7e,$42,$42,$7e,$46,$46,$46,$00
        .byte $7e,$62,$62,$7e,$62,$62,$7e,$00
        .byte $7e,$42,$40,$40,$40,$42,$7e,$00
        .byte $7e,$42,$42,$62,$62,$62,$7e,$00
        .byte $7e,$60,$60,$78,$70,$70,$7e,$00
        .byte $7e,$60,$60,$78,$70,$70,$70,$00
        .byte $7e,$42,$40,$6e,$62,$62,$7e,$00
        .byte $42,$42,$42,$7e,$62,$62,$62,$00
        .byte $10,$10,$10,$18,$18,$18,$18,$00
        .byte $04,$04,$04,$06,$06,$66,$7e,$00
        .byte $42,$44,$48,$7e,$66,$66,$66,$00
        .byte $40,$40,$40,$60,$60,$60,$7e,$00
        .byte $43,$67,$5b,$43,$43,$43,$43,$00
        .byte $e2,$d2,$ca,$c6,$c2,$c2,$c2,$00
        .byte $7e,$42,$42,$46,$46,$46,$7e,$00
        .byte $7e,$42,$42,$7e,$60,$60,$60,$00
        .byte $7e,$42,$42,$62,$6a,$66,$7e,$00
        .byte $7e,$42,$42,$7e,$68,$64,$62,$00
        .byte $7e,$42,$40,$7e,$02,$62,$7e,$00
        .byte $7e,$18,$18,$18,$18,$18,$18,$00
        .byte $62,$62,$62,$62,$62,$62,$3c,$00
        .byte $62,$62,$62,$62,$62,$24,$18,$00
        .byte $c2,$c2,$c2,$c2,$da,$e6,$c2,$00
        .byte $62,$62,$24,$18,$24,$62,$62,$00
        .byte $62,$62,$62,$34,$18,$18,$18,$00
        .byte $7f,$03,$06,$08,$10,$60,$7f,$00
        .byte $3c,$30,$30,$30,$30,$30,$3c,$00
        .byte $0e,$10,$30,$fe,$30,$60,$ff,$00
        .byte $3c,$0c,$0c,$0c,$0c,$0c,$3c,$00
        .byte $00,$18,$3c,$7e,$18,$18,$18,$18
        .byte $00,$10,$30,$7f,$7f,$30,$10,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $0e,$0e,$60,$60,$60,$60,$0e,$0e
        .byte $00,$00,$00,$07,$0f,$1c,$18,$18
        .byte $00,$00,$00,$e0,$f0,$38,$18,$18
        .byte $18,$18,$1c,$0f,$07,$00,$00,$00
        .byte $18,$18,$38,$f0,$e0,$00,$00,$00
        .byte $00,$00,$00,$ff,$ff,$00,$00,$00
        .byte $18,$18,$18,$18,$18,$18,$18,$18
        .byte $0c,$18,$30,$30,$30,$18,$0c,$00
        .byte $30,$18,$0c,$0c,$0c,$18,$30,$00
        .byte $00,$66,$3c,$ff,$3c,$66,$00,$00
        .byte $00,$18,$18,$7e,$18,$18,$00,$00
        .byte $00,$00,$00,$00,$00,$18,$18,$30
        .byte $00,$00,$00,$7e,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$18,$18,$00
        .byte $00,$03,$06,$0c,$18,$30,$60,$00
        .byte $7e,$42,$42,$42,$42,$42,$7e,$00
        .byte $30,$30,$10,$10,$3c,$3c,$3c,$00
        .byte $7e,$02,$02,$7e,$40,$40,$7e,$00
        .byte $7e,$02,$02,$7e,$06,$06,$7e,$00
        .byte $60,$60,$60,$66,$7e,$06,$06,$00
        .byte $7e,$40,$40,$7e,$02,$02,$7e,$00
        .byte $78,$48,$40,$7e,$42,$42,$7e,$00
        .byte $7e,$42,$04,$08,$08,$08,$08,$00
        .byte $3c,$24,$24,$3c,$66,$66,$7e,$00
        .byte $7e,$42,$42,$7e,$06,$06,$06,$00
prefill:


.fill ($ffff-prefill-5),$aa

         *=$fffa
         .word $e000
         *=$fffc
         .word $e000
         *=$fffe
         .word $e000

//---------------------------------------
//eof