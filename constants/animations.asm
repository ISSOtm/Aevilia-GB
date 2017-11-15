

; ------- ANIMATION COMMANDS ---------
	enum_start
	enum_elem END_ANIM
	enum_elem DELAY_AND_PAUSE
	enum_elem ANIM_JUMP_TO
	enum_elem START_NEW_ANIM
	enum_elem ANIM_CALL
	
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
	db \1
	dw \2
ENDM

anim_jump_to: MACRO
	anim_jump BANK(\1), \1
ENDM

; Starts a new animation (IF A SLOT IS AVAILABLE !!)

