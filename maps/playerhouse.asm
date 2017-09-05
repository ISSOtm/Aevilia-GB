
SECTION "Player house map", ROMX
PlayerHouse::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 10, 9
	dw NO_SCRIPT ; No loading script
	
PlayerHouseInteractions::
	db 2
	
	db WALK_LOADZONE
	interact_box $0077, $003E, 6, $14
	db 0
	db 3
	
	db BTN_INTERACT
	interact_box $0008, $0080, 16, 16
	dw PlayerHouseTVScript
	
PlayerHouseNPCs::
	db 0
	
PlayerHouseWarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $0076 ; Y pos
	dw $0048 ; X pos
	db DIR_UP ; Direction
	db NO_WALKING ; Flags
	db 0
	dw NO_SCRIPT ; Loading script (none)
	ds 7
	
PlayerHouseBlocks::
INCBIN "maps/playerhouse.blk"
	
	
	set_text_prefix PlayerHouseTV
PlayerHouseTVScript::
	disp_box
	print_line_id 0
	print_line_id 1
.source1
	choose YesNoChoice, .branch1 - .source1
	close_box
	make_player_walk DIR_DOWN, 32, 1
	turn_player DIR_UP
	wait_user
	make_player_walk DIR_UP, 32, 1
	delay 30
	turn_player DIR_DOWN
	done
	
.branch1
	print_line_id 2
	wait_user
	done
