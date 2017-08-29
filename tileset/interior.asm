
SECTION "Interior tileset", ROMX

InteriorTileset::
	db $0A
	
	; $80
	dw $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
	
	; $81-85 : Floor tiles
	dw $0033, $0033, $00CC, $00CC, $0033, $0033, $00CC, $00CC
	dw $000F, $000F, $000F, $000F, $00F0, $00F0, $00F0, $00F0
	dw $0A0A, $0505, $0A0A, $0505, $0A0A, $0505, $0A0A, $0505
	dw $007F, $007F, $0000, $FF00, $01FE, $01FE, $0100, $FF00 ; Wooden floor
	dw $01FE, $01FE, $0100, $FF00, $007F, $007F, $0000, $FF00
	
	; $86-89 : Rug tiles
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00
	dw $FFFF, $A480, $FF80, $B080, $AE80, $ED80, $A980, $A780
	dw $A780, $A780, $EF80, $A780, $A780, $EF80, $A780, $A780
	dw $FFFF, $2400, $FF00, $0000, $2400, $FF00, $FF00, $FF00
	
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $84, 0, 2, 0, 0, 0, 0
	tile_attr $84, 0, 2, 0, 0, 0, 0
	tile_attr $85, 0, 2, 0, 0, 0, 0
	tile_attr $85, 0, 2, 0, 0, 0, 0
	
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $87, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 2, 0, 0, 0, 0
	
	tile_attr $89, 0, 2, 0, 0, 0, 0
	tile_attr $86, 0, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 0, 0
	tile_attr $86, 0, 2, 0, 0, 0, 0
	
	tile_attr $87, 0, 2, 0, 1, 0, 0
	tile_attr $88, 0, 2, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 2, 0, 0, 0, 0
	tile_attr $87, 0, 2, 0, 0, 1, 0
	
	tile_attr $86, 0, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 1, 0
	tile_attr $86, 0, 2, 0, 0, 1, 0
	tile_attr $89, 0, 2, 0, 0, 1, 0
	
	tile_attr $88, 0, 2, 0, 1, 0, 0
	tile_attr $87, 0, 2, 0, 1, 1, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
REPT $37
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
	tile_attr $80, 0, 0, 0, 0, 0, 0
ENDR
	
	
	; Blackness
	db 0
	
	; Floor tiles
REPT 5
	db TILE_CANWALK
ENDR
	
	; Rug tiles
REPT 4
	db TILE_CANWALK
ENDR
	
REPT $100 - 10
	db 0
ENDR
	
	
	db 0 ; No tile animations
	
	
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
