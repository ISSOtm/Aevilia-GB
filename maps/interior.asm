
SECTION "Test house map", ROMX
TestHouseNew::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 9, 6
	dw NO_SCRIPT ; No loading script
	
TestHouseNewInteractions::
	db 1
	
	db WALK_LOADZONE
	interact_box $004B, $002E, 6, 5
	db 0
	db 0
	
TestHouseNewNPCs::
	db 0
	
TestHouseNewWarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $0041 ; Y pos
	dw $0030 ; X pos
	db DIR_UP ; Direction
	db NO_WALKING ; Flags
	db 0
	dw NO_SCRIPT ; Loading script (none)
	ds 7
	
TestHouseNewBlocks::
INCBIN "maps/testhousenew.blk"
