#importonce
.filenamespace Sid
https://www.c64-wiki.com/wiki/SID

// ========================================================
// ////// CONSTANTS ///////////////////////////////////////
// ========================================================


.label          FV1L            = $d400      // frequency voice 1 low byte
.label          FV1H            = $d401      // frequency voice 1 high byte
.label          PCWV1L          = $d402      // pulse wave duty cycle voice 1 low byte

// TODO: Add more

.label          FMVC            = $d418     // filter mode and main volume control
                                            // Bit 7 mute voice 3
                                            // Bit 6 high pass
                                            // Bit 5 band pass
                                            // Bit 4 low pass
                                            // Bit 3-0 main volume



// ========================================================
// ////// METHODS /////////////////////////////////////////
// ========================================================


* = * "SID HW"

init: {
                ldx     #$00
                stx     Sid.FMVC       // TURN OFF SID
                rts
}


