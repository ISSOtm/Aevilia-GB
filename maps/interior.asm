
SECTION "Test house map", ROMX
TestHouseNew::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 10, 9
	dw NO_SCRIPT ; No loading script
	
TestHouseNewInteractions::
	db 1
	
	db WALK_LOADZONE
	interact_box $0077, $003E, 6, $14
	db 0
	db 3
	
TestHouseNewNPCs::
	db 0
	
TestHouseNewWarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $0076 ; Y pos
	dw $0048 ; X pos
	db DIR_UP ; Direction
	db NO_WALKING ; Flags
	db 0
	dw NO_SCRIPT ; Loading script (none)
	ds 7
	
TestHouseNewBlocks::
INCBIN "maps/testhousenew.blk"
