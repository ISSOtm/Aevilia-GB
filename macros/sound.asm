; ================================================================
; DevSound macros
; ================================================================

if !def(incDSMacros)
incDSMacros	set	1

Instrument:		macro
	db	\1
	dw	\2,\3,\4,\5
	endm

Drum:			macro
	db	SetInstrument,\1,fix,\2
	endm
	
endc
