	
SECTION "Startham map", ROMX
	
StarthamMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db TILESET_TEST ; Tileset
	dw NO_SCRIPT ; Script (none)
	map_size 29, 18 ; Width, height
	dw NO_SCRIPT ; Loading script (none)
	
StarthamInteractions::
	db 7
	
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
	db 2 ; Number of NPCs
	
	interact_box $00B3, $00D8, 16, 16
	db 1 ; Interaction ID
	db $01 << 2 | DIR_DOWN ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $F4 ; Movement permissions
	db $01 ; Movement speed
	
	interact_box $0110, $01C0, 16, 16
	db 0 ; Interaction ID
	db $01 << 2 | DIR_DOWN
	dn 1, 1, 1, 1
	db 0
	db 0
	
	db $02 ; Number of NPC scripts
	dw StarthamNPCScripts
	
	db $01 ; Number of NPC tile sets
	dw GenericBoyATiles
	
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

GenericBoyATiles::
	dw $0303, $0F0F, $1F1F, $1F1F, $3F3F, $3F3F, $3F3F, $3F3F
	dw $3F3F, $191F, $263D, $2D3A, $1B1C, $0F0E, $0D0B, $0606
	dw $C0C0, $F0F0, $F8F8, $F8F8, $FCFC, $FCFC, $FCFC, $FCFC
	dw $FCFC, $98F8, $64BC, $B45C, $D838, $F070, $B0D0, $6060
	
	dw $0303, $0F0F, $1F1F, $1F1F, $3F3F, $3F3F, $393F, $2A3F
	dw $223F, $181F, $273F, $2E35, $1F18, $0F0E, $0D0B, $0606
	dw $C0C0, $F0F0, $F8F8, $F8F8, $FCFC, $FCFC, $9CFC, $54FC
	dw $44FC, $18F8, $E4FC, $74AC, $F818, $F070, $B0D0, $6060
	
	dw $0303, $0F0F, $1F1F, $3F3F, $3F3F, $131F, $151F, $141F
	dw $101F, $080F, $0707, $0704, $0605, $0203, $0704, $0303
	dw $C0C0, $F0F0, $F8F8, $FCFC, $FCFC, $FCFC, $FCFC, $F8F8
	dw $38F8, $30F0, $E0E0, $90F0, $D070, $20E0, $E020, $E0E0
	
GenericBoyAWalkingTiles::
	dw $0000, $0303, $0F0F, $1F1F, $1F1F, $3F3F, $3F3F, $3F3F
	dw $3F3F, $3F3F, $1A1F, $171C, $0F0A, $0B0C, $0D0B, $0606
	dw $0000, $C0C0, $F0F0, $F8F8, $F8F8, $FCFC, $FCFC, $FCFC
	dw $FCFC, $FCFC, $78F8, $E818, $C878, $B070, $C0C0, $0000
	
	dw $0000, $0303, $0F0F, $1F1F, $1F1F, $3F3F, $3F3F, $393F
	dw $2A3F, $223F, $181F, $171F, $1E19, $1F1E, $0D0B, $0606
	dw $0000, $C0C0, $F0F0, $F8F8, $F8F8, $FCFC, $FCFC, $FCFC
	dw $54FC, $44FC, $38F8, $C8F8, $68D8, $F070, $8080, $0000
	
	dw $0000, $0303, $0F0F, $1F1F, $3F3F, $3F3F, $131F, $151F
	dw $141F, $101F, $080F, $0707, $1D1F, $342F, $1F13, $0C0C
	dw $0000, $C0C0, $F0F0, $F8F8, $FCFC, $FCFC, $FCFC, $FCFC
	dw $F8F8, $38F8, $30F0, $E0E0, $F838, $E8B8, $F8C8, $3030
	
	
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
