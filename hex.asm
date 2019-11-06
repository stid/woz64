#importonce
#import "mem_map.asm"


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

