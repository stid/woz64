#importonce
#import "../core/pseudo.asm"
#import "../core/system.asm"
#import "../libs/print.asm"
#import "../libs/timers.asm"
#import "../core/module.asm"
#import "../hardware/vic.asm"
#import "../devices/keyboard.asm"
#import "../devices/video.asm"
#import "../hardware/mem_map.asm"

.filenamespace WozShell





* = * "WozShell Routines"

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================

.const          R       =       $52
.const          CR      =       $0d
.const          BS      =       $14

.const          MAX_CMD_BUFFER  = 40

// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


clear:
init: {
                lda     #-1
                sta     MemMap.SHELL.pos
                rts
}

start: {
                PrintLine(lineString)
                PrintLine(aboutString)
                PrintLine(lineString)

                //jsr WozShell.startCursor
                jmp WozShell.loop
}

startCursor: {
                sei
                lda #$01
                sta Vic.INTE

                lda #<cursortInt
                ldx #>cursortInt

                sta $314    // store in $314/$315
                stx $315

                lda #$00
                sta Vic.RCNT

                lda $d011
                and #$7f
                sta $d011

                cli

                rts

        cursortInt: {
                dec $d019       // ACK INT



                pla
                tay
                pla
                tax
                pla
                rti
        }
}



//------------------------------------------------------------------------------------
loop: {
                jsr     Keyboard.waitForKey

                cmp     #CR
                beq     execute

                cmp     #BS
                beq     backspace
        inputChar:
                jsr     WozShell.push                 // Char in Buffer
                cpy     #MAX_CMD_BUFFER
                beq     loop
                PrintChar()
                jmp     loop
        backspace:
                jsr     WozShell.backspace
                PrintChar()
                jmp     loop

        execute:
                jsr     WozShell.push                 // CR in Buffer
                jsr     Video.screenNewLine
                jsr     WozShell.exec
                jsr     Video.screenNewLine
                jsr     WozShell.clear
                jmp     loop
}

toDebug: {
                ModuleToDebug(module_type, module_name, version)
                rts
}

push: {
                ldy     MemMap.SHELL.pos
                iny
                cpy     #MAX_CMD_BUFFER
                beq     done
                sty     MemMap.SHELL.pos
                sta     MemMap.SHELL.buffer, y
        done:
                rts
}

backspace: {
                ldy     MemMap.SHELL.pos
                cpy     #-1
                beq     done
                dey
                sty     MemMap.SHELL.pos
        done:
                rts
}

exec: {
                lda     MemMap.SHELL.buffer     // Check first char
                cmp     #'!'
                beq     stidExec                // if ! is stid mon command
                jmp     wozExec                 // Otherwise exec Woz
                // Expect exec functions to RTS
}


stidExec: {
                ldy     #1

                lda     MemMap.SHELL.buffer, y

                cmp     #$48 // H
                beq     cmdHelp

                cmp     #$52 // R
                beq     cmdReset

                cmp     #$56 // V
                beq     cmdSysInfo

                .break
                cmp     #$54 // T
                beq     cmdTest

    done:
                rts
    // STID Commands
    cmdHelp:
                PrintLine(helpString)
                jmp     done
    cmdReset:
                jmp     $fce2       // SYS 64738

    cmdSysInfo:
                jsr     System.toDebug
                jmp     done

    cmdTest:  {
                // TODO: Optizime for code size here
                        ldy     #1
                loop:
                        tya
                        jsr     clearVideo
                        jsr     clearColors
                        jsr     Timers.delayOne
                        iny
                        bne     loop
                        VideoClearColorRam($03)

                        jmp     done

        clearVideo: {
                        ldx     #0
                !loop:
                        sta     $0400, x
                        sta     $0400 + $100, x
                        sta     $0400 + $200, x
                        sta     $0400 + $300, x
                        inx
                        bne     !loop-
                        rts
        }

        clearColors: {
                        ldx     #0
                !loop:
                        sta     $d800, x
                        sta     $d800 + $100, x
                        sta     $d800 + $200, x
                        sta     $d800 + $300, x
                        inx
                        bne     !loop-
                        rts
        }
    }
}


// WOZ MONITOR FLOW - FROM APPLE1
wozExec: {
                ldy     #-1
                lda     #0
                tax
        SETSTOR:
                asl
        SETMODE:
                cmp     #0
                beq     !+
                eor     #%10000000
!:
                sta     MemMap.SHELL.MODE

        BLSKIP: iny

        NEXTITEM:
                lda     MemMap.SHELL.buffer,Y   //Get character
                cmp     #CR
                bne     CONT                    // We're done if it's CR!
                rts
        CONT:
                cmp     #'.'
                bcc     BLSKIP                  // Ignore everything below "."!
                beq     SETMODE                 // Set BLOCK XAM mode ("." = $AE)
                cmp     #':'
                beq     SETSTOR                 // Set STOR mode! $BA will become $7B
                cmp     #R
                beq     RUN              // Run the program! Forget the rest
                stx     MemMap.SHELL.L          // Clear input value (X=0)
                stx     MemMap.SHELL.H
                sty     MemMap.SHELL.YSAV       // Save Y for comparison

// Here we're trying to parse a new hex value

        NEXTHEX:
                lda     MemMap.SHELL.buffer,y   // Get character for hex test
                eor     #$30                // Map digits to 0-9
                cmp     #9+1                // Is it a decimal digit?
                bcc     DIG                 // Yes!
                adc     #$88                // Map letter "A"-"F" to $FA-FF
                cmp     #$FA                // Hex letter?
                bcc     NOTHEX              // No! Character not hex

        DIG:
                asl
                asl                             // Hex digit to MSD of A
                asl
                asl

                ldx     #4                      // Shift count
        HEXSHIFT:
                asl                      // Hex digit left, MSB to carry
                rol     MemMap.SHELL.L          // Rotate into LSD
                rol     MemMap.SHELL.H          // Rotate into MSD's
                dex                      // Done 4 shifts?
                bne     HEXSHIFT                // No, loop
                iny                      // Advance text index
                bne     NEXTHEX                 // Always taken

        NOTHEX: cpy     MemMap.SHELL.YSAV       //Was at least 1 hex digit given?
                bne     !+                // No! Ignore all, start from scratch
                rts
        !:
                bit     MemMap.SHELL.MODE       //Test MODE byte
                bvc     NOTSTOR                 // B6=0 is STOR, 1 is XAM or BLOCK XAM

// STOR mode, save LSD of new hex byte

                lda     MemMap.SHELL.L               // LSD's of hex data
                sta     (MemMap.SHELL.STL,X)         //Store current 'store index'(X=0)
                inc     MemMap.SHELL.STL             //Increment store index.
                bne     NEXTITEM                 // No carry!
                inc     MemMap.SHELL.STH             // Add carry to 'store index' high
        TONEXTITEM:
                jmp     NEXTITEM                     //Get next command item.

//-------------------------------------------------------------------------
//  RUN user's program from last opened location
//-------------------------------------------------------------------------

        RUN:    jmp     (MemMap.SHELL.XAML)          // Run user's program

//-------------------------------------------------------------------------
//  We're not in Store mode
//-------------------------------------------------------------------------

        NOTSTOR:
                bmi     XAMNEXT                     // B7 = 0 for XAM, 1 for BLOCK XAM

// We're in XAM mode now

                ldx     #2                          // Copy 2 bytes
        SETADR:
                lda     MemMap.SHELL.L-1,X          // Copy hex data to
                sta     MemMap.SHELL.STL-1,X        // 'store index'
                sta     MemMap.SHELL.XAML-1,X       // and to 'XAM index'
                dex                          // Next of 2 bytes
                bne     SETADR                      // Loop unless X = 0

// Print address and data from this address, fall through next BNE.

        NXTPRNT:
                bne     PRDATA                // NE means no address to print
                lda     #CR                  // Print CR first
                PrintChar()
                lda     MemMap.SHELL.XAMH          // Output high-order byte of address
                jsr     PRBYTE
                lda     MemMap.SHELL.XAML          // Output low-order byte of address
                jsr     PRBYTE
                lda     #':'                    // Print colon
                PrintChar()

        PRDATA: lda     #' '                        // Print space
                PrintChar()
                lda     (MemMap.SHELL.XAML,X)       // Get data from address (X=0)
                jsr     PRBYTE                      // Output it in hex format
        XAMNEXT:
                stx     MemMap.SHELL.MODE           // 0 -> MODE (XAM mode).
                lda     MemMap.SHELL.XAML           // See if there's more to print
                cmp     MemMap.SHELL.L
                lda     MemMap.SHELL.XAMH
                sbc     MemMap.SHELL.H
                bcs     TONEXTITEM                  // Not less! No more data to output

                inc     MemMap.SHELL.XAML           // Increment 'examine index'
                bne     MOD8CHK              // No carry!
                inc     MemMap.SHELL.XAMH

        MOD8CHK:
                lda     MemMap.SHELL.XAML           // If address MOD 8 = 0 start new line
                and     #%00000111
                bpl     NXTPRNT                     // Always taken.

// -------------------------------------------------------------------------
//   Subroutine to print a byte in A in hex form (destructive)
// -------------------------------------------------------------------------

        PRBYTE:
                pha                             // Save A for LSD
                lsr
                lsr
                lsr                             // MSD to LSD position
                lsr
                jsr     PRHEX                   // Output hex digit
                pla                             // Restore A

// Fall through to print hex routine

// -------------------------------------------------------------------------
//   Subroutine to print a hexadecimal digit
// -------------------------------------------------------------------------

        PRHEX:  and     #%00001111                  // Mask LSD for hex print
                ora     #'0'                    // Add "0"
                cmp     #'9'+1                // Is it a decimal digit?
                bcc     !+                    // Yes! output it
                adc     #6                    // Add offset for letter A-F
        !:
                PrintChar()
                rts
}


// ========================================================
// ////// DATA ////////////////////////////////////////////
// ========================================================

* = * "WozShell Data"
module_type:    .byte   Module.TYPES.PROG
version:        .byte   1, 5, 0

.encoding "screencode_mixed"
module_name:
                .text   "woz-shell"
                .byte   0

helpString:
                .text   "----------------------"
                .byte   $8e
                .text   "h : this help"
                .byte   $8e
                .text   "r : hard reset"
                .byte   $8e
                .text   "v : modue versions"
                .byte   $8e
                .text   "----------------------"
                .byte   $8e, 0

aboutString:
                .text   "woz64 mon - v 1.6.0"
                .byte   $8e, 0
lineString:
                .text   "----------------------------------------"
                .byte   $8e, 0

#import "../hardware/mem_map.asm"
