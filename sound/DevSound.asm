; ================================================================
; DevSound - a Game Boy music system by DevEd
;
; Copyright (c) 2017 Edward J. Whalen
; 
; Permission is hereby granted, free of charge, to any person obtaining
; a copy of this software and associated documentation files (the
; "Software"), to deal in the Software without restriction, including
; without limitation the rights to use, copy, modify, merge, publish,
; distribute, sublicense, and/or sell copies of the Software, and to
; permit persons to whom the Software is furnished to do so, subject to
; the following conditions:
; 
; The above copyright notice and this permission notice shall be included
; in all copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
; CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
; TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; ================================================================

UseFXHammer	set	1

SECTION	"DevSound entry points",ROM0

DevSound_JumpTable:

DS_Init::
	ld c, a
	jpacross	DevSound_Init_Hook
DS_Play::
	jpacross	DevSound_Play
DS_Stop::
	jpacross	DevSound_Stop
DS_Fade::
	ld c, a
	jpacross	DevSound_Fade_Hook

; ================================================================
; Init routine
; INPUT: a = ID of song to init
; ================================================================

SECTION "DevSound engine", ROMX,BANK[5]

; Driver thumbprint (Please keep this in the DevSound ROM bank)
db	"DevSound GB music player by DevEd | email: deved8@gmail.com"

DevSound:

DevSound_Init_Hook:	
	ld a, c
DevSound_Init::
	cp MUSIC_INVALIDTRACK ; Check if song ID is valid
	jr nc, DevSound_Stop ; If song ID is invalid, mute.
	
	di ; Prevent DS_Play from happening
	ld	b,a		; Preserve song ID

	xor	a
	ldh	[rNR52],a	; disable sound
	ld	[PWMEnabled],a
	ld	[RandomizerEnabled],a
	ld	[WaveBufUpdateFlag],a

	; init sound RAM area
	ld	de,DSVarsStart
	ld	c,DSVarsEnd-DSVarsStart
	ld	hl,DefaultRegTable
	rst copy
	
	ld	d,b		; Transfer song ID

	; load default waveform
	ld	hl,DefaultWave
	call	LoadWave
	call	ClearWaveBuffer
	call	ClearArpBuffer
	
	; set up song pointers
	ld	hl,SongPointerTable
	ld	a,d
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry		; HERE BE HACKS
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl+]
	ld	[CH1Ptr],a
	ld	a,[hl+]
	ld	[CH1Ptr+1],a	
	ld	a,[hl+]
	ld	[CH2Ptr],a
	ld	a,[hl+]
	ld	[CH2Ptr+1],a
	ld	a,[hl+]
	ld	[CH3Ptr],a
	ld	a,[hl+]
	ld	[CH3Ptr+1],a
	ld	a,[hl+]
	ld	[CH4Ptr],a
	ld	a,[hl+]
	ld	[CH4Ptr+1],a
	ld	hl,DummyChannel
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl+]
	ld	[CH1RetPtr],a
	ld	[CH2RetPtr],a
	ld	[CH3RetPtr],a
	ld	[CH4RetPtr],a
	ld	a,[hl]
	ld	[CH1RetPtr+1],a
	ld	[CH2RetPtr+1],a
	ld	[CH3RetPtr+1],a
	ld	[CH4RetPtr+1],a
	ld	a,$11
	ld	[CH1Pan],a
	ld	[CH2Pan],a
	ld	[CH3Pan],a
	ld	[CH4Pan],a
	; get tempo
	ld	hl,SongSpeedTable
	ld	a,d		; Retrieve song ID one last time
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry2
	inc	h
.nocarry2
	ld	a,[hl+]
	dec	a
	ld	[GlobalSpeed1],a
	ld	a,[hl]
	dec	a
	ld	[GlobalSpeed2],a
	ld	a,%10000000
	ldh	[rNR52],a
	ld	a,$FF
	ldh	[rNR51],a
	ldh	[rNR50],a
	reti

; ================================================================
; Stop routine
; ================================================================

DevSound_Stop:
	di ; Prevent DS_Play from happening
	
	xor	a
	ldh	[rNR52],a
	ld	[CH1Enabled],a
	ld	[CH2Enabled],a
	ld	[CH3Enabled],a
	ld	[CH4Enabled],a
	ld	[SoundEnabled],a
	reti

; ================================================================
; Fade routine
; ================================================================

DevSound_Fade_Hook:
	ld a, c
DevSound_Fade::
	di ; Prevent DS_Play from happening
	
	and	3
	or	a
	jr	z,.fadeOut
	dec	a
	jr	z,.fadeIn
	dec	a
	jr	z,.fadeOutStop
	reti	; default case
.fadeOut
	inc	a
	ld	[FadeType],a
	ld	a,7
	ld	[GlobalVolume],a
	jr	.done
.fadeIn
	ld	a,2
	ld	[FadeType],a
	xor	a
	ld	[GlobalVolume],a
	jr	.done
.fadeOutStop
	ld	a,3
	ld	[FadeType],a
	ld	a,7
	ld	[GlobalVolume],a
.done
	ld	a,7
	ld	[FadeTimer],a
	reti
	
; ================================================================
; Play routine
; ================================================================

DevSound_Play:
	; Since this routine is called during an interrupt (which may
	; happen in the middle of a routine), preserve all register
	; values just to be safe.
	; Other registers are saved at `.doUpdate`.
	push	af
	ld	a,[SoundEnabled]
	and	a
	jr	nz,.doUpdate	; if sound is enabled, jump ahead
	pop	af
	ret
	
.doUpdate
	push	bc
	push	de
	push	hl
	; get song timer
	ld	a,[GlobalTimer]	; get global timer
	and	a				; is GlobalTimer non-zero?
	jr	nz,.noupdate	; if yes, don't update
	ld	a,[TickCount]	; get current tick count
	inc	a				; add 1
	ld	[TickCount],a	; store it in RAM
	rra					; check if A is odd
	jr	nc,.odd			; if a is odd, jump
.even
	ld	a,[GlobalSpeed1]
	jr	.setTimer
.odd
	ld	a,[GlobalSpeed2]
.setTimer
	ld	[GlobalTimer],a	; store timer value
	jr	UpdateCH1		; continue ahead
	
.noupdate
	dec	a				; subtract 1 from timer
	ld	[GlobalTimer],a	; store timer value
	jp	DoneUpdating	; done

; ================================================================
	
UpdateCH1:
	ld	a,[CH1Enabled]
	and	a
	jp	z,UpdateCH2
	ld	a,[CH1Tick]
	and	a
	jr	z,.continue
	dec	a
	ld	[CH1Tick],a
	jp	UpdateCH2
.continue
	ld	hl,CH1Ptr		; get pointer
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH1Pos]		; get current offset
	ld	c,a				; store offset for later use
	add	l
	ld	l,a
	jr	nc,CH1_CheckByte
	inc	h
CH1_CheckByte:
	ld	a,[hl+]			; get byte
	inc	c				; add 1 to offset
	cp	$ff				; if $ff...
	jr	z,.endChannel
	cp	$c9				; if $c9...
	jr	z,.retSection
	bit	7,a				; if command...
	jr	nz,.getCommand
	; if we have a note...
.getNote
	ld	[CH1Note],a		; set note
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[CH1Tick],a		; set tick
	xor	a
	ld	[CH1ArpPos],a
	ldh	[rNR12],a
	inc	a
	ld	[CH1VibPos],a
	ld	hl,CH1VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl]
	ld	[CH1VibDelay],a
	ld	a,[CH1Reset]
	and	a
	jr	nz,.noreset_checkvol
	xor	a
	ld	[CH1PulsePos],a
.noreset_checkvol
	ld	a,[CH1Reset]
	cp	2
	jr	z,.noreset
	xor	a
	ld	[CH1VolPos],a
.noreset
	ld	a,[CH1NoteCount]
	inc	a
	ld	[CH1NoteCount],a
	ld	b,a
	; check if instrument mode is 1 (alternating)
	ld	a,[CH1InsMode]
	and	a
	jr	z,.noInstrumentChange
	ld	a,b
	rra
	jr	nc,.notodd
	ld	a,[CH1Ins1]
	jr	.odd
.notodd
	ld	a,[CH1Ins2]
.odd
	call	CH1_SetInstrument
.noInstrumentChange	
	jp	CH1_DoneUpdating
.getCommand
	push	hl
	sub	$80				; subtract 128 from command value
	cp	DummyCommand-$80
	jr	c,.nodummy
	pop	hl
	jp	CH1_CheckByte
.nodummy
	add	a				; multiply by 2
	add	a,CH1_CommandTable%256
	ld	l,a
	adc	a,CH1_CommandTable/256
	sub	l
	ld	h,a
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	jp	hl
	
.endChannel
	xor	a
	ld	[CH1Enabled],a
	jp	UpdateCH2

.retSection
	ld	a,[CH1RetPtr]
	ld	[CH1Ptr],a
	ld	a,[CH1RetPtr+1]
	ld	[CH1Ptr+1],a
	ld	a,[CH1RetPos]
	ld	[CH1Pos],a
	jp	UpdateCH1
	
CH1_DoneUpdating:
	ld	a,c
	ld	[CH1Pos],a
	jp	UpdateCH2
		
CH1_CommandTable:
	dw	.setInstrument
	dw	.setLoopPoint
	dw	.gotoLoopPoint
	dw	.callSection
	dw	.setChannelPtr
	dw	.pitchBendUp
	dw	.pitchBendDown
	dw	.setSweep
	dw	.setPan
	dw	.setSpeed
	dw	.setInsAlternate
	dw	.randomizeWave
	dw	.combineWaves
	dw	.enablePWM
	dw	.enableRandomizer
	dw	.disableAutoWave
	dw	.arp

.setInstrument
	pop	hl
	ld	a,[hl+]
	inc	c
	push	hl
	call	CH1_SetInstrument
	xor	a
	ld	[CH1InsMode],a
	pop	hl
	jp	CH1_CheckByte
	
.setLoopPoint
	pop	hl
	ld	a,c
	ld	[CH1LoopPos],a
	jp	CH1_CheckByte
	
.gotoLoopPoint
	pop	hl
	ld	a,[CH1LoopPos]
	ld	[CH1Pos],a
	jp	UpdateCH1

.callSection
	pop	hl
	ld	a,[CH1Ptr]
	ld	[CH1RetPtr],a
	ld	a,[CH1Ptr+1]
	ld	[CH1RetPtr+1],a
	ld	a,[hl+]
	ld	[CH1Ptr],a
	ld	a,[hl]
	ld	[CH1Ptr+1],a
	inc	c
	inc	c
	ld	a,c
	ld	[CH1RetPos],a
	xor	a
	ld	[CH1Pos],a
	ld	c,a
	jp	UpdateCH1
	
.setChannelPtr
	pop	hl
	ld	a,[hl+]
	ld	[CH1Ptr],a
	ld	a,[hl]
	ld	[CH1Ptr+1],a
	xor	a
	ld	c,a
	ld	[CH1Pos],a
	jp	UpdateCH1

.pitchBendUp	; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH1_CheckByte
	
.pitchBendDown	; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH1_CheckByte

.setSweep		; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH1_CheckByte

.setPan
	pop	hl
	ld	a,[hl+]
	ld	[CH1Pan],a
	inc	c
	jp	CH1_CheckByte

.setSpeed
	pop	hl
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed1],a
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed2],a
	jp	CH1_CheckByte
	
.setInsAlternate
	pop	hl
	ld	a,[hl+]
	inc	c
	ld	[CH1Ins1],a
	ld	a,[hl+]
	inc	c
	ld	[CH1Ins2],a
	ld	a,1
	ld	[CH1InsMode],a
	jp	CH1_CheckByte
	
.randomizeWave
	pop	hl
	jp	CH1_CheckByte
	
.combineWaves
	pop	hl
	ld	a,l
	add	4
	ld	l,a
	jr	nc,.nc
	inc	h
.nc
	ld	a,c
	add	4
	ld	c,a
	jp	CH1_CheckByte	
	
.enablePWM
	pop	hl
	ld	a,l
	add	2
	ld	l,a
	jr	nc,.nc2
	inc	h
.nc2
	ld	a,c
	add	2
	ld	c,a
	jp	CH1_CheckByte
	
.enableRandomizer
	pop	hl
	inc	hl
	inc	c
	jp	CH1_CheckByte

.disableAutoWave
	pop	hl
	jp	CH1_CheckByte
	
.arp
	pop	hl
	call	DoArp
	ld	a,c
	add	2
	ld	c,a
	jp	CH1_CheckByte
	
CH1_SetInstrument:
	ld	hl,InstrumentTable
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	; no reset flag
	ld	a,[hl+]
	ld	[CH1Reset],a
	ld	b,a
	; vol table
	ld	a,[hl+]
	ld	[CH1VolPtr],a
	ld	a,[hl+]
	ld	[CH1VolPtr+1],a
	; arp table
	ld	a,[hl+]
	ld	[CH1ArpPtr],a
	ld	a,[hl+]
	ld	[CH1ArpPtr+1],a
	; pulse table
	ld	a,[hl+]
	ld	[CH1PulsePtr],a
	ld	a,[hl+]
	ld	[CH1PulsePtr+1],a
	; vib table
	ld	a,[hl+]
	ld	[CH1VibPtr],a
	ld	a,[hl+]
	ld	[CH1VibPtr+1],a
	ld	hl,CH1VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl]
	ld	[CH1VibDelay],a
	ret
	
; ================================================================
	
UpdateCH2:
	ld	a,[CH2Enabled]
	and	a
	jp	z,UpdateCH3
	ld	a,[CH2Tick]
	and	a
	jr	z,.continue
	dec	a
	ld	[CH2Tick],a
	jp	UpdateCH3
.continue
	ld	hl,CH2Ptr	; get pointer
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH2Pos]	; get current offset
	ld	c,a			; store offset for later use
	add	l			; hl = hl + a (four lines)
	ld	l,a
	jr	nc,CH2_CheckByte
	inc	h
CH2_CheckByte:
	ld	a,[hl+]		; get byte
	inc	c			; add 1 to offset
	cp	$ff
	jr	z,.endChannel
	cp	$c9
	jr	z,.retSection
	bit	7,a			; check for command
	jr	nz,.getCommand	
	; if we have a note...
.getNote
	ld	[CH2Note],a
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[CH2Tick],a
	xor	a
	ld	[CH2ArpPos],a
	if(UseFXHammer)
	ld	a,[$c7cc]
	cp	3
	jp	z,.noupdate
	endc
	ldh	[rNR22],a
.noupdate
	inc	a
	ld	[CH2VibPos],a
	ld	hl,CH2VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl]
	ld	[CH2VibDelay],a
	ld	a,[CH2Reset]
	and	a
	jr	nz,.noreset_checkvol
	xor	a
	ld	[CH2PulsePos],a
.noreset_checkvol
	ld	a,[CH2Reset]
	cp	2
	jr	z,.noreset
	xor	a
	ld	[CH2VolPos],a
.noreset
	ld	a,[CH2NoteCount]
	inc	a
	ld	[CH2NoteCount],a
	ld	b,a
	; check if instrument mode is 1 (alternating)
	ld	a,[CH2InsMode]
	and	a
	jr	z,.noInstrumentChange
	ld	a,b
	rra
	jr	nc,.notodd
	ld	a,[CH2Ins1]
	jr	.odd
.notodd
	ld	a,[CH2Ins2]
.odd
	call	CH2_SetInstrument
.noInstrumentChange
	jp	CH2_DoneUpdating
.getCommand
	push	hl
	sub	$80
	cp	DummyCommand-$80
	jr	c,.nodummy
	pop	hl
	jp	CH2_CheckByte
.nodummy
	add	a
	add	a,CH2_CommandTable%256
	ld	l,a
	adc	a,CH2_CommandTable/256
	sub	l
	ld	h,a
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	jp	hl
	
.endChannel
	xor	a
	ld	[CH2Enabled],a
	jp	UpdateCH3
	
.retSection
	ld	hl,CH2RetPtr
	ld	a,[hl+]
	ld	[CH2Ptr],a
	ld	a,[hl]
	ld	[CH2Ptr+1],a
	ld	a,[CH2RetPos]
	ld	[CH2Pos],a
	jp	UpdateCH2
	
CH2_DoneUpdating:
	ld	a,c
	ld	[CH2Pos],a
	jp	UpdateCH3
		
CH2_CommandTable:
	dw	.setInstrument
	dw	.setLoopPoint
	dw	.gotoLoopPoint
	dw	.callSection
	dw	.setChannelPtr
	dw	.pitchBendUp
	dw	.pitchBendDown
	dw	.setSweep
	dw	.setPan
	dw	.setSpeed
	dw	.setInsAlternate
	dw	.randomizeWave
	dw	.combineWaves
	dw	.enablePWM
	dw	.enableRandomizer
	dw	.disableAutoWave
	dw	.arp

.setInstrument
	pop	hl
	ld	a,[hl+]
	inc	c
	push	hl
	call	CH2_SetInstrument
	pop	hl
	xor	a
	ld	[CH2InsMode],a
	jp	CH2_CheckByte
	
.setLoopPoint
	pop	hl
	ld	a,c
	ld	[CH2LoopPos],a
	jp	CH2_CheckByte
	
.gotoLoopPoint
	pop	hl
	ld	a,[CH2LoopPos]
	ld	[CH2Pos],a
	jp	UpdateCH2
	
.callSection
	pop	hl
	ld	a,[CH2Ptr]
	ld	[CH2RetPtr],a
	ld	a,[CH2Ptr+1]
	ld	[CH2RetPtr+1],a
	ld	a,[hl+]
	ld	[CH2Ptr],a
	ld	a,[hl]
	ld	[CH2Ptr+1],a
	inc	c
	inc c
	ld	a,c
	ld	[CH2RetPos],a
	xor	a
	ld	[CH2Pos],a
	ld	c,a
	jp	UpdateCH2
	
.setChannelPtr
	pop	hl
	ld	a,[hl+]
	ld	[CH2Ptr],a
	ld	a,[hl]
	ld	[CH2Ptr+1],a
	xor	a
	ld	c,a
	ld	[CH2Pos],a
	jp	UpdateCH2

.pitchBendUp	; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH2_CheckByte
	
.pitchBendDown	; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH2_CheckByte

.setSweep		; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH2_CheckByte

.setPan
	pop	hl
	ld	a,[hl+]
	ld	[CH2Pan],a
	inc	c
	jp	CH2_CheckByte

.setSpeed
	pop	hl
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed1],a
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed2],a
	jp	CH2_CheckByte

.setInsAlternate
	pop	hl
	ld	a,[hl+]
	inc	c
	ld	[CH2Ins1],a
	ld	a,[hl+]
	inc	c
	ld	[CH2Ins2],a
	ld	a,1
	ld	[CH2InsMode],a
	jp	CH2_CheckByte

.randomizeWave
	pop	hl
	jp	CH2_CheckByte
	
.combineWaves
	pop	hl
	ld	a,l
	add	4
	ld	l,a
	jr	nc,.nc
	inc	h
.nc
	ld	a,c
	add	4
	ld	c,a
	jp	CH2_CheckByte	
	
.enablePWM
	pop	hl
	ld	a,l
	add	2
	ld	l,a
	jr	nc,.nc2
	inc	h
.nc2
	ld	a,c
	add	2
	ld	c,a
	jp	CH2_CheckByte
	
.enableRandomizer
	pop	hl
	inc	hl
	inc	c
	jp	CH1_CheckByte

.disableAutoWave
	pop	hl
	jp	CH1_CheckByte
	
.arp
	pop	hl
	call	DoArp
	ld	a,c
	add	2
	ld	c,a
	jp	CH2_CheckByte
	
CH2_SetInstrument:
	ld	hl,InstrumentTable
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	; no reset flag
	ld	a,[hl+]
	ld	[CH2Reset],a
	ld	b,a
	; vol table
	ld	a,[hl+]
	ld	[CH2VolPtr],a
	ld	a,[hl+]
	ld	[CH2VolPtr+1],a
	; arp table
	ld	a,[hl+]
	ld	[CH2ArpPtr],a
	ld	a,[hl+]
	ld	[CH2ArpPtr+1],a
	; pulse table
	ld	a,[hl+]
	ld	[CH2PulsePtr],a
	ld	a,[hl+]
	ld	[CH2PulsePtr+1],a
	; vib table
	ld	a,[hl+]
	ld	[CH2VibPtr],a
	ld	a,[hl+]
	ld	[CH2VibPtr+1],a
	ld	hl,CH2VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl]
	ld	[CH2VibDelay],a
	ret
	
; ================================================================
	
UpdateCH3:
	ld	a,[CH3Enabled]
	and	a
	jp	z,UpdateCH4
	ld	a,[CH3Tick]
	and	a
	jr	z,.continue
	dec	a
	ld	[CH3Tick],a
	jp	UpdateCH4
.continue
	ld	hl,CH3Ptr	; get pointer
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH3Pos]	; get current offset
	ld	c,a			; store offset for later use
	add	l			; hl = hl + a (four lines)
	ld	l,a
	jr	nc,CH3_CheckByte
	inc	h
CH3_CheckByte:
	ld	a,[hl+]		; get byte
	inc	c			; add 1 to offset
	cp	$ff
	jr	z,.endChannel
	cp	$c9
	jr	z,.retSection
	bit	7,a			; check for command
	jr	nz,.getCommand
	; if we have a note...
.getNote
	ld	[CH3Note],a
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[CH3Tick],a
	xor	a
	ld	[CH3VolPos],a
	ld	[CH3ArpPos],a
	xor	$ff
	ld	[CH3Wave],a		; workaround for wave corruption bug on DMG, forces wave update at note start
	ld	a,1
	ld	[CH3VibPos],a
	ld	hl,CH3VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl]
	ld	[CH3VibDelay],a
	ld	a,[CH3Reset]
	and	a
	jp	nz,CH3_DoneUpdating
	xor	a
	ld	[CH3WavePos],a
	ld	a,[CH3NoteCount]
	inc	a
	ld	[CH3NoteCount],a
	ld	b,a
	ld	a,[CH3Vol]
	ldh	[rNR32],a	; fix for volume not updating when unpausing
	
	; check if instrument mode is 1 (alternating)
	ld	a,[CH3InsMode]
	and	a
	jr	z,.noInstrumentChange
	ld	a,b
	rra
	jr	nc,.notodd
	ld	a,[CH3Ins1]
	jr	.odd
.notodd
	ld	a,[CH3Ins2]
.odd
	call	CH3_SetInstrument
.noInstrumentChange
	jp	CH3_DoneUpdating
.getCommand
	push	hl
	sub	$80
	cp	DummyCommand-$80
	jr	c,.nodummy
	pop	hl
	jp	CH3_CheckByte
.nodummy
	add	a
	add	a,CH3_CommandTable%256
	ld	l,a
	adc	a,CH3_CommandTable/256
	sub	l
	ld	h,a
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	jp	hl
	
.endChannel
	xor	a
	ld	[CH3Enabled],a
	jp	UpdateCH4
	
.retSection
	ld	hl,CH3RetPtr
	ld	a,[hl+]
	ld	[CH3Ptr],a
	ld	a,[hl]
	ld	[CH3Ptr+1],a
	ld	a,[CH3RetPos]
	ld	[CH3Pos],a
	jp	UpdateCH3
	
CH3_DoneUpdating:
	ld	a,c
	ld	[CH3Pos],a
	jp	UpdateCH4
		
CH3_CommandTable:
	dw	.setInstrument
	dw	.setLoopPoint
	dw	.gotoLoopPoint
	dw	.callSection
	dw	.setChannelPtr
	dw	.pitchBendUp
	dw	.pitchBendDown
	dw	.setSweep
	dw	.setPan
	dw	.setSpeed
	dw	.setInsAlternate
	dw	.randomizeWave
	dw	.combineWaves
	dw	.enablePWM
	dw	.enableRandomizer
	dw	.disableAutoWave
	dw	.arp

.setInstrument
	pop	hl
	ld	a,[hl+]
	inc	c
	push	hl
	call	CH3_SetInstrument
	pop	hl
	xor	a
	ld	[CH3InsMode],a
	jp	CH3_CheckByte
	
.setLoopPoint
	pop	hl
	ld	a,c
	ld	[CH3LoopPos],a
	jp	CH3_CheckByte
	
.gotoLoopPoint
	pop	hl
	ld	a,[CH3LoopPos]
	ld	[CH3Pos],a
	jp	UpdateCH3
	
.callSection
	pop	hl
	ld	a,[CH3Ptr]
	ld	[CH3RetPtr],a
	ld	a,[CH3Ptr+1]
	ld	[CH3RetPtr+1],a
	ld	a,[hl+]
	ld	[CH3Ptr],a
	ld	a,[hl]
	ld	[CH3Ptr+1],a
	inc	c
	inc c
	ld	a,c
	ld	[CH3RetPos],a
	xor	a
	ld	[CH3Pos],a
	ld	c,a
	jp	UpdateCH3
	
.setChannelPtr
	pop	hl
	ld	a,[hl+]
	ld	[CH3Ptr],a
	ld	a,[hl]
	ld	[CH3Ptr+1],a
	xor	a
	ld	c,a
	ld	[CH3Pos],a
	jp	UpdateCH3

.pitchBendUp	; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH3_CheckByte
	
.pitchBendDown	; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH3_CheckByte

.setSweep		; TODO
	pop	hl
	inc	hl
	inc	c
	jp	CH3_CheckByte

.setPan
	pop	hl
	ld	a,[hl+]
	ld	[CH3Pan],a
	inc	c
	jp	CH3_CheckByte

.setSpeed
	pop	hl
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed1],a
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed2],a
	jp	CH3_CheckByte
	
.setInsAlternate
	pop	hl
	ld	a,[hl+]
	inc	c
	ld	[CH3Ins1],a
	ld	a,[hl+]
	inc	c
	ld	[CH3Ins2],a
	ld	a,1
	ld	[CH3InsMode],a
	jp	CH3_CheckByte
	
.randomizeWave
	call	_RandomizeWave
	pop	hl
	jp	CH3_CheckByte

.combineWaves
	pop	hl
	push	bc
	ld	a,[hl+]
	ld	c,a
	ld	a,[hl+]
	ld	b,a
	ld	a,[hl+]
	ld	e,a
	ld	a,[hl+]
	ld	d,a
	push	hl
	call	_CombineWaves
	pop	hl
	pop	bc
	ld	a,c
	add	4
	ld	c,a
	jp	CH3_CheckByte
	
.enablePWM
	call	ClearWaveBuffer
	pop	hl
	ld	a,[hl+]
	ld	[PWMVol],a
	ld	a,[hl+]
	ld	[PWMSpeed],a
	ld	a,$ff
	ld	[WavePos],a
	xor	a
	ld	[PWMDir],a
	inc	a
	ld	[PWMEnabled],a
	ld	[PWMTimer],a
	ld	a,c
	add	2
	ld	c,a
	xor	a
	ld	[RandomizerEnabled],a
	jp	CH3_CheckByte
	
.enableRandomizer
	call	ClearWaveBuffer
	pop	hl
	inc	c
	ld	a,[hl+]
	ld	[RandomizerSpeed],a
	ld	a,1
	ld	[RandomizerTimer],a
	ld	[RandomizerEnabled],a
	xor	a
	ld	[PWMEnabled],a
	jp	CH3_CheckByte
	
.disableAutoWave
	pop	hl
	xor	a
	ld	[PWMEnabled],a
	ld	[RandomizerEnabled],a
	jp	CH3_CheckByte

.arp
	pop	hl
	call	DoArp
	ld	a,c
	add	2
	ld	c,a
	jp	CH3_CheckByte
	
CH3_SetInstrument:
	ld	hl,InstrumentTable
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	; no reset flag
	ld	a,[hl+]
	ld	[CH3Reset],a
	ld	b,a
	; vol table
	ld	a,[hl+]
	ld	[CH3VolPtr],a
	ld	a,[hl+]
	ld	[CH3VolPtr+1],a
	; arp table
	ld	a,[hl+]
	ld	[CH3ArpPtr],a
	ld	a,[hl+]
	ld	[CH3ArpPtr+1],a
	; wave table
	ld	a,[hl+]
	ld	[CH3WavePtr],a
	ld	a,[hl+]
	ld	[CH3WavePtr+1],a
	; vib table
	ld	a,[hl+]
	ld	[CH3VibPtr],a
	ld	a,[hl+]
	ld	[CH3VibPtr+1],a
	ld	hl,CH3VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[hl]
	ld	[CH3VibDelay],a
	ret

; ================================================================

UpdateCH4:
	ld	a,[CH4Enabled]
	and	a
	jp	z,DoneUpdating
	ld	a,[CH4Tick]
	and	a
	jr	z,.continue
	dec	a
	ld	[CH4Tick],a
	jp	DoneUpdating
.continue
	ld	hl,CH4Ptr	; get pointer
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH4Pos]	; get current offset
	ld	c,a			; store offset for later use
	add	l			; hl = hl + a (four lines)
	ld	l,a
	jr	nc,CH4_CheckByte
	inc	h
CH4_CheckByte:
	ld	a,[hl+]		; get byte
	inc	c			; add 1 to offset
	cp	$ff
	jr	z,.endChannel
	cp	$c9
	jr	z,.retSection
	bit	7,a			; check for command
	jr	nz,.getCommand	
	; if we have a note...
.getNote
	ld	[CH4Mode],a
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[CH4Tick],a
	ld	a,[CH4Reset]
	jp	z,CH4_DoneUpdating
	xor	a
	ld	[CH4VolPos],a
	ld	[CH4NoisePos],a
	if(UseFXHammer)
	ld	a,[$c7d9]
	cp	3
	jp	z,.noupdate
	endc
	ldh	[rNR42],a
.noupdate
	ld	a,[CH4NoteCount]
	inc	a
	ld	[CH4NoteCount],a
	ld	b,a
	; check if instrument mode is 1 (alternating)
	ld	a,[CH4InsMode]
	and	a
	jr	z,.noInstrumentChange
	ld	a,b
	rra
	jr	nc,.notodd
	ld	a,[CH4Ins1]
	jr	.odd
.notodd
	ld	a,[CH4Ins2]
.odd
	call	CH4_SetInstrument
.noInstrumentChange
	jp	CH4_DoneUpdating
.getCommand
	push	hl
	sub	$80
	cp	DummyCommand-$80
	jr	c,.nodummy
	pop	hl
	jp	CH4_CheckByte
.nodummy
	add	a
	add	a,CH4_CommandTable%256
	ld	l,a
	adc	a,CH4_CommandTable/256
	sub	l
	ld	h,a
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	jp	hl
	
.endChannel
	xor	a
	ld	[CH4Enabled],a
	jp	DoneUpdating
	
.retSection
	ld	hl,CH4RetPtr
	ld	a,[hl+]
	ld	[CH4Ptr],a
	ld	a,[hl]
	ld	[CH4Ptr+1],a
	ld	a,[CH4RetPos]
	ld	[CH4Pos],a
	jp	UpdateCH4
	
CH4_DoneUpdating:
	ld	a,c
	ld	[CH4Pos],a
	jp	DoneUpdating
		
CH4_CommandTable:
	dw	.setInstrument
	dw	.setLoopPoint
	dw	.gotoLoopPoint
	dw	.callSection
	dw	.setChannelPtr
	dw	.pitchBendUp
	dw	.pitchBendDown
	dw	.setSweep
	dw	.setPan
	dw	.setSpeed
	dw	.setInsAlternate
	dw	.randomizeWave
	dw	.combineWaves
	dw	.enablePWM
	dw	.enableRandomizer
	dw	.disableAutoWave
	dw	.arp

.setInstrument
	pop	hl
	ld	a,[hl+]
	inc	c
	push	hl
	call	CH4_SetInstrument
	pop	hl
	xor	a
	ld	[CH4InsMode],a
	jp	CH4_CheckByte
	
.setLoopPoint
	pop	hl
	ld	a,c
	ld	[CH4LoopPos],a
	jp	CH4_CheckByte
	
.gotoLoopPoint
	pop	hl
	ld	a,[CH4LoopPos]
	ld	[CH4Pos],a
	jp	UpdateCH4
	
.callSection
	pop	hl
	ld	a,[CH4Ptr]
	ld	[CH4RetPtr],a
	ld	a,[CH4Ptr+1]
	ld	[CH4RetPtr+1],a
	ld	a,[hl+]
	ld	[CH4Ptr],a
	ld	a,[hl]
	ld	[CH4Ptr+1],a
	inc	c
	inc c
	ld	a,c
	ld	[CH4RetPos],a
	xor	a
	ld	[CH4Pos],a
	ld	c,a
	jp	UpdateCH4
	
.setChannelPtr
	pop	hl
	ld	a,[hl+]
	ld	[CH4Ptr],a
	ld	a,[hl]
	ld	[CH4Ptr+1],a
	xor	a
	ld	c,a
	ld	[CH4Pos],a
	jp	UpdateCH4

.pitchBendUp	; unused for ch4
	pop	hl
	inc	hl
	inc	c
	jp	CH4_CheckByte
	
.pitchBendDown	; unused for ch4
	pop	hl
	inc	hl
	inc	c
	jp	CH4_CheckByte

.setSweep		; unused for ch4
	pop	hl
	inc	hl
	inc	c
	jp	CH4_CheckByte

.setPan
	pop	hl
	ld	a,[hl+]
	ld	[CH4Pan],a
	inc	c
	jp	CH4_CheckByte

.setSpeed
	pop	hl
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed1],a
	ld	a,[hl+]
	inc	c
	dec	a
	ld	[GlobalSpeed2],a
	jp	CH4_CheckByte
	
.setInsAlternate
	pop	hl
	ld	a,[hl+]
	inc	c
	ld	[CH4Ins1],a
	ld	a,[hl+]
	inc	c
	ld	[CH4Ins2],a
	ld	a,1
	ld	[CH4InsMode],a
	jp	CH4_CheckByte
	
.randomizeWave
	pop	hl
	jp	CH4_CheckByte
	
.combineWaves
	pop	hl
	ld	a,l
	add	4
	ld	l,a
	jr	nc,.nc
	inc	h
.nc
	ld	a,c
	add	4
	ld	c,a
	jp	CH4_CheckByte	
	
.enablePWM
	pop	hl
	ld	a,l
	add	2
	ld	l,a
	jr	nc,.nc2
	inc	h
.nc2
	ld	a,c
	add	2
	ld	c,a
	jp	CH4_CheckByte
	
.enableRandomizer
	pop	hl
	inc	hl
	inc	c
	jp	CH4_CheckByte

.disableAutoWave
	pop	hl
	jp	CH4_CheckByte

.arp
	pop	hl
	ld	a,l
	add	2
	ld	l,a
	jr	nc,.nc3
	inc	h
.nc3
	ld	a,c
	add	2
	ld	c,a
	jp	CH4_CheckByte

CH4_SetInstrument:
	ld	hl,InstrumentTable
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	; no reset flag
	ld	a,[hl+]
	ld	[CH4Reset],a
	ld	b,a
	; vol table
	ld	a,[hl+]
	ld	[CH4VolPtr],a
	ld	a,[hl+]
	ld	[CH4VolPtr+1],a
	; noise mode pointer
	ld	a,[hl+]
	ld	[CH4NoisePtr],a
	ld	a,[hl+]
	ld	[CH4NoisePtr+1],a
	ret
	
; ================================================================

DoneUpdating:

UpdateRegisters:
	; update panning
	xor	a
	ld	b,a
	ld	a,[CH1Pan]
	add	b
	ld	b,a
	ld	a,[CH2Pan]
	rla
	add	b
	ld	b,a
	ld	a,[CH3Pan]
	rla
	rla
	add	b
	ld	b,a
	ld	a,[CH4Pan]
	rla
	rla
	rla
	add	b
	ldh	[rNR51],a

	; update global volume + fade system
	ld	a,[FadeType]
	and	3
	or	a
	jr	z,CH1_UpdateRegisters
	ld	a,[FadeTimer]
	and	a
	jr	z,.doupdate
	dec	a
	ld	[FadeTimer],a
	jr	.continue
.doupdate
	ld	a,7
	ld	[FadeTimer],a
	ld	a,[FadeType]
	dec	a
	jr	z,.fadeout
	dec	a
	jr	z,.fadein
	dec	a
	jr	z,.fadeoutstop
	jr	.continue
.fadeout
	ld	a,[GlobalVolume]
	and	a
	jr	z,.continue
	dec	a
	ld	[GlobalVolume],a
	jr	.continue
.fadein
	ld	a,[GlobalVolume]
	cp	7
	jr	z,.done
	inc	a
	ld	[GlobalVolume],a
	jr	.continue
.done
	xor	a
	ld	[FadeType],a
	jr	.continue
.fadeoutstop
	ld	a,[GlobalVolume]
	and	a
	jr	z,.dostop
	dec	a
	ld	[GlobalVolume],a
	jr	.continue
.dostop
	call	DevSound_Stop
.continue
	ld	a,[GlobalVolume]
	and	7
	ld	b,a
	swap	a
	add	b
	ldh	[rNR50],a
	
CH1_UpdateRegisters:
	ld	a,[CH1Enabled]
	and	a
	jp	z,CH2_UpdateRegisters

	ld	a,[CH1Note]
	cp	rest
	jr	nz,.norest
	xor	a
	ldh	[rNR12],a
	ldh	a,[rNR14]
	or	%10000000
	ldh	[rNR14],a
	jp	.done
.norest

	; update arps
.updatearp
	ld	hl,CH1ArpPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH1ArpPos]
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	cp	$80
	jr	nz,.noloop
	ld	a,[hl]
	ld	[CH1ArpPos],a
	jr	.updatearp
.noloop
	cp	$ff
	jr	z,.continue
	ld	[CH1Transpose],a
.noreset
	ld	a,[CH1ArpPos]
	inc	a
	ld	[CH1ArpPos],a
.continue
	
	; update sweep
	xor	a
	ldh	[rNR10],a
	
	; update pulse
	ld	hl,CH1PulsePtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH1PulsePos]
	add	l
	ld	l,a
	jr	nc,.nocarry2
	inc	h
.nocarry2
	ld	a,[hl+]
	cp	$ff
	jr	z,.updateNote
	; convert pulse value
	and	3			; make sure value does not exceed 3
	swap	a		; swap lower and upper nybbles
	rla				; rotate left
	rla				;   ""    ""
	ldh	[rNR11],a	; transfer to register
.noreset2
	ld	a,[CH1PulsePos]
	inc	a
	ld	[CH1PulsePos],a
	ld	a,[hl+]
	cp	$80
	jr	nz,.updateNote
	ld	a,[hl]
	ld	[CH1PulsePos],a
	
; get note
.updateNote
	ld	a,[CH1Transpose]
	ld	b,a
	ld	a,[CH1Note]
	add	b
	
	ld	c,a
	ld	b,0
	
	ld	hl,FreqTable
	add	hl,bc
	add	hl,bc	

; get note frequency
	ld	a,[hl+]
	ld	d,a
	ld	a,[hl]
	ld	e,a
.updateVibTable
	ld	a,[CH1VibDelay]
	and	a
	jr	z,.doVib
	dec	a
	ld	[CH1VibDelay],a
	jr	.setFreq
.doVib
	ld	hl,CH1VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH1VibPos]
	add	l
	ld	l,a
	jr	nc,.nocarry4
	inc	h
.nocarry4
	ld	a,[hl+]
	cp	$80
	jr	nz,.noloop2
	ld	a,[hl+]
	ld	[CH1VibPos],a
	jr	.doVib
.noloop2
	ld	[CH1FreqOffset],a
	ld	a,[CH1VibPos]
	inc	a
	ld	[CH1VibPos],a
	
.getPitchOffset
	ld	a,[CH1FreqOffset]
	bit	7,a
	jr	nz,.sub
	add	d
	ld	d,a
	jr	nc,.setFreq
	inc	e
	jr	.setFreq
.sub
	ld	c,a
	ld	a,d
	add	c
	ld	d,a
.setFreq	
	ld	a,d
	ldh	[rNR13],a
	ld	a,e
	ldh	[rNR14],a
	
	; update volume
.updateVolume
	ld	hl,CH1VolPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH1VolPos]
	add	l
	ld	l,a
	jr	nc,.nocarry5
	inc	h
.nocarry5
	ld	a,[hl+]
	cp	$ff
	jr	z,.done
	swap	a
	ld	b,a
	ldh	a,[rNR12]
	cp	b
	jr	z,.noreset3
	ld	a,b
	ldh	[rNR12],a
	ld	a,e
	or	$80
	ldh	[rNR14],a
.noreset3
	ld	a,[CH1VolPos]
	inc	a
	ld	[CH1VolPos],a
	ld	a,[hl+]
	cp	$8f
	jr	nz,.done
	ld	a,[hl]
	ld	[CH1VolPos],a
.done

; ================================================================

CH2_UpdateRegisters:
	ld	a,[CH2Enabled]
	and	a
	jp	z,CH3_UpdateRegisters
	
	if(UseFXHammer)
	ld	a,[$c7cc]
	cp	3
	jr	z,.norest
	endc
	ld	a,[CH2Note]
	cp	rest
	jr	nz,.norest
	xor	a
	ldh	[rNR22],a
	ldh	a,[rNR24]
	or	%10000000
	ldh	[rNR24],a
	jp	.done
.norest

	; update arps
.updatearp
	ld	hl,CH2ArpPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH2ArpPos]
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	cp	$80
	jr	nz,.noloop
	ld	a,[hl]
	ld	[CH2ArpPos],a
	jr	.updatearp
.noloop
	cp	$ff
	jr	z,.continue
	ld	[CH2Transpose],a
.noreset
	ld	a,[CH2ArpPos]
	inc	a
	ld	[CH2ArpPos],a
.continue
	
	; update pulse
	ld	hl,CH2PulsePtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH2PulsePos]
	add	l
	ld	l,a
	jr	nc,.nocarry2
	inc	h
.nocarry2
	ld	a,[hl+]
	cp	$ff
	jr	z,.updateNote
	; convert pulse value
	and	3			; make sure value does not exceed 3
	swap	a		; swap lower and upper nybbles
	rla				; rotate left
	rla				;   ""    ""
	if(UseFXHammer)
	ld	e,a
	ld	a,[$c7cc]
	cp	3
	jp	z,.noreset2
	ld	a,e
	endc
	ldh	[rNR21],a	; transfer to register
.noreset2
	ld	a,[CH2PulsePos]
	inc	a
	ld	[CH2PulsePos],a
	ld	a,[hl+]
	cp	$80
	jr	nz,.updateNote
	ld	a,[hl]
	ld	[CH2PulsePos],a
	
; get note
.updateNote
	ld	a,[CH2Transpose]
	ld	b,a
	ld	a,[CH2Note]
	add	b
	
	ld	c,a
	ld	b,0
	
	ld	hl,FreqTable
	add	hl,bc
	add	hl,bc
	
	; get note frequency
	ld	a,[hl+]
	ld	d,a
	ld	a,[hl]
	ld	e,a
.updateVibTable
	ld	a,[CH2VibDelay]
	and	a
	jr	z,.doVib
	dec	a
	ld	[CH2VibDelay],a
	jr	.setFreq
.doVib
	ld	hl,CH2VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH2VibPos]
	add	l
	ld	l,a
	jr	nc,.nocarry4
	inc	h
.nocarry4
	ld	a,[hl+]
	cp	$80
	jr	nz,.noloop2
	ld	a,[hl+]
	ld	[CH2VibPos],a
	jr	.doVib
.noloop2
	ld	[CH2FreqOffset],a
	ld	a,[CH2VibPos]
	inc	a
	ld	[CH2VibPos],a
	
.getPitchOffset
	ld	a,[CH2FreqOffset]
	bit	7,a
	jr	nz,.sub
	add	d
	ld	d,a
	jr	nc,.setFreq
	inc	e
	jr	.setFreq
.sub
	ld	c,a
	ld	a,d
	add	c
	ld	d,a
.setFreq	
	if(UseFXHammer)
	ld	a,[$c7cc]
	cp	3
	jp	z,.updateVolume
	endc
	ld	a,d
	ldh	[rNR23],a
	ld	a,e
	ldh	[rNR24],a

	; update volume
.updateVolume
	ld	hl,CH2VolPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH2VolPos]
	add	l
	ld	l,a
	jr	nc,.nocarry5
	inc	h
.nocarry5
	ld	a,[hl+]
	cp	$ff
	jr	z,.done
	swap	a
	ld	b,a
	if(UseFXHammer)
	ld	a,[$c7cc]
	cp	3
	jp	z,.noreset3
	endc
	ldh	a,[rNR22]
	cp	b
	jr	z,.noreset3
	ld	a,b
	ldh	[rNR22],a
	ld	a,e
	or	$80
	ldh	[rNR24],a
.noreset3
	ld	a,[CH2VolPos]
	inc	a
	ld	[CH2VolPos],a
	ld	a,[hl+]
	cp	$8f
	jr	nz,.done
	ld	a,[hl]
	ld	[CH2VolPos],a
.done

; ================================================================

CH3_UpdateRegisters:
	ld	a,[CH3Enabled]
	and	a
	jp	z,CH4_UpdateRegisters

	ld	a,[CH3Note]
	cp	rest
	jr	nz,.norest
	xor	a
	ldh	[rNR32],a
	ld	[CH3Vol],a
	ldh	a,[rNR34]
	or	%10000000
	ldh	[rNR34],a
	jp	.done
.norest

	; update arps
.updatearp
	ld	hl,CH3ArpPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH3ArpPos]
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	cp	$80
	jr	nz,.noloop
	ld	a,[hl]
	ld	[CH3ArpPos],a
	jr	.updatearp
.noloop
	cp	$ff
	jr	z,.continue
	ld	[CH3Transpose],a
.noreset
	ld	a,[CH3ArpPos]
	inc	a
	ld	[CH3ArpPos],a
.continue

	xor	a
	ldh	[rNR31],a
	or	%10000000
	ldh	[rNR30],a
	
; get note
.updateNote
	ld	a,[CH3Transpose]
	ld	b,a
	ld	a,[CH3Note]
	add	b
	
	ld	c,a
	ld	b,0
	
	ld	hl,FreqTable
	add	hl,bc
	add	hl,bc
	
	; get note frequency
	ld	a,[hl+]
	ld	d,a
	ld	a,[hl]
	ld	e,a
.updateVibTable
	ld	a,[CH3VibDelay]
	and	a
	jr	z,.doVib
	dec	a
	ld	[CH3VibDelay],a
	jr	.setFreq
.doVib
	ld	hl,CH3VibPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH3VibPos]
	add	l
	ld	l,a
	jr	nc,.nocarry4
	inc	h
.nocarry4
	ld	a,[hl+]
	cp	$80
	jr	nz,.noloop2
	ld	a,[hl+]
	ld	[CH3VibPos],a
	jr	.doVib
.noloop2
	ld	[CH3FreqOffset],a
	ld	a,[CH3VibPos]
	inc	a
	ld	[CH3VibPos],a
	
.getPitchOffset
	ld	a,[CH3FreqOffset]
	bit	7,a
	jr	nz,.sub
	add	d
	ld	d,a
	jr	nc,.setFreq
	inc	e
	jr	.setFreq
.sub
	ld	c,a
	ld	a,d
	add	c
	ld	d,a
.setFreq	
	ld	a,d
	ldh	[rNR33],a
	ld	a,e
	ldh	[rNR34],a
	
	; update wave
	ld	hl,CH3WavePtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH3WavePos]
	add	l
	ld	l,a
	jr	nc,.nocarry2
	inc	h
.nocarry2
	ld	a,[hl+]
	cp	$ff					; table end?
	jr	z,.updateVolume
	ld	b,a
	ld	a,[CH3Wave]
	cp	b
	jr	z,.noreset2
	ld	a,b
	ld	[CH3Wave],a
	cp	$c0					; if value = $c0, use wave buffer
	jr	nz,.notwavebuf
	ld	hl,WaveBuffer
	jr	.loadwave
.notwavebuf
	add	a
	ld	hl,WaveTable
	add	l
	ld	l,a
	jr	nc,.nocarry3
	inc	h	
.nocarry3
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
.loadwave
	call	LoadWave
	ld	a,e
	or	%10000000
	ldh	[rNR34],a
.noreset2
	ld	a,[CH3WavePos]
	inc	a
	ld	[CH3WavePos],a
	ld	a,[hl+]
	cp	$80
	jr	nz,.updateVolume
	ld	a,[hl]
	ld	[CH3WavePos],a

.updateVolume
	ld	hl,CH3VolPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH3VolPos]
	add	l
	ld	l,a
	jr	nc,.nocarry5
	inc	h
.nocarry5
	ld	a,[hl+]
	cp	$ff
	jr	z,.done
	ld	b,a
	ld	a,[CH3Vol]
	cp	b
	jr	z,.noreset3
	ld	a,b
	ldh	[rNR32],a
	ld	[CH3Vol],a
	ld	a,e
	or	$80
	ldh	[rNR34],a
.noreset3
	ld	a,[CH3VolPos]
	inc	a
	ld	[CH3VolPos],a
	ld	a,[hl+]
	cp	$80
	jr	nz,.done
	ld	a,[hl]
	ld	[CH3VolPos],a
.done
	call	DoPWM
	call	DoRandomizer
	ld	a,[CH3Wave]
	cp	$c0
	jr	nz,.noupdate
	ld	a,[WaveBufUpdateFlag]
	and	a
	jr	z,.noupdate
	ld	hl,WaveBuffer
	call	LoadWave
	xor	a
	ld	[WaveBufUpdateFlag],a
	ld	a,e
	or	$80
	ldh	[rNR34],a
.noupdate

; ================================================================

CH4_UpdateRegisters:
	ld	a,[CH4Enabled]
	and	a
	jp	z,DoneUpdatingRegisters
	
	if(UseFXHammer)
	ld	a,[$c7d9]
	cp	3
	jr	z,.norest
	endc
	ld	a,[CH4Mode]
	cp	rest
	jr	nz,.norest
	xor	a
	ldh	[rNR42],a
	ldh	a,[rNR44]
	or	%10000000
	ldh	[rNR44],a
	jp	.done
.norest

	; update arps
.updatearp
	ld	hl,CH4NoisePtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH4NoisePos]
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	cp	$80
	jr	nz,.noloop
	ld	a,[hl]
	ld	[CH4NoisePos],a
	jr	.updatearp
.noloop
	cp	$ff
	jr	z,.continue
	ld	[CH4Transpose],a
.noreset
	ld	a,[CH4NoisePos]
	inc	a
	ld	[CH4NoisePos],a
.continue
	
; get note
.updateNote
	ld	a,[CH4Transpose]
	ld	b,a
	ld	a,[CH4Mode]
	add	b
	
	ld	hl,NoiseTable
	add	l
	ld	l,a
	jr	nc,.nocarry2
	inc	h
.nocarry2
	
	if(UseFXHammer)
	ld	a,[$c7d9]
	cp	3
	jr	z,.updateVolume
	endc
	ld	a,[hl+]
	ldh	[rNR43],a	

	; update volume
.updateVolume
	ld	hl,CH4VolPtr
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,[CH4VolPos]
	add	l
	ld	l,a
	jr	nc,.nocarry3
	inc	h
.nocarry3
	ld	a,[hl+]
	cp	$ff
	jr	z,.done
	swap	a
	ld	b,a
	if(UseFXHammer)
	ld	a,[$c7d9]
	cp	3
	jr	z,.noreset3
	endc
	ldh	a,[rNR42]
	cp	b
	jr	z,.noreset3
	ld	a,b
	ldh	[rNR42],a
	ld	a,%10000000
	ldh	[rNR44],a
.noreset3
	ld	a,[CH4VolPos]
	inc	a
	ld	[CH4VolPos],a
	ld	a,[hl+]
	cp	$8f
	jr	nz,.done
	ld	a,[hl]
	ld	[CH4VolPos],a
.done
	
DoneUpdatingRegisters:
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret

; ================================================================
; Wave routines
; ================================================================

LoadWave:
	xor	a
	ldh	[rNR30],a	; disable CH3
	ld	bc,$1030	; b = counter, c = HRAM address
.loop
	ld	a,[hl+]		; get byte from hl
	ld	[c],a		; copy to wave ram
	inc	c
	dec	b
	jr	nz,.loop	; loop until done
	ld	a,%10000000
	ldh	[rNR30],a	; enable CH3
	ret
	
ClearWaveBuffer:
	ld	b,$10
	xor	a
	ld	hl,WaveBuffer
.loop
	ld	[hl+],a		; copy to wave ram
	dec	b
	jr	nz,.loop	; loop until done
	ret

; Combine two waves. Optimized by Pigu
; INPUT: bc = first wave addr
;		 de = second wave addr

_CombineWaves:
	ld hl,WaveBuffer
	ld a,16
.loop
	push	af
	push	hl
	ld	a,[bc]
	and	$f
	ld	l,a
	ld	a,[de]
	and	$f
	add	l
	rra
	ld	l,a
	ld	a,[bc]
	inc	bc
	and	$f0
	ld	h,a
	ld	a,[de]
	inc	de
	and	$f0
	add	h
	rra
	and	$f0
	or	l
	pop	hl
	ld	[hl+],a
	pop	af
	dec	a
	jr	nz, .loop
	ld	a,1
	ld	[WaveBufUpdateFlag],a
	ret
	
; Randomize the wave buffer

_RandomizeWave:
	push	de
	ld	hl,NoiseData
	ld	de,WaveBuffer
	ld	b,$10
	ld	a,[WavePos]
	inc	a
	ld	[WavePos],a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	ld	hl,NoiseData
	add	l
	ld	l,a
	jr	nc,.loop
	inc	h
.loop
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	b
	jr	nz,.loop
	ld	a,1
	ld	[WaveBufUpdateFlag],a
	pop	de
	ret

; Do PWM
DoPWM:
	ld	a,[PWMEnabled]
	and	a
	ret	z	; if PWM is not enabled, return
	ld	a,[PWMTimer]
	dec	a
	ld	[PWMTimer],a
	and	a
	ret	nz
	ld	a,[PWMSpeed]
	ld	[PWMTimer],a
	ld	a,[PWMDir]
	and	a
	jr	nz,.decPos
.incPos	
	ld	a,[WavePos]
	inc	a
	ld	[WavePos],a
	cp	$1e
	jr	nz,.continue
	ld	a,[PWMDir]
	xor	1
	ld	[PWMDir],a
	jr	.continue
.decPos
	ld	a,[WavePos]
	dec	a
	ld	[WavePos],a
	and	a
	jr	nz,.continue2
	ld	a,[PWMDir]
	xor	1
	ld	[PWMDir],a
	jr	.continue2
.continue
	ld	hl,WaveBuffer
	ld	a,[WavePos]
	rra
	push	af
	and	$f
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	pop	af
	jr	c,.odd
.even
	ld	a,[PWMVol]
	swap	a
	ld	[hl],a
	jr	.done
.odd
	ld	a,[hl]
	ld	b,a
	ld	a,[PWMVol]
	or	b
	ld	[hl],a
	jr	.done
	
.continue2
	ld	hl,WaveBuffer
	ld	a,[WavePos]
	inc	a
	rra
	push	af
	and	$f
	add	l
	ld	l,a
	jr	nc,.nocarry2
	inc	h
.nocarry2
	pop	af
	jr	nc,.odd2
.even2
	ld	a,[PWMVol]
	swap	a
	ld	[hl],a
	jr	.done
.odd2
	xor	a
	ld	[hl],a
.done
	ld	a,1
	ld	[WaveBufUpdateFlag],a
	ret
	
DoRandomizer:
	ld	a,[RandomizerEnabled]
	and	a
	ret	z	; if randomizer is disabled, return
	ld	a,[RandomizerTimer]
	dec	a
	ld	[RandomizerTimer],a
	ret	nz
	ld	a,[RandomizerSpeed]
	ld	[RandomizerTimer],a
	call	_RandomizeWave
	ret
	
; ================================================================
; Misc routines
; ================================================================

ClearArpBuffer:
	ld	hl,ArpBuffer
	push	hl
	inc	hl
	ld	b,7
	xor	a
.loop
	ld	a,[hl+]
	dec	b
	jr	nz,.loop
	dec	a
	pop	hl
	ld	a,[hl]
	ret
	
DoArp:
	ld	de,ArpBuffer
	ld	a,[hl+]
	and	a
	jr	nz,.slow
.fast
	xor	a
	ld	[de],a
	inc	de
	ld	a,[hl]
	swap	a
	and	$f
	ld	[de],a
	inc	de
	ld	a,[hl+]
	and	$f
	ld	[de],a
	inc	de
	ld	a,$80
	ld	[de],a
	inc	de
	xor	a
	ld	[de],a
	ret
.slow
	xor	a
	ld	[de],a
	inc	de
	ld	[de],a
	inc	de
	ld	a,[hl]
	swap	a
	and	$f
	ld	[de],a
	inc	de
	ld	[de],a
	inc	de
	ld	a,[hl+]
	and	$f
	ld	[de],a
	inc	de
	ld	[de],a
	inc	de
	ld	a,$80
	ld	[de],a
	inc	de
	xor	a
	ld	[de],a
	ret

; ================================================================
; Frequency table
; ================================================================

FreqTable:  ; TODO: Add at least one extra octave
;	     C-x  C#x  D-x  D#x  E-x  F-x  F#x  G-x  G#x  A-x  A#x  B-x
	dw	$02c,$09c,$106,$16b,$1c9,$223,$277,$2c6,$312,$356,$39b,$3da ; octave 1
	dw	$416,$44e,$483,$4b5,$4e5,$511,$53b,$563,$589,$5ac,$5ce,$5ed ; octave 2
	dw	$60a,$627,$642,$65b,$672,$689,$69e,$6b2,$6c4,$6d6,$6e7,$6f7 ; octave 3
	dw	$706,$714,$721,$72d,$739,$744,$74f,$759,$762,$76b,$773,$77b ; octave 4
	dw	$783,$78a,$790,$797,$79d,$7a2,$7a7,$7ac,$7b1,$7b6,$7ba,$7be ; octave 5
	dw	$7c1,$7c4,$7c8,$7cb,$7ce,$7d1,$7d4,$7d6,$7d9,$7db,$7dd,$7df ; octave 6
	dw	$7e0,$7e2,$7e4,$7e5,$7e7,$7e8,$7ea,$7eb,$7ec,$7ee,$7ee,$7ef ; octave 7 (not used directly, is slightly out of tune)
	
NoiseTable:	; taken from deflemask
	db	$a4	; 15 steps
	db	$97,$96,$95,$94,$87,$86,$85,$84,$77,$76,$75,$74,$67,$66,$65,$64
	db	$57,$56,$55,$54,$47,$46,$45,$44,$37,$36,$35,$34,$27,$26,$25,$24
	db	$17,$16,$15,$14,$07,$06,$05,$04,$03,$02,$01,$00
	db	$ac	; 7 steps
	db	$9f,$9e,$9d,$9c,$8f,$8e,$8d,$8c,$7f,$7e,$7d,$7c,$6f,$6e,$6d,$6c
	db	$5f,$5e,$5d,$5c,$4f,$4e,$4d,$4c,$3f,$3e,$3d,$3c,$2f,$2e,$2d,$2c
	db	$1f,$1e,$1d,$1c,$0f,$0e,$0d,$0c,$0b,$0a,$09,$08

; ================================================================
; misc stuff
; ================================================================
	
DefaultRegTable:
	; global flags
	db	7,0,0,0,0,0,0,1,1,1,1,1
	; ch1
	dw	DummyTable,DummyTable,DummyTable,DummyTable,DummyTable
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	; ch2
	dw	DummyTable,DummyTable,DummyTable,DummyTable,DummyTable
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	; ch3
	dw	DummyTable,DummyTable,DummyTable,DummyTable,DummyTable
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$ff,0,0,0,0,0,0
	; ch4
	dw	DummyTable,DummyTable,DummyTable
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
DefaultWave:	db	$01,$23,$45,$67,$89,$ab,$cd,$ef,$fe,$dc,$ba,$98,$76,$54,$32,$10

NoiseData:		incbin	"sound/NoiseData.bin"
	
; ================================================================
; Dummy data
; ================================================================
	
DummyTable:	db	$ff

DummyChannel:
	db	EndChannel
