
SECTION "Interior tileset", ROMX

InteriorTileset::
	db $02
	
	; $80
	dw $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
	
	; $81
	dw $0033, $0033, $00CC, $00CC, $0033, $0033, $00CC, $00CC
	
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	
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
