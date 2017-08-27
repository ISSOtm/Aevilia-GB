

SECTION "Utilities 2", ROM0

; Returns hl divided by de in bc
; Remainder can be obtained in hl by "add hl, de"
DivideHLByDE::
	ld a, d
	or e
	jr z, DividingByZero
DivideHLByDE_KnownDE:: ; Jump here if de CANNOT be zero. Just be CERTAIN it can't be zero, the check is done quickly
	ld bc, 0
.loop
	ld a, l ; sub hl, de
	sub e
	ld l, a
	ld a, h
	sbc d ; Carry, lel
	ld h, a
	ret c ; Return if underflow happened
	inc bc
	jr nc, .loop
	ret
DividingByZero:
	ld [wSaveA], a
	ld a, ERR_DIV_BY_ZERO
	jr FatalError
	
; Used by "rst callHL" to trap jumps to RAM
_AtHL_FatalError::
	ld [wSaveA], a
	ld a, ERR_PC_IN_RAM
	; Slide through
	
	
; Call with error ID in a
FatalError::
	di
	ld [wFatalErrorCode], a ; Preserve error code
.loop ; Wait until VBlank - do not issue a call or rst to preserve the stack as much as possible
	ld a, [rSTAT]
	and 3
	sub 1
	jr nz, .loop
	ld [rLCDC], a ; Shut LCD down (don't call function because it uses b)
	ld [rVBK], a ; Make sure to be in bank 0 for printing ; swap before saving SP for obvious reasons
	
	; Further things will be stored into VRAM, because it won't overwrite any WRAM!
	ld [$9BFE], sp ; Store the stack pointer twice in the upcoming stack
	ld [$9BFC], sp
	ld sp, $9BFC ; This will enable us to pop twice and get SP back
	
	ld a, [wSaveA]
	push hl
	push de
	push bc
	push af
	
	ld a, BANK(BasicFont)
	ld [ROMBankLow], a
	ld hl, BasicFont
	ld de, vFontTiles
	ld bc, 52 * 16
	call Copy
	
	ld a, BANK(DebugFatalError)
	rst bankswitch
	jp DebugFatalError
	
	
; Copy bc bytes from a:hl to de
CopyAcross::
	; This function starts by performing heavy register movement to still register the current ROM bank before switching. Beware, it's a bit complicated :3
	
	push bc ; Save bc, used to save data manipulation
	ld b, a ; Save target bank to free a
	ldh a, [hCurROMBank] ; Can only use a for this (otherwise code would have been much simpler)
	ld c, a ; Ideally we would push af, but we must pop bc first! So save value to swap with b
	ld a, b ; Get target bank back
	rst bankswitch ; And make it fulfill its purpose! YEAH!!
	ld a, c ; Now we can get the saved bank back, which ALSO frees bc! Hooray!
	
	pop bc ; Get back bc, freeing the stack...
	push af ; ... so we can save the bank. Wow. Now THAT was some good register manipulation :P
	
	call Copy ; The correct bank is loaded, the correct parameters are set... We're golden!
	pop af
	rst bankswitch
	ret
	
; Copy c bytes from a:hl to de, assuming de is in VRAM
; Thus, doesn't copy if VRAM isn't available
CopyAcrossToVRAM::
	; If this function looks kamoulox-esque, see CopyAcross
	push bc
	ld b, a
	ldh a, [hCurROMBank]
	ld c, a
	ld a, b
	rst bankswitch
	ld a, c
	pop bc
	push af
	
	call CopyToVRAM
	pop af
	rst bankswitch
	ret
	
	
FillVRAM::
	ld d, a
.fillLoop
	rst isVRAMOpen
	jr nz, .fillLoop
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .fillLoop
	ret
	
	
; Shamelessly stolen from SM64
; It's a very neat bijection, and I'm not good enough to produce such a nice function
; I didn't implement the weird re-looping they did, though X)
RandInt::
	ldh a, [hRandIntLow]
	ld l, a
	cp $0A
	ldh a, [hRandIntHigh]
	jr nz, .dontChangeCycles
	cp $56
	jr nz, .dontChangeCycles
	xor a
	ld l, a
.dontChangeCycles
	ld h, a
	xor l
	ld c, a
	ld b, l
	ld h, 0
	add hl, hl
	ld a, l
	xor c
	ld l, a
	ld a, h
	xor b
	cpl
	scf
	rra
	ld b, a
	ld a, l
	rra
	ld c, a
	ld hl, $1FF4
	jr nc, .useThatConstant
	ld hl, $8180
.useThatConstant
	ld a, h
	xor b
	ld h, a
	ld a, l
	xor c
	ld l, a
	ldh [hRandIntLow], a
	ld a, h
	ldh [hRandIntHigh], a
	ret
	
	
; Used by PrintKnownPointer
TextCopyAcross::
	ldh a, [hCurROMBank]
	push af
	ld a, b
	rst bankswitch
.copyText
	ld a, [hli]
	and a
	jr z, .endCopy
	ld [de], a
	inc de
	jr .copyText
.endCopy
	ld a, [de]
	cp $10
	jr z, .dontOverwriteBorder
	xor a
	ld [de], a
.dontOverwriteBorder
	pop af
	rst bankswitch
	ret
	
	
DivideBy3::
	ld c, 0
.divideBy3
	inc c
	sub 3
	jr nc, .divideBy3
	dec c ; There was a remainder, we don't want that to count as a full 3
	ret
