	
SECTION "Test map", ROMX
	
StarthamMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db TILESET_TEST ; Tileset
	dw NO_SCRIPT ; Script (none)
	map_size 29, 17 ; Width, height
	dw NO_SCRIPT ; Loading script (none)
	
StarthamInteractions::
	db 7
	
	db BTN_LOADZONE
	interact_box $009F, $0052, 1, 12
	db MAP_PLAYER_HOUSE ; Dest map
	db 0 ; Dest warp point
	
	db BTN_LOADZONE
	interact_box $004F, $0092, 1, 12
	db MAP_TEST_HOUSE
	db 0
	
	db BTN_LOADZONE
	interact_box $004F, $0042, 1, 12
	db MAP_STARTHAM_HOUSE_2
	db 0
	
	db WALK_LOADZONE
	interact_box $0048, $0000, 25, 21
	db MAP_STARTHAM_FOREST
	db 0
	
	db BTN_INTERACT
	interact_box $0090, $0130, 16, 16
	dw StarthamSignText ; Text ptr
	
	db BTN_INTERACT
	interact_box $0060, $00E0, 16, 16
	dw StarthamHouseForSaleSign
	
	db BTN_INTERACT
	interact_box $0050, $0050, 16, 16
	dw StarthamHouseForSaleSign
	
StarthamNPCs::
	db 1 ; Number of NPCs
	
	interact_box $0020, $0020, 16, 16
	db 0 ; Interaction ID
	db $01 << 2 | DIR_DOWN ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $F4 ; Movement permissions
	db $01 ; Movement speed
	
	db $01 ; Number of NPC scripts
	dw StarthamNPCScripts
	
	db $01 ; Number of NPC tile sets
	dw TestNPCTiles
	
StarthamWarpToPoints::
	db 5 ; Number of warp-to points
	
	dw $0048 ; Y pos
	dw $0090 ; X pos
	db DIR_DOWN ; Direction
	db NO_WALKING ; Flags
	db 0 ; Cameraman ID
	dw NO_SCRIPT ; Loading script (none)
	ds 7
	
	dw $FFF8
	dw $0140
	db DIR_DOWN
	db NO_WALKING
	db 0
	dw NO_SCRIPT
	ds 7
	
	dw $0055
	dw $001E
	db DIR_RIGHT
	db KEEP_WALKING
	db 0
	dw NO_SCRIPT
	ds 7
	
	dw $0098
	dw $0050
	db DIR_DOWN
	db NO_WALKING
	db 0
	dw NO_SCRIPT
	ds 7
	
	dw $0048
	dw $0040
	db DIR_DOWN
	db NO_WALKING
	db 0
	dw NO_SCRIPT
	ds 7
	
StarthamBlocks::
INCBIN "maps/startham.blk"

StarthamNPCScripts::
	dw StarthamNPC0Script
	
	set_text_prefix StarthamNPC0
StarthamNPC0Script::
	print_name
	print_line_id 0
	print_line_id 1
	wait_user
	print_line_id 2
	print_line_id 3
	print_line_id 4
	wait_user
	clear_box
	print_line_id 5
	wait_user
	print_line_id 6
	print_line_id 7
	print_line_id 8
	wait_user
	clear_box
	print_line_id 9
	print_line_id 10
	print_line_id 11
	wait_user
	print_line_id 12
	wait_user
	clear_box
	print_line_id 13
	wait_user
	done

TestNPCTiles::
	dw $0000, $0000, $0202, $0404, $0000, $0303, $0407, $080F
	dw $101F, $101F, $101F, $101F, $080F, $0407, $0303, $0000
	dw $0000, $0000, $8080, $4040, $0000, $C0C0, $20E0, $10F0
	dw $08F8, $08F8, $08F8, $08F8, $10F0, $20E0, $C0C0, $0000
	
	dw $0000, $0000, $0202, $0404, $0000, $0303, $0407, $0A0F
	dw $121F, $121F, $101F, $101F, $090F, $0407, $0303, $0000
	dw $0000, $0000, $8080, $4040, $0000, $C0C0, $20E0, $90F0
	dw $88F8, $88F8, $08F8, $48F8, $90F0, $20E0, $C0C0, $0000
	
	dw $0000, $0000, $0404, $0202, $0000, $0303, $0407, $080F
	dw $141F, $141F, $141F, $101F, $0A0F, $0407, $0303, $0000
	dw $0000, $0000, $0000, $0000, $0000, $C0C0, $20E0, $10F0
	dw $08F8, $08F8, $08F8, $08F8, $10F0, $20E0, $C0C0, $0000
	
TestNPCWalkingTiles::
	dw $0202, $0404, $0000, $0303, $0407, $080F, $101F, $101F
	dw $101F, $101F, $080F, $0407, $0303, $0000, $0000, $0000
	dw $8080, $4040, $0000, $C0C0, $20E0, $10F0, $08F8, $08F8
	dw $08F8, $08F8, $10F0, $20E0, $C0C0, $0000, $0000, $0000
	
	dw $0202, $0404, $0000, $0303, $0407, $0A0F, $121F, $101F
	dw $131F, $121F, $090F, $0407, $0303, $0000, $0000, $0000
	dw $8080, $4040, $0000, $C0C0, $20E0, $90F0, $88F8, $08F8
	dw $C8F8, $48F8, $90F0, $20E0, $C0C0, $0000, $0000, $0000
	
	dw $0404, $0202, $0000, $0303, $0407, $080F, $141F, $141F
	dw $101F, $181F, $0407, $0407, $0303, $0000, $0000, $0000
	dw $0000, $0000, $0000, $C0C0, $20E0, $10F0, $08F8, $08F8
	dw $08F8, $08F8, $10F0, $20E0, $C0C0, $0000, $0000, $0000
	
	
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


SECTION "Test house map", ROMX
TestHouse::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db TILESET_TEST_HOUSE
	dw NO_SCRIPT ; No map script
	map_size 9, 6
	dw NO_SCRIPT ; No loading script
	
TestHouseInteractions::
	db 1
	
	db WALK_LOADZONE
	interact_box $004B, $002E, 6, 5
	db 0
	db 0
	
TestHouseNPCs::
	db 1
	
	interact_box $0020, $0020, 16, 16
	db 0
	db $01 << 2 + DIR_LEFT
	dn 1, 2, 1, 2
	db $00
	db $00
	
	db $01
	dw TestHouseNPCScripts
	
	db $01
	dw TestHouseNPCTiles
	
TestHouseWarpToPoints::
	db 1 ; Number of warp-to points
	
	dw $0041 ; Y pos
	dw $0030 ; X pos
	db DIR_UP ; Direction
	db NO_WALKING ; Flags
	db 0
	dw NO_SCRIPT ; Loading script (none)
	ds 7
	
TestHouseBlocks::
INCBIN "maps/testhouse.blk"
	
TestHouseNPCScripts::
	dw TestHouseTestBattleScript
	
	set_text_prefix TestHouseTestBattleScript
TestHouseTestBattleScript::
	text_bankswitch BANK(wTestWarriorFlags)
	text_lda wTestWarriorFlags
	text_bankswitch 1
	text_bit $80
	print_name
.source1
	text_jr cond_nz, (.branch1 - .source1)
	print_line_id 0
	delay 60
	wait_user
	clear_box
	print_line_id 1
	delay 100
	text_bankswitch BANK(wTestWarriorFlags)
	text_lda_imm $80
	text_sta wTestWarriorFlags
	text_bankswitch 1
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
	db 0
	db 2
	
	db WALK_INTERACT
	interact_box $0028, $0000, 9, 16
	dw TestForestEndOfDemo
	
	db BTN_INTERACT
	interact_box $00B0, $01C0, 16, 16
	dw TestForestEntranceSign
	
	db BTN_INTERACT
	interact_box $0020, $0050, 16, 16
	dw StarthamForestExitSign
	
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
INCBIN "maps/test_forest.blk"

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
