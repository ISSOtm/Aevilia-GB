

INCLUDE "macros.asm"
INCLUDE "constants.asm"
	
	
SECTION "Tileset pointers", ROMX[$4300]

TilesetROMBanks:: ; MAKE SURE THIS IS 256-BYTE ALIGNED!!
	db BANK(OverworldTileset)
	db BANK(IntroTileset)
	db BANK(InteriorTileset)
	db BANK(InteriorTilesetDark)
	
TilesetPointers::
	dw OverworldTileset
	dw IntroTileset
	dw InteriorTileset
	dw InteriorTilesetDark


; ** Tileset structure **
; Byte		- Number of tiles
; Tiles		- VRAM tile data
; blk_meta	- Block metadata
; palette	- Pointers to BG Palettes 2-8


INCLUDE "tileset/overworld.asm"
INCLUDE "tileset/intro.asm"
INCLUDE "tileset/interior.asm"
INCLUDE "tileset/interior_dark.asm"
