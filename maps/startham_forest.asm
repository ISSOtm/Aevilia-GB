
	
TestForestMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db TILESET_TEST
	dw NO_SCRIPT ; Script (none)
	map_size 30, 18 ; Width, height
	dw NO_SCRIPT ; Loading script (none)
	
TestForestInteractions::
	db 4
	
	db WALK_LOADZONE
	interact_box $0068, $01C6, 25, 14
	db THREAD2_LOADINGWALKRIGHT
	db 2
	db MAP_STARTHAM
	ds 7
	
	db WALK_INTERACT
	interact_box $0028, $0000, 9, 16
	dw TestForestEndOfDemo
	ds 8
	
	db BTN_INTERACT
	interact_box $00B0, $01C0, 16, 16
	dw TestForestEntranceSign
	ds 8
	
	db BTN_INTERACT
	interact_box $0020, $0050, 16, 16
	dw StarthamForestExitSign
	ds 8
	
TestForestNPCs::
	db 0
	
TestForestWarpToPoints::
	db 1
	
	dw $0074
	dw $01C2
	db DIR_LEFT
	db KEEP_WALKING
	db 0
	dw NO_SCRIPT
	ds 7
	
TestForestBlocks::
INCBIN "maps/startham_forest.blk"

	set_text_prefix TestForestEndOfDemo
TestForestEndOfDemo::
	disp_box
	print_line_id 0
	print_line_id 1
	print_line_id 2
	wait_user
	clear_box
	print_line_id 3
	print_line_id 4
	print_line_id 5
	wait_user
	clear_box
	print_line_id 6
	print_line_id 7
	wait_user
	close_box
	text_asmcall PlayCredits
	
	
	set_text_prefix TestForestEntranceSign
TestForestEntranceSign::
	disp_box
	print_line_id 0
	wait_user
	clear_box
	print_line_id 1
	print_line_id 2
	print_line_id 3
	wait_user
	done
	
	
	set_text_prefix StarthamForestExitSign
StarthamForestExitSign::
	disp_box
	print_line_id 0
	delay 30
	print_line_id 1
	wait_user
	done
