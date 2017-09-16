
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
	
	rst waitVBlank ; Make sure wSCY gets applied
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
	rst waitVBlank ; Wait for a certain amount of frames
	inc c
	jr nz, .staff_delayNextPixel
	inc e
	jr nz, .staff_goDownOnePixel
	ld e, 8 ; Being < 8 would make a 256-frame wait.
.staff_goDownOnePixel
	ld a, [wSCY]
	inc a ; Scroll down by 1 pixel
	ld [wSCY], a
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
	jr nz, .doOneStaffCredits
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
	
	dstr "3DS & WII U
	dstr "SUPPORT"
	dstr "Parzival"
	db 0
	
	dstr "ADDITIONAL                      PROGRAMMING"
	dstr "Kai"
	db 0
	
	dstr "SPECIAL THANKS"
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
