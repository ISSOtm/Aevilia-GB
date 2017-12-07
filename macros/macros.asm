

enum_start: MACRO
	IF _NARG == 0
		enum_set 0
	ELSE
		enum_set \1
	ENDC
ENDM

enum_set: MACRO
enum_value = \1
ENDM

enum_skip: MACRO
	enum_set (enum_value + 1)
ENDM

enum_elem: MACRO
\1 = enum_value
	enum_skip
ENDM


dn: MACRO
	REPT _NARG / 2
		db ((\1 & $0F) << 4) | (\2 & $0F)
		shift
		shift
	ENDR
	
	; If there's an odd number of arguments, imply a 0 for the last arg
	IF _NARG % 2 == 1
		db (\1 & $0F) << 4
	ENDC
ENDM

dbfill: MACRO
	REPT \1
		db \2
	ENDR
ENDM

dwfill: MACRO
	REPT \1
		dw \2
	ENDR
ENDM


dbor: MACRO
value = 0
	REPT _NARG
value = value | \1
		shift
	ENDR
	
	db value
ENDM

dbw: MACRO
	db \1
	dw \2
ENDM


save_rom_bank: MACRO
	ldh a, [hCurROMBank]
	push af
ENDM

restore_rom_bank: MACRO
	pop af
	rst bankswitch
ENDM


; Usage : full_ptr label
; Places a label and its bank into memory
full_ptr: MACRO
	db BANK(\1) ; Throws an error if not in bank 0 to 255 (would fuck up otherwise)
	dw \1
ENDM

; Usage : dstr "string"
; Adds the NULL after the string.
dstr: MACRO
	REPT _NARG
		db \1
		shift
	ENDR
	db 0
ENDM

; Usage : dspr ypos, xpos, tile, attr
dspr: MACRO
	db LOW(\1 + 16)
	db LOW(\2 + 8)
	db \3
	db \4
ENDM


; Usage : homecall label
; Calls a function in a given ROM bank
; Shouldn't be used from within ROMX
homecall: MACRO
	IF _NARG == 1
		ld a, BANK(\1)
		rst bankswitch
		call \1
	ELSE
		ld a, BANK(\2)
		rst bankswitch
		call \1,\2
	ENDC
ENDM

homejump: MACRO
	IF _NARG == 1
		ld a, BANK(\1)
		rst bankswitch
		jp \1
	ELSE
		ld a, BANK(\2)
		rst bankswitch
		jp \1,\2
	ENDC
ENDM

; Usage : callacross label
; Calls a function across ROM banks
; WARNING : only de and c are passed to the function intact!
callacross: MACRO
	IF _NARG == 1
		ld b, BANK(\1)
		ld hl, \1
		call CallAcrossBanks
	ELSE
		ld b, BANK(\2)
		ld hl, \2
		call \1, CallAcrossBanks
	ENDC
ENDM

jpacross: MACRO
	IF _NARG == 1
		ld b, BANK(\1)
		ld hl, \1
		jp CallAcrossBanks
	ELSE
		ld b, BANK(\2)
		ld hl, \2
		jp \1, CallAcrossBanks
	ENDC
ENDM

; Usage : copyacross source dest length
; Copies data across ROM banks
; Either uses CopyAcrossLite or CopyAcross, depending on the number of bytes to copy
copyacross: MACRO
	ld hl, \1
	ld de, \2
	callcopyacross \3 BANK(\1)
ENDM

; Usage : callcopyacross length bank
; Sets up a call to the corresponding "across copy" function depending on transfer size
; Setting up the source and destination is left to the caller, though
callcopyacross: MACRO
	IF (\1 >> 8)
		ld bc, \1
		ld a, \2
		call CopyAcross
	ELSE
		ld c, \1
		ld b, \2
		call CopyAcrossLite
	ENDC
ENDM
