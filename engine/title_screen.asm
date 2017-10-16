
SECTION "Title screen", ROMX
	
TitleScreen::
	ld hl, vTileMap0
	ld bc, VRAM_ROW_SIZE * SCREEN_HEIGHT
	xor a
	call FillVRAM
	
	inc a ; ld a, 1
	ld [rVBK], a
	ld hl, vAttrMap0
	ld bc, VRAM_ROW_SIZE * (SCREEN_HEIGHT - 5)
	xor a
	call FillVRAM
	ld a, $08
	ld c, VRAM_ROW_SIZE * 5
	call FillVRAM
	
	ld a, BANK(IntroCloudTiles)
	ld hl, IntroCloudTiles
	ld de, v1Tiles1
	ld bc, VRAM_TILE_SIZE * $35
	call CopyAcrossToVRAM
	
	xor a
	ld [rVBK], a
	ld [wXPos], a ; Cloud scroll offset
	
	; ld c, 0
	ld de, TitleScreenCloudPalette
	callacross LoadBGPalette_Hook
	
	ld hl, .cloudMap
	ld de, vTileMap0 + VRAM_ROW_SIZE * (SCREEN_HEIGHT - 5)
	ld c, 5 * VRAM_ROW_SIZE
	call CopyToVRAMLite
	
	
	ld a, BANK(TitleScreenTiles)
	ld hl, TitleScreenTiles
	ld de, v0Tiles0
	ld bc, VRAM_TILE_SIZE * $106
	call CopyAcrossToVRAM
	
	ld de, TitleScreenLogoPalette0
	ld bc, $501
.loadBGPalettes
	push bc
	callacross LoadBGPalette_Hook
	ld d, h
	ld e, l
	pop bc
	inc c
	dec b
	jr nz, .loadBGPalettes
	
	ld bc, $500
.loadOBJPalettes
	push bc
	callacross LoadOBJPalette_Hook
	ld d, h
	ld e, l
	pop bc
	inc c
	dec b
	jr nz, .loadOBJPalettes
	
	ld hl, .OAM
	ld de, wVirtualOAM
	ld c, OAM_SPRITE_SIZE * 40
	rst copy
	
	ld a, 40
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	
	ld hl, rLCDC
	set 2, [hl] ; Set 8x16 sprites
	
	ld hl, .copyrightMap
	ld de, vTileMap1
	ld b, 2
	call .copyToScreen
	ld a, 7
	ld [wWX], a
	ld a, $86
	ld [wWY], a
	ld a, 1
	ld [wEnableWindow], a
	
	ld [rVBK], a
	ld hl, .topTitleMap
	ld de, vAttrMap0
	ld b, 13
	call .copyToScreen
	ld de, $99AA ; There are two tiles that are written in the middle of the cloud tilemap
.waitVRAM1 ; thus, they have to be added manually
	rst isVRAMOpen
	jr nz, .waitVRAM1
	ld a, $04
	ld [de], a
	inc de
.waitVRAM2
	rst isVRAMOpen
	jr nz, .waitVRAM2
	ld a, $24
	ld [de], a
	xor a
	ld [rVBK], a
	ld de, vTileMap0
	ld b, 13
	call .copyToScreen
	ld de, $99AA
.waitVRAM3
	rst isVRAMOpen
	jr nz, .waitVRAM3
	ld a, $D0
	ld [de], a
	inc de
	ld [de], a
	
.wait
	rst waitVBlank
	ldh a, [hPressedButtons]
	and BUTTON_A | BUTTON_START
	jr nz, .end
	
	; Scroll the clouds
	ld hl, wXPos
.waitLine
	ld a, [rLY]
	cp (SCREEN_HEIGHT - 5) * 8
	jr nz, .waitLine
.waitHBlank
	ld a, [rSTAT]
	and 3
	jr nz, .waitHBlank
	ld a, [hl]
	inc a
	ld [rSCX], a
	ld b, a
	ldh a, [hFrameCounter]
	and 15
	jr nz, .wait
	ld [hl], b
	jr .wait
	
.end
	callacross Fadeout
	ld hl, rLCDC
	res 2, [hl]
	xor a
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	rst waitVBlank
	ret
	
.copyToScreen
	ld c, SCREEN_WIDTH
	call CopyToVRAMLite
	ld a, e
	add a, VRAM_ROW_SIZE - SCREEN_WIDTH
	ld e, a
	jr nc, .noCopyCarry
	inc d
.noCopyCarry
	dec b
	jr nz, .copyToScreen
	ret
	
	
.cloudMap ; 1 line = 1/2 VRAM row
	db $80,$81,$82,$83,$84,$85,  0,  0,  0,  0,  0,  0,  0,$86,$87,  0
	db $88,  0,  0,$80,$81,$82,$83,$84,$85,  0,  0,  0,  0,  0,  0,  0
	db $89,$8A,$8B,$8C,$8A,$8D,$8E,$8F,$90,$91,$92,$93,$94,$95,$96,$97
	db $98,$99,  0,$9A,$8A,$8B,$8C,$8A,$8D,$8E,$8F,$90,$91,$92,$93,$9B
	db $9C,$9D,$9E,$9F,$8A,$A0,$8A,$8A,$8A,$A1,$A2,$A3,$A4,$A5,$A6,$A7
	db $8A,$A8,$A9,$9C,$9D,$9E,$9F,$8A,$A0,$8A,$8A,$8A,$A1,$A2,$A3,$A4
	db $AA,$AB,$AC,$8A,$8A,$8A,$8A,$AD,$AE,$AF,$8A,$8A,$B0,$B1,$B2,$B3
	db $8A,$B4,$8A,$AA,$AB,$AC,$8A,$8A,$8A,$8A,$AD,$AE,$AF,$8A,$8A,$8A
	dbfill VRAM_ROW_SIZE, $8A
	
.topTitleMap ; 1 line = 1 screen row
	dbfill SCREEN_WIDTH, 0
	db   0,  0,  0,  0,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	db   0,  0,  0,  0,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  0,  0,  0,  0
	db   0,  0,  0,  0,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  0,  0,  0,  0
	db   0,  0,  0,  0,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  0,  0,  0,  0
	dbfill SCREEN_WIDTH, 0
	db   0,  0,  0,  0,  5,  5,  5,  5,  0,  0,  0,  0,  4,  4,  4,  4,  0,  0,  0,  0
	db   0,  0,  0,  0,  5,  5,  5,  5,  5,  0,  0,  0,  4,  4,  4,  4,  0,  0,  0,  0
	db   0,  0,  0,  0,  5,  5,  5,  5,  0,  0,  0,  0,  4,  4,  4,  4,  0,  0,  0,  0
	db   0,  0,  0,  0,  5,  5,  5,  5,  0,  4,  4,  0,  4,  4,  4,  4,  0,  0,  0,  0
	db   0,  0,  0,  0,  0,  5,  5,  0,  0,  4,  4,  0,  4,  4,  4,  4,  0,  0,  0,  0
	db   0,  0,  0,  0,  0,  0,  0,  0,  0,  4,  4,  4,  4,  4,  4,  4,  4,  0,  0,  0
	db   0,  0,  0,  0,  0,  0,  0,  0,  0,  4,  4,  4,  4,  4,  4,  0,  0,  0,  0,  0
	
.topTileMap
	db $82,$83,$84,$85,$86,$87,$88,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	db $80,$80,$80,$80,$89,$8A,$8B,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	db $80,$80,$80,$80,$8C,$8D,$8E,$8F,$90,$91,$92,$93,$93,$94,$95,$96,$80,$80,$80,$80
	db $80,$80,$80,$80,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$9F,$A0,$A1,$A2,$80,$80,$80,$80
	db $80,$80,$80,$80,$A3,$A4,$A5,$A6,$A7,$A8,$A9,$AA,$AA,$AB,$AC,$AD,$80,$80,$80,$80
	db $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	db $80,$80,$80,$80,$D5,$D6,$D7,$D8,$80,$80,$80,$80,$AE,$AF,$B0,$B1,$80,$80,$80,$80
	db $80,$80,$80,$80,$D9,$DA,$DB,$DC,$DD,$80,$80,$80,$B2,$B3,$B4,$B5,$80,$80,$80,$80
	db $80,$80,$80,$80,$DE,$DF,$E0,$E1,$80,$80,$80,$80,$B6,$B7,$B8,$B9,$80,$80,$80,$80
	db $80,$80,$80,$80,$E2,$E3,$E4,$E5,$80,$C4,$C5,$80,$BA,$BB,$BC,$BD,$80,$80,$80,$80
	db $80,$80,$80,$80,$80,$E6,$E7,$80,$80,$C6,$C7,$80,$BE,$BF,$C0,$C1,$80,$80,$80,$80
	db $80,$80,$80,$80,$80,$80,$80,$80,$80,$C8,$C9,$CA,$CB,$C2,$C3,$D1,$D2,$80,$80,$80
	db $80,$80,$80,$80,$80,$80,$80,$80,$80,$CC,$CD,$CE,$CF,$D3,$D4,$80,$80,$80,$80,$80
	
.copyrightMap
	db $E8,$E8,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF,$F0,$F1,$F2,$F3,$F4,$F5,$F6,$E8,$E8,$E8
	db $81,$81,$81,$F7,$F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF,$01,$02,$03,$04,$05,$81,$81,$81
	
.OAM
	; Eyes
	dspr  66,104, 0, 0
	dspr  66,114, 0, 0
	dspr  66, 42, 2, 0
	dspr  66, 52, 2, 0
	; Mouth
	dspr  61,109, 4, 0
	
	; Evie's right elbow
	dspr 105, 84,56, 2
	
	; Evie's left arm
	dspr  96,122,58, 2
	
	; Interleaved shirts
	; Tom top
	dspr  72, 31,28, 1
	dspr  72, 39,30, 1
	dspr  72, 47,32, 1
	dspr  72, 55,34, 1
	dspr  72, 63,36, 1
	
	; Tom mid
	dspr  88, 31,38, 1
	dspr  88, 39,40, 1
	dspr  88, 47,42, 1
	dspr  88, 55,44, 1
	dspr  88, 63,46, 1
	
	; Evie top
	dspr  82, 92, 6, 1
	dspr  82,100, 8, 1
	dspr  82,108,10, 1
	dspr  82,116,12, 1
	dspr  82,124,14, 1
	
	; Evie mid
	dspr  98, 99,16, 1
	dspr  98,107,18, 1
	dspr  98,115,20, 1
	
	; Tom bot
	dspr 103, 33,48, 1
	dspr 103, 41,50, 1
	dspr 103, 49,52, 1
	dspr 103, 57,54, 1
	
	; Evie bot
	dspr 103, 99,22, 1
	dspr 103,107,24, 1
	dspr 103,115,26, 1
	
	; Tom's jeans
	dspr 119, 29,60, 3
	dspr 119, 37,62, 3
	dspr 119, 45,64, 3
	dspr 119, 53,66, 3
	
	; Evie's jeans
	dspr 119, 99,68, 4
	dspr 119,107,70, 4
	dspr 119,115,72, 4
	dspr 119,123,74, 4
	