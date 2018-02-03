
SECTION "Player house 2F map", ROMX
PlayerHouse2F::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db 1 ; Tileset is dependent
	dw PlayerHouse2FTilesetScript
	dw PlayerHouse2FHideDpad
	map_size 10, 9
	dw PlayerHouse2FSetupIntroCutscene
	
PlayerHouse2FInteractions::
	db 2
	
	db WALK_LOADZONE
	load_zone $0008, $FFFE, 16, 16, THREAD2_LOADINGSTAIRSDOWN_LEFT, 1, MAP_PLAYER_HOUSE, SFX_STAIRS
	
	db WALK_INTERACT | FLAG_DEP
	flag_dep FLAG_RESET, FLAG_INTRO_CUTSCENE_PLAYED
	interaction $0010, $0090, 1, 1, TestIntroCutscene
	
PlayerHouse2FNPCs::
	db 3
	
	dw NO_FLAG_DEP
	npc $0040, $0030, 0, 0, 0, $0A, DIR_LEFT, 1, 1, 1, 1, 0, 0 ; Top-left plant
	
	dw NO_FLAG_DEP
	npc $0050, $0050, 0, 0, 0, $0A, DIR_LEFT, 1, 1, 1, 1, 0, 0 ; Bottom-left plant
	
	flag_dep FLAG_RESET, FLAG_INTRO_CUTSCENE_PLAYED
	npc $0002, $0089, 0, 0, 0, 1, DIR_UP, 2, 2, 2, 2, 0, 0 ; ZZZ sprite
	
	db 0 ; Number of NPC scripts
	dw 0 ; Obligatory no matter the above value
	
	db 1 ; Number of NPC tile sets
	full_ptr InteriorBlanketCoverTile
	
PlayerHouse2FPalettes::
	dw InteriorMainPalette + 3 ; Used by the "floor-behind-potted-plants" NPCs ; skip color #0
	dw DefaultPalette
	dw InteriorWallPalette + 3
	dw 0
	dw 0
	dw 0
	dw 0
	
PlayerHouse2FWarpToPoints::
	db 2 ; Number of warp-to points
	
	warp_to $0009, $000F, DIR_RIGHT, NO_WALKING, 0, THREAD2_DISABLED, NO_SCRIPT ; Stairs from 1F
	
	warp_to $0010, $0090, DIR_DOWN, NO_WALKING, 0, THREAD2_DISABLED, PlayerHouse2FLoadIntroGfx ; Intro entry point
	
PlayerHouse2FBlocks::
INCBIN "maps/playerhouse2f.blk"
	
	
PlayerHouse2FTilesetScript::
	ld de, FLAG_INTRO_CUTSCENE_PLAYED
	call GetFlag
	ld a, TILESET_INTERIOR_DARK
	ret nc ; If the cutscene hasn't played yet, use the dimmed tileset instead
	ld a, TILESET_INTERIOR
	ret
	
PlayerHouse2FHideDpad::
	ld de, FLAG_2F_DPAD_HIDDEN
	call GetFlag
	ret c ; Don't do anything if the dpad has already been hidden
	ldh a, [hHeldButtons]
	and $F0
	ret z ; Wait until the player moves
	ld hl, wAnimation0_delay
	ld [hl], 0
	inc hl
	inc hl
	ld [hl], LOW(IntroHideDpadAnimation)
	inc hl
	ld [hl], HIGH(IntroHideDpadAnimation)
	ld de, FLAG_2F_DPAD_HIDDEN
	jp SetFlag
	
PlayerHouse2FSetupIntroCutscene::
	ld de, FLAG_INTRO_CUTSCENE_PLAYED
	call GetFlag
	ret c
	
	xor a
	ld [wChangeMusics], a ; This won't load the new music
	ld de, InteriorMainDarkPalette + 3
	ld c, 1
	callacross LoadOBJPalette_Hook
	ld de, InteriorWallDarkPalette + 3
	ld c, 3
	jpacross LoadOBJPalette_Hook
	
PlayerHouse2FLoadIntroGfx::
	ld hl, EvieSleepingPajamasTiles
	ld a, [wPlayerGender]
	and a
	jr z, .evie
	ld hl, TomSleepingPajamasTiles
.evie
	ld de, vPlayerTiles + 4 * VRAM_TILE_SIZE ; Overwrite "facing" frame
	ld bc, BANK(EvieSleepingPajamasTiles) << 8 | 4
	call TransferTilesAcross
PlayerHouse2FLoadBlanket::
	ld hl, .oam
	ld de, wVirtualOAM
	ld c, OAM_SPRITE_SIZE * 2
	rst copy
	ret
	
.oam
	dspr $1A, $90, $10, $03
	dspr $1A, $98, $10, $23
	
	
TestIntroCutscene::
	set_counter 3
.sleepingLoop
	delay 20
	make_player_walk DIR_DOWN, 1, 1
	delay 30
	make_npc_walk 2, DIR_RIGHT | ROTATE_45 | DONT_TURN, 1, 1
	delay 10
	make_player_walk DIR_UP | DONT_TURN, 1, 1
	delay 40
	make_npc_walk 2, DIR_LEFT | ROTATE_45 | DONT_TURN, 1, 1
	text_djnz_label .sleepingLoop
	
	set_fade_speed 3
	gfx_fadeout
	text_lda_imm $80
	text_sta wNPC3_ypos + 1
	text_asmcall MatrixPit
	text_asmcall RedrawMap
	text_asmcall PlayerHouse2FLoadBlanket
	text_asmcall ProcessNPCs ; Blanket needs to be loaded prior to this
	text_asmcall ReloadPalettes
	delay 30
	text_asmcall IntroLoadAwakePajamas
	delay 60
	turn_player DIR_LEFT
	delay 20
	turn_player DIR_RIGHT
	delay 20
	turn_player DIR_LEFT
	delay 120
	; Make player leave bed
	make_player_walk DIR_LEFT, 14, 1
	make_player_walk DIR_DOWN | DONT_TURN, 2, 2
	
	; Make player's eyes blink
	delay 60
	make_player_walk DIR_UP, 10, 1
	delay 20
	play_sfx SFX_PHONE_HANG_UP
	wait_sfx
	text_asmcall .lightUp
	delay 50
	turn_player DIR_DOWN
	delay 20
	make_player_walk DIR_DOWN | ROTATE_45 | ROTATE_CW, 16, 1
	make_player_walk DIR_LEFT, 34, 1
	delay 10
	turn_player DIR_UP
	delay 20
	set_fade_speed $81
	gfx_fadeout
	text_lda hGFXFlags ; Don't commit the palettes while the screen is black
	text_or $40
	text_sta hGFXFlags
	text_asmcall LoadPlayerGraphics ; To cancel the pajamas graphics
	text_and $BF
	text_sta hGFXFlags ; Commit palettes on loading
	text_lda_imm DIR_DOWN
	text_sta wPlayerDir
	gfx_fadein
	fade_music MUSICFADE_IN
	play_music MUSIC_SAFE_PLACE
	delay 30
	make_player_walk DIR_DOWN | ROTATE_45 | ROTATE_CW, 19, 1
	delay 10
	turn_player DIR_LEFT
	start_animation 0, IntroDpadAnimation
	
	text_set_flag FLAG_INTRO_CUTSCENE_PLAYED
	set_fade_speed 0
	done
	
.lightUp
	ld a, TILESET_INTERIOR
	call LoadTileset
	
	ld hl, hGFXFlags
	set 6, [hl]
	ld de, InteriorMainPalette + 3
	ld c, 1
	callacross LoadOBJPalette_Hook
	ld de, InteriorWallPalette + 3
	ld c, 3
	callacross LoadOBJPalette_Hook
	ld hl, hGFXFlags
	res 6, [hl]
	
	jpacross ReloadPalettes
	
SECTION "Intro awake gfx loader", ROMX

IntroLoadAwakePajamas::
	ld hl, EviePajamasTiles
	ld a, [wPlayerGender]
	and a
	jr z, .evie
	ld hl, TomPajamasTiles
.evie
	ld de, vPlayerTiles
	ld bc, BANK(EviePajamasTiles) << 8 | 12
	call TransferTilesAcross
	ld a, 1
	ld [rVBK], a
	ld hl, TomPajamasWalkingTiles
	ld a, [wPlayerGender]
	and a
	jr nz, .tom
	ld hl, EviePajamasWalkingTiles
.tom
	ld de, vPlayerWalkingTiles
	ld bc, BANK(EviePajamasWalkingTiles) << 8 | 12
	call TransferTilesAcross
	xor a
	ld [rVBK], a
	ret
	
SECTION "Intro D-pad animation", ROMX

IntroDpadAnimation::
	db 5
	anim_copy_tiles PlayerHouse2FDpadTiles, 0, $FD, 3
	anim_copy_sprites .oam, 0, 5
	anim_set_loop_counter 16
.moveDpadUp
	pause 1
	anim_move_spr 0, 5, -2, 0
	anim_djnz_label .moveDpadUp
.lock ; Dirty infinite loop
	pause 255
	anim_set_loop_counter 0
	anim_djnz_label .lock
	
.oam
	dspr SCREEN_HEIGHT * TILE_SIZE + 2 , 14, $FD, 4
	dspr SCREEN_HEIGHT * TILE_SIZE + 10,  6, $FE, 4
	dspr SCREEN_HEIGHT * TILE_SIZE + 10, 14, $FF, 4
	dspr SCREEN_HEIGHT * TILE_SIZE + 10, 22, $FE, $24
	dspr SCREEN_HEIGHT * TILE_SIZE + 18, 14, $FD, $44
	
IntroHideDpadAnimation::
	anim_set_loop_counter 16
	pause 20
.moveDpadDown
	pause 1
	anim_move_spr 0, 5, 2, 0
	anim_djnz_label .moveDpadDown
	done
