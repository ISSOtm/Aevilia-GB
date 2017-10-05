
SECTION "Startham's large house map", ROMX
StarthamLargeHouse::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 20, 9
	dw NO_SCRIPT ; No loading script
	
StarthamLargeHouseInteractions::
	db 1
	
	db WALK_LOADZONE
	interact_box $0077, $003E, 10, $15
	db THREAD2_LOADINGWALKDOWN
	db 3
	db MAP_STARTHAM
	ds 7
	
StarthamLargeHouseNPCs::
	db 1
	
	dw 0
	interact_box $0020, $0000, 0, 0
	db 0 ; Interaction ID
	db $0A << 2 | DIR_LEFT ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $00 ; Movement permissions
	db $00 ; Movement speed
	
	db 0 ; Number of NPC scripts
	dw 0 ; Obligatory no matter the above value
	
	db 0 ; Number of NPC tile sets
	
StarthamLargeHouseWarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $0076 ; Y pos
	dw $0048 ; X pos
	db DIR_UP ; Direction
	db NO_WALKING ; Flags
	db 0
	db THREAD2_AFTERLOADINGWALKUP
	dw NO_SCRIPT ; Loading script (none)
	ds 6
	
StarthamLargeHouseBlocks::
INCBIN "maps/starthamlargehouse1f.blk"
