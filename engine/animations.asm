
SECTION "Animation engine", ROMX

; Start animation at c:de
; This will allocate the animation in the earliest slot available
StartAnimation::
	ld hl, wNumOfAnimations
	ld a, [hl]
	cp 8
	debug_message "%ZERO%FAILED TO ALLOCATE ANIMATION!!;Allocated animation in slot %A%;"
	ret z ; Return if all animations are used (!!!)
	inc a
	ld [hl], a
	ld hl, wAnimationTable
	add a, a
	add a, a
	add a, a
	add a, l
	ld l, a
	jr nc, .foundAnim
	inc h
.foundAnim
	ld [hl], $FF ; Init link
	inc l
	xor a
	ld [hli], a ; Init delay
	ld [hl], c ; Init bank
	inc l
	ld a, e
	add a, 1 ; Skip over header
	ld [hli], a ; Init ptr
	ld [hl], d
	jr nc, .noHeaderCarry
	inc [hl]
.noHeaderCarry
	inc l
	ld b, c
	ld c, l ; swap l and e
	ld l, e
	ld e, c
	ld c, h ; swap h and d
	ld h, d
	ld d, c
	ld c, 1 ; Init the rest
	jp CopyAcrossLite
	
PlayAnimations::
	ld hl, wAnimationTable
	ret
	