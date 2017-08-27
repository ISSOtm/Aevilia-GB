
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
	tile_attr $80, 0, 2, 0, 0, 0, 0
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
	
	
	; Path tile
	db TILE_CANWALK
	
REPT $100 - 1
	db 0
ENDR
	
	
	db 0 ; Number of tile animations
	
	
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
