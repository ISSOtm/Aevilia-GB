
SECTION "Test interior tileset", ROMX
	
TestInteriorTileset::
	db 10
	full_ptr TestInteriorTilesetTiles
	db 0
	
	db 0
	
	; $00 : Black void
	tile_attr $88, 0, 1, 0, 0, 0, 1
	tile_attr $88, 0, 1, 0, 0, 0, 1
	tile_attr $88, 0, 1, 0, 0, 0, 1
	tile_attr $88, 0, 1, 0, 0, 0, 1
	
	; $01 : House wall
	tile_attr $88, 0, 3, 0, 0, 0, 1
	tile_attr $88, 0, 3, 0, 0, 0, 1
	tile_attr $88, 0, 3, 0, 0, 0, 1
	tile_attr $88, 0, 3, 0, 0, 0, 1
	
	; $02 : House bottom wall
	tile_attr $88, 0, 3, 0, 0, 0, 1
	tile_attr $81, 0, 2, 0, 0, 0, 1
	tile_attr $88, 0, 3, 0, 0, 0, 1
	tile_attr $81, 0, 2, 0, 0, 0, 1
	
	; $03 : House left wall
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	
	; $04 : House right wall
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 1, 0, 0
	tile_attr $80, 0, 2, 0, 1, 0, 0
	
	; $05 : House bottom-left corner
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	
	; $06 : House bottom-right corner
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 1, 0, 0
	
	; $07 : Floor
	tile_attr $89, 0, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 0, 0
	
	; $08 : Door (can be walked "under")
	tile_attr $83, 0, 3, 0, 0, 0, 1
	tile_attr $84, 0, 3, 0, 0, 0, 1
	tile_attr $83, 0, 3, 0, 1, 0, 1
	tile_attr $85, 0, 3, 0, 0, 0, 1
	
	; These blocks are unused
REPT 64 - 9
	tile_attr $88, 0, 1, 0, 0, 0, 1
	tile_attr $88, 0, 1, 0, 0, 0, 1
	tile_attr $88, 0, 1, 0, 0, 0, 1
	tile_attr $88, 0, 1, 0, 0, 0, 1
ENDR
	
	
	; House tiles
REPT 3
	db 0
ENDR
	
	; Door tiles
REPT 3
	db TILE_CANWALK
ENDR
	
	; Decoration tiles
REPT 3
	db 0
ENDR
	
	db TILE_CANWALK
	
REPT $100 - 10
	db 0
ENDR
	
	
	db 0 ; No tile animations
	
	
	dw DefaultPalette
	dw HousePalette
	dw InsideHousePalette
	dw 0
	dw 0
	dw 0
	dw 0
	
