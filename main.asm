//BasicUpstart2(start)

* = $8000 "Main"

// Constants
.namespace constants {
    .label  MAIN_COLOR   = $05
    .label  BORDER_COLOR = $03
    .label  SCREEN_MEM   = $0400
}

.word coldstart             // coldstart vector
.word start                 // start vector
.byte $C3,$C2,$CD,'8','0'   //..CBM80..


#import "screen.asm"
#import "keyb.asm"
#import "hex.asm"


.pc = * "Kernel Start"

coldstart:
                ldx #$FF
                sei
                txs
                cld
                stx $d016
                jsr $fda3 // Prepare IRQ
                jsr $fd50 // Init memory. Rewrite this routine to speed up boot process.
                jsr $fd15 // Init I/O
                jsr $ff5b // Init video
                cli
start:
                jsr initApp;
                print(testString)

getKeyb:
                jsr Keyboard.start
                bcs NoValidInput
                stx MemMap.KEYB_SPACE.TempX
                sty MemMap.KEYB_SPACE.TempY
                cmp #$ff
                // Check A for Alphanumeric keys
                beq NoNewAphanumericKey
                jsr printKey
                jmp getKeyb

printKey:
                cPrint()
                rts


NoNewAphanumericKey:
                // Check X & Y for Non-Alphanumeric Keys
                ldx MemMap.KEYB_SPACE.TempX
                ldy MemMap.KEYB_SPACE.TempY
NoValidInput:   // This may be substituted for an errorhandler if needed.
                jmp getKeyb


initApp: {
                ClearColorRam($00)
                ClearScreen(constants.SCREEN_MEM, ' ')
                SetBorderColor(constants.MAIN_COLOR)
                SetBackgroundColor(constants.BORDER_COLOR)
                jsr Screen.init
                jsr Keyboard.init
                rts
}

.pc = * "Kernel Data"

.encoding "screencode_mixed"
testString:
        .text "=stid= os - v 0.1.1a"
        .byte $ff
        .byte 0


* = $9FFF "EpromFiller"
    .byte 0


