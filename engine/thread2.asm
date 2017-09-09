
SECTION "Thread 2 pointers and functions", ROMX
	
Thread2Ptrs::
	dw LoadingWalk
	dw LoadingWalkUp
	dw LoadingWalkDown
	dw LoadingWalkLeft
	dw LoadingWalkRight
	dw OpenDoorAnim
	
	
LoadingWalkUp::
	xor a ; ld a, DIR_UP
	jr LoadingFirstWalk
	
LoadingWalkDown::
	ld a, DIR_DOWN
	jr LoadingFirstWalk
	
LoadingWalkLeft::
	ld a, DIR_LEFT
	jr LoadingFirstWalk
	
LoadingWalkRight::
	ld a, DIR_RIGHT
	
LoadingFirstWalk:
	ldh [hLoadingWalkDirection], a
	ld [wPlayerDir], a
	ld a, THREAD2_LOADINGWALK
	ldh [hThread2ID], a
	
LoadingWalk::
	ld a, [wFadeCount]
	sub $20
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
	jr c, .movePositively
	dec [hl]
	dec [hl]
.movePositively
	inc [hl]
	call MoveNPC0ToPlayer
	ld hl, wNPC0_steps
	dec [hl]
	jp ProcessNPCs
	
	
OpenDoorAnim::
	ret

