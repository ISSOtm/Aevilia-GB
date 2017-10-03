
SECTION "Default save", ROMX
;SECTION "Default save bank 0", ROMX

DefaultSaveBank0::

; MAKES SURE THIS MATCHES `MagicString`!!
DefaultSaveMagicString0::
	dstr "Aevilia"
	
DefaultSaveChecksums0::
	ds $F8
	
DefaultSaveWarp::
	db 0 ; wTargetWarpID
	db 2 ; wLoadedMap
	
DefaultPlayerData::
	db 0 ; wUnlinkJoypad
	db 0 ; wNoClipActive
	db 1 ; wPlayerSpeed
	dw $70 ; wYPos
	dw $70 ; wXPos
	db DIR_RIGHT ; wPlayerDir
	db 1 ; wPlayerGender (edit IntroChooseGender if modified)
	db 0 ; wCameramanID
	dw 0 ; wCameraYPos
	dw 0 ; wCameraXPos
	
DefaultButtonFilter::
	db $FF ; hOverworldButtonFilter
	
DefaultMapStatuses::
	db 0 ; wIntroMapStatus
	db 0 ; wIntroMapDelayStep
	db 0 ; wTestWarriorFlags
	
DefaultRNG::
	dw 0 ; hRandInt
	
; Will be overridden by the map loading anyways
DefaultNumOfNPCScripts::
	db 0 ; wNumOfNPCScripts
	dw 0 ; wNPCScriptsPointer
	
; NPC 0 is never overridden, so we initialize it here
DefaultNPCArray::
	dw 0 ; wNPC0_ypos
	dw 0 ; wNPC0_xpos
	db 0 ; wNPC0_ybox
	db 0 ; wNPC0_xbox
	db 0 ; wNPC0_interactID
	db 0 ; wNPC0_sprite
	dw 0 ; wNPC0_palettes
	db 0 ; wNPC0_steps
	db 0 ; wNPC0_movtFlags
	db 0 ; wNPC0_speed
	db 0 ; wNPC0_ydispl
	db 0 ; wNPC0_unused
	db 0 ; wNPC0_xdispl
	
; wNPC1_ypos to wNPC8_xdispl
REPT 8 ; 8 NPCs
REPT $10 ; 1 NPC = $10 bytes
	db 0
ENDR
ENDR

DefaultFlags::
REPT $1000
	db 0
ENDR

DefaultSaveBank0End:

	ds $2000 - (DefaultSaveBank0End - DefaultSaveBank0)

	
;SECTION "Default save bank 1", ROMX
DefaultSaveBank1::

; Also make sure this matches `MagicString`.
DefaultSaveMagicString1::
	dstr "Aevilia"
	
DefaultSaveChecksums1::
	ds $F8
	
DefaultSaveBank1End:
	
	ds $2000 - (DefaultSaveBank1End - DefaultSaveBank1)
