; ================================================================
; DevSound macros
; ================================================================

Instrument:		macro
	db	\1
if "\2" == "_"
	dw	DummyTable
else
	dw	vol_\2
endc
if "\3" == "_"
	dw	DummyTable
else
	dw	arp_\3
endc
if "\4" == "_"
	dw	DummyTable
else
	dw	waveseq_\4
endc
if "\5" == "_"
	dw	vib_Dummy
else
	dw	vib_\5
endc
	endm

Drum:			macro
	db	SetInstrument,id_\1,fix,\2
	endm

; Enumerate constants

const_def:		macro
const_value = 0
endm

const:			macro
if "\1" != "skip"
\1	equ const_value
endc
const_value = const_value + 1
ENDM

dins:			macro
	const	id_\1
	dw	ins_\1
endm
