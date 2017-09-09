
SECTION "Test interior tileset", ROMX

TestInteriorTileset::
	db 10
	
	; $80 - $82
	dw $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF ; House vertical edge
	dw $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $FFFF ; House horizontal edge
	dw $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $FFFF ; House corner
	
	; $83 - $85
	dw $FF3F, $C07F, $C07F, $C07F, $C07F, $C07F, $C07F, $C07F ; Door top-left
	dw $C07F, $C07F, $C07F, $C07F, $C07F, $C07F, $C07F, $FFFF ; Door bottom-left
	dw $33FE, $03FE, $03FE, $03FE, $03FE, $03FE, $03FE, $FFFF ; Door bottom-right
	
	; $86 - $87
	dw $0000, $0000, $0000, $0000, $000F, $0E11, $1E21, $1E21 ; Window top-left
	dw $003F, $1E21, $1E21, $1E21, $1E21, $1E21, $003F, $0000 ; Window bottom-left
	
	; $88
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00 ; Grey tile
	
	; $89
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00 ; Accesses the third color of a palette
	
	; $00 : Black void
	tile_attr $88, 0, 1, 0, 0, 0, 0
	tile_attr $88, 0, 1, 0, 0, 0, 0
	tile_attr $88, 0, 1, 0, 0, 0, 0
	tile_attr $88, 0, 1, 0, 0, 0, 0
	
	; $01 : House wall
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	
	; $02 : House bottom wall
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	
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
	tile_attr $88, 0, 1, 0, 0, 0, 0
	tile_attr $88, 0, 1, 0, 0, 0, 0
	tile_attr $88, 0, 1, 0, 0, 0, 0
	tile_attr $88, 0, 1, 0, 0, 0, 0
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
	
	dw TestWarriorTopPalette
	dw TestWarriorBottomPalette
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
