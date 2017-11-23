
SECTION "Thread 2 pointers and functions", ROMX
	
Thread2Ptrs::
	dw LoadingWalk
	dw LoadingWalkUp
	dw LoadingWalkDown
	dw LoadingWalkLeft
	dw LoadingWalkRight
	dw AfterLoadingWalkUp
	dw AfterLoadingWalkDown
	dw AfterLoadingWalkLeft
	dw AfterLoadingWalkRight
	dw OpenDoorMovement
	dw OpenDoorAnim
	dw LoadingStairsUp
	dw LoadingStairsUpLeft
	dw LoadingStairsUpRight
	dw LoadingStairsDown
	dw LoadingStairsDownLeft
	dw LoadingStairsDownRight
	dw ScrollClouds
	
	
AfterLoadingWalkUp::
	xor a ; ld a, DIR_UP
	jr AfterLoadingFirstWalk
	
AfterLoadingWalkDown::
	ld a, DIR_DOWN
	jr AfterLoadingFirstWalk
	
AfterLoadingWalkLeft::
	ld a, DIR_LEFT
	jr AfterLoadingFirstWalk
	
AfterLoadingWalkRight::
	ld a, DIR_RIGHT
	; Slide
	
AfterLoadingFirstWalk:
	ldh [hLoadingWalkDirection], a
	ld b, a
	
	ld a, [wFadeCount]
	cp $1F
	ret nz ; Wait until the fade has started
	
	ld a, [wFadeSpeed]
	and $7F ; Ignore color bit
	ld c, a
	inc a
	swap a ; Multiply by 16
	ld l, a
	and $0F
	ld h, a
	ld a, l
	and $F0
	ld l, a
	add hl, hl ; hl = (fade speed + 1) * $20 = nb of frames fade will take
	ld a, l
	sub c
	ld l, a
	jr nc, .noCarry
	dec h
.noCarry ; hl = (fade speed + 1) * $1F = number of pixels the player will move, total
	dec hl ; Account for the one frame of delay
	; (Preserves b)
	
	; First frame, offset player so it lands at the warp-to after the after-loading movement
	ld a, b
	ld [wPlayerDir], a
	ld bc, wYPos
	bit 1, a
	jr z, .moveVertically
	inc bc
	inc bc
.moveVertically
	rrca
	jr nc, .moveNegatively
	ld a, l ; Compensate movement :
	cpl ; if moving positively,
	ld l, a ; compensate with a negative offset.
	ld a, h ; The current offset is positive,
	cpl ; so we must negate it.
	ld h, a
	inc hl
.moveNegatively
	ld a, [bc] ; Get coord in de
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	add hl, de ; Apply offset
	ld a, h ; Write back
	ld [bc], a
	dec bc
	ld a, l
	ld [bc], a
	
	xor a
	ldh [hLoadingFinalCount], a
	
	; Start the actual movement
	ld a, THREAD2_LOADINGWALK
	ldh [hThread2ID], a
	ret ; Delay by 1 frame to avoid a sprite count conflict that causes a graphical issue
	
	
LoadingWalkUp::
	ld b, DIR_UP
	jr LoadingFirstWalk
	
LoadingWalkDown::
	ld b, DIR_DOWN
	jr LoadingFirstWalk
	
LoadingWalkLeft::
	ld b, DIR_LEFT
	jr LoadingFirstWalk
	
LoadingWalkRight::
	ld b, DIR_RIGHT
	
LoadingFirstWalk:
	ld a, $20
	ldh [hLoadingFinalCount], a
	ld a, b
	ldh [hLoadingWalkDirection], a
LoadingWalks_CommonFirst:
	ld [wPlayerDir], a
	ld a, THREAD2_LOADINGWALK
	ldh [hThread2ID], a
	
LoadingWalk::
	ldh a, [hLoadingFinalCount]
	ld b, a
	ld a, [wFadeCount]
	sub b
	jr nz, .dontTerminate
	ldh [hThread2ID], a
.dontTerminate
	ldh a, [hLoadingWalkDirection]
	ld hl, wYPos
	bit 1, a
	jr z, .moveVertically
	inc hl
	inc hl
.moveVertically
	rrca
	ld e, [hl]
	inc hl
	ld d, [hl]
	jr c, .movePositively
	dec de
	dec de
.movePositively
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	call MoveNPC0ToPlayer
	ld hl, wNPC0_steps
	dec [hl]
	jp ProcessNPCs
	
	
OpenDoorMovement::
	ld hl, wXPos
	ld a, [hli]
	ld d, [hl]
	ld e, a ; Get current X position in de
	
	add a, 8
	ld h, d
	jr nc, .noCarry
	inc h
.noCarry
	and $F0
	cpl
	ld l, a ; Got target X position in hl
	ld a, h
	cpl
	ld h, a
	inc hl ; Negate target pos
	
	add hl, de ; Get offset (target - current)
	ld a, h
	or l
	
	ld a, 1
	ld [rSVBK], a
	jr nz, .move
	
	ld [wNPC0_steps], a ; Make sure the player doesn't get stuck in his walking animation
	ld a, THREAD2_OPENDOORANIMATION
	ldh [hThread2ID], a
	ld a, -3 ; Wait a few frames after this
	ldh [hLoadingDoorAnimCount], a
	xor a ; ld a, DIR_UP
	jr .doneMoving
	
.move
	bit 7, h
	jr nz, .moveRight
	dec de
	ld a, DIR_LEFT
	jr .doneMoving
	
.moveRight
	inc de
	ld a, DIR_RIGHT
	
.doneMoving
	ld [wPlayerDir], a
	ld hl, wXPos
	ld [hl], e
	inc hl
	ld [hl], d
	call MoveNPC0ToPlayer
	ld hl, wNPC0_steps
	dec [hl]
	jp ProcessNPCs
	
OpenDoorAnim::
	ldh a, [hLoadingDoorAnimCount]
	rlca
	ld c, a ; If no carry, then this is essentially `add a, a`
	jr nc, .playAnim
	
	; Add a short delay
	rrca
	inc a
	ldh [hLoadingDoorAnimCount], a
	ret
	
.playAnim
	ldh a, [hFrameCounter]
	and $03
	ret nz ; Slow the animation down to 30fps
	
	ld a, 1
	ld [rSVBK], a
	
	call GetPlayerTopLeftPtr
	ld h, d
	ld l, e
	ld a, c ; Get back anim count
;	add a, a ; Already done by `rlca`
	add a, a ; 4 tiles per frame
	add a, OPEN_DOOR_FIRST_TILE
	ld b, a
	call .drawTile
	inc hl
	inc b
	call .drawTile
	ld de, VRAM_ROW_SIZE
	add hl, de
	inc b
	call .drawTile
	dec hl
	inc b
	call .drawTile
	
	ldh a, [hLoadingDoorAnimCount]
	inc a
	ldh [hLoadingDoorAnimCount], a
	sub 7
	ret nz
	ldh [hThread2ID], a
	ret
	
.drawTile
	ld a, [rSTAT]
	and 2
	jr nz, .drawTile
	ld [hl], b
	ret
	
	
UP_STAIRS_Y_COORD	equ $10
	
LoadingStairsUpLeft::
	ld hl, wNPC0_steps
	dec [hl]
	
	ld hl, wYPos
	ld a, [hl]
	sub 8
	and $0F
	cp UP_STAIRS_Y_COORD - 8
	jr z, .startClimbing
	
	ld b, a ; Save this for AlignToStairsUp
	inc hl
	inc hl
	ld a, [hl] ; Get x coord
	and $0F
	cp $0D
	jr z, AlignToStairsUp ; If the player is at XD, this means he's on the right of the stairs
	; Otherwise we need to move to the right
	inc [hl] ; Inc x
	inc hl
	jr nz, .noCarry
	inc [hl]
.noCarry
	inc hl ; Points to player dir
	ld a, DIR_RIGHT
	ld [hl], a
	call MoveNPC0ToPlayer
	jp ProcessNPCs
	
.startClimbing
	ld a, DIR_LEFT
	jr FirstLoadingStairsUp

	
LoadingStairsUpRight::
	ld hl, wNPC0_steps
	dec [hl]
	
	ld hl, wYPos
	ld a, [hl]
	sub 8
	and $0F
	cp UP_STAIRS_Y_COORD - 8
	jr z, StartStairsUpRight
	
	ld b, a ; Save this for AlignToStairsUp
	inc hl
	inc hl
	ld a, [hl] ; Get x coord
	and $0F
	cp $0D
	jr z, AlignToStairsUp ; If the player is at XD, this means he's on the right of the stairs
	; Otherwise we need to move to the right
	ld a, [hli] ; Get old x
	dec [hl] ; Inc x
	and a
	jr nz, .noCarry
	dec [hl]
.noCarry
	inc hl ; Points to player dir
	ld a, DIR_LEFT
	ld [hl], a
	call MoveNPC0ToPlayer
	jp ProcessNPCs
	
	
AlignToStairsUp:
	dec hl
	dec hl
	ld a, b ; Get back modified coord
	cp UP_STAIRS_Y_COORD - 8 ; Do the comp' again
	jr nc, .moveUp
	ld a, DIR_DOWN
	ld [wPlayerDir], a
	inc [hl]
	jr nz, .noCarry
	inc hl
	inc [hl]
	jr .noCarry
	
.moveUp
	xor a ; ld a, DIR_UP
	ld [wPlayerDir], a
	dec [hl]
	ld a, [hl]
	inc a
	jr nz, .noCarry
	inc hl
	dec [hl]
.noCarry
	call MoveNPC0ToPlayer
	jp ProcessNPCs
	
	
StartStairsUpRight: ; Part of LoadingStairsUpRight
	ld a, DIR_RIGHT
	
	
FirstLoadingStairsUp:
	ldh [hLoadingWalkDirection], a
	ld a, THREAD2_LOADINGSTAIRSUP
	ldh [hThread2ID], a
	
LoadingStairsUp::
	ld hl, wNPC0_steps
	dec [hl]
	ldh a, [hLoadingWalkDirection]
	ld [wPlayerDir], a
	ld b, a
	
	; Don't move too much, looks spazzy
	ldh a, [hFrameCounter]
	and 3
	ret nz
	
	ld a, b
	cp DIR_LEFT
	ld hl, wXPos
	ld a, [hl]
	jr z, .moveLeft
	inc [hl]
	jr nz, .doneMoving ; noCarry
	inc hl
	inc [hl]
	jr .doneWithCarry
	
.moveLeft
	dec [hl]
	and a
	jr nz, .doneMoving ; noCarry
	inc hl
	dec [hl]
.doneWithCarry
	dec hl
	
.doneMoving
	and 3
	jr nz, .dontMoveUp
	dec hl
	dec hl
	ld a, [hl]
	and $0F
	sub 6
	jr nz, .keepMoving
	; Once the player has gone up enough, make it disappear and stop moving it
	ldh [hThread2ID], a ; Stop moving it next time
	ld [hl], a ; We'll put the player far away ($FEXX should be fine)
.keepMoving
	dec [hl]
	dec [hl]
	
.dontMoveUp
	call MoveNPC0ToPlayer
	jp ProcessNPCs
	
	
DOWN_STAIRS_Y_COORD equ $09
	
LoadingStairsDownLeft::
	ld hl, wNPC0_steps
	dec [hl]
	
	ld hl, wYPos
	ld a, [hl]
	sub 8
	and $0F
	cp DOWN_STAIRS_Y_COORD - 8
	jr nz, AlignToStairsDown
	
	ld a, DIR_LEFT
	jr FirstLoadingStairsDown
	
	
LoadingStairsDownRight::
	ld hl, wNPC0_steps
	dec [hl]
	
	ld hl, wYPos
	ld a, [hl]
	sub 8
	and $0F
	cp DOWN_STAIRS_Y_COORD - 8
	jr z, StartStairsDownRight
	
	
AlignToStairsDown:
	ld b, a
	inc hl
	inc hl
	ld a, [hl] ; Get x coord
	and $0F
	cp $0D
	jr z, .alignVert ; If the player is at XD, this means he's on the right of the stairs
	; Otherwise we need to move to the right
	inc [hl] ; Inc x
	ld a, [hli] ; Get new x
	jr nz, .noHorizCarry
	inc [hl]
.noHorizCarry
	inc a ; New x still
	inc a
	and $0F ; This will be zero if player is now aligned to stairs
	inc hl ; Points to player dir
	ld a, DIR_RIGHT
	ld [hl], a
	jr .noCarry ; Done moving
	
.alignVert
	dec hl
	dec hl
	ld a, b ; Get back modified coord
	cp DOWN_STAIRS_Y_COORD - 8 ; Do the comp' again
	jr nc, .moveUp
	ld a, DIR_DOWN
	ld [wPlayerDir], a
	inc [hl]
	jr nz, .noCarry
	inc hl
	inc [hl]
	jr .noCarry
	
.moveUp
	xor a ; ld a, DIR_UP
	ld [wPlayerDir], a
	dec [hl]
	ld a, [hl]
	inc a
	jr nz, .noCarry
	inc hl
	dec [hl]
.noCarry
	call MoveNPC0ToPlayer
	jp ProcessNPCs
	
	
StartStairsDownRight: ; Part of LoadingStairsDownRight
	ld a, DIR_RIGHT
	
	
FirstLoadingStairsDown:
	ldh [hLoadingWalkDirection], a
	ld a, THREAD2_LOADINGSTAIRSDOWN
	ldh [hThread2ID], a
	xor a
	ldh [hLoadingStepCounter], a
	
LoadingStairsDown::
	ld hl, wNPC0_steps
	dec [hl]
	ldh a, [hLoadingWalkDirection]
	ld [wPlayerDir], a
	ld b, a
	
	; Don't move too much, looks spazzy
	ldh a, [hFrameCounter]
	and 3
	ret nz
	
	ld a, b
	cp DIR_LEFT
	ld hl, wXPos
	ld a, [hl]
	jr z, .moveLeft
	inc [hl]
	jr nz, .doneMoving ; noCarry
	inc hl
	inc [hl]
	jr .doneWithCarry
	
.moveLeft
	dec [hl]
	and a
	jr nz, .doneMoving ; noCarry
	inc hl
	dec [hl]
.doneWithCarry
	dec hl
	
.doneMoving
	ld b, a
	ldh a, [hLoadingStepCounter]
	cp 8
	jr c, .dontMoveDown
	and 3
	jr nz, .dontMoveDown
	dec hl
	dec hl
	ld a, [hl]
	and $0F
	jr nz, .keepMoving
	; Once the player has gone down enough, make it disappear and stop moving it
	ldh [hThread2ID], a ; Stop moving it next time
	ld a, $FC
	ld [hl], a ; We'll put the player far away ($FEXX should be fine)
.keepMoving
	inc [hl]
	inc [hl]
	
.dontMoveDown
	call MoveNPC0ToPlayer
	call ProcessNPCs
	
	; If possible, hide left half (first 2 sprites of player)
	ldh a, [hLoadingStepCounter]
	inc a
	ldh [hLoadingStepCounter], a
	cp 24
	ret c
	cp 31
	ret nc
	ld hl, wVirtualOAM + 4 * OAM_SPRITE_SIZE
	xor a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	ld [hl], a
	ret
	
	
ScrollClouds::
	ld hl, hSpecialEffectsBuf + 1
	ld c, LOW(hCloudScrollCount)
	ld a, [c]
	dec a
	and 15
	ld [c], a
	ret nz
	inc [hl]
	ret

