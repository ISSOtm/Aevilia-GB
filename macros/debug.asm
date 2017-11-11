
debug_message: MACRO
	IF DEF(DebugMode)
		ld d, d
		jr .debugMessage\@
		dw $6464
		dw $0000
		REPT _NARG
			db \1
			shift
		ENDR
.debugMessage\@
	ENDC
ENDM

debug_break: MACRO
	IF DEF(DebugMode)
		ld b, b
	ENDC
ENDM
