
SECTION "Intro cutscene", ROMX,ALIGN[8] ; So IntroCutscenePitSpeeds is 256-byte aligned
	
IntroCutscenePitSpeeds::
	db $10, $0F, $0D, $0B, $08, $09, $06, $07, $04, $05
	
	
; So badass it requires its own ASM func.
; Hell yeah.
IntroCutscene::
	xor a
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	rst waitVBlank
	di ; Disable interrupts, they get in the way
	call SpeedUpCPU ; The vertical rastersplits require Full CPU Power(tm)
	
	ld de, IntroMatrixPalette
	ld c, 0
	callacross LoadBGPalette_Hook
	call ClearMovableMap
	inc a
	ld [rVBK], a
	call ClearMovableMap
	ld [rVBK], a
	
	; wLargerBuf will house a buffer containing the SCY values
	; 0 1 2 3 4 5 6 7 8 9 (and mirrored)
	; wTempBuf is a frame counter
	
	; Init
	xor a
	ld [wTempBuf], a
	ld a, 3 ; Number of 256-frame cycles that will occur (the first might be incomplete)
	ld [wTempBuf + 1], a
	
	ld hl, wLargerBuf
	ld c, SCREEN_WIDTH / 2
	rst fill
	
	; Setup for HALT that syncs CPU with PPU
	ld a, $20
	ld [rSTAT], a ; Enable Mode 2 int only
	ld a, 2
	ld [rIE], a
	
.waitVBlank
	; Wait for VBlank
	ld a, [rLY]
	cp $90
	jr nz, .waitVBlank
	
.loop
	; Avoid memory-intensive operations, otherwise the effect "hiccups"
	; callacross DevSound_Play
	
	; Increment frame counter
	ld hl, wTempBuf
	dec [hl]
	ld c, [hl] ; Store it
	jr nz, .calcNextFrame
	inc hl
	dec [hl]
	jp z, .done
.calcNextFrame
	
	ld hl, wLargerBuf
	ld de, IntroCutscenePitSpeeds
	ld b, SCREEN_WIDTH / 2
.moveScreen
	ld a, [de]
	inc de
	and a
	rra
	jr nc, .canScroll
	bit 0, c ; Scroll these by half the speed
	jr nz, .canScroll
	dec a ; Done by alternating between this and the lower
.canScroll
	add [hl]
	ld [hli], a
	dec b
	jr nz, .moveScreen
	
	; Update all tiles below those currently rendered
	ld a, [wTempBuf + 1]
	dec a
	jr nz, .randomTiles
	ld a, c ; Frame counter
	cp $68
	jr nc, .randomTiles
	xor a
	ld c, a ; ld c, 0
	jr .gotNextTiles
.randomTiles
	; Pick tiles between $20 and $3F
	call RandInt
	and $1F
	add a, " "
	ld c, a
	ldh a, [hRandIntLow]
	and $1F
	add a, " "
.gotNextTiles
	ld [wTempBuf + 2], a
	ld de, wLargerBuf
	ld b, 0
.updateTiles
	ld h, HIGH(vTileMap0)
	ld a, [de]
	add SCREEN_HEIGHT * 8 ; Go to lower edge
	and $F8 ; Snap on tile boundaries
	add a, 8 ; Make sure to update the tile *below*
	add a, a
	jr nc, .updateTilesNoCarry1
	inc h
	inc h
.updateTilesNoCarry1
	add a, a
	jr nc, .updateTilesNoCarry2
	inc h
.updateTilesNoCarry2
	add a, b
	ld l, a
	ld [hl], c
	sub b
	sub b
	add a, SCREEN_WIDTH - 1
	ld l, a
	ld a, [wTempBuf + 2]
	ld [hl], a
	inc de
	inc b
	ld a, b
	cp SCREEN_WIDTH / 2
	jr nz, .updateTiles
	
	; Wait until first line
	xor a
	ld [rIF], a ; Clear IF
	halt ; Halt with disabled ints = will wait until an int occur but not exec it (+ a certain bug, but whatever.)
	ld a, 7
.waitVBlankEnd
	dec a
	jr nz, .waitVBlankEnd
	nop
	
	; Perform pit effect
.lineEffect
	ld hl, wLargerBuf ; This adds some additional delay. Works fine.
	ld c, LOW(rSCY)
	; The beginning of Mode 3 must land around here
REPT 9
	ld a, [hli]
	ld [c], a
ENDR
	ld a, [hl]
	ld [c], a
REPT 9
	ld a, [hld]
	ld [c], a
ENDR
	ld a, [hl]
	ld [c], a
	
	; We now have some time...
	ld a, [rLY]
	cp $8F
	jp z, .loop
	; Add some delay
	ld a, $20
.waitHBlankEnd
	dec a
	jr nz, .waitHBlankEnd
	nop
	nop
	nop
	jr .lineEffect
	
.done
	call ClearMovableMap
	callacross LoadPlayerGraphics
	ld a, $80
	ld [rBGPI], a
	ld [rOBPI], a
	ld b, 8 * 4 * 2
.blackOut
	rst isVRAMOpen
	jr nz, .blackOut
	xor a
	ld [rBGPD], a
	ld [rOBPD], a
	dec b
	jr nz, .blackOut
	
	call SlowDownCPU
	xor a ; Clear interrupts...
	ld [rIF], a
	ld a, 3
	ld [rIE], a
	ei ; Re-enable interrupts
	
	call ProcessNPCs
	call RedrawMap
	
	ld a, $81
	ld [wFadeSpeed], a
	jp Fadein
