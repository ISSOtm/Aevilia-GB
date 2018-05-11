	
SECTION "Startham map", ROMX
	
StarthamMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db 0 ; Tileset is fixed
	db TILESET_OVERWORLD ; Tileset
	dw NO_SCRIPT ; Script (none)
	map_size 29, 18 ; Width, height
	dw NO_SCRIPT ; Loading script (none)
	
StarthamInteractions::
	db 13
	
	db WALK_LOADZONE
	load_zone $0048, $0000, 25, 21, THREAD2_LOADINGWALKLEFT, 0, MAP_STARTHAM_FOREST, SFX_NONE
	
	db WALK_INTERACT
	interaction $FFF8, $013E, 16, 5, StarthamUnfinishedNorthConnection
	
	db WALK_INTERACT
	interaction $0100, $013E, 16, 5, StarthamUnfinishedSouthConnection
	
	db BTN_LOADZONE
	load_zone $009F, $0052, 1, 12, THREAD2_OPENDOOR, 0, MAP_PLAYER_HOUSE, SFX_DOOR_OPEN
	
	db BTN_LOADZONE
	load_zone $004F, $0092, 1, 12, THREAD2_OPENDOOR, 0, MAP_TEST_HOUSE, SFX_DOOR_OPEN
	
	db BTN_LOADZONE
	load_zone $004F, $0042, 1, 12, THREAD2_OPENDOOR, 0, MAP_STARTHAM_HOUSE_2, SFX_DOOR_OPEN
	
	db BTN_LOADZONE | FLAG_DEP
	flag_dep FLAG_SET, FLAG_STARTHAM_LARGE_HOUSE_UNLOCKED
	load_zone $005F, $00D2, 1, 12, THREAD2_OPENDOOR, 0, MAP_STARTHAM_LARGE_HOUSE, SFX_DOOR_OPEN
	
	db BTN_INTERACT | FLAG_DEP
	flag_dep FLAG_RESET, FLAG_STARTHAM_LARGE_HOUSE_UNLOCKED
	interaction $005F, $00D2, 1, 12, StarthamLockedHouseText
	
	db BTN_INTERACT
	interaction $0090, $0130, 16, 16, StarthamSignText
	
	db BTN_INTERACT
	interaction $0060, $00E0, 16, 16, StarthamHouseForSaleSign
	
	db BTN_INTERACT
	interaction $0050, $0050, 16, 16, StarthamEmptySign
	
	db BTN_INTERACT
	interaction $00A0, $0040, 16, 16, StarthamDevEdTestScript
	
	db WALK_INTERACT | FLAG_DEP
	flag_dep FLAG_RESET, FLAG_STARTHAM_SIBLING_ENTERED
	interaction $0098, $0050, 1, 1, StarthamMeetSiblingCutscene
	
StarthamNPCs::
	db 3 ; Number of NPCs
	
	dw NO_FLAG_DEP ; No flag dependency
	npc $00B3, $00D8, 16, 16, 1, $01, DIR_DOWN, 1, 1, 1, 1, $F4, 1 ; Generic inhabitant
	
	dw NO_FLAG_DEP
	npc $0110, $01C0, 16, 16, 0, $01, DIR_DOWN, 1, 1, 1, 1, 0, 0 ; Parzival
	
	flag_dep FLAG_RESET, FLAG_STARTHAM_SIBLING_ENTERED
	npc $0098, $0060, 0, 0, 0, 2, DIR_UP, 2, 2, 2, 2, 0, 0 ; Sibling (cutscene-only)
	
	db $02 ; Number of NPC scripts
	dw StarthamNPCScripts
	
	db 3 ; Number of NPC tile sets
	full_ptr GenericBoyATiles
	db 0
	full_ptr KasumiTiles
	
StarthamPalettes::
	dw GenericBoyAPalette
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	dw 0
	
StarthamWarpToPoints::
	db 5 ; Number of warp-to points
	
	warp_to $0048, $0090, DIR_DOWN, NO_WALKING, 0, THREAD2_DISABLED, NO_SCRIPT ; Test house
	
	warp_to $FFF8, $0140, DIR_DOWN, NO_WALKING, 0, THREAD2_DISABLED, NO_SCRIPT ; Old intro entry point
	
	warp_to $0055, $001E, DIR_RIGHT, KEEP_WALKING, 0, THREAD2_AFTERLOADINGWALKRIGHT, NO_SCRIPT ; Startham forest
	
	warp_to $0098, $0050, DIR_DOWN, NO_WALKING, 0, THREAD2_DISABLED, NO_SCRIPT ; Player house
	
	warp_to $0048, $0040, DIR_DOWN, NO_WALKING, 0, THREAD2_DISABLED, NO_SCRIPT ; Startham house 2
	
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
	play_sfx	SFX_DOOR_OPEN
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

	set_text_prefix	DevEdTestScript
StarthamDevEdTestScript::
	play_sfx SFX_PHONE_RINGING
	wait_sfx
	delay 30
	disp_box
	
	print_line_id 0
	print_line_id 1
	print_line_id 2
	wait_user
	clear_box
	print_line_id 3
	print_line_id 4
	fake_choice YesNoChoice
	clear_box
	delay 30
	
	text_lda_imm	2
	text_sta	hScreenShakeAmplitude
	play_sfx SFX_BATTLE_THUD
	start_animation 0, PlayerJumpingAnimation
	play_animations $F8 | 0
	text_lda_imm	0
	text_sta	hScreenShakeAmplitude
	wait_sfx
	
	delay 120
	print_line_id 5
	print_line_id 6
	print_line_id 7
	wait_user
	wait_sfx
	play_sfx SFX_PHONE_HANG_UP
	print_line_id 8
	delay 60
	done
	
	
SECTION "Player jumping animation", ROMX

PlayerJumpingAnimation::
	db 2
	anim_copy_tiles ShadowTile, 1, $7F, 1
	anim_set_tiles 0, 2, $7F, 0
	anim_set_pos 0, 2, 60, 60
	anim_set_attribs 0, 2, $08, $60
	
; sorry about the mess! - DevEd
.movePlayer
	anim_move_player -3, 0
	pause 1
	anim_move_player -3, 0
	pause 1
	anim_move_player -2, 0
	pause 1
	anim_move_player -2, 0
	pause 1
	anim_move_player -1, 0
	pause 1
	anim_move_player -1, 0
	pause 3
	anim_move_player 1, 0
	pause 1
	anim_move_player 1, 0
	pause 1
	anim_move_player 2, 0
	pause 1
	anim_move_player 2, 0
	pause 1
	anim_move_player 3, 0
	pause 1
	anim_move_player 3, 0
	done
	
