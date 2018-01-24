
SECTION "Start menu", ROMX	
	
; If this isn't a power of two things will probably fail. Hard.
INTERLEAVE_SPEED	equ 8
; Value at which it should end (mov -> fix) or start (fix -> mov)
INTERLEAVE_LAST		equ $C0
	
InterleaveFromMovableToFixed::
	ld hl, rNR51 ; L/R connectors
	xor a
	ld [hl], a ; Mute sound
	ld l, LOW(rIE)
	ld b, [hl]
	ld [hl], 1
	xor a
	; e holds max scanline
	ld e, a ; ld e, 0
	; d holds first scanline
	ld d, a ; ld d, 0
	inc a
	ldh [hTilemapMode], a
	rst waitVBlank
.interleaveLoop
	push bc
	push de
	callacross FXHammer_Update
	pop de
	pop bc
	ld hl, rLCDC
	res 1, [hl]
	ld l, LOW(rLY)
	ld c, d
.oneScanline
	ld a, c
.waitScanline
	cp [hl]
	jr nz, .waitScanline
	inc c
	ld l, LOW(rSTAT)
.waitBlank
	ld a, [hl]
	and 3
	jr nz, .waitBlank
	dec l ; hl = rLCDC
	ld a, e
	cp c
	jr c, .dontWindow ; Don't window if past max line
	ld a, c
	rra
	jr c, .dontWindow ; Don't window if on odd line (NB: c is current +1)
	res 1, [hl]
	set 3, [hl]
	ld a, TILE_SIZE * 14
	ld [rSCY], a
	xor a
	jr .doneWindowing
.dontWindow
	set 1, [hl]
	res 3, [hl]
	ldh a, [hSCY]
	ld [rSCY], a
	ldh a, [hSCX]
.doneWindowing
	ld [rSCX], a
	ld l, LOW(rLY)
	ld a, [hl]
	cp LY_VBLANK - 1
	jr nz, .oneScanline
	ld a, e
	cp INTERLEAVE_LAST - INTERLEAVE_SPEED
	jr z, .displayFullWindow
	add a, INTERLEAVE_SPEED
	ld e, a
	jr .interleaveLoop
.displayFullWindow
	; VBlank re-enables sprites, make sure that doesn't override our sprite settings
	; Can't use waitVBlank, too timing-sensitive
.waitVBlank
	ld a, [rSTAT]
	and 3
	dec a
	jr nz, .waitVBlank
	ld a, d
	add a, INTERLEAVE_SPEED
	ld d, a
	cp LY_VBLANK
	jr nz, .interleaveLoop
	
	ld l, LOW(rIE)
	ld [hl], b
	ld l, LOW(rLCDC)
	res 1, [hl] ; Disable sprites, otherwise they appear for a single frame
	
	xor a
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	rst waitVBlank ; Also re-enables sprites
	ret
	
InterleaveFromFixedToMovable::
	ld hl, rNR51 ; L/R "connections"
	xor a
	ld [hl], a ; Mute sound
	ld l, LOW(rIE)
	ld b, [hl]
	res 1, [hl]
	ld de, ((LY_VBLANK - INTERLEAVE_SPEED) << 8) | (INTERLEAVE_LAST - INTERLEAVE_SPEED)
	inc a
	ldh [hTilemapMode], a
	rst waitVBlank
.interleaveLoop
	push bc
	push de
	callacross FXHammer_Update
	pop de
	pop bc
	ld c, d
	ld hl, rLCDC
	res 1, [hl]
	ld l, LOW(rLY)
.oneScanline
	ld a, c
.waitScanline
	cp [hl]
	jr nz, .waitScanline
	inc c
	ld l, LOW(rSTAT)
.waitBlank
	ld a, [hl]
	and 3
	jr nz, .waitBlank
	dec l ; hl = rLCDC
	ld a, e
	cp c
	jr c, .dontWindow ; Don't window if past max line
	ld a, c
	rra
	jr c, .dontWindow ; Don't window if on odd line (NB: c is current +1)
	res 1, [hl]
	set 3, [hl]
	ld a, TILE_SIZE * 14
	ld [rSCY], a
	xor a
	jr .doneWindowing
.dontWindow
	set 1, [hl]
	res 3, [hl]
	ldh a, [hSCY]
	ld [rSCY], a
	ldh a, [hSCX]
.doneWindowing
	ld [rSCX], a
	ld l, LOW(rLY)
	ld a, [hl]
	cp LY_VBLANK - 1
	jr nz, .oneScanline
	ld a, d
	and a
	jr z, .displayPartialWindow
	; VBlank re-enables sprites, make sure that doesn't override our sprite settings
	; Can't use waitVBlank, too timing-sensitive
.waitVBlank
	ld a, [rSTAT]
	and 3
	dec a
	jr nz, .waitVBlank
	ld a, d
	sub a, INTERLEAVE_SPEED
	ld d, a
	jr .interleaveLoop
.displayPartialWindow
	ld a, e
	sub a, INTERLEAVE_SPEED
	ld e, a
	jr nz, .interleaveLoop
	
	ldh [hTilemapMode], a
	ldh a, [hSCY]
	ld [rSCY], a
	ldh a, [hSCX]
	ld [rSCX], a
	ld l, LOW(rLCDC)
	res 3, [hl]
	ld l, LOW(rIE)
	ld [hl], b
	ret
	
	
StartMenu::
	rst waitVBlank
	ld a, 1
	ld [rVBK], a
	ld hl, wTransferRows + 6
	ld c, SCREEN_HEIGHT
	rst fill
	ld hl, wFixedTileMap
	xor a
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call Fill
	
	ld hl, StartMenuStrs
	ld de, wFixedTileMap + SCREEN_WIDTH + 5
	rst copyStr
	ld e, LOW(wFixedTileMap + SCREEN_WIDTH * 3 + 1)
	rst copyStr
	ld e, LOW(wFixedTileMap + SCREEN_WIDTH * 4 + 1)
	rst copyStr
	ld e, LOW(wFixedTileMap + SCREEN_WIDTH * 5 + 1)
	rst copyStr
	ld hl, wFixedTileMap + SCREEN_WIDTH * 6 + 2
	ld c, SCREEN_WIDTH - 4
	ld a, "_"
	rst fill
	
	xor a
	ld hl, vFixedMap
	ld c, VRAM_ROW_SIZE * 6
	call FillVRAMLite
	ld c, SCREEN_WIDTH
	ld a, $40
	call FillVRAMLite ; Flip the "_"s to create the bar
	ld bc, VRAM_ROW_SIZE * (SCREEN_HEIGHT - 7)
	xor a
	call FillVRAM
	ld [rVBK], a
	
	ld [SoundEnabled], a
	
	ld c,SFX_MENU_OPEN
	callacross FXHammer_Trig
	call InterleaveFromMovableToFixed
	
.mainLoop
	rst waitVBlank
	ldh a, [hPressedButtons]
	rrca
	rrca
	jr c, .saveGame
	rrca
IF DEF(DebugMode)
	jr c, .enableDebugWarping
ENDC
	rrca
	jr nc, .mainLoop
	
.exitMenu
	call ProcessNPCs ; Re-process NPC sprites which we had cleared
	call ExtendOAM
	ld a, 1
	ld [SoundEnabled], a
	call InterleaveFromFixedToMovable
	
	; Restore the tilemap
	xor a
	ld hl, wFixedTileMap + SCREEN_WIDTH * 6
	ld c, SCREEN_WIDTH
	rst fill
	inc a
	ld [wTransferRows + 14], a
	ld [rVBK], a
	ld hl, vTileMap1 + VRAM_ROW_SIZE * 5
	ld c, VRAM_ROW_SIZE + SCREEN_WIDTH
	call FillVRAMLite
	xor a
	ld [rVBK], a
	ret
	
IF DEF(DebugMode)
.enableDebugWarping
	ld hl, wWalkingLoadZone0_destWarp
.forceWarps
	ld [hl], 0
	inc hl
	ld [hl], MAP_TEST_HOUSE
	ld a, l
	add a, wWalkingLoadZone1_destWarp - wWalkingLoadZone0_destMap
	ld l, a
	jr nc, .forceWarps
	inc h
	ld a, h
	cp HIGH(wButtonLoadZone0_destWarp)
	jr z, .forceWarps
	jr .exitMenu
ENDC
	
.saveGame
	inc a ; Can't be $FF
	ld [wTransferRows + 22], a
	ld hl, wFixedTileMap + SCREEN_WIDTH * 14
	ld c, SCREEN_WIDTH - 2
	xor a
	rst fill
	callacross SaveFile
	inc hl
	inc hl
	
	ld de, sNonVoidSaveFiles - 1
	ldh a, [hSRAM32kCompat]
	and a
	jr z, .notCompat
	inc de
	jr .gotAddr
.notCompat
	ld a, [wSaveFileID]
	add a, e
	ld e, a
.gotAddr
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ld a, BANK(sNonVoidSaveFiles)
	ld [SRAMBank], a
	ld [de], a ; Mark save file as non-void
	xor a
	ld [SRAMEnable], a
	ld [SRAMBank], a
	
	ld c,SFX_TEXT_CONFIRM
	callacross FXHammer_Trig
	ld hl, DoneStr
	ld de, wFixedTileMap + SCREEN_WIDTH * 14 + 2
	rst copyStr
	inc a
	ld [wTransferRows + 22], a
	jp .mainLoop
	
StartMenuStrs::
	dstr "PAUSE MENU"
	dstr "START  : Exit menu"
	dstr "B      : Save"
	dstr "SELECT : Options"
	
