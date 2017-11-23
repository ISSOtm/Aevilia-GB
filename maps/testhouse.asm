

SECTION "Test house map", ROMX
TestHouse::
	db $80 ; Interior map
	
	db MUSIC_NEO_SAFE_PLACE ; Music ID
	
	db 0
	db TILESET_INTERIOR
	dw NO_SCRIPT ; No map script
	map_size 7, 6
	dw NO_SCRIPT ; No loading script
	
TestHouseInteractions::
	db 1
	
	db WALK_LOADZONE
	load_zone $004B, $002E, 6, 5, THREAD2_LOADINGWALKDOWN, 0, MAP_STARTHAM
	
TestHouseNPCs::
	db 2
	
	dw NO_FLAG_DEP
	npc $0020, $0020, 16, 16, 0, $01, DIR_LEFT, 1, 2, 1, 2, 0, 0 ; Test battle
	
	dw NO_FLAG_DEP
	npc $0030, $0060, 0, 0, 0, $0A, DIR_LEFT, 1, 1, 1, 1, 0, 0
	
	db 1
	dw TestHouseNPCScripts
	
	db 1
	full_ptr TestHouseNPCTiles
	
TestHouseWarpToPoints::
	db 1 ; Number of warp-to points
	
	warp_to $0041, $0030, DIR_UP, NO_WALKING, 0, THREAD2_AFTERLOADINGWALKUP, NO_SCRIPT ; Startham
	
TestHouseBlocks::
INCBIN "maps/testhouse.blk"
	
	
TestHouseNPCScripts::
	dw TestHouseTestBattleScript
	
	set_text_prefix TestHouseTestBattleScript
TestHouseTestBattleScript::
	text_get_flag FLAG_TEST_WARRIOR_SPOKE_ONCE
	print_name
.source1
	text_jr cond_nz, (.branch1 - .source1)
	print_line_id 0
	delay 60
	wait_user
	clear_box
	print_line_id 1
	delay 100
	text_set_flag FLAG_TEST_WARRIOR_SPOKE_ONCE
	print_line_id 2
	empty_line
	empty_line
.source2
	choose YesNoChoice, (.branch2 - .source2)
	clear_box
	print_line_id 3
	print_line_id 4
	wait_user
	clear_box
	print_line_id 5
	print_line_id 6
	print_line_id 7
	wait_user
	done
	
.branch2
	clear_box
	print_line_id 8
	print_line_id 9
	wait_user
	clear_box
	print_line_id 5
	print_line_id 6
	print_line_id 7
	wait_user
	clear_box
	print_line_id 10
	print_line_id 11
	print_line_id 12
	wait_user
	done
	
.branch1
	print_line_id 13
	wait_user
	clear_box
	print_line_id 1
	delay 60
	print_line_id 14
	wait_user
	print_line_id 15
	print_line_id 16
	empty_line
.source3
	choose YesNoChoice, (.branch3 - .source3)
	
	clear_box
	print_line_id 17
	delay 60
	text_lda_imm 0
	text_sta wBattleTransitionID
	text_inc
	text_sta wBattleEncounterID
	text_sta wBattlePreservedNPCs
	print_line_id 18
	print_line_id 19
	wait_user
	done
	
.branch3
	clear_box
	print_line_id 20
	delay 60
	print_line_id 21
	wait_user
	clear_box
	print_line_id 22
	delay 30
	print_line_id 23
	print_line_id 24
	wait_user
	done
	
TestHouseNPCTiles::
	dw $1010, $3C2C, $3F23, $1F1C, $3F20, $3F23, $3F3C, $3F21
	dw $3A3F, $151F, $2D3A, $2A3D, $1D1A, $0F0F, $0F09, $0606
	dw $0808, $3C34, $FCC4, $F838, $FC04, $FCC4, $FC3C, $FC84
	dw $5CFC, $A8F8, $54BC, $B45C, $58B8, $F0F0, $F090, $6060
	
	dw $1010, $3C2C, $3F23, $1F1C, $3F20, $3F26, $393F, $2A3F
	dw $223F, $181F, $273F, $2D36, $1A1D, $0F0F, $0F09, $0606
	dw $0808, $3C34, $FCC4, $F838, $FC04, $FC64, $9CFC, $54FC
	dw $44FC, $18F8, $E4FC, $74AC, $B858, $F0F0, $F090, $6060
	
	dw $0000, $0F0F, $1F11, $3F21, $3F3C, $171F, $151F, $151F
	dw $101F, $080F, $0707, $0605, $0506, $0203, $0704, $0303
	dw $8080, $F070, $F848, $FC4C, $FC34, $FCC4, $FC04, $F808
	dw $88F8, $90F0, $E0E0, $90F0, $50F0, $A060, $E020, $E0E0
	
	; No walking sprites, he doesn't move
	; That'll put some garbage data in VRAM bank 1, but who cares
	