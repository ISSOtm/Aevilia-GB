
SECTION "Player house map", ROMX
PlayerHouse::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db 0 ; Tileset is fixed
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 10, 9
	dw NO_SCRIPT ; No loading script
	
PlayerHouseInteractions::
	db 5
	
	db WALK_LOADZONE
	load_zone $0077, $003E, 10, 21, THREAD2_LOADINGWALKDOWN, 3, MAP_STARTHAM, SFX_STAIRS
	
	db WALK_LOADZONE
	load_zone $0008, $FFFE, 16, 16, THREAD2_LOADINGSTAIRSUP_LEFT, 0, MAP_PLAYER_HOUSE_2F, SFX_STAIRS
	
	db BTN_INTERACT
	interaction $0008, $0080, 16, 16, PlayerHouseTVScript
	
	db WALK_INTERACT | FLAG_DEP
	flag_dep FLAG_SET, FLAG_LOAD_CUTSCENE_NPCS
	interaction $0071, $003E, 16, 21, PlayerHouseDontLeaveScript
	
	db WALK_INTERACT | FLAG_DEP
	flag_dep FLAG_SET, FLAG_SIBLING_WATCHING_TV
	interaction $0071, $003E, 16, 21, PlayerHouseDontLeaveScript
	
PlayerHouseNPCs::
	db 3
	
	dw NO_FLAG_DEP
	npc $0060, $0000, 0, 0, 0, $0A, DIR_LEFT, 1, 1, 1, 1, 0, 0 ; Plant
	
	flag_dep FLAG_SET, FLAG_LOAD_CUTSCENE_NPCS
	npc $0090, $0048, 16, 16, 0, 1, DIR_UP, 2, 2, 2, 2, 0, 0 ; Sibling (temp)
	
	flag_dep FLAG_SET, FLAG_SIBLING_WATCHING_TV
	npc $0039, $0080, 16, 16, 0, 1, DIR_UP, 2, 2, 2, 2, 0, 0 ; Sibling (permanent, copy)
	
	db 1 ; Number of NPC scripts
	dw PlayerHouseNPCScripts ; Obligatory no matter the above value
	
	db 1 ; Number of NPC tile sets
	db 0 ; Special trigger : load opposite gender's tiles (if Evie, load Tom, etc.)
	
PlayerHousePalettes::
	dw InteriorMainPalette + 3 ; Used by the "floor-behind-potted-plants" NPCs ; skip color #0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	
PlayerHouseWarpToPoints::
	db 2 ; Number of warp-to points
	
	warp_to $0076, $0048, DIR_UP, NO_WALKING, 0, THREAD2_AFTERLOADINGWALKUP, NO_SCRIPT ; Startham
	
	warp_to $0010, $000F, DIR_RIGHT, NO_WALKING, 0, THREAD2_DISABLED, NO_SCRIPT ; 2F
	
PlayerHouseBlocks::
INCBIN "maps/playerhouse.blk"
	
	
PlayerHouseNPCScripts::
	dw PlayerHouseSiblingTVScript
	
	
	set_text_prefix PlayerHouseSiblingTVScript
PlayerHouseSiblingTVScript::
	print_name
	print_line_id 0
	print_line_id 1
	print_line_id 2
	wait_user
	print_line_id 3
	print_line_id 4
	wait_user
	print_line_id 5
	wait_user
	close_box
	turn_npc 1, DIR_UP
	done
	
	
	set_text_prefix PlayerHouseTV
PlayerHouseTVScript::
	text_get_flag FLAG_SIBLING_WATCHING_TV
.source1
	text_jr cond_nz, .branch1 - .source1
	
	; Watch TV
	disp_box
	print_line_id 0
	print_line_id 1
.source2
	choose YesNoChoice, .branch2 - .source2
	close_box
	make_player_walk_to VERTICAL_AXIS, $30, 1
	make_player_walk_to HORIZONTAL_AXIS, $0080, 1
	turn_player DIR_UP
	wait_user_no_sfx
	make_player_walk DIR_UP, 32, 1
	delay 30
	turn_player DIR_DOWN
	done
	
.branch2
	print_line_id 2
	wait_user
	done
	
	; Sibling watching TV
.branch1
	print_name
	print_line_id 3
	print_line_id 4
	print_line_id 5
	wait_user
	print_line_id 6
	print_line_id 7
	print_line_id 8
	wait_user
	close_box
	delay 10
	make_player_walk DIR_DOWN, $0005, 1
	make_player_walk DIR_DOWN | ROTATE_45 | ROTATE_CW, 36, 1
	delay 10
	turn_player DIR_RIGHT
	delay 40
	turn_player DIR_LEFT
	done
	
	
	set_text_prefix PlayerHouseDontLeaveScript
PlayerHouseDontLeaveScript::
	make_player_walk DIR_DOWN, 3, 1
	turn_npc 1, DIR_DOWN
	delay 5
	print_name
	print_line_id 0
	wait_user
	turn_player DIR_UP
	close_quick
	make_npc_walk 1, DIR_LEFT, 56, 1
	turn_npc 1, DIR_DOWN
	print_name
	print_line_id 1
	text_lda_imm $48
	text_sta wXPos
	make_player_walk DIR_UP, 40, 1
	print_line_id 2
	print_line_id 3
	print_line_id 4
	wait_user
	print_line_id 5
	wait_user
	clear_box
	print_line_id 6
	print_line_id 7
	wait_user
.source1
	choose OkayNoChoice, .branch1 - .source1
	; Okay
	clear_box
	print_line_id 8
	print_line_id 9
	wait_user
	clear_box
	print_line_id 15
	print_line_id 16
	wait_user
	print_line_id 20
	print_line_id 21
.source2
	text_jr .branch2 - .source2
	
.branch1
	; No
	clear_box
	print_line_id 10
	delay 30
	print_line_id 11
	print_line_id 12
	wait_user
	print_line_id 13
	print_line_id 14
	wait_user
	print_line_id 15
	print_line_id 16
	wait_user
	clear_box
	delay 30
	print_line_id 17
	print_line_id 18
	delay 40
	print_line_id 19
	
.branch2
	wait_user
	close_box
	set_counter 16
.branch3
	make_npc_walk 1, DIR_DOWN, 1, 1
.source3
	text_djnz .branch3 - .source3
	
	text_lda_imm $FF
	text_sta wNPC2_ypos + 1
	text_sta wWalkingInter0_ypos + 1
	text_reset_flag FLAG_SIBLING_WATCHING_TV
	clear_box
	disp_box
	print_line_id 22
	delay 60
	text_asmcall ProcessNPCs
	wait_user
	done
