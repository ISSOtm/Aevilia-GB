

; SECTION "Overworld", ROM0

OverworldLoop::
	xor a ; Suppose we don't have to ignore the player's actions
	ldh [hIgnorePlayerActions], a
	
.forceIgnorePlayerActions
	xor a
	ldh [hAbortFrame], a
	rst waitVBlank
	
	; Increment overworld's frame counter
	ldh a, [hOverworldFrameCounter]
	inc a
	ldh [hOverworldFrameCounter], a
	
	; Update our own button addresses
	ldh a, [hOverworldHeldButtons] ; Get previously held buttons
	cpl ; Complement to create a mask
	ld b, a ; Save it
	ldh a, [hHeldButtons] ; Get the game's held buttons
	ldh [hOverworldHeldButtons], a ; Store them
	and b ; Remove previously held buttons
	ld b, a ; Save this
	ldh a, [hOverworldButtonFilter]
	and b ; Apply the filter
	ldh [hOverworldPressedButtons], a ; Store that
	
	ld a, 1
	call SwitchRAMBanks
	
	; Run map script, if any
	ld de, wMapScriptPtr + 1
	ld a, [de]
	ld h, a
	dec de
	ld a, [de]
	ld l, a
	or h
	jr nz, @+1
	
	ldh a, [hAbortFrame] ; If map script tells to abort frame, do so
	and a
	jr nz, .forceIgnorePlayerActions
	
	ldh a, [hIgnorePlayerActions]
	and a
	jr nz, .ignoreMovement
	
	; If a battle is about to start, don't perform any operation
	ld a, [wBattleEncounterID]
	and a
	jr nz, .ignoreMovement
	
	; Move, if allowed to
	ld a, [wUnlinkJoypad]
	and a
	call z, MovePlayer
.ignoreMovement	
	
	call PlayAnimations
	call MoveNPCs
	call MoveNPC0ToPlayer
	call MoveCamera
	call ProcessNPCs
	call ExtendOAM
	ld a, [wCameraYPos]
	ldh [hSCY], a
	ld a, [wCameraXPos]
	ldh [hSCX], a
	
	call DoWalkingInteractions
	
	ldh a, [hAbortFrame] ; If walking interactions tells to abort frame, do so
	and a
	jr nz, .forceIgnorePlayerActions
	
	ld a, [wBattleEncounterID]
	and a
	jr nz, .startBattle
	
	ldh a, [hIgnorePlayerActions]
	and a
	jr nz, OverworldLoop
	
	ld a, [wUnlinkJoypad]
	and a
	jr nz, OverworldLoop
	
	; Process button interactions, if any
	ldh a, [hOverworldPressedButtons]
	rrca ; A
	jr c, .doButtonInteractions
	rrca ; B
	rrca ; Select
	rrca ; Start
	jp nc, OverworldLoop
	
	callacross StartMenu
.gotoLoop
	ldh a, [hAbortFrame] ; Doesn't make a very big difference, though
	and a
	jp nz, .forceIgnorePlayerActions
	jp OverworldLoop
	
.startBattle
	callacross StartBattle
	
	ld a, MUSICFADE_OUT_STOP
	call DS_Fade
	ld a, $80
	ld [wFadeSpeed], a
	callacross Fadeout
	
	ld a, [wMapMusicID]
	call DS_Init
	call RedrawMap
	call ProcessNPCs
	xor a
	ldh [hTilemapMode], a
	ld [GlobalVolume], a
	inc a
	ldh [hIgnorePlayerActions], a
;	ld a, MUSICFADE_IN
	call DS_Fade
	callacross Fadein
	
	jp .forceIgnorePlayerActions
	
.doButtonInteractions
	; Reset this now, to allow the interaction to choose by itself
	xor a
	ldh [hIgnorePlayerActions], a
	call DoButtonInteractions
	jp .forceIgnorePlayerActions ; Don't force the player's actions to be taken into account, again.

