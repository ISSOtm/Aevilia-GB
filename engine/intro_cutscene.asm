
SECTION "Intro cutscene", ROMX,ALIGN[8] ; So IntroCutscenePitSpeeds is 256-byte aligned
	
IntroCutscenePitSpeeds::
	db 8 << 2
	db 7 << 2 | 2
	db 6 << 2 | 3
	db 5 << 2 | 3
	db 3 << 2
	db 3 << 2 | 1
	db 3 << 2 | 3
	db 2 << 2
	db 2 << 2 | 1
	db 2 << 2 | 2
	
	
; So badass it requires its own ASM func.
; Hell yeah.
IntroCutscene::
	; Part 1 : falling into a pit
	call PitEffect
	
	; Part 2 : designing the next parts
	
	; Reload the map we were in
	call RedrawMap ; Re-draw the map that was overwritten
	callacross ReloadPalettes ; Reload palettes that we blacked out
	callacross PlayerHouse2FLoadBlanket
	jp ProcessNPCs ; And finally, display NPCs again.
	
; Uses the Demotronic trick to make the player "fall" into a Matrix-like pit
PitEffect:
	xor a
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	rst waitVBlank
	di ; Disable interrupts, they get in the way
	call SpeedUpCPU ; The vertical rastersplits require Full CPU Power(tm)
	; Note that switching speeds causes a part of the display to be drawn blank, but this is done on a blank screen
	
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
	rra ; Get 1/4 speed bit
	jr nc, .noQuarterScroll
	; If (c & 3) != 0, don't do 1/4 scroll
	bit 0, c
	jr nz, .noQuarterScroll
	bit 1, c
	jr nz, .noQuarterScroll
	dec a
	dec a
.noQuarterScroll
	and a
	rra ; Get 1/2 speed bit
	jr nc, .noHalfScroll
	bit 0, c ; If (c & 1) != 0, don't do 1/2 scroll
	jr nz, .noHalfScroll
	dec a
.noHalfScroll
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
	
	; Slowing down causes a part of the screen to be white
	; This is avoided by having that happen during VBlank
.waitVBlankBeforeSlowdown
	ld a, [rLY]
	cp $90
	jr nz, .waitVBlankBeforeSlowdown
	call SlowDownCPU
	xor a ; Clear interrupts...
	ld [rIF], a
	ld a, 3
	ld [rIE], a
	ei ; Re-enable interrupts
	ret
