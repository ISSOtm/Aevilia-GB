
SECTION "Home debug menu", ROMX

HomeDebugMenu::
	ld a, 1
	ld [rVBK], a
	call ClearMovableMap
	ld [rVBK], a
	call ClearMovableMap
	ld c, 0
	ld de, DefaultPalette
	callacross LoadBGPalette_Hook
	
.restart
	xor a
	ldh [hTilemapMode], a
	ld hl, wFixedTileMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call Fill
	
	ld hl, wTransferRows + 8
	inc a ; ld a, 1
	ld c, SCREEN_HEIGHT
	rst fill
	
	ld hl, .strings
	ld de, $98A2
	call CopyStrToVRAM
	ld de, $9903
	ld b, 0
.printString
	inc b
	call CopyStrToVRAM
	ld a, e
	and -VRAM_ROW_SIZE
	add VRAM_ROW_SIZE * 2 + 3
	ld e, a
	jr nc, .printStringsNoCarry
	inc d
.printStringsNoCarry
	ld a, [hl]
	and a
	jr nz, .printString
	
	ld c, 0
	ld hl, $9901
	
.mainLoop
	rst waitVBlank
	ld [hl], $7F ; VBlank should still be in effect
	ldh a, [hPressedButtons]
	rra
	jr c, .exec
	and (DPAD_UP | DPAD_DOWN) >> 1
	jr z, .mainLoop
	ld [hl], 0
	and DPAD_UP >> 1
	jr nz, .up
	inc c
	ld a, c
	cp b
	jr nz, .redrawCursor
	xor a
	jr .redrawCursor - 1 ; Load a (which is 0) into c
	
.up
	ld a, c
	and a
	jr nz, .ok
	ld a, b
.ok
	dec a
	ld c, a
.redrawCursor
	swap a
	add a, a
	add a, a
	inc a ; add a, 1
	ld l, a
	jr .mainLoop
	
.exec
	ld [hl], 0
	ld a, c
	add a, a
	add a, LOW(.pointers)
	ld l, a
	adc a, HIGH(.pointers)
	sub l
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst callHL
	jr .restart
	
.strings
	dstr "DEBUG MENU"
	dstr "SOUND TEST"
	dstr "TILESET VIEWER"
	db 0
	
.pointers
	dw SoundTestMenu
	dw TilesetViewerMenu
	
	
SoundTestMenu::
	ld hl, .strings
.printStrings
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	rst copyStr
	ld a, [hl]
	and a
	jr nz, .printStrings
	
	ld hl, wTransferRows + 8
	ld c, SCREEN_HEIGHT
	inc a
	rst fill
	ldh [hTilemapMode], a
	
	ld [rVBK], a
	ld hl, $9E48
	ld b, $20
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld [hl], b
	ld l, $A8
	ld [hl], b
	xor a
	ld [rVBK], a
	
	ld [wYPos], a
	ld [wXPos], a
	ld [wCurrentMusicID], a
	jr .printMusicName
	
.mainLoop
	rst waitVBlank
	ld a, 1
	ld [wTransferRows + 18], a
	ld [wTransferRows + 21], a
	ldh a, [hPressedButtons]
	ld l, a
	rst waitVBlank
	
	ld de, wFixedTileMap + SCREEN_WIDTH * 10 + 8
	ld c, " "
	ld a, [wYPos]
	and a
	jr nz, .notOnMusic
	ld c, $7F
.notOnMusic
	ld a, c
	ld [de], a
	inc de
	ld a, [wCurrentMusicID]
	ld b, a
	call PrintHex
	ld a, c
	ld [de], a
	
	ld de, wFixedTileMap + SCREEN_WIDTH * 13 + 8
	ld a, c
	xor " " ^ $7F
	ld c, a
	ld [de], a
	inc de
	ld a, [wCurrentMusicID]
	ld b, a
	call PrintHex
	ld a, c
	ld [de], a
	
	ldh a, [hPressedButtons]
	or l ; Add in the buttons of the previous frame (since this runs at 30 fps)
	bit 1, a
	jr nz, .end
	bit 5, a
	jr nz, .left
	bit 4, a
	jr nz, .right
	bit 3, a
	jr nz, .fadein
	bit 2, a
	jr nz, .fadeout
	rrca
	jr c, .play
	and (DPAD_UP | DPAD_DOWN) >> 1
	jr z, .mainLoop
	ld a, [wYPos]
	xor 1
	ld [wYPos], a
	jr .mainLoop
	
.end
	jp DS_Stop
	
.left
	ld a, [wYPos]
	and a
	jr nz, .decSFX
	ld hl, wCurrentMusicID
	dec [hl]
	jr .printMusicName
.decSFX
	jr .mainLoop
	
.right
	ld a, [wYPos]
	and a
	jr nz, .incSFX
	ld hl, wCurrentMusicID
	inc [hl]
.printMusicName
	ld hl, wFixedTileMap + SCREEN_WIDTH * 11
	ld c, SCREEN_WIDTH
	xor a
	rst fill ; Clear the song name
	ld bc, BANK(SongNames) << 8 | 2
	ld a, [wCurrentMusicID]
	cp MUSIC_INVALIDTRACK
	ld hl, InvalidSongName
	jr nc, .gotSongName
	add a, a
	add a, LOW(SongNames)
	ld l, a
	adc a, HIGH(SongNames)
	sub l
	ld h, a
	ld de, wTempBuf
	call CopyAcrossLite
	ld hl, wTempBuf
	ld a, [hli]
	ld h, [hl]
	ld l, a
.gotSongName
	ld de, wFixedTileMap + SCREEN_WIDTH * 11
	call CopyStrAcross
	ld a, 1
	ld [wTransferRows + 19], a
	rst waitVBlank
	jp .mainLoop
.incSFX
	jp .mainLoop
	
.fadein
	ld a, MUSICFADE_IN
	call DS_Fade
	jp .mainLoop
	
.fadeout
	ld a, MUSICFADE_OUT
	call DS_Fade
	jp .mainLoop
	
.play
	ld a, [wCurrentMusicID]
	call DS_Init
	jp .mainLoop
	
	
.strings
	dw wFixedTileMap + SCREEN_WIDTH + 2
	dstr "SOUND TEST"
	dw wFixedTileMap + SCREEN_WIDTH * 3 + 1
	dstr "     A - PLAY"
	dw wFixedTileMap + SCREEN_WIDTH * 4 + 1
	dstr "     B - EXIT"
	dw wFixedTileMap + SCREEN_WIDTH * 5 + 1
	dstr " START - FADE IN"
	dw wFixedTileMap + SCREEN_WIDTH * 6 + 1
	dstr "SELECT - FADE OUT"
	dw wFixedTileMap + SCREEN_WIDTH * 10 + 1
	dstr "MUSIC:"
	dw wFixedTileMap + SCREEN_WIDTH * 13 + 3
	dstr "SFX:"
	db 0
	
TilesetViewerMenu::
	ld hl, .strings
.printStrings
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	rst copyStr
	ld a, [hl]
	and a
	jr nz, .printStrings
	
	ld hl, wTransferRows
	ld c, SCREEN_HEIGHT
	inc a ; ld a, 1
	rst fill
	ldh [hTilemapMode], a
	
	ld [rVBK], a
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, $20
	ld [$9E4C], a
	
	xor a
	ld [rVBK], a
	jr .updateTileset
	
.selectTileset
	rst waitVBlank
	ldh a, [hPressedButtons]
	rra
	jr c, .viewTiles
	rra
	ret c
	rra
	rra
	jr c, .viewNPCs
	rra
	jr c, .right
	rra
	jr nc, .selectTileset
	
	ld a, [wLoadedTileset]
	and a
	jr z, .selectTileset
	dec a
	jr .updateTileset
.right
	ld a, [wLoadedTileset]
	inc a
	cp NB_OF_TILESETS
	jr nc, .selectTileset
.updateTileset
	ld [wLoadedTileset], a
	ld b, a
	ld de, wFixedTileMap  + SCREEN_WIDTH * 10 + 13
	call PrintHex
	; Non-zero
	ld [wTransferRows + 18], a
	
.loadTileset
	ld d, $FD
.clearOneBank
	inc d
	jr z, .doneClearingTiles
	ld a, d
	cpl
	ld [rVBK], a
	ld hl, v1Tiles1
	ld bc, 4 * 256
	ld e, $AA
.clearTiles
	rst isVRAMOpen
	jr nz, .clearTiles
	ld a, e
	ld [hli], a
	ld [hli], a
	cpl
	ld e, a
	dec bc
	ld a, b
	or c
	jr nz, .clearTiles
	jr .clearOneBank
.doneClearingTiles
	ld a, [wLoadedTileset]
	call LoadTileset
	jr .selectTileset
	
.viewTiles
	jr TilesetViewerMenu
	
.viewNPCs
	jr TilesetViewerMenu
	
.strings
	dw wFixedTileMap + SCREEN_WIDTH + 2
	dstr "TILESET VIEWER"
	dw wFixedTileMap + SCREEN_WIDTH * 4 + 1
	dstr "     A - VIEW TILES"
	dw wFixedTileMap + SCREEN_WIDTH * 5 + 1
	dstr "     B - EXIT"
	dw wFixedTileMap + SCREEN_WIDTH * 6 + 1
	dstr " START - VIEW NPCS"
	dw wFixedTileMap + SCREEN_WIDTH * 10
	dstr "TILESET ID: ",$7F,"  ",$7F
	db 0
	