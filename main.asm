.cpu _6502

//BasicUpstart2(Boot.warmStart)
#import "./core/mem_map.asm"

* = $8000 "Main"

.word Boot.coldStart                 // coldstart vector
.word Boot.warmStart                 // start vector
.byte $C3,$C2,$CD,'8','0'            //..CBM80..

#import "./core/boot.asm"

* = * "Kernel Data"
* = $9FFF "EpromFiller"
                .byte 0


