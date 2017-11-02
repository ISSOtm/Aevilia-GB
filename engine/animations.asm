
SECTION "Animation engine", ROMX

; Start animation at c:de
; This will allocate the animation in the earliest slot available
StartAnimation::
	ld hl, wAnimationTable
	ld a, [wActiveAnimations]
	inc a
	ret z ; Return if all animations are used (!!!)
	dec a
.findAnim
	rrca
	jr nc, .foundAnim
REPT 8
	inc l
ENDR
	jr .findAnim
.foundAnim
	ld [hl], $FF ; Init link
	inc hl
	xor a
	ld [hli], a ; Init delay
	ld [hl], c ; Init bank
	inc hl
	ld [hl], e ; Init ptr
	inc hl
	ld [hl], d
	ret
	
PlayAnimations::
	ld hl, wAnimationTable
	ld b, 1
	
.nextAnimation
	ld a, [wActiveAnimations]
	and b ; Check if selected animation is active
	jr z, .skipAnimation
	
.processAnimation
	ld a, [hli] ; Read link ID
	inc a
	jr nz, .skipAnimation ; If it's not $FF, the animation is pending for another one
	ld a, [hli] ; Read wait time
	and a
	jr z, .playFrame
	dec a
	dec l ; hl
	ld [hl], a
	jr .skipAnimation
	
.playFrame
	
.skipAnimation
	ld a, l
	and $F8
	add a, 8
	ld l, a
	jr nz, .animationSkipped
	inc h
.animationSkipped
	sla b ; Shift b left once
	jr nc, .processAnimation ; If we didn't process all animations yet, continue
	ret
	