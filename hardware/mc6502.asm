#importonce
.filenamespace MC6502
https://sta.c64.org/cbm64mem.html

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================


.label          ZR0            = $0     // Processor port data direction register. Bits:
                                        // Bit #x: 0 = Bit #x in processor port can only be read; 1 = Bit #x in processor port can be read and written.
                                        // Default: $2F, %00101111.

.label          ZR1            = $1     // Processor port. Bits:
                                        // Bits #0-#2: Configuration for memory areas $A000-$BFFF, $D000-$DFFF and $E000-$FFFF. Values:
                                        // %x00: RAM visible in all three areas.
                                        // %x01: RAM visible at $A000-$BFFF and $E000-$FFFF.
                                        // %x10: RAM visible at $A000-$BFFF; KERNAL ROM visible at $E000-$FFFF.
                                        // %x11: BASIC ROM visible at $A000-$BFFF; KERNAL ROM visible at $E000-$FFFF.
                                        // %0xx: Character ROM visible at $D000-$DFFF. (Except for the value %000, see above.)
                                        // %1xx: I/O area visible at $D000-$DFFF. (Except for the value %100, see above.)
                                        // Bit #3: Datasette output signal level.
                                        // Bit #4: Datasette button status; 0 = One or more of PLAY, RECORD, F.FWD or REW pressed; 1 = No button is pressed.
                                        // Bit #5: Datasette motor control; 0 = On; 1 = Off.
                                        // Default: $37, %00110111.

// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


* = * "mc6502 HW"

init: {
                // SET UP THE 6510 LINES
                lda     #%00110111      // MOTOR OFF, HIRAM LOWRAM CHAREN HIGH
                sta     MC6502.ZR1      // set 1110 0111, motor off, enable I/O, enable KERNAL, Enable BASIC

                lda     #%00101111      // set 0010 1111, 0 = input, 1 = output
                sta     MC6502.ZR0      // save the 6510 I/O port direction register
                rts
}


