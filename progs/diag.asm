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
.const f0000 = $0000
.const f0100 = $0100
.const f0200 = $0200
.const f0300 = $0300
.const f0400 = $0400
.const f0408 = $0408
.const f0450 = $0450
.const f0478 = $0478
.const f04a0 = $04a0
.const f04c8 = $04c8
.const f04f0 = $04f0
.const f0500 = $0500
.const f0518 = $0518
.const f0600 = $0600
.const f0630 = $0630
.const f0658 = $0658
.const f0700 = $0700
.const f0748 = $0748
.const f07c0 = $07c0
.const f0800 = $0800
.const f0900 = $0900
.const f0a00 = $0a00
.const f0b00 = $0b00
.const f0c00 = $0c00
.const f0d00 = $0d00
.const f0e00 = $0e00
.const f0f00 = $0f00
.const fcfff = $cfff
.const fd800 = $d800
.const fd900 = $d900
.const fda00 = $da00
.const fda30 = $da30
.const fda58 = $da58
.const fdb00 = $db00
.const fdb48 = $db48
.const fdc07 = $dc07
.const fdd07 = $dd07
//
.const a045d = $045d
.const a045e = $045e
.const a045f = $045f
.const a0485 = $0485
.const a0486 = $0486
.const a0487 = $0487
.const a04ad = $04ad
.const a04ae = $04ae
.const a04af = $04af
.const a04d5 = $04d5
.const a04d6 = $04d6
.const a04d7 = $04d7
.const a04fd = $04fd
.const a04fe = $04fe
.const a04ff = $04ff
.const a0699 = $0699
.const a069a = $069a
.const a069b = $069b
.const a06a4 = $06a4
.const a06a5 = $06a5
.const a06a6 = $06a6
.const a06c1 = $06c1
.const a06c2 = $06c2
.const a06c3 = $06c3
.const a06cc = $06cc
.const a06cd = $06cd
.const a06ce = $06ce
.const a06e9 = $06e9
.const a06ea = $06ea
.const a06eb = $06eb
.const a06f4 = $06f4
.const a06f5 = $06f5
.const a06f6 = $06f6
.const a0711 = $0711
.const a0712 = $0712
.const a0713 = $0713
.const a071c = $071c
.const a071d = $071d
.const a071e = $071e
.const a07c6 = $07c6
.const a07c7 = $07c7
.const a07c8 = $07c8
.const a07c9 = $07c9
.const a07d3 = $07d3
.const a07d4 = $07d4
.const a07d5 = $07d5
.const a07d6 = $07d6
.const a07d7 = $07d7
.const a07d8 = $07d8
.const a07d9 = $07d9
.const a07da = $07da
.const a07db = $07db
.const a07dc = $07dc
.const a07de = $07de
.const a07df = $07df
.const a07e0 = $07e0
.const a07e1 = $07e1
.const a07e2 = $07e2
.const a07e3 = $07e3
.const a07e4 = $07e4
.const a07e5 = $07e5
.const a07e6 = $07e6
.const a07e7 = $07e7
.const ad020 = $d020
.const ad021 = $d021
.const ad400 = $d400
.const ad401 = $d401
.const ad402 = $d402
.const ad403 = $d403
.const ad404 = $d404
.const ad405 = $d405
.const ad406 = $d406
.const ad407 = $d407
.const ad408 = $d408
.const ad409 = $d409
.const ad40a = $d40a
.const ad40b = $d40b
.const ad40c = $d40c
.const ad40d = $d40d
.const ad40e = $d40e
.const ad40f = $d40f
.const ad410 = $d410
.const ad411 = $d411
.const ad412 = $d412
.const ad413 = $d413
.const ad414 = $d414
.const ad417 = $d417
.const ad418 = $d418
.const ada99 = $da99
.const ada9a = $da9a
.const ada9b = $da9b
.const adaa4 = $daa4
.const adaa5 = $daa5
.const adaa6 = $daa6
.const adac1 = $dac1
.const adac2 = $dac2
.const adac3 = $dac3
.const adacc = $dacc
.const adacd = $dacd
.const adace = $dace
.const adae9 = $dae9
.const adaea = $daea
.const adaeb = $daeb
.const adaf4 = $daf4
.const adaf5 = $daf5
.const adaf6 = $daf6
.const adb11 = $db11
.const adb12 = $db12
.const adb13 = $db13
.const adb1c = $db1c
.const adb1d = $db1d
.const adb1e = $db1e
.const adc08 = $dc08
.const adc09 = $dc09
.const adc0a = $dc0a
.const adc0b = $dc0b
.const adc0e = $dc0e
.const adc0f = $dc0f
.const add08 = $dd08
.const add09 = $dd09
.const add0a = $dd0a
.const add0b = $dd0b
.const add0e = $dd0e
.const add0f = $dd0f

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

ie010:  lda #<fead8      //font
        ldx #>fead8
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
ie034:  lda fe7ee,x
        sta fdc07,x
        lda fe7f2,x
        sta fdd07,x
        dex
        bne ie034
        ldx #$00
        stx a02
        stx a03
        ldx #$00
ie04b:  lda #$20
        sta f0400,x
        sta f0500,x
        sta f0600,x
        sta f0700,x
        lda #$06
        sta fd800,x
        sta fd900,x
        sta fda00,x
        sta fdb00,x
        inx
        bne ie04b
        ldx #$27
ie06c:  lda fe8a6,x      //box upper part
        sta f0630,x
        lda #$02         //red
        sta fda30,x
        dex
        bpl ie06c
        ldx #$00
ie07c:  lda fe8ce,x
        cmp #$ff
        beq ie08a
        sta f0658,x
        inx
        jmp ie07c

ie08a:  ldx #$00
ie08c:  lda fe9bf,x      //color
        cmp #$ff
        beq ie09a
        sta fda58,x
        inx
        jmp ie08c

ie09a:  ldx #$27
ie09c:  lda feab0,x      //box lower part
        sta f0748,x
        lda #$02         //red
        sta fdb48,x
        dex
        bpl ie09c
        lda #$08
        sta adc0f
        sta add0f
        lda #$48
        sta adc0e
        lda #$08
        sta add0e

ie0bc:  ldx #$2f
ie0be:  lda fe7bf-1,x      //vic/d000- values
        sta fcfff,x
        dex
        bne ie0be
        ldx #$18
ie0c9:  lda fe817,x      //c-64 dead test rev 781220
        sta f0408,x
        dex
        bpl ie0c9
        ldx #$04
ie0d4:  lda fe830,x      //count
        sta f07c0,x
        dex
        bpl ie0d4
        lda a02
        and #$0f
        ora #$30
        sta a07c9
        lda a02
        lsr
        lsr
        lsr
        lsr
        and #$0f
        ora #$30
        sta a07c8
        lda a03
        and #$0f
        ora #$30
        sta a07c7
        lda a03
        lsr
        lsr
        lsr
        lsr
        and #$0f
        ora #$30
        sta a07c6
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

        lda #<fead8      //font
        ldx #>fead8
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
        sta ad418
        ldx #$00
        lda #$20
ie16d:  sta f0400,x
        sta f0500,x
        inx
        bne ie16d
        ldx #$2e
        lda #$20
ie17a:  sta f0600,x
        dex
        bpl ie17a
        jmp ie0bc

ie183:  lda #$00
        sta ad020
        sta ad021
        ldx #$15
        ldy #$00
ie18f:  lda fe7f7,x      //memtest pattern
        sta f0100,y
        sta f0200,y
        sta f0300,y
        sta f0400,y
        sta f0500,y
        sta f0600,y
        sta f0700,y
        sta f0800,y
        sta f0900,y
        sta f0a00,y
        sta f0b00,y
        sta f0c00,y
        sta f0d00,y
        sta f0e00,y
        sta f0f00,y
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
ie1ce:  lda f0100,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0200,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0300,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0400,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0500,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0600,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0700,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0800,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0900,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0a00,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0b00,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0c00,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0d00,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0e00,y
        cmp fe7f7,x      //memtest pattern
        bne ie24c
        lda f0f00,y
        cmp fe7f7,x      //memtest pattern
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

ie25a:  eor fe7f7,x      //memtest pattern
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
        sta ad020
        sta ad021
        txa
        ldx #$7f
        ldy #$00
ie2b3:  dey
        bne ie2b3
        dex
        bne ie2b3
        tax
        lda #$00
        sta ad020
        sta ad021
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
ie2fc:  lda fe835,x      //zeropage test
        sta f0450,x
        dex
        bpl ie2fc
        ldx #$13
ie307:  lda fe7f7,x      //memtest pattern
        ldy #$12
ie30c:  sta f0000,y
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
        lda fe7f7,x      //memtest pattern
        ldy #$12
ie323:  cmp f0000,y
        bne ie33b
        iny
        bne ie323
        dex
        bpl ie307
        lda #$0f         //"o"
        sta a045d
        lda #$0b         //"k"
        sta a045e
        jmp ie110

ie33b:  eor fe7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta a045d
        lda #$01         //"a"
        sta a045e
        lda #$04         //"d"
        sta a045f
        jmp ie4c1

ie351:  ldx #$09
ie353:  lda fe83e,x      //stack page
        sta f0478,x
        dex
        bpl ie353
        ldx #$13
ie35e:  lda fe7f7,x      //memtest pattern
        ldy #$00
ie363:  sta f0100,y
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
        lda fe7f7,x      //memtest pattern
ie378:  cmp f0100,y
        bne ie390
        iny
        bne ie378
        dex
        bpl ie35e
        lda #$0f         //"o"
        sta a0485
        lda #$0b         //"k"
        sta a0486
        jmp ie113

ie390:  eor fe7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta a0485
        lda #$01         //"a"
        sta a0486
        lda #$04         //"d"
        sta a0487
        jmp ie4c1

ie3a6:  ldx #$09
ie3a8:  lda fe863,x      //screen ram
        sta f04a0,x
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
ie3c0:  lda fe7f7,x      //memtest pattern
        sta (p09),y
        txa
        ldx #$00
ie3c8:  dex
        bne ie3c8
        tax
        lda (p09),y
        cmp fe7f7,x      //memtest pattern
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
        sta a04ad
        lda #$0b         //"k"
        sta a04ae
        rts

ie3f0:  eor fe7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta a04ad
        lda #$01         //"a"
        sta a04ae
        lda #$04         //"d"
        sta a04af
        jsr ie4c1

ie406:  ldx #$08
ie408:  lda fe850,x      //color ram test
        sta f04c8,x
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
ie422:  lda fe80b,x
        sta (p09),y
        txa
        ldx #$00
ie42a:  dex
        bne ie42a
        tax
        lda (p09),y
        and #$0f
        cmp fe80b,x
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
        sta a04d5
        lda #$0b         //"k"
        sta a04d6
        rts

ie454:  eor fe80b,x
        tax
        lda #$02         //"b"
        sta a04d5
        lda #$01         //"a"
        sta a04d6
        lda #$04         //"d"
        sta a04d7
        jmp ie4c1

ie46a:  ldx #$07
ie46c:  lda fe848,x      //ram test
        sta f04f0,x
        dex
        bpl ie46c
        ldx #<$0800
        ldy #>$0800
        stx a09
        sty a0a
ie47d:  ldy #$00
        ldx #$13
ie481:  lda fe7f7,x      //memtest pattern
        sta (p09),y
        txa
        ldx #$7f
ie489:  dex
        bne ie489
        tax
        lda (p09),y
        cmp fe7f7,x      //memtest pattern
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
        sta a04fd
        lda #$0b         //"k"
        sta a04fe
        rts

ie4ae:  eor fe7f7,x      //memtest pattern
        tax
        lda #$02         //"b"
        sta a04fd
        lda #$01         //"a"
        sta a04fe
        lda #$04         //"d"
        sta a04ff
ie4c1:  txa
        and #$01
        beq ie4e0
        lda #$02         //"b"
        sta a06a4
        lda #$01         //"a"
        sta a06a5
        lda #$04         //"d"
        sta a06a6
        lda #$02         //red
        sta adaa4
        sta adaa5
        sta adaa6
ie4e0:  txa
        and #$02
        beq ie4ff
        lda #$02         //"b"
        sta a0699
        lda #$01         //"a"
        sta a069a
        lda #$04         //"d"
        sta a069b
        lda #$02         //red
        sta ada99
        sta ada9a
        sta ada9b
ie4ff:  txa
        and #$04
        beq ie51e
        lda #$02         //"b"
        sta a06cc
        lda #$01         //"a"
        sta a06cd
        lda #$04         //"d"
        sta a06ce
        lda #$02         //red
        sta adacc
        sta adacd
        sta adace
ie51e:  txa
        and #$08
        beq ie53d
        lda #$02         //"b"
        sta a06c1
        lda #$01         //"a"
        sta a06c2
        lda #$04         //"d"
        sta a06c3
        lda #$02         //red
        sta adac1
        sta adac2
        sta adac3
ie53d:  txa
        and #$10
        beq ie55c
        lda #$02         //"b"
        sta a06f4
        lda #$01         //"a"
        sta a06f5
        lda #$04         //"d"
        sta a06f6
        lda #$02         //red
        sta adaf4
        sta adaf5
        sta adaf6
ie55c:  txa
        and #$20
        beq ie57b
        lda #$02         //"b"
        sta a06e9
        lda #$01         //"a"
        sta a06ea
        lda #$04         //"d"
        sta a06eb
        lda #$02         //red
        sta adae9
        sta adaea
        sta adaeb
ie57b:  txa
        and #$40
        beq ie59a
        lda #$02         //"b"
        sta a071c
        lda #$01         //"a"
        sta a071d
        lda #$04         //"d"
        sta a071e
        lda #$02         //red
        sta adb1c
        sta adb1d
        sta adb1e
ie59a:  txa
        and #$80
        beq ie5b9
        lda #$02         //"b"
        sta a0711
        lda #$01         //"a"
        sta a0712
        lda #$04         //"d"
        sta a0713
        lda #$02         //red
        sta adb11
        sta adb12
        sta adb13
ie5b9:  jmp ie5b9

ie5bc:  ldx #$09
ie5be:  lda fe859,x      //sound test
        sta f0518,x
        dex
        bpl ie5be
        lda #$14
        sta ad418
        lda #$00
        sta ad417
        lda #$3e
        sta ad405
        lda #$ca
        sta ad406
        lda #$00
        sta ad412
        lda #$02
ie5e2:  pha
        ldx #$06
ie5e5:  lda fe86d,x
        sta ad401
        lda fe874,x
        sta ad400
        pla
        tay
        lda fe89a,y
        sta ad402
        lda fe89d,y
        sta ad403
        lda fe897,y
        sta ad404
        tya
        pha
        lda #$6a
        jsr ie6b7
        lda #$00
        sta ad404
        lda #$00
        jsr ie6b7
        dex
        bne ie5e5
        lda #$00
        sta ad417
        lda #$18
        sta ad418
        lda #$3e
        sta ad40c
        lda #$ca
        sta ad40d
        ldx #$06
ie62f:  lda fe87b,x
        sta ad408
        lda fe882,x
        sta ad407
        pla
        tay
        lda fe89a,y
        sta ad409
        lda fe89d,y
        sta ad40a
        lda fe897,y
        sta ad40b
        tya
        pha
        lda #$6a
        jsr ie6b7
        lda #$00
        sta ad40b
        lda #$00
        jsr ie6b7
        dex
        bne ie62f
        lda #$00
        sta ad417
        lda #$1f
        sta ad418
        lda #$3e
        sta ad413
        lda #$ca
        sta ad414
        ldx #$06
ie679:  lda fe889,x
        sta ad40f
        lda fe890,x
        sta ad40e
        pla
        tay
        lda fe89a,y
        sta ad410
        lda fe89d,y
        sta ad411
        lda fe897,y
        sta ad412
        tya
        pha
        lda #$6a
        jsr ie6b7
        lda #$00
        sta ad412
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
        sta adc0e
        lda #$08
        sta add0e
ie6d9:  lda adc0b
        clc
        asl
        bcc ie6ed
        lda #$10         //"p"
        sta a07db
        lda #$0d         //"m"
        sta a07dc
        clc
        bcc ie6f7
ie6ed:  lda #$01         //"a"
        sta a07db
        lda #$0d         //"m"
        sta a07dc
ie6f7:  lda adc0b
        and #$7f
        ldy #$01
        bne ie732
ie700:  sta a07d3        //xx-00-00
        stx a07d4
        lda #$2d         //"-"
        sta a07d5
        lda adc0a
        ldy #$02
        bne ie732
ie712:  sta a07d6        //00-xx-00
        stx a07d7
        lda #$2d         //"-"
        sta a07d8
        lda adc09
        ldy #$03
        bne ie732
ie724:  sta a07d9        //00-00-xx
        stx a07da
        lda adc08
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

ie76b:  lda add0b
        clc
        asl
        bcc ie77f
        lda #$10         //"p"
        sta a07e6
        lda #$0d         //"m"
        sta a07e7
        clc
        bcc ie789
ie77f:  lda #$01         //"a"
        sta a07e6
        lda #$0d         //"m"
        sta a07e7
ie789:  lda add0b
        and #$7f
        ldy #$05
ie790:  bne ie732
ie792:  sta a07de        //xx-00-00
        stx a07df
        lda #$2d         //"-"
        sta a07e0
        lda add0a
        ldy #$06
        bne ie790
ie7a4:  sta a07e1        //00-xx-00
        stx a07e2
        lda #$2d         //"-"
        sta a07e3
        lda add09
        ldy #$07
        bne ie790
ie7b6:  sta a07e4        //00-00-xx
        stx a07e5
        lda add08
        rts

fe7bf:
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$1b,$00,$00,$00,$00,$08,$00
        .byte $12,$00,$00,$00,$00,$00,$00,$00
        .byte $03,$01,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00

fe7ee:  .byte $00,$00,$00,$00
fe7f2:  .byte $00,$00,$00,$00,$80

fe7f7:  .byte $00,$55,$aa,$ff,$01,$02,$04,$08     // memtest pattern
        .byte $10,$20,$40,$80,$fe,$fd,$fb,$f7     //
        .byte $ef,$df,$bf,$7f                     //

fe80b:  .byte $00,$05,$0a,$0f,$01,$02,$04,$08
        .byte $0e,$0d,$0b,$07


.encoding "screencode_mixed"
fe817:  .text "c-64 dead test rev 781220"
fe830:  .text "count"
fe835:  .text "zero page"
fe83e:  .text "stack page"
fe848:  .text "ram test"
fe850:  .text "color ram"
fe859:  .text "sound test"
fe863:  .text "screen ram"

fe86d:  .byte $11,$15,$19,$22,$19,$15,$11         // soundtest
fe874:  .byte $25,$9a,$b1,$4b,$b1,$9a,$25         //
fe87b:  .byte $22,$2b,$33,$44,$33,$2b,$22         //
fe882:  .byte $4b,$34,$61,$95,$61,$34,$4b         //
fe889:  .byte $44,$56,$66,$89,$66,$56,$44         //
fe890:  .byte $95,$69,$c2,$2b,$c2,$69,$95         //
fe897:  .byte $45,$11,$25                         //
fe89a:  .byte $00,$00,$00                         //
fe89d:  .byte $08,$00,$00,$09,$00,$28,$ff,$1f     //
        .byte $af                                 //


fe8a6:  .byte $20,$20,$20,$20,$20,$20,$20,$20     // box upper part
        .byte $20,$20,$20,$20,$20,$20,$22,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$23

fe8ce:  .byte $20,$20,$20,$20,$20,$20,$20,$20     // box text. 4164 etc.
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

fe9bf:  .byte $06,$06,$06,$06,$06,$06,$06,$06     //color
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

feab0:  .byte $20,$20,$20,$20,$20,$20,$20,$20     //box lower part
        .byte $20,$20,$20,$20,$20,$20,$24,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$26
        .byte $26,$26,$26,$26,$26,$26,$26,$25

fead8:  .byte $00,$00,$00,$00,$00,$00,$00,$00     //font
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