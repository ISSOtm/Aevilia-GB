
SECTION "Startham house #2 map", ROMX
StarthamHouse2::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db 0
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 10, 10
	dw NO_SCRIPT ; No loading script
	
StarthamHouse2Interactions::
	db 1
	
	db WALK_LOADZONE
	load_zone $0087, $002E, 10, $15, THREAD2_LOADINGWALKDOWN, 4, MAP_STARTHAM, SFX_STAIRS
	
StarthamHouse2NPCs::
	db 2
	
	dw NO_FLAG_DEP
	npc $0040, $0000, 0, 0, 0, $0A, DIR_LEFT, 1, 1, 1, 1, 0, 0 ; Top-left plant
	
	dw NO_FLAG_DEP
	npc $0070, $0090, 0, 0, 0, $0A, DIR_LEFT, 1, 1, 1, 1, 0, 0 ; Bottom-right plant
	
	db 0
	dw 0
	
	db 0
	
StarthamHouse2WarpToPoints::
	db 1 ; Number of warp-to points
	
	warp_to $0086, $0038, DIR_UP, NO_WALKING, 0, THREAD2_AFTERLOADINGWALKUP, NO_SCRIPT ; Startham
	
StarthamHouse2Blocks::
INCBIN "maps/starthamhouse2.blk"
