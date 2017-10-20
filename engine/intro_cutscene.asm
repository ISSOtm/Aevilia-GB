
SECTION "Intro cutscene", ROMX
	
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
	; call ClearMovableMap
	; inc a
	; ld [rVBK], a
	; call ClearMovableMap
	; ld [rVBK], a
	
	; wLargerBuf will house a buffer containing the SCY values
	; 0 1 2 3 4 5 6 7 8 9 (and mirrored)
	; 5 4 3 3 2 2 1 1 . . (and mirrored)
	; wTempBuf is a frame counter
	
	; Init
	xor a
	ld [wTempBuf], a
	
	ld hl, wLargerBuf
	ld c, SCREEN_WIDTH / 2
	rst fill
	
.waitVBlank
	; Wait for VBlank
	ld a, [rLY]
	cp $90
	jr nz, .waitVBlank
	
.loop
	callacross DevSound_Play
	
	; Increment frame counter
	ld hl, wTempBuf
	inc [hl]
	jp z, .done
	ld c, [hl] ; Store it
	
	ld hl, wLargerBuf
	ld de, IntroCutscenePitSpeeds
	ld b, 10
.moveScreen
	ld a, [de]
	inc de
	and a
	rra
	jr nc, .canScroll
	bit 0, c ; Scroll these every other frame
	jr z, .dontScroll
.canScroll
	add [hl]
	ld [hl], a
.dontScroll
	inc hl
	dec b
	jr nz, .moveScreen
	
	
	ld a, $20
	ld [rSTAT], a ; Enable Mode 2 int only
	xor a
	ld [rIF], a ; Clear IE
	ld a, 2
	ld [rIE], a
	halt ; Halt with disabled ints = will wait until an int occur but not exec it (+ a certain bug, but whatever.)
	ld a, 7
.waitVBlankEnd
	dec a
	jr nz, .waitVBlankEnd
	nop
	
	; Perform pit effect
.lineEffect
	ld hl, wLargerBuf
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
	jr z, .loop
	; Add some delay
	ld a, $21
.waitHBlankEnd
	dec a
	jr nz, .waitHBlankEnd
REPT 0
	nop
ENDR
	jr .lineEffect
	
.done
	call SlowDownCPU
	xor a ; Clear interrupts...
	ld [rIF], a
	ld a, 3
	ld [rIE], a
	ei ; Re-enable interrupts
	ret
	
	
IntroCutscenePitSpeeds::
	db $10, $0E, $0C, $0A, $08, $06, $04, $05, $02, $03
	
