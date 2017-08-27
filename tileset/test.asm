
SECTION "Test tileset", ROMX

TestTileset::
	db 42 ; Number of tiles
	
	; Grass tiles (80-82)
	dw $0062, $02B5, $004A, $40B5, $004A, $08B4, $004B, $0094
	dw $00AA, $0855, $002B, $00AA, $2054, $00AA, $0255, $004A
	dw $0029, $00D2, $102D, $0052, $02AD, $0052, $40AD, $0046
	
	; House (83-91)
	dw $203F, $2F30, $203F, $3C23, $3C23, $203F, $2F30, $2F30 ; Left
	dw $00FF, $3FC0, $00FF, $FC03, $FC03, $00FF, $FFFF, $0000 ; Bottom
	dw $203F, $2F30, $203F, $3C23, $3F20, $1F10, $0F0F, $0000 ; Corner
	dw $00FF, $00FF, $3FFF, $3FE0, $3FE7, $38E8, $38E8, $3FEF ; Door top-left
	dw $3FE0, $3FEF, $37E1, $37E1, $31E1, $3FE0, $BFFF, $6060 ; Door bottom-left
	dw $FC07, $FCF7, $7C17, $7C17, $1C17, $FC07, $FDFF, $0606 ; Door bottom-right
	dw $00FF, $7FFF, $7FC0, $64C0, $64C0, $64C0, $64C0, $7FFF ; Window top
	dw $64C0, $64C0, $64C0, $64C0, $64C0, $7FFF, $00FF, $00FF ; Window bottom
	dw $00FF, $3FC0, $00FF, $FC03, $FC03, $00FF, $3FC0, $3FC0 ; Filler
	dw $FFFF, $00FF, $54AB, $22DD, $00FF, $08F7, $44BB, $22DD ; Roof top
	dw $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF ; Roof left
	dw $80FF, $9FFF, $A0FF, $C0FF, $FFFF, $FF80, $FF80, $FFFF ; Roof bottom-left
	dw $0707, $181F, $203F, $407F, $407F, $80FF, $80FF, $80FF ; Roof top-left
	dw $00FF, $FFFF, $00FF, $00FF, $FFFF, $FF00, $FF00, $FFFF ; Roof bottom
	dw $00FF, $54AB, $22DD, $00FF, $08F7, $44BB, $22DD, $00FF ; Roof filler
	
	; Rock (92-97)
	dw $FF56, $BBEF, $D77E, $EBBE, $DD77, $FF6A, $D5FF, $FF6A ; Left
	dw $D50F, $C4F7, $82E3, $01F3, $03FD, $9FE9, $7F47, $BEBE ; Horizontal
	dw $0F0C, $3732, $6F45, $4F4B, $CFC5, $FFAB, $FF55, $FF3E ; Top-left
	dw $A7B6, $4362, $80E2, $81E2, $84F3, $83FF, $F7CC, $FFF9 ; Right
	dw $F030, $EC4C, $D6A2, $82F2, $83F3, $83FD, $C37E, $FF3C ; Top-right
	dw $FF00, $AF10, $FE00, $FF00, $AD42, $FF00, $EF10, $FB00 ; Filler
	
	; 98
	dw $FF00, $EF10, $FF00, $FF00, $BD42, $FF00, $EF10, $FF00 ; Water
;	dw $FF00, $F700, $FF00, $FF00, $DE00, $FF00, $F700, $FF00 ; Water frame 2
;	dw $FF00, $DF20, $FF00, $FF00, $7B84, $FF00, $DF20, $FF00 ; Water frame 3
	
	; Bridge (99-9A)
	dw $FF00, $8877, $8877, $FF00, $22DD, $FF00, $FFFF, $1010 ; Horizontal
	dw $FF00, $8877, $8877, $FF00, $22DD, $FF00, $8877, $8877 ; Vertical
	
	; Sign (9B-9C)
	dw $0000, $0000, $0000, $7F7F, $407F, $5F7F, $507F, $577F ; Top-left
	dw $5070, $5777, $5070, $5777, $5878, $5070, $507F, $207F ; Bottom-left
	
	; 9D
	dw $0000, $0012, $0044, $0000, $0020, $0002, $0040, $0008 ; Path tile (merge with rock filler ?)
	
	; 9E
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Flower
;	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Flower frame 2
	
	; Tree (9F-A6)
	dw $01A9, $0243, $0D2E, $1798, $243B, $D3EC, $5C63, $E19E ; Top-left (walkable)
	dw $8092, $C048, $F033, $78AC, $FE16, $FF2B, $FE16, $FF69 ; Top-right (walkable)
	dw $01A9, $0243, $0D2E, $1798, $243B, $D3EC, $5C63, $E19E ; Top-left
	dw $8092, $C048, $F033, $78AC, $FE16, $FF2B, $FE16, $FF69 ; Top-right
	dw $243B, $D3EC, $5C63, $E19E, $243B, $D3EC, $5CE3, $E19E ; Middle-left
	dw $FE17, $FF2B, $FE17, $FF69, $FE17, $FF2B, $FE17, $FF69 ; Middle-right
	dw $24FB, $D3EC, $5CE3, $E19E, $7FFF, $057E, $0B7C, $0F3F ; Bottom-left
	dw $FE17, $FF2B, $FE17, $FF69, $FF7F, $E0BC, $F018, $E0F0 ; Bottom-right
	
	; A7
	dw $4200, $A542, $AB44, $D628, $4438, $2856, $38C7, $106E ; Tall grass
	
	; A8
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Door mat
	
	; A9
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00 ; Accesses the third color of a palette
	
	
	; Grey border
	tile_attr $A7, 0, 0, 0, 0, 0, 0
	tile_attr $A7, 0, 0, 0, 0, 0, 0
	tile_attr $A7, 0, 0, 0, 0, 0, 0
	tile_attr $A7, 0, 0, 0, 0, 0, 0
	
	; Grass
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; House top-left
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $8F, 0, 5, 0, 0, 0, 1
	tile_attr $8D, 0, 5, 0, 0, 0, 1
	
	; House top
	tile_attr $8C, 1, 5, 0, 0, 0, 1
	tile_attr $91, 0, 5, 0, 0, 0, 1
	tile_attr $8C, 0, 5, 0, 0, 0, 1
	tile_attr $91, 0, 5, 0, 0, 0, 1
	
	; House top-right
	tile_attr $8F, 1, 5, 0, 1, 0, 1
	tile_attr $8D, 0, 5, 0, 1, 0, 1
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Roof bottom-left
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $8E, 0, 5, 0, 0, 0, 1
	tile_attr $83, 0, 3, 0, 0, 0, 0
	
	; Roof bottom
	tile_attr $90, 0, 5, 0, 0, 0, 1
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $90, 0, 5, 0, 0, 0, 1
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	
	; Roof bottom-right
	tile_attr $8E, 0, 5, 0, 1, 0, 1
	tile_attr $83, 0, 3, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; House left
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $83, 0, 3, 0, 0, 0, 0
	tile_attr $83, 0, 3, 0, 0, 0, 0
	
	; House middle
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	
	; House right
	tile_attr $83, 0, 3, 0, 1, 0, 0
	tile_attr $83, 0, 3, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; House bottom-left
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $83, 0, 3, 0, 0, 0, 0
	tile_attr $85, 0, 3, 0, 0, 0, 0
	
	; Door
	tile_attr $86, 0, 4, 0, 0, 0, 0
	tile_attr $87, 0, 4, 0, 0, 0, 0
	tile_attr $86, 0, 4, 0, 1, 0, 0
	tile_attr $88, 0, 4, 0, 0, 0, 0
	
	; House bottom
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $84, 0, 3, 0, 0, 0, 0
	tile_attr $8B, 0, 3, 0, 0, 0, 0
	tile_attr $84, 0, 3, 0, 0, 0, 0
	
	; Roof bottom with window top
	tile_attr $90, 0, 5, 0, 0, 0, 1
	tile_attr $89, 0, 4, 0, 0, 0, 0
	tile_attr $90, 0, 5, 0, 0, 0, 1
	tile_attr $89, 0, 4, 0, 1, 0, 0
	
	; House bottom with window bottom
	tile_attr $8A, 0, 4, 0, 0, 0, 0
	tile_attr $84, 0, 3, 0, 0, 0, 0
	tile_attr $8A, 0, 4, 0, 1, 0, 0
	tile_attr $84, 0, 3, 0, 0, 0, 0
	
	; House bottom-right
	tile_attr $83, 0, 3, 0, 1, 0, 0
	tile_attr $85, 0, 3, 0, 1, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Path
	tile_attr $9D, 1, 0, 0, 0, 0, 0
	tile_attr $9D, 0, 0, 0, 0, 0, 0
	tile_attr $9D, 0, 0, 0, 0, 0, 0
	tile_attr $9D, 0, 0, 0, 0, 0, 0
	
	; Sign
	tile_attr $9B, 0, 0, 0, 0, 0, 1
	tile_attr $9C, 0, 0, 0, 0, 0, 0
	tile_attr $9B, 0, 0, 0, 1, 0, 1
	tile_attr $9C, 0, 0, 0, 1, 0, 0
	
	; Water top-left
	tile_attr $94, 0, 7, 0, 0, 0, 0
	tile_attr $92, 1, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water top
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water top-right
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Water left
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $92, 1, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Horizontal bridge
	tile_attr $9A, 1, 3, 0, 0, 0, 0
	tile_attr $99, 0, 3, 0, 0, 0, 0
	tile_attr $9A, 0, 3, 0, 0, 0, 0
	tile_attr $99, 0, 3, 0, 0, 0, 0
	
	; Vertical bridge
	tile_attr $9A, 1, 3, 0, 0, 0, 0
	tile_attr $9A, 0, 3, 0, 0, 0, 0
	tile_attr $9A, 0, 3, 0, 0, 0, 0
	tile_attr $9A, 0, 3, 0, 0, 0, 0
	
	; Water right
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Water bottom-left
	tile_attr $92, 0, 7, 0, 0, 1, 0
	tile_attr $94, 1, 7, 0, 0, 1, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	
	; Water bottom
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $93, 1, 7, 0, 0, 1, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	
	; Water bottom-right
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $93, 1, 7, 0, 0, 1, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 0, 1, 0
	
	; Tree
	tile_attr $A1, 0, 2, 0, 0, 0, 0
	tile_attr $A5, 0, 2, 0, 0, 0, 0
	tile_attr $A2, 0, 2, 0, 0, 0, 0
	tile_attr $A6, 0, 2, 0, 0, 0, 0
	
	; Tree base
	tile_attr $A3, 0, 2, 0, 0, 0, 0
	tile_attr $A5, 0, 2, 0, 0, 0, 0
	tile_attr $A4, 0, 2, 0, 0, 0, 0
	tile_attr $A6, 0, 2, 0, 0, 0, 0
	
	; Tree middle
	tile_attr $A3, 0, 2, 0, 0, 0, 0
	tile_attr $A3, 0, 2, 0, 0, 0, 0
	tile_attr $A4, 0, 2, 0, 0, 0, 0
	tile_attr $A4, 0, 2, 0, 0, 0, 0
	
	; Tree top
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $9F, 0, 2, 0, 0, 0, 1
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $A0, 0, 2, 0, 0, 0, 1
	
	; Tall grass
	tile_attr $A7, 1, 2, 0, 0, 0, 0
	tile_attr $A7, 0, 2, 0, 0, 0, 0
	tile_attr $A7, 0, 2, 0, 0, 0, 0
	tile_attr $A7, 0, 2, 0, 0, 0, 0
	
	; Rock top-left
	tile_attr $96, 0, 7, 0, 1, 0, 0
	tile_attr $95, 0, 7, 0, 1, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	
	; Rock top
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	
	; Rock top-right
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $94, 0, 7, 0, 1, 0, 0
	tile_attr $92, 0, 7, 0, 1, 0, 0
	
	; Rock left
	tile_attr $95, 0, 7, 0, 1, 0, 0
	tile_attr $95, 0, 7, 0, 1, 0, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	
	; Rock
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	
	; Rock right
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 1, 0, 0
	tile_attr $92, 0, 7, 0, 1, 0, 0
	
	; Rock bottom-left
	tile_attr $95, 0, 7, 0, 1, 0, 0
	tile_attr $96, 0, 7, 0, 1, 1, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	
	; Rock bottom (lol)
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	
	; Rock bottom-right
	tile_attr $97, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 1, 0, 0
	tile_attr $94, 0, 7, 0, 1, 1, 0
	
	; Water inwards (top-left)
	tile_attr $94, 0, 7, 0, 1, 1, 0
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water inwards (bottom-left)
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $94, 1, 7, 0, 1, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water inwards (top-right)
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 1, 1, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water inwards (bottom-right)
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 1, 0, 0
	
	; Window
	tile_attr $89, 0, 4, 0, 0, 0, 0
	tile_attr $8A, 0, 4, 0, 0, 0, 0
	tile_attr $89, 0, 4, 0, 1, 0, 0
	tile_attr $8A, 0, 4, 0, 1, 0, 0
	
; These blocks would requires special coding, maybe use them later
IF 0
	; Grass ledge down
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	
	; Grass ledge right
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Grass ledge left
	tile_attr $92, 1, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge up
	tile_attr $93, 1, 7, 0, 0, 1, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge corner upright
	tile_attr $93, 1, 7, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Grass ledge corner upleft
	tile_attr $94, 1, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge corner downright
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $96, 0, 7, 0, 0, 1, 0
	
	; Grass ledge corner downleft
	tile_attr $92, 1, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $94, 0, 7, 0, 0, 1, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	
	; Grass ledge inward upright
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $94, 0, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge inward upleft
	tile_attr $96, 1, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge inward downright
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $94, 0, 7, 0, 0, 0, 0
	
	; Grass ledge inward downleft
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
ENDC
	
	; These blocks aren't used
REPT 64 - 49
	tile_attr $A7, 0, 0, 0, 0, 0, 0
	tile_attr $A7, 0, 0, 0, 0, 0, 0
	tile_attr $A7, 0, 0, 0, 0, 0, 0
	tile_attr $A7, 0, 0, 0, 0, 0, 0
ENDR
	
	
	; Grass tiles
REPT 3
	db TILE_CANWALK
ENDR
	
	; House tiles
REPT 9
	db 0
ENDR
	; Roof tiles
REPT 6
	db TILE_CANWALK
ENDR
	
	; Rock tiles
REPT 6
	db 0
ENDR
	
	; Water tile
	db 1 ; Has an animation
	
	; Bridge
REPT 2
	db TILE_CANWALK
ENDR
	
	; Sign
	db TILE_CANWALK
	db 0
	
	; Path
	db TILE_CANWALK
	
	; Flower
	db TILE_CANWALK | 2
	
	; Tree
	db TILE_CANWALK
	db TILE_CANWALK
REPT 6
	db 0
ENDR
	
	; Tall grass
	db TILE_CANWALK
	
	; Door mat
	db TILE_CANWALK
	
	; "Third color" tile
	db 0
	
	; Unused tiles get nuffin'
REPT $100 - 42
	db 0
ENDR
	
	
	dw GrassPalette
	dw HousePalette
	dw DoorWindowPalette
	dw RoofPalette
	dw WaterPalette
	dw RockPalette
	
	dw TestNPCPalette
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	
	
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
	tile_attr $88, 0, 0, 0, 0, 0, 0
	tile_attr $88, 0, 0, 0, 0, 0, 0
	tile_attr $88, 0, 0, 0, 0, 0, 0
	tile_attr $88, 0, 0, 0, 0, 0, 0
	
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
	tile_attr $89, 1, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 0, 0
	tile_attr $89, 0, 2, 0, 0, 0, 0
	
	; $08 : Door (can be walked "under")
	tile_attr $83, 1, 3, 0, 0, 0, 1
	tile_attr $84, 0, 3, 0, 0, 0, 1
	tile_attr $83, 0, 3, 0, 1, 0, 1
	tile_attr $85, 0, 3, 0, 0, 0, 1
	
	; These blocks are unused
REPT 64 - 9
	tile_attr $88, 0, 0, 0, 0, 0, 0
	tile_attr $88, 0, 0, 0, 0, 0, 0
	tile_attr $88, 0, 0, 0, 0, 0, 0
	tile_attr $88, 0, 0, 0, 0, 0, 0
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
