
SECTION "Interior tileset", ROMX

InteriorTileset::
	db $3E
	
	; $80
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00
	
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
	
	; $8A-8E : Wall tiles
	dw $FFFF, $00FF, $5AA5, $A55A, $A55A, $5AA5, $5AA5, $A55A
	dw $00FF, $00FF, $00FF, $FFFF, $00FF, $FF00, $FF00, $FF00
	dw $A55A, $A55A, $5AA5, $A55A, $A55A, $5AA5, $5AA5, $A55A
	dw $FFFF, $80FF, $DAA5, $A5DA, $A5DA, $DAA5, $DAA5, $A5DA
	dw $80FF, $80FF, $80FF, $FFFF, $80FF, $FF80, $FF80, $FF80
	
	; $8F-92 : Shelf tiles
	dw $FFFF, $80FF, $BFFF, $BAF4, $BAEC, $B5F8, $BFFF, $80FF
	dw $80FF, $BFFF, $BEF4, $BCE9, $B8F3, $B1E6, $B2ED, $FFFF
	dw $01FF, $FDFF, $25DF, $4DB7, $9D6F, $3DD7, $7DAF, $FFFF
	dw $FFFF, $01FF, $FDFF, $5DAF, $5DB7, $2DDF, $FDFF, $01FF
	
	; $93-94 : Shelf top tiles
	dw $BF00, $BF00, $803F, $803F, $8000, $FF00, $807F, $807F
	dw $FF00, $FF00, $00FF, $00FF, $0000, $FF00, $00FF, $00FF
	
	; $95-96 : Computer tiles
	dw $FF7F, $80FF, $FFBF, $E0BF, $E0BF, $E0BF, $E0BF, $E0BF
	dw $E0BF, $E0BF, $FFBF, $FF80, $FFFF, $FF07, $FF07, $FF3F
	
	; $97-9E : Potted plant
	dw $0000, $0101, $0607, $090E, $3B34, $6C73, $2738, $2C33
	dw $0000, $8080, $E060, $F030, $78A8, $FC14, $FC2C, $FE16
	dw $5768, $4D72, $A7D8, $BBC4, $C8B7, $DBE7, $7A77, $0E0F
	dw $FE1E, $FE16, $FF2B, $FF17, $FF29, $FFD7, $FCDC, $E060
	dw $2334, $2038, $101D, $1718, $101D, $080D, $0707, $0000
	dw $C43C, $041C, $08F8, $E818, $08F8, $10F0, $E0E0, $0000
	dw $0202, $0202, $0203, $0E0F, $141E, $0C2D, $2C2E, $2637
	dw $40C0, $40C0, $4040, $70F0, $28F8, $30BC, $34FC, $64FC
	
	; $9F-A0 : Wall picture
	dw $00FF, $7FFF, $40C0, $48D7, $4CD3, $5EC1, $5FC0, $5FC0
	dw $5FC0, $5FC0, $5FC0, $5FC0, $40C0, $7FFF, $00FF, $00FF
	
	; $A1-A4 : Chair
	dw $202F, $505F, $505F, $505F, $50D0, $50D0, $5FDF, $5FD0
	dw $5F50, $5F50, $5F50, $5F50, $5FDF, $50D0, $50D0, $20F0
	dw $F01F, $F01F, $F01F, $F01F, $F0F0, $50D0, $50D0, $20F0
	dw $000F, $000F, $000F, $000F, $00F0, $00F0, $E0F0, $F010
	
	; $A5-AA : Table
	dw $3F3F, $4040, $9881, $B083, $A087, $808F, $809F, $80BF
	dw $FFFF, $0000, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF
	dw $80BF, $80BF, $809F, $808F, $A087, $B083, $9881, $FFFF
	dw $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $FFFF
	dw $BFC0, $BFC0, $BFC0, $BFCF, $B0D5, $A0EA, $A0F5, $C0EA
	dw $FF00, $FF00, $FF00, $FFFF, $0055, $00AA, $0055, $00AA
	
	; $AB
	dw $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF
	
	; $AC-B3 : Large shelf
	dw $7F7F, $8080, $80BF, $80BF, $80BF, $80BF, $80BF, $80BF
	dw $FEFE, $0101, $03FD, $03FD, $03FD, $03FD, $03FD, $03FD
	dw $FF80, $FFBF, $FFAA, $FFAA, $EBBE, $EBAA, $FFBF, $FF80
	dw $FF01, $FFBD, $E7BD, $FFA5, $F7A5, $EFA5, $FFBD, $FF01
	dw $FF80, $FFBE, $FFA2, $FFA2, $F7AA, $FFAA, $FFBE, $FF80
	dw $FF80, $FF80, $FF80, $FF80, $FFBF, $E0AA, $E0B5, $C0EA
	dw $FFBF, $E0BF, $FFBF, $FF80, $FFBF, $E0AA, $E0B5, $C0EA
	dw $7F7F, $8080, $80BF, $80AF, $80AF, $80B7, $80B7, $80BF
	
	; $B4 : Table part (oops xP  -Kai)
	dw $80BF, $80BF, $80BF, $80BF, $80BF, $80BF, $80BF, $80BF
	
	; $B5-B6 : "Vertical" walls
	dw $BFC0, $BFC0, $BFC0, $BFC0, $BFC0, $BFC0, $BFC0, $BFC0
	dw $BFC0, $BFC0, $BFC0, $BFC0, $BFC0, $BFC0, $BFC0, $80FF
	
	; $B7 : Small wood shelf - top-right tile
	dw $FEFE, $0101, $03FD, $0BF5, $03F5, $03F5, $03F5, $03FD
	
	; $B8-B9 : Green rugs
	dw $22DD, $54AB, $8A75, $54AB, $2AD5, $50AF, $AA55, $44BB
	dw $007F, $00AE, $00D5, $00BB, $00DD, $00AB, $0075, $00FE
	
	; $BA-BD : Bed
	dw $80C0, $FF80, $FF80, $FF80, $FF80, $FF80, $FF80, $FFFF
	dw $81FE, $83FC, $86F9, $8CF3, $98E7, $B0CF, $E09F, $FFFF
	dw $F0F0, $90F8, $BFDF, $FFB0, $E0DF, $9FEF, $F0BF, $C0FF
	dw $FFFF, $80C0, $FF80, $FF80, $FF80, $FF80, $FF8F, $F090
	
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
	
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	
	tile_attr $93, 0, 2, 0, 0, 0, 0
	tile_attr $8F, 0, 3, 0, 0, 0, 0
	tile_attr $94, 0, 2, 0, 0, 0, 0
	tile_attr $92, 0, 3, 0, 0, 0, 0
	
	tile_attr $93, 0, 2, 0, 1, 0, 0
	tile_attr $8D, 0, 3, 0, 1, 0, 0
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	
	tile_attr $90, 0, 3, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $91, 0, 3, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $8E, 0, 3, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $B5, 0, 3, 0, 0, 0, 0
	tile_attr $B5, 0, 3, 0, 0, 0, 0
	
	tile_attr $B5, 0, 3, 0, 1, 0, 0
	tile_attr $B5, 0, 3, 0, 1, 0, 0
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $B5, 0, 3, 0, 0, 0, 0
	tile_attr $B6, 0, 3, 0, 0, 0, 0
	
	tile_attr $B5, 0, 3, 0, 1, 0, 0
	tile_attr $B6, 0, 3, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $8D, 0, 3, 0, 0, 0, 0
	tile_attr $8E, 0, 3, 0, 0, 0, 0
	
	tile_attr $8D, 0, 3, 0, 1, 0, 0
	tile_attr $8E, 0, 3, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 1, 0, 0
	
	tile_attr $96, 0, 3, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $96, 0, 3, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $97, 0, 4, 0, 0, 0, 1
	tile_attr $99, 0, 4, 0, 0, 0, 1
	tile_attr $98, 0, 4, 0, 0, 0, 1
	tile_attr $9A, 0, 4, 0, 0, 0, 1
	
	tile_attr $9D, 0, 2, 0, 0, 0, 0
	tile_attr $9B, 0, 2, 0, 0, 0, 0
	tile_attr $9E, 0, 2, 0, 0, 0, 0
	tile_attr $9C, 0, 2, 0, 0, 0, 0
	
	tile_attr $9F, 0, 3, 0, 0, 0, 0
	tile_attr $A0, 0, 3, 0, 0, 0, 0
	tile_attr $9F, 0, 3, 0, 1, 0, 0
	tile_attr $A0, 0, 3, 0, 1, 0, 0
	
	tile_attr $A1, 0, 1, 0, 0, 0, 0
	tile_attr $A2, 0, 1, 0, 0, 0, 0
	tile_attr $A4, 0, 1, 0, 0, 0, 0
	tile_attr $A3, 0, 1, 0, 0, 0, 0
	
	tile_attr $8D, 0, 3, 0, 0, 0, 0
	tile_attr $8E, 0, 3, 0, 0, 0, 0
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $8D, 0, 3, 0, 1, 0, 0
	tile_attr $8E, 0, 3, 0, 1, 0, 0
	
	tile_attr $A5, 0, 2, 0, 0, 0, 0
	tile_attr $B4, 0, 2, 0, 0, 0, 0
	tile_attr $A6, 0, 2, 0, 0, 0, 0
	tile_attr $AB, 0, 2, 0, 0, 0, 0
	
	tile_attr $A7, 0, 2, 0, 0, 0, 0
	tile_attr $A9, 0, 2, 0, 0, 0, 0
	tile_attr $A8, 0, 2, 0, 0, 0, 0
	tile_attr $AA, 0, 2, 0, 0, 0, 0
	
	tile_attr $A6, 0, 2, 0, 0, 0, 0
	tile_attr $AB, 0, 2, 0, 0, 0, 0
	tile_attr $A5, 0, 2, 0, 1, 0, 0
	tile_attr $B4, 0, 2, 0, 1, 0, 0
	
	tile_attr $A8, 0, 2, 0, 1, 0, 0
	tile_attr $AA, 0, 2, 0, 1, 0, 0
	tile_attr $A7, 0, 2, 0, 1, 0, 0
	tile_attr $A9, 0, 2, 0, 1, 0, 0
	
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $AC, 0, 2, 0, 0, 0, 0
	tile_attr $AE, 0, 2, 0, 0, 0, 0
	
	tile_attr $AD, 0, 2, 0, 0, 0, 0
	tile_attr $AF, 0, 2, 0, 0, 0, 0
	tile_attr $AC, 0, 2, 0, 0, 0, 0
	tile_attr $AE, 0, 2, 0, 0, 0, 0
	
	tile_attr $AD, 0, 2, 0, 0, 0, 0
	tile_attr $AF, 0, 2, 0, 0, 0, 0
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $B0, 0, 2, 0, 0, 0, 0
	tile_attr $B2, 0, 2, 0, 0, 0, 0
	
	tile_attr $B0, 0, 2, 0, 1, 0, 0
	tile_attr $B2, 0, 2, 0, 1, 0, 0
	tile_attr $B0, 0, 2, 0, 0, 0, 0
	tile_attr $B2, 0, 2, 0, 0, 0, 0
	
	tile_attr $B0, 0, 2, 0, 1, 0, 0
	tile_attr $B2, 0, 2, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $B3, 0, 2, 0, 0, 0, 0
	tile_attr $8A, 0, 3, 0, 0, 0, 0
	tile_attr $B7, 0, 2, 0, 0, 0, 0
	
	tile_attr $B1, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $B1, 0, 2, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	
	tile_attr $B8, 0, 4, 0, 0, 0, 0
	tile_attr $B8, 0, 4, 0, 0, 0, 0
	tile_attr $B8, 0, 4, 0, 0, 0, 0
	tile_attr $B8, 0, 4, 0, 0, 0, 0
	
	tile_attr $B9, 0, 4, 0, 0, 0, 0
	tile_attr $B9, 0, 4, 0, 0, 0, 0
	tile_attr $B9, 0, 4, 0, 0, 0, 0
	tile_attr $B9, 0, 4, 0, 0, 0, 0
	
	tile_attr $BD, 0, 2, 0, 0, 0, 0
	tile_attr $BC, 0, 3, 0, 0, 0, 0
	tile_attr $BD, 0, 2, 0, 1, 0, 0
	tile_attr $BC, 0, 3, 0, 1, 0, 0
	
	tile_attr $BB, 0, 3, 0, 0, 0, 0
	tile_attr $BA, 0, 2, 0, 0, 0, 0
	tile_attr $BB, 0, 3, 0, 1, 0, 0
	tile_attr $BA, 0, 2, 0, 1, 0, 0
	
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 2, 0, 0, 0, 0
    
	tile_attr $88, 0, 2, 0, 1, 0, 0
	tile_attr $88, 0, 2, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
    
	tile_attr $86, 0, 2, 0, 0, 0, 0
	tile_attr $86, 0, 2, 0, 0, 0, 0
	tile_attr $86, 0, 2, 0, 0, 0, 0
	tile_attr $86, 0, 2, 0, 0, 0, 0
    
REPT 17
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
	
	; Wall tiles
REPT 5
	db 0
ENDR
	
	; Shelf tiles
REPT 4
	db 0
ENDR
	
	; Shelf top tiles
	db 0
	db 0
	
	; Computer tiles
	db 0
	db 0
	
	; Potted plant tiles
REPT 4
	db TILE_CANWALK
ENDR
REPT 4
	db 0
ENDR
	
	; Wall picture
	db 0
	db 0
	
	; Chair tiles
REPT 4
	db 0
ENDR
	
	; Table tiles
REPT 6
	db 0
ENDR
	
	; Light greyness
	db 0
	
	; Large shelf
REPT 8
	db 0
ENDR
	
	; Table edge
	db 0
	
	; Vertical walls
	db 0
	db 0
	
	; Small shelf top-right
	db 0
	
	; Green rugs
	db TILE_CANWALK
	db TILE_CANWALK
	
	; Bed
REPT 4
	db 0
ENDR
	
REPT $100 - $3E
	db 0
ENDR
	
	
	db 0 ; No tile animations
	
	
	dw InteriorChairPalette
	dw InteriorMainPalette
	dw InteriorWallPalette
	dw InteriorGreenPalette
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
