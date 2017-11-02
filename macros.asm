
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


INCLUDE "macros/debug.asm"
INCLUDE "macros/macros.asm"
INCLUDE "macros/memory.asm"
INCLUDE "macros/sound.asm"
INCLUDE "macros/map.asm"
INCLUDE "macros/text.asm"
