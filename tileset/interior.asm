
SECTION "Interior tileset", ROMX

InteriorTileset::
	db $06
	
	; $80
	dw $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
	
	; $81
	dw $0033, $0033, $00CC, $00CC, $0033, $0033, $00CC, $00CC
	dw $000F, $000F, $000F, $000F, $00F0, $00F0, $00F0, $00F0
	dw $0A0A, $0505, $0A0A, $0505, $0A0A, $0505, $0A0A, $0505
	
	
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	
	tile_attr $82, 1, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
REPT $7E
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
ENDR
	
	dw InteriorMainPalette
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
