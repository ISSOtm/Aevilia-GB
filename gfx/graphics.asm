
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
	inc a ; [add a, 2], globally : skip color #0, it's never displayed anyways. Saves a whole loop iteration, huh ?
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
	ld a, 1
	jp LoadBGPalette
	
	
StartMenu::
	rst waitVBlank
	ld a, 1
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
	
	ld a, 1
	ld [rVBK], a
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
	
	
SECTION "Palette data", ROMX,BANK[1]
	
DefaultPalette::
	db $1F, $1F, $1F
GrayPalette::
	db $15, $15, $15 ; These 3 are shared by Default- and GrayPalette
	db $0A, $0A, $0A
	db $00, $00, $00
InvertedPalette::
	db $00, $00, $00 ; Shared with GrayPalette
	db $0A, $0A, $0A
	db $15, $15, $15
DarkTextPalette::
	db $1F, $1F, $1F ; Shared
	db $00, $00, $00
	db $00, $00, $00
	db $00, $00, $00
	
	
; Console palettes for file select screen
ConsolePalettes::
	; Crappy emulator
	db $14, $14, $14
	db $10, $06, $05
	db $00, $00, $00
	
	; 3DS VC
	db $10, $10, $10
	db $00, $00, $12
	db $00, $00, $00
	
	; Decent emulator
	db $14, $14, $14
	db $1F, $1C, $00
	db $00, $00, $00
	
	; GBC
	db $14, $14, $14
	db $1F, $1C, $00
	db $00, $00, $00
	
	; GBA (NYI)
	db $14, $14, $14
	db $07, $04, $0D
	db $00, $00, $00
	
	
CharSelectTextPalette::
	db $1F, $1F, $1F
	db $0A, $0A, $0A
	db $00, $00, $1F
	db $00, $00, $00
CharSelectEviePalette0::
	db $1F, $1F, $1F
	db $1F, $17, $16
	db $1F, $00, $0F
	db $00, $00, $00
CharSelectEviePalette1::
	db $1F, $17, $16
	db $00, $00, $1F
	db $00, $00, $10
	db $1E, $13, $10
CharSelectTomPalette0::
	db $1F, $1F, $1F
	db $1F, $17, $16
	db $08, $02, $02
	db $00, $00, $00
CharSelectTomPalette1::
	db $1F, $17, $16
	db $0C, $1B, $0E
	db $02, $1F, $02
	db $1E, $13, $10
	
	
IntroNPCPalette::
; Test NPC palette
TestNPCPalette::
	db $1F, $1F, $1F
	db $00, $00, $00
	db $00, $00, $00
	
	
EvieDefaultPalette:: ; Sprite palette : 3 colors per horizontal half
	db $1F, $17, $13
	db $1F, $0C, $1A
	db $00, $00, $00
EvieTextboxPalette::
	db $1F, $1F, $1F
	db $0A, $0A, $0A
	db $00, $00, $00
	db $1F, $0C, $1A
	
TomDefaultPalette::
	db $1F, $17, $13
	db $09, $00, $03
	db $00, $00, $00
TomTextboxPalette::
	db $1F, $1F, $1F
	db $0A, $0A, $0A
	db $00, $00, $00
	db $09, $00, $03
	
	
; A few test exterior palettes
	
GrassPalette::
	db $1B, $1B, $11 ; Background
	db $12, $18, $08 ; Green
	db $09, $10, $05 ; Darker green
	db $00, $00, $00 ; Black
	
HousePalette::
	db $1B, $1B, $11 ; Grass color
	db $1F, $11, $0C ; Wall
	db $1B, $0F, $09 ; Brick
	db $00, $00, $00 ; Edges
	
DoorWindowPalette::
	db $1F, $1F, $1F ; Glass
	db $1F, $11, $0C ; Wall
	db $15, $0F, $09 ; Wood
	db $00, $00, $00 ; Edges
	
RoofPalette::
	db $1B, $1B, $11 ; Grass color
	db $08, $0C, $0C ; Light color
	db $08, $0A, $0A ; Darker color
	db $00, $00, $00 ; Edges
	
WaterPalette::
	db $1A, $1F, $1F ; Lighter spots
	db $15, $1E, $1F ; Darker spots
	db $0B, $1A, $1C ; Water fill
	db $00, $00, $00 ; Unused
	
RockPalette::
	db $1F, $1F, $1F
	db $18, $11, $0C
	db $11, $0D, $07
	db $00, $00, $00
	
	
; Test interior palettes

InsideHousePalette::
	db $18, $1B, $18 ; Window
	db $0C, $08, $00 ; Wood
	db $1C, $0C, $00 ; Wall
	db $00, $00, $00 ; Edges
	
TestWarriorTopPalette::
	db $1F, $17, $13
	db $16, $16, $06
	db $00, $00, $00
	
TestWarriorBottomPalette::
	db $1F, $17, $13
	db $1F, $00, $04
	db $00, $00, $00
	
	
; Interior tileset palettes
	
InteriorMainPalette::
	db $1E, $1E, $1D
	db $16, $0F, $09
	db $11, $0B, $09
	db $00, $00, $00
	
	
SECTION "Tile data", ROMX,BANK[1]
	
CursorTile::
	dw $8080, $C0C0, $A0E0, $90F0, $88F8, $D0F0, $A8B8, $1818
	
	
EvieTiles::
	dw $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20, $3F20
	dw $3F29, $171E, $171C, $233F, $1E19, $0F0E, $0F09, $0606
	dw $C0C0, $F030, $F808, $F808, $FC04, $FC04, $FC04, $FC04
	dw $FC94, $E878, $E838, $C4FC, $7898, $F070, $F090, $6060
	
	dw $0303, $0F0C, $1F10, $1F13, $3F24, $3F2B, $3C27, $3A2F
	dw $3A2F, $382F, $1F17, $2D36, $191E, $0F0E, $0F09, $0606
	dw $C0C0, $F030, $F808, $F8C8, $FC24, $FCD4, $3CE4, $5CF4
	dw $5CF4, $1CF4, $F8E8, $B46C, $9878, $F070, $F090, $6060
	
	dw $0303, $0F0C, $1F10, $3F28, $3F28, $373C, $171F, $141F
	dw $111F, $090F, $0707, $0407, $0407, $0302, $0704, $0303
	dw $C0C0, $F030, $F808, $FC04, $FC04, $FC04, $FC04, $FC84
	dw $FC84, $FC04, $FCE4, $B8D8, $50F0, $E020, $E020, $E0E0
	
EvieMovingTiles::
	dw $0000, $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20
	dw $3F20, $3F29, $1F1E, $171F, $151E, $0E0B, $0F09, $0606
	dw $0000, $C0C0, $F030, $F808, $F808, $FC04, $FC04, $FC04
	dw $FC04, $FC94, $F868, $E8F8, $C878, $30F0, $C0C0, $0000
	
	dw $0000, $0303, $0F0C, $1F10, $1F13, $3F24, $3F2B, $3C27
	dw $3A2F, $3A2F, $382F, $1F17, $151E, $0F0A, $0F09, $0606
	dw $0000, $C0C0, $F030, $F808, $F8C8, $FC24, $FCD4, $3CE4
	dw $5CF4, $5CF4, $1CF4, $E8F8, $C878, $B0F0, $C0C0, $0000
	
	dw $0000, $0303, $0F0C, $1F10, $3F28, $3F28, $373C, $171F
	dw $141F, $101F, $090F, $0707, $1D1F, $3C27, $1F13, $0C0C
	dw $0000, $C0C0, $F030, $F808, $FC04, $FC04, $FC04, $FC04
	dw $FC84, $FC84, $FC04, $FCE4, $78B8, $B8E8, $F8C8, $3030
	
TomTiles::
	dw $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20, $3F20
	dw $3F20, $1F1A, $273D, $2F3B, $181F, $0E0F, $0F09, $0606
	dw $C0C0, $FE3E, $FC0C, $F808, $FC04, $FC04, $FC04, $FC04
	dw $FC04, $F858, $E4BC, $F4DC, $18F8, $70F0, $F090, $6060
	
	dw $0303, $7F7C, $3F30, $1F10, $3F20, $3F26, $393F, $2A37
	dw $223F, $181F, $273F, $2D36, $191E, $0F0E, $0F09, $0606
	dw $C0C0, $F030, $F808, $F808, $FC04, $FC64, $9CFC, $54EC
	dw $44FC, $18F8, $E4FC, $B46C, $9878, $F070, $F090, $6060
	
	dw $0303, $0F0C, $1F10, $3F20, $3F28, $171C, $171F, $141F
	dw $101F, $080F, $0707, $0605, $0605, $0302, $0704, $0303
	dw $C0C0, $F030, $F8C8, $FC34, $FC04, $FC04, $FC04, $F888
	dw $F888, $F090, $E0E0, $90F0, $50F0, $E020, $E020, $E0E0
	
TomMovingTiles::
	dw $0000, $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20
	dw $3F20, $3F20, $1F1A, $171D, $0F0B, $080F, $0F09, $0606
	dw $0000, $C0C0, $FE3E, $FC0C, $F808, $FC04, $FC04, $FC04
	dw $FC04, $FC04, $F878, $C8B8, $C8F8, $30F0, $C0C0, $0000
	
	dw $0000, $0303, $7F7C, $3F30, $1F10, $3F20, $3F26, $393F
	dw $2A37, $223F, $181F, $171F, $191E, $1F1E, $0F09, $0606
	dw $0000, $C0C0, $F030, $F808, $F808, $FC04, $FC64, $9CFC
	dw $54EC, $44FC, $38F8, $C8F8, $E858, $70F0, $8080, $0000
	
	dw $0000, $0303, $0F0C, $1F10, $3F20, $3F28, $171C, $171F
	dw $141F, $101F, $080F, $0707, $1D1F, $3C27, $1F13, $0C0C
	dw $0000, $C0C0, $F030, $F8C8, $FC34, $FC04, $FC04, $FC04
	dw $F888, $F888, $F090, $E0E0, $38F8, $B8E8, $F8C8, $3030
	
	
GameTiles:: ; Game Boy tiles, used for the text box
	dw $0F00, $1000, $1007, $1007, $1007, $1007, $1005, $1007
	dw $FF00, $0000, $00FF, $00FF, $0000, $0000, $0000, $0000
	dw $F000, $0800, $08E0, $08E0, $08E0, $08E0, $08E0, $08E0
	
	dw $1007, $1007, $1007, $1007, $1003, $1000, $1100, $1100
	dw $0000, $0000, $0000, $00FF, $00FF, $0000, $8000, $8000
	dw $08E0, $08E0, $08E0, $08E0, $08C0, $0800, $0800, $6800
	
	dw $1700, $1700, $1100, $1100, $1000, $1000, $0800, $0700
	dw $E300, $E300, $8000, $8000, $3600, $0000, $0000, $FF00
	dw $6800, $0800, $0800, $0800, $08E0, $08E0, $10E0, $E000
	
	
ConsoleTiles::
	; Crappy emulator
	dw $0000, $0000, $FFFF, $80FF, $80FF, $80FF, $80FF, $80FF
	dw $80FF, $81FF, $81FF, $80FF, $83FF, $87FC, $87FC, $83FF
	dw $80FF, $FFFF, $0000, $0000, $0000, $0101, $0000, $0000
	
	dw $0000, $0000, $FFFF, $10FF, $08FF, $3CFF, $7EC3, $3CE7
	dw $FFC3, $FF00, $DB36, $FF81, $FF3C, $FF18, $FF00, $FFFF
	dw $00FF, $FFFF, $1818, $1818, $1818, $FFFF, $0000, $0000
	
	dw $0000, $0000, $FFFF, $01FF, $01FF, $01FF, $01FF, $01FF
	dw $01FF, $81FF, $81FF, $01FF, $C1FF, $E13F, $E13F, $C1FF
	dw $01FF, $FFFF, $0000, $0000, $0000, $8080, $0000, $0000
	
	; 3DS VC
	dw $7F7F, $FFFF, $7FFF, $F8FF, $F8FF, $E8FF, $D8FF, $F8FF
	dw $F8FF, $F8FF, $FFFF, $7F40, $FFC0, $E699, $C2BD, $C2BD
	dw $E699, $FE81, $E699, $C2BD, $E798, $FE81, $7F7F, $0000
	
	dw $FFFF, $E7FF, $FFFF, $00FF, $00FF, $00FF, $00FF, $00FF
	dw $00FF, $00FF, $FFFF, $FF00, $FF00, $00FF, $00FF, $00FF
	dw $00FF, $00FF, $00FF, $00FF, $FF00, $24DB, $FFFF, $0000
	
	dw $FEFE, $FFFF, $FEFF, $1FFF, $1FFF, $17FF, $1BFF, $1EFF
	dw $1EFF, $1EFF, $FFFF, $FA06, $FF03, $6799, $7F81, $5BA5
	dw $5BA5, $7F81, $6799, $7F81, $FF01, $7F81, $FEFE, $0000
	
	; Good emulator
	dw $0000, $0000, $FFFF, $80FF, $80FF, $80FF, $80FF, $80FF
	dw $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF
	dw $80FF, $FFFF, $0000, $0000, $0000, $0101, $0000, $0000
	
	dw $0000, $0000, $FFFF, $00FF, $FFFF, $FF81, $FFBD, $E7BD
	dw $E7BD, $FFBD, $FF81, $FFA5, $FFA9, $FF83, $FF85, $7EFF
	dw $00FF, $FFFF, $1818, $1818, $1818, $FFFF, $0000, $0000
	
	dw $0000, $0000, $FFFF, $01FF, $01FF, $01FF, $01FF, $01FF
	dw $01FF, $01FF, $01FF, $01FF, $01FF, $01FF, $01FF, $01FF
	dw $01FF, $FFFF, $0000, $0000, $0000, $8080, $0000, $0000
	
	; GBC
	dw $0707, $0F08, $0F0B, $0F0B, $0F0B, $0F0B, $0F0B, $0F0B
	dw $0F0B, $0F0B, $0F0B, $0F09, $0F08, $0F08, $0F08, $0F09
	dw $0F08, $0F08, $0F08, $0F08, $0F08, $0F08, $0706, $0101
	
	dw $FFFF, $FF00, $FFFF, $FFFF, $00FF, $00FF, $00FF, $00FF
	dw $00FF, $00FF, $FFFF, $FFFF, $FF00, $FF00, $FF81, $FFCD
	dw $FF8C, $FF00, $FF00, $FF00, $FF66, $FF00, $FF00, $FFFF
	
	dw $E0E0, $F010, $F0D0, $F0D0, $F0D0, $F0D0, $F0D0, $F0D0
	dw $F0D0, $F0D0, $F0D0, $F090, $F010, $F010, $F090, $F090
	dw $F010, $F010, $F010, $F010, $F0B0, $F050, $E060, $8080
	
	; GBA
	dw $0000, $0000, $0000, $0000, $0000, $011F, $3F3E, $7F40
	dw $7F41, $7F41, $FF83, $EF93, $C7BB, $EF93, $FB87, $FF83
	dw $FB85, $7F78, $0707, $0000, $0000, $0000, $0000, $0000
	
	dw $0000, $0000, $0000, $0000, $0000, $FFFF, $FF00, $FFFF
	dw $FFFF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $FFFF
	dw $FFFF, $FF00, $FF00, $FFFF, $0000, $0000, $0000, $0000
	
	dw $0000, $0000, $0000, $0000, $0000, $80F8, $FC7C, $FE02
	dw $FE82, $FE82, $FFC1, $FBC5, $EBD5, $EFD1, $FFC1, $FFCF
	dw $FF81, $FE1E, $E0E0, $0000, $0000, $0000, $0000, $0000
	
	
SECTION "Strings and text", ROMX,BANK[1]
	
AeviliaStr::
	dstr "AEVILIA GB"
	
VBAText::
	db "NICE EMULATOR YA GOT"
	db "  RIGHT THAR, MATE! "
	db "                    "
	db "WELL, ACTUALLY IT'S "
	db " A PRETTY BAD ONE.  "
	db "INSTEAD, YOU CAN TRY"
	db "  BGB OR GAMBATTE,  "
	db "OR A REAL GB COLOR. "
	db "    (OR ADVANCE,    "
	db "    IT WORKS TOO)   "
	db "                    "
	db "PRESS A TO DISMISS, "
	db " BUT DON'T BLAME ME "
	db "IF SOMETHING DOESN'T"
	db "  WORK CORRECTLY.   "
	db "                    "
	dstr "           --ISSOTM"
	
GameName::
	dstr "AEVILIA"
	
SaveDestroyed0::
	dstr "SAVE DATA IS"
SaveDestroyed1::
	dstr "DESTROYED !"
SaveDestroyed2::
	dstr "ALL FILES WILL"
SaveDestroyed3::
	dstr "BE DELETED."
SaveDestroyed4::
	dstr "SORRY :/"
	
SaveDestroyedText::
	print_pic GameTiles
	print_name GameName
	print_line SaveDestroyed0
	print_line SaveDestroyed1
	empty_line
	wait_user
	print_line SaveDestroyed2
	print_line SaveDestroyed3
	empty_line
	wait_user
	text_lda_imm 2
	text_sta wNumOfPrintedLines
	print_line SaveDestroyed4
	wait_user
	delay 5
	done
	
FirstTimeLoadingText::
	print_pic GameTiles
	print_name GameName
	print_line .line0
	print_line .line1
	print_line .line2
	wait_user
	clear_box
	print_line .line3
	print_line .line4
	print_line .line5
	wait_user
	print_line .line6
	wait_user
	clear_box
	print_line .line7
	print_line .line8
	wait_user
	clear_box
	print_line .line9
	print_line .line10
	print_line .line11
	wait_user
	clear_box
	print_line .line12
	print_line .line13
	wait_user
	clear_box
	delay 30
	print_line .line14
	wait_user
	done
	
.line0
	db "OH, "
	dstr "IT'S YOUR"
.line1
	dstr "FIRST TIME"
.line2
	dstr "PLAYING ?"
.line3
	db "OKAY,"
	dstr " HERE ARE"
.line4
	dstr "THE CONTROLS"
.line5
	dstr "FOR THE MAIN"
.line6
	dstr "MENU."
.line7
	dstr "UP AND DOWN TO"
.line8
	dstr "SELECT A FILE."
.line9
	dstr "A OR START TO"
.line10
	db "CONFIRM,",0
.line11
	dstr "B TO CANCEL."
.line12
	dstr "USE SELECT FOR"
.line13
	dstr "OPTIONS."
.line14
	dstr "ENJOY!"
	
	
