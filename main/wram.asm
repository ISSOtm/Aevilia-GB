
SECTION "HomeRAM", WRAM0
; Used to save the value of a if a fatal error occurs
wSaveA::
	ds 1
wFatalErrorCode::
	ds 1
	
	
; ID of the current save file
wSaveFileID::
	ds 1
	
wTargetWarpID::
	ds 1
wLoadedMap::
	ds 1
wLoadedMapROMBank::
	ds 1
wLoadedTileset::
	ds 1
wMapScriptPtr::
	ds 2
wMapWidth::	
	ds 1
wMapHeight::
	ds 1
	
	
SECTION "Player data", WRAM0,ALIGN[2]

UNION
wIntroInterruptable::
	ds 1
wIntroInterrupted::
	ds 1
	
wIntroSP::
	ds 2
	
wIntroScrollSpeed::
	ds 1
wIntroPauseLength::
	ds 1
	
NEXTU
	ds 2 ; Intro interruptable / interrupted
	
wTitleScreenScrollX::
	ds 1
wTitleScreenScrollDelay::
	ds 1
	
NEXTU

; Coordinates within the map
wYPos::
	ds 2
wXPos::
	ds 2

; Direction the player is facing
wPlayerDir::
	ds 1
	
; If non-zero, joypads inputs can't move the player
wUnlinkJoypad::
	ds 1
ENDU
	
; If non-zero, collision detection will be disabled
wNoClipActive::
	ds 1
	
; The player's speed, in px/frame
wPlayerSpeed::
	ds 1
	
wPlayerGender::
	ds 1
	
	
; ID of the NPC the camera will try to focus on
wCameramanID::
	ds 1
; Camera's coordinates
wCameraYPos::
	ds 2
wCameraXPos::
	ds 2
	


SECTION "GFX and text", WRAM0,ALIGN[8]
; Each of these bytes controls if the corresponding row of FixedTileMap should be transferred
; Note that only one row can be processed on each frame due to timing limitations (and code complexity)
; WARNING : high byte of all 18 bytes must be the same! (ie must not cross a 256-byte boundary)
; If this has to be moved, make sure to change **ALL** instances where this is used!
wTransferRows::
	ds 6 + SCREEN_HEIGHT
	
; The "fixed" tile map, transferred on VBlanks
; 18 rows of 20 tiles each
wTextboxTileMap::
	ds 5
; The textbox spans 5 lines
wTextboxName::
	ds 15
	; End row 0
	ds 1
wTextboxPicRow0::
	ds 3
	ds 16
	; End row 1
	ds 1
wTextboxPicRow1::
	ds 3
	ds 1
wTextboxLine0::
	ds 15
	; End row 2
	ds 1
wTextboxPicRow2::
	ds 3
	ds 1
wTextboxLine1::
	ds 15
	; End row 3
	ds 1
wTextboxPicRow3::
	ds 3
	ds 1
wTextboxLine2::
	ds 15
	; End row 4
	ds SCREEN_WIDTH
	
wFixedTileMap::
	ds SCREEN_HEIGHT * SCREEN_WIDTH
	
	
; Controls the text box's status
; Bit 7 set = Closing textbox
; Bits 0-6 indicate the status (0 = disabled, 80 = fully displayed)
; The text box is considered active is this is non-zero
wTextboxStatus::
	ds 1
	
; Destination coords for text printing
wNumOfPrintedLines::
	ds 1
; Counter for text looping
; Can be set to a fixed value and decremented as a loop counter
wTextLoopCounter::
	ds 1
	
; Temporary buffer for command and argument copy
; Holds a copy of the processed data to be visible across banks
; Other use :
; Temporary buffer for number displaying
; Holds the two/four drawn digits plus a terminating $00
wDigitBuffer::
	ds 5
	
; Text accumulator register
wTextAcc::
	ds 1
	
; Text flag register
; Bit 7 - Carry
; Bit 6 - Sign
; Bit 5 - Parity
; Bit 4 - Zero
; Bit 3 - Is pic present?
; Bit 2 - Unused
; Bit 1 - Unused
; Bit 0 - Unused
wTextFlags::
	ds 1
	
	
SECTION "Larger buffer", WRAM0
wLargerBuf::
	ds $11
	
	
SECTION "Palettes", WRAM0[$C2FE]
	
; Fadeout/Fadein will wait (this & $7F)+1 frames between each step of the fade
; If bit 7 is reset, fade will be from/to white, otherwise black
wFadeSpeed::
	ds 1
	
; Counter for palette fade effect
wFadeCount::
	ds 1
	
; Contains all loaded BG palettes in uncompressed format
; Used for fadeout/fadein
wBGPalettes::
	struct_pal BG,0
	struct_pal BG,1
	struct_pal BG,2
	struct_pal BG,3
	struct_pal BG,4
	struct_pal BG,5
	struct_pal BG,6
	struct_pal BG,7
	
; Contains all loaded OBJ palettes in uncompressed format
; Used for fadeout/fadein
wOBJPalettes::
	struct_pal OBJ,0
	struct_pal OBJ,1
	struct_pal OBJ,2
	struct_pal OBJ,3
	struct_pal OBJ,4
	struct_pal OBJ,5
	struct_pal OBJ,6
	struct_pal OBJ,7
wPalettesEnd:
	
	
	
SECTION "Staged OAM", WRAMX,BANK[1],ALIGN[8]

wStagedOAM::
	ds 40 * OAM_SPRITE_SIZE
	
	
SECTION "OAM", WRAM0,ALIGN[8]
	
; The virtual OAM, dynamically transferred during each VBlank
; Make sure to update wNumOfSprites accordingly
;!!! LOW BYTE OF THIS MUST BE ZERO!!!
wVirtualOAM::
	ds 40 * OAM_SPRITE_SIZE
	
; Number of sprites in "main" OAM (will be extended with the secondary OAM later)
wNumOfSprites::
	ds 1
; Value on previous frame
wPrevNumOfSprites::
	ds 1
	
	
SECTION "Extended OAM", WRAM0
	
; This contains "minor" sprites that should be "appended" to OAM
wExtendedOAM::
	ds 40 * OAM_SPRITE_SIZE
	
; Number of extended sprites
wNumOfExtendedSprites::
	ds 1
	
	
; Set this to non-zero to commit a modification of VirtualOAM to the real OAM
; It's reset afterwards anyways
wTransferSprites::
	ds 1
	
; Number of sprites (to be transferred) in VirtualOAM
; Manually capped at 40, the maximum possible value
wTotalNumOfSprites::
	ds 1
	
	
SECTION "Animation table", WRAM0,ALIGN[3]
	
wAnimationSlots::
	animation 0
	animation 1
	animation 2
	animation 3
	animation 4
	animation 5
	animation 6
	animation 7
	
wAnimationStacks::
	animation_stack 0
	animation_stack 1
	animation_stack 2
	animation_stack 3
	animation_stack 4
	animation_stack 5
	animation_stack 6
	animation_stack 7
	
wAnimationGfxHooks::
	animation_gfx_hook 0
	animation_gfx_hook 1
	animation_gfx_hook 2
	animation_gfx_hook 3
	animation_gfx_hook 4
	animation_gfx_hook 5
	animation_gfx_hook 6
	animation_gfx_hook 7
	
; List of the IDs of the active animation slots
wActiveAnimations::
	ds 9
	
; Table of "offsets" for the NPC-targeting animation commands
wAnimationTargetNPCs::
	ds 8
	
wTextAnimationSlots::
	ds 8

	
	
SECTION "Buffer", WRAMX,BANK[1]
; This is a general-purpose temporary buffer
; To avoid conflicting uses, this buffer's contents should **not** be assumed to be deterministic outside of the scope it is used in (ie. when you return from the function, it becomes oblivion)
; Only exceptions :
; - If a function uses this buffer's contents as an argument (the caller is obviously supposed to fill the buffer before calling)
; - If a function is called that sets the buffer to a known state (be it because it's its return value or a side effect, though you shouldn't use the latter unless you're sure about it)
wTempBuf::
	ds 8
	
	
SECTION "Block metadata", WRAMX[$D000],BANK[1] ; ,ALIGN[4]
	
wBlockMetadata::
	struct_blk 0
	struct_blk 1
	struct_blk 2
	struct_blk 3
	struct_blk 4
	struct_blk 5
	struct_blk 6
	struct_blk 7
	struct_blk 8
	struct_blk 9
	struct_blk 10
	struct_blk 11
	struct_blk 12
	struct_blk 13
	struct_blk 14
	struct_blk 15
	struct_blk 16
	struct_blk 17
	struct_blk 18
	struct_blk 19
	struct_blk 20
	struct_blk 21
	struct_blk 22
	struct_blk 23
	struct_blk 24
	struct_blk 25
	struct_blk 26
	struct_blk 27
	struct_blk 28
	struct_blk 29
	struct_blk 30
	struct_blk 31
	struct_blk 32
	struct_blk 33
	struct_blk 34
	struct_blk 35
	struct_blk 36
	struct_blk 37
	struct_blk 38
	struct_blk 39
	struct_blk 40
	struct_blk 41
	struct_blk 42
	struct_blk 43
	struct_blk 44
	struct_blk 45
	struct_blk 46
	struct_blk 47
	struct_blk 48
	struct_blk 49
	struct_blk 50
	struct_blk 51
	struct_blk 52
	struct_blk 53
	struct_blk 54
	struct_blk 55
	struct_blk 56
	struct_blk 57
	struct_blk 58
	struct_blk 59
	struct_blk 60
	struct_blk 61
	struct_blk 62
	struct_blk 63
wBlockMetadataEnd:
	
	; Make SURE this is 256-byte aligned, or modify GetCollisionAt
wTileAttributes::
	ds 256
wTileAttributesEnd:


SECTION "Tile animations", WRAMX[$D7FF],BANK[1]
	
wNumOfTileAnims::
	ds 1
	
wTileAnimations::
	struct_tileanim 0
	struct_tileanim 1
	struct_tileanim 2
	struct_tileanim 3
	struct_tileanim 4
	struct_tileanim 5
	struct_tileanim 6
	struct_tileanim 7
	struct_tileanim 8
	struct_tileanim 9
	struct_tileanim 10
	struct_tileanim 11
	struct_tileanim 12
	struct_tileanim 13
	struct_tileanim 14
	struct_tileanim 15
wTileAnimationsEnd:
	
	
SECTION "Animation frame storage", WRAMX,BANK[3]
	
wTileFrames::
	ds VRAM_TILE_SIZE * 16 * 16 ; Allow 16 frames per tile (and there are a maximum of 16 tiles to be animated)
wTileFramesEnd:
	
	
SECTION "Interaction table", WRAMX[$D300],BANK[1] ; ,ALIGN[8]
	
wWalkingInteractions::
	walking_interaction 0
	walking_interaction 1
	walking_interaction 2
	walking_interaction 3
	walking_interaction 4
	walking_interaction 5
	walking_interaction 6
	walking_interaction 7
	walking_interaction 8
	walking_interaction 9
	walking_interaction 10
	walking_interaction 11
	walking_interaction 12
	walking_interaction 13
	walking_interaction 14
	walking_interaction 15
	
wButtonInteractions::
	button_interaction 0
	button_interaction 1
	button_interaction 2
	button_interaction 3
	button_interaction 4
	button_interaction 5
	button_interaction 6
	button_interaction 7
	button_interaction 8
	button_interaction 9
	button_interaction 10
	button_interaction 11
	button_interaction 12
	button_interaction 13
	button_interaction 14
	button_interaction 15
	
wWalkingLoadZones::
	walking_loadzone 0
	walking_loadzone 1
	walking_loadzone 2
	walking_loadzone 3
	walking_loadzone 4
	walking_loadzone 5
	walking_loadzone 6
	walking_loadzone 7
	walking_loadzone 8
	walking_loadzone 9
	walking_loadzone 10
	walking_loadzone 11
	walking_loadzone 12
	walking_loadzone 13
	walking_loadzone 14
	walking_loadzone 15
	
wButtonLoadZones::
	button_loadzone 0
	button_loadzone 1
	button_loadzone 2
	button_loadzone 3
	button_loadzone 4
	button_loadzone 5
	button_loadzone 6
	button_loadzone 7
	button_loadzone 8
	button_loadzone 9
	button_loadzone 10
	button_loadzone 11
	button_loadzone 12
	button_loadzone 13
	button_loadzone 14
	button_loadzone 15
	
	
wWalkInterCount::
	ds 1
wBtnInterCount::
	ds 1
wWalkLoadZoneCount::
	ds 1
wBtnLoadZoneCount::
	ds 1
	
; Number of NPC scripts (length of the table)
wNumOfNPCScripts::
	ds 1
; Pointer to the NPC script table
wNPCScriptsPointer::
	ds 2
	
	
SECTION "NPC counter", WRAMX,BANK[1]
	
wEmoteGfxID::
	ds 1
	
wEmotePosition::
	ds 1
	
; Contains the number of NPCs (excluding NPC #0, which is always rendered)
wNumOfNPCs::
	ds 1
	
SECTION "NPC array", WRAMX[$D710],BANK[1] ; ,ALIGN[8]
	
; Contains data for all NPCs
wNPCArray::
	struct_NPC 0 ; This NPC lacks the "N" in "NPC", but is mostly the same, processing-wise
	struct_NPC 1
	struct_NPC 2
	struct_NPC 3
	struct_NPC 4
	struct_NPC 5
	struct_NPC 6
	struct_NPC 7
	struct_NPC 8



SECTION "Sound variables",WRAM0

wMapMusicID::
	ds 1
	
wCurrentMusicID::
	ds 1
wCurrentSFXID::
	ds 1
wChangeMusics::
	ds 1


SECTION	"FX Hammer RAM",WRAM0,ALIGN[3]

FXHammer_SFXCH2	db
FXHammer_SFXCH4	db
; These are only temporary names, I have no idea what they're actually for at the moment
FXHammer_RAM1	db
FXHammer_cnt	db
FXHammer_ptr	dw



SECTION "Battle", WRAMX,BANK[1]
wBattleEncounterID::
	ds 1
	
wBattleTransitionID::
	ds 1
	
wBattlePreservedNPCs::
	ds 1

	
	
SECTION "Map block data", WRAMX

wBlockData::
	ds $1000
	
	
SECTION "Flags", WRAMX

UNION
	
wFlags::
	ds $1000
	
NEXTU
	
wIntroMapStatus::
	ds 1
wIntroMapDelayStep::
	ds 1
	
	; Used
	ds 1
	
ENDU
	
	
	
SECTION "Stack", WRAM0[$CF80]

wStack::	
	ds $80 ; The stack isn't very big right now
wStackBottom::

