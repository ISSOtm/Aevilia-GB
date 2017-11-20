

; ------- ANIMATION COMMANDS ---------
	enum_start
	enum_elem END_ANIM
	enum_elem DELAY_AND_PAUSE
	enum_elem ANIM_JUMP_TO
	enum_elem START_NEW_ANIM
	enum_elem ANIM_CALL
	enum_elem ANIM_CALL_SECTION
	enum_elem ANIM_COPY_TILES
	enum_elem ANIM_COPY_SPRITES
	enum_elem ANIM_MOVE_SPRITE
	enum_elem ANIM_MOVE_NPC
	enum_elem ANIM_TURN_NPC
	enum_elem ANIM_SET_SPR_POS
	enum_elem ANIM_SET_SPR_TILES
	enum_elem ANIM_SET_SPR_ATTRIBS
	
	enum_elem INVALID_ANIM_COMMAND


; -------- ANIMATION COMMAND MACROS ----------

; Ends all operations
; done: MACRO
	; db END_ANIM
; ENDM
; Shared with the text engine !

; Pauses animation for some time
pause: MACRO
	db DELAY_AND_PAUSE
	db \1
ENDM

; Continues the animation where specified
anim_jump: MACRO
	db ANIM_JUMP_TO
	IF _NARG == 1
		db BANK(\1)
		dw \1
	ELSE
		db \1
		dw \2
	ENDC
ENDM

; Starts a new animation (IF A SLOT IS AVAILABLE !!)
anim_start: MACRO
	db START_NEW_ANIM
	IF _NARG == 1
		db BANK(\1)
		dw \2
	ELSE
		db \1
		dw \2
	ENDC
ENDM

; Starts a new animation and waits for it
anim_call: MACRO
	db ANIM_CALL
	IF _NARG == 1
		db BANK(\1)
		dw \1
	ELSE
		db \1
		dw \2
	ENDC
ENDM

; Copies tiles to VRAM
; args : bank src bank dest len
; other syntax : src bank dest len (the src bank will be pulled from the label)
; src and dest must be 16-byte aligned
; len must be specified in tiles increments
anim_copy_tiles: MACRO
	db ANIM_COPY_TILES
	IF _NARG >= 5
		dw \2
		db \1
		shift
	ELSE
		dw \1
		db BANK(\1)
	ENDC
	db (HIGH(\3) & 1) | (\2 & 1) << 1
	db LOW(\3)
	db \4
ENDM

; Copies sprites to Extended OAM
; args : bank src destID len
; other syntax : src destID len
anim_copy_sprites: MACRO
	db ANIM_COPY_SPRITES
	IF _NARG >= 4
		dw \2
		db \1
		shift
	ELSE
		dw \1
		dw BANK(\1)
	ENDC
	db \2
	db \3
ENDM

; Moves sprites on-screen
; args : bank src sprID len
; sprID is the ID of the 1st allocated sprite that will be affected
; len is in sprite increments (ie. 4 bytes)
anim_move_spr: MACRO
	db ANIM_MOVE_SPRITE
	IF _NARG >= 4
		dw \2
		db \1
		shift
	ELSE
		dw \1
		db BANK(\1)
	ENDC
	db \2
	db \3
ENDM

; Moves a NPC
; args : npcID yvect xvect
; Both vector coordinates are signed 
anim_move_npc: MACRO
	db ANIM_MOVE_NPC
	db \1
	db \2, \3
ENDM

; Turns a NPC
; args : npcID dir
anim_turn_npc: MACRO
	db ANIM_TURN_NPC
	db \1
	db \2
ENDM
; Changes a NPC's sprite ID
; args : npcID lookID (not shifted)
anim_set_npc_look: MACRO
	db ANIM_TURN_NPC
	db \1
	db ((\2 << 2) & $7F) | $80
ENDM

; Sets some sprite's positions
; args : sprID len ypos xpos
anim_set_pos: MACRO
	db ANIM_SET_SPR_POS
	db \1
	db \2
	db \3, \4
ENDM

; Sets some sprite's tiles
; args : sprID len tileID vect
anim_set_tiles: MACRO
	db ANIM_SET_SPR_TILES
	db \1
	db \2
	db \3
	db \4
ENDM

anim_set_attribs: MACRO
	db ANIM_SET_SPR_ATTRIBS
ENDM
