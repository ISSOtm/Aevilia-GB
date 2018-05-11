
SECTION "Error handler", ROMX
	
	
; Function to print the fatal error handler
; Also in this bank since there's lotsa room for this
DebugFatalError::
	xor a
	ld [rNR52], a
	ld [rSCY], a
	ld [rSCX], a
	ld hl, vTileMap1
	ld bc, 32 * SCREEN_HEIGHT
	call Fill
	
	; Make sure the user will see something
	ld a, 1
	ld [rVBK], a
	ld hl, vAttrMap1
	ld c, 13
	dec a
	rst fill
	inc a
	ld bc, $400 - 13
	call Fill
	ld hl, $9F42
	ld c, 9
	dec a
	rst fill
	ld [rVBK], a
	ld c, 0
	callacross LoadFont
	ld c, 1
	ld de, GrayPalette
	callacross LoadBGPalette_Hook
	ld c, 0
	ld de, InvertedPalette
	callacross LoadBGPalette_Hook
	
	ld hl, FatalErrorString
	ld de, vTileMap1
	rst copyStr
	
	ld a, [wFatalErrorCode]
	and a
	jr z, .unknownError
	cp ERR_MAX
	jr nc, .unknownError
	ld c, a
.getErrorName
	ld a, [hli]
	and a
	jr nz, .getErrorName
	dec c
	jr nz, .getErrorName
.unknownError ; Jump here to skip looking for error name
	ld e, $20
	rst copyStr ; Print error name
	
	; Print all registers at time of fatal error
	ld hl, FatalErrorScreenStrings
	ld e, $60
.printRegisters
	rst copyStr
	pop bc
	call PrintHex
	ld b, c
	call PrintHex
	ld a, e
	and $E0
	add a, $20
	ld e, a
	jr nz, .printRegisters
	
	; Print loaded ROM bank at time of error (obviously bank 3 is loaded now)
	ld de, $9D20
	rst copyStr
	ldh a, [hCurROMBank]
	ld b, a
	call PrintHex
	; Print loaded RAM bank
	ld e, $40
	rst copyStr
	ldh a, [hCurRAMBank]
	ld b, a
	call PrintHex
	
	; Print IE register
	ld e, $80
	rst copyStr
	ld a, [rIE]
	ld b, a
	call PrintHex
	; Print STAT register
	ld e, $A0
	rst copyStr
	ld a, [rSTAT]
	and $3C
	ld b, a
	call PrintHex
	
	ld de, $9E00
	rst copyStr
	ld e, $22
	pop hl ; Get stack pointer (again)
	ld bc, -(2 * 27)
	add hl, bc
.dumpStack
	; Print one entry
	ld b, h
	call PrintHex
	ld b, l
	call PrintHex
	ld a, ":"
	ld [de], a
	inc de
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	call PrintHex
	ld b, c
	call PrintHex
	inc de
	; Print another entry
	ld b, h
	call PrintHex
	ld b, l
	call PrintHex
	ld a, ":"
	ld [de], a
	inc de
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	call PrintHex
	ld b, c
	call PrintHex
	inc de
	; Print the last entry
	ld b, h
	call PrintHex
	ld b, l
	call PrintHex
	ld a, ":"
	ld [de], a
	inc de
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	call PrintHex
	ld b, c
	call PrintHex
	ld a, e
	add a, 3
	ld e, a
	jr nc, .noCarry
	inc d
	bit 5, d ; $9X = Z and $AX = NZ
	jr nz, .doneDumping
.noCarry
	jr .dumpStack
.doneDumping
	ld sp, $9C00
	
	; Display something for the user
	ld a, $89
	ld [rLCDC], a
	
	ld de, 0
.scrollAround
	; Update scroll
	ld a, d
	ld [rSCX], a
	ld a, e
	ld [rSCY], a
	
.waitVBlankEnd
	ld a, [rSTAT]
	and $03
	dec a
	jr z, .waitVBlankEnd
.waitForVBlank
	ld a, [rSTAT]
	and $03
	dec a
	jr nz, .waitForVBlank
	
	call UpdateJoypadState
	ldh a, [hHeldButtons]
	rla
	jr nc, .notDown
	ld b, a
	ld a, e
	cp $70
	ld a, b
	jr z, .notDown
	inc e
.notDown
	rla
	jr nc, .notUp
	ld b, a
	ld a, e
	and a
	ld a, b
	jr z, .notUp
	dec e
.notUp
	rla
	jr nc, .notLeft
	ld b, a
	ld a, d
	and a
	ld a, b
	jr z, .notLeft
	dec d
.notLeft
	rla
	jr nc, .scrollAround
	ld a, d
	cp $60
	jr z, .scrollAround
	inc d
	jr .scrollAround
	
FatalErrorString::
	dstr "FATAL ERROR!"
	dstr "UNKNOWN ERROR!!!"
	dstr "RAM IS RW BUT NOT X"
	dstr "CANNOT DIV BY ZERO"
	dstr "WOOPS\, WRONG DOOR"
	dstr "WHERE AM I??"
	dstr "INVALID BATTLE TRANSITION"
	dstr "NONEXISTANT ENEMY"
	dstr "BAD THREAD 2 POINTER"
	
FatalErrorScreenStrings::
	dstr "AF ="
	dstr "BC ="
	dstr "DE ="
	dstr "HL ="
	dstr "SP ="
	dstr "ROM BANK"
	dstr "RAM BANK"
	dstr "IE ="
	dstr "STAT ="
	dstr "STACK DUMP :"
	
	
