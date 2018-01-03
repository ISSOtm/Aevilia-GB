
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
	inc a ; ld a, 1
	ld [rVBK], a
	ld hl, vFixedMap
	ld bc, SCREEN_HEIGHT * VRAM_ROW_SIZE
	xor a
	call FillVRAM
	ld [rVBK], a
	
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
	
	push bc
	ld de, DefaultPalette
	ld c, a ; ld c, 0
	callacross LoadBGPalette_Hook
	pop bcs
	
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
	xor a
	ld [hl], a ; ld [hl], 0
	ld l, c
	ld h, a ; ld h, 0
	add hl, hl
	ld de, .pointers
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst callHL
	jp .restart
	
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
	call DebugMenuPrintStrings
	
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
	ld [wCurrentSFXID], a
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
	ld a, [wCurrentSFXID]
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
	ld	hl,wCurrentSFXID
	dec	[hl]
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
	ld	hl,wCurrentSFXID
	inc	[hl]
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
	ld a, [wYPos]
	and a
	jr nz, .playSFX
	ld a, [wCurrentMusicID]
	call DS_Init
	jp .mainLoop
.playSFX
	push	bc
	ld	a,[wCurrentSFXID]
	ld	c,a
	callacross	FXHammer_Trig
	pop	bc
	jp	.mainLoop
	
	
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
	xor a
	ld [wYPos + 1], a
	ld [wLoadedTileset], a
	inc a
	ld [wPlayerGender], a
	
.restartNoReset
	xor a
	ld [wNumOfSprites], a
	inc a ; ld a, 1
	ld [wTransferSprites], a
	ld [rVBK], a
	ld hl, vFixedMap
	ld b, SCREEN_HEIGHT
.clearRow
	ld c, SCREEN_WIDTH
	xor a
	call FillVRAMLite
	ld a, l
	add VRAM_ROW_SIZE - SCREEN_WIDTH
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	dec b
	jr nz, .clearRow
	
	xor a
	ld [rVBK], a
	ld hl, wFixedTileMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call Fill
	
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
	
	ld de, wFixedTileMap + SCREEN_WIDTH * 10 + 13
	ld a, [wLoadedTileset]
	ld b, a
	call PrintHex
	ld de, wFixedTileMap + SCREEN_WIDTH * 11 + 13
	ld a, [wYPos + 1]
	ld b, a
	call PrintHex
	
	ld hl, wTransferRows + 8
	ld c, SCREEN_HEIGHT
	ld a, 1
	rst fill
	ldh [hTilemapMode], a
	
	ld [rVBK], a
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, $20
	ld [$9E4C], a
	ld [$9E6C], a
	
.toggleGender
	ld a, [wPlayerGender]
	xor 1
	ld [wPlayerGender], a
	xor a
	ld [rVBK], a
	ld [wYPos], a
	call .loadTileset
	callacross LoadPlayerGraphics
	ld bc, SCREEN_HEIGHT - 2
	call DelayBCFrames ; Wait, otherwise the block redrawn gets overwritten
	call .updateBlockView
	
.selectTileset
	rst waitVBlank
	ldh a, [hPressedButtons]
	rra
	jp c, .viewTiles
	rra
	ret c
	rra
	jr c, .toggleGender
	rra
	jp c, .viewNPCs
	rra
	jr c, .right
	rra
	jr c, .left
	rra
	jr c, .up
	rra
	jr nc, .selectTileset
	
	; down
	ld a, [wYPos]
	and a
	jr nz, .selectTileset
	inc a
	jr .moveCursor
.up
	ld a, [wYPos]
	and a
	jr z, .selectTileset
	dec a
.moveCursor
	ld c, a
	ld d, 0
	ld a, [wYPos]
	call .writeCursor
	ld a, c
	ld [wYPos], a
	ld d, $7F
	call .writeCursor
	jr .selectTileset
	
.left
	ld hl, .mainFunctions
	call .loadAction
	ld a, [de]
	and a
	jr z, .selectTileset
	dec a
	jr .performAction
.right
	ld hl, .mainFunctions
	call .loadAction
	ld a, [de]
	inc a
	cp c
	jr nc, .selectTileset
.performAction
	ld [de], a
	ld c, a
	push hl
	ld a, [wYPos]
	call .getCursorPos
	ld d, h
	ld e, l
	inc de
	ld a, b
	add a, 18
	ld l, a
	ld h, HIGH(wTransferRows)
	ld [hl], a
	ld b, c
	call PrintHex
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst callHL
	jr .selectTileset
	
	
.viewTiles
	ld hl, wFixedTileMap + SCREEN_WIDTH * 3
	ld bc, 2 << 8 | SCREEN_WIDTH
.printBank
	ld a, $80
.printTiles
	ld [hli], a
	dec c
	jr nz, .ok
	ld c, SCREEN_WIDTH
.ok
	inc a
	jr nz, .printTiles
	ld a, l
	add a, c
	ld l, a
	dec b
	jr nz, .printBank
	
	ld hl, wTransferRows + 11
	ld c, 14
	inc a
	rst fill
	
	ld e, 0
	call .tileViewerPrintAttribs
	; xor a
	ld [wXPos], a
	
.viewTilesLoop
	rst waitVBlank
	ldh a, [hPressedButtons]
	bit 1, a
	jp nz, .restartNoReset
	bit 4, a
	jr nz, .tileViewerRight
	bit 5, a
	jr z, .viewTilesLoop
	
	; left
	ld a, [wXPos]
	dec a
	jr .updateTileAttribs
.tileViewerRight
	ld a, [wXPos]
	inc a
.updateTileAttribs
	and $07
	ld [wXPos], a
	ld e, a
	call .tileViewerPrintAttribs
	jr .viewTilesLoop
	
	
.tileViewerPrintAttribs
	ld a, 1
	ld [rVBK], a
	ld hl, vFixedMap + VRAM_ROW_SIZE * 3
	ld d, $80
.printRow
	ld c, SCREEN_WIDTH
.printAttrib
	rst isVRAMOpen
	jr nz, .printAttrib
	ld [hl], e
	inc hl
	dec d
	jr z, .bankEnded
	dec c
	jr nz, .printAttrib
.keepPrinting
	ld a, l
	and -VRAM_ROW_SIZE
	add a, VRAM_ROW_SIZE
	ld l, a
	jr nc, .printRow
	inc h
	jr .printRow
.bankEnded
	ld d, $80
	ld a, e
	xor $08
	ld e, a
	and $08
	jr nz, .keepPrinting
	xor a
	ld [rVBK], a
	ret
	
	
.viewNPCs
	ld hl, wFixedTileMap + SCREEN_WIDTH * 3
	ld bc, SCREEN_WIDTH * (SCREEN_HEIGHT - 3)
	xor a
	call Fill
	ld hl, .NPCStrings
	call DebugMenuPrintStrings
	ld hl, wTransferRows + 8
	ld c, SCREEN_HEIGHT
	inc a ; ld a, 1
	rst fill
	
	ld [rVBK], a
	ld hl, $9E4C
	ld de, VRAM_ROW_SIZE
	ld b, 6
.writeFlipBits
	rst isVRAMOpen
	jr nz, .writeFlipBits
	ld [hl], $20
	add hl, de
	dec b
	jr nz, .writeFlipBits
	xor a
	ld [rVBK], a
	
	ld a, [wYPos]
	ld [wXPos + 1], a
	
	ld hl, wNPC1_ypos
	ld c, 4
	xor a
	rst fill
	ld [wYPos], a
	ld [wLoadedMap], a
	
	ld [wNumOfNPCs], a
	ld [wNPC0_ypos + 1], a
	ld [wNPC0_xpos + 1], a
	ld a, $20
	ld [wNPC0_ypos], a
	ld [wNPC0_xpos], a
	call .loadMapNPCTiles
	call .updateNPCPalettes
	
	ld a, $FF
	ld [wNPC0_steps], a
.toggleWalk
	ld a, [wNPC0_steps]
	cpl
	ld [wNPC0_steps], a
	call ProcessNPCs
	
.NPCMainLoop
	rst waitVBlank
	ldh a, [hPressedButtons]
	bit 0, a
	jr nz, .toggleWalk
	bit 1, a
	jr nz, .restoreAndExit
	rla
	jr c, .npcDown
	rla
	jr c, .npcUp
	rla
	jr c, .npcLeft
	rla
	jr nc, .NPCMainLoop
	
	; right
	ld hl, .NPCFunctions
	call .loadAction
	ld a, [de]
	inc a
	cp c
	jr z, .NPCMainLoop
	jr .performNPCAction
.npcLeft
	ld hl, .NPCFunctions
	call .loadAction
	ld a, [de]
	and a
	jr z, .NPCMainLoop
	dec a
.performNPCAction
	ld [de], a
	ld c, a
	push hl
	ld a, [wYPos]
	call .getCursorPos
	ld d, h
	ld e, l
	inc de
	ld a, b
	add a, 18
	ld l, a
	ld h, HIGH(wTransferRows)
	ld [hl], a
	ld b, c
	call PrintHex
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst callHL
	jr .NPCMainLoop
	
.npcUp
	ld a, [wYPos]
	and a
	jr z, .NPCMainLoop
	dec a
	jr .moveNPCCursor
.npcDown
	ld a, [wYPos]
	inc a
	cp 6
	jr z, .NPCMainLoop
.moveNPCCursor
	ld c, a
	ld d, 0
	ld a, [wYPos]
	call .writeCursor
	ld a, c
	ld [wYPos], a
	ld d, $7F
	call .writeCursor
	jr .NPCMainLoop
	
.restoreAndExit
	ld a, [wXPos + 1]
	ld [wYPos], a
	jp TilesetViewerMenu
	
	
	; Utilitary functions
	
	; Code for moving the cursor around
.getCursorPos
	ld b, a
	add a, a
	add a, a
	add a, b ; *5
	add a, a
	add a, a ; *20
	add a, LOW(wFixedTileMap + SCREEN_WIDTH * 10 + 12)
	ld l, a
	adc a, HIGH(wFixedTileMap + SCREEN_WIDTH * 10 + 12)
	sub l
	ld h, a
	ret
	
	; Sub-func to write d at the position of the arrows for option #a
.writeCursor
	call .getCursorPos
	ld [hl], d
	inc hl
	inc hl
	inc hl
	ld [hl], d
	ld a, b
	add a, 18
	ld l, a
	ld h, HIGH(wTransferRows)
	ld [hl], h ; h is non-zero
	rst waitVBlank
	ret
	
.loadAction
	ld a, [wYPos]
	ld b, a
	add a, a
	add a, a
	add a, b
	add a, l
	ld l, a
	adc a, h
	sub l
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ret
	
	
.mainFunctions
	dw wLoadedTileset
	db NB_OF_TILESETS
	dw .loadTileset
	
	dw wYPos + 1
	db $40
	dw .updateBlockView
	
.loadTileset
	ld hl, v1Tiles1
	call .resetTileBlock
	ld a, [wLoadedTileset]
	call LoadTileset
	callacross ReloadPalettes
	; Fall through because block needs to be redrawn
	
.updateBlockView
	ld a, [wYPos + 1]
	ld de, $9EAD
	jp DrawBlock
	
	
.resetTileBlock
	push hl
	push hl
	ld d, $FD
.clearOneBank
	inc d
	ret z
	ld a, d
	cpl
	ld [rVBK], a
	pop hl
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
	
	
.NPCFunctions
	dw wLoadedMap
	db NB_OF_MAPS
	dw .loadMapNPCTiles
	
	dw wNPC0_sprite
	db $55
	dw ProcessNPCs
	
	dw wNPC1_ypos
	db 8
	dw .updateNPCPalettes
	
	dw wNPC1_ypos + 1
	db 8
	dw .updateNPCPalettes
	
	dw wNPC1_ypos + 2
	db 8
	dw .updateNPCPalettes
	
	dw wNPC1_ypos + 3
	db 8
	dw .updateNPCPalettes
	
.loadMapNPCTiles
	ld hl, v1Tiles0
	call .resetTileBlock
	callacross LoadPlayerGraphics
	
	ld b, BANK(MapROMBanks)
	ld d, b
	ld h, HIGH(MapROMBanks)
	ld a, [wLoadedMap]
	ld e, a
	ld l, a
	call GetByteAcross
	ld c, b ; Bank
	
	ld a, e
	add a, a
	add a, LOW(MapPointers)
	ld l, a
	adc a, HIGH(MapPointers)
	sub l
	ld h, a
	ld b, d
	call GetByteAcross
	inc hl
	ld b, d
	ld d, a ; Low byte
	call GetByteAcross
	
	; c = bank
	; d = low
	; a = high
	ld b, c
	ld h, a
	ld a, d
	add a, 10 ; Skip over header
	ld l, a
	jr nc, .noCarry1
	inc h
.noCarry1
	call GetByteAcross ; Num of interactions
	and a
	jr z, .skippedInteractions
	ld e, b
	inc hl
.skipInteractions
	ld b, c
	call GetByteAcross
	rla
	jr nc, .noDep
	inc hl ; Skip over dependency
	inc hl
.noDep
	ld a, l
	add a, INTERACTION_STRUCT_SIZE + 1 ; Skip over type, too
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
	dec e ; That was one.
	jr nz, .skipInteractions
.skippedInteractions
	ld b, c
	call GetByteAcross ; NPC count
	add a, a
	ret z ; If no NPCs, then nothing to load
	add a, a
	add a, a
	sub b ; Trick : b was already loaded with the original copy of a !
	inc a
	inc a ; Skip nb of NPCs, nb of scripts, ptr (this skips 4 bytes because *2)
	add a, a
	add a, l
	ld l, a
	jr nc, .noCarry3
	inc h
.noCarry3
	ld b, c
	call GetByteAcross ; get tile count
	inc hl
	and a
	ret z ; If no tiles...
	ld de, $80C0
	ld b, a
.loadNPCTiles
	push bc ; Save count and bank
	ld b, c
	call GetByteAcross ; Tile bank
	inc hl
	and a ; Check if bank is zero (special trap)
	jr z, .loadSiblingGfx
	inc hl
	inc hl
	push hl ; Save ptr to next entry
	; Done before pushing de for obvious reasons
	push de
	ld e, a ; Store bank in e
	dec hl
	ld b, c
	call GetByteAcross
	ld d, a ; Store high
	ld b, c
	dec hl
	call GetByteAcross
	ld l, a
	ld h, d
	ld a, e ; bank
	pop de
.loadGfx
	push de
	push af
	ld bc, $C0
	call CopyAcrossToVRAM
	ld a, 1
	ld [rVBK], a
	pop af
	pop de
	ld bc, $C0
	call CopyAcrossToVRAM
	xor a
	ld [rVBK], a
	pop hl
	pop bc
	dec b
	jr nz, .loadNPCTiles
	ret
.loadSiblingGfx
	push hl
	ld a, [wPlayerGender]
	and a
	ld hl, EvieTiles
	ld a, BANK(EvieTiles)
	jr nz, .loadGfx
	ld hl, TomTiles
	jr .loadGfx
	
.updateNPCPalettes
	ld hl, wNPC1_ypos
	ld de, wNPC0_palettes
	ld b, 2
.updatePaletteByte
	ld a, [hli]
	swap a
	or [hl]
	ld [de], a
	inc hl
	inc e ; inc de
	dec b
	jr nz, .updatePaletteByte
	jp ProcessNPCs
	
	
.strings
	dw wFixedTileMap + SCREEN_WIDTH + 2
	dstr "TILESET VIEWER"
	dw wFixedTileMap + SCREEN_WIDTH * 4
	dstr "     A - VIEW TILES"
	dw wFixedTileMap + SCREEN_WIDTH * 5
	dstr "     B - EXIT"
	dw wFixedTileMap + SCREEN_WIDTH * 6
	dstr " START - VIEW NPCS"
	dw wFixedTileMap + SCREEN_WIDTH * 7
	dstr "SELECT - TOGGLE GNDR"
	dw wFixedTileMap + SCREEN_WIDTH * 10
	dstr "TILESET ID: ",$7F,"00",$7F
	dw wFixedTileMap + SCREEN_WIDTH * 11
	dstr "  BLOCK ID:  00 "
	db 0
	
	
.NPCStrings
	dw wFixedTileMap + SCREEN_WIDTH * 10
	dstr "    MAP ID: ",$7F,"00",$7F
	dw wFixedTileMap + SCREEN_WIDTH * 11
	dstr "DISPLAY ID:  00 "
	dw wFixedTileMap + SCREEN_WIDTH * 12
	dstr "PALETTE TL:  00 "
	dw wFixedTileMap + SCREEN_WIDTH * 13
	dstr "PALETTE BL:  00 "
	dw wFixedTileMap + SCREEN_WIDTH * 14
	dstr "PALETTE TR:  00 "
	dw wFixedTileMap + SCREEN_WIDTH * 15
	dstr "PALETTE BR:  00 "
	db 0
	
	
DebugMenuPrintStrings::
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	rst copyStr
	ld a, [hl]
	and a
	jr nz, DebugMenuPrintStrings
	ret
	
