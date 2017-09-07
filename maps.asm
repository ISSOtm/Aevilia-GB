

INCLUDE "macros.asm"
INCLUDE "constants.asm"


SECTION "Map pointers", ROMX[$4000]
	
MapROMBanks:: ; MAKE SURE THIS IS 256-BYTE ALIGNED!!
	db BANK(StarthamMap)
	db BANK(TestHouse)
	db BANK(IntroMap)
	db BANK(TestForestMap)
	db BANK(PlayerHouse)
	db 0
	db BANK(StarthamHouse2)
	
MapPointers::
	dw StarthamMap
	dw TestHouse
	dw IntroMap
	dw TestForestMap
	dw PlayerHouse
	dw 0
	dw StarthamHouse2
	
	
SECTION "Tileset pointers", ROMX[$4300]

TilesetROMBanks:: ; MAKE SURE THIS IS 256-BYTE ALIGNED!!
	db BANK(OverworldTileset)
	db BANK(TestInteriorTileset)
	db BANK(IntroTileset)
	db BANK(InteriorTileset)
	
TilesetPointers::
	dw OverworldTileset
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


INCLUDE "maps/startham.asm"
INCLUDE "maps/intro.asm"
INCLUDE "maps/playerhouse.asm"
INCLUDE "maps/starthamhouse2.asm"
