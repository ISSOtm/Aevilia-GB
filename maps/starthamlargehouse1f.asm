
SECTION "Startham's large house map", ROMX
StarthamLargeHouse::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db 0
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 20, 9
	dw NO_SCRIPT ; No loading script
	
StarthamLargeHouseInteractions::
	db 1
	
	db WALK_LOADZONE
	load_zone $0077, $003E, 10, $15, THREAD2_LOADINGWALKDOWN, 3, MAP_STARTHAM
	
StarthamLargeHouseNPCs::
	db 1
	
	dw NO_FLAG_DEP
	npc $0020, $0000, 0, 0, 0, $0A, DIR_LEFT, 1, 1, 1, 1, 0, 0 ; Plant
	
	db 0 ; Number of NPC scripts
	dw 0 ; Obligatory no matter the above value
	
	db 0 ; Number of NPC tile sets
	
StarthamLargeHouseWarpToPoints::
	db 1 ; Number of warp-to points
	
	warp_to $0076, $0048, DIR_UP, NO_WALKING, 0, THREAD2_AFTERLOADINGWALKUP, NO_SCRIPT ; Startham
	
StarthamLargeHouseBlocks::
INCBIN "maps/starthamlargehouse1f.blk"
