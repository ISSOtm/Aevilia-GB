

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
	enum_elem MAKE_NPC_WALK_TO
	enum_elem MAKE_PLAYER_WALK
	enum_elem MAKE_PLAYER_WALK_TO
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
	enum_elem TEXT_GET_FLAG
	enum_elem TEXT_SET_FLAG
	enum_elem TEXT_RESET_FLAG
	enum_elem TEXT_TOGGLE_FLAG
	enum_elem TEXT_LOAD_MAP
	enum_elem TEXT_START_ANIM
	enum_elem TEXT_END_ANIM
	
	enum_elem INVALID_TXT_COMMAND ; WARNING : TEXT COMMAND PROCESSOR MUST BE UPDATED IF IDS 128+ ARE USED!!!


; -------- TEXT COMMAND MACROS ----------

; Closes the textbox and ends all operations
done: MACRO
	db END_TEXT
ENDM


; Clears the textbox's contents
clear_box: MACRO
	db CLEAR_TEXT
ENDM


; print_pic ptr_to_pic
; Prints a picture on the left of the textbox,
; and sets the corresponding text flag (so text doesn't occupy its space).
; ptr_to_pic : Pointer to 9 tiles that will form the pic, in this order :
; 1 4 7
; 2 5 8
; 3 6 9
; WARNING : Do not use if text is already on-screen ! (Otherwise enjoy your overwrites)
; WARNING : May cause graphical issues if the textbox is already displayed
print_pic: MACRO
	db PRINT_PIC
	db BANK(\1)
	dw \1
ENDM


; print_name ptr_to_name
; Prints a name on the textbox top border and displays the textbox
; ptr_to_name : Pointer to the string to be printed
; WARNING : Printing more than 16 characters will cause some overwrites !
; Alternate syntax : Giving no argument will use the default name instead
;   (done using `set_text_prefix` and `dname`)
print_name: MACRO
IF _NARG == 0
	print_name name_prefix
ELSE
	db PRINT_NAME_AND_DISP
	db BANK(\1)
	dw \1
ENDC
ENDM

; Simply displays the textbox
disp_box: MACRO
	print_name NULL
ENDM


; Waits until the user PRESSES the A or B button
wait_user: MACRO
	db WAIT_FOR_BUTTON
ENDM


; print_str ptr_to_print
; Prints a line of text, scrolling the textbox is required
; ptr_to_print : Pointer to the string to be printed
; NOTE : Max string size = (without pic) 18, (with pic) 15 characters
; WARNING : Printing more characters than the limit will do some overwrites !
print_line: MACRO
	db PRINT_STRING
	db BANK(\1)
	dw \1
ENDM

; print_line_id line_id
; Prints a string of the current block (done using `set_text_prefix` and `dline`)
; line_id : ID of the string to be printed
print_line_id: MACRO
line_label EQUS STRCAT("{line_prefix}", "\1")
	print_line {line_label}
PURGE line_label
ENDM

; Prints an empty string, essentially dishing out en empty line
empty_line: MACRO
	db EMPTY_LINE
ENDM


; delay nb_frames
; Pauses processing for some time
; nb_frames : Number of frames to wait
delay: MACRO
	db DELAY_FRAMES
	dw \1
ENDM


; set_counter nb_iters
; Sets the repetition counter to an immediate value
; nb_iters : Value to set the counter
set_counter: MACRO
	db SET_COUNTER
	db \1
ENDM

; copy_counter source_ptr
; Sets the repetition counter from a memory address
; source_ptr : Pointer to copy from
copy_counter: MACRO
	db COPY_COUNTER
	dw \1
ENDM

; djnz offset
; Decrements the repetition counter, and if non-zero, jumps somewhere
; offset : number of bytes to jump (relative jump)
djnz: MACRO
	db DECREMENT_AND_JUMP
	db \1
ENDM


; disp_num type ptr
; Display a number from a memory address (words are displayed low-endian)
; type : Either
byte equ 0
word equ 1
; to choose the length of the number you want to display
; ptr : Pointer to the number you want to display
disp_num: MACRO
	db DISPLAY_NUMBER
	db \1 & 1
	dw \2
ENDM


; Instantly displays the textbox (w/o animation)
display_quick: MACRO
	db INSTANT_DISPLAY
ENDM

; Instantly closes the textbox (w/o animation)
close_quick: MACRO
	db INSTANT_CLOSE
ENDM

; Starts displaying the textbox, and returns before the animation finishes
display_nodelay: MACRO
	db DISP_WITHOUT_WAIT
ENDM

; Starts closing the textbox, and returns before the animation finishes
close_nodelay: MACRO
	db CLOSE_WITHOUT_WAIT
ENDM

	
DONT_TURN	equ $04
ROTATE_45	equ $08
ROTATE_CW	equ $10

; make_npc_walk NPC_id dir len spd
; Moves a NPC in a straight line
; NPC_id : ID of the target NPC, minus 1 (because NPCs are 1-8 normally)
;          To target the player instead, use "make_npc_walk"
; dir : Direction of movement, and also the NPC's direction
;       Apply "| DONT_TURN" if the NPC shouldn't turn around
;       Apply "| ROTATE_45" if the NPC's movement direction should rotate by 45° counterclockwise
;        If you want the NPC's movement to rotate clockwise instead (so you can pick any of the two "logical" facing directions), apply "| ROTATE_CW"
;        Note : if ROTATE_CW is applied but not ROTATE_45, it won't have any effect (aside from wasting a couple cycles that do nothing)
; len : How many pixels to travel (does not need to be a multiple of spd)
; spd : How many pixels the NPC will move per frame (except on last step if len % spd != 0)
make_npc_walk: MACRO
	db MAKE_NPC_WALK
	db \1
	db \2
	db \3
	db \4
ENDM

; turn_npc NPC_id dir
; Turns a NPC
; Same arguments as above, except for len & spd
; Note : using "DONT_TURN" essentialy turns this into a "delay 1"
turn_npc: MACRO
	make_npc_walk \1, \2, 0, 0
ENDM

VERTICAL_AXIS	equ $00
HORIZONTAL_AXIS	equ $02

; make_npc_walk_to NPC_id dir coord spd
; NPC_id is obvious
; dir should be either VERTICAL_AXIS or HORIZONTAL_AXIS
; coord is the target coord on that axis
; spd is obvious
make_npc_walk_to: MACRO
	db MAKE_NPC_WALK_TO
	db \1 | ((\2 & $02) << 4) ; Because the command's length cannot be more than 5 bytes, a little compression here...
	dw \3
	db \4
ENDM

; make_player_walk dir len spd
; Same as make_npc_walk, except there's no "NPC_id" because the player is the target
make_player_walk: MACRO
	db MAKE_PLAYER_WALK
	db \1
	db \2
	db \3
ENDM

; turn_player dir
; Meh
turn_player: MACRO
	make_player_walk \1, 0, 0
ENDM

; make_player_walk_to dir coord spd
; Refer to make_npc_walk
; Rather unorthodox internal ordering of arguments, but that's to avoid as much work as possible when passing to make_player_walk (internally)
make_player_walk_to: MACRO
	db MAKE_PLAYER_WALK_TO
	dw \2
	db \3
	db \1
ENDM


; choose str_choice ofs_2
; Lets the user choose between two options
; str_choice : Pointer to the strings to be written (both must be consecutive)
; ofs_2 : number of bytes to "consume" if the second choice has been selected
; (First choice keeps going "as normal")
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

; Same as "choose", but the B button automatically selects the second option
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
; Sets the graphics fade speed
; gfx_fade_speed : byte to be written to wFadeSpeed (raw, including bit 7)
set_fade_speed: MACRO
	db SET_FADE_SPEED
	db \1
ENDM

; Calls Fadein
gfx_fadein: MACRO
	db GFX_FADE_IN
ENDM

; Calls Fadeout
gfx_fadeout: MACRO
	db GFX_FADE_OUT
ENDM

; Calls ReloadPalettes (reloads palettes from WRAM to palette RAM)
reload_palettes: MACRO
	db RELOAD_PALETTES
ENDM


; text_lda src_ptr
; Indirectly loads a byte into the text accumulator
; src_ptr : Pointer to load the byte from
; Note : banking is straight up ignored
text_lda: MACRO
	db LDA_TEXT
	dw \1
ENDM

; text_lda_imm imm8
; Loads a 8-bit value into the text accumulator
; imm8 : Value to load
text_lda_imm: MACRO
	db LDAIMM_TEXT
	db \1
ENDM

; text_sta dest_ptr
; Stores the text accumulator's contents to a byte in memory
; dest_ptr : Pointer to load the byte to
text_sta: MACRO
	db STA_TEXT
	dw \1
ENDM

; text_cmp imm8
; Compares the value of the text accumulator with a value and updates the flags
; imm8 : The value to compare to
text_cmp: MACRO
	db CMP_TEXT
	db \1
ENDM

; Decrements the text accumulator
; Note that unlike the z80's `dec`, this updates the carry flag!
; Also note that `inc` doesn't, otherwise C == Z (so it'd be pointless)
text_dec: MACRO
	db DEC_TEXT
ENDM

; Increments the text accumulator
text_inc: MACRO
	db INC_TEXT
ENDM

; text_add imm8
; Adds a value to the text accumulator
; imm8 : The value to add
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
; Adds an indirect value to the text accumulator
; ptr : Pointer to the 8-bit value to be added
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
; ORs the text flags with the given mask
; mask : bitfield of the masks to set
; (To reset, combine with a "toggle")
text_set_flags: MACRO
	db SET_TEXT_FLAGS
	db \1
ENDM

; text_toggle_flags mask
; XORs the text flags with the given mask
; mask : bitfield of the masks to toggle
text_toggle_flags: MACRO
	db TOGGLE_TEXT_FLAGS
	db \1
ENDM


; text_asmcall funcptr
; Calls a function directly (must be in ROM)
; funcptr : label of the function to be called
text_asmcall: MACRO
	db TEXT_CALL_FUNCTION
	db BANK(\1)
	dw \1
ENDM


; instant_str ptr
; Instantly prints all three strings pointed to (contiguous)
; ptr : pointer to the first string
instant_str: MACRO
	db INSTANT_PRINT_STRS
	db BANK(\1)
	dw \1
ENDM


; Reloads the text flags according to the accumulator (only exception is C, which is preserved)
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


; text_bankswitch bank
; Switches WRAM banks
; bank : target bank
text_bankswitch: MACRO
	db TEXT_RAM_BANKSWITCH
	db \1
ENDM


; text_and mask
; ANDS the text accumulator with the given mask
text_and: MACRO
	db TEXT_AND
	db \1
ENDM

; text_or mask
text_or: MACRO
	db TEXT_OR
	db \1
ENDM

; test_xor mask
text_xor: MACRO
	db TEXT_XOR
	db \1
ENDM

; test_bit bit_num
; ANDs the text accumulator with the given mask, but only updates flags (doesn't write back)
text_bit: MACRO
	db TEXT_BIT
	db \1
ENDM


; Ends the text stream (just like "done" would) but doesn't close the text box
end_with_box: MACRO
	db END_TEXT_LEAVE_BOX
ENDM


; fade_music fade_type
; Fades music out/in/out fully
; fade_type : Use DevSound's fade types
fade_music: MACRO
	db TEXT_MUSIC_FADE
	db \1
ENDM

; play_music music_id
; Plays a music track
; music_id : ID of the song to be played
play_music: MACRO
	db TEXT_MUSIC_PLAY
	db \1
ENDM

; Instantly stops the music (use DS_Fade beforehand !)
stop_music: MACRO
	db TEXT_MUSIC_STOP
ENDM


; color_textbox ptr_to_palette
; Overrides the textbox's color palette
; ptr_to_palette : pointer to the palette to be loaded
color_textbox: MACRO
	db OVERRIDE_TEXBOX_PAL
	dw \1
ENDM


; Closes the textbox without ending the stream
close_box: MACRO
	db CLOSE_TEXTBOX
ENDM


; Gets the state of a given game flag in the Z text flag
text_get_flag: MACRO
	db TEXT_GET_FLAG
	dw \1
ENDM

; Sets a game flag
text_set_flag: MACRO
	db TEXT_SET_FLAG
	dw \1
ENDM

text_reset_flag: MACRO
	db TEXT_RESET_FLAG
	dw \1
ENDM

text_toggle_flag: MACRO
	db TEXT_TOGGLE_FLAG
	dw \1
ENDM


; load_map map warp
load_map: MACRO
	db TEXT_LOAD_MAP
	db \1
	db \2
ENDM


; start_animation textSlot bank ptr
start_animation: MACRO
	db TEXT_START_ANIM
	IF _NARG == 2
		db BANK(\2)
		dw \2
	ELSE
		db \2
		dw \3
	ENDC
	db \1
ENDM

; end_animation textSlot
end_animation: MACRO
	db TEX_END_ANIM
ENDM
