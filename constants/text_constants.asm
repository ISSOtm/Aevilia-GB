
; ------- TEXT COMMANDS ---------
END_TEXT			equ $00
CLEAR_TEXT			equ $01
PRINT_PIC			equ $02
PRINT_NAME_AND_DISP	equ $03
WAIT_FOR_BUTTON		equ $04
PRINT_STRING		equ $05
EMPTY_LINE			equ $06
DELAY_FRAMES		equ $07
SET_COUNTER			equ $08
COPY_COUNTER		equ $09
DECREMENT_AND_JUMP	equ $0A
DISPLAY_NUMBER		equ $0B
INSTANT_DISPLAY		equ $0C
INSTANT_CLOSE		equ $0D
DISP_WITHOUT_WAIT	equ $0E
CLOSE_WITHOUT_WAIT	equ $0F
MAKE_NPC_WALK		equ $10
MAKE_CHOICE			equ $11
MAKE_B_CHOICE		equ $12
SET_FADE_SPEED		equ $13
GFX_FADE_IN			equ $14
GFX_FADE_OUT		equ $15
RELOAD_PALETTES		equ $16
LDA_TEXT			equ $17
LDAIMM_TEXT			equ $18
STA_TEXT			equ $19
CMP_TEXT			equ $1A
DEC_TEXT			equ $1B
INC_TEXT			equ $1C
ADD_TEXT			equ $1D
ADC_TEXT			equ $1E
ADDMEM_TEXT			equ $1F
SBC_TEXT			equ $20
SUBMEM_TEXT			equ $21
SET_TEXT_FLAGS		equ $22
TOGGLE_TEXT_FLAGS	equ $23
TEXT_CALL_FUNCTION	equ $24
INSTANT_PRINT_STRS	equ $25
UPDATE_TEXT_FLAGS	equ $26
TEXT_JR				equ $27
TEXT_JR_NC			equ $28
TEXT_JR_C			equ $29
TEXT_JR_P			equ $2A
TEXT_JR_N			equ $2B
TEXT_JR_PE			equ $2C
TEXT_JR_PO			equ $2D
TEXT_JR_NZ			equ $2E
TEXT_JR_Z			equ $2F
TEXT_RAM_BANKSWITCH	equ $30
TEXT_AND			equ $31
TEXT_OR				equ $32
TEXT_XOR			equ $33
TEXT_BIT			equ $34
END_TEXT_LEAVE_BOX	equ $35
TEXT_MUSIC_FADE		equ $36
TEXT_MUSIC_PLAY		equ $37
TEXT_MUSIC_STOP		equ $38
OVERRIDE_TEXBOX_PAL	equ $39
INVALID_TXT_COMMAND	equ $3A ; WARNING : TEXT COMMAND PROCESSOR MUST BE UPDATED IF IDS 128+ ARE USED!!!


; -------- TEXT MACROS ----------
done: MACRO
	db END_TEXT
ENDM


clear_box: MACRO
	db CLEAR_TEXT
ENDM


; print_pic ptr_to_pic
print_pic: MACRO
	db PRINT_PIC
	db BANK(\1)
	dw \1
ENDM


; print_name ptr_to_name
print_name: MACRO
	db PRINT_NAME_AND_DISP
	db BANK(\1)
	dw \1
ENDM

disp_box: MACRO
	db PRINT_NAME_AND_DISP
	db BANK(NULL)
	dw NULL
ENDM


wait_user: MACRO
	db WAIT_FOR_BUTTON
ENDM


; print_str ptr_to_print
print_line: MACRO
	db PRINT_STRING
	db BANK(\1)
	dw \1
ENDM

empty_line: MACRO
	db EMPTY_LINE
ENDM


; delay nb_frames
delay: MACRO
	db DELAY_FRAMES
	dw \1
ENDM


; set_counter nb_iters
set_counter: MACRO
	db SET_COUNTER
	db \1
ENDM

; copy_counter ptr_to_copy_from
copy_counter: MACRO
	db COPY_COUNTER
	dw \1
ENDM

; djnz offset
djnz: MACRO
	db DECREMENT_AND_JUMP
	db \1
ENDM


; disp_num type ptr
; words are displayed low-endian
byte equ 0
word equ 1
disp_num: MACRO
	db DISPLAY_NUMBER
	db \1 & 1
	dw \2
ENDM


display_quick: MACRO
	db INSTANT_DISPLAY
ENDM

close_quick: MACRO
	db INSTANT_CLOSE
ENDM

display_nodelay: MACRO
	db DISP_WITHOUT_WAIT
ENDM

close_nodelay: MACRO
	db CLOSE_WITHOUT_WAIT
ENDM


dir_down	equ $00
dir_up		equ $01
dir_left	equ $02
dir_right	equ $03

dont_turn	equ $04

; make_npc_walk NPC_id dir len spd
; apply "(dir | dont_turn)" to "dir" if the NPC shouldn't turn around
make_npc_walk: MACRO
	db MAKE_NPC_WALK
	db \1
	db \2 & 7
	db \3
	db \4
ENDM


; choose str_choice ofs_2
; Remember to add the 5 of the MAKE_CHOICE command !
choose: MACRO
	db MAKE_CHOICE
	db BANK(\1)
	dw \1
	db \2
ENDM
; Use to make a fake choice where the outcome is the same
fake_choice: MACRO
	db MAKE_CHOICE
	db BANK(\1)
	dw \1
	db 5
ENDM

choose_b: MACRO
	db MAKE_B_CHOICE
	db BANK(\1)
	dw \1
	db \2
ENDM

fake_b_choice: MACRO
	db MAKE_B_CHOICE
	db BANK(\1)
	dw \1
	db 5
ENDM


; set_fade_speed gfx_fade_speed
set_fade_speed: MACRO
	db SET_FADE_SPEED
	db \1
ENDM

gfx_fadein: MACRO
	db GFX_FADE_IN
ENDM

gfx_fadeout: MACRO
	db GFX_FADE_OUT
ENDM

reload_palettes: MACRO
	db RELOAD_PALETTES
ENDM


; text_lda src_ptr
text_lda: MACRO
	db LDA_TEXT
	dw \1
ENDM

; text_sta imm8
text_lda_imm: MACRO
	db LDAIMM_TEXT
	db \1
ENDM

; text_sta dest_ptr
text_sta: MACRO
	db STA_TEXT
	dw \1
ENDM

; text_cmp imm8
text_cmp: MACRO
	db CMP_TEXT
	db \1
ENDM

; Note that unlike the z80's `dec`, this updates the carry flag !
; Also note that `inc` doesn't, otherwise C == Z (so it'd be pointless)
text_dec: MACRO
	db DEC_TEXT
ENDM

text_inc: MACRO
	db INC_TEXT
ENDM

; text_add imm8
text_add: MACRO
	db ADD_TEXT
	db \1
ENDM

; text_adc imm8
text_adc: MACRO
	db ADC_TEXT
	db \1
ENDM

; text_add_mem ptr
text_add_mem: MACRO
	db ADDMEM_TEXT
	dw \1
ENDM

; text_sbc imm8
text_sbc: MACRO
	db SBC_TEXT
	db \1
ENDM

; text_sub_mem ptr
text_sub_mem: MACRO
	db SUBMEM_TEXT
	dw \1
ENDM

; text_set_flags mask
text_set_flags: MACRO
	db SET_TEXT_FLAGS
	db \1
ENDM

; text_toggle_flags mask
text_toggle_flags: MACRO
	db TOGGLE_TEXT_FLAGS
	db \1
ENDM


; text_asmcall funcptr
text_asmcall: MACRO
	db TEXT_CALL_FUNCTION
	dw \1
ENDM


; instant_str ptr
; Instantly prints all three strings pointed to (contiguous)
instant_str: MACRO
	db INSTANT_PRINT_STRS
	db BANK(\1)
	dw \1
ENDM


text_update_flags: MACRO
	db UPDATE_TEXT_FLAGS
ENDM


; Do a jr like the proc's one. Except the offset is calculated slightly differently, eg. text_jr $00 is an infinite loop !!
cond_nc	EQU 1
cond_c	EQU 2
cond_p	EQU 3
cond_m	EQU 4
cond_pe	EQU 5
cond_po	EQU 6
cond_nz	EQU 7
cond_z	EQU 8
text_jr: MACRO
	IF _NARG == 1
		db TEXT_JR
		db \1
	ELSE
		db TEXT_JR + \1
		db \2
	ENDC
ENDM


text_bankswitch: MACRO
	db TEXT_RAM_BANKSWITCH
	db \1
ENDM


text_and: MACRO
	db TEXT_AND
	db \1
ENDM

text_or: MACRO
	db TEXT_OR
	db \1
ENDM

text_xor: MACRO
	db TEXT_XOR
	db \1
ENDM


text_bit: MACRO
	db TEXT_BIT
	db \1
ENDM

end_with_box: MACRO
	db END_TEXT_LEAVE_BOX
ENDM


fade_music: MACRO
	db TEXT_MUSIC_FADE
	db \1
ENDM

play_music: MACRO
	db TEXT_MUSIC_PLAY
	db \1
ENDM

stop_music: MACRO
	db TEXT_MUSIC_STOP
ENDM


color_textbox: MACRO
	db OVERRIDE_TEXBOX_PAL
	dw \1
ENDM
