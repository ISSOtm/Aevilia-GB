
SECTION "Animation engine", ROM0

; Start animation at c:de
; This will allocate the animation in the earliest slot available
; Z will be set if the allocation failed (no matter the reason)
StartAnimation::
	; First, check if a free animation slot exists.
	ld a, [wActiveAnimations + 7]
	inc a
	debug_message "%ZERO%FAILED TO ALLOCATE ANIMATION!!;Allocating animation in slot %A%...;"
	ret z ; Return if all animations are used (!!!)
	
	ldh a, [hCurROMBank]
	push af
	ld a, c ; Bankswitch now to free c
	rst bankswitch
	
	; Look for free (ie. unreferenced) slot
	ld b, 0
.lookForSlot
	ld hl, wActiveAnimations
	ld c, 0
.checkInTable
	ld a, [hli]
	inc a
	jr z, .checkedTable
	dec a
	cp b
	jr nz, .checkInTable
	inc b
	inc c ; Sets c to non-zero, since this shouldn't occur 256 times
	jr .checkInTable
.checkedTable
	; a = 0
	or c ; We must repeat until we found a slot that's not in the list
	jr nz, .lookForSlot
	
	ldh a, [hCurROMBank] ; Get back animation's bank
	ld l, a ; Remember it, 'cause we're gonna bankswitch back
	ld a, [de] ; Read nb of sprites
	inc de
	ld c, a ; Remember it for later
	pop af
	rst bankswitch
	ld a, [wNumOfExtendedSprites]
	add a, c ; Calculate total number of sprites
	cp 40 + 1
	jr nc, .spriteOverflow ; If it overflows, don't add the slot to the list
	
	; Add the new slot to the list
	ld a, b
	ld [hli], a
	ld [hl], $FF
	ld b, l ; Transfer animation's bank to another register
	
	dec a
	add a, a ; Get pointer to target slot
	add a, a
	add a, a
	add a, LOW(wAnimationSlots)
	ld l, a
	adc a, HIGH(wAnimationSlots)
	sub l
	ld h, a
	
	; b = Animation's bank
	; c = Nb of sprites
	; de = Ptr to animation
	; hl = Ptr to animation's slot
	
	; Init the slot's data
	ld [hl], $0F ; Init link
	inc l
	xor a
	ld [hli], a ; Init delay
	ld a, b
	ld [hli], a ; Init bank
	ld a, e
	ld [hli], a ; Init ptr
	ld [hl], d
	inc l
	dec de ; Go back to header
	ld a, c ; Get back nb of sprites
	ld [hli], a
	
	; Allocate the sprites in the extended OAM
	ld a, [wNumOfExtendedSprites]
	ld b, a
	ld [hld], a ; Store first sprite's ID
	add a, c ; Add nb of sprites
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
	xor a ; Return with NZ to indicate success
	inc a
	ret
	
.spriteOverflow
	debug_message "FAILED TO ALLOCATE ANIMATION: OAM FULL (Requested %C% sprites\, leading to %A% total.)"
	xor a
	ret
	
	
; End animation in slot b
; Actually more complicated than starting one !
; (But that's because any animation slot may end, whereas starting appends the struct.)
EndAnimation::
	ld hl, wActiveAnimations
.lookForSlot
	ld a, [hli]
	inc a
	debug_message "%ZERO%CANNOT END ANIMATION: NO ANIMATIONS;Ending animation slot %B%...;"
	ret z ; Don't end an animation that doesn't exist
	dec a
	cp b
	jr nz, .lookForSlot
	
.removeSlot
	ld a, [hld]
	ld [hli], a
	inc hl
	inc a
	jr nz, .removeSlot
	
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
	
	; Unlink animations
	ld hl, wAnimation0_linkID
.unlinkStruct
	ld a, [hl]
	and $0F
	cp b
	jr nz, .structNotLinked
	ld a, [hl]
	or $0F
	ld [hl], a
.structNotLinked
	ld a, l
	add a, 8
	ld l, a
	cp LOW(wAnimation7_linkID + 8)
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
	
	ld a, d ; Get ID of first sprite of next anim
	add a, a ; Don't shift OAM...
	jr z, .dontShiftOAM ; ...if there aren't any sprites to be overwritten
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
	ld a, 1
	ld [wTransferSprites], a ; OAM has been updated !!1
	ret
	
	
PlayAnimations::
	ld hl, wActiveAnimations
.playActiveAnims
	ld a, [hli]
	inc a
	ret z ; End if the end of the list was reached
	push hl
	and $07
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimation0_linkID)
	ld l, a
	adc a, HIGH(wAnimation0_linkID)
	sub l
	ld h, a
	
	ld a, [hli] ; Get link ID
	inc a
	and $0F
	jp nz, .skipAnimation
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
	
.endAnim
	call EndAnimation
	pop hl
	dec hl
	jp .playActiveAnims ; The number of animations has changed, so check again.
	
.applyDelay
	dec a
	dec hl
	ld [hl], a
	
.skipAnimation
	pop hl
	jp .playActiveAnims
	
	
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
	dw AnimationMoveSprites
	dw AnimationMoveNPC
	dw AnimationTurnNPC
	dw AnimationSetSpritePos
	dw AnimationSetSpriteTiles
	dw AnimationSetSpriteAttribs
	dw AnimationSetLoopCounter
	dw AnimationDjnz
	
	
AnimationJumpTo::
	ld hl, sp+2 ; Points to saved bank
	ld de, wLargerBuf
	ld a, [de]
	inc de
	ld [hli], a
	inc hl ; Skip over saved counter
	ld a, [de]
	inc de
	ld [hli], a ; Write ptr
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
	jr z, ForceAnimationEnd ; If the animation failed to start, don't do anything else.
	ld hl, sp+3 ; Points to current animation's ID
	ld a, [hl] ; Get current animation's ID
	add a, a
	add a, a
	add a, a
	add a, LOW(wAnimationSlots)
	ld l, a
	adc a, HIGH(wAnimationSlots)
	sub l
	ld h, a ; hl points to current animation's link
	ld de, wActiveAnimations + 7
.lookForSlot
	ld a, [de]
	dec de
	inc a
	jr nz, .lookForSlot
	ld a, [de] ; Get last slot inserted, which must be our anim
	ld c, a
	ld a, [hl]
	and $F0 ; Keep the "locking" bits
	or c
	ld [hl], a
	ld a, 3
	ret
	
	
; Repoints the saved read ptr to a 00
ForceAnimationEnd::
	ld hl, sp+2 ; Saved read ptr
	ld [hl], LOW(NullByte)
	inc hl
	ld [hl], HIGH(NullByte)
	xor a ; Don't move the read ptr afterwards
	ret
	
	
AnimationCallSection::
	ld hl, sp+2
	ld a, [hli] ; Get bank
	ld b, a
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
	ld a, b
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
	ld c, a
	ld a, [hld] ; Dest tile (low)
	swap a
	ld d, a
	and $F0
	ld e, a
	ld a, d
	and $0F
	add a, HIGH(v0Tiles0)
	ld d, a
	ld a, [hld] ; Dest tile (high)
	rra
	jr nc, .noCarry
	ld a, d
	add a, $10
	ld d, a
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
	ld l, a
	adc a, HIGH(wAnimation0_nbOfSprites)
	sub l
	ld h, a ; de points to the animation's number of sprites
	ld a, [hli]
	ld e, a ; Nb of sprites
	ld d, [hl] ; ID of 1st sprite
	
	ld hl, wLargerBuf + 4
	ld a, [hld] ; Length (in sprites)
	and a
	ret z ; Don't try to copy 0 sprites
	ld b, a
	ld a, e
	cp b
	jr nc, .nbOfSpritesValid ; Valid if len <= nb of spr (nb - len >= 0)
	debug_message "TRIED TO COPY TOO MANY SPRITES (%B% > %D%)"
	ld b, e
.nbOfSpritesValid
	ld a, [hld] ; 1st sprite
	add a, d ; Add ID of 1st allocated sprite
	ld d, a ; Save global ID of 1st sprite
	add a, b ; Add len
	cpl
	scf
	adc a, e ; a = e - len = nb of spr - len
	jr nc, .preventOverflow ; Prevent overflow if len > nb of spr (condition is inverted because of ADC instead of CP)
	ld a, d
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
	ld h, a
	call CopyAcrossLite
.preventOverflow
	ld a, 5
	ld [wTransferSprites], a
	ret
	
	
AnimationMoveSprites::
	call GetAnimSpriteInfo
	ld hl, wLargerBuf
	ld a, [hli] ; ID of 1st targeted sprite
	cp b
	jr nc, .preventOverflow
	ld e, a
	ld a, [hl] ; Nb of targeted sprites
	add a, e
	dec a
	cp b ; Check if not going past the limit
	jr nc, .preventOverflow
	ld a, [hli]
	ld b, a
	ld a, [hli] ; Y delta
	ld c, [hl] ; X delta
	ld d, a
	ld a, e
	add a, a
	add a, a
	add a, LOW(wExtendedOAM)
	ld l, a
	adc a, HIGH(wExtendedOAM)
	sub l
	ld h, a
.loop
	ld a, d
	add a, [hl]
	ld [hli], a
	ld a, c
	add a, [hl]
	ld [hli], a
	inc hl
	inc hl
	dec b
	jr nz, .loop
.preventOverflow
	ld a, 4
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
	call GetAnimSpriteInfo
	ld hl, wLargerBuf
	ld a, [hli] ; ID of 1st targeted sprite
	cp b
	jr nc, .preventOverflow
	ld e, a
	ld a, [hl] ; Nb of targeted sprites
	add a, e
	dec a
	cp b ; Check if not going past the limit
	jr nc, .preventOverflow
	ld a, [hli]
	ld b, a
	ld a, e
	add a, a
	add a, a
	add a, LOW(wExtendedOAM)
	ld e, a
	adc a, HIGH(wExtendedOAM)
	sub e
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
	call GetAnimSpriteInfo
	ld hl, wLargerBuf
	ld a, [hli] ; ID of 1st targeted sprite
	cp b
	jr nc, .preventOverflow
	ld e, a
	ld a, [hl] ; Nb of targeted sprites
	add a, e
	dec a
	cp b ; Check if not going past the limit
	jr nc, .preventOverflow
	ld a, [hli]
	ld b, a
	ld a, e
	add a, a
	add a, a
	add a, LOW(wExtendedOAM + 2)
	ld e, a
	adc a, HIGH(wExtendedOAM + 2)
	sub e
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
	call GetAnimSpriteInfo
	ld hl, wLargerBuf
	ld a, [hli] ; ID of 1st targeted sprite
	cp b
	jr nc, .preventOverflow
	ld e, a
	ld a, [hl] ; Nb of targeted sprites
	add a, e
	dec a
	cp b ; Check if not going past the limit
	jr nc, .preventOverflow
	ld a, [hli]
	ld b, a
	ld a, e
	add a, a
	add a, a
	add a, LOW(wExtendedOAM + 3)
	ld e, a
	adc a, HIGH(wExtendedOAM + 3)
	sub e
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
	
	
AnimationSetLoopCounter::
	ld hl, sp+3
	ld a, [hl]
	add a, a
	add a, a
	add a, a
	ld l, a
	ld h, 0
	ld de, wAnimation0_loopCounter
	add hl, de
	ld a, [wLargerBuf]
	ld [hl], a
	ld a, 1
	ret
	
AnimationDjnz::
	ld hl, sp+3
	ld a, [hl]
	add a, a
	add a, a
	add a, a
	ld l, a
	ld h, 0
	ld de, wAnimation0_loopCounter
	add hl, de
	ld a, 1
	dec [hl]
	ret z
	ld a, [wLargerBuf]
	ret
	
	
GetNPCPtrFromAnimID::
	bit 7, a
	jr z, .gotNPCID
	and $07
	ld b, a ; Save offset
	ld hl, sp+1
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
	
	
GetAnimSpriteInfo::
	ld hl, sp+5 ; Compensate for the extra return addr
	ld a, [hl]
	add a, a
	add a, a
	add a, a
	ld l, a
	ld h, 0
	ld de, wAnimation0_nbOfSprites
	add hl, de
	ld a, [hli]
	ld b, a ; Nb of sprites
	ld c, [hl] ; ID of 1st sprite
	ret
	
