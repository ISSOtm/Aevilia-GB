	
SECTION "Test map", ROMX
	
TestMap::
	db 0 ; Exterior map
	
	db MUSIC_OVERWORLD ; Music ID
	
	db TILESET_TEST ; Tileset
	dw NO_SCRIPT ; Script (none)
	map_size 29, 17 ; Width, height
	dw NO_SCRIPT ; Loading script (none)
	
TestMapInteractions::
	db 3
	
	db BTN_INTERACT
	interact_box $0090, $0130, 16, 16
	dw TestMapSignText ; Text ptr
	
	db BTN_LOADZONE
	interact_box $009F, $0052, 1, 12
	db 1 ; Dest map
	db 0 ; Dest warp point
	
	db WALK_LOADZONE
	interact_box $0048, $0000, 25, 21
	db 3
	db 0
	
TestMapNPCs::
	db 1 ; Number of NPCs
	
	interact_box $0020, $0020, 16, 16
	db 0 ; Interaction ID
	db $01 << 2 | DIR_DOWN ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $F4 ; Movement permissions
	db $01 ; Movement speed
	
	db $01 ; Number of NPC scripts
	dw TestMapNPCScripts
	
	db $01 ; Number of NPC tile sets
	dw TestNPCTiles
	
TestMapWarpToPoints::
	db 3 ; Number of warp-to points
	
	dw $0098 ; Y pos
	dw $0050 ; X pos
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
	
TestMapBlocks::
INCBIN "maps/test.blk"

TestMapNPCScripts::
	dw TestMapNPC0Script
	
TestMapNPC0Script::
	print_name .name
	print_line .line0
	print_line .line1
	wait_user
	print_line .line2
	print_line .line3
	print_line .line4
	wait_user
	clear_box
	print_line .line5
	wait_user
	print_line .line6
	print_line .line7
	print_line .line8
	wait_user
	clear_box
	print_line .line9
	print_line .line10
	print_line .line11
	wait_user
	print_line .line12
	wait_user
	clear_box
	print_line .line13
	wait_user
	done
	
.name
	dstr "TEST #0"
	
.line0
	dstr "Heya! Did you know"
.line1
	dstr "you are a NPC?"
.line2
	db "At least, "
	dstr "what"
.line3
	dstr "that guy there is"
.line4
	dstr "seeing is."
.line5
	dstr "What guy?"
.line6
	dstr "That one watching"
.line7
	dstr "us through that"
.line8
	db "screen, there!",0
.line9
	db "Also, "
	dstr "aside from"
.line10
	db "you, "
	dstr "I am the"
.line11
	dstr "first NPC ever"
.line12
	dstr "created."
.line13
	db "Neat, "
	dstr "huh?"

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
	
	
TestMapSignText::
	disp_box
	print_line TestMapSignLine0
	print_line TestMapSignLine1
	wait_user
	print_line TestMapSignLine2
	print_line TestMapSignLine3
	empty_line
	wait_user
	clear_box
	print_line TestMapSignLine4
	print_line TestMapSignLine5
	print_line TestMapSignLine6
	wait_user
	clear_box
	delay 60
	print_line TestMapSignLine7
	print_line TestMapSignLine8
	wait_user
	done
	
TestMapSignLine0::
	db "Howdy, "
	dstr "fellow"
TestMapSignLine1::
	dstr "traveler!"
TestMapSignLine2::
	dstr "Welcome to the"
TestMapSignLine3::
	dstr "Test Map!"
TestMapSignLine4::
	dstr "Enjoy your stay"
TestMapSignLine5::
	dstr "in this strange"
TestMapSignLine6::
	dstr "place."
TestMapSignLine7::
	db "Also, "
	dstr "how on earth"
TestMapSignLine8::
	dstr "did you get here??"


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
	
TestHouseTestBattleScript::
	text_bankswitch BANK(wTestWarriorFlags)
	text_lda wTestWarriorFlags
	text_bankswitch 1
	text_bit $80
	print_name .name
.source1
	text_jr cond_nz, (.branch1 - .source1)
	print_line .line0
	delay 60
	wait_user
	clear_box
	print_line .line1
	delay 100
	text_bankswitch BANK(wTestWarriorFlags)
	text_lda_imm $80
	text_sta wTestWarriorFlags
	text_bankswitch 1
	print_line .line2
	empty_line
	empty_line
.source2
	choose YesNoChoice, (.branch2 - .source2)
	clear_box
	print_line .line3
	print_line .line4
	wait_user
	clear_box
	print_line .line5
	print_line .line6
	print_line .line7
	wait_user
	done
	
.branch2
	clear_box
	print_line .line8
	print_line .line9
	wait_user
	clear_box
	print_line .line5
	print_line .line6
	print_line .line7
	wait_user
	clear_box
	print_line .line10
	print_line .line11
	print_line .line12
	wait_user
	done
	
.branch1
	print_line .line13
	wait_user
	clear_box
	print_line .line1
	delay 60
	print_line .line14
	wait_user
	print_line .line15
	print_line .line16
	empty_line
.source3
	choose YesNoChoice, (.branch3 - .source3)
	
	clear_box
	print_line .line17
	delay 60
	text_lda_imm 0
	text_sta wBattleTransitionID
	text_inc
	text_sta wBattleEncounterID
	text_sta wBattlePreservedNPCs
	print_line .line18
	print_line .line19
	wait_user
	done
	
.branch3
	clear_box
	print_line .line20
	delay 60
	print_line .line21
	wait_user
	clear_box
	print_line .line22
	delay 30
	print_line .line23
	print_line .line24
	wait_user
	done
	
.name
	dstr "TEST WARRIOR"
.line0
	dstr "YARR!"
.line1
	dstr "..."
.line2
	dstr "Aren't you scared?"
.line3
	dstr "You don't look"
.line4
	dstr "very sincere..."
.line5
	dstr "I promise I won't"
.line6
	dstr "try to scare you"
.line7
	dstr "anymore."
	
.line8
	dstr "Oh! I am very"
.line9
	dstr "sorry!"
.line10
	dstr "I hope I didn't"
.line11
	dstr "make you angry or"
.line12
	dstr "anything..."
	
.line13
	db "Oh,"
	dstr " you again?"
.line14
	dstr "That look..."
.line15
	dstr "Are you looking"
.line16
	dstr "for a fight?"
	
.line17
	dstr "Well. Just..."
.line18
	dstr "Don't come crying"
.line19
	db "after, "
	dstr "okay?"
	
.line20
	dstr "Well."
.line21
	dstr "That's a relief."
.line22
	db "Actually,",0
.line23
	dstr "I don't like"
.line24
	dstr "to fight..."
	
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
	db 1
	
	db WALK_LOADZONE
	interact_box $0068, $01C6, 25, 14
	db 0
	db 2
	
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
	
;Like I said,
;if I could understand this,
;I'd have added 30 maps or
;more, by now. -P