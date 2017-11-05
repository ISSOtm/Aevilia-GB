	
SECTION "Startham map", ROMX
	
StarthamMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db 0 ; Tileset is fixed
	db TILESET_TEST ; Tileset
	dw NO_SCRIPT ; Script (none)
	map_size 29, 18 ; Width, height
	dw NO_SCRIPT ; Loading script (none)
	
StarthamInteractions::
	db 12
	
	db WALK_LOADZONE
	interact_box $0048, $0000, 25, 21
	db THREAD2_LOADINGWALKLEFT
	db 0
	db MAP_STARTHAM_FOREST
	ds 7
	
	db BTN_LOADZONE
	interact_box $009F, $0052, 1, 12
	db THREAD2_OPENDOOR
	db 0 ; Dest warp point
	db MAP_PLAYER_HOUSE ; Dest map
	ds 7
	
	db BTN_LOADZONE
	interact_box $004F, $0092, 1, 12
	db THREAD2_OPENDOOR
	db 0
	db MAP_TEST_HOUSE
	ds 7
	
	db BTN_LOADZONE
	interact_box $004F, $0042, 1, 12
	db THREAD2_OPENDOOR
	db 0
	db MAP_STARTHAM_HOUSE_2
	ds 7
	
	db BTN_LOADZONE | FLAG_DEP
	flag_dep FLAG_SET, FLAG_STARTHAM_LARGE_HOUSE_UNLOCKED
	interact_box $005F, $00D2, 1, 12
	db THREAD2_OPENDOOR
	db 0
	db MAP_STARTHAM_LARGE_HOUSE
	ds 7
	
	db BTN_INTERACT | FLAG_DEP
	flag_dep FLAG_RESET, FLAG_STARTHAM_LARGE_HOUSE_UNLOCKED
	interact_box $005F, $00D2, 1, 12
	dw StarthamLockedHouseText
	ds 8
	
	db BTN_INTERACT
	interact_box $0090, $0130, 16, 16
	dw StarthamSignText ; Text ptr
	ds 8
	
	db BTN_INTERACT
	interact_box $0060, $00E0, 16, 16
	dw StarthamHouseForSaleSign
	ds 8
	
	db BTN_INTERACT
	interact_box $0050, $0050, 16, 16
	dw StarthamEmptySign
	ds 8
	
	db WALK_INTERACT | FLAG_DEP
	flag_dep FLAG_RESET, FLAG_STARTHAM_SIBLING_ENTERED
	interact_box $0098, $0050, 1, 1
	dw StarthamMeetSiblingCutscene
	ds 8
	
	db WALK_INTERACT
	interact_box $FFF8, $013E, 16, 5
	dw StarthamUnfinishedNorthConnection
	ds 8
	
	db WALK_INTERACT
	interact_box $0100, $0142, 16, 5
	dw StarthamUnfinishedSouthConnection
	ds 8
	
StarthamNPCs::
	db 3 ; Number of NPCs
	
	dw 0 ; No flag dependency
	interact_box $00B3, $00D8, 16, 16
	db 1 ; Interaction ID
	db $01 << 2 | DIR_DOWN ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $F4 ; Movement permissions
	db $01 ; Movement speed
	
	; Parzival
	dw 0 ; No flag dependency
	interact_box $0110, $01C0, 16, 16
	db 0 ; Interaction ID
	db $01 << 2 | DIR_DOWN
	dn 1, 1, 1, 1
	db 0
	db 0
	
	; Sibling (cutscene-only)
	flag_dep FLAG_RESET, FLAG_STARTHAM_SIBLING_ENTERED
	interact_box $0098, $0060, 0, 0
	db 0
	db 2 << 2 | DIR_UP
	dn 2, 2, 2, 2
	db 0
	db 0
	
	db $02 ; Number of NPC scripts
	dw StarthamNPCScripts
	
	db 2 ; Number of NPC tile sets
	full_ptr GenericBoyATiles
	db 0
	
StarthamWarpToPoints::
	db 5 ; Number of warp-to points
	
	dw $0048 ; Y pos
	dw $0090 ; X pos
	db DIR_DOWN ; Direction
	db NO_WALKING ; Flags
	db 0 ; Cameraman ID
	db THREAD2_DISABLED
	dw NO_SCRIPT ; Loading script (none)
	ds 6
	
	dw $FFF8
	dw $0140
	db DIR_DOWN
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw NO_SCRIPT
	ds 6
	
	dw $0055
	dw $001E
	db DIR_RIGHT
	db KEEP_WALKING
	db 0
	db THREAD2_AFTERLOADINGWALKRIGHT
	dw NO_SCRIPT
	ds 6
	
	dw $0098
	dw $0050
	db DIR_DOWN
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw NO_SCRIPT
	ds 6
	
	dw $0048
	dw $0040
	db DIR_DOWN
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw NO_SCRIPT
	ds 6
	
StarthamBlocks::
INCBIN "maps/startham.blk"
	
	
StarthamNPCScripts::
	dw StarthamNPC0Script
	dw StarthamGenericBoyAScript
	
	set_text_prefix StarthamParzival
StarthamNPC0Script::
	print_name
	print_line_id 0
	wait_user
	print_line_id 1
	wait_user
	print_line_id 2
	print_line_id 3
	wait_user
	print_line_id 4
	print_line_id 5
	wait_user
	clear_box
	delay 60
	print_line_id 6
	delay 60
	print_line_id 7
	print_line_id 8
	print_line_id 9
	wait_user
	clear_box
	print_line_id 10
	delay 60
	print_line_id 11
	print_line_id 12
	wait_user
	print_line_id 13
	wait_user
	done
	
	set_text_prefix StarthamGenericBoyAScript
StarthamGenericBoyAScript::
	disp_box
	print_line_id 0
	print_line_id 1
	wait_user
	print_line_id 2
	print_line_id 3
	print_line_id 4
	wait_user
	clear_box
	print_line_id 5
	print_line_id 6
	wait_user
	done
	
	
	set_text_prefix StarthamLockedHouseText
StarthamLockedHouseText::
	disp_box
	print_line_id 0
	print_line_id 1
	wait_user
	print_line_id 2
	print_line_id 3
	print_line_id 4
	wait_user
	clear_box
	print_line_id 5
	print_line_id 6
	print_line_id 7
	wait_user
	done
	
	
	set_text_prefix StarthamSign
StarthamSignText::
	disp_box
	print_line_id 0
	wait_user
	clear_box
	print_line_id 1
	print_line_id 2
	print_line_id 3
	wait_user
	clear_box
	print_line_id 4
	delay 20
	print_line_id 5
	wait_user
	done
	
	
	set_text_prefix StarthamHouseForSaleSign
StarthamHouseForSaleSign::
	disp_box
	print_line_id 0
	wait_user
	print_line_id 1
	print_line_id 2
	wait_user
	clear_box
	print_line_id 3
	delay 20
	print_line_id 4
	wait_user
	clear_box
	print_line_id 5
	print_line_id 6
	print_line_id 7
	wait_user
	done
	
	
	set_text_prefix StarthamEmptySign
StarthamEmptySign::
	disp_box
	print_line_id 0
	print_line_id 1
	wait_user
	print_line_id 2
	wait_user
	done
	
	
	set_text_prefix StarthamMeetSiblingCutscene
StarthamMeetSiblingCutscene::
	delay 20
	turn_npc 2, DIR_LEFT
	delay 10
	print_name
	print_line_id 0
	delay 20
	turn_player DIR_RIGHT
	delay 40
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
	delay 20
	turn_player DIR_UP
	text_lda_imm THREAD2_OPENDOOR ; Start door-opening animation
	text_sta hThread2ID
	text_lda_imm $FF
	text_sta wCameramanID ; Freeze camera in place
	delay 30
	text_sta wYPos + 1
	make_npc_walk 2, DIR_LEFT, 16, 1
	delay 10
	turn_npc 2, DIR_UP
	delay 5
	text_lda_imm $FF
	text_sta wNPC3_ypos + 1
	text_asmcall ProcessNPCs
	delay 20
	text_asmcall RedrawMap ; Make door close
	delay 10
	text_set_flag FLAG_LOAD_CUTSCENE_NPCS
	load_map MAP_PLAYER_HOUSE, 0
	text_reset_flag FLAG_LOAD_CUTSCENE_NPCS
	
	; The cutscene continues, but in the house
	delay 5
	turn_player DIR_DOWN
	delay 10
	make_player_walk DIR_UP | ROTATE_45, 20, 1
	turn_player DIR_RIGHT
	delay 5
	make_npc_walk 1, DIR_UP, 66, 1
	turn_npc 1, DIR_RIGHT
	delay 20
	turn_npc 1, DIR_LEFT
	delay 20
	turn_npc 1, DIR_DOWN
	delay 10
	clear_box
	print_name
	print_line_id 8
	print_line_id 9
	make_player_walk DIR_UP, 20, 1
	turn_player DIR_RIGHT
	wait_user
	print_line_id 10
	print_line_id 11
	print_line_id 12
	wait_user
	clear_box
	turn_npc 1, DIR_LEFT
	delay 10
	print_line_id 13
	print_line_id 14
	wait_user
	print_line_id 15
	print_line_id 16
	wait_user
	clear_box
	delay 60
	print_line_id 17
	delay 30
	print_line_id 18
	wait_user
	print_line_id 19
	print_line_id 20
	wait_user
	print_line_id 21
	print_line_id 22
	wait_user
	close_box
	delay 10
	make_npc_walk 1, DIR_UP | ROTATE_45 | ROTATE_CW, 21, 1
	make_npc_walk 1, DIR_RIGHT, 35, 1
	turn_npc 1, DIR_UP
	text_set_flag FLAG_SIBLING_WATCHING_TV
	text_set_flag FLAG_STARTHAM_SIBLING_ENTERED
	done
	
	
	set_text_prefix StarthamUnfinishedMapText
StarthamUnfinishedNorthConnection::
	disp_box
	print_line_id 0
	print_line_id 1
	wait_user
	print_line_id 2
	print_line_id 3
	wait_user
	clear_box
	print_line_id 4
	print_line_id 5
	wait_user
	print_line_id 6
	print_line_id 7
	wait_user
	clear_box
	print_line_id 8
	print_line_id 9
	delay 30
	print_line_id 10
	wait_user
	close_box
	make_player_walk DIR_DOWN, 5, 1
	done
	
	set_text_prefix StarthamUnfinishedMapText
StarthamUnfinishedSouthConnection::
	disp_box
	print_line_id 0
	print_line_id 1
	wait_user
	print_line_id 2
	print_line_id 3
	wait_user
	clear_box
	print_line_id 4
	print_line_id 5
	wait_user
	print_line_id 6
	print_line_id 7
	wait_user
	clear_box
	print_line_id 8
	print_line_id 9
	delay 30
	print_line_id 10
	wait_user
	close_box
	make_player_walk DIR_UP, 5, 1
	done
