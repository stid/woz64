#importonce

#import "../hardware/sid.asm"

.filenamespace Cia
// https://www.c64-wiki.com/wiki/CIA

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================

// CIA 1
// ========================================================

.label          C1PRA       = $DC00     // CIA 1 A Register Monitoring/control of the 8 data lines of Port A
                                        // Read/Write: Bit 0..7 keyboard matrix columns
                                        // Read: Joystick Port 2: Bit 0..3 Direction (Left/Right/Up/Down), Bit 4 Fire button. 0 = activated.
                                        // Read: Lightpen: Bit 4 (as fire button), connected also with "/LP" (Pin 9) of the VIC
                                        // Read: Paddles: Bit 2..3 Fire buttons, Bit 6..7 Switch control port 1 (%01=Paddles A) or 2 (%10=Paddles B)

.label          C1PRB       = $DC01     // Monitoring/control of the 8 data lines of Port B. The lines are used for multiple purposes:
                                        // Read/Write: Bit 0..7 keyboard matrix rows
                                        // Read: Joystick Port 1: Bit 0..3 Direction (Left/Right/Up/Down), Bit 4 Fire button. 0 = activated.
                                        // Read: Bit 6: Timer A: Toggle/Impulse output (see register 14 bit 2)
                                        // Read: Bit 7: Timer B: Toggle/Impulse output (see register 15 bit 2)

.label          C1DDRA	    = $DC02     // Bit X: 0=Input (read only), 1=Output (read and write)

.label          C1DDRB	    = $DC03     // Bit X: 0=Input (read only), 1=Output (read and write)

.label          C1TALO	    = $DC04     // Read: actual value Timer A (Low Byte)
                                        // Writing: Set latch of Timer A (Low Byte)

.label          C1TAHI	    = $DC05     // Read: actual value Timer A (High Byte)
                                        // Writing: Set latch of timer A (High Byte) - if the timer is stopped, the high-byte will automatically be re-set as well


.label          C1TBLO	    = $DC06     // Read: actual value Timer B (Low Byte)
                                        // Writing: Set latch of Timer B (Low Byte)


.label          C1TBHI	    = $DC07     // Read: actual value Timer B (High Byte)
                                        // Writing: Set latch of timer B (High Byte) - if the timer is stopped, the high-byte will automatically be re-set as well

.label          C1TOD10THS 	= $DC08     // Read:
                                        // Bit 0..3: Tenth seconds in BCD-format ($0-$9)
                                        // Bit 4..7: always 0
                                        // Writing:
                                        // Bit 0..3: if CRB-Bit7=0: Set the tenth seconds in BCD-format
                                        // Bit 0..3: if CRB-Bit7=1: Set the tenth seconds of the alarm time in BCD-format

.label          C1TODSEC   	= $DC09     // Bit 0..3: Single seconds in BCD-format ($0-$9)
                                        // Bit 4..6: Ten seconds in BCD-format ($0-$5)
                                        // Bit 7: always 0

.label          C1TODMIN   	= $DC0A     // Bit 0..3: Single minutes in BCD-format( $0-$9)
                                        // Bit 4..6: Ten minutes in BCD-format ($0-$5)
                                        // Bit 7: always 0

.label          C1TODHR   	= $DC0B     // Bit 0..3: Single hours in BCD-format ($0-$9)
                                        // Bit 4..6: Ten hours in BCD-format ($0-$5)
                                        // Bit 7: Differentiation AM/PM, 0=AM, 1=PM
                                        // Writing into this register stops TOD, until register 8 (TOD 10THS) will be read.

.label          C1TSDR      = $DC0C     // The byte within this register will be shifted bitwise to or from the SP-pin with every positive slope at the CNT-pin.

.label          C1ICR       = $DC0D     // CIA1 is connected to the IRQ-Line.
                                        // Read: (Bit0..4 = INT DATA, Origin of the interrupt)
                                        // Bit 0: 1 = Underflow Timer A
                                        // Bit 1: 1 = Underflow Timer B
                                        // Bit 2: 1 = Time of day and alarm time is equal
                                        // Bit 3: 1 = SDR full or empty, so full byte was transferred, depending of operating mode serial bus
                                        // Bit 4: 1 = IRQ Signal occured at FLAG-pin (cassette port Data input, serial bus SRQ IN)
                                        // Bit 5..6: always 0
                                        // Bit 7: 1 = IRQ An interrupt occured, so at least one bit of INT MASK and INT DATA is set in both registers.
                                        // Flags will be cleared after reading the register!
                                        // Write: (Bit 0..4 = INT MASK, Interrupt mask)
                                        // Bit 0: 1 = Interrupt release through timer A underflow
                                        // Bit 1: 1 = Interrupt release through timer B underflow
                                        // Bit 2: 1 = Interrupt release if clock=alarmtime
                                        // Bit 3: 1 = Interrupt release if a complete byte has been received/sent.
                                        // Bit 4: 1 = Interrupt release if a positive slope occurs at the FLAG-Pin.
                                        // Bit 5..6: unused
                                        // Bit 7: Source bit. 0 = set bits 0..4 are clearing the according mask bit. 1 = set bits 0..4 are setting the according mask bit. If all bits 0..4 are cleared, there will be no change to the mask.

.label          C1CRA       = $DC0E     // Control Timer A
                                        // Bit 0: 0 = Stop timer; 1 = Start timer
                                        // Bit 1: 1 = Indicates a timer underflow at port B in bit 6.
                                        // Bit 2: 0 = Through a timer overflow, bit 6 of port B will get high for one cycle , 1 = Through a timer underflow, bit 6 of port B will be inverted
                                        // Bit 3: 0 = Timer-restart after underflow (latch will be reloaded), 1 = Timer stops after underflow.
                                        // Bit 4: 1 = Load latch into the timer once.
                                        // Bit 5: 0 = Timer counts system cycles, 1 = Timer counts positive slope at CNT-pin
                                        // Bit 6: Direction of the serial shift register, 0 = SP-pin is input (read), 1 = SP-pin is output (write)
                                        // Bit 7: Real Time Clock, 0 = 60 Hz, 1 = 50 Hz

.label          C1CRB       = $DC0F     // Control Timer B
                                        // Bit 0: 0 = Stop timer; 1 = Start timer
                                        // Bit 1: 1 = Indicates a timer underflow at port B in bit 7.
                                        // Bit 2: 0 = Through a timer overflow, bit 7 of port B will get high for one cycle , 1 = Through a timer underflow, bit 7 of port B will be inverted
                                        // Bit 3: 0 = Timer-restart after underflow (latch will be reloaded), 1 = Timer stops after underflow.
                                        // Bit 4: 1 = Load latch into the timer once.
                                        // Bit 5..6:
                                        //  %00 = Timer counts System cycle
                                        //  %01 = Timer counts positive slope on CNT-pin
                                        //  %10 = Timer counts underflow of timer A
                                        //  %11 = Timer counts underflow of timer A if the CNT-pin is high
                                        // Bit 7: 0 = Writing into the TOD register sets the clock time, 1 = Writing into the TOD register sets the alarm time.


// CIA 2
// ========================================================

.label          C2PRA       = $DD00     // CIA 2 A Register Monitoring/control of the 8 data lines of Port A
                                        // 	Bit 0..1: Select the position of the VIC-memory
                                        //  %00, 0: Bank 3: $C000-$FFFF, 49152-65535
                                        //  %01, 1: Bank 2: $8000-$BFFF, 32768-49151
                                        //  %10, 2: Bank 1: $4000-$7FFF, 16384-32767
                                        //  %11, 3: Bank 0: $0000-$3FFF, 0-16383 (standard)
                                        // Bit 2: RS-232: TXD Output, userport: Data PA 2 (pin M)
                                        // Bit 3..5: serial bus Output (0=High/Inactive, 1=Low/Active)
                                        // Bit 3: ATN OUT
                                        // Bit 4: CLOCK OUT
                                        // Bit 5: DATA OUT
                                        // Bit 6..7: serial bus Input (0=Low/Active, 1=High/Inactive)
                                        // Bit 6: CLOCK IN
                                        // Bit 7: DATA IN

.label          C2PRB       = $DD01     // Monitoring/control of the 8 data lines of Port B. The lines are used for multiple purposes:
                                        // Bit 0..7: userport Data PB 0-7 (Pins C,D,E,F,H,J,K,L)
                                        // The KERNAL offers several RS232-Routines, which use the pins as followed:
                                        // Bit 0, 3..7: RS-232: reading
                                        // Bit 0: RXD
                                        // Bit 3: RI
                                        // Bit 4: DCD
                                        // Bit 5: User port pin J
                                        // Bit 6: CTS
                                        // Bit 7: DSR
                                        // Bit 1..5: RS-232: writing
                                        // Bit 1: RTS
                                        // Bit 2: DTR
                                        // Bit 3: RI
                                        // Bit 4: DCD
                                        // Bit 5: User port pin J

.label          C2DDRA	    = $DD02     // Bit X: 0=Input (read only), 1=Output (read and write)

.label          C2DDRB	    = $DD03     // Bit X: 0=Input (read only), 1=Output (read and write)

.label          C2TALO	    = $DD04     // Read: actual value Timer A (Low Byte)
                                        // Writing: Set latch of Timer A (Low Byte)

.label          C2TAHI	    = $DD05     // Read: actual value Timer A (High Byte)
                                        // Writing: Set latch of timer A (High Byte) - if the timer is stopped, the high-byte will automatically be re-set as well


.label          C2TBLO	    = $DD06     // Read: actual value Timer B (Low Byte)
                                        // Writing: Set latch of Timer B (Low Byte)


.label          C2TBHI	    = $DD07     // Read: actual value Timer B (High Byte)
                                        // Writing: Set latch of timer B (High Byte) - if the timer is stopped, the high-byte will automatically be re-set as well

.label          C2TOD10THS 	= $DD08     // Read:
                                        // Bit 0..3: Tenth seconds in BCD-format ($0-$9)
                                        // Bit 4..7: always 0
                                        // Writing:
                                        // Bit 0..3: if CRB-Bit7=0: Set the tenth seconds in BCD-format
                                        // Bit 0..3: if CRB-Bit7=1: Set the tenth seconds of the alarm time in BCD-format

.label          C2TODSEC   	= $DD09     // Bit 0..3: Single seconds in BCD-format ($0-$9)
                                        // Bit 4..6: Ten seconds in BCD-format ($0-$5)
                                        // Bit 7: always 0

.label          C2TODMIN   	= $DD0A     // Bit 0..3: Single minutes in BCD-format( $0-$9)
                                        // Bit 4..6: Ten minutes in BCD-format ($0-$5)
                                        // Bit 7: always 0

.label          C2TODHR   	= $DD0B     // Bit 0..3: Single hours in BCD-format ($0-$9)
                                        // Bit 4..6: Ten hours in BCD-format ($0-$5)
                                        // Bit 7: Differentiation AM/PM, 0=AM, 1=PM
                                        // Writing into this register stops TOD, until register 8 (TOD 10THS) will be read.

.label          C2TSDR      = $DD0C     // The byte within this register will be shifted bitwise to or from the SP-pin with every positive slope at the CNT-pin.

.label          C2ICR       = $DD0D     // CIA2 is connected to the NMI-Line.
                                        // Bit 4: 1 = NMI Signal occured at FLAG-pin (RS-232 data received)
                                        // Bit 7: 1 = NMI An interrupt occured, so at least one bit of INT MASK and INT DATA is set in both registers.

.label          C2CRA       = $DD0E     // Control Timer A
                                        // Bit 0: 0 = Stop timer; 1 = Start timer
                                        // Bit 1: 1 = Indicates a timer underflow at port B in bit 6.
                                        // Bit 2: 0 = Through a timer overflow, bit 6 of port B will get high for one cycle , 1 = Through a timer underflow, bit 6 of port B will be inverted
                                        // Bit 3: 0 = Timer-restart after underflow (latch will be reloaded), 1 = Timer stops after underflow.
                                        // Bit 4: 1 = Load latch into the timer once.
                                        // Bit 5: 0 = Timer counts system cycles, 1 = Timer counts positive slope at CNT-pin
                                        // Bit 6: Direction of the serial shift register, 0 = SP-pin is input (read), 1 = SP-pin is output (write)
                                        // Bit 7: Real Time Clock, 0 = 60 Hz, 1 = 50 Hz

.label          C2CRB       = $DD0F     // Control Timer B
                                        // Bit 0: 0 = Stop timer; 1 = Start timer
                                        // Bit 1: 1 = Indicates a timer underflow at port B in bit 7.
                                        // Bit 2: 0 = Through a timer overflow, bit 7 of port B will get high for one cycle , 1 = Through a timer underflow, bit 7 of port B will be inverted
                                        // Bit 3: 0 = Timer-restart after underflow (latch will be reloaded), 1 = Timer stops after underflow.
                                        // Bit 4: 1 = Load latch into the timer once.
                                        // Bit 5..6:
                                        //  %00 = Timer counts System cycle
                                        //  %01 = Timer counts positive slope on CNT-pin
                                        //  %10 = Timer counts underflow of timer A
                                        //  %11 = Timer counts underflow of timer A if the CNT-pin is high
                                        // Bit 7: 0 = Writing into the TOD register sets the clock time, 1 = Writing into the TOD register sets the alarm time.



// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


* = * "CIA HW"

init: {
                lda     #$7F            // KILL INTERRUPTS
                sta     Cia.C1ICR
                sta     Cia.C2ICR

                sta     Cia.C1PRA       // TURN ON STOP KEY

                lda     #%00001000      // SHUT OFF TIMERS
                sta     Cia.C1CRA
                sta     Cia.C2CRA
                sta     Cia.C1CRB
                sta     Cia.C2CRB

                // CONFIGURE PORTS
                ldx     #$00            // SET UP KEYBOARD INPUTS
                stx     Cia.C1DDRB      // KEYBOARD INPUTS
                stx     Cia.C2DDRB      // USER PORT (NO RS-232)

                stx     Sid.FMVC       // TURN OFF SID

                dex                     // set X = $FF

                stx     Cia.C1DDRA      // KEYBOARD OUTPUTS

                lda     #%00000111      // SET SERIAL/VA14/15 (CLKHI)
                sta     Cia.C2PRA

                lda     #%00111111      // ;SET SERIAL IN/OUT, VA14/15OUT
                sta     Cia.C2DDRA

                rts
}

