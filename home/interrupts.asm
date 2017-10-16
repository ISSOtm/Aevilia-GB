

SECTION "Interrupt vectors", ROM0[$0040]

; VBlank
VBlank_int::
	push af
	push bc
	call VBlankHandler
	pop bc
	pop af
	reti
	
; STAT
STAT_int::
	push af
	ld a, [rSTAT]
	push hl
	jp STATHandler
	
; Timer
Timer_int::
	reti
	
; Fitting these two functions in the spare bytes for MAXIMUM DATA COMPRESSION 8|
	
; Switches to RAM bank a
SwitchRAMBanks::
	ldh [hCurRAMBank], a
	ld [rSVBK], a
	
; In case you need to point to a `ret`
DoNothing::
	ret
	
; Do you need a pointer to $00, be it byte or word?
; WE GOT YOU COVERED RIGHT HERE!!1
NullWord::
NullByte::
	dw 0
	
; Serial
Serial_int::
	reti
	
; Delay bc frames
DelayBCFrames::
	rst waitVBlank
	dec bc
	ld a, b
	or c
	jr nz, DelayBCFrames
	ret
	
; Joypad
Joypad_int::
	reti ; Will never be used, I think
	; Thus, no extra space behind it, so we can fit 7 more function bytes :)
