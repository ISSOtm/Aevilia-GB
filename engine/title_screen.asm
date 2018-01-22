
SECTION "Title screen", ROMX
	
PlayIntro::
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
	call FillVRAMLite
	ld hl, vAttrMap1
	ld c, VRAM_ROW_SIZE * 2
	call FillVRAMLite
	
	ld hl, IntroCloudTiles
	ld de, v1Tiles1
	ld bc, BANK(IntroCloudTiles) << 8 | $52
	call TransferTilesAcross
	
	xor a
	ld [rVBK], a
	
	ld [wIntroInterruptable], a
	ld [wIntroInterrupted], a
	ld [wIntroSP], sp
	
	ldh [hSpecialEffectsBuf + 1], a ; Cloud scroll offset
	ld a, 2 ; SCX
	ldh [hSpecialEffectsBuf], a
	ld a, (SCREEN_HEIGHT - 5) * 8
	ldh [hSpecialEffectsLY], a
	ld a, THREAD2_SCROLLCLOUDS
	ldh [hThread2ID], a
	
	ld c, 0
	ld de, TitleScreenCloudPalette
	callacross LoadBGPalette_Hook
	
	ld hl, IntroCloudMap
	ld de, vTileMap0 + VRAM_ROW_SIZE * (SCREEN_HEIGHT - 5)
	ld c, 5 * VRAM_ROW_SIZE
	call CopyToVRAMLite
	
	ld de, TitleScreenAeviDevPalette
	ld c, 1
	callacross LoadBGPalette_Hook
	ld de, TitleScreenAeviDevPalette + 3
	ld c, 1
	callacross LoadOBJPalette_Hook
	
	ld a, 1
	ld [wIntroInterruptable], a
	ld bc, 120
	call DelayBCFrames
	; xor a
	ld [wIntroInterruptable], a
	
	
	ld a, $5B
	ldh [hSCX], a
	ld a, 13
	ld [wIntroScrollSpeed], a
	ld a, 60
	ld [wIntroPauseLength], a
	
	ld a, 1
	ld [rVBK], a
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 2
	ld c, 0 ; VRAM_ROW_SIZE * 8
	call FillVRAMLite
	xor a
	ld [rVBK], a
	
	ld hl, AeviDevLogoTiles
	ld de, v0Tiles1
	ld bc, BANK(AeviDevLogoTiles) << 8 | $30
	call TransferTilesAcross
	
	ld hl, .lengths
	ld de, vTileMap0 + VRAM_ROW_SIZE * 3
	ld b, $80
.printAeviDev
	ld a, [hli]
	and a
	jr z, .donePrintingAeviDev
	ld c, a
	ld a, e
	and -VRAM_ROW_SIZE
	add a, VRAM_ROW_SIZE + 3
	ld e, a
	jr nc, .printAeviDevLine
	inc d
.printAeviDevLine
	rst isVRAMOpen
	jr nz, .printAeviDevLine
	ld a, b
	ld [de], a
	inc b
	inc de
	dec c
	jr nz, .printAeviDevLine
	jr .printAeviDev
	
.lengths
	db 3, 3, 8, 8, 8, 0
	
.donePrintingAeviDev
	ld hl, .oam
	ld de, wVirtualOAM
	ld c, 18 * OAM_SPRITE_SIZE
	rst copy
	ld a, 18
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	ld [wIntroInterruptable], a
	
	ld c, LOW(hSCX)
	ld hl, hSpecialEffectsBuf + 1
.animateAeviDev
	rst waitVBlank
	ldh a, [hFrameCounter]
	and 1
	jr nz, .animateAeviDev
	ld a, [wIntroScrollSpeed]
	and a
	jr nz, .move
	ld a, [wIntroPauseLength] ; Decrement the wait counter
	dec a
	ld [wIntroPauseLength], a
	jr nz, .animateAeviDev
	inc a ; If we finished waiting, set speed to non-zero
	ld [wIntroScrollSpeed], a
	jr .animateAeviDev
	
.move
	ld d, a
	ld a, [wIntroPauseLength]
	and a
	ld a, d
	jr nz, .decrementSpeed
	inc a
	cp $12
	jr z, .aeviDevDone
	inc a
.decrementSpeed
	dec a
	ld [wIntroScrollSpeed], a
	ld a, [c]
	sub d
	ld [c], a
	ld b, d
	ld de, wVirtualOAM + 1
.moveSprites
	ld a, [de]
	sub b
	ld [de], a
	ld a, e
	add a, 4
	ld e, a
	cp LOW(wVirtualOAM + 18 * OAM_SPRITE_SIZE + 1)
	jr nz, .moveSprites
	ld [wTransferSprites], a
	jr .animateAeviDev
	
.oam
	dspr 48,$B1,$9E, 1
	dspr 48,$B9,$9F, 1
	dspr 48,$C1,$A0, 1
	dspr 48,$C9,$A1, 1
	dspr 48,$D1,$A2, 1
	dspr 48,$D9,$A3, 1
	
	dspr 56,$B1,$A4, 1
	dspr 56,$B9,$A5, 1
	dspr 56,$C1,$A6, 1
	dspr 56,$C9,$A7, 1
	dspr 56,$D1,$A8, 1
	dspr 56,$D9,$A9, 1
	
	dspr 64,$B1,$AA, 1
	dspr 64,$B9,$AB, 1
	dspr 64,$C1,$AC, 1
	dspr 64,$C9,$AD, 1
	dspr 64,$D1,$AE, 1
	dspr 64,$D9,$AF, 1
	
.aeviDevDone
	ld bc, 20
	call DelayBCFrames
	; xor a
	ld [wIntroInterruptable], a
	
; -------------------------------------------------------------
	
DevSoftAnimation::
	ld a, $5C
	ldh [hSCX], a
	ld a, 13
	ld [wIntroScrollSpeed], a
	ld a, 60 ; Number of frames to stand still
	ld [wIntroPauseLength], a
	
	ld de, TitleScreenDevSoftPalette
	ld c, 1
	callacross LoadBGPalette_Hook
	ld de, TitleScreenDevSoftPalette + 3
	ld c, 1
	callacross LoadOBJPalette_Hook
	
	ld hl, DevSoftTiles
	ld de, v0Tiles1
	ld bc, BANK(DevSoftTiles) << 8 | $50
	call TransferTilesAcross
	
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 4
	ld c, SCREEN_WIDTH
	xor a
	call FillVRAMLite
	ld hl, DevSoftTilemap
	ld de, vTileMap0 + VRAM_ROW_SIZE * 5
	ld b, 5
	call TitleScreen.copyToScreen
	
	ld a, 1
	ld [wIntroInterruptable], a
	
.animateReloadHL
	ld hl, hSpecialEffectsBuf + 1
.animate
	ld c, LOW(hSCX)
	rst waitVBlank
	ldh a, [hFrameCounter]
	rrca
	jr c, .animate
	
	ld a, [wIntroScrollSpeed]
	and a
	jr nz, .move
	ld a, [wIntroPauseLength] ; Decrement the wait counter
	dec a
	ld [wIntroPauseLength], a
	cp 45
	jr z, .printMessage
	and a
	jr nz, .animate
	
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 3
	ld c, SCREEN_WIDTH
	call FillVRAMLite ; Clear message
	inc a ; If we finished waiting, set speed to non-zero
	ld [wIntroScrollSpeed], a
	jr .animate
	
.printMessage
	ld hl, .message
	ld de, vTileMap0 + VRAM_ROW_SIZE * 3 + 2
	call CopyStrToVRAM
	jr .animateReloadHL
	
.message
	dstr "SOUND ENGINE BY"
	
.move
	ld d, a
	ld a, [wIntroPauseLength]
	and a
	ld a, d
	jr nz, .moveLeft
	inc a
	cp $13
	jr z, DevSoftDone
	inc a
.moveLeft
	dec a
	ld [wIntroScrollSpeed], a
	ld a, [c]
	sub d
	ld [c], a
	cp $A6
	jr nz, .animate
	ld hl, $98AA
	ld b, 5
.clearRightOfLogo
	ld c, 10
	xor a
	call FillVRAMLite
	ld a, l
	add VRAM_ROW_SIZE - 10
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	dec b
	jr nz, .clearRightOfLogo
	jr .animateReloadHL
	
SkipIntroLogos::
	xor a
	ldh [hSCY], a
	ld [rSCY], a
	ld [wFadeSpeed], a
	callacross Fadeout
	
	ld hl, wIntroSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 2
	xor a
	ld c, a ; ld c, 0
	call FillVRAMLite
	ld hl, $9A40
	ld c, a ; ld c, 0
	call FillVRAMLite
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	
	callacross Fadein
	jr CopyrightAnimation
	
DevSoftDone::
	xor a
	ld [wIntroInterruptable], a
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 5
	ld c, VRAM_ROW_SIZE * 5
	call FillVRAMLite
	
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	
; -----------------------------------------------------------------------
	
CopyrightAnimation::
	ld bc, 10
	call DelayBCFrames
	
	ld hl, rLCDC
	set 2, [hl] ; Set 8x16 sprites
	xor a
	ldh [hSCX], a
	
	ld hl, CopyrightTiles
	ld de, v0Tiles1
	ld bc, BANK(CopyrightTiles) << 8 | $22
	call TransferTilesAcross
	
	ld hl, CopyrightOAM0
	ld de, wVirtualOAM
	ld c, OAM_SPRITE_SIZE * 9
	rst copy
	ld a, 9
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 24 + 7
	ld b, $94
.writeAeviDevLine0
	rst isVRAMOpen
	jr nz, .writeAeviDevLine0
	ld [hl], b
	inc hl
	inc b
	inc b
	ld a, b
	cp $A2
	jr nz, .writeAeviDevLine0
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 25 + 6
	ld b, $93
.writeAeviDevLine1
	rst isVRAMOpen
	jr nz, .writeAeviDevLine1
	ld [hl], b
	inc hl
	inc b
	inc b
	ld a, b
	cp $A1
	jr nz, .writeAeviDevLine1
	
	ld a, $DE
	ldh [hSCY], a
	ld hl, wIntroPauseLength
	ld a, 40
	ld [hld], a
	ld [hl], 12
.animate0
	rst waitVBlank
	; Reset SCY to 0 for the clouds
.wait0
	ld a, [rLY]
	sub 88
	jr nz, .wait0
	ld [rSCY], a
	ldh a, [hFrameCounter]
	rrca
	jr c, .animate0
	
	ldh a, [hSCY]
	sub [hl]
	ldh [hSCY], a
	ld de, wVirtualOAM
.scrollSprites0
	ld a, [de]
	sub [hl]
	ld [de], a
	ld a, e
	add OAM_SPRITE_SIZE
	ld e, a
	cp LOW(wVirtualOAM + OAM_SPRITE_SIZE * 9)
	jr nz, .scrollSprites0
	ld [wTransferSprites], a
	
	ld a, [hl]
	and a
	jr z, .waitAfterAnim0
	dec [hl]
	jr .animate0
	
.waitAfterAnim0
	inc hl
	dec [hl]
	dec hl
	jr nz, .animate0
	
	ld hl, CopyrightOAM1
	ld de, wVirtualOAM
	ld c, OAM_SPRITE_SIZE * 8
	rst copy
	ld a, 8
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	ld hl, CopyrightTilemap
	ld de, vTileMap0 + VRAM_ROW_SIZE * 24
	ld b, 2
	call TitleScreen.copyToScreen
	
	ld hl, wIntroScrollSpeed
	ld [hl], 0
.animate1
	rst waitVBlank
.wait1
	ld a, [rLY]
	sub 88
	jr nz, .wait1
	ld [rSCY], a
	ldh a, [hFrameCounter]
	rrca
	jr c, .animate1
	
	ldh a, [hSCY]
	add [hl]
	ldh [hSCY], a
	ld de, wVirtualOAM
.scrollSprites1
	ld a, [de]
	add [hl]
	ld [de], a
	ld a, e
	add OAM_SPRITE_SIZE
	ld e, a
	cp LOW(wVirtualOAM + OAM_SPRITE_SIZE * 8)
	jr nz, .scrollSprites1
	ld [wTransferSprites], a
	ld a, [hl]
	cp 12
	jr z, .done
	inc [hl]
	jr .animate1
	
.done:
	xor a
	ldh [hSCY], a
	ld hl, vTileMap0 + VRAM_ROW_SIZE * 24
	ld c, VRAM_ROW_SIZE * 2
	call FillVRAMLite
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	
; ----------------------------------------------------------------
	
TitleScreen::
	ld bc, 20
	call DelayBCFrames
	
	ld hl, TitleScreenSpriteTiles
	ld de, v0Tiles0
	ld bc, BANK(TitleScreenSpriteTiles) << 8 | $4C
	call TransferTilesAcross
	
	ld hl, TitleScreenBGTiles
	ld de, v0Tiles1
	ld bc, BANK(TitleScreenBGTiles) << 8 | $68
	call TransferTilesAcross
	
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
	
	ld hl, vTileMap0 + VRAM_ROW_SIZE
	ld c, 0 ; VRAM_ROW_SIZE * 8
	xor a
	call FillVRAMLite
	
	ld a, $82
	ldh [hSCX], a
	ld hl, .copyrightMap
	ld de, vTileMap1
	ld b, 2
	call .copyToScreen
	ld a, 7
	ldh [hWX], a
	ld a, 1
	ldh [hEnableWindow], a
	ld a, $90
	ldh [hWY], a
	
	ld b, a ; ld b, $90
.moveWindowUp
	rst waitVBlank
	dec b
	ld a, b
	ldh [hWY], a
	cp $86
	jr nz, .moveWindowUp
	
	ld bc, 30
	call DelayBCFrames
	
	ld c, LOW(hSpecialEffectsBuf + 1)
	ld b, 10
.scrollClouds
	rst waitVBlank
	rst waitVBlank
	ld a, [c]
	inc a
	ld [c], a
	dec b
	jr nz, .scrollClouds
	
	ld hl, .OAM
	ld de, wVirtualOAM
	ld c, OAM_SPRITE_SIZE * 40
	rst copy
	
	ld a, 40
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	
	ld a, 1
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
	ld de, vTileMap0 + VRAM_ROW_SIZE
	ld b, 12
	call .copyToScreen
	ld de, $99AA
.waitVRAM3
	rst isVRAMOpen
	jr nz, .waitVRAM3
	ld a, $D0
	ld [de], a
	inc de
	ld [de], a
	
	; Make a copy of the logo below the screen for the animation
	ld a, 1
	ld [rVBK], a
	ld hl, vTileMap0 + VRAM_ROW_SIZE
	ld de, vTileMap0 + VRAM_ROW_SIZE * 19
	ld c, VRAM_ROW_SIZE * 4
	call CopyToVRAMLite
	xor a
	ld [rVBK], a
	ld hl, vTileMap0 + VRAM_ROW_SIZE
	ld de, vTileMap0 + VRAM_ROW_SIZE * 19
	ld c, VRAM_ROW_SIZE * 4
	call CopyToVRAMLite
	
	; Perform animation
	ld hl, hSCY
	ld a, $B8 ; Make it so the top of the screen doesn't show the Aevilia logo
	ld [hli], a
.scrollTitleScreen
	rst waitVBlank
.waitBelowLogo
	ld a, [rLY]
	sub 40
	jr nz, .waitBelowLogo
	ld [rSCY], a
	
	; Do this now so it's not overwritten by Thread 2
	ld c, LOW(hSpecialEffectsBuf + 1)
	ld a, [hl]
	and 3
	jr nz, .dontMoveClouds
	ld a, [c]
	inc a
	ld [c], a
.dontMoveClouds
	
	ld de, wVirtualOAM + 1
	ld c, 40
.scrollSprites
	ld a, [de]
	dec a
	dec a
	ld [de], a
REPT 4
	inc de
ENDR
	dec c
	jr nz, .scrollSprites
	ld [wTransferSprites], a
	inc [hl]
	inc [hl]
	jr nz, .scrollTitleScreen
	
	ld hl, hSCY
	ld b, $C8
.scrollLogoIn
	ld [hl], b
	rst waitVBlank
.waitBelowLogo2
	ld a, [rLY]
	sub 40
	jr nz, .waitBelowLogo2
	ld [rSCY], a
	
	dec b
	ld a, b
	cp $90
	jr nz, .scrollLogoIn
	ld [hl], 0
	
	ld bc, 30
	call DelayBCFrames
	
	ld hl, vTileMap0
	ld b, $82
.writeVersion
	rst isVRAMOpen
	jr nz, .writeVersion
	ld [hl], b
	inc hl
	inc b
	ld a, b
	cp $89
	jr nz, .writeVersion
	
	ld hl, .pressSTARTStr
	ld de, $9B04
	call CopyStrToVRAM
	; xor a
	ld [wTitleScreenScrollDelay], a
	ld a, $7F
	ld [wTitleScreenScrollX], a
	
	ld bc, $7B
	xor a
.wait
	rst waitVBlank
.waitPressSTART
	ld a, [rLY]
	cp 40
	jr nz, .waitPressSTART
	
	ld a, $97
	ld [rSCY], a
	ld hl, wTitleScreenScrollDelay
	ld a, [hl] ; Check if delay is active
	and a
	jr nz, .decrementReg ; If so, decrement it
	dec hl ; Go to X
	ld a, [hl]
	and $7F
	cp $FE & $7F
	jr nz, .decrementReg ; Don't lock if not at extremes
	inc hl
	ld a, 120
	ld [hld], a
.decrementReg
	dec [hl]
	ld a, [wTitleScreenScrollX]
	ld [rSCX], a
.waitBelowPressSTART
	ld a, [rLY]
	cp 48
	jr nz, .waitBelowPressSTART
	xor a
	ld [rSCY], a
	ld [rSCX], a
	
	ldh a, [hPressedButtons]
	and BUTTON_A | BUTTON_START
	or b
	ld b, a
	jr z, .wait
	
.end
	callacross Fadeout
	ld hl, rLCDC
	res 2, [hl]
	xor a
	ldh [hEnableWindow], a
	
	ldh [hThread2ID], a
	
	ldh [hSpecialEffectsLY], a
	ldh [hSpecialEffectsBuf], a
	
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
	db $B5,$B5,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$B5,$B5,$B5
	db $8A,$8A,$8A,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF,$D0,$D1,$8A,$8A,$8A
	
.OAM
	; Eyes
	dspr  66,104+$7E, 0, 0
	dspr  66,114+$7E, 0, 0
	dspr  66, 42+$7E, 2, 0
	dspr  66, 52+$7E, 2, 0
	; Mouth
	dspr  61,109+$7E, 4, 0
	
	; Evie's right elbow
	dspr 105, 84+$7E,56, 2
	
	; Evie's left arm
	dspr  96,122+$7E,58, 2
	
	; Interleaved shirts
	; Tom top
	dspr  72, 31+$7E,28, 1
	dspr  72, 39+$7E,30, 1
	dspr  72, 47+$7E,32, 1
	dspr  72, 55+$7E,34, 1
	dspr  72, 63+$7E,36, 1
	
	; Tom mid
	dspr  88, 31+$7E,38, 1
	dspr  88, 39+$7E,40, 1
	dspr  88, 47+$7E,42, 1
	dspr  88, 55+$7E,44, 1
	dspr  88, 63+$7E,46, 1
	
	; Evie top
	dspr  82, 92+$7E, 6, 1
	dspr  82,100+$7E, 8, 1
	dspr  82,108+$7E,10, 1
	dspr  82,116+$7E,12, 1
	dspr  82,124+$7E,14, 1
	
	; Evie mid
	dspr  98, 99+$7E,16, 1
	dspr  98,107+$7E,18, 1
	dspr  98,115+$7E,20, 1
	
	; Tom bot
	dspr 103, 33+$7E,48, 1
	dspr 103, 41+$7E,50, 1
	dspr 103, 49+$7E,52, 1
	dspr 103, 57+$7E,54, 1
	
	; Evie bot
	dspr 103, 99+$7E,22, 1
	dspr 103,107+$7E,24, 1
	dspr 103,115+$7E,26, 1
	
	; Tom's jeans
	dspr 119, 29+$7E,60, 3
	dspr 119, 37+$7E,62, 3
	dspr 119, 45+$7E,64, 3
	dspr 119, 53+$7E,66, 3
	
	; Evie's jeans
	dspr 119, 99+$7E,68, 4
	dspr 119,107+$7E,70, 4
	dspr 119,115+$7E,72, 4
	dspr 119,123+$7E,74, 4
	
.pressSTARTStr
	dstr "PRESS START!"
	
	
	
IntroCloudMap:: ; 1 line = 1/2 VRAM row
	db $80,$81,$82,$83,$84,$85,  0,  0,  0,  0,  0,  0,  0,$86,$87,  0
	db $88,  0,  0,$80,$81,$82,$83,$84,$85,  0,  0,  0,  0,  0,  0,  0
	db $89,$8A,$8B,$8C,$8A,$8D,$8E,$8F,$90,$91,$92,$93,$94,$95,$96,$97
	db $98,$99,  0,$9A,$8A,$8B,$8C,$8A,$8D,$8E,$8F,$90,$91,$92,$93,$9B
	db $9C,$9D,$9E,$9F,$8A,$A0,$8A,$8A,$8A,$A1,$A2,$A3,$A4,$A5,$A6,$A7
	db $8A,$A8,$A9,$9C,$9D,$9E,$9F,$8A,$A0,$8A,$8A,$8A,$A1,$A2,$A3,$A4
	db $AA,$AB,$AC,$8A,$8A,$8A,$8A,$AD,$AE,$AF,$8A,$8A,$B0,$B1,$B2,$B3
	db $8A,$B4,$8A,$AA,$AB,$AC,$8A,$8A,$8A,$8A,$AD,$AE,$AF,$8A,$8A,$8A
	dbfill VRAM_ROW_SIZE, $8A
	
DevSoftTilemap::
	db   0,  0,$80,$81,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,$A7,$A8,$A9,$AA
	db $82,$83,$84,$85,$86,$87,$88,$89,  0,$8A,$AB,$AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4
	db $8B,$8C,$8D,$8E,$8F,$90,$91,$92,$93,$94,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE
	db $95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$BC,$BD,$BE
	db   0,$9F,$A0,$A1,$A2,$A3,$A4,  0,$A5,$A6,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF
	
	
CopyrightOAM0::
	dspr $7E,  8, $80, $81
	dspr $7E, 16, $82, $81
	dspr $7E, 24, $84, $81
	dspr $7E, 32, $86, $81
	dspr $7E, 40, $88, $81
	
	dspr $7E,112, $8A, $81
	dspr $7E,120, $8C, $81
	dspr $7E,128, $8E, $81
	dspr $7E,136, $90, $81
	
CopyrightTilemap::
	db   0,$80,$82,$84,$86,$88,  0,  0,  0,  0,  0,  0,  0,  0,$8A,$8C,$8E,$90,  0,  0
	db   0,$81,$83,$85,$87,$89,  0,  0,  0,  0,  0,  0,  0,  0,$8B,$8D,$8F,$91,  0,  0
	
CopyrightOAM1::
	dspr  48, 48, $92, $81
	dspr  48, 56, $94, $81
	dspr  48, 64, $96, $81
	dspr  48, 72, $98, $81
	dspr  48, 80, $9A, $81
	dspr  48, 88, $9C, $81
	dspr  48, 96, $9E, $81
	dspr  48,104, $A0, $81
	
