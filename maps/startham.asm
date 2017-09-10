	
SECTION "Startham map", ROMX
	
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
	db THREAD2_DISABLED
	db 0 ; Dest warp point
	db MAP_PLAYER_HOUSE ; Dest map
	ds 7
	
	db BTN_LOADZONE
	interact_box $004F, $0092, 1, 12
	db THREAD2_DISABLED
	db 0
	db MAP_TEST_HOUSE
	ds 7
	
	db BTN_LOADZONE
	interact_box $004F, $0042, 1, 12
	db THREAD2_DISABLED
	db 0
	db MAP_STARTHAM_HOUSE_2
	ds 7
	
	db WALK_LOADZONE
	interact_box $0048, $0000, 25, 21
	db THREAD2_LOADINGWALKLEFT
	db 0
	db MAP_STARTHAM_FOREST
	ds 7
	
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
	db THREAD2_DISABLED
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
	
	
	set_text_prefix StarthamEmptySign
StarthamEmptySign::
	disp_box
	print_line_id 0
	print_line_id 1
	wait_user
	print_line_id 2
	wait_user
	done
