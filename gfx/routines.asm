
SECTION "Graphic funcs", ROMX[$4000],BANK[1]
	
InitGBPalAndSryScreen::
	ld a, $E4
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	
	ld hl, vFontTiles + $20 * VRAM_TILE_SIZE
	ld de, v0Tiles0 + VRAM_TILE_SIZE
	ld c, VRAM_TILE_SIZE
	rst copy
	
	ld a, %10000001
	ld [rLCDC], a
	
	ld a, 1
	ld [hPreventSoftReset], a ; Soft reset restarts in CGB mode, so prevent it.
	ei
	
	; Leave only game name for 1/3 second
	ld bc, 20
	call DelayBCFrames
	
	; Shake screen a little
	ld a, 2
	ld [wScreenShakeAmplitude], a
	
	ld c, 40
	call DelayBCFrames
	
	xor a
	ld [wScreenShakeAmplitude], a
	
	; Wait a bit before displaying text
	ld c, 20
	call DelayBCFrames
	
	ld hl, SryStr
	ld de, $98E3
	ld bc, 16
	call DelayBCFrames
	rst copyStr
	ld de, $9905
	rst copyStr
	ld de, $9923
	rst copyStr
	ld de, $9943
	call CopyStrToVRAM
	
	ld bc, 600
	call DelayBCFrames
	
	ld b, 0
.scrollDown
	rst waitVBlank
	ldh a, [hFrameCounter]
	and 7
	jr nz, .scrollDown
	inc c
	ld a, c
	ld [wSCY], a
	cp 10
	jr nz, .scrollDown
	
	ld de, $99A5
	call DelayBCFrames ; bc = 10
	rst copyStr
	ld de, $99C2
	rst copyStr
	ld de, $99E2
	rst copyStr
	ld de, $9A02
	call CopyStrToVRAM
	
	ld bc, 60
	call DelayBCFrames
	
	ld de, $9A41
	rst copyStr
	ld hl, wVirtualOAM
	ld a, 18
	ld [hli], a
	rrca
	ld [hli], a
	ld a, 1
	ld [hl], a
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	ldh [hFrameCounter], a
	
	ld a, $94
	ld [wXPos], a ; Will serve as a position marker
	
.lock
	ld a, [rLY]
	cp $80
	jr z, .scroll
	cp $98
	jr nz, .lock
	
	ld a, [hFrameCounter]
	ld b, a
	and $0F
	jr nz, .noScroll
	
	ld a, [wXPos]
	add a, 4
	ld [wXPos], a
	
.noScroll
	ld a, b
	and $20
	jr nz, .lock
	
	ld a, [rLCDC]
	and $FD
	ld [rLCDC], a
	jr .lock
	
.scroll
	ld a, [wXPos]
	ld [rSCX], a
	jr .lock
	
SryStr::
	dstr "YOU CANNOT PLAY"
	dstr "THIS GAME"
	dstr "ON A BLACK AND"
	dstr "WHITE GAME BOY!"
	
	db "LOOK DUDE,", 0 ; Commas within macro agruments don't work well :(
	db "I AM SORRY,"
	dstr " BUT"
	dstr "YOU HAVE TO TURN"
	dstr "THIS CONSOLE OFF!"
	
	dstr "FLICK THE SWITCH!"
	
	
ScoldSpoofers::	
	xor a
	ld [rBGP], a
	
	inc a
	ldh [hPreventSoftReset], a
	ldh [hTilemapMode], a
	
	ld hl, ScoldStr
	ld de, wFixedTileMap + SCREEN_WIDTH
	rst copyStr
	
	inc a
	ld hl, wTransferRows + 8
	ld c, SCREEN_HEIGHT
	rst fill
	
	ld a, $E4
	ld [rBGP], a
	
.waitKey
	rst waitVBlank
	ldh a, [hPressedButtons]
	and a
	jr z, .waitKey
	
	ld a, $E4
	ld [rBGP], a
.lock
	jr .lock
	
ScoldStr::
	db "    HEY HEY HEY!    "
	db "                    "
	db "   YOU, THE TOUGH   "
	db "  GUY RIGHT THERE!  "
	db "   THINK YOU CAN    "
	db " SPOOF ME THAT WAY? "
	db "                    "
	db " Y O U   F O O L  ! "
	db "                    "
	db "   WHEN I SAY YOU   "
	db "  CANNOT PLAY THIS  "
	db "     GAME ON A      "
	db "  BLACK AND WHITE   "
	db "  GB, I'M SERIOUS.  "
	db "                    "
	db " NOW TURN THIS OFF. "
	db 0
	

; Shuts the LCD down
; Destroys a
DisableLCD::
	ld a, [rLCDC]
	and $80 ; Check if LCD is on
	ret z ; Quit if it's not
	
	; Mask LCD
	ld a, [rLCDC]
	and $7F
	
	; Wait until VBlank (REQUIRED)
	rst waitVBlank
	
	; Power LCD down.
	ld [rLCDC], a
	ret
	
; Turns the LCD on
; Destroys a
EnableLCD::
	ld a, [rLCDC]
	and $80
	ret nz ; Return if already on
	
	ld a, [rLCDC]
	or $80
	ld [rLCDC], a
	ret
	
	
; Use this hook the same way as LoadOBJPalette_Hook
LoadBGPalette_Hook::
	ld h, d
	ld l, e
	ld a, c
	
; Initializes BG palete #a (whose ID is a) with the 3*4 bytes at hl (RGB RGB RGB RGB)
; Applies a change to adjust to GBA screen if needed (checking hIsGBA)
; hl points to last byte, zeroes b, a equals last written byte, destroys de and c
LoadBGPalette::
	ld b, a
	add a, a
	add a, a
	ld c, rBGPI & $FF
	jr LoadPalette_Common
	
	
; Use this hook when "callacross"-ing LoadOBJPalette ; put the palette pointer in de instead of hl, and the palette # in c instead of a
LoadOBJPalette_Hook::
	ld h, d
	ld l, e
	ld a, c
	
; Initializes OBJ palette #a with the struct pointed to by hl
; Struct is the same as BG palette, without first 3 color bytes (bcuz transparent, lel)
; Registers are modified the same way, too
LoadOBJPalette::
	ld c, rOBPI & $FF
	ld b, a
	add a, a
	add a, a
	inc a ; [add a, 2], globally : skip color #0, it's never displayed anyways. Saves a whole loop iteration, huh?
LoadPalette_Common:
	add a, a
	or $80 ; Enable auto-increment
	ld [$FF00+c], a
	inc c
	ld d, h
	ld e, l
	push hl
	ld a, [rSVBK]
	push af
	ld a, BANK(wOBJPalettes)
	call SwitchRAMBanks
	ld h, d
	ld l, e
	ld d, wOBJPalettes >> 8
	ld a, b
	add a, a
	add a, b
	add a, a
	add a, a
	ld e, a
	ld b, BG_PALETTE_STRUCT_SIZE
	bit 1, c ; OBPI/D have this bit set
	jr z, .copy
	ld b, OBJ_PALETTE_STRUCT_SIZE ; OBJ palettes have a different size,
	ld a, e ; and are stored in a different array
	add a, (wOBJPalettes & $FF) + 3
	ld e, a
.copy
	ld a, [hli]
	and $1F
	ld [de], a
	inc de
	dec b
	jr nz, .copy
	pop af
	ld [rSVBK], a
	pop hl
	ld b, 3
	bit 1, c
	jr nz, .writeByte
	inc b ; BG palettes need one more color, thus one more loop iteration
.writeByte
	push bc
	call PaletteCommon
	ld [$FF00+c], a
	ld a, e
	ld [$FF00+c], a
	
	pop bc
	dec b
	jr nz, .writeByte
	ret
	
	
; Used to convert a 3-byte raw palette into a 2-byte "mixed" one
PaletteCommon::
	; We need to mix all three colors together, making sure they are all in range $00-$1F
	ld a, [hli]
	and $1F
	ld b, a
	ld a, [hli]
	and $1F
	ld e, a
	ld a, [hli]
	and $1F
	ld d, a
PaletteCommon_Custom: ; Call with colors in b and de
	ldh a, [hGFXFlags]
	bit 7, a
	ld a, b
	jr z, .notGBA
	
	; Adjust all three palettes, using the formula "GBAPal = GBCPal / 2 + $10"
	; Carry is clear from previous "and a"
	rra
	add a, $10
	ld b, a ; Preserve this palette for later recovery
	ld a, e ; Load middle color
	; Carry can't be set
	rra
	add a, $10
	ld e, a
	ld a, d
	; Same
	rra
	add a, $10
	ld d, a
	; Restore
	ld a, b
	
.notGBA
	ld b, a
	ld a, e
	rrca
	rrca
	rrca
	ld e, a
	and $e0
	or b ; Mix R and 3/5 G
	ld b, a
	ld a, e
	and $03
	rl d
	and a ; Clear carry
	rl d
	or d ; Mix 2/5 G and B
	ld e, a
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, b
	ret
	
; Reloads palettes from WRAM
; Use for example after GrayOutPicture
ReloadPalettes::
	ld hl, wBGPalettes
	ld c, rBGPI & $FF - 1
.reloadPaletteSet
	inc c
	ld a, $80 ; Palette 0, color 0, auto-increment
	ld [$FF00+c], a
	inc c
.reloadBGPalettes
	call PaletteCommon
	ld [$FF00+c], a
	ld a, e
	ld [$FF00+c], a
	ld a, l
	cp wOBJPalettes & $FF
	jr z, .reloadPaletteSet
	cp wPalettesEnd & $FF
	jr nz, .reloadBGPalettes
	ret
	
	
TransitionToFixedMap::
	rst waitVBlank ; Make sure we copy stuff before it's displayed
	
	ld a, 1 ; Copy meta-data
	ld [rVBK], a
	call CopyToFixedMap
	xor a ; Copy data
	ld [rVBK], a
	call CopyToFixedMap
	ld a, 1
	ldh [hTilemapMode], a
	ret
	
CopyToFixedMap::
	ld h, vTileMap0 >> 8
	ld a, [wSCY]
	and -TILE_SIZE
	ld [wSCY], a
	add a, a
	jr nc, .noCarry1
	inc h
	inc h
.noCarry1
	add a, a
	jr nc, .noCarry2
	inc h
.noCarry2
	ld l, a
	ld a, [wSCX]
	and -TILE_SIZE
	ld [wSCX], a
	rrca
	rrca
	rrca
	add a, l
	ld l, a
	ld b, SCREEN_HEIGHT
	ld de, vFixedMap
.rowLoop
	ld c, SCREEN_WIDTH
	push hl
	ld a, h
	cp vTileMap1 >> 8
	jr nz, .copyLoop ; No vertical wrap
	ld h, vTileMap0 >> 8
.copyLoop
	rst isVRAMOpen
	jr nz, .copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, l
	and (VRAM_ROW_SIZE - 1)
	jr nz, .noHorizontalWrap
	ld a, l
	sub VRAM_ROW_SIZE
	ld l, a
	jr nc, .noHorizontalWrap
	dec h
.noHorizontalWrap
	dec c
	jr nz, .copyLoop
	pop hl
	ld a, VRAM_ROW_SIZE
	add a, l
	ld l, a
	jr nc, .noCarry4
	inc h
.noCarry4
	ld a, VRAM_ROW_SIZE - SCREEN_WIDTH
	add a, e
	ld e, a
	jr nc, .noCarry5
	inc d
.noCarry5
	dec b
	jr nz, .rowLoop
	ret
	
	
GrayOutPicture::
	ld hl, wBGPalettes
	rst waitVBlank
	ld c, rBGPI & $FF
.palettesLoop
	ld a, $80
	ld [$FF00+c], a
	inc c
	ld b, 8
.loop
	ld d, 4
.oneColor
	ld a, [hli]
	and $1F
	ld e, a
	ld a, [hli]
	and $1F
	add a, e
	ld e, a
	ld a, [hli]
	and $1F
	add a, e
	
	ld e, 0
	cp 3
	jr c, .divEnd
.divideBy3
	inc e
	sub 3
	jr c, .divEnd
	jr nz, .divideBy3
.divEnd
	push de
	ld a, e
	rrca
	rrca
	rrca
	and $E0
	or e
	ld d, a
.waitVRAM1
	rst isVRAMOpen
	jr nz, .waitVRAM1
	ld a, d
	ld [$FF00+c], a
	ld a, e
	rlca
	rlca
	and $7C
	ld d, a
	ld a, e
	and $18
	rrca
	rrca
	rrca
	or d
	ld d, a
.waitVRAM2
	rst isVRAMOpen
	jr nz, .waitVRAM2
	ld a, d
	pop de
	ld [$FF00+c], a
	
	dec d
	jr nz, .oneColor
	dec b
	jr nz, .loop
	
	inc c
	ld a, c
	cp $6C
	jr nz, .palettesLoop
	ret
	
	
Fadeout::
	xor a
	ld [wFadeCount], a
	ld a, [wFadeSpeed]
	add a, a
	jr c, FadeOutToBlack
FadeOutToWhite:
	ld a, [wFadeSpeed]
	and $7F
	jr z, .maxSpeed
	ld b, a
.delayFade
	rst waitVBlank
	dec b
	jr nz, .delayFade
.maxSpeed
	rst waitVBlank
	ld hl, wBGPalettes
	ld c, rBGPI & $FF
.nextPaletteSet
	ld a, $80
	ld [$FF00+c], a
	inc c
	ld b, 4 * 8
.onePalette
	push bc
	ld a, [wFadeCount]
	ld c, a
	ld a, [hli]
	and $1F
	add a, c
	cp $1F
	jr c, .notWhiteB
	ld a, $1F
.notWhiteB
	ld b, a
	ld a, [hli]
	and $1F
	add a, c
	cp $1F
	jr c, .notWhiteE
	ld a, $1F
.notWhiteE
	ld e, a
	ld a, [hli]
	and $1F
	add a, c
	cp $1F
	jr c, .notWhiteD
	ld a, $1F
.notWhiteD
	ld d, a
	call PaletteCommon_Custom
	ld d, a
	pop bc
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, d
	ld [$FF00+c], a
	ld a, e
	ld [$FF00+c], a
	dec b
	jr nz, .onePalette
	inc c
	ld a, c
	cp rOBPI & $FF
	jr z, .nextPaletteSet
	
	ld a, [wFadeCount]
	inc a
	ld [wFadeCount], a
	cp $20
	jr nz, FadeOutToWhite
	ret
	
FadeOutToBlack:
	ld a, [wFadeSpeed]
	and $7F
	jr z, .maxSpeed
	ld b, a
.delayFade
	rst waitVBlank
	dec b
	jr nz, .delayFade
.maxSpeed
	rst waitVBlank
	ld hl, wBGPalettes
	ld c, rBGPI & $FF
.nextPaletteSet
	ld a, $80
	ld [$FF00+c], a
	inc c
	ld b, 4 * 8
.onePalette
	push bc
	ld a, [wFadeCount]
	ld c, a
	ld a, [hli]
	and $1F
	sub c
	jr nc, .notWhiteB
	xor a
.notWhiteB
	ld b, a
	ld a, [hli]
	and $1F
	sub c
	jr nc, .notWhiteE
	xor a
.notWhiteE
	ld e, a
	ld a, [hli]
	and $1F
	sub c
	jr nc, .notWhiteD
	xor a
.notWhiteD
	ld d, a
	call PaletteCommon_Custom
	ld d, a
	pop bc
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, d
	ld [$FF00+c], a
	ld a, e
	ld [$FF00+c], a
	dec b
	jr nz, .onePalette
	inc c
	ld a, c
	cp rOBPI & $FF
	jr z, .nextPaletteSet
	
	ld a, [wFadeCount]
	inc a
	ld [wFadeCount], a
	cp $20
	jr nz, FadeOutToBlack
	ret
	
Fadein::
	ld a, $1F
	ld [wFadeCount], a
	ld a, [wFadeSpeed]
	add a, a
	jr c, FadeInToBlack
FadeInToWhite:
	ld a, [wFadeSpeed]
	and $7F
	jr z, .maxSpeed
	ld b, a
.delayFade
	rst waitVBlank
	dec b
	jr nz, .delayFade
.maxSpeed
	rst waitVBlank
	ld hl, wBGPalettes
	ld c, rBGPI & $FF
.nextPaletteSet
	ld a, $80
	ld [$FF00+c], a
	inc c
	ld b, 4 * 8
.onePalette
	push bc
	ld a, [wFadeCount]
	ld c, a
	ld a, [hli]
	and $1F
	add a, c
	cp $1F
	jr c, .notWhiteB
	ld a, $1F
.notWhiteB
	ld b, a
	ld a, [hli]
	and $1F
	add a, c
	cp $1F
	jr c, .notWhiteE
	ld a, $1F
.notWhiteE
	ld e, a
	ld a, [hli]
	and $1F
	add a, c
	cp $1F
	jr c, .notWhiteD
	ld a, $1F
.notWhiteD
	ld d, a
	call PaletteCommon_Custom
	ld d, a
	pop bc
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, d
	ld [$FF00+c], a
	ld a, e
	ld [$FF00+c], a
	dec b
	jr nz, .onePalette
	inc c
	ld a, c
	cp rOBPI & $FF
	jr z, .nextPaletteSet
	
	ld a, [wFadeCount]
	dec a
	ld [wFadeCount], a
	inc a
	jr nz, FadeInToWhite
	ret
	
FadeInToBlack:
	ld a, [wFadeSpeed]
	and $7F
	jr z, .maxSpeed
	ld b, a
.delayFade
	rst waitVBlank
	dec b
	jr nz, .delayFade
.maxSpeed
	rst waitVBlank
	ld hl, wBGPalettes
	ld c, rBGPI & $FF
.nextPaletteSet
	ld a, $80
	ld [$FF00+c], a
	inc c
	ld b, 4 * 8
.onePalette
	push bc
	ld a, [wFadeCount]
	ld c, a
	ld a, [hli]
	and $1F
	sub c
	jr nc, .notWhiteB
	xor a
.notWhiteB
	ld b, a
	ld a, [hli]
	and $1F
	sub c
	jr nc, .notWhiteE
	xor a
.notWhiteE
	ld e, a
	ld a, [hli]
	and $1F
	sub c
	jr nc, .notWhiteD
	xor a
.notWhiteD
	ld d, a
	call PaletteCommon_Custom
	ld d, a
	pop bc
.waitVRAM
	rst isVRAMOpen
	jr nz, .waitVRAM
	ld a, d
	ld [$FF00+c], a
	ld a, e
	ld [$FF00+c], a
	dec b
	jr nz, .onePalette
	inc c
	ld a, c
	cp rOBPI & $FF
	jr z, .nextPaletteSet
	
	ld a, [wFadeCount]
	dec a
	ld [wFadeCount], a
	inc a
	jr nz, FadeInToBlack
	ret
	
	
; If this isn't a power of two things will probably fail. Hard.
INTERLEAVE_SPEED	equ 8
; Value at which it should end (mov -> fix) or start (fix -> mov)
INTERLEAVE_LAST		equ $C0
	
InterleaveFromMovableToFixed::
	ld hl, rNR51 ; L/R connectors
	xor a
	ld [hl], a ; Mute sound
	ld l, rIE & $FF
	ld b, [hl]
	res 1, [hl]
	xor a
	; e holds max scanline
	ld e, a ; ld e, 0
	; d holds first scanline
	ld d, a ; ld d, 0
	ld [wWY], a
	inc a
	ld [wEnableWindow], a
	ld a, 7
	ld [wWX], a
	rst waitVBlank
.interleaveLoop
	ld l, rLCDC & $FF
	res 1, [hl]
	ld l, rLY & $FF
	ld c, d
.oneScanline
	ld a, c
.waitScanline
	cp [hl]
	jr nz, .waitScanline
	inc c
	ld l, rSTAT & $FF
.waitBlank
	bit 1, [hl]
	jr nz, .waitBlank
	dec l ; hl = rLCDC
	ld a, e
	cp c
	jr c, .windowEnd ; Don't window if past max line
	ld a, c
	rra
	jr nc, .dontWindow ; Don't window if on even line (NB: c is current +1)
	res 1, [hl]
	ld a, 7
	jr .doneWindowing
.windowEnd
	set 1, [hl]
	ld hl, rLCDC
	ld a, $A7
	jr .doneWindowing
.dontWindow
	set 1, [hl]
	ld a, $A6
.doneWindowing
	ld [rWX], a
	ld l, rLY & $FF
	ld a, [hl]
	cp LY_VBLANK - 1
	jr nz, .oneScanline
	ld a, e
	add a, INTERLEAVE_SPEED
	cp INTERLEAVE_LAST
	jr z, .displayFullWindow
	ld e, a
	jr .interleaveLoop
.displayFullWindow
	rst waitVBlank ; Make sure we override VBlank's sprite settings (which is "display")
	ld a, d
	add a, INTERLEAVE_SPEED
	ld d, a
	cp LY_VBLANK
	jr nz, .interleaveLoop
	
	ld l, rIE & $FF
	ld [hl], b
	ld l, rLCDC & $FF
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
	ld l, rIE & $FF
	ld b, [hl]
	res 1, [hl]
	ld de, ((LY_VBLANK - INTERLEAVE_SPEED) << 8) | (INTERLEAVE_LAST - INTERLEAVE_SPEED)
	xor a
	ld [wWY], a
	inc a
	ld [wEnableWindow], a
	ld a, 7
	ld [wWX], a
	rst waitVBlank
.interleaveLoop
	ld c, d
	ld l, rLCDC & $FF
	res 1, [hl]
	ld l, rLY & $FF
.oneScanline
	ld a, c
.waitScanline
	cp [hl]
	jr nz, .waitScanline
	inc c
	ld l, rSTAT & $FF
.waitBlank
	bit 1, [hl]
	jr nz, .waitBlank
	dec l ; hl = rLCDC
	ld a, e
	cp c
	jr c, .windowEnd ; Don't window if past max line
	ld a, c
	rra
	jr nc, .dontWindow ; Don't window if on even line (NB: c is current +1)
	res 1, [hl]
	ld a, 7
	jr .doneWindowing
.windowEnd
	set 1, [hl]
	ld a, $A7
	jr .doneWindowing
.dontWindow
	set 1, [hl]
	ld a, $A6
.doneWindowing
	ld [rWX], a
	ld l, rLY & $FF
	ld a, [hl]
	cp LY_VBLANK - 1
	jr nz, .oneScanline
	ld a, d
	and a
	jr z, .displayPartialWindow
	sub a, INTERLEAVE_SPEED
	ld d, a
	rst waitVBlank ; VBlank re-enables sprites, make sure that doesn't override our sprite settings
	jr .interleaveLoop
.displayPartialWindow
	ld a, e
	sub a, INTERLEAVE_SPEED
	ld e, a
	jr nz, .interleaveLoop
	
	ld [wEnableWindow], a
	ld l, rIE & $FF
	ld [hl], b
	ret
	
LoadPlayerGraphics::
	ld hl, EvieTiles
	ld a, [wPlayerGender]
	and a
	jr z, .loadEvie1
	ld hl, TomTiles
.loadEvie1
	ld de, vPlayerTiles
	ld bc, VRAM_TILE_SIZE * 4 * 3
	call CopyToVRAM
	ld a, 1
	ld [rVBK], a
	ld de, vPlayerWalkingTiles
	ld bc, VRAM_TILE_SIZE * 4 * 3
	call CopyToVRAM
	xor a
	ld [rVBK], a
	
	ld hl, EvieDefaultPalette
	ld a, [wPlayerGender]
	and a
	jr z, .loadEvie2
	ld hl, TomDefaultPalette
	xor a
.loadEvie2
	call LoadOBJPalette
	xor a
	jp LoadBGPalette
	
	
StartMenu::
	rst waitVBlank
	ld a, 1
	ld [rVBK], a
	ld hl, wTransferRows
	ld c, SCREEN_HEIGHT
	rst fill
	xor a
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call Fill
	
	ld hl, StartMenuStrs
	ld de, wTextboxTileMap + SCREEN_WIDTH + 5
	rst copyStr
	ld e, (wTextboxTileMap + SCREEN_WIDTH * 3 + 1) & $FF
	rst copyStr
	ld e, (wTextboxTileMap + SCREEN_WIDTH * 4 + 1) & $FF
	rst copyStr
	ld e, (wTextboxTileMap + SCREEN_WIDTH * 5 + 1) & $FF
	rst copyStr
	ld hl, wTextboxTileMap + SCREEN_WIDTH * 6 + 2
	ld c, SCREEN_WIDTH - 4
	ld a, "_"
	rst fill
	
	xor a
	ld hl, vTileMap1
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
	call InterleaveFromMovableToFixed
	
.mainLoop
	rst waitVBlank
	ldh a, [hPressedButtons]
	rrca
	rrca
	jr c, .saveGame
	rrca
	rrca
	jr nc, .mainLoop
	
.exitMenu
	call ProcessNPCs ; Re-process NPC sprites which we had cleared
	ld a, 1
	ld [SoundEnabled], a
	call InterleaveFromFixedToMovable
	
	; Restore the tilemap
	xor a
	ld hl, wTextboxTileMap + SCREEN_WIDTH * 6
	ld c, SCREEN_WIDTH
	rst fill
	inc a
	ld [wTransferRows + 6], a
	ld [rVBK], a
	ld hl, vTileMap1 + VRAM_ROW_SIZE * 5
	ld c, VRAM_ROW_SIZE + SCREEN_WIDTH
	call FillVRAMLite
	xor a
	ld [rVBK], a
	ret
	
.saveGame
	inc a ; Can't be $FF
	ld [wTransferRows + 14], a
	ld hl, wTextboxTileMap + SCREEN_WIDTH * 14
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
	
	ld d, h
	ld e, l
	ld bc, 30
	call DelayBCFrames
	ld hl, DoneStr
	ld de, wTextboxTileMap + SCREEN_WIDTH * 14 + 3
	rst copyStr
	inc a
	ld [wTransferRows + 14], a
	jr .mainLoop
	
StartMenuStrs::
	dstr "PAUSE MENU"
	dstr "START  : Exit menu"
	dstr "B      : Save"
	dstr "SELECT : Options"
	
