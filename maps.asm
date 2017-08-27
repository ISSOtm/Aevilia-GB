

INCLUDE "macros.asm"
INCLUDE "constants.asm"


SECTION "Map pointers", ROMX[$4000]
	
MapROMBanks:: ; MAKE SURE THIS IS 256-BYTE ALIGNED!!
	db BANK(TestMap)
	db BANK(TestHouse)
	db BANK(IntroMap)
	db BANK(TestForestMap)
	db BANK(TestHouseNew)
	
MapPointers::
	dw TestMap
	dw TestHouse
	dw IntroMap
	dw TestForestMap
	dw TestHouseNew
	
	
SECTION "Tileset pointers", ROMX[$4300]

TilesetROMBanks:: ; MAKE SURE THIS IS 256-BYTE ALIGNED!!
	db BANK(TestTileset)
	db BANK(TestInteriorTileset)
	db BANK(IntroTileset)
	db BANK(InteriorTileset)
	
TilesetPointers::
	dw TestTileset
	dw TestInteriorTileset
	dw IntroTileset
	dw InteriorTileset


; ** Map header structure : **
; Byte       - Tileset ID
; Word       - Map script pointer
;              (must be in same bank as map)
; Byte       - Map width
; Byte       - Map height
; Word       - Map loading script pointer
; Byte       - Number of interactions
; Int_stream - Interactions, stored sequentially
;   Byte     - A constant identifying the following structure
;   Struct   - The corresponding structure
; Bytestream - Blocks


; ** Tileset structure **
; Byte		- Number of tiles
; Tiles		- VRAM tile data
; blk_meta	- Block metadata
; palette	- Pointers to BG Palettes 2-8


INCLUDE "maps/test.asm"
INCLUDE "maps/intro.asm"
INCLUDE "maps/interior.asm"
