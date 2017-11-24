
SECTION "Overworld tileset", ROMX, ALIGN[4]
WaterFrames::
	dw $7E81, $7F80, $3FC0, $3FC0, $3FC0, $9F60, $C33C, $E01F ; Frame 1
	dw $C13E, $FC03, $FE01, $7E81, $7E81, $7E81, $3FC0, $8778 ; Frame 2
	dw $0FF0, $837C, $F906, $FD02, $FC03, $FC03, $FC03, $FE01 ; Frame 3
	dw $FC03, $1EE1, $07F8, $F30C, $FB04, $F906, $F906, $F906 ; Frame 4
	dw $F30C, $F906, $3CC3, $0EF1, $E718, $F708, $F30C, $F30C ; Frame 5
	dw $E718, $E718, $F30C, $7887, $1CE3, $CF30, $EF10, $E718 ; Frame 6
	dw $CF30, $CF30, $CF30, $E718, $F00F, $38C7, $9F60, $DF20 ; Frame 7
	dw $BF40, $9F60, $9F60, $9F60, $CF30, $E11E, $708F, $3FC0 ; Frame 8
	
FlowerFrames::
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Flower
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; Flower frame 2
	

OverworldTileset::
	db $18 ; Number of tiles
	full_ptr OverworldTilesetTiles0
	db 1
	full_ptr WaterFrames
	db 5
	full_ptr OverworldTilesetTiles1
	db 1
	full_ptr FlowerFrames
	db $2E
	full_ptr OverworldTilesetTiles2
	db 0
	
	db 0
	
	
	; Grey border
	tile_attr $A9, 0, 1, 0, 0, 0, 0
	tile_attr $A9, 0, 1, 0, 0, 0, 0
	tile_attr $A9, 0, 1, 0, 0, 0, 0
	tile_attr $A9, 0, 1, 0, 0, 0, 0
	
	; Grass
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $82, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; House top-left
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $81, 0, 2, 0, 0, 0, 0
	tile_attr $8F, 0, 5, 0, 0, 0, 1
	tile_attr $8D, 0, 5, 0, 0, 0, 1
	
	; House top
	tile_attr $8C, 0, 5, 0, 0, 0, 1
	tile_attr $91, 0, 5, 0, 0, 0, 1
	tile_attr $8C, 0, 5, 0, 0, 0, 1
	tile_attr $91, 0, 5, 0, 0, 0, 1
	
	; House top-right
	tile_attr $8F, 0, 5, 0, 1, 0, 1
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
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	
	; Sign
	tile_attr $9B, 0, 1, 0, 0, 0, 1
	tile_attr $9C, 0, 1, 0, 0, 0, 0
	tile_attr $9B, 0, 1, 0, 1, 0, 1
	tile_attr $9C, 0, 1, 0, 1, 0, 0
	
	; Water top-left
	tile_attr $94, 1, 7, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water top
	tile_attr $93, 1, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water top-right
	tile_attr $93, 1, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Water left
	tile_attr $92, 1, 7, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Water
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	
	; Horizontal bridge
	tile_attr $9A, 0, 4, 0, 0, 0, 0
	tile_attr $99, 0, 4, 0, 0, 0, 0
	tile_attr $9A, 0, 4, 0, 0, 0, 0
	tile_attr $99, 0, 4, 0, 0, 0, 0
	
	; Vertical bridge
	tile_attr $9A, 0, 4, 0, 0, 0, 0
	tile_attr $9A, 0, 4, 0, 0, 0, 0
	tile_attr $9A, 0, 4, 0, 0, 0, 0
	tile_attr $9A, 0, 4, 0, 0, 0, 0
	
	; Water right
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Water bottom-left
	tile_attr $92, 1, 7, 0, 0, 1, 0
	tile_attr $94, 0, 7, 0, 0, 1, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	
	; Water bottom
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $98, 0, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	
	; Water bottom-right
	tile_attr $98, 1, 6, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
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
	tile_attr $A7, 0, 2, 0, 0, 0, 0
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
	
	; Horizontal fence and path
	tile_attr $AA, 0, 1, 0, 0, 0, 0
	tile_attr $AE, 0, 1, 0, 0, 0, 0
	tile_attr $AA, 0, 1, 0, 0, 0, 0
	tile_attr $AE, 0, 1, 0, 0, 0, 0
	
	; Horizontal fence end and path
	tile_attr $AB, 0, 1, 0, 0, 0, 0
	tile_attr $AE, 0, 1, 0, 0, 0, 0
	tile_attr $AA, 0, 1, 0, 0, 0, 0
	tile_attr $AE, 0, 1, 0, 0, 0, 0
	
	; Vertical fence and path (left)
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $AC, 0, 1, 0, 0, 0, 0
	tile_attr $AC, 0, 1, 0, 0, 0, 0
	
	; Vertical fence and path (right)
	tile_attr $AC, 0, 1, 0, 0, 0, 0
	tile_attr $AC, 0, 1, 0, 0, 0, 0
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	
	; Horizontal fence end and path
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $9D, 0, 1, 0, 0, 0, 0
	tile_attr $AB, 0, 1, 0, 0, 0, 0
	tile_attr $AE, 0, 1, 0, 0, 0, 0
	
	; Horizontal fence end and path
	tile_attr $AA, 0, 1, 0, 0, 0, 0
	tile_attr $AE, 0, 1, 0, 0, 0, 0
	tile_attr $AF, 0, 1, 0, 0, 0, 0
	tile_attr $B0, 0, 1, 0, 0, 0, 0
	
REPT 9
	tile_attr $A9, 0, 1, 0, 0, 0, 0
	tile_attr $A9, 0, 1, 0, 0, 0, 0
	tile_attr $A9, 0, 1, 0, 0, 0, 0
	tile_attr $A9, 0, 1, 0, 0, 0, 0
ENDR
	
; These blocks would requires special coding, maybe use them later
; (Note : currently they don't fit in the block space)
IF 0
	; Grass ledge down
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	
	; Grass ledge right
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Grass ledge left
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge up
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge corner upright
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	
	; Grass ledge corner upleft
	tile_attr $94, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 0, 0
	tile_attr $92, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge corner downright
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $95, 0, 7, 0, 0, 0, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	tile_attr $96, 0, 7, 0, 0, 1, 0
	
	; Grass ledge corner downleft
	tile_attr $92, 0, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $94, 0, 7, 0, 0, 1, 0
	tile_attr $93, 0, 7, 0, 0, 1, 0
	
	; Grass ledge inward upright
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $94, 0, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge inward upleft
	tile_attr $96, 0, 7, 0, 0, 1, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Grass ledge inward downright
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $94, 0, 7, 0, 0, 0, 0
	
	; Grass ledge inward downleft
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $96, 0, 7, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
ENDC
	
	
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
	db 0
	
	; Bridge
	db TILE_CANWALK
	db TILE_CANWALK
	
	; Sign
	db TILE_CANWALK
	db 0
	
	; Path
	db TILE_CANWALK
	
	; Flower
	db TILE_CANWALK
	
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
	
	; Fence tiles
	dbfill 4, 0
	db TILE_CANWALK
	db 0
	db TILE_CANWALK
	
	dbfill 26, 0
	; Unused tiles get nuffin'
REPT $100 - 75
	db 0
ENDR
	
	
	db 2 ; Number of tile animations
	
	db 30 ; Refresh period
	db 8 ; Number of frames
	db $18 ; ID of animated tile
	dw WaterFrames
	
	db 30
	db 2
	db $1E
	dw FlowerFrames
	
	
	dw DefaultPalette
	dw GrassPalette
	dw HousePalette
	dw DoorWindowPalette
	dw RoofPalette
	dw WaterPalette
	dw RockPalette
	
	dw GenericBoyAPalette
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
