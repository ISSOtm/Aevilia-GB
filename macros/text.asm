
set_text_prefix: MACRO
if DEF(name_prefix)
	PURGE name_prefix
	PURGE line_prefix
ENDC

name_prefix EQUS "\1Name"
line_prefix EQUS "\1Line"
ENDM

dline: MACRO
line_label EQUS STRCAT("{line_prefix}", "\1")
line_label::
IF _NARG > 1
	dstr \2
ENDC
PURGE line_label ; Required, otherwise conflicts arise (!)
ENDM

dname: MACRO
name_prefix::
IF _NARG > 0
	dstr \1
ENDC
ENDM
