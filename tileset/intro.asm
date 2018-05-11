
SECTION "Intro tileset", ROMX
	
IntroTileset::
	db $80
	full_ptr IntroTilesetTiles0
	db 0
	
	db $0C
	full_ptr IntroTilesetTiles1
	db 0
	
	; $00 : Black void
	tile_attr $20, 0, 2, 0, 0, 0, 0
	tile_attr $20, 0, 2, 0, 0, 0, 0
	tile_attr $20, 0, 2, 0, 0, 0, 0
	tile_attr $20, 0, 2, 0, 0, 0, 0
	
	; $01 : Grey void (walkable)
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Character select blocks
	; First row
	tile_attr $81, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $82, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0

	tile_attr $83, 0, 3, 0, 0, 0, 0
	tile_attr $92, 0, 3, 0, 0, 0, 0
	tile_attr $84, 0, 3, 0, 0, 0, 0
	tile_attr $94, 0, 3, 0, 0, 0, 0
	
	tile_attr $85, 0, 3, 0, 0, 0, 0
	tile_attr $96, 0, 3, 0, 0, 0, 0
	tile_attr $86, 0, 3, 0, 0, 0, 0
	tile_attr $97, 0, 3, 0, 0, 0, 0
	
	tile_attr $87, 0, 3, 0, 0, 0, 0
	tile_attr $98, 0, 3, 0, 0, 0, 0
	tile_attr $88, 0, 3, 0, 0, 0, 0
	tile_attr $99, 0, 3, 0, 0, 0, 0
	
	tile_attr $89, 0, 3, 0, 0, 0, 0
	tile_attr $9A, 0, 3, 0, 0, 0, 0
	tile_attr $86, 0, 3, 0, 0, 0, 0
	tile_attr $9B, 0, 3, 0, 0, 0, 0
	
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $9C, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $9D, 0, 3, 0, 0, 0, 0
	
	tile_attr $8C, 0, 3, 0, 0, 0, 0
	tile_attr $9E, 0, 3, 0, 0, 0, 0
	tile_attr $8D, 0, 3, 0, 0, 0, 0
	tile_attr $9F, 0, 3, 0, 0, 0, 0
	
	tile_attr $8E, 0, 3, 0, 0, 0, 0
	tile_attr $A0, 0, 3, 0, 0, 0, 0
	tile_attr $8F, 0, 3, 0, 0, 0, 0
	tile_attr $A1, 0, 3, 0, 0, 0, 0
	
	tile_attr $90, 0, 3, 0, 0, 0, 0
	tile_attr $A2, 0, 3, 0, 0, 0, 0
	tile_attr $91, 0, 3, 0, 0, 0, 0
	tile_attr $92, 0, 3, 0, 1, 0, 0
	
	tile_attr $82, 0, 3, 0, 1, 0, 0
	tile_attr $00, 0, 3, 0, 0, 0, 0
	tile_attr $81, 0, 3, 0, 1, 0, 0
	tile_attr $00, 0, 3, 0, 0, 0, 0
	
	; Second row, $0C onwards
	tile_attr $93, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A3, 0, 4, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A4, 0, 4, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A5, 0, 4, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A6, 0, 4, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A6, 0, 6, 0, 1, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A5, 0, 6, 0, 1, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A4, 0, 6, 0, 1, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A3, 0, 6, 0, 1, 0, 0
	tile_attr $93, 0, 3, 0, 1, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	; Third row
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $B4, 0, 4, 0, 0, 0, 0
	
	tile_attr $AB, 0, 4, 0, 0, 0, 0
	tile_attr $B5, 0, 4, 0, 0, 0, 0
	tile_attr $AC, 0, 4, 0, 0, 0, 0
	tile_attr $B6, 0, 4, 0, 0, 0, 0
	
	tile_attr $AD, 0, 4, 0, 0, 0, 0
	tile_attr $B7, 0, 4, 0, 0, 0, 0
	tile_attr $AE, 0, 4, 0, 0, 0, 0
	tile_attr $B8, 0, 4, 0, 0, 0, 0
	
	tile_attr $AF, 0, 4, 0, 0, 0, 0
	tile_attr $B9, 0, 4, 0, 0, 0, 0
	tile_attr $B0, 0, 4, 0, 0, 0, 0
	tile_attr $BA, 0, 4, 0, 0, 0, 0
	
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $BB, 0, 4, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $BB, 0, 6, 0, 1, 0, 0
	
	tile_attr $B1, 0, 6, 0, 0, 0, 0
	tile_attr $BC, 0, 6, 0, 0, 0, 0
	tile_attr $B2, 0, 6, 0, 0, 0, 0
	tile_attr $BD, 0, 6, 0, 0, 0, 0
	
	tile_attr $80, 0, 6, 0, 1, 0, 0
	tile_attr $BE, 0, 6, 0, 0, 0, 0
	tile_attr $80, 0, 6, 0, 0, 0, 0
	tile_attr $BF, 0, 6, 0, 0, 0, 0
	
	tile_attr $80, 0, 6, 0, 0, 0, 0
	tile_attr $C0, 0, 6, 0, 0, 0, 0
	tile_attr $B3, 0, 6, 0, 0, 0, 0
	tile_attr $C1, 0, 6, 0, 0, 0, 0
	
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $C2, 0, 6, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	; Fourth row
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $C3, 0, 4, 0, 0, 0, 0
	tile_attr $D3, 0, 4, 0, 0, 0, 0
	
	tile_attr $C4, 0, 4, 0, 0, 0, 0
	tile_attr $D4, 0, 4, 0, 0, 0, 0
	tile_attr $C5, 0, 4, 0, 0, 0, 0
	tile_attr $D5, 0, 5, 0, 0, 0, 0
	
	tile_attr $C6, 0, 4, 0, 0, 0, 0
	tile_attr $D6, 0, 4, 0, 0, 0, 0
	tile_attr $C7, 0, 4, 0, 0, 0, 0
	tile_attr $D7, 0, 5, 0, 0, 0, 0
	
	tile_attr $C8, 0, 4, 0, 0, 0, 0
	tile_attr $D8, 0, 4, 0, 0, 0, 0
	tile_attr $C9, 0, 4, 0, 0, 0, 0
	tile_attr $D9, 0, 4, 0, 0, 0, 0
	
	tile_attr $CA, 0, 4, 0, 0, 0, 0
	tile_attr $DA, 0, 4, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $CB, 0, 6, 0, 0, 0, 0
	tile_attr $DB, 0, 6, 0, 0, 0, 0
	
	tile_attr $CC, 0, 6, 0, 0, 0, 0
	tile_attr $DC, 0, 6, 0, 0, 0, 0
	tile_attr $CD, 0, 6, 0, 0, 0, 0
	tile_attr $DD, 0, 6, 0, 0, 0, 0
	
	tile_attr $CE, 0, 6, 0, 0, 0, 0
	tile_attr $D7, 0, 7, 0, 1, 0, 0
	tile_attr $CF, 0, 6, 0, 0, 0, 0
	tile_attr $D6, 0, 6, 0, 1, 0, 0
	
	tile_attr $D0, 0, 6, 0, 0, 0, 0
	tile_attr $D5, 0, 7, 0, 1, 0, 0
	tile_attr $D1, 0, 6, 0, 0, 0, 0
	tile_attr $DE, 0, 6, 0, 0, 0, 0
	
	tile_attr $D2, 0, 6, 0, 0, 0, 0
	tile_attr $DF, 0, 6, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	; Fifth row
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $E0, 0, 4, 0, 0, 0, 0
	tile_attr $EC, 0, 4, 0, 0, 0, 0
	
	tile_attr $E1, 0, 4, 0, 0, 0, 0
	tile_attr $ED, 0, 4, 0, 0, 0, 0
	tile_attr $E2, 0, 5, 0, 0, 0, 0
	tile_attr $EE, 0, 4, 0, 0, 0, 0
	
	tile_attr $E3, 0, 5, 0, 0, 0, 0
	tile_attr $EF, 0, 4, 0, 0, 0, 0
	tile_attr $E4, 0, 5, 0, 0, 0, 0
	tile_attr $00, 0, 5, 0, 0, 0, 0
	
	tile_attr $E5, 0, 4, 0, 0, 0, 0
	tile_attr $F0, 0, 4, 0, 0, 0, 0
	tile_attr $E6, 0, 4, 0, 0, 0, 0
	tile_attr $F1, 0, 4, 0, 0, 0, 0
	
	tile_attr $E7, 0, 4, 0, 0, 0, 0
	tile_attr $F2, 0, 4, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $E8, 0, 6, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $E9, 0, 6, 0, 0, 0, 0
	tile_attr $F3, 0, 6, 0, 0, 0, 0
	tile_attr $EA, 0, 6, 0, 0, 0, 0
	tile_attr $F4, 0, 6, 0, 0, 0, 0
	
	tile_attr $E4, 0, 7, 0, 1, 0, 0
	tile_attr $00, 0, 7, 0, 0, 0, 0
	tile_attr $E3, 0, 7, 0, 1, 0, 0
	tile_attr $F5, 0, 6, 0, 0, 0, 0
	
	tile_attr $E2, 0, 7, 0, 1, 0, 0
	tile_attr $F6, 0, 6, 0, 0, 0, 0
	tile_attr $EB, 0, 6, 0, 0, 0, 0
	tile_attr $F7, 0, 6, 0, 0, 0, 0
	
	; Sixth row
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $F8, 0, 4, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	tile_attr $F9, 0, 4, 0, 0, 0, 0
	tile_attr $82, 0, 4, 1, 0, 0, 0
	tile_attr $FA, 0, 4, 0, 0, 0, 0
	tile_attr $83, 0, 4, 1, 0, 0, 0
	
	tile_attr $FB, 0, 4, 0, 0, 0, 0
	tile_attr $84, 0, 4, 1, 0, 0, 0
	tile_attr $FC, 0, 4, 0, 0, 0, 0
	tile_attr $85, 0, 4, 1, 0, 0, 0
	
	tile_attr $FD, 0, 4, 0, 0, 0, 0
	tile_attr $86, 0, 4, 1, 0, 0, 0
	tile_attr $FE, 0, 4, 0, 0, 0, 0
	tile_attr $87, 0, 4, 1, 0, 0, 0
	
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $88, 0, 6, 1, 0, 0, 0
	tile_attr $FF, 0, 6, 0, 0, 0, 0
	tile_attr $89, 0, 6, 1, 0, 0, 0
	
	tile_attr $FC, 0, 6, 0, 1, 0, 0
	tile_attr $85, 0, 6, 1, 1, 0, 0
	tile_attr $00, 0, 7, 0, 0, 0, 0
	tile_attr $8A, 0, 6, 1, 0, 0, 0
	
	tile_attr $80, 0, 6, 1, 0, 0, 0
	tile_attr $8B, 0, 6, 1, 0, 0, 0
	tile_attr $81, 0, 6, 1, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	; Filling block
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	; Unused blocks
REPT 7
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
ENDR
	
	
	; Path tile
	db TILE_CANWALK
	
REPT $100 - 1
	db 0
ENDR
	
	
	db 0 ; Number of tile animations
	
	
	dw DefaultPalette
	dw InvertedPalette
	dw CharSelectTextPalette
	dw CharSelectEviePalette0
	dw CharSelectEviePalette1
	dw CharSelectTomPalette0
	dw CharSelectTomPalette1
	
