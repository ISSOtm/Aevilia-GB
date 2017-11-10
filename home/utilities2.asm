

SECTION "Utilities 2", ROM0
	
; Copy str from b:hl to de
CopyStrAcross::
	ldh a, [hCurROMBank]
	push af
	ld a, b
	rst bankswitch
	rst copyStr
	pop af
	rst bankswitch
	ret

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
	dec a
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
	
; Copy bc bytes from a:hl to de, assuming de is in VRAM
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
	
	
; Get the byte at b:hl in a (and b)
GetByteAcross::
	ldh a, [hCurROMBank]
	push af
	ld a, b
	rst bankswitch
	ld b, [hl]
	pop af
	rst bankswitch
	ld a, b
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
	ld c, a
	cp $0A
	ldh a, [hRandIntHigh]
	jr nz, .dontChangeCycles
	cp $56
	jr nz, .dontChangeCycles
	xor a
	ld c, a
.dontChangeCycles
	xor c
	ld h, a
	ld l, c
	ld b, l
	ld c, h
	add hl, hl
	ld a, l
	xor c
	ld l, a
	ld a, h
	and $01 ; Remove pre-shift upper byte
	xor b ; Resets carry
	rra
	cpl
	ld h, a
	ld a, l
	rra
	ld bc, $1F74
	jr nc, .useThatConstant
	ld bc, $8100
.useThatConstant
	xor c
	ld l, a
	ldh [hRandIntLow], a
	ld a, h
	xor b
	ld h, a
	ldh [hRandIntHigh], a
	ret
	
	
PrintAcross::
	ldh a, [hCurROMBank]
	push af
	ld a, b
	rst bankswitch
	call StrnPrint
	pop af
	rst bankswitch
	ret
	
; Print the string pointed to by hl at de (not including the terminating NUL)
; At most c chars will be printed
StrnPrint::
	ld a, c
	and a
	ret z
	
	ld a, [hli]
	cp $20
	jr nc, .normalChar
	; This is a control char
	and a ; The terminator ends it all
	ret z
	
	push hl ; Save the read ptr where we read from the control char
	dec a ; Get index between 0 and $1E (since original 0 has been removed)
	add a, a
	add a, LOW(.controlChars)
	ld l, a
	adc a, HIGH(.controlChars)
	sub l
	ld h, a ; Get pointer to control char's func
	ld a, [hli] ; Read addr of control char's func
	ld h, [hl]
	ld l, a
	rst callHL ; Obtain pointer to read
	call StrnPrint ; Copy it w/ control chars & border prevention
	pop hl ; Get back read ptr
	jr StrnPrint
	
.normalChar
	ld [de], a
	inc de
	dec c
	jr StrnPrint
	
	; Array of pointers to functions that return a pointer to the string to be copied
	; (Note : if you're smart you can have the function perform the write itself, by returning a pointer to a NUL)
	; WARNING : these functions must NOT modify c or de !!
.controlChars
	dw .siblingName
	dw .playerBroSis
	dwfill 29, .doNothing
	
.siblingName
	ld hl, TomName
	ld a, [wPlayerGender]
	and a
	ret z
	ld hl, EvieName
	ret
	
.playerBroSis
	ld hl, SisString
	ld a, [wPlayerGender]
	and a
	ret z
	ld hl, BroString
	ret
	
.doNothing
	ld hl, NullByte ; Points to a NUL, thus does nothing
	ret
	
	
DivideBy3::
	ld c, 0
.divideBy3
	inc c
	sub 3
	jr nc, .divideBy3
	dec c ; There was a remainder, we don't want that to count as a full 3
	ret
	
	
ClearMovableMap::
	ld hl, vTileMap0
	ld bc, vTileMap1 - vTileMap0
	xor a
	jp FillVRAM
	
	
; Transfer c tiles from b:hl to de using HDMA if available
; (This assumes hl and de are aligned)
; NOTE : don't try to transfer more than 128 tiles !!
TransferTilesAcross::
	ldh a, [hCurROMBank]
	push af
	ld a, b
	rst bankswitch
	ld b, c ; Transfer to b 'cause c will be re-used a lot
.tryAgain
	ldh a, [hHDMAInUse]
	and a
	jr z, .HDMAClear
	; Transfer one tile "normally"
	ld c, VRAM_TILE_SIZE
	call CopyToVRAMLite
	dec b
	jr nz, .tryAgain ; If any tiles remain, try again to use HDMA
	jr .done
	
.transferAgain
	ld b, $7F
	jr .waitHBlank
	
.HDMAClear
	inc a
	ldh [hHDMAInUse], a
	dec b ; We have to write 1 less than the number of tiles
	ld c, LOW(rHDMA1)
	ld a, h
	ld [c], a
	inc c
	ld a, l
	ld [c], a
	inc c
	ld a, d
	ld [c], a
	inc c
	ld a, e
	ld [c], a
	inc c
.waitHBlank
	rst isVRAMOpen
	jr nz, .waitHBlank
.waitNotHBlank
	rst isVRAMOpen
	jr z, .waitNotHBlank
	ld a, b
	or $80
	ld [c], a ; Start HDMA
.waitHDMA
	ld a, [c]
	inc a
	jr nz, .waitHDMA
	ld a, b
	sub $80
	jr nc, .transferAgain
	xor a
	ldh [hHDMAInUse], a
.done
	pop af
	rst bankswitch
	ret
	
	
ExtendOAM::
	ld a, BANK(wStagedOAM) ; Non-zero
	ldh [hOAMMode], a ; Set OAM mode to "with extension"
	call SwitchRAMBanks
	
	ld de, wStagedOAM
	ld a, [wNumOfSprites]
	cp NB_OF_SPRITES + 1
	jr c, .copyMainOAM
	ld a, NB_OF_SPRITES
.copyMainOAM
	ld b, a
	add a, a
	jr z, .emptyMainOAM
	add a, a
	ld c, a
	ld hl, wVirtualOAM
	rst copy
.emptyMainOAM
	
	; Transfer extended OAM into staged OAM, making sure not to overflow it
	ld a, [wNumOfExtendedSprites]
	ld c, a ; Save this
	add b ; Add counts to get total number of sprites
	cp NB_OF_SPRITES + 1 ; Check if the two OAMs don't max out the actual one
	jr c, .OAMNotFull
	ld a, NB_OF_SPRITES ; Max capacity
	sub b ; Remove all sprites used by main OAM
	ld c, a ; Store as count of sprites to transfer
	add b
.OAMNotFull
	
	ld a, c
	add a, a
	jr z, .noExtendedSprites ; Return if no sprites should be transferred
	add a, a
	ld c, a ; Get length
	ld hl, wExtendedOAM
	rst copy
.noExtendedSprites
	
	ld a, e
.clearStagedOAM
	cp OAM_SPRITE_SIZE * NB_OF_SPRITES
	ret z
	xor a
	ld [de], a
	ld a, e
	add a, OAM_SPRITE_SIZE
	ld e, a
	jr .clearStagedOAM
	
	
; Prints b as hex to de
; Advances de as well
PrintHex::
	ld a, b
	and $F0
	swap a
	add a, "0"
	cp ":"
	jr c, .isDigitHigh
	add a, "A" - ":"
.isDigitHigh
	ld [de], a
	inc de
	ld a, b
	and $0F
	add a, "0"
	cp ":"
	jr c, .isDigitLow
	add a, "A" - ":"
.isDigitLow
	ld [de], a
	inc de
	ret
