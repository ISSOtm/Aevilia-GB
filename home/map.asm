

SECTION "Map loader", ROM0
	
	
LoadMap_FatalError::
	ld [wSaveA], a
	ld a, ERR_BAD_MAP
	jp FatalError
	
; Loads map #a
; Performs gfx fade-out,
; Loads map (meta-)data,
; Applies warp-to #[wTargetWarpID] (except if that's $FF),
; Performs gfx fade-in,
; and returns.
LoadMap::
	ld [wLoadedMap], a ; Write the current map's ID to WRAM
	ld d, a ; Save the ID
	
IF !DEF(GlitchMaps)
	cp NB_OF_MAPS ; Check for validity
	jr nc, LoadMap_FatalError ; Is not. ¯\_(ツ)_/¯
ENDC
	
	xor a
	ld [wChangeMusics], a ; By default, don't change musics
	inc a ; a = 1
	call SwitchRAMBanks
	
	ld a, BANK(MapROMBanks)
	rst bankswitch
	ld h, MapROMBanks >> 8
	ld l, d ; MapROMBanks is 256-byte aligned
	ld a, [hl] ; Get map ROM bank
	ld b, a ; Store for bankswitch just after
	ld [wLoadedMapROMBank], a ; Store it
	
	ld a, d
	add a, a ; 2 bytes per pointer
	
	add a, MapPointers & $FF
	ld l, a
	adc a, MapPointers >> 8 ; a = Hi + Lo + Carry
	sub l ; a = Hi + Carry, OK!
	ld h, a
	ld a, [hli] ; Set hl to map header's pointer
	ld h, [hl]
	ld l, a
	ld a, b ; We got all info we needed from MapROMBanks/MapPointers
	rst bankswitch ; Switch to map's ROM bank
	
	ld a, [hli] ; Read map's properties byte
	and $80 ; Filter map type (interior vs exterior)
	ld b, a
	ld a, [wFadeSpeed] ; Use fade speed previously set, so it can be customized
	and $7F
	or b ; If map is interior, set fadeout to black, otherwise it will be white
	ld [wFadeSpeed], a
	
	push hl ; Save read pointer, it will be destroyed by later operations
	ld a, [wCurrentMusicID] ; We will determine whether we have to fade the music out
	cp $FF ; Is there any music?
	jr z, .forceMutedMusic ; If not, we have to start the new music
	cp [hl] ; Compare to map's music ID
	jr z, .sameMusic ; If we have the same music, do nothing
.forceMutedMusic
	ld a, [hl]
	ld [wCurrentMusicID], a ; Store intended music ID
	ld a, 2
	ld [wChangeMusics], a ; Schedule music changing
	call DS_Fade ; Fade out and kill music once it's done (fade type 2)
.sameMusic
	
	callacross Fadeout
	
	; Clear OAM 'cause NPC code doesn't clear attribs, etc.
	; Has to be done AFTER fadeout to avoid graphical errors
	xor a
	ld [wNumOfSprites], a
	ld hl, wVirtualOAM
	ld c, OAM_SIZE
	rst fill
	inc a
	ld [wTransferSprites], a
	
	pop hl ; Get back read ptr
	inc hl
	
	; Tileset
	ld a, [wLoadedTileset]
	ld c, a
	ld a, [hli]
	cp c
	jp z, .tilesetAlreadyLoaded ; Too far for a jr...
	push hl
	ld c, a
	
	ld l, a
	ld h, TilesetROMBanks >> 8
	save_rom_bank
	ld a, BANK(TilesetROMBanks)
	rst bankswitch
	ld b, [hl] ; Save tileset's ROM bank
	
	ld a, c
	add a, a
	add a, TilesetPointers & $FF
	ld l, a
	adc a, TilesetPointers >> 8
	sub l
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, b
	rst bankswitch
	ld a, [hli] ; Get number of tiles
	push af ; Save for bank 1 copy
	dec a
	bit 7, a ; If there are bank 1 tiles, this will be set
	jr z, .onlyBank0Tiles
	ld a, $7F
.onlyBank0Tiles
	inc a
	push hl
	ld de, VRAM_TILE_SIZE
	call MultiplyDEByA
	ld b, h ; Get copy length
	ld c, l
	pop hl
	ld de, v0Tiles1
	call CopyToVRAM ; Copy tiles
	
	pop af ; Get back number of tiles
	sub $81
	jr c, .noBank1Copy ; If < $81, there are only bank 0 tiles
	inc a ; a = nb_tiles - $80
	push hl
	ld de, VRAM_TILE_SIZE
	call MultiplyDEByA
	ld b, h
	ld c, l
	pop hl
	ld a, BANK(v1Tiles1)
	ld [rVBK], a
	ld de, v1Tiles1
	call CopyToVRAM
	xor a
	ld [rVBK], a
.noBank1Copy
	
	ld a, BANK(wBlockMetadata)
	call SwitchRAMBanks
	ld de, wBlockMetadata
	ld bc, (wTileAttributesEnd - wBlockMetadata)
	call Copy ; Copy block metadata
	
	ld a, [hli] ; Read number of tile animators
	ld de, wNumOfTileAnims
	ld [de], a
	and $0F ; Cap that
	jr z, .noAnimators
	ld b, a
	ld c, b
.copyAnimators ; This loop is a bit of an oddball : de points to the byte *just before* the target
	; It's no problem by any means, just not what you'd be used to.
	xor a
	inc de
	ld [de], a ; Write frame count
	ld a, [hli]
	inc de
	ld [de], a ; Write max frame
	xor a
	inc de
	ld [de], a ; Write current animation frame
	ld a, [hli]
	inc de
	ld [de], a ; Write max anim frame
	ld a, [hli]
	inc de
	ld [de], a ; Write tile ID
	ld a, [hli]
	inc de
	ld [de], a ; Write temporary pointer (real one will be computed after copies)
	ld a, [hli]
	inc de
	ld [de], a
	inc de ; Skip over unused byte
	dec c
	jr nz, .copyAnimators
	
	; Now, copy all animation frames to WRAM bank 3
	push hl
	ld hl, wTileAnim0_framesPtr + 1
	ld de, wTileFrames
.copyAnimationFrames
	push bc
	
	; Now, a slightly tricky part : we need to write the pointer before the copy (since that's where the base pointer is)
	; but at the same time we need to retrieve the pointer that's the source of the copy!
	ld b, [hl]
	ld [hl], e ; Write pointer to anim frames (which is big-endian)
	dec hl
	ld c, [hl]
	ld [hl], d
	; So, the source pointer is in bc.
	
	dec hl
	dec hl
	ld a, [hli] ; Get num of frames
	; Note : using hli when not necessary? Yup, but if it happened to overflow, we skip a "noCarry", so it's good.
	
	push hl ; Save the read pointer for later
	ld h, b ; Get the source pointer into hl,
	ld l, c ; which also frees bc.
	
	swap a ; Compute length of copy
	ld c, a ; Save this because we can't read it again!
	and $0F
	ld b, a
	ld a, c ; Get back unmasked low byte
	and $F0
	ld c, a ; Done calculating.
	
	ld a, BANK(wTileFrames)
	call SwitchRAMBanks
	call Copy ; Copy anim frames from ROM to WRAM
	; This advances de, which is then set up for the next animator
	
	ld a, BANK(wTileAnimations)
	call SwitchRAMBanks
	
	pop hl ; Get back read ptr
	; Move to next tile
	ld a, l
	add a, (wTileAnim1_framesPtr + 1) - (wTileAnim0_numOfFrames + 1)
	ld l, a
	jr nc, .noCarryAnim
	inc h
.noCarryAnim
	
	pop bc
	dec b
	jr nz, .copyAnimationFrames
	pop hl
.noAnimators
	
	ld de, wBGPalette7_color0
	ld c, 12
	rst copy
	push hl
	save_rom_bank
	ld a, BANK(DefaultPalette)
	rst bankswitch
	
	ld hl, wBGPalette7_color0
	ld de, wBGPalette2_color0
.loadTilesetBGPalettes
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld c, BG_PALETTE_STRUCT_SIZE
	rst copy
	pop hl
	inc hl
	ld a, e
	cp wOBJPalettes & $FF
	jr nz, .loadTilesetBGPalettes
	
	restore_rom_bank
	pop hl
	ld de, wOBJPalette7_color0
	ld c, 14
	rst copy
;	push hl
;	save_rom_bank
	ld a, BANK(DefaultPalette)
	rst bankswitch
	
	ld hl, wOBJPalette7_color0
	ld de, wOBJPalette1_color0
.loadTilesetOBJPalettes
	inc de
	inc de
	inc de
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld c, OBJ_PALETTE_STRUCT_SIZE
	rst copy
	pop hl
	inc hl
	ld a, e
	cp wPalettesEnd & $FF
	jr nz, .loadTilesetOBJPalettes
	
;	restore_rom_bank
;	pop hl
	
	; Insert more code here
	; (If so, uncomment the above block of code and the corresponding one above)
	
	restore_rom_bank
	pop hl
.tilesetAlreadyLoaded
	
	ld de, wMapScriptPtr ; Copy this data
	ld c, 4
	rst copy
	
	ld c, [hl] ; Get loading script
	inc hl
	ld b, [hl]
	inc hl
	push bc
	
	xor a
	ld de, wWalkInterCount
	ld c, 4
.clearInteractionsLoop
	ld [de], a
	inc de
	dec c
	jr nz, .clearInteractionsLoop
	
	ld a, [hli]
	and a
	jr z, .noInteractions
	ld b, a
.copyInteractions
	ld d, wWalkInterCount >> 8
	ld e, [hl]
	ld a, [de]
	inc a
	ld [de], a
	dec a
	add a, a
	add a, a
	add a, a
	ld e, a
	dec d ; de points to wWalkingLoadZones + struct offset
	ld a, [hli]
	rra
	jr nc, .walkingThingy
	set 7, e
.walkingThingy
	and a
	jr nz, .loadZone
	dec d
.loadZone
	ld c, INTERACTION_STRUCT_SIZE
	rst copy
	dec b
	jr nz, .copyInteractions
.noInteractions
	
	ld a, [hli] ; Get NPC count
	and $07 ; Failsafe!
	ld [wNumOfNPCs], a
	jr z, .noNPCs
	ld de, wNPC1_ypos
	ld b, a
	ld a, [wTargetWarpID]
	inc a
	jr nz, .NPCLoadingLoop
	; Warp $FF overrides NPC loading
	inc hl ; Skip script loading
	inc hl
	inc hl
	ld a, b
	add a, a
	add a, b ; *3
	add a, a ; *6
	add a, a ; *12 (size of ROM NPC)
	add a, l
	ld l, a
	jr nc, .skipLoadingNPCs
	inc h
	jr .skipLoadingNPCs
.NPCLoadingLoop
	ld c, 10
	rst copy ; Copy position and hitbox and interaction ID and sprite ID and palettes
	xor a
	ld [de], a
	inc de
	ld c, 2
	rst copy ; Copy movement flags and speed
	ld a, $80
	ld [de], a ; Init vertical displacement
	inc de
	xor a
	ld [de], a ; Init unused byte
	inc de
	ld a, $80
	ld [de], a ; Init horizontal displacement
	inc de
	dec b
	jr nz, .NPCLoadingLoop
	ld de, wNumOfNPCScripts
	ld c, 3
	rst copy ; Copy nb & ptr
.skipLoadingNPCs
	ld a, [hli] ; Get number of NPC tiles
	and $0F
	jr z, .noNPCTiles
	ld de, $80C0
	ld b, a
.NPCTilesLoop
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld c, $C0
	call CopyToVRAMLite
	ld a, 1
	ld [rVBK], a
	ld a, e
	sub $C0
	ld e, a
	jr nc, .noCarry0
	dec d
.noCarry0
	ld c, $C0
	call CopyToVRAMLite
	xor a
	ld [rVBK], a
	pop hl
	inc hl
	dec b
	jr nz, .NPCTilesLoop
.noNPCTiles
	
.noNPCs	
	push hl
	ld a, [hli] ; Get number of warp-to points
	ld c, a
	ld a, [wTargetWarpID]
	cp c
IF !DEF(GlitchMaps)
	jr nc, .checkWarpFF
ELSE
	jr nc, .doneWarping
ENDC
	
	add a, a
	add a, a
	add a, a
	add a, a
	jr nc, .noCarry1
	inc h
.noCarry1
	add a, l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
	ld a, $FF ; For saving, make sure to preserve player position
	ld [wTargetWarpID], a ; UNLESS THIS IS EXPLICITELY OVERRIDDEN
	ld de, wYPos
	ld c, 4
	rst copy
	
	ld a, [hli]
	ld b, a
	cp DIR_RIGHT + 1
	jr nc, .dontForcePlayerDir
	ld a, b
	ld [de], a ; Player direction
.dontForcePlayerDir
	ld a, [hli] ; Flags byte
	rrca
	ld b, a
	jr c, .dontResetPlayerAnim
	xor a
	ld [wNPC0_steps], a
.dontResetPlayerAnim
	
	; Now we're going to move the camera to the cameraman...
	ld a, [hli]
	inc de
	inc de
	ld [de], a ; wCameramanID
	push hl
	call MoveNPC0ToPlayer ; If camera is set to target player (ie. NPC0), move NPC0 to avoid camera moving incorrectly
	pop hl
	ld a, [wCameramanID]
	ld de, wYPos
	and $0F ; Somewhat of a failsafe, and also updates flags
	ld de, wNPC0_ypos
	swap a ; Mult by 16
	add a, e
	ld e, a
	ld bc, wCameraYPos
	ld a, [de]
	sub a, SCREEN_HEIGHT * 4 - 8
	ld [bc], a ; Camera Y pos, low
	inc de
	inc bc
	ld a, [de]
	sbc a, 0 ; Add carry
	ld [bc], a ; Camera Y pos, high
	inc de
	inc bc
	ld a, [de]
	sub a, SCREEN_WIDTH * 4 - 8
	ld [bc], a ; Camera X pos, low
	inc de
	inc bc
	ld a, [de]
	sbc a, 0
	ld [bc], a ; Camera X pos, high
	
	ld a, [hli] ; Loading script...
	ld h, [hl]
	ld l, a
	; Now, call "MoveCamera" to snap the camera at the map's boundaries
	; Otherwise redrawing gets screwed up
	push hl ; Save loading script ptr
	call MoveCamera
	pop hl ; get it back
	ld a, l
	or h
	jr nz, @+1 ; Call loading script if it's not NULL
	jr .doneWarping
.checkWarpFF
	inc a ; Check for warp $FF, which stands for "don't do any warp-related operation"
	jr z, .doneWarping
	dec a
	ld [wSaveA], a
	ld a, ERR_WRONG_WARP
	jp FatalError
.doneWarping
	
	pop hl
	ld a, [hli] ; Get back number of warps
	add a, a
	add a, a
	add a, a
	add a, a
	jr nc, .noCarry3
	inc h
.noCarry3
	add a, l
	ld l, a
	jr nc, .noCarry4
	inc h
.noCarry4 ; Skipped over all warp entries
	
	ld de, wBlockPointer
	ld a, l ; Get block pointer
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	
	pop hl
	ld a, l
	or h
	; Hack : this compiles as 20 FF
	; If the jump occurs, it will land on the $FF byte, which will execute a "rst callHL".
	; tl;dr : this is "rst nz, callHL" ^^
	jr nz, @+1
	
	ld a, [wCameraYPos]
	ld [wSCY], a
	ld a, [wCameraXPos]
	ld [wSCX], a
	call RedrawMap
	call MoveNPC0ToPlayer
	call ProcessNPCs
	
	ld a, [wChangeMusics]
	and a
	jr z, .stillSameMusic
.waitMusicIsDown
	rst waitVBlank
	ld a, [SoundEnabled]
	and a
	jr nz, .waitMusicIsDown
	ld a, [wCurrentMusicID]
	inc a
	jr z, .stillSameMusic ; Music $FF = no music
	dec a
	call DS_Init
	xor a
	ld [GlobalVolume], a
	inc a ; ld a, 1
	call DS_Fade
.stillSameMusic
	
	callacross Fadein
	xor a
	ld [wFadeSpeed], a
	ret
	
	
GetCameraTopLeftPtr::
	ld d, vTileMap0 >> 8
	ld a, [wCameraYPos]
	and $F0
	add a, a
	jr nc, .noCarry2
	inc d
	inc d
.noCarry2
	add a, a
	jr nc, .noCarry3
	inc d
.noCarry3
	ld b, a
	ld a, [wCameraXPos]
	and $F0
	rra
	rra
	rra
	add a, b ; Cannot overflow
	ld e, a
	ret
	
RedrawMap::
	ld hl, wCameraYPos
	ld a, [hli]
	and $F0
	ld e, a
	ld a, [hl]
	and $0F
	or e
	swap a
	ld e, a ; Divided by 16 : OK!
	ld a, [hli]
	and $F0
	swap a
	ld d, a ; Divided by 16 : OK!
	; de now contains the vertical block position
	
	ld a, [hli]
	and $F0
	ld c, a
	ld a, [hl]
	and $0F
	or c
	swap a
	ld c, a ; Divided by 16 : OK!
	ld a, [hli]
	and $F0
	swap a
	ld b, a ; Divided by 16 : OK!
	; bc now contains the horizontal position
	
	ld a, [wMapWidth]
	call MultiplyDEByA
	add hl, bc
	ld d, h
	ld e, l
	ld hl, wBlockPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	
	
	call GetCameraTopLeftPtr
	; Got VRAM destination
	ld b, 0
.redrawRow
	push hl
	ld c, 0
.redrawBlock
	ld a, [wMapWidth]
	dec a
	cp c
	jr c, .mapIsntWideEnough
	ld a, [wMapHeight]
	dec a
	cp b
	ld a, [hli] ; Get block ID
	jr nc, .mapIsTallEnough
.mapIsntWideEnough
	xor a ; If drawing to the right or the bottom of the map, draw block 0 instead
.mapIsTallEnough
	push hl
	call DrawBlock
	pop hl
	ld a, e
	sub a, VRAM_ROW_SIZE - 1
	ld e, a
	and (VRAM_ROW_SIZE - 1)
	jr nz, .noWrap1
	ld a, e
	sub VRAM_ROW_SIZE
	ld e, a
.noWrap1
	inc c
	ld a, c
	cp SCREEN_WIDTH / 2 + 1
	jr nz, .redrawBlock
	ld a, e
	add a, (VRAM_ROW_SIZE - 1) * 2 - SCREEN_WIDTH
	ld e, a
	jr nc, .noCarry4
	inc d
	ld a, d
	cp vTileMap1 >> 8
	jr nz, .noCarry4
	ld d, vTileMap0 >> 8
.noCarry4
	ld a, e
	and (VRAM_ROW_SIZE - 1)
	cp $0A
	jr c, .noWrap2
	ld a, e
	add a, VRAM_ROW_SIZE
	ld e, a
	jr nc, .noWrap2
	inc d
	ld a, d
	cp vTileMap1 >> 8
	jr nz, .noWrap2
	ld d, vTileMap0 >> 8
.noWrap2
	pop hl ; Get back pointer from last line
	ld a, [wMapWidth]
	add a, l
	ld l, a
	jr nc, .noCarry5
	inc h
.noCarry5
	inc b
	ld a, b
	cp SCREEN_HEIGHT / 2 + 1
	jr nz, .redrawRow
	ret
	
; Draw block with ID a at VRAM dest de.
; hl points to end of the block's metadata
; de points to last written tile, a equals zero
DrawBlock::
	ld h, wBlockMetadata >> 8
	add a, a
	add a, a
	add a, a
	jr nc, .noCarry
	inc h
.noCarry
	ld l, a ; 256-byte aligned : all's gewd here!
	
	xor a
	ld [rVBK], a
.waitVRAM1
	rst isVRAMOpen
	jr nz, .waitVRAM1
	ld a, [hli] ; Load tile 0
	ld [de], a
	ld a, 1
	ld [rVBK], a
.waitVRAM2
	rst isVRAMOpen
	jr nz, .waitVRAM2
	ld a, [hli]
	ld [de], a
	
	ld a, e
	add a, VRAM_ROW_SIZE
	ld e, a
	
	xor a
	ld [rVBK], a
.waitVRAM3
	rst isVRAMOpen
	jr nz, .waitVRAM3
	ld a, [hli] ; Load tile 1
	ld [de], a
	ld a, 1
	ld [rVBK], a
.waitVRAM4
	rst isVRAMOpen
	jr nz, .waitVRAM4
	ld a, [hli]
	ld [de], a
	
	ld a, e
	sub a, VRAM_ROW_SIZE - 1
	ld e, a
	
	xor a
	ld [rVBK], a
.waitVRAM5
	rst isVRAMOpen
	jr nz, .waitVRAM5
	ld a, [hli] ; Load tile 2
	ld [de], a
	ld a, 1
	ld [rVBK], a
.waitVRAM6
	rst isVRAMOpen
	jr nz, .waitVRAM6
	ld a, [hli]
	ld [de], a
	
	ld a, e
	add a, VRAM_ROW_SIZE
	ld e, a
	
	xor a
	ld [rVBK], a
.waitVRAM7
	rst isVRAMOpen
	jr nz, .waitVRAM7
	ld a, [hli] ; Load tile 3
	ld [de], a
	ld a, 1
	ld [rVBK], a
.waitVRAM8
	rst isVRAMOpen
	jr nz, .waitVRAM8
	ld a, [hli]
	ld [de], a
	
	xor a
	ld [rVBK], a
	
	ret
	
	
MoveNPC0ToPlayer::
	ld de, wNPCArray
	ld hl, wYPos
	ld c, 4
	rst copy
	
	ld de, wNPC0_sprite
	ld a, [hl]
	and $03
	ld [de], a
	ret
	
MoveCamera::
	ld a, [wCameramanID]
	call GetNPCOffsetFromCam
	
	ld hl, wTempBuf
	ld a, [hli]
	ld h, [hl]
	ld l, a ; Get vertical offset
	; Sub "SCREEN_HEIGHT * 8 / 2 - 8" to get intended position, plus MAX_CAM_SPEED for possible values to be 0 - MAX_CAM_SPEED * 2
	; (Simpler to process this way)
	ld bc, -(SCREEN_HEIGHT * 4) + 8 + MAX_CAM_SPEED
	add hl, bc ; hl = NPC's displacement from standard position + MAX_CAM_SPEED
	
	ld a, h
	add a, a
	jr c, .capSpeedVertNeg ; Actually, a displacement in range [32768-MAX_CAM_SPEED; 32767] will move the camera in the wrong direction
	jr nz, .capSpeedVert
	
	ld a, l
	cp MAX_CAM_SPEED * 2
	jr nc, .capSpeedVert
	
	; hl is valid, so we will give it the proper value and proceed
	sub MAX_CAM_SPEED
	ld l, a
	sbc a ; 0 if no carry, $FF if carry
	ld h, a
	jr .moveVertically
	
.capSpeedVertNeg
	ld hl, -MAX_CAM_SPEED
	jr .moveVertically
.capSpeedVert
	ld hl, MAX_CAM_SPEED
	
.moveVertically
	ld de, wCameraYPos
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a ; Get camera's position in bc
	push hl ; Save movement vector ; if redraw needed, MSB will determine whether to redraw left or right row
	add hl, bc ; Add movement vector
	bit 7, h ; If hl > 0, don't count carry
	jr z, .dontLockCamUp
	jr nc, .lockCamUp ; If moving up AND there's no carry (ie. camera crossed sign), lock camera at top
.dontLockCamUp
	; Check if camera's bottom is past the map's boundary
	ld a, [wMapHeight]
	sub a, SCREEN_HEIGHT / 2 ; Subtract the camera's height
	jr c, .lockCamUp
	jr z, .lockCamUp ; If the map is too small, no movement.
	swap a ; Multiply the size by 16
	ld b, a
	and $F0
	ld c, a
	ld a, b
	and $0F
	ld b, a
	ld a, h
	; bc contains the camera's max position (camera must be <= this)
	; Lock cam if hl > bc
	; ie bc - hl < 0
	cp b
	jr c, .dontLockCamVert ; if h < b, hl < bc
	jr nz, .lockCamDown ; if h > b, hl > bc
	ld a, c
	cp l
	jr nc, .dontLockCamVert
.lockCamDown
	; Lock camera to bottom
	ld h, b
	ld l, c
	jr .dontLockCamVert
.lockCamUp
	ld hl, 0 ; Lock camera at position 0
.dontLockCamVert
	ld a, h ; Write back (in reverse order!)
	ld [de], a
	dec de
	ld a, [de]
	ld c, a ; Get back current position to decide whether to redraw row or not
	ld a, l
	ld [de], a
	
	ld a, c
	and $F0
	ld c, a
	ld a, l
	and $F0
	cp c
	pop bc ; Get movement vector back, LSByte will be trashed but what counts is MSByte
	jr z, .dontRedrawRow
	ld hl, wTempBuf + 2
	ld de, wLargerBuf
	ld c, 2
	rst copy
	ld hl, wCameraYPos
	ld de, wTempBuf
	ld a, b
	add a, a ; Get MSB of movement vector in carry
	ld a, [hli]
	jr nc, .drawBottomRow ; No carry = moved right -> redraw bottom!
	ld [de], a
	inc de
	ld a, [hli]
	jr .rowTargetAcquired
.drawBottomRow
	add a, SCREEN_HEIGHT * 8
	ld [de], a
	inc de
	ld a, [hli]
	adc a, 0
.rowTargetAcquired
	ld [de], a
	inc de
	ld c, 2
	rst copy
	
	ld d, vTileMap0 >> 8
	ld a, [wTempBuf]
	and $F0
	add a, a
	jr nc, .noCarry1
	inc d
	inc d
.noCarry1
	add a, a
	jr nc, .noCarry2
	inc d
.noCarry2
	ld e, a
	ld a, [wTempBuf + 2]
	and $F0
	rrca
	rrca
	rrca
	add a, e
	ld e, a
	push de
	call GetPointerFromCoords
	pop de
	ld c, SCREEN_WIDTH / 2 + 1
.drawRowLoop
	ld a, [hli]
	push hl
	push de
	call DrawBlock
	pop de
	inc e
	inc e
	ld a, e
	and (VRAM_ROW_SIZE - 1)
	jr nz, .rowNoWrap
	ld a, e
	sub a, $20
	ld e, a
.rowNoWrap
	pop hl
	dec c
	jr nz, .drawRowLoop
	ld hl, wLargerBuf
	ld de, wTempBuf + 2
	ld c, 2
	rst copy
	ld de, wCameraYPos
.dontRedrawRow
	
	
	ld hl, wTempBuf + 2
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -(SCREEN_WIDTH * 4) + 8 + MAX_CAM_SPEED
	add hl, bc
	
	ld a, h
	add a, a
	jr c, .capSpeedHorizNeg
	jr nz, .capSpeedHoriz
	
	ld a, l
	cp MAX_CAM_SPEED * 2
	jr nc, .capSpeedHoriz
	
	sub MAX_CAM_SPEED
	ld l, a
	sbc a
	ld h, a
	jr .moveHorizontally
	
.capSpeedHorizNeg
	ld hl, -MAX_CAM_SPEED
	jr .moveHorizontally
.capSpeedHoriz
	ld hl, MAX_CAM_SPEED
	
.moveHorizontally
	inc de
	inc de
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	push hl ; Push for later redraw
	add hl, bc
	bit 7, h ; If hl > 0, don't count carry
	jr z, .dontLockCamLeft
	jr nc, .lockCamLeft ; If moving up AND there's no carry (ie. camera crossed sign), lock camera at top
.dontLockCamLeft
	; Check if camera's right is past the map's boundary
	ld a, [wMapWidth]
	sub a, SCREEN_WIDTH / 2 ; Subtract the camera's width
	jr c, .lockCamLeft
	jr z, .lockCamLeft ; If the map is too small, no movement.
	swap a ; Multiply the size by 16
	ld b, a
	and $F0
	ld c, a
	ld a, b
	and $0F
	ld b, a
	ld a, h
	; bc contains the camera's max position (camera must be <= this)
	; Lock cam if hl > bc
	; ie bc - hl < 0
	cp b
	jr c, .dontLockCamHoriz ; if h < b, hl < bc
	jr nz, .lockCamRight ; if h > b, hl > bc
	ld a, c
	cp l
	jr nc, .dontLockCamHoriz
.lockCamRight
	; Lock camera to right
	ld h, b
	ld l, c
	jr .dontLockCamHoriz
.lockCamLeft
	ld hl, 0 ; Lock camera at position 0
.dontLockCamHoriz
	ld a, h
	ld [de], a
	dec de
	ld a, [de]
	ld c, a ; Get back current position to decide whether to redraw row or not
	ld a, l
	ld [de], a
	
	ld a, c
	and $F0
	ld c, a
	ld a, l
	and $F0
	cp c
	pop bc ; Get back h in b. l doesn't matter
	ret z ; End all operations if we stay on same row
	
	ld hl, wCameraYPos
	ld de, wTempBuf
	ld c, 2
	rst copy
	ld a, b
	add a, a
	ld a, [hli]
	jr nc, .drawRightColumn
	ld [de], a
	inc de
	ld a, [hli]
	jr .columnTargetAcquired
.drawRightColumn
	add a, SCREEN_WIDTH * 8
	ld [de], a
	inc de
	ld a, [hli]
	adc a, 0
.columnTargetAcquired
	ld [de], a
	
	ld d, vTileMap0 >> 8
	ld a, [wTempBuf]
	and $F0
	add a, a
	jr nc, .noCarry3
	inc d
	inc d
.noCarry3
	add a, a
	jr nc, .noCarry4
	inc d
.noCarry4
	ld e, a
	ld a, [wTempBuf + 2]
	and $F0
	rrca
	rrca
	rrca
	add a, e
	ld e, a
	push de
	call GetPointerFromCoords
	pop de
	ld c, SCREEN_HEIGHT / 2 + 1
.drawColumnLoop
	ld a, [hl]
	push hl
	call DrawBlock
	ld a, VRAM_ROW_SIZE - 1
	add a, e
	ld e, a
	jr nc, .noCarry5
	inc d
	ld a, d
	cp vTileMap1 >> 8
	jr nz, .noCarry5
	; Wrap
	ld d, vTileMap0 >> 8
.noCarry5
	pop hl
	ld a, [wMapWidth]
	add a, l
	ld l, a
	jr nc, .noCarry6
	inc h
.noCarry6
	dec c
	jr nz, .drawColumnLoop
	ret
	
	
StopPlayerMovement::
	xor a
	ld [wNPC0_steps], a
	; Slide through to refresh sprites
	
	
; Aside from "THIS FUNCTION IS FUCKING HUUUUUGE", there's not much to say
; In fact, it's so huge there are a couple JRs in here that died because their target was too far away
ProcessNPCs::
	ld a, BANK(wVirtualOAM)
	call SwitchRAMBanks
	
	ld hl, wNPCArray
	ld de, wVirtualOAM
	ld a, [wNumOfNPCs]
	inc a ; Add player to the count, also makes sure this is not 0
	ld c, a
	
	ld b, 0
.processNPC
	push bc
	push hl
	push de
	ld a, b
	call GetNPCOffsetFromCam
	
	ld bc, wTempBuf
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a ; Get offset from wTempBuf
	inc bc
	ld hl, TILE_SIZE * 2
	add hl, de
	pop de ; Get back write ptr
	ld a, h
	and a ; Check if NPC has a pixel on-screen
	jp nz, .skipThisNPC ; Too far for a jr
	ld a, l
	cp SCREEN_HEIGHT * TILE_SIZE + TILE_SIZE * 2
	jp nc, .skipThisNPC
	
	ld a, [bc]
	add a, TILE_SIZE * 2
	ld h, a
	inc bc
	ld a, [bc]
	adc a, 0
	jp nz, .skipThisNPC ; Too far, too
	ld a, h
	cp SCREEN_WIDTH * TILE_SIZE + TILE_SIZE * 2
	jp nc, .skipThisNPC
	
	; Write sprite coords
	ld a, l
	ld [de], a ; Place offset
REPT 4
	inc de
ENDR
	add a, TILE_SIZE
	ld [de], a
REPT 4
	inc de
ENDR
	sub TILE_SIZE
	ld [de], a
REPT 4
	inc de
ENDR
	add a, TILE_SIZE
	ld [de], a
	inc de
	
	ld a, h
	ld [de], a
REPT 4
	dec de
ENDR
	ld [de], a
REPT 4
	dec de
ENDR
	sub a, TILE_SIZE
	ld [de], a
REPT 4
	dec de
ENDR
	ld [de], a
	inc de
	
	; Calculate sprite ID, direction etc.
	pop hl ; Get read pointer back
	push hl
	ld bc,  2 + 2 + 1 + 1 + 1 ; Y pos, X pos, Y hitbox, X hitbox, interact ID
	add hl, bc
	ld a, [hli] ; Get sprite ID & direction
	ld b, a ; Save this for ID extraction
	add a, a ; Mult by 2
	and 3 << 1 ; Get direction
	ld c, a
	
	ld a, b ; Extract ID
	and $7C ; Get sprite ID * 4
	ld b, a
	add a, a ; Mult by 3
	add a, b ; a = ID * 12
	ld b, a
	
	ld a, [hli] ; Get palette ID
	and $77
	
	inc hl
	inc hl
	bit 3, [hl] ; [hl]'s bit 3 contains if the NPC is walking or "frozen"
	dec hl
	ld d, 0 ; We will use the step counter to perform walking animations. d is known, so we can use it for storage.
	jr nz, .forceNoWalkingAnim ; If bit 3 is set, the NPC isn't walking so no anim
	ld d, [hl]
.forceNoWalkingAnim
	dec hl
	
	ld h, [hl] ; Store right palettes in h
	ld l, a ; Store left palettes in l
	ld a, h
	and $77
	ld h, a
	
	bit 3, d ; On some parts of a walk, change to a "walking" stance to play a "walking" animation
	jr z, .noWalkingAnim
	or $88 ; Change VRAM banks
	ld h, a
	ld a, l
	or $88
	ld l, a
	bit 2, c
	jr nz, .noWalkingAnim ; If facing up or down,
	bit 4, d ; (set this to 1 bit left of the "walking stance" bit)
	jr z, .noWalkingAnim ; half of the walking frames will be of the opposite direction (to create arms balancing)
	inc c ; Set bit 0 of c to mirror the bottom half
.noWalkingAnim
	ld d, wVirtualOAM >> 8 ; Restore
	
	ld a, c ; Get direction
	and 6
	cp DIR_RIGHT * 2
	jr nz, .notRight
	dec a
	dec a
	ld c, %1001 ; Set bits 0 and 3 of c to mirror both halves of sprite
.notRight
	add a, a ; Double the index (top is always on even IDs)
	add a, b ; Add the base index
	ld b, a
	bit 3, c
	jr z, .dontFlip1
	or 2
.dontFlip1
	ld [de], a
	inc de
	ld a, l
	swap a
	and %1111 ; Get palette ID and VRAM bank bit
	bit 3, c
	jr z, .dontFlip2
	set 5, a ; Set flip
.dontFlip2
	ld [de], a
REPT 3
	inc de
ENDR
	ld a, b
	bit 0, c
	jr z, .dontFlip3
	or 2
.dontFlip3
	inc a
	ld [de], a
	inc de
	ld a, l
	and %1111 ; Get palette ID and VRAM bank
	bit 0, c
	jr z, .dontFlip4
	set 5, a ; Set flip
.dontFlip4
	ld [de], a
REPT 3
	inc de
ENDR
	ld a, b
	or 2
	ld b, a
	bit 3, c
	jr z, .dontFlip5
	and 2 ^ $FF
.dontFlip5
	ld [de], a
	inc de
	ld a, h
	swap a
	and %1111 ; Get palette ID and VRAM bank
	bit 3, c
	jr z, .dontFlip6
	set 5, a ; Set flip
.dontFlip6
	ld [de], a
REPT 3
	inc de
ENDR
	ld a, b
	inc a
	bit 0, c
	jr z, .dontFlip7
	and 2 ^ $FF
.dontFlip7
	ld [de], a
	inc de
	ld a, h
	and %1111 ; Get palette ID and VRAM bank
	bit 0, c
	jr z, .dontFlip8
	set 5, a ; Set flip
.dontFlip8
	ld [de], a
	inc de
	
.skipThisNPC
	ld a, e
	and -OAM_SPRITE_SIZE ; Get on sprite boundary
	ld e, a
	pop hl
	ld a, l
	and -NPC_STRUCT_SIZE
	add a, NPC_STRUCT_SIZE
	ld l, a
	
	pop bc
	inc b
	ld a, b
	sub c
	jp nz, .processNPC ; Too far to jr...
	
	inc a
	ld [wTransferSprites], a
	; Now, we set the number of sprites...
	ld a, e
	rra
	and a
	rra
	ld [wNumOfSprites], a
	ret
	
	
; Get NPC #a's offset from the camera
GetNPCOffsetFromCam::
	add a, a
	add a, a
	add a, a
	add a, a
	add a, wNPC0_ypos & $FF
	ld l, a
	ld h, wNPC0_ypos >> 8
	; hl = Pointer to NPC's Y coord
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	; hl = NPC's Y coord
	
	ld bc, wCameraYPos
	ld a, [bc]
	cpl
	ld e, a
	inc bc
	ld a, [bc]
	cpl
	ld d, a
	inc bc
	inc de
	; de = - Camera's Y coord
	
	add hl, de ; Get NPC's Y offset
	ld de, wTempBuf
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a ; Store it
	
	pop hl
	inc hl ; hl = Pointer to NPC's X coord
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [bc]
	cpl
	ld e, a
	inc bc
	ld a, [bc]
	cpl
	ld d, a
	inc de
	; de = - Camera's X coord
	
	add hl, de ; Get offset
	ld de, wTempBuf + 2
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a ; Store it
	ret
	
	
; Move all NPCs according to their structs
MoveNPCs::
	ld de, NPC_STRUCT_SIZE
	ld a, [wNumOfNPCs]
	call MultiplyDEByA
	ld de, wNPC0_steps
	add hl, de
.moveNPC
	ld a, [hli]
	bit 2, [hl]
	jr z, .gotoNextNPC
	and a
	jr z, .NPCAtRest
	
	bit 3, [hl]
	jr z, .NPCIsMoving
	
	dec hl
	dec a ; Decrement waiting counter
	ld [hli], a ; Store
	jr nz, .gotoNextNPC
	res 3, [hl] ; Unfreeze NPC if waiting is done
	jr .gotoNextNPC
	
.NPCIsMoving
	ld b, a ; Store number of steps
	ld e, [hl] ; Store direction
	inc hl
	
	ld d, [hl] ; Store speed in d
	; a = number of steps
	sub d ; Subtract speed from number of steps
	jr nc, .dontStopMovement
	; If there's a carry we need to not walk full speed on the last step
	ld d, b ; Set "speed" to equal remaining steps
	xor a ; Set number of steps to zero
	
.dontStopMovement
	dec hl
	dec hl
	ld [hl], a ; Write number of steps back
	
	and a
	jr nz, .movementContinues
.stopMovement
	push hl
	call RandInt
	pop hl
	ld [hli], a
	set 3, [hl] ; Mark NPC as "frozen"
.movementContinues
	
	ld a, l
	and -NPC_STRUCT_SIZE
	ld l, a
	; hl points to NPC's y pos
	ld bc, wTempBuf
.copyToTemp
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, c
	cp (wTempBuf + 4) & $FF
	jr nz, .copyToTemp
	dec bc
	dec bc
	bit 1, e ; Check if moving horizontally
	jr nz, .movingHorizontally
	dec bc
	dec bc
	dec hl
	dec hl
.movingHorizontally
	; bc points to corresponding coordinate
	bit 0, e
	ld a, [bc]
	jr nz, .movingPositively
	sub a, d
	ld [bc], a
	jr nc, .noCarry
	inc bc
	ld a, [bc]
	dec a
	ld [bc], a
	jr .noCarry
.movingPositively
	add a, d
	ld [bc], a
	jr nc, .noCarry
	inc bc
	ld a, [bc]
	dec a
	ld [bc], a
.noCarry
	; Perform collision check
	push hl
	push de
	call GetNPCCollision
	pop de
	pop hl
	jr z, .stopNPC
	
	; Update displacement
	ld bc, (wNPC0_ydispl - wNPC0_xpos)
	add hl, bc
	ld a, [hl]
	bit 0, e
	jr nz, .updateDisplacementPositively
	sub a, d
	db $06 ; Absorbs the next instruction, and the value of b doesn't matter
.updateDisplacementPositively
	add a, d
	jr c, .stopNPC ; Prevent NPCs going too far from their "anchor point"
	ld [hl], a
	
	ld a, l
	and $F0
	ld l, a
	ld bc, wTempBuf
.applyMovement
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, c
	cp (wTempBuf + 4) & $FF
	jr nz, .applyMovement
.gotoNextNPC ; "Relay" to avoid turning some "jr"s above into "jp"s (Saves size and wastes 1 CPU cycle)
	jr .nextNPC
	
.NPCAtRest
	; Have NPC generate movement
	ld a, [hl] ; Store flags
	and $F4 ; Get only permissions & "enable" bit (which should be set by this point)
	ld [hl], a ; Correct invalid states
	ld d, a
	and $C0 ; Get turning permissions
	jr z, .nextNPC
	
	push hl
	call RandInt
	ld b, l ; Save the random int's low byte
	pop hl
	and $3F ; a contains the high byte
	jr nz, .nextNPC ; Some chance the NPC doesn't do anything, but eventually it should
	
	ld a, d ; Get back flags
	and $C0
	rlca
	rlca
	cp 3 ; If NPC is able to move on both axes, choose one at random
	jr nz, .axisSelected
	rra
	bit 1, b
	jr z, .axisSelected
	add a, a
.axisSelected
	ld c, a ; Store the axis to choose movement (later)
	and 2
	bit 2, b
	jr z, .directionSelected
	inc a
.directionSelected
	ld e, a ; Store direction in common format
	or d
	ld [hld], a ; Write flags with new direction
	dec hl
	dec hl
	dec hl
	ld a, [hl] ; Get sprite ID minus direction
	and $FC
	or e ; Turn NPC
	ld [hli], a
	inc hl
	inc hl ; hl points to step counter
	bit 0, b
	jr z, .dontMove ; NPC may choose not to move :p
	ld a, d
	swap a ; Get perms in the low byte
	and c ; Mask the axis chosen
	jr z, .dontMove ; NPC isn't allowed to move on that axis
	
	; Do NPC's movement
	push hl
	call RandInt
	pop hl
	ld [hli], a
	; Process one frame of movement (if NPC bonks immediately, avoids a "stutter frame") ; also "hli" coincidentally placed hl just right! :D
	jp .NPCIsMoving ; Too far to jr, tho :/
	
.dontMove
	; Stall NPC for some frames, to avoid spamming turning around
	ld a, b
	and $F8
	rrca
	ld [hli], a
	set 3, [hl] ; Mark NPC as "waiting"
	
.nextNPC
	ld a, l
	and -NPC_STRUCT_SIZE ; Get on struct edge
	sub	(wNPC1_ypos - wNPC0_steps) ; Go to previous struct
	ld l, a
	cp (wNPC0_steps - 16) & $FF ; Check if we reached the end
	jp nz, .moveNPC
	ret
	
.stopNPC ; This block of code is off in the distance to avoid turning a jr into a jp
	ld a, l
	and -NPC_STRUCT_SIZE
	ld l, a
	ld bc, (wNPC0_steps - wNPC0_ypos)
	add hl, bc
	push hl
	call RandInt
	pop hl
	ld [hli], a ; Make NPC enter "frozen" state
	set 3, [hl]
	jr .nextNPC
	
; Get collision for the NPC pointed to by hl (can be anywhere within the NPC's struct) at coordinates given by wTempBuf
; Doesn't alter wTempBuf, but otherwise trashes all other registers
GetNPCCollision::
	ld a, l ; Make sure we are on struct's edge (transfers some code from above function, lets a jr be a jr)
	and -NPC_STRUCT_SIZE
	ld l, a
	ld bc, (wNPC0_movtFlags - wNPC0_ypos)
	add hl, bc
	ld a, [hl]
	and 3
	ld b, a ; Get movement direction, will be used for optimization (otherwise, laaaaag)
	ld a, l
	and -NPC_STRUCT_SIZE
	add a, (wNPC0_ybox - wNPC0_ypos)
	ld l, a
	ld e, b ; Transfer direction (it was preserved across the copy here)
	ld a, [hli] ; Store Y hitbox size
	ld c, a
	ld b, [hl] ; Store X hitbox size
	push hl
	ld a, c ; If hitbox is 0 wide/large, NPC can't collide
	dec c ; Decrement hitbox size by 1 to obtain offset
	and a
	jr z, .dontCollide
	ld a, b
	dec b
	and a
	jr z, .dontCollide
	
	ld [hl], 0 ; Zero hitbox size to avoid NPC colliding with itself
	
	bit 0, e ; Down and Right have this bit set
	jr nz, .dontSampleTopLeft
	push de
	push bc
	call GetNPCCollisionAt
	pop bc
	pop de
	jr z, .collide
	
.dontSampleTopLeft
	ld a, c
	and a
	jr z, .dontSampleBottomLeft ; A hitbox of 1 (thus offset of 0) will yield the same result as above, ie. PASS
	
	ld hl, wTempBuf
	ld a, [hl]
	add a, c
	ld [hli], a
	jr nc, .noCarry1
	inc [hl]
.noCarry1
	ld a, e ; Get direction
	and a ; Clear carry
	rra
	jr nc, .bit0Reset1
	dec a ; Toggle bit 1 (rotated right)
.bit0Reset1
	and a ; Left and Down have differing bits 0 and 1, thus they will set Z here (and we want only those)
	jr z, .dontSampleBottomLeft
	push de
	push bc
	call GetNPCCollisionAt
	pop bc
	pop de
	jr z, .collide
	
.dontSampleBottomLeft
	ld a, b
	and a
	jr z, .dontSampleBottomRight
	
	ld hl, wTempBuf + 2
	ld a, [hl]
	add a, b
	ld [hli], a
	jr nc, .noCarry2
	inc [hl]
.noCarry2
	bit 0, e ; Up and Left have the bit reset
	jr z, .dontSampleBottomRight
	push de
	push bc
	call GetNPCCollisionAt
	pop bc
	pop de
	jr z, .collide
	
.dontSampleBottomRight
	ld a, c
	and a
	jr z, .dontCollide
	
	ld hl, wTempBuf
	ld a, [hl]
	sub a, c
	ld [hli], a
	jr nc, .noCarry3
	inc [hl]
.noCarry3
	
	ld a, e
	and a
	rra
	jr nc, .bit0Reset2
	dec a
.bit0Reset2
	and a
	jr nz, .dontCollide
	push bc
	call GetNPCCollisionAt
	pop bc
	db $11 ; Will absorb the next two as "ld de, $XXXX"
	
.dontCollide
	xor a
	inc a
.collide
	pop hl
	push af
	inc c ; Make sure to restore true hitbox size
	ld [hl], c ; Restore hitbox size
	ld hl, wTempBuf + 2
	ld a, [hl]
	sub b
	ld [hli], a
	jr nc, .noCarry4
	dec [hl]
.noCarry4
	pop af ; Restore Z flag
	ret
	
	
StopWalkingAnimation:
	; xor a ; No need, it's already zero when called
	ld [wNPC0_steps], a
	ret
	
MovePlayer::
	ldh a, [hOverworldHeldButtons]
	and DPAD_DOWN | DPAD_LEFT | DPAD_RIGHT | DPAD_UP
	jr z, StopWalkingAnimation
	ld b, a
	ld [wTempBuf + 4], a
	
	ld a, [wNPC0_steps]
	and a
	jr nz, .dontRestartWalkingAnimation
	ld a, $20
.dontRestartWalkingAnimation
	dec a
	ld [wNPC0_steps], a
	
	ld a, [wPlayerSpeed]
	ld c, a
	and $F0 ; Valid speed range : $00-$0F
	jr z, .speedIsValid
	xor a
	ld c, a
	ld [wPlayerSpeed], a
.speedIsValid
	ld a, c
	and a
	jp z, .cantMove ; Too far to jr
	
.movementLoop
	push bc
	ld hl, wYPos
	ld de, wTempBuf
	ld a, b
	add a, a
	jr nc, .notDown
	add a, a ; Skip Up.
	ld b, a
	ld a, [hli]
	add a, 1
	ld [de], a
	inc de
	ld a, [hli]
	adc a, 0
	jr .movedVertically
.notDown
	add a, a
	ld b, a
	jr c, .moveUp
	ld c, 2
	rst copy
	jr .noVerticalMovement
.moveUp
	ld a, [hli]
	sub a, 1
	ld [de], a
	inc de
	ld a, [hli]
	sbc a, 0
.movedVertically
	ld [de], a
	
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	
	push bc
	ld hl, wTempBuf
	ld de, wLargerBuf
	ld c, 2
	rst copy
	
	call DetectPlayerCollision
	jr z, .verticalCollision
	ld hl, wLargerBuf
	ld de, wYPos
	ld c, 2
	rst copy
	jr .noVerticalCollision
	
.verticalCollision
	ld a, [wTempBuf + 4]
	and $30
	ld [wTempBuf + 4], a
	
.noVerticalCollision
	ld hl, wYPos
	ld de, wTempBuf
	ld c, 2
	rst copy
	
	pop bc
	ld hl, wXPos
	ld de, wTempBuf + 2
.noVerticalMovement
	ld a, b
	add a, a
	jr nc, .notLeft
	ld a, [hli]
	sub a, 1 ; This can generate a carry, "dec" wouldn't
	ld [de], a
	inc de
	ld a, [hli]
	sbc a, 0
	jr .movedHorizontally
.notLeft
	add a, a
	jr nc, .noHorizontalMovement
.moveRight
	ld a, [hli]
	add a, 1 ; This may generate a carry, "inc" wouldn't
	ld [de], a
	inc de
	ld a, [hli]
	adc a, 0
.movedHorizontally
	ld [de], a
	inc de
	
	ld hl, wTempBuf + 2
	ld de, wLargerBuf
	ld c, 2
	rst copy
	
	; Check for collision at target coordinates
	call DetectPlayerCollision
	jr z, .horizontalCollision ; Don't move if collision occurs
	
	ld hl, wLargerBuf
	ld de, wXPos
	ld c, 2
	rst copy
	jr .noHorizontalCollision
	
.horizontalCollision
	ld a, [wTempBuf + 4]
	and $C0
	ld [wTempBuf + 4], a
	
.noHorizontalCollision
.noHorizontalMovement
	pop bc
	dec c
	jp nz, .movementLoop ; Too far to jr!
	
.cantMove
	ld a, [wTempBuf + 4]
	ld c, a
	and a
	jr nz, .changeDirection
	; Reset animation for the same reasons as below
	xor a
	ld [wNPC0_steps], a
	
	ld a, b ; Player didn't move, so use direction keys instead. Will look weird in some cases, but just returning would cause even weirder things
	; Example : Look left against a wall below you, stop and tap Down. You wouldn't turn with `ret`urning.
	; Also not retrieving keys from memory, since it's slower
	; Note : loop softlocks if no key is held (but that's normally impossible here)
.changeDirection
	ld e, -1
.turnPlayer
	inc e
	add a, a
	jr nc, .turnPlayer
	
	and a ; Check if a diagonal is being held (no other key than first one)
	jr z, .doTurn
	ld a, c
	and a ; If we're trying to turn but we didn't move, don't turn (otherwise it looks weird)
	ret z
	
.doTurn
	and a ; Clear carry
	ld a, e
	rra
	xor e
	xor 1
	ld [wPlayerDir], a
	ret
	
	
PLAYER_HITBOX_Y_OFFSET	equ 8
PLAYER_HITBOX_X_OFFSET	equ 2
PLAYER_HITBOX_Y_SIZE	equ 7
PLAYER_HITBOX_X_SIZE	equ 11
	
; Detect player collision at coordinates given by wTempBuf
; Sets Z if can't go through
DetectPlayerCollision::
	ld hl, wTempBuf
	ld a, [hl]
	add a, PLAYER_HITBOX_Y_OFFSET
	ld [hli], a
	jr nc, .noCarry1
	inc [hl]
.noCarry1
	inc hl
	ld a, [hl]
	add a, PLAYER_HITBOX_X_OFFSET
	ld [hli], a
	jr nc, .noCarry2
	inc [hl]
.noCarry2
	
	ldh a, [hOverworldHeldButtons]
	and DPAD_UP | DPAD_LEFT
	jr z, .dontSampleTopLeft ; Don't sample top-left if not going up or left
	call GetCollisionAt
	ret z
.dontSampleTopLeft
	
	ld hl, wTempBuf
	ld a, [hl]
	add a, PLAYER_HITBOX_Y_SIZE
	ld [hli], a
	jr nc, .noCarry3
	inc [hl]
.noCarry3
	inc hl
	
	ldh a, [hOverworldHeldButtons]
	and DPAD_DOWN | DPAD_LEFT
	jr z, .dontSampleBottomLeft ; Don't sample if...
	call GetCollisionAt
	ret z
.dontSampleBottomLeft
	
	ld hl, wTempBuf + 2
	ld a, [hl]
	add a, PLAYER_HITBOX_X_SIZE
	ld [hli], a
	jr nc, .noCarry4
	inc [hl]
.noCarry4
	inc hl
	
	ldh a, [hOverworldHeldButtons]
	and DPAD_DOWN | DPAD_RIGHT
	jr z, .dontSampleBottomRight
	call GetCollisionAt
	ret z
.dontSampleBottomRight
	
	ldh a, [hOverworldHeldButtons]
	and DPAD_UP | DPAD_RIGHT
	jr nz, .sampleTopRight ; Skip all calculations if this point isn't sampled
	xor a
	inc a ; Reset Z flag
	ret
.sampleTopRight
	
	ld hl, wTempBuf
	ld a, [hl]
	sub a, PLAYER_HITBOX_Y_SIZE
	ld [hli], a
	jr nc, .noCarry5
	dec [hl]
.noCarry5
	call GetCollisionAt
	ret
	
	
GetNPCCollisionAt::
	; Check for collision with the player (only relevant for NPCs, since the player will NEVER trigger this)
	ld hl, wTempBuf
	ld a, [wYPos + 1]
	ld b, a
	ld a, [wYPos]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [hli]
	sbc b
	jr nz, .noPlayerCollision
	ld a, c
	cp $10
	jr nc, .noPlayerCollision
	
	ld a, [wYPos + 3]
	ld b, a
	ld a, [wYPos + 2]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	jr nz, .noPlayerCollision
	ld a, c
	cp $10
	jr c, CollideWithOOB
.noPlayerCollision
	; Share rest of collision detection with player
	
; Detect collision at pixel whose coordinates are given by wTempBuf
; Sets Z if collision occurs
GetCollisionAt::
	ld a, [wNumOfNPCs]
	and a
	jr z, .dontScanNPCs
	ld hl, wNPC1_ypos
	ld e, NPC_STRUCT_SIZE
	call ScanForInteraction
	ccf ; C set = NPC NOT collided with
	sbc a, a ; If a NPC is collided with, this will set a to $00. Otherwise, $FF.
	ret z
.dontScanNPCs
	
	call GetPointerFromCoords
	
	ld a, b
	and a
	jr nz, CollideWithOOB
	ld a, [wMapWidth]
	dec a
	cp c ; Will set carry if width - 1 < block offset, ie block offset >= width
	jr c, CollideWithOOB
	
	ld hl, wTempBuf + 1
	ld a, [hl]
	and $F0
	jr nz, CollideWithOOB
	ld a, [wMapHeight]
	ld c, a
	ld a, [hld]
	and $0F
	ld b, a
	ld a, [hl]
	and $F0
	or b
	swap a
	cp c
	jr c, NoOOB
CollideWithOOB:
	xor a
	ret
	
NoOOB:
	ld a, [wNoClipActive]
	and a
	ret nz
	
	ld a, [de]
	ld d, wBlockMetadata >> 8
	add a, a
	add a, a
	add a, a
	jr nc, .noCarry1
	inc d
.noCarry1
	ld e, a
	bit 3, [hl] ; Check if on bottom row of tile of current block
	jr z, .notBottomRow
	inc de
	inc de
.notBottomRow
	inc hl
	inc hl
	bit 3, [hl] ; Check if on right column of tile of current block
	jr z, .notRightRow
	inc de
	inc de
	inc de
	inc de
.notRightRow
	ld h, d
	ld l, e
	ld a, [hli]
	bit 7, a ; Check if tile is a tileset one
	ret z ; Always collide with tiles not originating from tileset
	bit 3, [hl]
	jr nz, .tileIsBank1
	res 7, a ; Bank 0's tiles have attributes 0-127, bank 1's have 128-255
.tileIsBank1
	ld l, a
	ld h, wTileAttributes >> 8
	bit 7, [hl]
	ret ; Return with colliding with block status
	
	
; Get the pointer to the block targeted by the coords in wTempBuf
GetPointerFromCoords::
	ld hl, wTempBuf
	ld a, [hli]
	and $F0
	ld e, a
	ld a, [hl]
	and $0F
	or e
	swap a
	ld e, a ; Divided by 16 : OK!
	ld a, [hli]
	and $F0
	swap a
	ld d, a ; Divided by 16 : OK!
	; de now contains the vertical block position
	
	ld a, [hli]
	and $F0
	ld c, a
	ld a, [hl]
	and $0F
	or c
	swap a
	ld c, a ; Divided by 16 : OK!
	ld a, [hli]
	and $F0
	swap a
	ld b, a ; Divided by 16 : OK!
	; bc now contains the horizontal position
	
	ld a, [wMapWidth]
	call MultiplyDEByA
	add hl, bc ; hl now contains map offset
	ld d, h
	ld e, l
	
	ld hl, wBlockPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ret
	
	
GetCoordsInFrontOfPlayer::
	ld a, [wPlayerDir]
	add a, a
	ld hl, CoordVectors
	add a, l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld c, [hl]
	inc hl
	ld b, [hl]
	
	ld hl, wYPos
	ld de, wTempBuf
	ld a, [hli]
	add a, c
	ld [de], a
	inc de
	ld a, [hli]
	adc a, 0
	ld [de], a
	inc de
	ld a, [hli]
	add a, b
	ld [de], a
	inc de
	ld a, [hli]
	adc a, 0
	ld [de], a
	ret
	
CoordVectors::
	db 7,  7
	db 16, 7
	db 9,  1
	db 9, 14
	
	
DoButtonInteractions::
	call GetCoordsInFrontOfPlayer
	
	ld a, [wNumOfNPCs]
	and a
	jr z, .noNPCs
	ld hl, wNPC1_ypos
	
	ld e, NPC_STRUCT_SIZE
	call ScanForInteraction
	jr nc, .noNPCs ; Didn't find anything
	inc hl
	ld a, [hli] ; Get NPC's interaction ID
	ld b, a ; Save it
	ld a, [wNPC0_sprite] ; Get out direction (& sprite)
	and 3 ; Filter only direction bits
	xor 1 ; Toggle facing so NPC faces us
	ld c, a ; Save new direction
	ld a, [hl] ; Get NPC's sprite & direction
	and $FC ; Get sprite only
	or c ; Set direction
	ld [hli], a ; Push changes
	inc hl
	inc hl
	xor a
	ld [hli], a ; Stop NPC's movement
	push bc
	call ProcessNPCs
	pop af ; NPC script ID goes in a
	add a, a
	ld hl, wNPCScriptsPointer
	add a, [hl] ; Add offset to base ptr
	inc hl
	ld h, [hl]
	ld l, a
	jr nc, ProcessInteraction + 1 ; Skip 1st "inc hl"
	inc h
	jr ProcessInteraction
	
.noNPCs
	ld e, INTERACTION_STRUCT_SIZE
	ld a, [wBtnInterCount]
	and a
	jr z, .noButtonInteraction
	ld hl, wButtonInteractions
	call ScanForInteraction
	jr c, ProcessInteraction
.noButtonInteraction
	ld a, [wBtnLoadZoneCount]
	and a
	ret z
	ld hl, wButtonLoadZones
	call ScanForInteraction
	ret nc
	jr ProcessLoadZone
	
DoWalkingInteractions::
	ld hl, wYPos
	ld de, wTempBuf
	ld c, 4
	rst copy
	ld e, INTERACTION_STRUCT_SIZE
	ld a, [wWalkInterCount]
	and a
	jr z, .noWalkingInteraction
	ld hl, wWalkingInteractions
	call ScanForInteraction
	jr c, ProcessInteraction
.noWalkingInteraction
	ld a, [wWalkLoadZoneCount]
	and a
	ret z
	ld hl, wWalkingLoadZones
	call ScanForInteraction
	ret nc
	; Slide
	
ProcessLoadZone:
	inc hl
	inc hl
	ld a, [hld]
	ld [wTargetWarpID], a
	ld a, [hl]
	jp LoadMap
	
ProcessInteraction:
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl] ; Get interaction pointer
	push de ; Save it 'cause it's gonna be destroyed
	call StopPlayerMovement
	pop de ; Retrieve interaction pointer
	ld a, [wLoadedMapROMBank]
	ld c, a ; Get interaction bank
	jpacross ProcessText_Hook
	
; Formerly "LookForAThingToInteractWith"
; The olde name shall forever remain in memory
; Scans for an interaction in a table
; First 6 bytes of an element must be :
; - Y pos,			2 bytes
; - X pos,			2 bytes
; - Y hitbox size,	1 byte
; - X hitbox size,	1 byte
; Parameters :
; hl = pointer to table (ELEMENTS MUST BE ALIGNED TO THEIR SIZE!!) (Otherwise  v )
; a = number of elements
; e = length of one element (MUST BE A POWER OF 2!!!) (Otherwise          rewrite code so it pushes base ptr, operates, pops it, and adds the size)
; wTempBuf = coords of scanned point
; Destroys all registers, preserves wTempBuf
; If an element can be interacted with, will return with C flag set and hl pointing to corresponding X hitbox size
ScanForInteraction::
	ld b, a
.lookForInteraction
	ld a, [hli]
	ld c, a
	ld a, [wTempBuf]
	sub c
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [wTempBuf + 1]
	sbc c
	jr nz, .notThisOne
	ld a, d
	inc hl
	inc hl
	cp [hl]
	jr nc, .notThisOne
	dec hl
	dec hl
	ld a, [hli]
	ld c, a
	ld a, [wTempBuf + 2]
	sub c
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [wTempBuf + 3]
	sbc c
	jr nz, .notThisOne
	ld a, d
	inc hl
	cp [hl]
	ret c
	
.notThisOne
	xor a
	sub e ; Get alignment mask (this only works with powers of 2!!!)
	and l ; Align read ptr
	add a, e ; Advance 1 element
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	dec b
	jr nz, .lookForInteraction
	and a ; Clear carry
	ret
