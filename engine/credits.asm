
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
	ld hl, StaffCreditsStrs
.doOneStaffCredits
	
	ld de, $9A24
	call CopyStrToVRAM ; Copy role str to VRAM
	
	ld a, e
	and -VRAM_ROW_SIZE
	add VRAM_ROW_SIZE * 2 + 6
	ld e, a
.printStaff
	ld c, e
	call CopyStrToVRAM
	ld a, c
	add VRAM_ROW_SIZE
	ld e, a
	ld a, [hl]
	and a
	jr nz, .printStaff
	
	ld bc, 120
	call DelayBCFrames
	
	push hl
	ld hl, $9980
	ld e, 5
.staff_goDownOneRow
	ld b, 8
.staff_goDownOnePixel
	ld c, e
.staff_delayNextPixel
	rst waitVBlank
	dec c
	jr nz, .staff_delayNextPixel
	ld a, [wSCY]
	inc a
	ld [wSCY], a
	dec b
	jr nz, .staff_goDownOnePixel
	
	ld c, VRAM_ROW_SIZE
	xor a
	call FillVRAMLite
	dec e
	jr nz, .staff_dontCap
	inc e
.staff_dontCap
	ld a, h
	cp $9C
	jr nz, .staff_goDownOneRow
	ld a, $60
	ld [wSCY], a
	pop hl
	
	inc hl
	ld a, [hl]
	and a
	jr nz, .doOneStaffCredits
	
	; Fade the screen for the final moment
	ld a, 8
	ld [wFadeSpeed], a
	callacross Fadeout
	xor a
	ld [wSCY], a
	ld [wSCX], a
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
	dstr "ISSOtm"
	dstr "DevEd"
	db 0
	
	dstr "LEAD GRAPHICS"
	dstr "Kai"
	db 0
	
	dstr "GRAPHICS"
	dstr "Alpha"
	dstr "Mian"
	dstr "Citx"
	dstr "ISSOtm"
	db 0
	
	dstr "MUSIC"
	dstr "DevEd"
	db 0
	
	dstr "MAP DESIGN"
	dstr "Parzival"
	dstr "Charmy"
	dstr "Kai"
	dstr "Citx"
	db 0
	
	dstr "3DS SUPPORT"
	dstr "Parzival"
	db 0
	
	dstr "ADDITIONAL                      PROGRAMMING"
	dstr "Kai"
	db 0
	
	dstr "SPECIAL THANKS"
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
