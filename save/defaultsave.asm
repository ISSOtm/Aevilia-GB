
SECTION "Default save", ROMX
;SECTION "Default save bank 0", ROMX

DefaultSaveBank0::

; MAKES SURE THIS MATCHES `MagicString`!!
DefaultSaveMagicString0::
	db "Aevilia"
	
	db ROM_VERSION
	
DefaultSaveChecksums0:
	ds $F8
	
	
DefaultSaveWarp:
	db 0 ; wTargetWarpID
	db 2 ; wLoadedMap
	
	
DefaultPlayerData:
	dw $70 ; wYPos
	dw $70 ; wXPos
	db DIR_RIGHT ; wPlayerDir
	db 0 ; wUnlinkJoypad
	db 0 ; wNoClipActive
	db 1 ; wPlayerSpeed
	db 1 ; wPlayerGender (edit IntroChooseGender if modified)
	db 0 ; wCameramanID
	dw 0 ; wCameraYPos
	dw 0 ; wCameraXPos
	
DefaultButtonFilter:
	db $FF ; hOverworldButtonFilter
	
	
DefaultRNG:
	dw 0 ; hRandInt
	
	
; These two will be overridden by the map loading anyways
DefaultInteractions:
	dbfill $400, 0
	
	
DefaultInteractionCounts:
	dbfill 4, 0 ; wWalkInterCount - wBtnLoadZoneCount
	db 0 ; wNumOfNPCScripts
	dw 0 ; wNPCScriptsPointer
	
	
; NPC 0 is never overridden, so we initialize it here
DefaultNPCArray:
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
	dbfill 8 * $10, 0 ; 1 NPC = $10 bytes
	
	
DefaultEmoteData::
	db $7F ; wEmoteGfxID
	db 0 ; wEmotePosition
	db 0 ; wNumOfNPCs
	
	
DefaultAnimationSlots::
	dbfill 8 * 8, 0
	
DefaultAnimationStacks::
	dbfill 8 * 8, 0
	
DefaultActiveAnimations::
	db $FF
	dbfill 8, 0
	
; DefaultAnimationTargetNPCs::
	dbfill 8, 0
	
DefaultTextAnimationSlots::
	dbfill 8, $FF
	
	
DefaultExtendedOAM::
	dbfill $A0, 0
	
	dbfill 3, 0
	
	
DefaultOAMMode::
	db 0
	
	
DefaultAnimGfxHooks::
REPT 8
	db $FF
	ds 7
ENDR
	

DefaultFlags:
	dbfill $1000, 0

DefaultSaveBank0End:

	ds $2000 - (DefaultSaveBank0End - DefaultSaveBank0)

	
;SECTION "Default save bank 1", ROMX
DefaultSaveBank1::

; Also make sure this matches `MagicString`.
DefaultSaveMagicString1::
	db "Aevilia"
	
	db ROM_VERSION
	
DefaultSaveChecksums1::
	ds $F8
	
DefaultSaveBank1End:
	
	ds $2000 - (DefaultSaveBank1End - DefaultSaveBank1)
