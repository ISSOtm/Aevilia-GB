
INCLUDE "macros.asm"
INCLUDE "constants.asm"


SECTION "Test tileset", ROMX

TestTileset::
	db 40 ; Number of tiles
	
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
	dw $0000, $0000, $0000, $7F7F, $407F, $5F7F, $507F, $5777 ; Top-left
	dw $5070, $5777, $5070, $5777, $5878, $5070, $507F, $207F ; Bottom-left
	
	; 9D
	dw $0000, $0012, $0044, $0000, $0020, $0002, $0040, $0008 ; Path tile (merge with rock filler ?)
	
	; 9E
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Flower
;	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Flower frame 2
	
	; Tree (9F-A4)
	dw $01A9, $0243, $0D2E, $1798, $243B, $D3EC, $5C63, $E19E ; Top-left
	dw $8092, $C048, $F033, $78AC, $FE16, $FF2B, $FE16, $FF69 ; Top-right
	dw $243B, $D3EC, $5C63, $E19E, $243B, $D3EC, $5CE3, $E19E ; Middle-left
	dw $FE17, $FF2B, $FE17, $FF69, $FE17, $FF2B, $FE17, $FF69 ; Middle-right
	dw $24FB, $D3EC, $5CE3, $E19E, $7FFF, $057E, $0B7C, $0F3F ; Bottom-left
	dw $FE17, $FF2B, $FE17, $FF69, $FF7F, $E0BC, $F018, $E0F0 ; Bottom-right
	
	; A5
	dw $4200, $A542, $AB44, $D628, $4438, $2856, $38C7, $106E ; Tall grass
	
	; A6
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Door mat
	
	; A7
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
	tile_attr $9F, 0, 2, 0, 0, 0, 0
	tile_attr $A3, 0, 2, 0, 0, 0, 0
	tile_attr $A0, 0, 2, 0, 0, 0, 0
	tile_attr $A4, 0, 2, 0, 0, 0, 0
	
	; Tree base
	tile_attr $A1, 0, 2, 0, 0, 0, 0
	tile_attr $A3, 0, 2, 0, 0, 0, 0
	tile_attr $A2, 0, 2, 0, 0, 0, 0
	tile_attr $A4, 0, 2, 0, 0, 0, 0
	
	; Tree middle
	tile_attr $A1, 0, 2, 0, 0, 0, 0
	tile_attr $A1, 0, 2, 0, 0, 0, 0
	tile_attr $A2, 0, 2, 0, 0, 0, 0
	tile_attr $A2, 0, 2, 0, 0, 0, 0
	
	; Tree top
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $9F, 0, 2, 0, 0, 0, 1
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $A0, 0, 2, 0, 0, 0, 1
	
	; Tall grass
	tile_attr $A5, 1, 2, 0, 0, 0, 0
	tile_attr $A5, 0, 2, 0, 0, 0, 0
	tile_attr $A5, 0, 2, 0, 0, 0, 0
	tile_attr $A5, 0, 2, 0, 0, 0, 0
	
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
	db 9
	
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
	tile_attr $88, 1, 2, 0, 0, 0, 0
	tile_attr $88, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 2, 0, 0, 0, 0
	tile_attr $88, 0, 2, 0, 0, 0, 0
	
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
	
	
SECTION "Test map", ROMX
	
TestMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db TILESET_TEST ; Tileset
	dw 0 ; Script (none)
	map_size 29, 17 ; Width, height
	dw 0 ; Loading script (none)
	
TestMapInteractions::
	db 3
	
	db BTN_INTERACT
	interact_box $0090, $0130, 16, 16
	dw TestMapSignText ; Text ptr
	
	db BTN_LOADZONE
	interact_box $009F, $0052, 1, 12
	db 1 ; Dest map
	db 0 ; Dest warp point
	
	db WALK_LOADZONE
	interact_box $0048, $0000, 25, 21
	db 3
	db 0
	
TestMapNPCs::
	db 1 ; Number of NPCs
	
	interact_box $0020, $0020, 16, 16
	db 0 ; Interaction ID
	db $01 << 2 | DIR_DOWN ; Sprite ID & direction
	db 1 << 4 | 1, 1 << 4 | 1 ; Palette IDs
	db $F4 ; Movement permissions
	db $01 ; Movement speed
	
	db $01 ; Number of NPC scripts
	dw TestMapNPCScripts
	
	db $01 ; Number of NPC tile sets
	dw TestNPCTiles
	
TestMapWarpToPoints::
	db 3 ; Number of warp-to points
	
	dw $0098 ; Y pos
	dw $0050 ; X pos
	db DIR_DOWN ; Direction
	db NO_WALKING ; Flags
	db 0 ; Cameraman ID
	dw 0 ; Loading script (none)
	ds 7
	
	dw $FFF8
	dw $0140
	db DIR_DOWN
	db NO_WALKING
	db 0
	dw 0
	ds 7
	
	dw $0055
	dw $001E
	db DIR_RIGHT
	db KEEP_WALKING
	db 0
	dw 0
	ds 7
	
TestMapBlocks::
INCBIN "maps/test.blk"

TestMapNPCScripts::
	dw TestMapNPC0Script
	
TestMapNPC0Script::
	print_name .name
	print_line .line0
	print_line .line1
	wait_user
	print_line .line2
	print_line .line3
	print_line .line4
	wait_user
	clear_box
	print_line .line5
	wait_user
	print_line .line6
	print_line .line7
	print_line .line8
	wait_user
	clear_box
	print_line .line9
	print_line .line10
	print_line .line11
	wait_user
	print_line .line12
	wait_user
	clear_box
	print_line .line13
	wait_user
	done
	
.name
	dstr "TEST #0"
	
.line0
	dstr "Heya! Did you know"
.line1
	dstr "you are a NPC?"
.line2
	db "At least, "
	dstr "what"
.line3
	dstr "that guy there is"
.line4
	dstr "seeing is."
.line5
	dstr "What guy?"
.line6
	dstr "That one watching"
.line7
	dstr "us through that"
.line8
	db "screen, there!",0
.line9
	db "Also, "
	dstr "aside from"
.line10
	db "you, "
	dstr "I am the"
.line11
	dstr "first NPC ever"
.line12
	dstr "created."
.line13
	db "Neat, "
	dstr "huh?"

TestNPCTiles::
	dw $0000, $0000, $0202, $0404, $0000, $0303, $0407, $080F
	dw $101F, $101F, $101F, $101F, $080F, $0407, $0303, $0000
	dw $0000, $0000, $8080, $4040, $0000, $C0C0, $20E0, $10F0
	dw $08F8, $08F8, $08F8, $08F8, $10F0, $20E0, $C0C0, $0000
	
	dw $0000, $0000, $0202, $0404, $0000, $0303, $0407, $0A0F
	dw $121F, $121F, $101F, $101F, $090F, $0407, $0303, $0000
	dw $0000, $0000, $8080, $4040, $0000, $C0C0, $20E0, $90F0
	dw $88F8, $88F8, $08F8, $48F8, $90F0, $20E0, $C0C0, $0000
	
	dw $0000, $0000, $0404, $0202, $0000, $0303, $0407, $080F
	dw $141F, $141F, $141F, $101F, $0A0F, $0407, $0303, $0000
	dw $0000, $0000, $0000, $0000, $0000, $C0C0, $20E0, $10F0
	dw $08F8, $08F8, $08F8, $08F8, $10F0, $20E0, $C0C0, $0000
	
TestNPCWalkingTiles::
	dw $0202, $0404, $0000, $0303, $0407, $080F, $101F, $101F
	dw $101F, $101F, $080F, $0407, $0303, $0000, $0000, $0000
	dw $8080, $4040, $0000, $C0C0, $20E0, $10F0, $08F8, $08F8
	dw $08F8, $08F8, $10F0, $20E0, $C0C0, $0000, $0000, $0000
	
	dw $0202, $0404, $0000, $0303, $0407, $0A0F, $121F, $101F
	dw $131F, $121F, $090F, $0407, $0303, $0000, $0000, $0000
	dw $8080, $4040, $0000, $C0C0, $20E0, $90F0, $88F8, $08F8
	dw $C8F8, $48F8, $90F0, $20E0, $C0C0, $0000, $0000, $0000
	
	dw $0404, $0202, $0000, $0303, $0407, $080F, $141F, $141F
	dw $101F, $181F, $0407, $0407, $0303, $0000, $0000, $0000
	dw $0000, $0000, $0000, $C0C0, $20E0, $10F0, $08F8, $08F8
	dw $08F8, $08F8, $10F0, $20E0, $C0C0, $0000, $0000, $0000
	
	
TestMapSignText::
	disp_box
	print_line TestMapSignLine0
	print_line TestMapSignLine1
	wait_user
	print_line TestMapSignLine2
	print_line TestMapSignLine3
	empty_line
	wait_user
	clear_box
	print_line TestMapSignLine4
	print_line TestMapSignLine5
	print_line TestMapSignLine6
	wait_user
	clear_box
	delay 60
	print_line TestMapSignLine7
	print_line TestMapSignLine8
	wait_user
	done
	
TestMapSignLine0::
	db "Howdy, "
	dstr "fellow"
TestMapSignLine1::
	dstr "traveler!"
TestMapSignLine2::
	dstr "Welcome to the"
TestMapSignLine3::
	dstr "Test Map!"
TestMapSignLine4::
	dstr "Enjoy your stay"
TestMapSignLine5::
	dstr "in this strange"
TestMapSignLine6::
	dstr "place."
TestMapSignLine7::
	db "Also, "
	dstr "how the hell"
TestMapSignLine8::
	dstr "did you get here??"


SECTION "Test house map", ROMX
TestHouse::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_TEST_HOUSE
	dw 0 ; No map script
	map_size 9, 6
	dw 0 ; No loading script
	
TestHouseInteractions::
	db 1
	
	db WALK_LOADZONE
	dw $004B
	dw $002E
	db 6
	db 5
	db 0
	db 0
	
TestHouseNPCs::
	db 1
	
	dw $0020
	dw $0020
	db 16
	db 16
	db 0
	db $01 << 2 + DIR_LEFT
	db $12, $12
	db $00
	db $00
	
	db $01
	dw TestHouseNPCScripts
	
	db $01
	dw TestHouseNPCTiles
	
TestHouseWarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $0041 ; Y pos
	dw $0030 ; X pos
	db DIR_UP ; Direction
	db NO_WALKING ; Flags
	db 0
	dw 0 ; Loading script (none)
	ds 7
	
TestHouseBlocks::
INCBIN "maps/testhouse.blk"
	
TestHouseNPCScripts::
	dw TestHouseTestBattleScript
	
TestHouseTestBattleScript::
	text_bankswitch BANK(wTestWarriorFlags)
	text_lda wTestWarriorFlags
	text_bankswitch 1
	text_bit $80
	print_name .name
.source1
	text_jr cond_nz, (.branch1 - .source1)
	print_line .line0
	delay 60
	wait_user
	clear_box
	print_line .line1
	delay 100
	text_bankswitch BANK(wTestWarriorFlags)
	text_lda_imm $80
	text_sta wTestWarriorFlags
	text_bankswitch 1
	print_line .line2
	empty_line
	empty_line
.source2
	choose YesNoChoice, (.branch2 - .source2)
	clear_box
	print_line .line3
	print_line .line4
	wait_user
	clear_box
	print_line .line5
	print_line .line6
	print_line .line7
	wait_user
	done
	
.branch2
	clear_box
	print_line .line8
	print_line .line9
	wait_user
	clear_box
	print_line .line5
	print_line .line6
	print_line .line7
	wait_user
	clear_box
	print_line .line10
	print_line .line11
	print_line .line12
	wait_user
	done
	
.branch1
	print_line .line13
	wait_user
	clear_box
	print_line .line1
	delay 60
	print_line .line14
	wait_user
	print_line .line15
	print_line .line16
	empty_line
.source3
	choose YesNoChoice, (.branch3 - .source3)
	
	clear_box
	print_line .line17
	delay 60
	text_lda_imm 0
	text_sta wBattleTransitionID
	text_inc
	text_sta wBattleEncounterID
	text_sta wBattlePreservedNPCs
	print_line .line18
	print_line .line19
	wait_user
	done
	
.branch3
	clear_box
	print_line .line20
	delay 60
	print_line .line21
	wait_user
	clear_box
	print_line .line22
	delay 30
	print_line .line23
	print_line .line24
	wait_user
	done
	
.name
	dstr "TEST WARRIOR"
.line0
	dstr "YARR!"
.line1
	dstr "..."
.line2
	dstr "Aren't you scared?"
.line3
	dstr "You don't look"
.line4
	dstr "very sincere..."
.line5
	dstr "I promise I won't"
.line6
	dstr "try to scare you"
.line7
	dstr "anymore."
	
.line8
	dstr "Oh! I am very"
.line9
	dstr "sorry!"
.line10
	dstr "I hope I didn't"
.line11
	dstr "make you angry or"
.line12
	dstr "anything..."
	
.line13
	db "Oh,"
	dstr " you again?"
.line14
	dstr "That look..."
.line15
	dstr "Are you looking"
.line16
	dstr "for a fight?"
	
.line17
	dstr "Well. Just..."
.line18
	dstr "Don't come crying"
.line19
	db "after, "
	dstr "okay?"
	
.line20
	dstr "Well."
.line21
	dstr "That's a relief."
.line22
	db "Actually,",0
.line23
	dstr "I don't like"
.line24
	dstr "to fight..."
	
TestHouseNPCTiles::
	dw $1010, $3C2C, $3F23, $1F1C, $3F20, $3F23, $3F3C, $3F21
	dw $3A3F, $151F, $2D3A, $2A3D, $1D1A, $0F0F, $0F09, $0606
	dw $0808, $3C34, $FCC4, $F838, $FC04, $FCC4, $FC3C, $FC84
	dw $5CFC, $A8F8, $54BC, $B45C, $58B8, $F0F0, $F090, $6060
	
	dw $1010, $3C2C, $3F23, $1F1C, $3F20, $3F26, $393F, $2A3F
	dw $223F, $181F, $273F, $2D36, $1A1D, $0F0F, $0F09, $0606
	dw $0808, $3C34, $FCC4, $F838, $FC04, $FC64, $9CFC, $54FC
	dw $44FC, $18F8, $E4FC, $74AC, $B858, $F0F0, $F090, $6060
	
	dw $0000, $0F0F, $1F11, $3F21, $3F3C, $171F, $151F, $151F
	dw $101F, $080F, $0707, $0605, $0506, $0203, $0704, $0303
	dw $8080, $F070, $F848, $FC4C, $FC34, $FCC4, $FC04, $F808
	dw $88F8, $90F0, $E0E0, $90F0, $50F0, $A060, $E020, $E0E0
	
	; No walking sprites, he doesn't move
	
	
TestForestMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db TILESET_TEST
	dw 0 ; Script (none)
	map_size 30, 18 ; Width, height
	dw 0 ; Loading script (none)
	
TestForestIneractions::
	db 1
	
	db WALK_LOADZONE
	dw $0068
	dw $01D1
	db 25
	db 4
	db 0
	db 2
	
TestForestNPCs::
	db 0
	
TestForestWarpToPoints::
	db 1
	
	dw $0074
	dw $01C8
	db DIR_LEFT
	db KEEP_WALKING
	db 0
	dw 0
	ds 7
	
TestForestBlocks::
INCBIN "maps/test_forest.blk"
	
