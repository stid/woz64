BasicUpstart2(start)

// c64
.const bgcolor       = $d020
.const bordercolor   = $d021
.const screenram     = $0400

// kernel functions
.const bsout               = $ab1e //kernel character output sub
.const chrout              = $ffd2
.const clearscreen         = $e544

// chars
.const cr = 13

// memory map
.const kernel          = $ff80
.const start_basic     = $0281
.const end_basic       = $0037
.const step_size_garb  = $000f
.const dataset         = $0090
.const input_dev       = 153
.const out_dev         = 154
.const time_1          = 160
.const time_2          = 161
.const time_3          = 162
.const ds_motor        = 192

// color petscii
.const color_cyan          = $9f
.const color_light_blue    = $9a
.const color_green         = $1e

// local const
.const pline_len           = 40
.const hex_open_chr        = $5b
.const hex_close_chr       = $5d

.macro printHexByte(stringAddr, value) {
        lda #<stringAddr
        ldy #>stringAddr
        ldx value
        jsr printhex_row
}

.macro printHexWord(stringAddr, value) {
        bPrint(stringAddr)
        jsr popenhex
        lda value+1
        jsr printhex
        lda value
        jsr printhex
        jsr pclosehex
        bChar(cr)
}

.macro bPrint(stringAddr) {
        lda #<stringAddr
        ldy #>stringAddr
        jsr bsout
}

.macro bChar(char) {
        lda #char
        jsr chrout
}

//==========================================================
// code
//==========================================================

start:
                ldx #$00     // color
                stx $d021    // set background color
                stx $d020    // set border color

                jsr clearscreen

                bChar(color_cyan)
                bPrint(str_about)

                bChar(cr)
                bChar(color_light_blue)

getKeyb:
                jsr Keyboard
                bcs NoValidInput
                stx TempX
                sty TempY
                cmp #$ff
                // Check A for Alphanumeric keys
                beq NoNewAphanumericKey
                // jsr printhex

                cmp #'m'
                beq mapMemory
                cmp #'q'
                beq exit

                jmp getKeyb

NoNewAphanumericKey:
                // Check X & Y for Non-Alphanumeric Keys
                ldx TempX
                ldy TempY
                //stx $0401
                //sty $0402
NoValidInput:   // This may be substituted for an errorhandler if needed.
                jmp getKeyb


exit:           rts


mapMemory:
                ldx #pline_len       // lenht of pline
                jsr pline

                // ----------------------
                // ------ map table start
                // ----------------------

                // kernel
                printHexByte(str_row_kernel, kernel)

                // start basic area
                printHexWord(str_row_basic_start, start_basic)

                // end basic area
                printHexWord(str_row_basic_end, end_basic)

                // garbadge
                printHexByte(str_row_step_size_garb, printhex_row)

                // dataset
                printHexByte(str_row_dataset, dataset)

                // input dev
                printHexByte(str_row_input_dev, input_dev)

                // out dev
                printHexByte(str_row_out_dev, out_dev)

                // time 1
                printHexByte(str_row_time_1, time_1)

                // time 2
                printHexByte(str_row_time_2, time_2)

                // time 2
                printHexByte(str_row_time_2, time_3)

                // dataset motor
                printHexByte(str_row_ds_motor, ds_motor)


                // ----------------------
                // ------ map table end
                // ----------------------
                bChar(cr)

                ldx #pline_len
                jsr pline
                rts

//   ————————————————————————————————————
//   popenhex
//   ————————————————————————————————————
popenhex:
                bChar(hex_open_chr)
                bChar(color_green)
                rts

//   ————————————————————————————————————
//   pclosehex
//   ————————————————————————————————————
pclosehex:
                bChar(color_light_blue)
                bChar(hex_close_chr)
                rts

//   ————————————————————————————————————
//   printhex_row
//   ————————————————————————————————————
//   ————————————————————————————————————
//   preparatory ops: .a: msn ascii char
//                    .x: lsn ascii char
//                    .y: value
//
//   returned values: none
//   ————————————————————————————————————
printhex_row:
                sta a_cache    // preserve a
                txa            // store x using a as it will be lost after bsout
                pha
                lda a_cache    // get back a
                jsr bsout
                jsr popenhex
                pla             // saved x back in a from saved a
                jsr printhex
                jsr pclosehex
                bChar(cr)
                rts

//   ————————————————————————————————————
//   printhex
//   ————————————————————————————————————
//   ————————————————————————————————————
//   preparatory ops: .a: byte to convert
//
//   returned values: none
//   ————————————————————————————————————
printhex:
                pha
                jsr binhex
                jsr chrout
                txa
                jsr chrout
                pla
                rts

//   ————————————————————————————————————
//   btohex
//   ————————————————————————————————————
//   ————————————————————————————————————
//   preparatory ops: .a: byte to convert
//
//   returned values: .a: msn ascii char
//                    .x: lsn ascii char
//                    .y: entry value
//   ————————————————————————————————————
binhex:         pha                   //save byte
                and #%00001111        //extract lsn
                tax                   //save it
                pla                   //recover byte
                lsr                   //extract...
                lsr                   //msn
                lsr
                lsr
                pha                   //save msn
                txa                   //lsn
                jsr binhex1          //generate ascii lsn
                tax                   //save
                pla                   //get msn & fall thru
//
//   convert nybble to hex ascii equivalent...
binhex1:        cmp #$0a
                bcc binhex2          //in decimal range
                adc #$66              //hex compensate
binhex2:        eor #%00110000        //finalize nybble
                rts                   //done



//   ————————————————————————————————————
//   pline
//   ————————————————————————————————————
//   ————————————————————————————————————
//   preparatory ops: .x: lenght
//   returned values: none
//   ————————————————————————————————————
pline:
                cpx #0
                bne pline_start
                ldx #12 // default to 12 if 0 is passed in x
pline_start:    lda #102
pline_loop:     jsr chrout
                dex
                cpx #0
                bne pline_loop
                lda #cr
                jsr chrout
                rts


.encoding "petscii_mixed"
str_about:
        .text "c=64 mapper v2.0 by =stid="
        .byte 13, 0
str_row_kernel:
        .text " kernel                            "
        .byte 0
str_row_basic_start:
        .text " start basic area                "
        .byte 0
str_row_basic_end:
        .text " end basic area                  "
        .byte 0
str_row_step_size_garb:
        .text " step size garbage                 "
        .byte 0
str_row_dataset:
        .text " dataset                           "
        .byte 0
str_row_input_dev:
        .text " input device                      "
        .byte 0
str_row_out_dev:
        .text " output device                     "
        .byte 0
str_row_time_1:
        .text " time 1                            "
        .byte 0
str_row_time_2:
        .text " time 2                            "
        .byte 0
str_row_time_3:
        .text " time 3                            "
        .byte 0
str_row_ds_motor:
        .text " dataset motor                     "
        .byte 0

a_cache:
        .byte 0

TempX:
        .byte 0
TempY:
        .byte 0




/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Keyboard IO Routine
    ~~~~~~~~~~~~~~~~~~~
        By: TWW/CTR


    Preparatory Settings
    ~~~~~~~~~~~~~~~~~~~~
        None


    Destroys
    ~~~~~~~~
        Accumulator
        X-Register
        Y-Register
        Carry / Zero / Negative
        $dc00
        $dc01
        $50-$5f


    Footprint
    ~~~~~~~~~
        #$206 Bytes


    Information
    ~~~~~~~~~~~
        The routine uses "2 Key rollower" or up to 3 if the key-combination doesen't induce shadowing.
        If 2 or 3 keys are pressed simultaneously (within 1 scan) a "No Activity" state has to occur before new valid keys are returned.
        RESTORE is not detectable and must be handled by NMI IRQ.
        SHIFT LOCK is not detected due to unreliability.


    Usage
    ~~~~~
      Example Code:

            jsr Keyboard
            bcs NoValidInput
                stx TempX
                sty TempY
                cmp #$ff
                beq NoNewAphanumericKey
                    // Check A for Alphanumeric keys
                    sta $0400
            NoNewAphanumericKey:
            // Check X & Y for Non-Alphanumeric Keys
            ldx TempX
            ldy TempY
            stx $0401
            sty $0402
       NoValidInput:  // This may be substituted for an errorhandler if needed.


    Returned
    ~~~~~~~~

        +=================================================+
        |             Returned in Accumulator             |
        +===========+===========+=============+===========+
        |  $00 - @  |  $10 - p  |  $20 - SPC  |  $30 - 0  |
        |  $01 - a  |  $11 - q  |  $21 -      |  $31 - 1  |
        |  $02 - b  |  $12 - r  |  $22 -      |  $32 - 2  |
        |  $03 - c  |  $13 - s  |  $23 -      |  $33 - 3  |
        |  $04 - d  |  $14 - t  |  $24 -      |  $34 - 4  |
        |  $05 - e  |  $15 - u  |  $25 -      |  $35 - 5  |
        |  $06 - f  |  $16 - v  |  $26 -      |  $36 - 6  |
        |  $07 - g  |  $17 - w  |  $27 -      |  $37 - 7  |
        |  $08 - h  |  $18 - x  |  $28 -      |  $38 - 8  |
        |  $09 - i  |  $19 - y  |  $29 -      |  $39 - 9  |
        |  $0a - j  |  $1a - z  |  $2a - *    |  $3a - :  |
        |  $0b - k  |  $1b -    |  $2b - +    |  $3b - ;  |
        |  $0c - l  |  $1c - £  |  $2c - ,    |  $3c -    |
        |  $0d - m  |  $1d -    |  $2d - -    |  $3d - =  |
        |  $0e - n  |  $1e - ^  |  $2e - .    |  $3e -    |
        |  $0f - o  |  $1f - <- |  $2f - /    |  $3f -    |
        +-----------+-----------+-------------+-----------+

        +================================================================================
        |                             Return in X-Register                              |
        +=========+=========+=========+=========+=========+=========+=========+=========+
        |  Bit 7  |  Bit 6  |  Bit 5  |  Bit 4  |  Bit 3  |  Bit 2  |  Bit 1  |  Bit 0  |
        +---------+---------+---------+---------+---------+---------+---------+---------+
        | CRSR UD |   F5    |   F3    |   F1    |   F7    | CRSR RL | RETURN  |INST/DEL |
        +---------+---------+---------+---------+---------+---------+---------+---------+

        +================================================================================
        |                             Return in Y-Register                              |
        +=========+=========+=========+=========+=========+=========+=========+=========+
        |  Bit 7  |  Bit 6  |  Bit 5  |  Bit 4  |  Bit 3  |  Bit 2  |  Bit 1  |  Bit 0  |
        +---------+---------+---------+---------+---------+---------+---------+---------+
        |RUN STOP | L-SHIFT |   C=    | R-SHIFT |CLR/HOME |  CTRL   |         |         |
        +---------+---------+---------+---------+---------+---------+---------+---------+

        CARRY:
          - Set = Error Condition (Check A for code):
              A = #$01 => No keyboard activity is detected.
              A = #$02 => Control Port #1 Activity is detected.
              A = #$03 => Key Shadowing / Ghosting is detected.
              A = #$04 => 2 or 3 new keys is detected within one scan
              A = #$05 => Awaiting "No Activity" state
          - Clear = Valid input
              A =  #$ff => No new Alphanumeric Keys detected (some key(s) being held down AND/OR some Non-Alphanumeric key is causing valid return).
              A <> #$ff => New Alphanumeric Key returned. Non-Alphanumeric keys may also be returned in X or Y Register

    Issues/ToDo:
    ~~~~~~~~~~~~
        - None


    Improvements:
    ~~~~~~~~~~~~~
        - Replace the subroutine with a pseudocommand and account for speedcode parameter (Memory vs. Cycles).
        - Shorten the routine / Optimize if possible.


    History:
    ~~~~~~~~
    V2.5 - New test tool.
           Added return of error codes.
           Fixed a bug causing Buffer Overflow.
           Fixed a bug in Non Alphanumerical Flags from 2.0.
    V2.1 - Shortened the source by adding .for loops & Updated the header and some comments.
           Added "simultaneous keypress" check.
    V2.0 - Added return of non-Alphanumeric keys into X & Y-Registers.
           Small optimizations here and there.
    V1.1 - Unrolled code to make it faster and optimized other parts of it.
           Removed SHIFT LOCK scanning.
    V1.0 - First Working Version along with test tool.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    .pc = * "Keyboard Scan Routine"


    // ZERO PAGE Varibles
    .const ScanResult       = $50  // 8 bytes
    .const BufferNew        = $58  // 3 bytes
    .const KeyQuantity      = $5b  // 1 byte
    .const NonAlphaFlagX    = $5c  // 1 byte
    .const NonAlphaFlagY    = $5d  // 1 byte
    .const TempZP           = $5e  // 1 byte
    .const SimultaneousKeys = $5f  // 1 byte

    // Operational Variables
    .var MaxKeyRollover = 3

Keyboard:
{
    jmp Main


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Routine for Scanning a Matrix Row

KeyInRow:
    asl
    bcs *+5
        jsr KeyFound
    .for (var i = 0 ; i < 7 ; i++) {
        inx
        asl
        bcs *+5
            jsr KeyFound
    }
    rts


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Routine for handling: Key Found

KeyFound:
    stx TempZP
    dec KeyQuantity
    bmi OverFlow
    ldy KeyTable,x
    ldx KeyQuantity
    sty BufferNew,x
    ldx TempZP
    rts

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Routine for handling: Overflow

OverFlow:
    pla  // Dirty hack to handle 2 layers of JSR
    pla
    pla
    pla
    // Don't manipulate last legal buffer as the routine will fix itself once it gets valid input again.
    lda #$03
    sec
    rts


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Exit Routine for: No Activity

NoActivityDetected:
    // Exit With A = #$01, Carry Set & Reset BufferOld.
    lda #$00
    sta SimultaneousAlphanumericKeysFlag  // Clear the too many keys flag once a "no activity" state is detected.
    stx BufferOld
    stx BufferOld+1
    stx BufferOld+2
    sec
    lda #$01
    rts


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Exit Routine for Control Port Activity

ControlPort:
    // Exit with A = #$02, Carry Set. Keep BufferOld to verify input after Control Port activity ceases
    sec
    lda #$02
    rts


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Configure Data Direction Registers
Main:
    ldx #$ff
    stx $dc02       // Port A - Output
    ldy #$00
    sty $dc03       // Port B - Input


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Check for Port Activity

    sty $dc00       // Connect all Keyboard Rows
    cpx $dc01
    beq NoActivityDetected

    lda SimultaneousAlphanumericKeysFlag
    beq !+
        // Waiting for all keys to be released before accepting new input.
        lda #$05
        sec
        rts
!:

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Check for Control Port #1 Activity

    stx $dc00       // Disconnect all Keyboard Rows
    cpx $dc01       // Only Control Port activity will be detected
    bne ControlPort


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Scan Keyboard Matrix

    lda #%11111110
    sta $dc00
    ldy $dc01
    sty ScanResult+7
    sec
    .for (var i = 6 ; i > -1 ; i--) {
        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+i
    }


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Check for Control Port #1 Activity (again)

    stx $dc00       // Disconnect all Keyboard Rows
    cpx $dc01       // Only Control Port activity will be detected
    bne ControlPort


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Initialize Buffer, Flags and Max Keys

    // Reset current read buffer
    stx BufferNew
    stx BufferNew+1
    stx BufferNew+2

    // Reset Non-AlphaNumeric Flag
    inx
    stx NonAlphaFlagY

    // Set max keys allowed before ignoring result
    lda #MaxKeyRollover
    sta KeyQuantity

    // Counter to check for simultaneous alphanumeric key-presses
    lda #$fe
    sta SimultaneousKeys


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Check and flag Non Alphanumeric Keys

    lda ScanResult+6
    eor #$ff
    and #%10000000     // Left Shift
    lsr
    sta NonAlphaFlagY
    lda ScanResult+0
    eor #$ff
    and #%10100100     // RUN STOP - C= - CTRL
    ora NonAlphaFlagY
    sta NonAlphaFlagY
    lda ScanResult+1
    eor #$ff
    and #%00011000     // Right SHIFT - CLR HOME
    ora NonAlphaFlagY
    sta NonAlphaFlagY

    lda ScanResult+7  // The rest
    eor #$ff
    sta NonAlphaFlagX


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Check for pressed key(s)

    lda ScanResult+7
    cmp #$ff
    beq *+5
        jsr KeyInRow
    .for (var i = 6 ; i > -1 ; i--) {
        ldx #[7-i]*8
        lda ScanResult+i
        beq *+5
            jsr KeyInRow
    }


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Key Scan Completed

    // Put any new key (not in old scan) into buffer
    ldx #MaxKeyRollover-1
    !:  lda BufferNew,x
        cmp #$ff
        beq Exist        // Handle 'null' values
        cmp BufferOld
        beq Exist
        cmp BufferOld+1
        beq Exist
        cmp BufferOld+2
        beq Exist
            // New Key Detected
            inc BufferQuantity
            ldy BufferQuantity
            sta Buffer,y
            // Keep track of how many new Alphanumeric keys are detected
            inc SimultaneousKeys
            beq TooManyNewKeys
    Exist:
        dex
        bpl !-

    // Anything in Buffer?
    ldy BufferQuantity
    bmi BufferEmpty
        // Yes: Then return it and tidy up the buffer
        dec BufferQuantity
        lda Buffer
        ldx Buffer+1
        stx Buffer
        ldx Buffer+2
        stx Buffer+1
        jmp Return

BufferEmpty:  // No new Alphanumeric keys to handle.
    lda #$ff

Return:  // A is preset
    clc
    // Copy BufferNew to BufferOld
    ldx BufferNew
    stx BufferOld
    ldx BufferNew+1
    stx BufferOld+1
    ldx BufferNew+2
    stx BufferOld+2
    // Handle Non Alphanumeric Keys
    ldx NonAlphaFlagX
    ldy NonAlphaFlagY
    rts

TooManyNewKeys:
    sec
    lda #$ff
    sta BufferQuantity
    sta SimultaneousAlphanumericKeysFlag
    lda #$04
    rts

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
KeyTable:
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  // CRSR DOWN, F5, F3, F1, F7, CRSR RIGHT, RETURN, INST DEL
    .byte $ff, $05, $13, $1a, $34, $01, $17, $33  // LEFT SHIFT, "E", "S", "Z", "4", "A", "W", "3"
    .byte $18, $14, $06, $03, $36, $04, $12, $35  // "X", "T", "F", "C", "6", "D", "R", "5"
    .byte $16, $15, $08, $02, $38, $07, $19, $37  // "V", "U", "H", "B", "8", "G", "Y", "7"
    .byte $0e, $0f, $0b, $0d, $30, $0a, $09, $39  // "N", "O" (Oscar), "K", "M", "0" (Zero), "J", "I", "9"
    .byte $2c, $00, $3a, $2e, $2d, $0c, $10, $2b  // ",", "@", ":", ".", "-", "L", "P", "+"
    .byte $2f, $1e, $3d, $ff, $ff, $3b, $2a, $1c  // "/", "^", "=", RIGHT SHIFT, HOME, ";", "*", "£"
    .byte $ff, $11, $ff, $20, $32, $ff, $1f, $31  // RUN STOP, "Q", "C=" (CMD), " " (SPC), "2", "CTRL", "<-", "1"

BufferOld:
    .byte $ff, $ff, $ff

Buffer:
    .byte $ff, $ff, $ff, $ff

BufferQuantity:
    .byte $ff

SimultaneousAlphanumericKeysFlag:
    .byte $00
}