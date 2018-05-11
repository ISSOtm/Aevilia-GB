
set_text_prefix: MACRO
IF DEF(name_prefix)
	PURGE name_prefix
ENDC
IF DEF(line_prefix)
	PURGE line_prefix
ENDC

name_prefix   EQUS "\1Name"
line_prefix   EQUS "\1Line"
ENDM

dline: MACRO
line_label EQUS STRCAT("{line_prefix}", "\1")
line_label::
	
	IF _NARG > 1
		; "REPT _NARG - 1" is apparently invalid, so instead...
isFirst	equ 1
		
		REPT _NARG
			IF isFirst == 1
isFirst = 0
			ELSE
				db \2
				shift
			ENDC
		ENDR
		
		db 0
	PURGE isFirst
	ENDC
	
	PURGE line_label ; Required, otherwise conflicts arise (!)
ENDM

dname: MACRO
name_prefix::
	
	IF _NARG > 0
		REPT _NARG
			db \1
			shift
		ENDR
		
		db 0
	ENDC
ENDM

