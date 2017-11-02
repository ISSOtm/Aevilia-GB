
debug_message: MACRO
	IF DEF(DebugMode)
		ld d, d
		jr .debugMessage\@
		dw $6464
		dw $0000
		dstr \1
.debugMessage\@
	ENDC
ENDM

debug_break: MACRO
	IF DEF(DebugMode)
		ld b, b
	ENDC
ENDM
