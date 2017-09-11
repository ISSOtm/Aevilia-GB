
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
	dw OpenDoorAnim
	
	
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
	cp $20
	ret z ; Wait until the fade starts
	
	ld de, $20
	ld a, [wFadeSpeed]
	and $7F ; Ignore color bit
	inc a
	call MultiplyDEByA ; The slower the fade, the more we have to compensate !
	; (Preserves bc)
	
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
	
	
OpenDoorAnim::
	ret

