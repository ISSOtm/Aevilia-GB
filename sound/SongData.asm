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

; For pulse and noise instruments, volume control is software-based by default.
; However, when the table execution ends ($FF) the value after that terminator
; will be loaded as a hardware volume and envelope. Please be cautious that the
; envelope speed won't be scaled along the channel volume.

; For wave instruments, volume has the same range as the above (that's right,
; this is possible by scaling the wave data) except that it won't load the
; value after the terminator as a final volume.
; WARNING: since there's no way to rewrite the wave data without restarting
; the wave so make sure that the volume doesn't change too fast that it
; unintentionally produces sync effect

vol_Kick:			db	$ff,$81
vol_Snare:			db	$ff,$d1
vol_OHH:			db	$ff,$84
vol_CymbQ:			db	$ff,$a6
vol_CymbL:			db	$ff,$f3

vol_Echo1a:			db	$ff,$c1
vol_Echo1b:			db	$ff,$61
vol_Echo2:			db	2,2,2,2,2,2,2,2,2,2,2,2,1,$ff,1
vol_WaveBass:		db	15,$ff,15
vol_QuietLead:		db	$ff,3
vol_QuietLeadFade:	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
					db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
					db	0,$ff,0
					
vol_Arp1:			db	13,12,11,10,9,8,7,6,5,4,9,8,7,6,5,4,3,2,1,0,9,8,7,6,5,4,3,2,1,$ff,0
vol_PulseLead1:		db	$ff,$c4	
vol_WaveBass2a:		db	15,15,15,15,15,5,5,$ff,10
vol_WaveBass2b:		db	15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,5,5,$ff,10

vol_CorruptionFade:	db	$ff,$09

vol_WaveTrill:		db	15,15,15,15,15,8,8,8,8,8,4,4,4,4,4,4,4,4,4,4,0,$ff,0
vol_PulseTrill:		db	$ff,$f1
vol_Boss1Echo1:		db	$ff,$f5
vol_Boss1Echo2:		db	$ff,$65
vol_Boss1Bass:		db	$ff,$f3
vol_WaveEcho:		db	5,$ff,5

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
	db	$ff,1
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
	db	$ff,1
	
vol_ScareChord:
	db	15,15,15,15,15,15,15
	db	14,14,14,14,14,14,14
	db	13,13,13,13,13,13,13
	db	12,12,12,12,12,12,12
	db	11,11,11,11,11,11,11
	db	10,10,10,10,10,10,10
	db	9,9,9,9,9,9,9
	db	8,8,8,8,8,8,8
	db	7,7,7,7
	rept	20
	db	2
	endr
	rept	20
	db	1
	endr
	db	$ff,0
	
vol_ScareChordWave:
	rept	40
	db	15
	endr
	rept	27
	db	8
	endr
	db	4,$ff,4
				
; =================================================================
; Arpeggio/Noise sequences
; =================================================================

s7	equ	$2d

; Noise values are the same as Deflemask, but with one exception:
; To convert 7-step noise values (noise mode 1 in deflemask) to a
; format usable by DevSound, take the corresponding value in the
; arpeggio macro and add s7.
; Example: db s7+32 = noise value 32 with step lengh 7
; Note that each noiseseq must be terminated with a loop command
; ($fe) otherwise the noise value will reset!

arp_Kick:	db	$a0,$9a,$a5,$fe,2
arp_Snare:	db	s7+$9d,s7+$97,s7+$94,$a3,$fe,3
arp_Hat:	db	$a9,$ab,$fe,1
arp_S7:	db	s7,$fe,0

arp_Pluck:			db	12,0,$ff

arp_Trill5:			db	5,5,0,0,$fe,0
arp_Trill6:			db	6,6,0,0,$fe,0
arp_Trill7:			db	7,7,0,0,$fe,0
arp_Boss1Bass:	db	12,0,$ff
arp_Boss1Echo1:	db	12,0,$ff

arp_ScareChordTom:	db	22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,$ff

; =================================================================
; Pulse/Wave sequences
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
waveseq_ScareChordWave:	db	4,$ff
waveseq_Buffer:		db	$c0,$ff

waveseq_12:			db	0,$ff
waveseq_25:			db	1,$ff
waveseq_50:			db	2,$ff
waveseq_75:			db	3,$ff

waveseq_Arp1:			db	0,0,1,1,1,2,2,3,3,3,2,2,1,1,1,$fe,0

waveseq_ScareChord:	db	0,0,0,1,1,1,2,2,2,2,0,0,0,0,0,0,0,0,0,0,$fe,0

; =================================================================
; Vibrato sequences
; Must be terminated with a loop command!
; =================================================================

vib_Dummy:			db	0,0,$80,1

vib_WaveBass:		db	48,2,4,6,4,2,0,-2,-4,-6,-4,-2,0,$80,1
vib_QuietLead:		db	12,1,1,0,0,-1,-1,0,0,$80,1
vib_QuietLeadFade:	db	1,1,1,0,0,-1,-1,0,0,$80,1

; =================================================================
; Instruments
; =================================================================

InstrumentTable:
	const_def
	dins	Kick
	dins	Snare
	dins	CHH
	dins	OHH
	dins	CymbQ
	dins	CymbL
	
	dins	WaveBass
	dins	Echo1a
	dins	Echo1b
	dins	Echo2
	dins	QuietLead
	dins	QuietLeadFade
	
	dins	Arp1
	dins	PulseLead1a
	dins	PulseLead1b
	dins	WaveBass2a
	dins	WaveBass2b
	
	dins	CorruptionFade
	dins	CorruptionWave
	
	dins	WaveTrill
	dins	PulseTrill5
	dins	PulseTrill7
	dins	Boss1Lead
	dins	Boss1Echo1
	dins	Boss1Echo2
	dins	Boss1Bass
	dins	Boss1Wave
	dins	Boss1Echo
	
	dins	ScareChord
	dins	ScareChordWave
	dins	ScareChordNoise
	
; Instrument format: [no reset flag],[voltable id],[arptable id],[wavetable id],[vibtable id]
; _ for no table
;!!! REMEMBER TO ADD INSTRUMENTS TO THE INSTRUMENT POINTER TABLE!!!
ins_Kick:				Instrument	0,Kick,Kick,_,_	; pulse/waveseq and vibrato unused by noise instruments
ins_Snare:				Instrument	0,Snare,Snare,_,_
ins_CHH:				Instrument	0,Kick,Hat,_,_
ins_OHH:				Instrument	0,OHH,Hat,_,_
ins_CymbQ:				Instrument	0,CymbQ,Hat,_,_
ins_CymbL:				Instrument	0,CymbL,Hat,_,_

ins_WaveBass:			Instrument	0,WaveBass,_,Bass,WaveBass
ins_Echo1a:				Instrument	0,Echo1a,_,50,_
ins_Echo1b:				Instrument	0,Echo1b,_,50,_
ins_Echo2:				Instrument	0,Echo2,_,50,_
ins_QuietLead:			Instrument	0,QuietLead,_,25,QuietLead
ins_QuietLeadFade:		Instrument	0,QuietLeadFade,_,25,QuietLeadFade

ins_Arp1:				Instrument	1,Arp1,Buffer,Arp1,_
ins_PulseLead1a:		Instrument	0,PulseLead1,Pluck,25,_
ins_PulseLead1b:		Instrument	0,PulseLead1,Pluck,50,_

ins_WaveBass2a:			Instrument	0,WaveBass2a,Pluck,Pulse,_
ins_WaveBass2b:			Instrument	0,WaveBass2b,Pluck,Pulse,_

ins_CorruptionFade:		Instrument	0,CorruptionFade,_,_,_
ins_CorruptionWave:		Instrument	0,WaveBass,_,Rand,_

ins_WaveTrill:			Instrument	0,WaveTrill,Trill5,Buffer,_

ins_PulseTrill5:		Instrument	0,PulseTrill,Trill5,25,_
ins_PulseTrill7:		Instrument	0,PulseTrill,Trill7,25,_
ins_Boss1Lead:			Instrument	0,Boss1Echo1,Boss1Echo1,25,_
ins_Boss1Echo1:			Instrument	0,Boss1Echo1,Boss1Echo1,50,_
ins_Boss1Echo2:			Instrument	0,Boss1Echo2,Boss1Echo1,50,_
ins_Boss1Bass:			Instrument	0,Boss1Bass,Boss1Bass,12,_
ins_Boss1Wave:			Instrument	0,WaveBass,_,Pulse,_
ins_Boss1Echo:			Instrument	0,WaveEcho,_,Pulse,_

ins_ScareChord:			Instrument	0,ScareChord,Trill6,ScareChord,_
ins_ScareChordWave:		Instrument	0,ScareChordWave,ScareChordTom,ScareChordWave,_
ins_ScareChordNoise:	Instrument	0,_,S7,_,_

; =================================================================

PT_SafePlace:	dw	SafePlace_CH1,SafePlace_CH2,SafePlace_CH3,DummyChannel

SafePlace_CH1:
	db	SetInsAlternate,id_Echo1a,id_Echo1b
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
	db	SetInstrument,id_Echo2
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
	db	SetInstrument,id_QuietLead	
	db	D#6,2,rest,2,D#6,4,D_6,4,C_6,8,A#5,8
	db	C_6,2,D_6,2,C_6,8,A#5,4,C_6,8,A#5,4,G_5,4
	db	G#5,1,A_5,11,G_5,4,F_5,8,D#5,8
	db	F_5,12,G_5,4,F_5,8,C_6,4,D_6,4
	db	D#6,12,D_6,4,C_6,8,D_6,8
	db	D#6,4,D_6,4,C_6,4,D_6,4,C_6,4,D#6,4,G_6,4,A#6,4
	db	G_6,1,A_6,11,G_6,4,F_6,8,C_6,8,F_5,16
	db	SetInstrument,id_QuietLeadFade
	db	F_5,16
	db	GotoLoopPoint

.block1
	db	D#5,4,G_4,4,F_4,4,G_4,4
	ret
	
.block2
	db	F_5,4,C_5,4,A_4,4,C_5,4
	ret
	
SafePlace_CH3:
	db	SetInstrument,id_WaveBass
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
	db	SetInstrument,id_PulseLead1a
	rept	2
	db	CallSection
	dw	.block1
	endr
	db	SetInstrument,id_PulseLead1b

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
	db	SetInstrument,id_Arp1
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
	db	SetInstrument,id_WaveBass2a
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
	db	SetInstrument,id_CorruptionFade
	db	SetChannelPtr
	dw	$4981
	
Corruption_CH3:
	db	SetInstrument,id_CorruptionWave
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
	db	SetInstrument,id_PulseTrill5
	
	db	CallSection
	dw	.block1
	db	CallSection
	dw	.block1
	db	SetInsAlternate,id_PulseTrill7,id_PulseTrill5
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
	db	SetInstrument,id_Boss1Lead
	
	db	E_4,24,G_4,8,F_4,2,F#4,10,E_4,12,D_4,8
	db	E_4,32,D_4,12,F#4,12,D_4,8
	db	D_4,2,E_4,22,G_4,8,A_4,8,G_4,4,F#4,8,G_4,4,F#4,8
	db	G_4,32,A_4,12,F#4,12,D_4,8
	db	SetInsAlternate,id_Boss1Echo1,id_Boss1Echo2
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
	db	SetInstrument,id_Boss1Echo1
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
	db	SetInstrument,id_Boss1Bass
	
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
	db	SetInstrument,id_WaveTrill
	db	EnablePWM,$f,7
	rept	4
	db	CallSection
	dw	.block1
	endr
	
	db	SetLoopPoint
	db	SetInsAlternate,id_Boss1Wave,id_Boss1Echo
rept 2
	db	CallSection
	dw	.block2
endr
	db	SetInstrument,id_Boss1Wave
	db	CallSection
	dw	.block4
rept 3
	db	CallSection
	dw	.block3
endr
rept 4
	db	CallSection
	dw	.block5
endr
	
	db	GotoLoopPoint
	
.block1
	db	B_5,12,B_5,12,B_5,12,B_5,12,A_5,8,A#5,8
	ret
	
.block2
	db	E_7,2,E_2,2,B_6,2,E_7,2,G_6,2,B_6,2,E_6,2,G_6,2
	db	E_7,2,E_6,2,B_6,2,E_7,2,G_6,2,B_6,2,E_6,2,G_6,2
	db	D_7,2,E_6,2,A_6,2,D_7,2,F#6,2,A_6,2,D_6,2,F#6,2
	db	D_7,2,D_6,2,A_6,2,D_7,2,F#6,2,A_6,2,D_6,2,F#6,2
	
	db	C_7,2,D_6,2,G_6,2,C_7,2,E_6,2,G_6,2,C_6,2,E_6,2
	db	C_7,2,C_6,2,G_6,2,C_7,2,E_6,2,G_6,2,C_6,2,E_6,2
	db	D_7,2,C_6,2,A_6,2,D_7,2,F#6,2,A_6,2,D_6,2,F#6,2
	db	D_7,2,D_6,2,A_6,2,D_7,2,F#6,2,A_6,2,D_6,2,F#6,2
	ret
	
.block3
	db	F#6,2,D#6,2,F#6,2,B_6,2,D#7,2,B_6,2,F#6,2,D#6,2
	db	F#6,2,D#6,2,F#6,2,B_6,2,D#7,2,B_6,2,F#6,2,D#6,2
	db	E_6,2,B_5,2,E_6,2,B_6,2,E_7,2,B_6,2,E_6,2,B_5,2
	db	D_6,2,A_5,2,D_6,2,A_6,2,D_7,2,A_6,2,D_5,2,A_5,2
	
.block4
	db	E_6,2,C_6,2,E_6,2,G_6,2,C_7,2,G_6,2,E_6,2,C_6,2
	db	E_6,2,C_6,2,E_6,2,G_6,2,C_7,2,G_6,2,E_6,2,C_6,2
	db	F#6,2,D_6,2,F#6,2,A_6,2,D_7,2,A_6,2,F#6,2,D_6,2
	db	F#6,2,D_6,2,F#6,2,A_6,2,D_7,2,A_6,2,F#6,2,D_6,2
	ret
	
.block5
	db	E_6,2,B_5,2,E_6,2,B_6,2,E_7,2,B_6,2,E_6,2,B_5,2
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
	db	SetInstrument,id_ScareChord
	db	G_5,40
	db	rest,1
	db	EndChannel
	
ScareChord_CH3:
	db	SetInstrument,id_ScareChordWave
	db	fix,40
	db	rest,1
	db	EndChannel
	
ScareChord_CH4:
	db	SetInstrument,id_ScareChordNoise
	db	G_4,1,F#4,1,F_4,1,E_4,1,D#4,1,D_4,1,C#4,1,C_4,1,B_3,1,A#3,1,A_3,1,G#3,1
	db	G_3,1,F#3,1,F_3,1,E_3,1,D#3,1,D_3,1,C#3,1,C_3,1,B_2,1,A#2,1,A_2,1,G#2,1
	db	rest,1
	db	EndChannel

; ================================================================

Scale_CH1:
	db	SetInstrument,id_PulseLead1a,C_3,4,D_3,4,E_3,4,F_3,4,G_3,4,A_3,4,B_3,4,C_4,4,EndChannel