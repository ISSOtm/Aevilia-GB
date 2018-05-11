

; Song IDs

	enum_start
	enum_elem MUSIC_SAFE_PLACE
	enum_elem MUSIC_BATTLE_1
	enum_elem MUSIC_FILESELECT
	enum_elem MUSIC_OVERWORLD
	enum_elem MUSIC_BOSS_1
	enum_elem MUSIC_SCARECHORD
	enum_elem MUSIC_NEO_SAFE_PLACE
	enum_elem MUSIC_AVOCADO_INVADERS
	enum_elem MUSIC_FOREST
	
	enum_elem MUSIC_INVALIDTRACK ; IDs >= this are invalid (except $FF)
	
	enum_set $FF
	enum_elem MUSIC_NONE
	
	
	enum_start
	enum_elem MUSICFADE_OUT
	enum_elem MUSICFADE_IN
	enum_elem MUSICFADE_OUT_STOP
	
	enum_start
	enum_elem SFX_NPC_SURPRISE
	enum_elem SFX_TEXT_CONFIRM
	enum_elem SFX_TEXT_DENY
	enum_elem SFX_STAIRS
	enum_elem SFX_TEXT_ADVANCE
	enum_elem SFX_BATTLE_THUD
	enum_elem SFX_MISC_BELL
	enum_elem SFX_PHONE_RINGING
	enum_elem SFX_PHONE_HANG_UP
	enum_elem SFX_DOOR_KNOCK
	enum_elem SFX_MISC_ZAP
	enum_elem SFX_TEXT_SELECT
	enum_elem SFX_DOOR_OPEN
	enum_elem SFX_MENU_OPEN
	enum_elem SFX_MISC_RUMBLE		; loop this sound every 8 frames (could also be used as a "distant thud" sound)
	enum_elem SFX_NPC_JUMP
	enum_elem SFX_ARCADE_SHOOT
	enum_elem SFX_ARCADE_HIT_ENEMY
	enum_elem SFX_ARCADE_UFO		; loop this sound every 24 frames
	enum_elem SFX_ARCADE_POWERUP
	enum_elem SFX_ARCADE_YOU_LOSE
	
	enum_set $FF
	enum_elem SFX_NONE

