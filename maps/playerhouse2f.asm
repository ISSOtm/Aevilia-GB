
SECTION "Player house 2F map", ROMX
PlayerHouse2F::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db 1 ; Tileset is dependent
	dw PlayerHouse2FTilesetScript
	dw NO_SCRIPT ; No map script
	map_size 10, 9
	dw NO_SCRIPT ; No loading script
	
PlayerHouse2FInteractions::
	db 2
	
	db WALK_LOADZONE
	interact_box $0008, $FFFE, 16, 16
	db THREAD2_LOADINGSTAIRSDOWN_LEFT
	db 1
	db MAP_PLAYER_HOUSE
	ds 7
	
	db BTN_INTERACT
	interact_box $0010, $0090, 32, 16
	dw TestIntroCutscene
	ds 8
	
PlayerHouse2FNPCs::
	db 2
	
	dw 0
	interact_box $0040, $0030, 0, 0
	db 0 ; Interaction ID
	db $0A << 2 | DIR_LEFT ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $00 ; Movement permissions
	db $00 ; Movement speed
	
	dw 0
	interact_box $0050, $0050, 0, 0
	db 0 ; Interaction ID
	db $0A << 2 | DIR_LEFT ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $00 ; Movement permissions
	db $00 ; Movement speed
	
	db 0 ; Number of NPC scripts
	dw 0 ; Obligatory no matter the above value
	
	db 0 ; Number of NPC tile sets
	
PlayerHouse2FWarpToPoints::
	db 2 ; Number of warp-to points
	
	dw $0009
	dw $000F
	db DIR_RIGHT
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw NO_SCRIPT
	ds 6
	
	dw $0013
	dw $0090
	db DIR_DOWN
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw NO_SCRIPT
	ds 6
	
PlayerHouse2FBlocks::
INCBIN "maps/playerhouse2f.blk"
	
PlayerHouse2FTilesetScript::
	ld de, FLAG_INTRO_CUTSCENE_PLAYED
	call GetFlag
	ld a, TILESET_INTRO
	ret nc ; If the cutscene hasn't played yet, use the dimmed tileset instead
	ld a, TILESET_INTERIOR
	ret
	
	
TestIntroCutscene::
	text_asmcall IntroCutscene
	done
