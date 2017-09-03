

; --------- TEXT FLAGS ----------
	enum_start
	enum_elem TEXT_0_FLAG
	enum_elem TEXT_1_FLAG
	enum_elem TEXT_2_FLAG
	enum_elem TEXT_PIC_FLAG
	enum_elem TEXT_ZERO_FLAG
	enum_elem TEXT_PARITY_FLAG
	enum_elem TEXT_SIGN_FLAG
	enum_elem TEXT_CARRY_FLAG

; ------- TEXT COMMANDS ---------
	enum_start
	enum_elem END_TEXT
	enum_elem CLEAR_TEXT
	enum_elem PRINT_PIC
	enum_elem PRINT_NAME_AND_DISP
	enum_elem WAIT_FOR_BUTTON
	enum_elem PRINT_STRING
	enum_elem EMPTY_LINE
	enum_elem DELAY_FRAMES
	enum_elem SET_COUNTER
	enum_elem COPY_COUNTER
	enum_elem DECREMENT_AND_JUMP
	enum_elem DISPLAY_NUMBER
	enum_elem INSTANT_DISPLAY
	enum_elem INSTANT_CLOSE
	enum_elem DISP_WITHOUT_WAIT
	enum_elem CLOSE_WITHOUT_WAIT
	enum_elem MAKE_NPC_WALK
	enum_elem MAKE_PLAYER_WALK
	enum_elem MAKE_CHOICE
	enum_elem MAKE_B_CHOICE
	enum_elem SET_FADE_SPEED
	enum_elem GFX_FADE_IN
	enum_elem GFX_FADE_OUT
	enum_elem RELOAD_PALETTES
	enum_elem LDA_TEXT
	enum_elem LDAIMM_TEXT
	enum_elem STA_TEXT
	enum_elem CMP_TEXT
	enum_elem DEC_TEXT
	enum_elem INC_TEXT
	enum_elem ADD_TEXT
	enum_elem ADC_TEXT
	enum_elem ADDMEM_TEXT
	enum_elem SBC_TEXT
	enum_elem SUBMEM_TEXT
	enum_elem SET_TEXT_FLAGS
	enum_elem TOGGLE_TEXT_FLAGS
	enum_elem TEXT_CALL_FUNCTION
	enum_elem INSTANT_PRINT_STRS
	enum_elem UPDATE_TEXT_FLAGS
	enum_elem TEXT_JR
	enum_elem TEXT_JR_NC
	enum_elem TEXT_JR_C
	enum_elem TEXT_JR_P
	enum_elem TEXT_JR_N
	enum_elem TEXT_JR_PE
	enum_elem TEXT_JR_PO
	enum_elem TEXT_JR_NZ
	enum_elem TEXT_JR_Z
	enum_elem TEXT_RAM_BANKSWITCH
	enum_elem TEXT_AND
	enum_elem TEXT_OR
	enum_elem TEXT_XOR
	enum_elem TEXT_BIT
	enum_elem END_TEXT_LEAVE_BOX
	enum_elem TEXT_MUSIC_FADE
	enum_elem TEXT_MUSIC_PLAY
	enum_elem TEXT_MUSIC_STOP
	enum_elem OVERRIDE_TEXBOX_PAL
	enum_elem CLOSE_TEXTBOX
	
	enum_elem INVALID_TXT_COMMAND ; WARNING : TEXT COMMAND PROCESSOR MUST BE UPDATED IF IDS 128+ ARE USED!!!


; -------- TEXT COMMAND MACROS ----------
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
IF _NARG == 0
	db BANK(name_prefix)
	dw name_prefix
ELSE
	db BANK(\1)
	dw \1
ENDC
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

print_line_id: MACRO
line_label EQUS STRCAT("{line_prefix}", "\1")
	print_line {line_label}
PURGE line_label
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

	
DONT_TURN	equ $04
ROTATE_45	equ $08
ROTATE_CW	equ $10

; make_npc_walk NPC_id dir len spd

; Apply "| DONT_TURN" to "dir" if the NPC shouldn't turn around
; Apply "| ROTATE_45" to "dir" if the NPC's movement direction should rotate by 45° counterclockwise
; If you want the NPC's movement to rotate clockwise instead (so you can pick any of the two "logical" facing directions), apply "| ROTATE_CW"
; Note : if ROTATE_CW is applied but not ROTATE_45, it won't have any effect (aside from wasting a couple cycles that do nothing)

; Note : ID 0 will target NPC 1, etc.
; To target the player, use the dedicated command below.
make_npc_walk: MACRO
	db MAKE_NPC_WALK
	db \1
	db \2
	db \3
	db \4
ENDM

; make_player_walk dir len spd

; Same remarks as the above.

make_player_walk: MACRO
	db MAKE_PLAYER_WALK
	db \1
	db \2
	db \3
ENDM


; choose str_choice ofs_2
; Remember to add the 5 of the MAKE_CHOICE command!
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

b_choice: MACRO
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

; Note that unlike the z80's `dec`, this updates the carry flag!
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
	db BANK(\1)
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


; Do a jr like the proc's one. Except the offset is calculated slightly differently, eg. text_jr $00 is an infinite loop!!
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

close_box: MACRO
	db CLOSE_TEXTBOX
ENDM
