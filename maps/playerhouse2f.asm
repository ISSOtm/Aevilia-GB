
SECTION "Player house 2F map", ROMX
PlayerHouse2F::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 10, 9
	dw NO_SCRIPT ; No loading script
	
PlayerHouse2FInteractions::
	db 1
	
	db WALK_LOADZONE
	interact_box $0008, $000E, 16, 1
	db THREAD2_DISABLED
	db 1
	db MAP_PLAYER_HOUSE
	ds 7
	
PlayerHouse2FNPCs::
	db 0
	
PlayerHouse2FWarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $000C
	dw $000F
	db DIR_RIGHT
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw NO_SCRIPT
	ds 6
	
PlayerHouse2FBlocks::
INCBIN "maps/playerhouse2f.blk"
