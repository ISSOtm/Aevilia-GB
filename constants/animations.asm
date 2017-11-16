

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
		
	ELSE
		db \1
		dw \2
	ENDC
ENDM
