//BasicUpstart2(start)

* = $8000 "Main"

// Constants
.namespace constants {
    .label  MainColor   = $05
    .label  BorderColor = $03
    .label  ScreenMem   = $0400
}

.word coldstart             // coldstart vector
.word start                 // coldstart vector

.byte $C3
.byte $C2
.byte $CD
.byte $38
.byte $30


coldstart:
                sei
                stx $d016
                jsr $fda3 // Prepare IRQ
                jsr $fd50 // Init memory. Rewrite this routine to speed up boot process.
                jsr $fd15 // Init I/O
                jsr $ff5b // Init video
                cli
/*
                jsr $E453
                jsr $E3BF
                jsr $E422
                ldx #$FB
*/
                //tsx

start:
                jsr initApp;
                print(testString)
                .for(var i=0; i<23; i++) {
                    print(testString2)
                }
deadLoop:       jmp deadLoop


initApp: {
                ClearColorRam($00)
                ClearScreen(constants.ScreenMem, ' ')
                SetBorderColor(constants.MainColor)
                SetBackgroundColor(constants.BorderColor)
                jsr Screen.init
                rts
}

#import "screen.asm"


.encoding "screencode_mixed"
testString:
        .text "fantastic job 1.0 by =stid="
        .byte 13
        .byte 13
        .byte 0

testString2:
        .text ".======================================."
        .byte 13
        .byte 0

* = $9FFF "EpromFiller"
    .byte 0


