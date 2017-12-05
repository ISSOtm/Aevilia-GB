
	
StarthamForestMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db 0
	db TILESET_TEST
	dw NO_SCRIPT ; Script (none)
	map_size 30, 18 ; Width, height
	dw NO_SCRIPT ; Loading script (none)
	
StarthamForestInteractions::
	db 5
	
	db WALK_LOADZONE
	load_zone $0068, $01C6, 25, 14, THREAD2_LOADINGWALKRIGHT, 2, MAP_STARTHAM
	
	db WALK_INTERACT
	interaction $0028, $0000, 9, 16, StarthamForestEndOfDemo
	
	db BTN_INTERACT
	interaction $00A1, $01A0, 15, 16, StarthamForestEntranceSign
	
	db BTN_INTERACT
	interaction $0081, $0030, 15, 16, StarthamForestDiagonalSign
	
	db BTN_INTERACT
	interaction $0020, $0050, 16, 16, StarthamForestExitSign
	
StarthamForestNPCs::
	db 0
	
StarthamForestWarpToPoints::
	db 1
	
	warp_to $0074, $01C2, DIR_LEFT, KEEP_WALKING, 0, THREAD2_AFTERLOADINGWALKLEFT, NO_SCRIPT ; Startham
	
StarthamForestBlocks::
INCBIN "maps/startham_forest.blk"

	set_text_prefix StarthamForestEndOfDemo
StarthamForestEndOfDemo::
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
	
	
	set_text_prefix StarthamForestEntranceSign
StarthamForestEntranceSign::
	disp_box
	print_line_id 0
	wait_user
	clear_box
	print_line_id 1
	print_line_id 2
	print_line_id 3
	wait_user
	done
	
	
	set_text_prefix StarthamForestDiagonalSign
StarthamForestDiagonalSign::
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
	done
	
	
	set_text_prefix StarthamForestExitSign
StarthamForestExitSign::
	disp_box
	print_line_id 0
	delay 30
	print_line_id 1
	wait_user
	done
