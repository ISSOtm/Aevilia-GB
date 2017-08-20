
INCLUDE "macros.asm"
INCLUDE "constants.asm"


SECTION "Intro map tileset", ROMX

IntroTileset::
	db $8C
	
	; $80
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00 ; Grey tile
	
	; Character select tiles
	dw $0000, $FFFF, $FF00, $FFFF, $0000, $0000, $0000, $0000
	dw $0000, $FFFF, $FF00, $FFFF, $0101, $0101, $0101, $0000
	
	dw $0000, $C0C0, $C040, $C040, $C040, $E020, $E020, $E0A0
	dw $0000, $0000, $0000, $0000, $1E1F, $6171, $4161, $80C0
	
	dw $0000, $0000, $0000, $0000, $1018, $1098, $1098, $2C3C
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $383C
	
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $7070
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $E1F1
	
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $C0E0
	; Re-using another tile
	
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0707
	dw $0000, $0000, $0000, $0000, $080C, $080C, $080C, $169F
	
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $1C1E
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $537B
	
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $87C7
	dw $0000, $0000, $0000, $0000, $0000, $1018, $1018, $38BC
	
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $E2F3
	dw $0000, $0303, $0302, $0302, $0302, $0704, $0704, $C785
	
	; Re-using two tiles
	
	; Second row, $91 onwards
	dw $F090, $F090, $7050, $7848, $7848, $3828, $3C24, $3C24
	dw $1F17, $1F10, $1F1F, $0000, $0000, $0000, $0000, $0000
	dw $80C0, $80C0, $81C1, $82C3, $4667, $383C, $0000, $0000
	dw $FFFF, $FF00, $FFFF, $0000, $0000, $0000, $0000, $0000
	
	dw $323F, $2233, $22B3, $4466, $4466, $4466, $0000, $0000
	dw $4466, $85C7, $85C7, $85C7, $89CD, $7078, $0000, $0000
	
	dw $89CD, $098D, $088C, $0A8F, $129B, $E1F1, $0000, $0000
	dw $129B, $84C6, $777F, $141E, $141E, $E3F3, $0000, $0000
	
	dw $2030, $2030, $E0F0, $0000, $4060, $80C0, $0000, $0000
	dw $4466, $0406, $7C7E, $88CC, $88CC, $787C, $0000, $0000
	
	dw $080C, $1018, $1018, $1018, $1119, $0E0F, $0000, $0000
	dw $99D9, $1119, $1119, $2233, $22B3, $2233, $0000, $0000
	
	dw $22B3, $0283, $3EBF, $44FF, $4466, $3C3E, $0000, $0000
	dw $6476, $4060, $4767, $88CC, $88CC, $87C7, $0000, $0000
	
	dw $486C, $5078, $D0F8, $90D8, $91D9, $8ECF, $0000, $0000
	dw $91D9, $121B, $2333, $2233, $22B3, $3139, $0000, $0000
	
	dw $139B, $121B, $F2FB, $0406, $2436, $C4E6, $0000, $0000
	
	; Third row
	dw $0000, $0000, $0000, $0000, $0707, $1F18, $7F60, $FFC0 ; A3
	dw $0000, $0000, $0000, $0000, $FFFF, $FF00, $FF00, $FF00 ; A4
	dw $0000, $0000, $0000, $0000, $F8F8, $FF07, $FF00, $FF00 ; A5
	dw $0000, $0000, $0000, $0000, $0000, $0000, $C0C0, $F838 ; A6
	dw $C0C0, $A0A0, $CACA, $AAAA, $C4C4, $0404, $0404, $0000 ; These tiles were
	dw $C600, $CC02, $D804, $F008, $F800, $DC20, $CE10, $00CE ; unused, so here's
	dw $3800, $6C10, $C628, $C600, $FE00, $C638, $C600, $00C6 ; a little credit to Kai
	dw $7E00, $1866, $1800, $1800, $1800, $1800, $7E00, $007E ; for these graphics ! :)
	dw $0303, $0704, $0F08, $1F10, $3F20, $7F40, $7F41, $FF83 ; AB
	dw $FF00, $FF00, $FF03, $FF1F, $FF7C, $FFE0, $FF80, $FF00 ; AC
	dw $FF00, $FF7F, $FFFF, $FF80, $FF00, $FF00, $FF08, $FF08 ; AD
	dw $FF00, $FF00, $FFE0, $FFFE, $FF1F, $FF01, $FF00, $FF00 ; AE
	dw $FE06, $FF01, $FF00, $FF00, $FF80, $FFC0, $FF60, $FF30 ; AF
	dw $0000, $8080, $C040, $E020, $F010, $F808, $FC04, $FC04 ; B0
	dw $0000, $0101, $0302, $0704, $0F08, $1F10, $3F20, $3F21 ; B1
	dw $7F60, $FF80, $FF00, $FF00, $FF00, $FF00, $FF00, $FFC0 ; B2
	dw $C0C0, $E020, $F010, $F808, $FC04, $FE02, $FE02, $FF01 ; B3
	
	; Fourth row
	dw $0000, $0101, $0101, $0101, $0101, $0302, $0302, $0302 ; B4
	dw $FF86, $FF0C, $FF0C, $FF18, $FF18, $FF30, $FF20, $FF00 ; B5
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF01, $FE07 ; B6
	dw $F71C, $F71C, $E73C, $E33E, $C17F, $81FF, $00FF, $00FF ; B7
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF80, $7FC0 ; B8
	dw $FF18, $FF0C, $FF06, $FF03, $FF01, $FF01, $FF00, $FF00 ; B9
	dw $FE02, $FE02, $FF01, $FF00, $FF80, $FF80, $FFC0, $FF60 ; BA
	dw $0000, $0000, $0000, $8080, $8080, $8080, $C040, $C040 ; BB
	dw $7F41, $7F41, $FF81, $FF01, $FF01, $FF01, $FF01, $FF01 ; BD
	dw $7FF0, $1FFC, $03FF, $00FF, $00FF, $00FF, $00FF, $00FF ; BE
	dw $FF01, $FF02, $FFEF, $39FF, $10FF, $00FF, $00FF, $00FF ; BF
	dw $FFF0, $FF0F, $FF00, $FFC0, $3FFE, $03FF, $00FF, $00FF ; C0
	dw $FF01, $FF81, $FFC1, $FF61, $FF31, $FF39, $F79C, $73DE ; C1
	dw $FF00, $FF80, $7FE0, $3FF0, $1FFC, $1FF3, $8FF8, $8FF8 ; C2
	dw $8080, $C040, $E020, $F010, $F808, $FEC6, $FF7F, $F050 ; C3
	dw $0302, $0704, $0704, $0704, $0704, $0F08, $0F08, $0F08 ; C4
	dw $FF00, $FF00, $FF03, $FC0F, $F01F, $E73F, $EF3F, $F83F ; C5
	dw $F81F, $E07F, $80FF, $00FF, $00FF, $F0FF, $F8FF, $08FF ; C6
	dw $00FF, $00FF, $00FF, $00FF, $03FF, $0FFF, $0CFF, $00FF ; C7
	dw $3FE0, $1FF0, $0FF8, $07FC, $FFFE, $FFFF, $00FF, $7CFF ; C8
	dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF80, $7FE0 ; C9
	dw $FF60, $FF30, $FF18, $FF18, $FF18, $FF08, $FF00, $FF00 ; CA
	dw $E020, $E020, $E020, $E020, $E020, $F010, $F010, $F010 ; CB
	dw $0302, $0302, $0302, $0302, $0302, $0302, $0302, $0302 ; CC
	dw $FF01, $FF01, $FE03, $FE03, $FE03, $FE03, $FE07, $FC07 ; CD
	dw $00FF, $00FF, $00FF, $00FF, $03FF, $07FF, $00FF, $00FF ; CE
	dw $00FF, $00FF, $00FF, $00FF, $FFFF, $FFFF, $00FF, $7EFF ; CF
	dw $00FF, $00FF, $00FF, $00FF, $C0FF, $E0FF, $60FF, $00FF ; D0
	dw $39EF, $38EF, $18FF, $08FF, $00FF, $0FFF, $1FFF, $10FF ; D1
	dw $87FC, $87FC, $07FC, $07FC, $07FC, $E7FC, $E7FC, $07FC ; D2
	dw $F050, $F050, $F050, $F0D0, $F090, $F090, $F090, $F090 ; D3
	
	; Fifth row
	dw $0F08, $0F08, $0F08, $0F08, $0F08, $0F08, $0F08, $0F08 ; D4
	dw $E33F, $E73F, $EC3C, $EC3C, $EC3C, $EC3C, $E43C, $E43C ; D5
	dw $0000, $0000, $0000, $0000, $0000, $0000, $7080, $3040 ; D6
	dw $00FF, $01FF, $01FF, $00FE, $00FE, $00FE, $00FE, $00FF ; D7
	dw $0000, $0000, $0000, $0000, $0000, $0000, $1E20, $231C ; D8
	dw $9FF0, $4FFC, $A3FF, $C1FF, $E1FF, $C1FF, $C0FF, $C0FF ; D9
	dw $FF00, $FF00, $FF8F, $F07F, $E03F, $E63F, $C0FF, $C8FF ; DA
	dw $F010, $F010, $F010, $F090, $70D0, $70D0, $70D0, $70D0 ; DB
	dw $0302, $0302, $0302, $0303, $0203, $0203, $0203, $0203 ; DC
	dw $FC07, $FC07, $FCF7, $0CFF, $04FF, $64FF, $02FF, $12FF ; DD
	dw $00FF, $01FF, $03FF, $03FF, $03FF, $03FF, $03FF, $03FF ; DE
	dw $C7FC, $E7FC, $373D, $373D, $373D, $373D, $273D, $273F ; E2
	dw $F0B0, $E0A0, $E060, $C040, $8080, $8080, $0000, $0000 ; E3
	dw $0F08, $0F08, $0F08, $0F08, $0F08, $0F08, $0F08, $0704 ; E4
	dw $E23E, $E13F, $E03F, $E03F, $E03F, $E03F, $E03F, $F01F ; E5
	dw $0060, $0000, $0000, $0000, $0000, $0000, $0101, $0101 ; E6
	dw $0000, $0000, $0000, $0000, $8080, $8080, $0000, $0000 ; E7
	dw $001F, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; E8
	dw $80FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF ; E9
	dw $CCFF, $54FF, $54FF, $18FF, $11FF, $01FF, $03FE, $07FC ; EA
	dw $70D0, $70D0, $E0A0, $E0A0, $E020, $E020, $E020, $C040 ; EB
	dw $0203, $0203, $0303, $0101, $0000, $0000, $0000, $0000 ; EC
	dw $32FF, $2AFF, $2AFF, $18FF, $88FF, $80FF, $407F, $203F ; ED
	dw $03FF, $01FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF ; EE
	dw $467E, $84FC, $04FC, $04FC, $04FC, $04FC, $04FC, $08F8 ; F2
	
	; Sixth row
	dw $0704, $0704, $0704, $0704, $0704, $0302, $0302, $0302 ; F3
	dw $F01F, $F01F, $F01F, $F80F, $F80F, $FC07, $FC07, $FE03 ; F4
	dw $01FF, $00FF, $00FF, $00FF, $00FF, $00FF, $03FF, $03FE ; F5
	dw $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $FCFF, $FC07 ; F6
	dw $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $01FF, $03FE ; F7
	dw $3FF8, $7FC0, $7FC0, $7FC0, $FF80, $FF81, $FF01, $FF01 ; F8
	dw $C040, $8080, $8080, $8080, $8080, $0000, $0000, $0000 ; F9
	dw $1C1F, $0203, $0203, $0203, $0101, $0101, $0000, $0000 ; FA
	dw $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $80FF, $407F ; FB
	dw $00FF, $00FF, $00FF, $00FF, $80FF, $40FF, $3FFF, $00FF ; FC
	dw $80FF, $00FF, $00FF, $00FF, $00FF, $80FF, $00FF, $00FF ; FD
	dw $08F8, $08F8, $08F8, $10F0, $10F0, $20E0, $20E0, $40C0 ; FE
	dw $0302, $0101, $0101, $0101, $0101, $0000, $0000, $0000 ; FF
	dw $FE03, $FF01, $FF01, $FF00, $FF00, $FF80, $FF80, $7F40 ; 1:80
	dw $01FF, $00FF, $00FF, $80FF, $C07F, $E03F, $F01F, $F80F ; 1:81
	dw $FC07, $F88F, $70FF, $00FF, $00FF, $00FF, $00FF, $00FF ; 1:82
	dw $00FF, $00FF, $00FF, $00FF, $00FF, $01FF, $06FF, $08FF ; 1:83
	dw $07FC, $0FF8, $1FF0, $3FE0, $7FE0, $BFE0, $3FE0, $3FE0 ; 1:84
	dw $FE02, $FE02, $FC04, $FC04, $FC04, $F808, $F808, $F010 ; 1:85
	dw $203F, $101F, $080F, $0407, $0607, $0507, $0407, $0407 ; 1:86
	dw $00FF, $00FF, $00FF, $01FF, $02FE, $04FC, $08F8, $10F0 ; 1:88
	dw $40C0, $8080, $8080, $0000, $0000, $0000, $0000, $0000 ; 1:89
	dw $7F40, $3F20, $3F20, $1F10, $1F10, $0F08, $0F09, $0606 ; 1:8A
	dw $FE07, $FF01, $FF00, $FF00, $FF1F, $E0E0, $0F0F, $1F18 ; 1:8B
	dw $00FF, $81FF, $FE7F, $C07F, $C07F, $C0FF, $C0FF, $C07F ; 1:8C
	dw $30FF, $C0FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF ; 1:8D
	dw $3FE0, $3FE0, $3FE0, $3FE0, $3FE1, $1EF2, $1FFF, $1FF0 ; 1:8E
	dw $F010, $E020, $C040, $8080, $0000, $0000, $C0C0, $F070 ; 1:8F
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0303, $0F0E ; 1:90
	dw $0407, $0407, $0407, $0407, $0407, $080F, $F8FF, $F80F ; 1:91
	dw $00FF, $81FF, $7EFE, $02FE, $02FE, $02FE, $03FF, $03FE ; 1:93
	dw $60E0, $8080, $0000, $0000, $0000, $0000, $F0F0, $F818 ; 1:94
	
	; $00 : Black void
	tile_attr $20, 0, 2, 0, 0, 0, 0
	tile_attr $20, 0, 2, 0, 0, 0, 0
	tile_attr $20, 0, 2, 0, 0, 0, 0
	tile_attr $20, 0, 2, 0, 0, 0, 0
	
	; $01 : Grey void (walkable)
	tile_attr $80, 1, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	tile_attr $80, 0, 2, 0, 0, 0, 0
	
	; Character select blocks
	; First row
	tile_attr $81, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $82, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0

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
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A3, 0, 4, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A4, 0, 4, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A5, 0, 4, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A6, 0, 4, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A6, 0, 6, 0, 1, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A5, 0, 6, 0, 1, 0, 0
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A4, 0, 6, 0, 1, 0, 0
	
	tile_attr $95, 0, 3, 0, 0, 0, 0
	tile_attr $A3, 0, 6, 0, 1, 0, 0
	tile_attr $93, 0, 3, 0, 1, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	; Third row
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
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
	
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $BB, 0, 4, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
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
	
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $C2, 0, 6, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	; Fourth row
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
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
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
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
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	; Fifth row
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
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
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $E8, 0, 6, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
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
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	tile_attr $F8, 0, 4, 0, 0, 0, 0
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
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
	
	tile_attr $00, 0, 0, 0, 0, 0, 0
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
	tile_attr $00, 0, 0, 0, 0, 0, 0
	
	; Filling block
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	
	; Unused blocks
REPT 7
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
	tile_attr $00, 0, 1, 0, 0, 0, 0
ENDR
	
	dw InvertedPalette
	dw CharSelectTextPalette
	dw CharSelectEviePalette0
	dw CharSelectEviePalette1
	dw CharSelectTomPalette0
	dw CharSelectTomPalette1
	
	dw IntroNPCPalette
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	
	
SECTION "Intro map", ROMX
IntroMap::
	db $80
	
	db MUSIC_NONE ; No music
	
	db TILESET_INTRO
	dw IntroMapScript
	map_size 15, 18
	dw NO_SCRIPT
	
IntroMapInteractions::
	db 0
	
IntroMapNPCs::
	db 6
	
	interact_box $0128, $0070, 16, 16 ; X hitbox
	db 0 ; Interaction ID
	db 1 << 2 + DIR_DOWN ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db 0 ; Movement permissions
	db 0 ; Movement speed
	
	; Dummy NPC for the camera to focus on during gender selection
	interact_box $00D0, $0000, 0, 0
	db 0
	db 2 << 2 | DIR_DOWN
	dn 0, 0, 0, 0
	db 0
	db 0
	
	; Dummy NPCs to display some of the character's eye colors to override some palette limitations
	interact_box $00C8, $0018, 0, 0
	db 0
	db 3 << 2 | DIR_LEFT
	dn 1, 1, 1, 1
	db 0
	db 0
	
	interact_box $00C8, $0020, 0, 0
	db 0
	db 4 << 2 | DIR_LEFT
	dn 1, 1, 1, 1
	db 0
	db 0
	
	interact_box $00C8, $0070, 0, 0
	db 0
	db 4 << 2 | DIR_RIGHT
	dn 1, 1, 1, 1
	db 0
	db 0
	
	interact_box $00C8, $0078, 0, 0
	db 0
	db 3 << 2 | DIR_RIGHT
	dn 1, 1, 1, 1
	db 0
	db 0
	
	db 1
	dw IntroMapNPCScripts
	
	db 4
	dw TestNPCTiles
	dw InvisibleTiles
	dw (LeftEyeTiles - 16 * 4 * 2) ; Make it so the actual tiles land in the slot for left/right, but without using padding
	dw (RightEyeTiles - 16 * 4 * 2)
	
IntroMapWarpToPoints::
	db 2
	
	dw $0028
	dw $0010
	db DIR_RIGHT
	db NO_WALKING
	db 2
	dw CharSelectLoadingScript
	ds 7
	
TUTORIAL_STARTING_YPOS = $0028
TUTORIAL_STARTING_XPOS = $0010
	
	dw TUTORIAL_STARTING_YPOS
	dw TUTORIAL_STARTING_XPOS
	db DIR_RIGHT
	db NO_WALKING
	db 0
	dw IntroMapLoadingScript
	ds 7
	
IntroMapBlocks::
INCBIN "maps/intro.blk"
	
	
InvisibleTiles::
	dwfill 2 * 3 * 4 * 8, $0000 ; (1 "still" set + 1 "moving" set) * 3 directions * 4 tiles * 8 lines


; The NPCs that use these can't be interacted with, so only one side will be coded (two because it's both left and right, left for Evie and mirrored left = right for Tom)
LeftEyeTiles::
	dw $F0F0, $F0F0, $68F8, $E8F8, $F0F0, $F0F0, $0000, $8080
	dw $9090, $6060, $0000, $0101, $0101, $0101, $0202, $0202
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
RightEyeTiles::
	dw $0000, $0101, $0101, $0001, $0001, $0001, $0001, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $83FF, $1FFF, $3CFF, $3CFF, $3FFF, $3FFF, $01C1, $20E0
	dw $10F0, $0F3F, $0000, $0000, $0000, $0000, $0000, $0000
	
	
IntroMapNPCScripts::
	dw IntroNPC0Script
	
IntroNPC0Script::
	print_name .name
	print_line .line0
	print_line .line1
	delay 100
	text_bankswitch BANK(wIntroMapStatus)
	text_lda wIntroMapStatus
	text_inc
	text_sta wIntroMapStatus
	text_bankswitch 1
	clear_box
	print_line .line2
	close_quick
	done
	
.name
	dstr "FRIENDLY NPC"
	
.line0
	dstr "Hi! It's rare to"
.line1
	dstr "see someone here!"
.line2
	dstr "My name is Jo"
	
	
; The caracter selection screen is actually part of the intro map (who would've known)
; The first loading script basically resets the tutorial
CharSelectLoadingScript::
	ld a, BANK(wIntroMapStatus)
	call SwitchRAMBanks
	xor a ; Initialize the map's status
	ld [wIntroMapStatus], a
	ld [wIntroMapDelayStep], a
	ldh [hOverworldButtonFilter], a
	inc a
	call SwitchRAMBanks
	jp PreventJoypadMovement ; Prevent player's movement, joypad input will only be used for the charselect, not to move the player
	
; Second loading script ; using a warp is more practical (notably because it provides an automated fade with some code exec in the middle)
; Also because it helps setting the map to a known state before the player is allowed to see the player even once
IntroMapLoadingScript::
	xor a ; Close the textbox that was left open by the previous script
	ld [wTextboxStatus], a
	jp AllowJoypadMovement ; Cancel above prevention
	
; The map script is basically a dispatcher, which either calls a function or processes some text depending on wIntroMapStatus
IntroMapScript::
	ld a, BANK(wIntroMapStatus)
	call SwitchRAMBanks
	ld a, [wIntroMapStatus] ; Read the index
	ld b, a ; Save for both dispatching and advancing status
	
	; Calculate status script pointer
	and %1111 ; Only bits 0-3 are used for status
	add a, a ; This is pretty standard, 2 bytes per pointer
	add a, IntroScripts & $FF
	ld l, a
	ld h, IntroScripts >> 8 ; hl points to the next pointer (the purpose / usage of which differs based on index parity)
	; Note : this assumes there's no carry. May not be true, if then move the pointer array around
	
	; Depending on status parity, the pointer should be interpreted differently
	bit 0, b ; If it's an even status, it's a text pointer
	jr nz, .runSpecificScript ; If it's an odd status, it's a code pointer
	
	inc b ; The text should only pop once
	ld a, b
	ld [wIntroMapStatus], a ; So we increment the status !
	
	; Now, we process the text
	ld c, BANK(IntroTexts)
	ld a, [hli]
	ld d, [hl]
	ld e, a
	jpacross ProcessText_Hook
	
.runSpecificScript
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h ; Check if that's not a NULL
	jr nz, @+1 ; No script, don't run it
	
	ld a, 1
	jp SwitchRAMBanks
	
; MAKE SURE THIS DOES NOT CROSS A 256-BYTE BOUNDARY !!
; (Except for the last byte, which is allowed to)
IntroScripts::
	dw IntroBoyGirlText
	dw IntroChooseGender
	dw IntroChoseGenderText
	dw IntroFadeToNarrator
	dw IntroGreetText
	dw IntroResetDelayStep
	dw IntroPressAText
	dw IntroWaitNextState
	dw IntroObjectNeededText
	dw 0 ; Don't do anything, the NPC script advances the status by itself
	dw IntroRemovedNPCText
	dw IntroCheckStartMenu
	
	
;SECTION "Intro map scripts", ROMX,ALIGN[5]
	
IntroChooseGender::
	ld a, [wIntroMapDelayStep]
	cp 20 ; Delay for a few frames to avoid A button spam
	jr z, .doneDelaying
	inc a ; Acknowledge one frame of delay
	ld [wIntroMapDelayStep], a
	cp 10 ; Halfway through, apply gray to a player
	ret nz
	; Gray out Tom
	xor a
	ld [hOverworldPressedButtons], a ; Make sure no action will be taken
	jr .toggleGender ; Gender loaded by default save file is Tom, so this will gray him out
	
.doneDelaying ; Run actual code
	ld a, [wPlayerGender]
	and a ; Z = Evie
	ldh a, [hPressedButtons]
	ldh [hOverworldPressedButtons], a
	jr nz, .checkLeft ; Tom checks DPAD_LEFT, Evie checks DPAD_RIGHT
	add a, a ; Roll DPAD_RIGHT into DPAD_LEFT
.checkLeft
	and DPAD_LEFT ; Check if player has pressed the button that changes gender
	jr z, .dontToggleGender
	
.toggleGender ; Hook for above
	callacross ReloadPalettes ; Cancel previous "gray" effect (this is overkill but smaller code than reloading only the two palettes)
	ld hl, wPlayerGender
	ld a, [hl] ; Retrieve currently chosen gender
	ld e, a ; Store it for gray out effect
	xor 1 ; Flip gender
	ld [hl], a
	
	; Little explanation here :
	; There are 2 palettes per player
	; 1 palette is 4 colors
	; In the GBC's memory, 1 color is 2 bytes large (post-processed size)
	; In the game's storage, 1 color is 3 bytes large (pre-processing size)
	; Thus, there are 2 * 4 * 2 bytes = 16 bytes per player in the GBC's memory
	;   and there are 2 * 4 * 3 bytes = 24 bytes per player in the game's storage
	
	; e = gender
	swap e ; e = gender * 16
	ld a, e
	add a, $80 | 32 ; This sets the base offset and sets the auto-increment bit
	ld [rBGPI], a
	ld a, e ; e = gender * 16
	rrca ; a = gender * 8
	add a, e ; a = gender * 24
	ld hl, wBGPalette4_color0
	add a, l
	ld l, a
	
	; Coming right up is graying out the two palettes of the character that's not chosen
	ld e, 8 ; Two palettes, thus 8 colors
.grayOutOneColor
	; Recipe to gray out a color :
	; 1. Sum the three shades in the color (R, G, B)
	; 2. Divide that by 3, thusly getting the mean of the shades
	; 3. Write that shade as the R, G and B shades
	; Explanation : step 3 produces a grey color.
	; Steps 1 and 2 ensure it's as close to the original color as possible.
	; (It's probably possible to do slightly better in some cases, but this looks good enough)
	ld a, [hli] ; Step 1 : sum
	add [hl]
	inc hl
	add [hl]
	inc hl
	call DivideBy3 ; Step 2 : divide by 3
	ld a, c ; Step 2.5 : we're going to darken the "inactive" character to emphasis a bit on it being "inactive"
	cp $1F
	jr z, .dontCap ; Don't darken white, it creates a weird outline (and doesn't make sense visually)
	sub 4 ; Remove some intensity, this is purely arbitrary, but heh
	jr nc, .dontCap
	xor a
.dontCap
	ld c, a ; Step 3 : convert the 3-byte format into the GBC's 2-byte one
	and %111 ; Not going to comment it. You can easily figure it out.
	rrca
	rrca
	rrca
	or c
	ld d, a ; Store for later
	ld a, c
	and %11000
	rlca
	rlca
	rlca
	or c
	rlca
	rlca
	ld c, a
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, d
	ld [rBGPD], a ; We write both bytes as shortly as possible to avoid doing so on different scanlines,
	ld a, c
	ld [rBGPD], a ; which produces "parasitic" colors (even more since the green shade is split across both bytes)
	dec e
	jr nz, .grayOutOneColor
	
.dontToggleGender
	ldh a, [hOverworldPressedButtons]
	and BUTTON_A | BUTTON_START | BUTTON_SELECT
	ret z ; Don't advance status if A or START or SELECT aren't pressed
	
	; Gender has been chosen !
	inc b
	ld a, b
	ld [wIntroMapStatus], a ; Advance status
	
	xor a ; Reset the delay counter for the following statuses
	ld [wIntroMapDelayStep], a
	
	; Apply gray effect to the palette in the palette array, otherwise color will suddenly re-appear during fade-out
	ld hl, wBGPalette4_color0
	ld a, [wPlayerGender]
	and a
	jr nz, .grayTom
	ld l, wBGPalette6_color0 & $FF
.grayTom
	ld b, 4 * 2 ; Gray two palettes, ie. 2 times 4 colors
.grayOneColor
	ld a, [hli]
	add a, [hl]
	inc hl
	add a, [hl]
	dec hl
	dec hl
	call DivideBy3
	ld a, c
	cp $1F
	jr z, .dontDarken
	sub 4
	jr nc, .dontDarken ; If there is an underflow, "cap" at black
	xor a
.dontDarken
	ld c, 3
	rst fill
	dec b
	jr nz, .grayOneColor
	
	ld a, [wPlayerGender]
	and a
	ret nz ; Tom's gfx are loaded by default, don't reload if it's still Tom
	jpacross LoadPlayerGraphics
	
IntroFadeToNarrator::
	inc b
	ld a, b
	ld [wIntroMapStatus], a
	ld a, 1
	ldh [hIgnorePlayerActions], a
	; Reload map with warp-to #1
	ld [wTargetWarpID], a ; Which sets things for the "tutorial" part instead of the "charselect" one
	inc a
	jp LoadMap
	
IntroResetDelayStep::
	; Check if player is still at its starting position
	; If warp-to #1's position is modified, update these accordingly
	ld a, [wYPos]
	cp TUTORIAL_STARTING_YPOS
	jr nz, .playerMoved
	
	ld a, [wXPos]
	cp TUTORIAL_STARTING_XPOS
	ret z
	
.playerMoved
	inc b
	ld a, b
	ld [wIntroMapStatus], a
	ret
	
IntroWaitNextState::
	ld a, [wIntroMapDelayStep] ; Holds the frame count when entering this state, used to determine when 256 frames have passed
	and a
	ld c, a
	ldh a, [hOverworldFrameCounter]
	; Will trigger twice if the frame counter to be stored is 0
	; Except when TASing this game, it wouldn't be a problem :D
	jr z, .setDelayStep ; Step is uninitialized, 
	
	cp c ; Check if 256 frames passed (~ 4 seconds)
	ret nz ; Nope
	
	ld a, [wIntroMapStatus]
	bit 6, a ; Check if 256 frames had already passed
	
	ld c, $40
	jr z, .first256block ; We're on the 256th frame, set the status flag to remember it
	; We're on the 512th frame, go to next state
	ld c, $1 - $40
.first256block
	
	add a, c
	ld [wIntroMapStatus], a
	ret
	
.setDelayStep
	ld [wIntroMapDelayStep], a
	ret
	
IntroCheckStartMenu::
	ld a, [wIntroMapStatus] ; Check bit 7, which is set if player answered "no" to previous text
	add a, a
	jr c, .playerTooSmart
	ldh a, [hPressedButtons]
	bit 3, a
	ret z
	ld de, IntroStartMenuText
	ld c, BANK(IntroStartMenuText)
	callacross ProcessText_Hook
	ld a, 3
	ld [wFadeSpeed], a
	
.playerTooSmart
	ld a, $F9
	ldh [hOverworldButtonFilter], a
	pop bc ; Remove the return address, otherwise LoadMap will return with the wrong ROM bank. Also, switching RAM banks back is done by LoadMap anyways
	ld a, 1
	ldh [hIgnorePlayerActions], a
	
	ld [wTargetWarpID], a ; Go to the test map's warp #1
	xor a
	jp LoadMap
	

SECTION "Intro map texts", ROMX
	
IntroTexts::

IntroBoyGirlText::
	print_pic GameTiles
	print_name GameName
	print_line .line0
	print_line .line1
	print_line .line2
	wait_user
	clear_box
	print_line .line3
	print_line .line4
	print_line .line5
	wait_user
	clear_box
	print_line .line6
	delay 60
	print_line .line7
	wait_user
	clear_box
	print_line .line8
	wait_user
	print_line .line9
	print_line .line10
	print_line .line11
	wait_user
	done
	
.line0
	dstr "Before you can"
.line1
	dstr "embark on this"
.line2
	dstr "adventure..."
.line3
	dstr "I must ask"
.line4
	dstr "A couple of"
.line5
	dstr "questions."
.line6
	dstr "The topic?"
.line7
	dstr "You."
.line8
	db "For example,", 0
.line9
	dstr "I need to know"
.line10
	dstr "If you are a"
.line11
	dstr "boy or girl."
	
	
IntroChoseGenderText::
	print_pic GameTiles
	print_name GameName
	print_line .line0
	wait_user
	clear_box
	print_line .line1
	print_line .line2
	print_line .line3
	wait_user
	clear_box
	print_line .line4
	print_line .line5
	wait_user
	end_with_box
	
.line0
	dstr "OKAY!"
.line1
	dstr "I'LL LEAVE YOU"
.line2
	dstr "WITH THE"
.line3
	dstr "NARRATOR."
.line4
	dstr "SEE YOU AND"
.line5
	dstr "HAVE FUN!"
	
	
IntroGreetText::
	disp_box
	delay 60
	print_line .line0
	wait_user
	clear_box
	print_line .line1
	print_line .line2
	wait_user
	clear_box
	print_line .line3
	wait_user
	clear_box
	print_line .line4
	print_line .line5
	wait_user
	done
	
.line0
	dstr "Ah."
.line1
	dstr "Someone has"
.line2
	dstr "arrived."
.line3
	dstr "Then hello."
.line4
	dstr "Use the d-pad"
.line5
	dstr "to move around."
	
	
IntroPressAText::
	delay 5
	disp_box
	print_line .line0
	delay 60
	print_line .line1
	print_line .line2
	print_line .line3
	wait_user
	done
	
.line0
	db "Okay, "
	dstr "good."
.line1
	dstr "Press A to"
.line2
	dstr "interact with"
.line3
	dstr "other things."
	
	
IntroObjectNeededText::
	disp_box
	print_line .line0
	print_line .line1
	wait_user
	clear_box
	print_line .line2
	print_line .line3
	delay 20
.source1
	choose YesNoChoice, (.branch1 - .source1)
	clear_box
	print_line .line4
	delay 60
	clear_box
	print_line .line5
	wait_user
	print_line .line6
	print_line .line7
	print_line .line8
	wait_user
	delay 30
	text_lda_imm $00
	text_sta wNPC1_ypos + 1
	text_lda wXPos ; Check if player might intersect NPC
	text_cmp $60
.source2
	text_jr cond_c, (.branch2 - .source2)
	text_lda_imm $50 ; If yes, move NPC to prevent this
	text_sta wNPC1_xpos
.branch2
	text_asmcall ProcessNPCs
	text_lda_imm $F1
	text_sta hOverworldButtonFilter
	delay 30
	print_line .line9
	wait_user
	done
	
.branch1
	clear_box
	delay 20
	print_line .line10
	delay 50
	print_line .line11
	delay 50
	wait_user
	clear_box
	print_line .line12
	print_line .line13
	print_line .line14
	wait_user
	clear_box
	print_line .line15
	text_bankswitch BANK(wIntroMapStatus)
	text_lda_imm $8B ; Set bit 7 to flag player as "too smart" and advance to last status
	text_sta wIntroMapStatus
	text_bankswitch 1
	delay 60
	print_line .line16
	wait_user
	done
	
	
.line0
	dstr "Why aren't you"
.line1
	dstr "interacting?"
.line2
	dstr "Are you even"
.line3
	dstr "trying?"
.line4
	dstr "..."
.line5
	db "Well, yes,", 0
.line6
	dstr "Maybe you need"
.line7
	dstr "something to"
.line8
	dstr "interact with."
.line9
	dstr "Okay. Now go."
.line10
	dstr "Oooh."
.line11
	dstr "I get it!"
.line12
	dstr "So you think"
.line13
	dstr "you're smarter"
.line14
	dstr "than ME?"
.line15
	dstr "Very well."
.line16
	dstr "Get outta here."
	
	
IntroRemovedNPCText::
	text_lda_imm $FF
	text_sta wNPC1_ypos
	text_asmcall ProcessNPCs
	delay 20
	disp_box
	print_line .line0
	print_line .line1
	wait_user
	clear_box
	print_line .line2
	print_line .line3
	wait_user
	done
	
.line0
	db "Okay, "
	dstr "enough"
.line1
	dstr "shenanigans."
.line2
	dstr "Press START to"
.line3
	dstr "open your menu."
	
	
IntroStartMenuText::
	disp_box
	print_line .line0
	print_line .line1
	print_line .line2
	wait_user
	print_line .line3
	print_line .line4
	print_line .line5
	wait_user
	clear_box
	print_line .line6
	print_line .line7
	wait_user
	instant_str .endingLines
	done
	
.line0
	db "Okay, "
	dstr "you know"
.line1
	dstr "what the START"
.line2
	dstr "button is."
.line3
	dstr "It's not my job to"
.line4
	dstr "explain this"
.line5
	dstr "crappy menu."
.line6
	dstr "You're on your"
.line7
	db "own, "
	dstr "get it?"
.endingLines
	dstr "Man I hate"
	dstr "this job."
	db 0

