
SECTION "Animation engine", ROM0

; Start animation at c:de
; This will allocate the animation in the earliest slot available
; Z will be set if the allocation failed (no matter the reason)
StartAnimation::
	; First, check if a free animation slot exists.
	ld hl, wNumOfAnimations
	ld a, [hl]
	cp 8
	debug_message "%ZERO%FAILED TO ALLOCATE ANIMATION!!;Allocating animation in slot %A%...;"
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
	jr z, .dontClearSprites ; If no sprites, don't clear
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
.dontClearSprites
	
	ret
	
.spriteOverflow
	ld hl, wNumOfAnimations
	dec [hl] ; Cancel allocation
	debug_message "FAILED TO ALLOCATE ANIMATION: OAM FULL (Requested %C% sprites\, leading to %A% total.)"
	xor a
	ret
	
	
; End animation in slot b
; Actually more complicated than starting one !
; (But that's because any animation slot may end, whereas starting appends the struct.)
EndAnimation::
	ld a, [wNumOfAnimations]
	scf ; Subtract an extra 1, the slot to be freed
	sbc b
	debug_message "%CARRY%CANNOT END ANIMATION: SLOT %B% EMPTY;Ending animation slot %B%...;"
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
	ld a, [wNumOfAnimations]
	and a
	ret z ; Don't do anything if there are no animations
	
	ld b, 0
	ld hl, wAnimationTable
.loop
	ld a, [hli] ; Get link ID
	inc a
	jp nz, .checkLink
	ld a, [hli]
	and a
	jp nz, .applyDelay
	
	; Great, the animation can be processed !
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ldh a, [hCurROMBank]
	push af
	push hl
.processCommand
	ld a, c
	rst bankswitch
	ld a, [de]
	inc de ; We've read the command byte
	cp INVALID_ANIM_COMMAND
	jr nc, .invalidCommand ; Invalid commands immediately terminate the animation
	; The first two commands are implemented a bit differently
	and a
	jr z, .animationEnding
	dec a
	jr z, .beginDelay
	push de ; Save the read ptr
	push bc ; Save counter and source
	ld b, a ; Save the command ID
	; Copy arguments
	ld h, d
	ld l, e
	ld de, wLargerBuf
	ld c, 8
	rst copy
	; Calculate command script and exec it
	ld a, BANK(AnimationCommands)
	rst bankswitch
	ld a, b ; Get command ID
	add a, a ; 2 bytes per animation
	add a, LOW(AnimationCommands - 2) ; Remove 2 bytes
	ld l, a
	adc a, HIGH(AnimationCommands - 2)
	sub l
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst callHL
	pop bc ; Get back counter and bank
	pop de ; Get back read ptr
	ld l, a
	add a, a ; Get bit 7 into carry
	sbc a, a ; If bit 7 was set, make number negative
	ld h, a
	add hl, de ; Add command's length
	ld d, h
	ld e, l ; Move read ptr
	jr .processCommand
.beginDelay
	pop hl
	dec hl
	inc de
	ld a, d ; Write back animation's pointer
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, c
	ld [hld], a
	dec de
	ld a, [de] ; Get delay
	ld [hl], a ; Write to animation's delay
	pop af
	rst bankswitch
	jr .skipAnimation
.invalidCommand
	debug_message "BAD ANIM COMMAND %A%"
.animationEnding
	; We're going to check if the animation has a return pointer in store
	ld a, b
	swap a
	add a, LOW(wAnimationStacks)
	ld l, a
	adc a, HIGH(wAnimationStacks)
	sub l
	ld h, a
	ld a, [hl] ; Check if the stack is empty
	and a
	jr nz, .returnFromSection ; If it's not, return !
	pop hl
	ld de, -5 ; Move back to beginning of animation
	add hl, de
	pop af
	rst bankswitch
	jr .endAnim
.returnFromSection
	dec a
	ld [hli], a
	ld c, a
	add a, a
	add a, c ; *3
	add a, l
	ld l, a
	jr nc, .noReturnCarry
	inc h
.noReturnCarry
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	jp .processCommand
	
.checkLink
	dec a ; The animation is linked
	ld c, a
	ld a, [wNumOfAnimations]
	scf
	sbc c ; Check if link ID is valid (< to nb of anims)
	jr nc, .skipAnimation
	; Failsafe : if the animation is waiting for one that didn't start yet, terminate it.
.endAnim
	push bc
	push hl
	call EndAnimation
	pop hl
	pop bc
	dec hl
	jr .tryProcessAnimation ; The number of animations has changed, so check again.
	
.applyDelay
	dec a
	dec hl
	ld [hl], a
	
.skipAnimation
	ld a, l
	and $F8
	add a, 8
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	inc b
.tryProcessAnimation
	ld a, [wNumOfAnimations]
	scf
	sbc b
	jp nc, .loop
	ret
	
	
SECTION "Animation commands", ROMX
	
; Here's a small piece of doc to understand commands and create new ones :
; A bunch of commands edit stuff on the stack (yep)
; The reason is, the top values are :
; sp+2 -> Read bank
; sp+3 -> Counter (ID of cur anim)
; sp+4 -> Read ptr
	
	
AnimationCommands::
	dw AnimationJumpTo
	dw StartNewAnim
	dw AnimationCall
	dw AnimationCallSection
	dw AnimationCopyTiles
	dw AnimationCopySprites
	dw AnimationMoveNPC
	dw AnimationTurnNPC
	dw AnimationSetSpritePos
	dw AnimationSetSpriteTiles
	dw AnimationSetSpriteAttribs
	
	
AnimationJumpTo::
	ld hl, sp+2 ; Points to saved bank
	ld de, wLargerBuf
	ld a, [de]
	inc de
	ld [hli], a
	inc hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	xor a ; Don't advance the cursor further...
	ret
	
StartNewAnim::
	ld hl, wLargerBuf
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	call StartAnimation
	ld a, 3
	ret ; Also returns
	
AnimationCall::
	call StartNewAnim
	; (This works because both functions return the same byte count ; add a `ld a, X` if this changes)
	jr z, ForceAnimationEnd ; If the animation failed to start, don't do anything else.
	ld hl, sp+3 ; Points to saved counter
	ld a, [hl] ; Get current animation's ID
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimationTable)
	ld l, a
	adc a, HIGH(wAnimationTable)
	sub l
	ld h, a ; hl points to current animation's link
	ld a, [wNumOfAnimations]
	ld [hl], a
	ld a, 3
	ret
	
	
; Repoints the saved read ptr to a 00
ForceAnimationEnd::
	ld hl, sp+4 ; Saved read ptr
	ld [hl], LOW(NullByte)
	inc hl
	ld [hl], HIGH(NullByte)
	xor a ; Don't move the read ptr afterwards
	ret
	
	
AnimationCallSection::
	ld hl, sp+2
	ld a, [hli] ; Get bank
	ld c, a
	ld a, [hli] ; Get anim ID
	swap a
	add a, LOW(wAnimationStacks)
	ld e, a
	adc a, HIGH(wAnimationStacks)
	sub e
	ld d, a
	
	ld a, [de]
	cp 5
	jr nc, .stackFull
	inc a
	ld [de], a
	dec a
	swap a
	add a, e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	
	; Push the entry on the stack
	ld a, c
	ld [de], a
	inc de
	ld a, [hli] ; Get anim ptr
	add a, 3 ; Add this command's length !
	ld [de], a
	inc de
	ld a, [hl]
	adc a, 0
	ld [de], a
	
	; Now, edit the saved data to repoint to called section
	ld de, wLargerBuf + 2
	ld a, [de] ; Ptr
	dec de
	ld [hld], a
	ld a, [de]
	dec de
	ld [hld], a
	dec hl ; Skip anim ID
	ld a, [de]
	ld [hl], a
	
	xor a ; Don't move
	ret
.stackFull
	debug_message "STACK FULL !!"
	ld a, 3
	ret
	
AnimationCopyTiles::
	ld hl, wLargerBuf + 5
	ld a, [hld] ; Len (in tiles)
	swap a
	ld c, a
	ld a, [hld] ; Dest tile (low)
	swap a
	ld e, a
	and $0F
	add a, HIGH(v0Tiles0)
	ld d, a
	ld a, e
	and $F0
	ld e, a
	ld a, [hld] ; Dest tile (high)
	rra
	jr nc, .noCarry
	swap d
	inc d ; This can't overflow (for the best !)
	swap d
.noCarry
	rra
	sbc a, a ; A = -carry (you can check)
	cpl
	inc a ; A = carry
	ld [rVBK], a ; Set VRAM bank
	
	ld a, [hld] ; Bank
	ld b, a
	ld a, [hld]
	ld l, [hl]
	ld h, a
	call TransferTilesAcross
	xor a
	ld [rVBK], a
	ld a, 6
	ret
	
AnimationCopySprites::
	ld hl, sp+3
	ld a, [hl]
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimation0_nbOfSprites)
	ld e, a
	adc a, HIGH(wAnimation0_nbOfSprites)
	sub e
	ld d, a ; de points to the animation's number of sprites
	
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld d, a ; ID of 1st sprite
	ld e, b ; Nb of sprites
	
	ld hl, wLargerBuf + 4
	ld a, [hld]
	ld b, a ; Length (in sprites)
	ld a, d
	cp b
	jr c, .nbOfSpritesValid ; Valid if len < nb of spr
	debug_message "TRIED TO COPY TOO MANY SPRITES (%B% >= %D%)"
	ld b, d
.nbOfSpritesValid
	ld a, d
	add a, e
	ld c, a ; Max spr ID
	ld a, [hld] ; 1st sprite
	and a
	ret z ; Don't try to copy 0 sprites
	add a, b
	cp c
	jr nc, .preventOverflow ; Prevent overflow if trying to copy past last sprite
	sub b ; Get back 1st sprite
	add a, d ; Add ID of 1st allocated sprite
	add a, a
	add a, a
	add a, LOW(wExtendedOAM)
	ld e, a
	adc a, HIGH(wExtendedOAM)
	sub e
	ld d, a
	ld a, b
	add a, a
	add a, a
	ld c, a
	ld a, [hld] ; Bank
	ld b, a
	ld a, [hld]
	ld l, [hl]
	ld a, h
	call CopyAcrossLite
.preventOverflow
	ld a, 5
	ld [wTransferSprites], a
	ret
	
	
AnimationMoveNPC::
	ld de, wLargerBuf
	ld a, [de]
	inc de
	call GetNPCPtrFromAnimID
	ld a, [de]
	inc de
	bit 7, a
	jr z, .moveDown
	cpl
	inc a ; Negate
	ld b, a ; Save
	ld a, [hl]
	sub b
	ld [hli], a
	jr nc, .movedVert
	dec [hl]
	jr .movedVert
.moveDown
	add a, [hl]
	ld [hli], a
	jr nc, .movedVert
	inc [hl]
.movedVert
	inc hl
	ld a, [de]
	bit 7, a
	jr z, .moveRight
	cpl
	inc a
	ld b, a
	ld a, [hl]
	sub b
	ld [hli], a
	jr nc, .movedHoriz
	dec [hl]
	jr .movedHoriz
.moveRight
	add a, [hl]
	ld [hli], a
	jr nc, .movedHoriz
	inc [hl]
.movedHoriz
	
	ld a, 3
	ret
	
	
AnimationTurnNPC::
	ld de, wLargerBuf
	ld a, [de]
	inc de
	call GetNPCPtrFromAnimID
	ld a, [de]
	ld de, wNPC1_sprite - wNPC1_ypos
	add hl, de ; hl now points to the NPC's sprite ID & direction
	ld d, 3
	bit 7, a
	jr z, .justTurn
	ld d, $7C ; Instead, just modify the NPC's sprite
.justTurn
	and d ; Get only the targeted bits
	ld e, a
	ld a, d
	cpl ; Keep all the unchanged bits
	and [hl]
	or e
	ld [hl], a
	
	ld a, 2
	ret
	
	
AnimationSetSpritePos::
	ld hl, sp+3
	ld a, [hl]
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimation0_nbOfSprites)
	ld l, a
	adc a, HIGH(wAnimation0_nbOfSprites)
	sub l
	ld h, a
	ld a, [hli]
	ld b, a ; Nb of sprites
	ld c, [hl] ; ID of 1st sprite
	ld hl, wLargerBuf
	ld a, [hli] ; ID of 1st targeted sprite
	cp b
	jr nc, .preventOverflow
	ld e, a ; ID of 1st targeted sprite
	ld a, [hli]
	ld b, a ; Nb of targeted sprites
	add a, e
	cp c ; Check if not going past the limit
	jr nc, .preventOverflow
	ld a, e
	add a, a
	add a, a
	add a, LOW(wExtendedOAM)
	ld e, a
	adc a, HIGH(wExtendedOAM)
	sub l
	ld d, a
	ld a, [hli] ; Y pos
	ld l, [hl] ; X pos
.loop
	ld [de], a
	inc de
	ld h, a
	ld a, l
	ld [de], a
	add a, 8
	ld l, a
REPT 3
	inc de
ENDR
	ld a, h
	dec b
	jr nz, .loop
.preventOverflow
	ld a, 4
	ld [wTransferSprites], a
	ret
	
	
AnimationSetSpriteTiles::
	ld hl, sp+3
	ld a, [hl]
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimation0_nbOfSprites)
	ld l, a
	adc a, HIGH(wAnimation0_nbOfSprites)
	sub l
	ld h, a
	ld a, [hli]
	ld b, a ; Nb of sprites
	ld c, [hl] ; ID of 1st sprite
	ld hl, wLargerBuf
	ld a, [hli] ; ID of 1st targeted sprite
	cp b
	jr nc, .preventOverflow
	ld e, a ; ID of 1st targeted sprite
	ld a, [hli]
	ld b, a ; Nb of targeted sprites
	add a, e
	cp c ; Check if not going past the limit
	jr nc, .preventOverflow
	ld a, e
	add a, a
	add a, a
	add a, LOW(wExtendedOAM + 2)
	ld e, a
	adc a, HIGH(wExtendedOAM + 2)
	sub l
	ld d, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
.loop
	ld a, h
	ld [de], a
	add a, l
	ld h, a
REPT 4
	inc de
ENDR
	dec b
	jr nz, .loop
.preventOverflow
	ld a, 4
	ld [wTransferSprites], a
	ret
	
	
AnimationSetSpriteAttribs::
	ld hl, sp+3
	ld a, [hl]
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimation0_nbOfSprites)
	ld l, a
	adc a, HIGH(wAnimation0_nbOfSprites)
	sub l
	ld h, a
	ld a, [hli]
	ld b, a ; Nb of sprites
	ld c, [hl] ; ID of 1st sprite
	ld hl, wLargerBuf
	ld a, [hli] ; ID of 1st targeted sprite
	cp b
	jr nc, .preventOverflow
	ld e, a ; ID of 1st targeted sprite
	ld a, [hli]
	ld b, a ; Nb of targeted sprites
	add a, e
	cp c ; Check if not going past the limit
	jr nc, .preventOverflow
	ld a, e
	add a, a
	add a, a
	add a, LOW(wExtendedOAM + 3)
	ld e, a
	adc a, HIGH(wExtendedOAM + 3)
	sub l
	ld d, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
.loop
	ld a, h
	ld [de], a
	xor l
	ld h, a
REPT 4
	inc de
ENDR
	dec b
	jr nz, .loop
.preventOverflow
	ld a, 4
	ld [wTransferSprites], a
	ret
	
	
GetNPCPtrFromAnimID::
	bit 7, a
	jr z, .gotNPCID
	and $07
	ld b, a ; Save offset
	ld hl, sp+3
	ld a, [hl]
	add a, LOW(wAnimationTargetNPCs)
	ld l, a
	adc a, HIGH(wAnimationTargetNPCs)
	sub l
	ld h, a
	ld a, [hl] ; Get base ID
	add a, b ; Add specified offset
.gotNPCID
	and $07 ; Cap to avoid OOB writes
	swap a
	add a, LOW(wNPC1_ypos)
	ld l, a
	ld h, HIGH(wNPC1_ypos)
	ret
	