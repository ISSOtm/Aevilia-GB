
SECTION "Staff credits", ROMX

PlayCredits::
	; Start by fading the screen slowly
	ld a, 8
	ld [wFadeSpeed], a
	callacross Fadeout
	
	; Clear the whole map
	ld a, 1
	ld [rVBK], a
	ld hl, vTileMap0
	ld bc, vTileMap1 - vTileMap0
	ld [wTransferSprites], a
	xor a
	ld [wNumOfSprites], a
	ld [wNumOfTileAnims], a ; Also clear all tile animators
	call FillVRAM
	ld [rVBK], a
	call ClearMovableMap
	ld [wSCY], a
	ld [wSCX], a
	ldh [hTilemapMode], a
	
	; Let text appear by loading a palette
	ld de, DefaultPalette
;	ld c, 0
	ld c, a
	callacross LoadBGPalette_Hook
	ld de, GrayPalette + 3
	ld c, 0
	callacross LoadOBJPalette_Hook
	
	; Display the first few lines
	ld hl, CreditsFirstStrs
	ld de, $98C5
	call CopyStrToVRAM
	ld bc, 120
	call DelayBCFrames
;	ld de, $98E4
	ld e, $E4
	call CopyStrToVRAM
	
	ld bc, 60
	call DelayBCFrames
	
	ld bc, 19
	ld d, 1
.scrollDownToStaff
	ld e, c
.waitToStaff
	rst waitVBlank
	dec e
	jr nz, .waitToStaff
	dec c
	jr z, .applyCap_ToStaff
	dec c
	dec c
.applyCap_ToStaff
	inc c
	inc b
	ld a, b
	ld [wSCY], a
	cp $60
	jr nz, .scrollDownToStaff
	
	call ClearMovableMap
	
	
	
	; Roll the staff credits
	ld a, [rLCDC]
	set 2, a ; Set sprites in 8x16 mode
	ld [rLCDC], a
	
	ld a, 8 + 4 * 7
	ld [wNumOfSprites], a
	
	ld hl, StaffCreditsStrs
.doOneStaffCredits
	; Hide all until tiles are properly copied
	ld a, [rLCDC]
	res 1, a
	ld [rLCDC], a
	
	; Init OAM
	push hl
	ld hl, wVirtualOAM
	ld de, $26
	ld bc, (5 << 8) | 8
	ld a, $18
.initSpriteLine
	ld [hl], e
	inc hl
	ld [hli], a
	add a, 16
	ld [hl], d
	inc d
	inc d
	inc d
	inc d
	inc hl
	ld [hl], 0
	inc hl
	dec c
	jr nz, .initSpriteLine
	ld a, d
	dec a
	and $F0
	add a, $10
	ld d, a
	rrca
	add a, $30
	ld e, a
	ld a, $28
	ld c, 7
	dec b
	jr nz, .initSpriteLine
	
	; Clear all tiles
	xor a
	ld hl, v0Tiles0
	ld bc, $A00
	call FillVRAM
	ld [wTransferSprites], a
	rst waitVBlank ; Make sure wSCY gets applied
	
	pop hl
	ld de, v0Tiles0 + VRAM_TILE_SIZE
	ld b, 0 ; Current mode
.initTitleTiles
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
	pop hl ; Retrieve read ptr
	ld a, e ; Skip next tile
	add a, VRAM_TILE_SIZE
	ld e, a
	jr nc, .initTitleTiles
	inc d
	jr .initTitleTiles
.titleInitDone
	inc b
	ld a, b ; Retrieve next mode
	dec a ; Mode 1 : top title line
	ld de, v0Tiles0
	jr z, .initTitleTiles
	; Mode 2+ : any name str
	inc a
	rra ; Carry is always clear
	ld e, 0
	jr nc, .topLine
	ld e, VRAM_TILE_SIZE
.topLine
	add a, a
	add a, HIGH(v0Tiles0)
	ld d, a ; $8200 onwards
	ld a, [hl]
	and a
	jr nz, .initTitleTiles
	
	ld a, [rLCDC]
	set 1, a
	ld [rLCDC], a
	
	push hl
	ld c, 120
.delayBetween
	call DelayFrameFlickerSprites
	dec c
	jr nz, .delayBetween
	
	ld hl, $9980
	ld e, -8 ; If < 0 : number of frames beteen lines ; if >= 0 : number of pixels per frame
	ld b, 8 ; Number of pixels until next refresh
.staff_goDownOnce
	ld d, 1 ; 1 line,
	ld c, e ; Multiple frames
	bit 7, c ; Check if < 1 lpf (line per frame)
	jr nz, .staff_delayNextPixel
	ld c, $FF ; If not, 1 frame,
	ld a, e ; multiple lines
	and $F8
	rrca ; Divide by 8 to avoid shooting away (this is safe because we're >= 8)
	rrca
	rrca
	ld d, a
.staff_delayNextPixel
	push hl
	call DelayFrameFlickerSprites ; Wait for a certain amount of frames
	call DelayFrameFlickerSprites ; Make sure all sprites move together
	pop hl
	inc c
	jr nz, .staff_delayNextPixel
	inc e
	jr nz, .staff_goDownOnePixel
	ld e, 8 ; Being < 8 would make a 256-frame wait.
.staff_goDownOnePixel
	ld a, [wSCY]
	inc a ; Scroll down by 1 pixel
	ld [wSCY], a
	push hl
	ld hl, wVirtualOAM + 1
.scrollSpritesRight
	ld a, [hl]
	cp $A9
	jr z, .lock
	inc a
	ld [hl], a
.lock
	ld a, l
	add a, 4
	ld l, a
	cp $A1
	jr nz, .scrollSpritesRight
	pop hl
	dec b ; We scrolled by 1 line
	jr nz, .staff_dontRefreshLine ; If that's not the 8th, don't refresh a line
	
	ld b, d ; Save the value of d
	ld c, VRAM_ROW_SIZE
	xor a
	call FillVRAMLite
	
	ld d, b ; Restore d
	ld b, 8 ; Reset to 8 lines
	
	ld a, h
	cp $9C
	jr nz, .staff_dontRefreshLine ; If that's not the end, keep going down
	ld a, $60
	ld [wSCY], a
	pop hl
	
	inc hl
	ld a, [hl]
	and a
	jp nz, .doOneStaffCredits
	jr .doneStaffCredits
.staff_dontRefreshLine
	dec d
	jr nz, .staff_goDownOnePixel
	jr .staff_goDownOnce
.doneStaffCredits
	
	
	
	; Fade the screen for the final moment
	ld a, 8
	ld [wFadeSpeed], a
	callacross Fadeout
	xor a
	ld [wSCY], a
	ld [wSCX], a
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
	
StaffCreditsStrs::
	dstr "PROGRAMMING"
	db 0
	dstr "ISSOtm"
	dstr "DevEd"
	db 0
	
	dstr "LEAD GRAPHICS"
	db 0
	dstr "Kai"
	db 0
	
	dstr "GRAPHICS"
	db 0
	dstr "Alpha"
	dstr "Mian"
	dstr "Citx"
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
	dstr "Kai"
	dstr "Citx"
	db 0
	
	dstr "SUPPORT"
	dstr "3DS & WII U"
	dstr "Parzival"
	db 0
	
	dstr "PROGRAMMING"
	dstr "ADDITIONAL"
	dstr "Kai"
	db 0
	
	dstr "SPECIAL THANKS"
	db 0
	dstr "Torchickens"
	dstr "GCL"
	dstr "beware"
	dstr "GBDev Discord"
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
	
DelayFrameFlickerSprites::
	push bc
	ld hl, wVirtualOAM + 2
	ld b, 8 + 4 * 7
.toggleOneSprite
	ld a, [hl] ; Get tile ID
	xor 2 ; Toggle
	ld [hld], a
	and 2 ; Check if it's now the RIGHT tile
	ld a, 8
	jr nz, .moveRight
	ld a, -8
.moveRight
	add [hl] ; Add to current pos
	ld [hli], a
	ld a, l
	add a, OAM_SPRITE_SIZE
	ld l, a
	dec b
	jr nz, .toggleOneSprite
	pop bc
	ld [wTransferSprites], a
	rst waitVBlank
	ret
