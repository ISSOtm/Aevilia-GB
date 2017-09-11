
SECTION "Player house map", ROMX
StarthamHouse2::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 10, 10
	dw NO_SCRIPT ; No loading script
	
StarthamHouse2Interactions::
	db 1
	
	db WALK_LOADZONE
	interact_box $0087, $002E, 10, $15
	db THREAD2_LOADINGWALKDOWN
	db 4
	db MAP_STARTHAM
	ds 7
	
StarthamHouse2NPCs::
	db 2
	
	interact_box $0040, $0000, 0, 0
	db 0
	db $10 << 2 | DIR_UP
	dn 1, 1, 1, 1
	db $00
	db $00
	
	interact_box $0070, $0090, 0, 0
	db 0
	db $10 << 2 | DIR_UP
	dn 1, 1, 1, 1
	db $00
	db $00
	
	db 0
	dw 0
	
	db 0
	
StarthamHouse2WarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $0086 ; Y pos
	dw $0038 ; X pos
	db DIR_UP ; Direction
	db NO_WALKING ; Flags
	db 0
	db THREAD2_AFTERLOADINGWALKUP
	dw NO_SCRIPT ; Loading script (none)
	ds 6
	
StarthamHouse2Blocks::
INCBIN "maps/starthamhouse2.blk"
