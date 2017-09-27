; ================================================================
; DevSound song data
; ================================================================
	
; =================================================================
; Song speed table
; =================================================================

SongSpeedTable:
	db	6,6	; safe place
	db	2,3	; battle 1
	db	4,4	; menu
	db	4,4	; overworld
	db	2,2	; corruption
	db	2,3	; boss 1
	db	2,3	; scare chord
	
SongPointerTable:
	dw	PT_SafePlace
	dw	PT_Battle1
	dw	PT_Menu
	dw	PT_Overworld
	dw	PT_Corruption
	dw	PT_Boss1
	dw	PT_ScareChord

; =================================================================
; Volume sequences
; =================================================================

; Wave volume values
w0			equ	%00000000
w1			equ	%01100000
w2			equ	%01000000
w3			equ	%00100000

; For pulse instruments, volume control is software-based by default.
; However, hardware volume envelopes may still be used by adding the
; envelope length * $10.
; Example: $3F = initial volume $F, env. length $3
; Repeat that value for the desired length.
; Note that using initial volume $F + envelope length $F will be
; interpreted as a "table end" command, use initial volume $F +
; envelope length $0 instead.
; Same applies to initial volume $F + envelope length $8 which
; is interpreted as a "loop" command, use initial volume $F +
; envelope length $0 instead.

vol_Dummy			db	$f,$ff

vol_Kick:			db	$18,$ff
vol_Snare:			db	$1d,$ff
vol_OHH:			db	$48,$ff
vol_CymbQ:			db	$6a,$ff
vol_CymbL:			db	$3f,$ff

vol_Echo1a:			db	$1c,$ff
vol_Echo1b:			db	$16,$ff
vol_Echo2:			db	2,2,2,2,2,2,2,2,2,2,2,2,1,$ff
vol_WaveBass:		db	w3,$ff
vol_QuietLead:		db	3,$ff
vol_QuietLeadFade:	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
					db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
					db	0,$ff
					
vol_Arp1:			db	$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d
					db	$19,$18,$18,$18,$18,$18,$18,$18,$18,$18
					db	$19,$ff
vol_PulseLead1:		db	$4c,$ff	
vol_WaveBass2a:		db	w3,w3,w3,w3,w3,w1,w1,w2,$ff
vol_WaveBass2b:		db	w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w3,w1,w1,w2,$ff

vol_CorruptionFade:	db	$90,$ff

vol_WaveTrill:		db	w3,w3,w3,w3,w3,w2,w2,w2,w2,w2,w1,w1,w1,w1,w1,w1,w1,w1,w1,w1,w0,$ff
vol_PulseTrill:		db	$1f,$ff
vol_Boss1Instr8:	db	$5f,$ff
vol_Boss1Instr8Vol6:db	$56,$ff
vol_Boss1Instr0:	db	$3f,$ff

vol_LongFade:
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db	5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	db	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
	db	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	db	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
	db	5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	db	4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	db	1,$ff
vol_LongFade2:	
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db	4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	db	1,$ff
	
vol_ScareChord:
	rept	60
	db	$7f
	endr
	rept	20
	db	2
	endr
	db	1,$ff
	
vol_ScareChordWave:
	rept	40
	db	w3
	endr
	rept	27
	db	w2
	endr
	db	w1,$ff
				
; =================================================================
; Arpeggio sequences
; =================================================================

arp_Pluck:			db	12,0,$ff

arp_Trill5:			db	5,5,0,0,$80,0
arp_Trill6:			db	6,6,0,0,$80,0
arp_Trill7:			db	7,7,0,0,$80,0
arp_Boss1Instr0:	db	12,0,$ff
arp_Boss1Instr8:	db	12,0,$ff

arp_ScareChordTom:	db	22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,$ff

; =================================================================
; Noise sequences
; =================================================================

; Noise values are the same as Deflemask, but with one exception:
; To convert 7-step noise values (noise mode 1 in deflemask) to a
; format usable by DevSound, take the corresponding value in the
; arpeggio macro and add s7.
; Example: db s7+32 = noise value 32 with step lengh 7
; Note that each noiseseq must be terminated with a loop command
; ($80) otherwise the noise value will reset!

s7	equ	$2d

noiseseq_Kick:	db	32,26,37,$80,2
noiseseq_Snare:	db	s7+29,s7+23,s7+20,35,$80,3
noiseseq_Hat:	db	41,43,$80,1
noiseseq_S7:	db	s7,$80,1

; =================================================================
; Pulse sequences
; =================================================================

pulse_12:			db	0,$ff
pulse_25:			db	1,$ff
pulse_50:			db	2,$ff
pulse_75:			db	3,$ff

pulse_Arp1:			db	0,0,1,1,1,2,2,3,3,3,2,2,1,1,1,$80,0

pulse_ScareChord:	db	0,0,0,1,1,1,2,2,2,2,0,0,0,0,0,0,0,0,0,0,$80,0

; =================================================================
; Vibrato sequences
; Must be terminated with a loop command!
; =================================================================

vib_Dummy:			db	0,0,$80,1

vib_WaveBass:		db	48,2,4,6,4,2,0,-2,-4,-6,-4,-2,0,$80,1
vib_QuietLead:		db	12,1,1,0,0,-1,-1,0,0,$80,1
vib_QuietLeadFade:	db	1,1,1,0,0,-1,-1,0,0,$80,1

; =================================================================
; Wave sequences
; =================================================================

WaveTable:
	dw	DefaultWave
	dw	wave_Bass1
	dw	wave_Pulse
	dw	wave_Rand
	dw	wave_ScareChord
	
wave_Bass1:			db	$02,$46,$8a,$ce,$ff,$fe,$ed,$dc,$ba,$98,$76,$54,$33,$22,$11,$00
wave_Pulse:			db	$cc,$cc,$cc,$cc,$cc,$c0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
wave_Rand:			db	$A6,$F0,$4D,$5F,$FC,$3B,$B7,$FF,$92,$EB,$A9,$8A,$9C,$2B,$45,$DA
wave_ScareChord:	db	$ff,$ff,$ff,$ff,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$f0,$00,$00,$00
	
; use $c0 to use the wave buffer
waveseq_Bass:		db	1,$ff
waveseq_Pulse:		db	2,$ff
waveseq_Rand:		db	3,$ff
waveseq_ScareChord:	db	4,$ff
waveseq_Buffer:		db	$c0,$ff

; =================================================================
; Instruments
; =================================================================

InstrumentTable:	
	dw	ins_Kick
	dw	ins_Snare
	dw	ins_CHH
	dw	ins_OHH
	dw	ins_CymbQ
	dw	ins_CymbL
	
	dw	ins_WaveBass
	dw	ins_Echo1a
	dw	ins_Echo1b
	dw	ins_Echo2
	dw	ins_QuietLead
	dw	ins_QuietLeadFade
	
	dw	ins_Arp1
	dw	ins_PulseLead1a
	dw	ins_PulseLead1b
	dw	ins_WaveBass2a
	dw	ins_WaveBass2b
	
	dw	ins_CorruptionFade
	dw	ins_CorruptionWave
	
	dw	ins_WaveTrill
	dw	ins_PulseTrill5
	dw	ins_PulseTrill7
	dw	ins_Boss1Lead
	dw	ins_Boss1Echo1
	dw	ins_Boss1Echo2
	dw	ins_Boss1Bass
	
	dw	ins_ScareChord
	dw	ins_ScareChordWave
	dw	ins_ScareChordNoise
	
; Instrument format: [no reset flag],[wave mode (ch3 only)],[voltable id],[arptable id],[pulsetable/wavetable id],[vibtable id]
; note that wave mode must be 0 for non-wave instruments
;!!! REMEMBER TO ADD INSTRUMENTS TO THE INSTRUMENT POINTER TABLE!!!
ins_Kick:				Instrument	0,vol_Kick,noiseseq_Kick,DummyTable,DummyTable	; pulse/waveseq and vibrato unused by noise instruments
ins_Snare:				Instrument	0,vol_Snare,noiseseq_Snare,DummyTable,DummyTable
ins_CHH:				Instrument	0,vol_Kick,noiseseq_Hat,DummyTable,DummyTable
ins_OHH:				Instrument	0,vol_OHH,noiseseq_Hat,DummyTable,DummyTable
ins_CymbQ:				Instrument	0,vol_CymbQ,noiseseq_Hat,DummyTable,DummyTable
ins_CymbL:				Instrument	0,vol_CymbL,noiseseq_Hat,DummyTable,DummyTable

ins_WaveBass:			Instrument	0,vol_WaveBass,DummyTable,waveseq_Bass,vib_WaveBass
ins_Echo1a:				Instrument	0,vol_Echo1a,DummyTable,pulse_50,vib_Dummy
ins_Echo1b:				Instrument	0,vol_Echo1b,DummyTable,pulse_50,vib_Dummy
ins_Echo2:				Instrument	0,vol_Echo2,DummyTable,pulse_50,vib_Dummy
ins_QuietLead:			Instrument	0,vol_QuietLead,DummyTable,pulse_25,vib_QuietLead
ins_QuietLeadFade:		Instrument	0,vol_QuietLeadFade,DummyTable,pulse_25,vib_QuietLeadFade

ins_Arp1:				Instrument	1,vol_Arp1,ArpBuffer,pulse_Arp1,vib_Dummy
ins_PulseLead1a:		Instrument	0,vol_PulseLead1,arp_Pluck,pulse_25,vib_Dummy
ins_PulseLead1b:		Instrument	0,vol_PulseLead1,arp_Pluck,pulse_50,vib_Dummy

ins_WaveBass2a:			Instrument	0,vol_WaveBass2a,arp_Pluck,waveseq_Pulse,vib_Dummy
ins_WaveBass2b:			Instrument	0,vol_WaveBass2b,arp_Pluck,waveseq_Pulse,vib_Dummy

ins_CorruptionFade:		Instrument	0,vol_CorruptionFade,DummyTable,DummyTable,vib_Dummy
ins_CorruptionWave:		Instrument	0,vol_WaveBass,DummyTable,waveseq_Rand,vib_Dummy

ins_WaveTrill:			Instrument	0,vol_WaveTrill,arp_Trill5,waveseq_Buffer,vib_Dummy

ins_PulseTrill5:		Instrument	0,vol_PulseTrill,arp_Trill5,pulse_25,vib_Dummy
ins_PulseTrill7:		Instrument	0,vol_PulseTrill,arp_Trill7,pulse_25,vib_Dummy
ins_Boss1Lead:			Instrument	0,vol_Boss1Instr8,arp_Boss1Instr8,pulse_25,vib_Dummy
ins_Boss1Echo1:			Instrument	0,vol_Boss1Instr8,arp_Boss1Instr8,pulse_50,vib_Dummy
ins_Boss1Echo2:			Instrument	0,vol_Boss1Instr8Vol6,arp_Boss1Instr8,pulse_50,vib_Dummy
ins_Boss1Bass:			Instrument	0,vol_Boss1Instr0,arp_Boss1Instr0,pulse_12,vib_Dummy

ins_ScareChord:			Instrument	0,vol_ScareChord,arp_Trill6,pulse_ScareChord,vib_Dummy
ins_ScareChordWave:		Instrument	0,vol_ScareChordWave,arp_ScareChordTom,waveseq_ScareChord,vib_Dummy
ins_ScareChordNoise:	Instrument	0,vol_Dummy,noiseseq_S7,DummyTable,DummyTable

_ins_Kick				equ	0
_ins_Snare				equ	1
_ins_CHH				equ	2
_ins_OHH				equ	3
_ins_CymbQ				equ	4
_ins_CymbL				equ	5

_ins_WaveBass			equ	6
_ins_Echo1a				equ	7
_ins_Echo1b				equ	8
_ins_Echo2				equ	9
_ins_QuietLead			equ	10
_ins_QuietLeadFade		equ	11

_ins_Arp1				equ	12
_ins_PulseLead1a		equ	13
_ins_PulseLead1b		equ	14
_ins_WaveBass2a			equ	15
_ins_WaveBass2b			equ	16
_ins_CorruptionFade		equ	17
_ins_CorruptionWave		equ	18

_ins_WaveTrill			equ	19
_ins_PulseTrill5		equ	20
_ins_PulseTrill7		equ	21
_ins_Boss1Lead			equ	22
_ins_Boss1Echo1			equ 23
_ins_Boss1Echo2			equ 24
_ins_Boss1Instr0		equ 25

_ins_ScareChord			equ	25
_ins_ScareChordWave		equ	26
_ins_ScareChordNoise	equ	27

Kick				equ	_ins_Kick
Snare				equ	_ins_Snare
CHH					equ	_ins_CHH
OHH					equ	_ins_OHH
CymbQ				equ	_ins_CymbQ
CymbL				equ	_ins_CymbL

; =================================================================

PT_SafePlace:	dw	SafePlace_CH1,SafePlace_CH2,SafePlace_CH3,DummyChannel

SafePlace_CH1:
	db	SetInsAlternate,_ins_Echo1a,_ins_Echo1b
	db	SetLoopPoint
	rept	4
	db	CallSection
	dw	.block1
	endr
	rept	4
	db	CallSection
	dw	.block2
	endr
	db	GotoLoopPoint
	
.block1
	db	D#5,2,D#5,2,G_4,2,G_4,2,F_4,2,F_4,2,G_4,2,G_4,2
	ret
	
.block2
	db	F_5,2,F_5,2,C_5,2,C_5,2,A_4,2,A_4,2,C_5,2,C_5,2
	ret
	
SafePlace_CH2:
	db	SetLoopPoint
	db	SetInstrument,_ins_Echo2
	db	rest,2
	rept	2
	rept	4
	db	CallSection
	dw	.block1
	endr
	rept	4
	db	CallSection
	dw	.block2
	endr
	endr
	db	rest,2
	db	SetInstrument,_ins_QuietLead	
	db	D#6,2,rest,2,D#6,4,D_6,4,C_6,8,A#5,8
	db	C_6,2,D_6,2,C_6,8,A#5,4,C_6,8,A#5,4,G_5,4
	db	G#5,1,A_5,11,G_5,4,F_5,8,D#5,8
	db	F_5,12,G_5,4,F_5,8,C_6,4,D_6,4
	db	D#6,12,D_6,4,C_6,8,D_6,8
	db	D#6,4,D_6,4,C_6,4,D_6,4,C_6,4,D#6,4,G_6,4,A#6,4
	db	G_6,1,A_6,11,G_6,4,F_6,8,C_6,8,F_5,16
	db	SetInstrument,_ins_QuietLeadFade
	db	F_5,16
	db	GotoLoopPoint

.block1
	db	D#5,4,G_4,4,F_4,4,G_4,4
	ret
	
.block2
	db	F_5,4,C_5,4,A_4,4,C_5,4
	ret
	
SafePlace_CH3:
	db	SetInstrument,_ins_WaveBass
	db	SetLoopPoint
	db	D#3,32,D#4,16,D#3,12,F_3,2,G_3,2
	db	F_3,32,F_4,16,F_3,12,G_3,2,F_3,2
	db	GotoLoopPoint
	
; ================================================================

PT_Battle1:
	dw	Battle1_CH1,Battle1_CH2,Battle1_CH3,Battle1_CH4
	
Battle1_CH1:
	db	rest,128
	db	SetLoopPoint
	db	SetInstrument,_ins_PulseLead1a
	rept	2
	db	CallSection
	dw	.block1
	endr
	db	SetInstrument,_ins_PulseLead1b

	db	CallSection
	dw	.block2
	db	E_4,12,D_4,12,B_3,12,D_4,8,F#4,8,G_4,4,F#4,8,B_3,4,D_4,4,B_3,4
	db	CallSection
	dw	.block2
	db	D_4,8,F#4,4,E_4,64
	db	GotoLoopPoint
	
.block1
	db	E_4,4,B_3,4,E_4,4,G_4,4,F#4,4,D_4,4,B_3,4,E_4,24,D_4,4,E_4,4,D_4,4
	db	C_4,8,C_4,8,C_4,4,C_4,8,B_3,24,A_3,4,B_3,4,D_4,4
	ret
	
.block2
	db	E_4,4,C_4,4,D_4,4,E_4,8,G_4,12,F#4,8,G_4,4,F#4,8,D_4,12
	db	B_3,20,G_3,4,B_3,4,D_4,4,F#4,8,G_4,4,F#4,8,D_4,8,B_3,4
	db	E_4,20,E_4,4,F#4,4,G_4,4,A_4,8,G_4,4,F#4,8
	ret
	
Battle1_CH2:
	db	rest,128
	db	SetInstrument,_ins_Arp1
	db	SetLoopPoint
	db	rest,128,rest,128
	rept	3
	db	CallSection
	dw	.block1
	endr
	db	CallSection
	dw	.block2
	db	GotoLoopPoint
	
.block1
	db	Arp,0,$47,C_5,12,C_5,12,C_5,8
	db	D_5,12,D_5,12,D_5,8
	db	Arp,0,$37,B_4,12,B_4,12,B_4,8
	db	Arp,0,$49,G_4,12,G_4,12,Arp,0,$47,G_4,8
	ret
	
.block2
	db	Arp,0,$47,C_5,12,C_5,12,C_5,8
	db	D_5,12,D_5,12,D_5,8
	db	Arp,0,$57,E_5,12,E_5,12,E_5,8
	db	Arp,0,$47,E_5,12,E_5,12,E_5,8
	ret

Battle1_CH3:
	db	SetInstrument,_ins_WaveBass2a
	rept	2
	db	CallSection
	dw	.block3
	endr
	
	db	SetLoopPoint
	rept	2
	db	CallSection
	dw	.block1
	endr
	rept	3
	db	CallSection
	dw	.block2
	endr
	db	C_3,4,C_3,4,C_4,4,C_3,4,B_3,4,C_4,4,C_3,4,$80,16,D_3,8
	db	$80,15,D_3,4,D_4,4,D_3,4,C_4,4,D_4,4,D_3,4,G_2,4
	db	E_3,4,E_3,4,E_4,4,E_3,4,D_4,4,E_4,4,E_3,4,D_4,4
	db	E_3,4,E_4,4,E_3,4,E_4,4,G_4,4,F#4,4,D_4,4,E_4,4
	db	GotoLoopPoint

.block1
	db	E_3,4,E_3,4,E_4,4,E_3,4,D_4,4,E_4,4,E_3,4,D_4,4
	db	E_3,4,E_4,4,E_3,4,E_4,4,G_4,4,F#4,4,D_4,4,E_4,4
	db	C_3,4,C_3,4,C_4,4,C_3,4,G_3,4,C_3,4,C_4,4,B_3,4
	db	B_2,4,F#3,4,B_2,4,F#3,4,B_3,4,B_2,4,F#3,4,B_3,4
	ret
	
.block2
	db	C_3,4,C_3,4,C_4,4,C_3,4,B_3,4,C_4,4,C_3,4,$80,16,D_3,8
	db	$80,15,D_3,4,D_4,4,D_3,4,C_4,4,D_4,4,D_3,4,G_2,4
	db	B_2,4,B_2,4,B_3,4,B_2,4,A_3,4,B_3,4,B_2,4,$80,16,E_3,8
	db	$80,15,E_3,4,E_4,4,E_3,4,D_4,4,E_4,4,D_3,4,D_4,4
	ret
	
.block3
	db	E_3,4,E_3,4,E_4,4,E_3,4,D_4,4,E_4,4,E_3,4,D_4,4
	db	E_3,4,E_4,4,E_3,4,E_4,4,G_4,4,F#4,4,D_4,4,E_4,4
	ret
	
Battle1_CH4:
	db	CallSection
	dw	.block1
	Drum	Kick,4
	Drum	CHH,4
	Drum	Snare,4
	Drum	CHH,4
	Drum	Kick,4
	db		fix,4
	Drum	Snare,4
	Drum	CHH,4
	Drum	Kick,4
	db		fix,4
	Drum	Snare,4
	Drum	Kick,4
	Drum	CHH,4
	Drum	Kick,4
	Drum	Snare,4
	db		fix,4

	db	SetLoopPoint
	db	CallSection
	dw	.block1
	db	GotoLoopPoint
	
.block1
	Drum	Kick,4
	Drum	CHH,4
	Drum	Snare,4
	Drum	CHH,4
	Drum	Kick,4
	db		fix,4
	Drum	Snare,4
	Drum	CHH,4
	Drum	Kick,4
	db		fix,4
	Drum	Snare,4
	Drum	Kick,4
	Drum	CHH,4
	Drum	Kick,4
	Drum	Snare,4
	Drum	CHH,4
	ret

; ================================================================

PT_Menu:		dw	Scale_CH1,DummyChannel,DummyChannel,DummyChannel

; ================================================================

PT_Overworld:	dw	Scale_CH1,DummyChannel,DummyChannel,DummyChannel

; ================================================================

PT_Corruption:	dw	Corruption_CH1,Corruption_CH2,Corruption_CH3,Corruption_CH4

Corruption_CH1:
	db	SetInstrument,69
	db	SetLoopPoint
	db	$1B,$04,$02,$0C,$0E,$25,$20,$27,$0F,$2B,$27,$0B,$09,$21,$00,$2A
	db	$04,$02,$00,$20,$0F,$2F,$28,$04,$14,$10,$28,$2A,$23,$2D,$2A,$10
	db	$23,$03,$0E,$0E,$02,$1D,$30,$18,$20,$1D,$09,$10,$1C,$0F,$17,$03
	db	$15,$0B,$0D,$01,$11,$0E,$28,$11,$0D,$13,$0A,$13,$15,$2D,$0B,$1E
	db	$2B,$04,$30,$26,$06,$30,$1A,$2E,$05,$26,$2F,$2C,$14,$19,$27,$00
	db	GotoLoopPoint
	
Corruption_CH2:
	db	SetInstrument,_ins_CorruptionFade
	db	SetChannelPtr
	dw	$4981
	
Corruption_CH3:
	db	SetInstrument,_ins_CorruptionWave
	db	SetLoopPoint
	db	$08,$1B,$20,$0A,$04,$16,$2A,$12,$1B,$28,$1A,$14,$2B,$02,$26,$2B
	db	$0D,$00,$1E,$13,$18,$2A,$05,$2E,$1E,$1B,$11,$15,$21,$2A,$06,$00
	db	$11,$2A,$23,$22,$0F,$2B,$09,$1F,$30,$25,$20,$09,$1D,$0A,$25,$0B
	db	$22,$25,$19,$2A,$00,$03,$21,$05,$22,$0B,$1A,$0B,$25,$28,$16,$00
	db	GotoLoopPoint

Corruption_CH4:
	db	SetInstrument,$42
	db	SetLoopPoint
	db	$0A,$0A,$10,$01,$27,$04,$1D,$1F,$03,$0D,$21,$13,$14,$1D,$00,$2A
	db	$26,$2D,$01,$10,$0D,$2B,$18,$2A,$0A,$30,$13,$12,$0B,$28,$09,$2F
	db	$27,$28,$02,$22,$1B,$2B,$0F,$16,$13,$0E,$18,$17,$27,$10,$1E,$2C
	db	$1A,$15,$0e,$17,$03,$08,$0F,$26,$18,$0B,$0B,$0A,$04,$27,$22,$0F
	db	GotoLoopPoint
	
; ================================================================

PT_Boss1:	dw	Boss1_CH1,Boss1_CH2,Boss1_CH3,Boss1_CH4
	
Boss1_CH1:
	db	SetInstrument,_ins_PulseTrill5
	
	db	CallSection
	dw	.block1
	db	CallSection
	dw	.block1
	db	SetInsAlternate,_ins_PulseTrill7,_ins_PulseTrill5
	db	E_5,8,B_4,4
	db	E_5,8,B_4,4
	db	E_5,8,B_4,4
	db	E_5,8,B_4,4
	db	D_5,4,A_4,4
	db	D#5,4,A#4,4
	db	E_6,8,B_4,4
	db	E_6,8,B_4,4
	db	E_6,8,B_4,4
	db	E_6,8,B_4,4
	db	D_6,4,A_4,4
	db	D#6,4,A#4,4
	
	db	SetLoopPoint
	db	SetInstrument,_ins_Boss1Lead
	
	db	E_4,24,G_4,8,F_4,2,F#4,10,E_4,12,D_4,8
	db	E_4,32,D_4,12,F#4,12,D_4,8
	db	D_4,2,E_4,22,G_4,8,A_4,8,G_4,4,F#4,8,G_4,4,F#4,8
	db	G_4,32,A_4,12,F#4,12,D_4,8
	db	SetInsAlternate,_ins_Boss1Echo1,_ins_Boss1Echo2
	db	CallSection
	dw	.block2
	db	E_4,8,E_4,4,G_4,8,G_4,4,E_4,2,G_4,2,G_4,2,E_4,2
	db	A_4,6,A_4,2,G_4,2,G_4,2,F#4,6,F#4,2,G_4,2,F#4,2,F#4,2,G_4,2,E_4,2,F#4,2
	db	B_3,2,E_4,2,D#4,2,B_3,2,B_3,2,D#4,2,F#4,6,F#4,2,G_4,2,F#4,2,F#4,2,G_4,2,D_4,2,F#4,2
	db	E_4,16,E_4,4,G_4,2,E_4,2,F#4,2,G_4,2,D_4,2,F#4,2
	db	CallSection
	dw	.block2
	db	E_4,8,E_4,4,G_4,8,G_4,4,E_4,2,G_4,2,G_4,2,E_4,2
	db	A_4,6,A_4,2,G_4,2,G_4,2,F#4,6,F#4,2,G_4,2,F#4,2,F#4,2,G_4,2,D_4,2,F#4,2
	db	SetInstrument,_ins_Boss1Echo1
	db	D_4,2,E_4,62
	db	GotoLoopPoint
	
.block1
	db	B_5,8,B_4,4
	db	B_5,8,B_4,4
	db	B_5,8,B_4,4
	db	B_5,8,B_4,4
	db	A_5,4,A_4,4
	db	A#5,4,A#4,4
	ret
	
.block2
	db	E_4,2,E_4,2
	db	F#4,2,E_4,2
	db	G_4,2,F#4,2
	db	E_4,2,G_4,2
	db	F#4,2,E_4,2
	db	G_4,2,F#4,2
	db	E_4,2,E_4,2
	db	G_4,2,G_4,2
	db	A_4,6,A_4,2
	db	G_4,2,A_4,2
	db	F#4,6,F#4,2
	db	E_4,10,E_4,2
	
	db	B_3,8,B_3,4
	db	D#4,8,D#4,4
	db	B_3,2,B_3,2
	db	D#4,2,D#4,2
	db	F#4,2,F#4,2
	db	G_4,2,F#4,2
	db	F#4,2,G_4,2
	db	E_4,4,E_4,4
	db	D_4,4,D_4,4
	db	B_3,2,B_3,2
	ret

Boss1_CH2:
	db	SetInstrument,_ins_Boss1Instr0
	
rept 4
	db	CallSection
	dw	.block0
endr
	db	SetLoopPoint
rept 2
	db	CallSection
	dw	.block1
endr
	db	CallSection
	dw	.block3
rept 3
	db	CallSection
	dw	.block2
endr
	db	E_2,4,E_2,4,E_3,4,E_2,4,E_2,4,E_3,4,E_2,4,E_2,4
	db	E_2,4,E_2,4,E_3,4,E_2,4,E_2,4,E_3,4,E_2,4,E_2,4
	
	db	GotoLoopPoint
	
.block0
	db	E_2,4,E_2,4,E_3,4,E_2,4,E_2,4,E_3,4,E_2,4,E_2,4
	db	E_3,4,E_2,4,E_2,4,E_3,4,D_2,4,D_3,4,D#2,4,D#3,4
	ret
	
.block1
	db	E_2,4,E_2,4,E_3,4,E_2,4,E_2,4,E_3,4,E_2,4,E_3,4
	db	D_2,4,D_2,4,D_3,4,D_2,4,D_2,4,D_3,4,D_2,4,D_3,4
	db	C_2,4,C_2,4,C_3,4,C_2,4,C_2,4,C_3,4,C_2,4,C_3,4
	db	D_2,4,D_2,4,D_3,4,D_2,4,D_2,4,D_3,4,D_2,4,D_3,4
	ret
	
.block2
	db	D#2,4,D#2,4,D#3,4,D#2,4,D#2,4,D#3,4,D#2,4,D#3,4
	db	E_2,4,E_2,4,E_3,4,E_2,4,D_2,4,D_3,4,D_2,4,D_3,4
	
.block3
	db	C_2,4,C_2,4,C_3,4,C_2,4,C_2,4,C_3,4,C_2,4,C_3,4
	db	D_2,4,D_2,4,D_3,4,D_2,4,D_2,4,D_3,4,D_2,4,D_3,4
	ret
	
Boss1_CH3:
	db	SetInstrument,_ins_WaveTrill
	db	EnablePWM,$f,7
	rept	4
	db	CallSection
	dw	.block1
	endr
	
	db	EndChannel
	
.block1
	db	B_5,12,B_5,12,B_5,12,B_5,12,A_5,8,A#5,8
	ret
	
Boss1_CH4:
	rept	3
	db	CallSection
	dw	.block1
	Drum	Kick,4
	endr
	db	CallSection
	dw	.block1
	Drum	Snare,4
	db	SetChannelPtr
	dw	Battle1_CH4
	
.block1
	Drum	Kick,4
	Drum	CHH,4
	Drum	Snare,4
	Drum	OHH,4
	Drum	Kick,4
	Drum	Snare,4
	Drum	OHH,4
	Drum	Kick,4
	Drum	Snare,4
	Drum	OHH,4
	Drum	Kick,4
	Drum	Snare,4
	Drum	OHH,4
	Drum	Kick,4
	Drum	Snare,4
	ret

; ================================================================

PT_ScareChord	dw	ScareChord_CH1,ScareChord_CH1,ScareChord_CH3,ScareChord_CH4

ScareChord_CH1:
	db	SetInstrument,_ins_ScareChord
	db	G_5,40
	db	rest,1
	db	EndChannel
	
ScareChord_CH3:
	db	SetInstrument,_ins_ScareChordWave
	db	fix,40
	db	rest,1
	db	EndChannel
	
ScareChord_CH4:
	db	SetInstrument,_ins_ScareChordNoise
	db	G_4,1,F#4,1,F_4,1,E_4,1,D#4,1,D_4,1,C#4,1,C_4,1,B_3,1,A#3,1,A_3,1,G#3,1
	db	G_3,1,F#3,1,F_3,1,E_3,1,D#3,1,D_3,1,C#3,1,C_3,1,B_2,1,A#2,1,A_2,1,G#2,1
	db	rest,1
	db	EndChannel

; ================================================================

Scale_CH1:
	db	SetInstrument,_ins_PulseLead1a,C_3,4,D_3,4,E_3,4,F_3,4,G_3,4,A_3,4,B_3,4,C_4,4,EndChannel