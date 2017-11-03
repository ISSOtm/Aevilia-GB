
SECTION "Player house 2F map", ROMX
PlayerHouse2F::
	db $80 ; Interior map
	
	db MUSIC_SAFE_PLACE ; Music ID
	
	db 1 ; Tileset is dependent
	dw PlayerHouse2FTilesetScript
	dw NO_SCRIPT ; No map script
	map_size 10, 9
	dw NO_SCRIPT ; No loading script
	
PlayerHouse2FInteractions::
	db 2
	
	db WALK_LOADZONE
	interact_box $0008, $FFFE, 16, 16
	db THREAD2_LOADINGSTAIRSDOWN_LEFT
	db 1
	db MAP_PLAYER_HOUSE
	ds 7
	
	db WALK_INTERACT | FLAG_DEP
	flag_dep FLAG_RESET, FLAG_INTRO_CUTSCENE_PLAYED
	interact_box $0010, $0090, 1, 1
	dw TestIntroCutscene
	ds 8
	
PlayerHouse2FNPCs::
	db 3
	
	dw 0
	interact_box $0040, $0030, 0, 0
	db 0 ; Interaction ID
	db $0A << 2 | DIR_LEFT ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $00 ; Movement permissions
	db $00 ; Movement speed
	
	dw 0
	interact_box $0050, $0050, 0, 0
	db 0 ; Interaction ID
	db $0A << 2 | DIR_LEFT ; Sprite ID & direction
	dn 1, 1, 1, 1 ; Palette IDs
	db $00 ; Movement permissions
	db $00 ; Movement speed
	
	flag_dep FLAG_RESET, FLAG_INTRO_CUTSCENE_PLAYED
	interact_box $0002, $0089, 0, 0
	db 0
	db 1 << 2 | DIR_UP
	dn 4, 4, 4, 4
	db 0
	db 0
	
	db 0 ; Number of NPC scripts
	dw 0 ; Obligatory no matter the above value
	
	db 1 ; Number of NPC tile sets
	full_ptr InteriorBlanketCoverTile
	
PlayerHouse2FWarpToPoints::
	db 2 ; Number of warp-to points
	
	dw $0009
	dw $000F
	db DIR_RIGHT
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw NO_SCRIPT
	ds 6
	
	dw $0010
	dw $0090
	db DIR_DOWN
	db NO_WALKING
	db 0
	db THREAD2_DISABLED
	dw PlayerHouse2FLoadIntroGfx
	ds 6
	
PlayerHouse2FBlocks::
INCBIN "maps/playerhouse2f.blk"
	
PlayerHouse2FTilesetScript::
	ld de, FLAG_INTRO_CUTSCENE_PLAYED
	call GetFlag
	ld a, TILESET_INTERIOR_DARK
	ret nc ; If the cutscene hasn't played yet, use the dimmed tileset instead
	ld a, TILESET_INTERIOR
	ret
	
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
.sleepingSource
	djnz .sleepingLoop - .sleepingSource
	
	set_fade_speed 3
	gfx_fadeout
	text_lda_imm $80
	text_sta wNPC3_ypos + 1
	text_asmcall IntroCutscene
	text_asmcall RedrawMap
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
	; Play "Click!" SFX
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
	text_lda hGFXFlags ; Don't commit the player palettes while the screen is black
	text_or $40
	text_sta hGFXFlags
	text_asmcall LoadPlayerGraphics ; To cancel the pajamas graphics
	text_and $BF
	text_sta hGFXFlags ; Commit palettes on loading
	text_lda_imm DIR_DOWN
	text_sta wPlayerDir
	gfx_fadein
	delay 30
	make_player_walk DIR_DOWN | ROTATE_45 | ROTATE_CW, 19, 1
	delay 10
	turn_player DIR_LEFT
	
	text_set_flag FLAG_INTRO_CUTSCENE_PLAYED
	set_fade_speed 0
	done
	
.lightUp
	ld a, TILESET_INTERIOR
	call LoadTileset
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
