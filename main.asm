.cpu _6502

//BasicUpstart2(start)
#import "./core/mem_map.asm"

* = $8000 "Main"


//------------------------------------------------------------------------------------
.const  MAIN_COLOR      = $03
.const  BORDER_COLOR    = $05
.const  CR              = $0d
.const  BS              = $14
.const  ADV_CHAR        = '@'
.const  INIT_IRQ        = $fda3
.const  INIT_MEM        = $fd50
.const  INIT_IO         = $fd15
.const  INIT_VID        = $ff5b
.const  SCRN_CTRL       = $d016
.const  RASTER_LINE     = $d012
.const  INTERRUPT_CTRL  = $dc0d
.const  NMSK_INTERRUPT_CTRL  = $dd0d
.const  TIMER_A_CTRL  = $DC0E

//------------------------------------------------------------------------------------
.word coldstart             // coldstart vector
.word start                 // start vector
.byte $C3,$C2,$CD,'8','0'   //..CBM80..

//------------------------------------------------------------------------------------
#import "./core/init.asm"
#import "./libs/print.asm"
#import "./core/screen.asm"
#import "./core/keyboard.asm"
#import "./progs/woz_shell.asm"

//------------------------------------------------------------------------------------
// Main Program
//------------------------------------------------------------------------------------
* = * "Kernel Start"

coldstart:
                ldx #$FF
                sei
                txs
                cld
                stx SCRN_CTRL   // Set Screen Bits
                jsr INIT_IRQ    // Prepare IRQ
                jsr INIT_MEM    // Init memory. Rewrite this routine to speed up boot process.
                jsr INIT_IO     // Init I/O
                jsr INIT_VID    // Init video
                cli

* = * "App Start"

//------------------------------------------------------------------------------------
start:
                jsr initApp;
                jsr WozShell.start

loop:
                lda #$FF
Raster:         cmp RASTER_LINE         // Raster done?
                bne Raster
                jsr Keyboard.ReadKeyb
                jsr Keyboard.GetKey
                bcs loop

                cmp #CR
                beq execute

                cmp #BS
                beq backspace
inputChar:
                jsr WozShell.push                  // Char in Buffer
                PrintChar()
                jmp loop
backspace:
                jsr WozShell.backspace
                PrintChar()
                jmp loop

execute:
                jsr WozShell.push                  // CR in Buffer
                jsr Screen.screenNewLine
                jsr WozShell.exec
                jsr Screen.screenNewLine
                jsr WozShell.clear
                jmp loop

//------------------------------------------------------------------------------------
initApp: {

                sei
                lda #$7f
                sta INTERRUPT_CTRL      // disable timer interrupts which can be generated by the two CIA chips
                sta NMSK_INTERRUPT_CTRL // the kernal uses such an interrupt to flash the cursor and scan the keyboard, so we better
                                        // stop it.

                lda INTERRUPT_CTRL      // by reading this two registers we negate any pending CIA irqs.
                lda NMSK_INTERRUPT_CTRL // if we don't do this, a pending CIA irq might occur after we finish setting up our irq.
                                        // we don't want that to happen.

                // Disable 0e TIMER
                lda #254
                and TIMER_A_CTRL
                sta TIMER_A_CTRL

                ScreenClearColorRam($00)
                ScreenClear(' ')
                ScreenSetBorderColor(BORDER_COLOR)
                ScreenSetBackgroundColor(MAIN_COLOR)
                jsr Init.init
                cli
                rts
}

//------------------------------------------------------------------------------------
* = * "Kernel Data"



* = $9FFF "EpromFiller"
                .byte 0


