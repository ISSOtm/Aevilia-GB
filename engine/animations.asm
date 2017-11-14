
SECTION "Animation engine", ROM0

; Start animation at c:de
; This will allocate the animation in the earliest slot available
StartAnimation::
	; First, check if a free animation slot exists.
	ld hl, wNumOfAnimations
	ld a, [hl]
	cp 8
	debug_message "%ZERO=1%FAILED TO ALLOCATE ANIMATION!!;Allocating animation in slot %A%...;"
	ret z ; Return if all animations are used (!!!)
	inc a
	ld [hl], a ; Increment animation count
	dec a
	add a, a ; Get pointer to target slot
	add a, a
	add a, a
	add a, LOW(wAnimationTable)
	ld l, a
	adc a, HIGH(wAnimationTable)
	sub l
	ld h, a
	; Init the slot's data
	ld [hl], $FF ; Init link
	inc l
	xor a
	ld [hli], a ; Init delay
	ld [hl], c ; Init bank
	inc l
	inc de ; Skip over header
	ld a, e
	ld [hli], a ; Init ptr
	ld [hl], d
	inc l
	dec de ; Go back to header
	ld a, [de] ; Read nb of sprites
	ld [hli], a
	
	; Allocate the sprites in the extended OAM
	ld a, [wNumOfExtendedSprites]
	ld b, a
	ld [hld], a ; Store first sprite's ID
	ld c, [hl]
	add a, c ; Add nb of sprites
	cp 40 + 1
	jr nc, .spriteOverflow
	ld [wNumOfExtendedSprites], a ; Allocate these sprites
	
	; Finally, clear the animation's sprites, since we allocated them.
	ld a, c ; Nb of sprites
	add a, a
	ret z ; If no sprites, don't clear
	add a, a
	ld c, a ; Length
	ld a, b ; ID of first sprite
	add a, a
	add a, a
	add a, LOW(wExtendedOAM)
	ld l, a
	adc a, HIGH(wExtendedOAM)
	sub l
	ld h, a
	xor a
	rst fill
	ret
	
.spriteOverflow
	ld hl, wNumOfAnimations
	dec [hl] ; Cancel allocation
	debug_message "FAILED TO ALLOCATE ANIMATION: OAM FULL (Requested %C% sprites\, leading to %A% total.)"
	ret
	
	
; End animation in slot b
; Actually more complicated than starting one !
; (But that's because any animation slot may end, whereas starting appends the struct.)
EndAnimation::
	ld a, [wNumOfAnimations]
	scf ; Subtract an extra 1, the slot to be freed
	sbc b
	debug_message "%CARRY=1%CANNOT END ANIMATION: SLOT %B% EMPTY;Ending animation slot %B%...;"
	ret c ; Don't end an animation that doesn't exist
	ld e, a ; This is how many animations are after this one
	
	ld hl, wNumOfAnimations
	dec [hl]
	
	ld a, b ; Obtain ptr to target slot's sprite attribs
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimation0_spriteID)
	ld l, a
	adc a, HIGH(wAnimation0_spriteID)
	sub l
	ld h, a
	ld a, [hld]
	ld c, a ; Store ID of first sprite
	ld d, [hl] ; Store length
	
	; At this point :
	; b = ID of slot
	; c = ID of first sprite
	; d = Number of sprites the animation has
	; e = Number of animations after this one
	
	ld a, l ; Get on struct's first byte
	and $F8
	ld l, a
	push hl ; Save this for clearing the struct later on
	; Unlink animations
	ld a, e
	and a
	jr z, .dontUnlinkStructs
.unlinkStruct
	ld a, l
	add a, 8
	ld l, a
	ld a, [hl]
	inc a
	jr z, .structNotLinked
	dec a
	cp b
	jr c, .structNotLinked
	jr nz, .structGonnaBeMoved
	xor a ; ld a, $FF
.structGonnaBeMoved
	dec a
	ld [hl], a
.structNotLinked
	ld a, l
	cp LOW(wAnimation7_linkID)
	jr nz, .unlinkStruct
.dontUnlinkStructs
	
	ld hl, wNumOfExtendedSprites
	ld a, [hl]
	sub d
	ld [hl], a
	jr nc, .numOfSpritesOK
	ld [hl], 0
	debug_message "WARNING: NUMBER OF SPRITES NEGATIVE (%A%) AFTER ENDING ANIMATION!!"
	jr .dontShiftOAM
.numOfSpritesOK
	
	ld a, d
	and a ; Don't shift OAM...
	jr z, .dontShiftOAM ; ...if there aren't any sprites to be overwritten
	ld a, d ; Get ID of first sprite of next anim
	add a, a
	add a, a
	ld l, a
	ld h, 0 ; hl = offset
	ld a, c ; Get ptr to first sprite (dest of copy)
	add a, a
	add a, a
	add a, LOW(wExtendedOAM)
	ld c, a
	adc a, HIGH(wExtendedOAM)
	sub c
	ld b, a ; bc points to first sprite of current anim
	add hl, bc ; hl points to first sprite of next anim
.shiftOAM
	ld a, l
	cp LOW(wExtendedOAM + $A0)
	jr z, .dontShiftOAM
	ld a, [hli]
	ld [bc], a
	inc bc
	jr .shiftOAM
.dontShiftOAM
	
	; Move animation structs after the current one
	pop hl
	ld a, e ; Check how many there are
	and a
	ret z ; It was the last one !
	push hl ; Save ptr to structs that will have to be modified
	push de ; Save nb of sprites & nb of anims to modify
	ld a, e ; Get number of animations to be modified
	add a, a
	add a, a
	add a, a ; Multiply
	ld c, a ; Store length
	ld d, h
	ld e, l ; Current struct will be dest of copy
	ld a, l ; Add length of 1 struct for src of copy
	add a, 8
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	rst copy
	pop de
	pop hl ; Get ptr to first struct that was copied
	ld a, l
	add a, 6
	ld l, a ; Point to ID of first sprite
	ld bc, 8 ; Length of struct
.updateSpriteIDs
	ld a, [hl]
	sub d ; Subtract nb of sprites that the current anim has 
	ld [hl], a
	add hl, bc
	dec e
	jr nz, .updateSpriteIDs
	inc a ; a wasn't $FF... well, normally.
	ld [wTransferSprites], a ; OAM has been updated !!1
	ret
	
	
PlayAnimations::
	ld hl, wAnimationTable
	ret
	