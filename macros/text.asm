
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
PURGE line_label ; Required, otherwise conflicts arise (!)
ENDM

dname: MACRO
name_prefix::
ENDM
