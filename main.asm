BasicUpstart2(start)

* = $8000 "Main"

//------------------------------------------------------------------------------------
.const  MAIN_COLOR   = $03
.const  BORDER_COLOR = $05
.const  SCREEN_MEM   = $0400
.const  CR = $0d
.const  BS = $14

//------------------------------------------------------------------------------------
.word coldstart             // coldstart vector
.word start                 // start vector
.byte $C3,$C2,$CD,'8','0'   //..CBM80..

//------------------------------------------------------------------------------------
#import "screen.asm"
#import "keyb2.asm"
#import "hex.asm"
#import "shell.asm"

//------------------------------------------------------------------------------------
// Main Program
//------------------------------------------------------------------------------------
* = * "Kernel Start"

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
//------------------------------------------------------------------------------------
start:
                //sei

                jsr initApp;
                print(testString)
loop:
                lda #$FF
Raster:         cmp $D012
	        bne Raster
                jsr Keyboard2.ReadKeyb
                jsr Keyboard2.GetKey
                bcs loop

                cmp #CR
                beq cr

                cmp #BS
                beq backspace
inputChar:
                jsr Shell.push
                cPrint()
                jmp loop
backspace:
                jsr Shell.backspace
                cPrint()
                jmp loop
cr:
                jsr Shell.push
                jsr Screen.screenNewLine
                jsr Shell.wozExec
                jsr Screen.screenNewLine
                jsr Shell.clear
                jmp loop

//------------------------------------------------------------------------------------
initApp: {
                // Disable Basic
                lda #254
                and $dc0e
                sta $dc0e

                ClearColorRam($00)
                ClearScreen(SCREEN_MEM, ' ')
                SetBorderColor(BORDER_COLOR)
                SetBackgroundColor(MAIN_COLOR)
                jsr Screen.init
                jsr Keyboard2.init
                jsr Shell.init
                rts
}

//------------------------------------------------------------------------------------
* = * "Hoax"
hoax: {
        print(hoaxString)
        jmp loop
}

//------------------------------------------------------------------------------------
* = * "Kernel Data"

.encoding "screencode_mixed"

testString:
        .text "woz64 mon - v 0.1.5a"
        .byte $8e
        .text "----------------------------------------"
        .byte $8e, 0
hoaxString:
        .text "=stid= 1972"
        .byte $8e, 0

* = $9FFF "EpromFiller"
    .byte 0


