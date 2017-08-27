

; dNPC spr_id facing_dir pal_id interact_id movt_type
; Use to declare a NPC in ROM
dNPC: MACRO
	db ((\1 & $07) << 5) | ((\2 & $03) << 3) | (\3 & $07)
	db ((\4 & $1F) << 3) |  (\5 & $07)
ENDM

; Use to declare a NPC buffer in RAM
struct_NPC: MACRO
wNPC\1_ypos::		dw ; Vertical position
wNPC\1_xpos::		dw ; Horizontal position
wNPC\1_ybox::		db ; Vertical hitbox
wNPC\1_xbox::		db ; Horizontal hitbox
wNPC\1_interactID::	db ; Interaction ID
wNPC\1_sprite::		db ; Sprite ID (bits 2-7) & direction (bits 0-1)
wNPC\1_palettes::	dw ; Palette IDs (each byte includes 2 unused bits, could be used...)
wNPC\1_steps::		db ; Number of steps to take
wNPC\1_movtFlags::	db ; Movement permissions (2 bits for turning perms then 2 bits for moving perms) & Status bit (1 if "steps" indicates how many frames NPC should wait) & Movement lock bit (NPC skipped if reset) & Movement direction (2 bits)  (all bits in this order)
wNPC\1_speed::		db ; Speed of movement
wNPC\1_ydispl::		db ; Vertical displacement (make sure there's a 1-byte offset between both displacement bytes)
wNPC\1_unused::		ds 1 ; Unused
wNPC\1_xdispl::		db ; Horizontal displacement
ENDM


; Use to declare a palette buffer in RAM
struct_pal: MACRO
w\1Palette\2_color0::	ds 3
w\1Palette\2_color1::	ds 3
w\1Palette\2_color2::	ds 3
w\1Palette\2_color3::	ds 3
ENDM


; Use to declare a tile animation in RAM
struct_tileanim: MACRO
wTileAnim\1_frameCount::	db ; Number of frames elapsed since beginning
wTileAnim\1_delayLength::	db ; When frameCount hits this, it resets, and one frame of anim is processed
wTileAnim\1_currentFrame::	db ; Which frame of animation is being displayed
wTileAnim\1_numOfFrames::	db ; Number of frames in the current animation
wTileAnim\1_tileID::		db ; ID of the tile being animated
wTileAnim\1_framesPtr::		dw ; Pointer to the frames (stored in WRAM)    /!\ THIS IS A BIG-ENDIAN POINTER !!!
wTileAnim\1_unused::		ds 1 ; Unused
ENDM


; tile_attr tile bit4 pal_id bank hflip vflip under_spr
; Use to declare a tile's data in ROM.
; Use in groups of four to declare a block's data
; 0 2
; 1 3 (in this order !)
tile_attr: MACRO
	; The tile ID
	db \1
	; The attribute (transferred to VRAM bank 1), plus an extra bit (bit 4, unseen by the console) used for the block's metadata
	db ((\7 & 1) << 7) | ((\6 & 1) << 6) | ((\5 & 1) << 5) | ((\2 & 1) << 4) | ((\4 & 1) << 3) | (\3 & $07)
ENDM
; Tile 0's bit 4 declares if the block is water
; Tile 1's bit 4 declares nothing (yet)
; Tile 2's bit 4 declares nothing (yet)
; Tile 3's bit 4 declares nothing (yet)

; Alternates between the tile and its attribute byte
; 0 2
; 1 3 to be consistent with sprites
struct_blk: MACRO
wBlk\1_tile0::	db
wBlk\1_attr0::	db
wBlk\1_tile1::	db
wBlk\1_attr1::	db
wBlk\1_tile2::	db
wBlk\1_attr2::	db
wBlk\1_tile3::	db
wBlk\1_attr3::	db
ENDM


walking_interaction: MACRO
wWalkingInter\1_ypos::		dw
wWalkingInter\1_xpos::		dw
wWalkingInter\1_ybox::		db
wWalkingInter\1_xbox::		db
wWalkingInter\1_textptr::	dw
ENDM

button_interaction: MACRO
wButtonInter\1_ypos::		dw
wButtonInter\1_xpos::		dw
wButtonInter\1_ybox::		db
wButtonInter\1_xbox::		db
wButtonInter\1_textptr::	dw
ENDM

walking_loadzone: MACRO
wWalkingLoadZone\1_ypos::		dw
wWalkingLoadZone\1_xpos::		dw
wWalkingLoadZone\1_ybox::		db
wWalkingLoadZone\1_xbox::		db
wWalkingLoadZone\1_destMap::	db
wWalkingLoadZone\1_destWarp::	db
ENDM

button_loadzone: MACRO
wButtonLoadZone\1_ypos::		dw
wButtonLoadZone\1_xpos::		dw
wButtonLoadZone\1_ybox::		db
wButtonLoadZone\1_xbox::		db
wButtonLoadZone\1_destMap::		db
wButtonLoadZone\1_destWarp::	db
ENDM


dtile: MACRO
	ds VRAM_TILE_SIZE * (\1)
ENDM

