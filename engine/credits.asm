
SECTION "Staff credits", ROMX

PlayCredits::
	; Start by fading the screen slowly
	ld a, 8
	ld [wFadeSpeed], a
	callacross Fadeout
	
	; Clear the whole map
	ld a, 1
	ld [rVBK], a
	ld [wTransferSprites], a
	xor a
	ld [wNumOfSprites], a
	ld [wNumOfTileAnims], a ; Also clear all tile animators
	ld hl, vTileMap0
	ld bc, vTileMap1 - vTileMap0
	call FillVRAM
	ld [rVBK], a
	call ClearMovableMap
	ldh [hSCY], a
	ldh [hSCX], a
	ldh [hTilemapMode], a
	
	; Let text appear by loading a palette
	ld de, DefaultPalette
;	ld c, 0
	ld c, a
	callacross LoadBGPalette_Hook
	
	; Display the first few lines
	ld hl, CreditsFirstStrs
	ld de, $98C5
	call CopyStrToVRAM
	ld bc, 120
	call DelayBCFrames
;	ld de, $98E4
	ld e, $E4
	call CopyStrToVRAM
	
	; Display without moving for one second
	ld bc, 60
	call DelayBCFrames
	
	; Start scrolling up
	ld hl, 19
	ld d, 1
	ld b, 0
.scrollDownToStaff
	ld c, l ; Wait c frames (b stays zero)
	call DelayBCFrames
	dec l ; We will wait one less frame next frame
	jr z, .applyCap_ToStaff ; (But we can't wait for less than one)
	dec l
	db $0E ; This will perform a "ld c, $XX" where XX is the hex of "inc l", effectively ignoring it
.applyCap_ToStaff
	inc l
	inc h ; Move by one pixel
	ld a, h
	ldh [hSCY], a
	sub $60 ; The text will be off-screen at this line
	jr nz, .scrollDownToStaff
	
	ld hl, $98C0
	ld c, VRAM_ROW_SIZE * 2
	; xor a
	call FillVRAMLite
	
	
StaffCredits::
	ld de, InvertedPalette + 6
	ld c, 0
	callacross LoadOBJPalette_Hook
	
	; Roll the staff credits
	; The staff credits are done a bit weirdly to work around the OAM size restriction
	; How it's done is :
	; Sprites are arranged in 4 rows of 10 each
	; Sprites are set in 8x16 mode to double the amount of letters available (cool),
	; BUT this requires the bottom tile to follow the top tile in indexes (less cool)
	; So tiles IDs are fixed in OAM, and tiles are copied from the font loaded in VRAM (bank 0)
	; to the tiles used by the sprites.
	; That's why the code is more convoluted than just setting tile indexes in OAM !
	
	ld a, 10 * 4 ; 8 lines (grouped by pairs) of 10 sprites each
	; That's actually the full OAM. Nice.
	ld [wNumOfSprites], a
	
	; Address where the credits are stored
	ld hl, StaffCreditsStrs
	
	ld a, [rLCDC]
	set 2, a ; Set sprites in 8x16 mode to allow displaying a ton of letters
	db $11 ; Skip next read [ld de, $XXYY] to merge them (saves one byte and three cycles)
.nextScreen
	; Hide all until tiles are properly copied
	ld a, [rLCDC]
	res 1, a
	ld [rLCDC], a
	
	xor a
	ldh [hSCY], a
	; First, clear all the sprite's tiles
	; xor a
	push hl ; Save the read addr
	ld hl, v0Tiles0
	ld bc, $A0 * VRAM_TILE_SIZE
	call FillVRAM
	
	; Init OAM
	ld hl, wVirtualOAM
	ld de, $26 ; This will also
	ld b, 4
	ld a, $18 ; First two lines will be more to the left than other
	; a = X pos
	; b = Nb of lines remaining
	; c = Nb of sprites remaining in cur line
	; d = Tile ID
	; e = Y pos
.nextSpriteLine
	ld c, 10
.initSpriteLine
	ld [hl], e
	inc hl
	ld [hli], a
	add a, 8 ; Advance to next sprite (8 pixels wide)
	ld [hl], d
	inc d ; Advance by two tiles
	inc d
	inc hl
	ld [hl], 0
	inc hl
	dec c
	jr nz, .initSpriteLine
	; Advance to next line
	; Skip the unused tiles
	ld a, d
	add a, 32 - 10 * 2
	ld d, a
	; The next X pos can be inferred from the tile ID
	; (This allows offsetting the first line w/o "hacks")
	rrca ; This divides by 2, since it's always even
	add a, $30
	ld e, a
	ld a, $28
	dec b
	jr nz, .nextSpriteLine
	
	ld [wTransferSprites], a
	rst waitVBlank ; Make sure SCY gets applied and sprites are transferred
	
	; b will hold the current line we're on (for the second title line, and then diff even and odd lines)
	ld b, 0
	
	; Remember : we need to copy the corresponding tile from its VRAM slot to the target one
	ld de, v0Tiles0 + VRAM_TILE_SIZE
.initNextTile
	pop hl ; Get back read ptr
.initTiles
	ld a, [hli] ; Read one char
	and a ; String end ?
	jr z, .titleInitDone ; Done.
	; "Print" char
	push hl ; Save read ptr
	swap a ; Get source ptr
	ld l, a
	and $0F
	add a, HIGH(v0Tiles2)
	ld h, a
	ld a, l
	and $F0
	ld l, a
	ld c, VRAM_TILE_SIZE
	call CopyToVRAMLite ; Copy tile from font to title
	ld a, e ; Skip next tile (since we only copy to every other slot)
	add a, VRAM_TILE_SIZE
	ld e, a
	jr nc, .initNextTile ; noCarry
	inc d
	jr .initNextTile
	
	; This is part of the later main loop, but placed here for efficiency
.dontRefreshLine
	dec d
	jr nz, .goDownOnePixel
	jr .goDownOnce
	
.titleInitDone
	inc b
	ld a, b ; Retrieve next line's ID
	dec a ; Line 1 : top title line
	ld de, v0Tiles0
	jr z, .initTiles ; If so, init is *slightly* different
	
	; Line 2+ : any name str
	ld a, b ; Get next line's ID
	rra ; Carry is always clear, so this is /2
	jr nc, .topOfSprite
	ld e, VRAM_TILE_SIZE ; If the line is odd, offset to the other tile IDs (the ones at the bottom of sprites)
.topOfSprite
	add a, a ; [Line ID] AND $FE (since lines are grouped by two)
	add a, HIGH(v0Tiles0) ; ...and a group takes 32 tiles, ie. two rows. This neatly falls in place :)
	ld d, a ; And so the dest pointer is set !
	
	ld a, [hl] ; An empty string terminates the current screen
	and a
	jr nz, .initTiles
	
	push hl ; Save read ptr, because we're gonna use hl a LOT.
	
	; Init background
	ld hl, vTileMap0
	ld bc, VRAM_ROW_SIZE * SCREEN_HEIGHT
	ld a, $A9
	call FillVRAM
	ld de, GrayPalette + 3
	ld c, 0
	callacross LoadBGPalette_Hook
	
	; Set sprites as visible
	ld a, [rLCDC]
	set 1, a
	ld [rLCDC], a
	
	; Wait two whole seconds...
	ld bc, 120
	call DelayBCFrames
	
	; b = Number of pixels until next refresh
	; c = Number of frames to wait until next scroll (negated)
	; d = Number of pixels to scroll on next scroll
	; e has different meanings based on its sign :
	;   If < 0  : number of frames until next line
	;   If >= 0 : number of pixels to scroll next time
	; (This is so the iteration is simply done by incrementing e, and it can be capped at 8)
	ld hl, vTileMap0 ; First row that will go off-screen
	ld e, -8
	ld b, 8
.goDownOnce
	; If e is negative, scroll by one line over several frames
	ld d, 1 ; 1 line,
	ld c, e ; Multiple frames
	bit 7, c ; Check if < 1 lpf (line per frame)
	jr nz, .delayNextPixel
	ld c, $FF ; If not, 1 frame,
	ld a, e ; multiple lines
	and $F8
	rrca ; Divide by 8 to avoid shooting away (this is safe because we're >= 8)
	rrca
	rrca
	ld d, a
.delayNextPixel
	rst waitVBlank
	inc c
	jr nz, .delayNextPixel
	inc e
	jr nz, .goDownOnePixel
	; Skip 0 through 7, as they mean "0 pixels w/ 1-frame delay"
	ld e, 8
.goDownOnePixel
	ldh a, [hSCY]
	inc a ; Scroll down by 1 pixel
	ldh [hSCY], a
	push hl
	ld hl, wVirtualOAM + 1
.scrollSpritesRight
	ld a, [hl]
	cp (SCREEN_WIDTH + 1) * 8
	jr nc, .lock ; Don't scroll sprites right if they are past the right screen edge
	inc [hl]
.lock
	ld a, l
	add a, 4
	ld l, a
	cp 40 * OAM_SPRITE_SIZE + 1
	jr nz, .scrollSpritesRight
	ld [wTransferSprites], a
	pop hl
	dec b ; We scrolled by 1 line
	jr nz, .dontRefreshLine ; If that's not the 8th, don't refresh a line
	
	ld b, d ; Save the value of d
	ld c, VRAM_ROW_SIZE
	xor a
	call FillVRAMLite
	
	ld d, b ; Restore d
	ld b, 8 ; Reset to 8 lines
	
	ldh a, [hSCY]
	cp SCREEN_HEIGHT * TILE_SIZE
	jp c, .dontRefreshLine ; If that's not the end, keep going down
	pop hl
	
	inc hl
	ld a, [hl] ; Check if next byte isn't a zero
	and a
	jp nz, .nextScreen ; If not, then keep going
	
	
	
	; Fade the screen for the final moment
	ld a, 8
	ld [wFadeSpeed], a
	callacross Fadeout
	
	xor a
	ldh [hSCY], a
	ldh [hSCX], a
	
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	
	; Print "thank you for playing"
	ld hl, CreditsThanksStrs
	ld de, $98C3
	call CopyStrToVRAM
;	ld de, $98E3
	ld e, $E3
	call CopyStrToVRAM
	ld de, $9905
	call CopyStrToVRAM
;	ld de, $9924
	ld e, $24
	call CopyStrToVRAM
	
	ld hl, hGFXFlags
	set 6, [hl]
	ld de, InvertedPalette + 3
	ld c, 0
	callacross LoadBGPalette_Hook
	ld hl, hGFXFlags
	res 6, [hl]
	
	; Fade the text in
	ld a, 4
	ld [wFadeSpeed], a
	callacross Fadein
	
	; Set the speed for the next fadeout
	ld a, 16
	ld [wFadeSpeed], a
	; Wait for the player to press A
.finalLoop
	rst waitVBlank
	ldh a, [hPressedButtons]
	and BUTTON_A
	jr z, .finalLoop
	
	; Print a message to tell we'll be back
	ld hl, CreditsFinalStr
	ld de, $99A2
.printFinalStr
	rst waitVBlank
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .printFinalStr
	
	ld bc, 30
	call DelayBCFrames
	; Fade out, then restart the game
	ld a, 2
	ld [wFadeSpeed], a
	callacross Fadeout
	ld a, $11
	jp Start
	
	
CreditsFirstStrs::
	dstr "AEVILIA GB"
	dstr "STAFF CREDITS"
	
	; Format :
	; This is a list of "screens"
	; For each screen :
	;  First two strs are screen's title (bottom line first), may be empty
	;  Then is a list of names (there can be up to 8 of them)
	;  Each line may not exceed 10 characters (not including the final terminator)
	;  The list must be NULL-terminated
	; The list of screens must be NULL-terminated
StaffCreditsStrs::
	dstr "CODING"
	db 0
	dstr "ISSOtm"
	dstr "DevEd"
	db 0
	
	dstr "GRAPHICS"
	dstr "LEAD"
	dstr "Kai"
	db 0
	
	dstr "GRAPHICS"
	db 0
	dstr "Alpha"
	dstr "ISSOtm"
	db 0
	
	dstr "MUSIC"
	db 0
	dstr "DevEd"
	db 0
	
	dstr "MAP DESIGN"
	db 0
	dstr "Parzival"
	dstr "Charmy"
	db 0
	
	dstr "VC SUPPORT"
	db 0
	dstr "Parzival"
	db 0
	
	dstr "CODING"
	dstr "ADDITIONAL"
	dstr "Kai"
	db 0
	
	dstr "THANKS"
	dstr "SPECIAL"
	dstr "beware"
	dstr "Evie"
	dstr "GBDev IRC"
	dstr " & Discord"
	dstr "GCL"
	dstr "Nintendo"
	db 0
	
	db 0
	
CreditsThanksStrs::
	dstr "THE DEV TEAM"
	dstr "WOULD LIKE TO"
	dstr "THANK YOU"
	dstr "FOR PLAYING!"
	
CreditsFinalStr::
	dstr "SEE YOU LATER..."
	
