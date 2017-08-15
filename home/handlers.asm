

SECTION "Interrupt handlers", ROM0

VBlankHandler::
	ld a, [rLY]
	cp LY_VBLANK + 3
	ret nc ; Return if interrupt fires too late, to avoid VBlank-sensitive operations to fail
	; If this return happens, something is wrong for sure, but we won't make it worse
	
	
	push de
	push hl
	ld a, BANK(wVirtualOAM)
	ld [rSVBK], a
	
	
	; Increment frame counter
	; This also means that skipping VBlank interrupt (or triggering it after $90 scanline)
	;   doesn't acknowledge we are on the next frame
	ldh a, [hFrameCounter]
	inc a
	ldh [hFrameCounter], a
	
	
	; Transfer WRAM positions to I/O (hiding window if needed)
	ld a, [wEnableWindow]
	and a
	ld a, LY_VBLANK
	jr z, .setWY ; Set window to be just under the screen, don't care about WX
	ld a, [wWX]
	ld [rWX], a
	ld a, [wWY]
.setWY
	ld [rWY], a
	
	
	ld a, [wScreenShakeAmplitude]
	and a
	jr z, .dontShakeScreen
	
	ld b, a
	and $80 ; Check if bit 7 is set (its meaning is separate from the amplitude)
	ld a, [wScreenShakeDisplacement]
	jr nz, .moveLeft ; Bit 7 is set, move left
	inc a
.movementCommon ; Code common to both movements
	ld [wScreenShakeDisplacement], a
	cp b
	jr nz, .dontShakeScreen ; We didn't reach the edge of the displacement
	ld a, b ; Retrieve amplitude
	cpl ; Negate amplitude
	inc a
	ld [wScreenShakeAmplitude], a
	jr .capAtAmplitude
; The placement of this piece of code can seem strange,
; but it is placed at a point that wouldn't be traversed otherwise.
; So this avoids doing a jr after the inc a above, saving some bytes and CPU cycles.
.moveLeft
	dec a
	jr .movementCommon
.dontShakeScreen
	ld [wScreenShakeDisplacement], a ; Avoid displacement carry-over (zeroing amplitude when displacement is non-zero then setting amplitude again)
	ld b, a ; Make sure B holds 0
.capAtAmplitude ; Jump here with b containing the displacement
	ldh a, [hTilemapMode]
	and a
	jr z, .mobileMap
	ld a, TILE_SIZE * 8
	ld [rSCY], a
	ld a, [rLCDC]
	or $08
	ld [rLCDC], a
	xor a
	jr .transferScroll
.mobileMap
	; Transfer WRAM positions, adding screen shake offset for SCX
	ld a, [rLCDC]
	and $F7
	ld [rLCDC], a
	ld a, [wSCY]
	ld [rSCY], a
	ld a, [wSCX]
.transferScroll
	add a, b
	ld [rSCX], a
	
	
	; Transfer fixed map
	ld bc, wTransferRows
	; We will look for any updated rows
.fixedMapTransferLoop
	ld a, [bc]
	and a
	jr nz, .rowUpdated
	inc c ; Check next row
	ld a, c
	cp (wTextboxTileMap & $FF)
	jr nz, .fixedMapTransferLoop
	jr .doneTransferringFixedMap
.rowUpdated ; This exits the loop, so only one row is transferred on each frame
	; Transferring two rows ends the VBlank interrupt after VBlank,
	; which causes issues (HBlank triggering after HBlank, WaitVBlank hanging...)
	; Additionally code that allows transferring two rows at once is *way* larger, so it's not worth it
	xor a
	ld [bc], a ; Mark row as transferred
	ld hl, wTextboxTileMap
	ld d, vTileMap1 >> 8
	ld a, c
	add a, a
	ld b, a
	add a, a
	add a, a
	add a, a
	jr nc, .noCarry1
	inc d
	inc d
.noCarry1
	add a, a
	jr nc, .noCarry2
	inc d
.noCarry2
	ld e, a
	
	ld a, b
	add a, a
	add a, a
	add a, b
	add a, a
	jr nc, .noCarry3
	inc h
.noCarry3
	add a, l
	ld l, a
	jr nc, .noCarry4
	inc h
.noCarry4
	ld a, [rVBK] ; Save current VRAM bank. We'd have to "and 1" to get the bank # but since bits 1-7 are ignored it's fine
	ld b, a
	xor a
	ld [rVBK], a ; Make sure not to overwrite attribute data
	ld c, SCREEN_WIDTH
	rst copy ; Transfer row
	ld a, b
	ld [rVBK], a ; Restore loaded VRAM bank
.doneTransferringFixedMap
	
	
	ld a, [wTransferSprites]
	and a
	jr z, .dontTransferSprites
	
	; Transfer OAM
	ld hl, wNumOfSprites
	ld a, [hli] ; Get number of sprites
	cp NB_OF_SPRITES + 1 ; Make sure this number is valid
	jr c, .numberOfSpritesValid
	ld a, NB_OF_SPRITES ; This should never be reached, but... it might !
	dec hl
	ld [hli], a ; Force number of sprites to be valid
.numberOfSpritesValid
	ld c, a ; Save this
	ld a, [hl] ; Subtract previous num of sprites
	sub c ; Calc difference
	jr c, .noSpritesToHide ; Negative ? Nothing to do !
	jr z, .noSpritesToHide ; Zero ? Same !
	
	ld b, a ; Save this as a counter
	dec hl
	ld a, [hli] ; Retrieve # of sprites
	add a, a
	add a, a ; Get offset
	ld e, a ; wVirtualOAM is 256-byte aligned, so this is fine
	ld d, wVirtualOAM >> 8 ; Get "erase" pointer
	xor a ; Put sprite just above screen
	
.clearSprite
	ld [de], a ; Move the sprite offscreen, to be faster don't clear the other bytes
REPT 4
	inc de
ENDR
	dec b
	jr nz, .clearSprite
	
.noSpritesToHide
	ld [hl], c ; Store Current into Previous
	xor a ; Don't transfer sprites until update
	ld [wTransferSprites], a
	
	; Copy DMA routine then call it
	; Prevents DMA hijacking :D
	ld hl, DMAScript
	ld c, hDMAScript & $FF
.copyDMARoutine
	ld a, [hli]
	ld [$FF00+c], a
	inc c
	cp $C9 ; Copied the RET ?
	jr nz, .copyDMARoutine
	; b's value was determined through testing...
	; less means returning before the CPU has access (crash),
	; and more means CPU time is wasted
	ld bc, (41 << 8) + (rDMA & $FF)
	ld a, wVirtualOAM >> 8
	call hDMAScript
	
.dontTransferSprites
	
	
	ld a, [wTextboxStatus]
	and a
	jr z, .noTextbox
	bit 7, a
	jr z, .moveTextboxUpwards ; If bit 7 is reset, move upwards
	and $7F
	jr z, .skipSecondDec ; If status = $80, avoid decrementing (otherwise, causes a softlock)
	dec a ; Move downwards 1 pixel
	jr z, .skipSecondDec ; Don't decrement if we reached the bottom
	or $80
	dec a
.skipSecondDec
	ld [wTextboxStatus], a
	and $7F
	jr nz, .displayTextbox
	ld [wTextboxStatus], a ; Clear "closing" bit
	jr .textboxDone
	
.moveTextboxUpwards
	cp TILE_SIZE * 6 + 1 ; If the textbox is fully deployed
	jr z, .displayTextbox
	inc a
	cp TILE_SIZE * 6 + 1
	jr z, .skipSecondInc
	inc a
.skipSecondInc
	ld [wTextboxStatus], a
.displayTextbox
	and $7F
	ld b, a
	ld a, LY_VBLANK
	sub b
	ld [rLYC], a
	
	ld hl, rSTAT
	set 6, [hl]
	jr .textboxDone
	
.noTextbox
	ld hl, rSTAT
	res 6, [hl]
	
.textboxDone
	ld hl, rLCDC
	set 1, [hl]
	
	inc hl ; hl = rLCDC
	set 5, [hl] ; Enable Mode 2 interrupt to schedule music
	; Due to a hardware bug exclusive to the DMG, this immediately schedules a LCD interrupt (but not on the CGB)
	ld l, rIF & $FF
	res 1, [hl] ; Thus, we remove it.
	
	ldh a, [hCurRAMBank] ; Restore WRAM bank
	ld [rSVBK], a
	pop hl
	pop de
	
	
UpdateJoypadState:: ; Initially part of VBlank, but may be used independently
	; Poll joypad
	ldh a, [hHeldButtons]
	cpl
	ld c, a
	ld a, SELECT_DPAD
	call PollJoypad
	cp (((DPAD_DOWN | DPAD_UP) >> 4) ^ $0F) + 1 ; If both Up and Down are held, both bit 2 and 3 will be unset, so the number will be smaller than this constant ($04)
	; This less intuitive check is used because it doesn't modify a, saving some cycles and instructions
	jr nc, .notUpAndDown
	or (DPAD_DOWN | DPAD_UP) >> 4 ; Cancel Up+Down
.notUpAndDown
	ld b, a
	and (DPAD_LEFT | DPAD_RIGHT) >> 4
	jr nz, .notLeftAndRight
	ld a, b
	or (DPAD_LEFT | DPAD_RIGHT) >> 4
	ld b, a
.notLeftAndRight
	swap b
	ld a, SELECT_BUTTONS
	call PollJoypad
	jr nz, .notSoftReset
	ldh a, [hPreventSoftReset]
	and a
	ld a, $0F
	jr nz, .notSoftReset
	ld e, $11
	ldh a, [hConsoleType]
	ld c, a
	cp CONSOLE_GBA
.setGBA
	ld a, $AF
	jr nz, .setGBA + 1 ; Probably the worst hack in this entire game.
	ld b, a
	ld a, c
	cp CONSOLE_GBC
	jp c, Init ; Init with NOT $11 (hConsoleType < CONSOLE_GBC <= $11)
	ld a, $11
	jp Init ; Jump to game init
	
	; Little explanation on the "jr nz, .setGBA" bomb.
	; $AF codes opcode "xor a" (I know it off by heart by this point, FYI), so :
	; 1. The jump won't occur again (since this sets a to 0 and updates the flags)
	; 2. This will reset bit 0 of a (and therefore, bit 0 of b passed to init). $AF has this bit set.
	
.notSoftReset
	or b
	cpl
	ldh [hHeldButtons], a
	and c
	ldh [hPressedButtons], a
	ret
	
PollJoypad::
	ld [rJOYP], a
REPT 3
	ld a, [rJOYP]
ENDR
	and $0F
	ret
	
; Script for OAM DMA wait
; Never run, it's just stored, waiting to be copied to HRAM
DMAScript:
	ld [$FF00+c], a
.waitLoop
	dec b
	jr nz, .waitLoop
	ret
	
	
; Handles all STAT operations
STATHandler::
	bit 2, [hl]
	jr z, .musicTime ; not on LY=LYC
	
	dec hl ; hl = rLCDC
	res 1, [hl] ; Zero OBJ bit
	
	ld l, rWY & $FF
	ld a, [rLY]
;	sub 5  It would be nice if this worked. But it doesn't. Shame.
	ld [hli], a
	ld a, 7
	ld [hl], a
	jr .end
	
.musicTime
	res 5, [hl] ; Disable mode 2 interrupt
	
	ld l, rIF & $FF
	res 1, [hl] ; Remove LCD interrupt, which fis immediately requested on the GB due to a hardware bug
	
	ld a, BANK(DevSound_Play)
	ld [ROMBankLow], a
	ld a, BANK(DSVarsStart)
	ld [rSVBK], a
	call DevSound_Play ; Preserves all registers
	
.end
	; Check the handler's return address
	ld hl, sp+$05
	bit 7, [hl] ; Is that RAM ?
	jr nz, .RAMNotX ; YES ?? OH GOD WHAT THE-
	
	ldh a, [hCurRAMBank]
	push af
	ldh a, [hCurROMBank]
	push af
	
	ld hl, hThread2ID
	ld a, [hl]
	and a
	jr z, .noThread2 ; Don't jump if the index is 0. There's nothing to see there anyways.
	cp THREAD2_MAX
	jr nc, .badThread2 ; Forbid invalid Thread 2 indexes
	dec a ; Indexing thus starts at 1...
	
	push bc
	push de
	
	ld b, a ; Save that index
	ld a, BANK(Thread2Ptrs)
	ld [ROMBankLow], a
	; Read which bank and pointer this is
	ld a, b
	add a, a
;	add a, b  Currently, only 2-byte entries since all Thread 2 functions must be in the same bank as the pointers
	add a, Thread2Ptrs & $FF
	ld l, a
	adc Thread2Ptrs >> 8
	sub l
	ld h, a
;	ld a, [hli] ; Read bank
;	ld b, a
	ld a, [hli] ; Read pointer
	ld h, [hl]
	ld l, a
;	ld a, b
;	ld [ROMBankLow], a
	rst callHL
	
	pop de
	pop bc
	
.noThread2
	
	pop af
	ld [ROMBankLow], a
	pop af
	ld [rSVBK], a
	pop hl
	; Make sure to return during Mode 0 to avoid breaking anything
.waitForMode0
	ld a, [rSTAT]
	and $03
	jr nz, .waitForMode0
	; We wait till next scanline
.waitForMode2
	ld a, [rSTAT]
	and $03
	cp $02
	jr nz, .waitForMode2
	; Then, we delay a bit and hope we land in Mode 0
	; Testing suggested this value of a works about right, even when sprite stalling is at its maximum
	ld a, 16
.waitUntilNextLine
	dec a
	jr nz, .waitUntilNextLine
	pop af
	reti
	
.RAMNotX
	pop hl
	pop af
	jp _AtHL_FatalError
	
.badThread2
	pop de
	pop af
	ld [wSaveA], a
	ld a, ERR_BAD_THREAD2
	jp FatalError

