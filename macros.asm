
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


INCLUDE "macros/macros.asm"
INCLUDE "macros/memory.asm"
INCLUDE "macros/sound.asm"
INCLUDE "macros/map.asm"
