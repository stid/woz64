.cpu _6502

BasicUpstart2(Boot.warmStart)
#import "./hardware/mem_map.asm"

* = $8000 "Main"

.word Boot.coldStart                 // coldstart vector
.word Boot.warmStart                 // start vector
.byte $C3,$C2,$CD,'8','0'            //..CBM80..

#import "./core/boot.asm"

* = * "Kernel Data"

* = $9FFF "EpromFiller" // 8K Cartridge, $8000-$9FFF (ROML / ROMH).
// * = $BFFF "EpromFiller" // 16K Cartridge, $8000-$9FFF / $A000-$BFFF (ROML / ROMH).
                        // GAME = 0, EXROM = 0
                        // ROML/ROMH are read only, Basic ROM is overwritten by ROMH.
                .byte 0


