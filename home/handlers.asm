

SECTION "Interrupt handlers", ROM0

VBlankHandler::
	ld a, [rLY]
	cp LY_VBLANK + 3
	ret nc ; Return if interrupt fires too late, to avoid VBlank-sensitive operations to fail
	; If this return happens, something is wrong for sure, but we won't make it worse
	
	
	push de
	push hl
;	ld a, BANK(wVirtualOAM)
	ld a, 1
	ld [rSVBK], a
	
	
	; Increment frame counter
	; This also means that skipping VBlank interrupt (or triggering it after $90 scanline)
	;   doesn't acknowledge we are on the next frame
	ldh a, [hFrameCounter]
	inc a
	ldh [hFrameCounter], a
	
	
	; Transfer WRAM positions to I/O (hiding window if needed)
	ldh a, [hEnableWindow]
	and a
	ld a, LY_VBLANK
	jr z, .setWY ; Set window to be just under the screen, don't care about WX
	ldh a, [hWX]
	ld [rWX], a
	ldh a, [hWY]
.setWY
	ld [rWY], a
	
	
	ldh a, [hScreenShakeAmplitude]
	and a
	jr z, .dontShakeScreen
	
	ld b, a
	and $80 ; Check if bit 7 is set (its meaning is separate from the amplitude)
	ldh a, [hScreenShakeDisplacement]
	jr nz, .moveLeft ; Bit 7 is set, move left
	inc a
.movementCommon ; Code common to both movements
	ldh [hScreenShakeDisplacement], a
	cp b
	jr nz, .dontShakeScreen ; We didn't reach the edge of the displacement
	ld a, b ; Retrieve amplitude
	cpl ; Negate amplitude
	inc a
	ldh [hScreenShakeAmplitude], a
	jr .capAtAmplitude
; The placement of this piece of code can seem strange,
; but it is placed at a point that wouldn't be traversed otherwise.
; So this avoids doing a jr after the inc a above, saving some bytes and CPU cycles.
.moveLeft
	dec a
	jr .movementCommon
.dontShakeScreen
	ldh [hScreenShakeDisplacement], a ; Avoid displacement carry-over (zeroing amplitude when displacement is non-zero then setting amplitude again)
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
	ldh a, [hSCY]
	ld [rSCY], a
	ldh a, [hSCX]
.transferScroll
	add a, b
	ld [rSCX], a
	
	
	; Transfer fixed map
	ld bc, wTransferRows
	ld d, wTextboxTileMap - wTransferRows
	; We will look for any updated rows
.fixedMapTransferLoop
	ld a, [bc]
	and a
	jr nz, .rowUpdated
	inc c ; Check next row
	dec d
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
	
	; OAM operations follow.
	; First, transfer virtual OAM into staged OAM
	ld hl, wNumOfSprites
	ld a, [hl] ; Get number of sprites
	cp NB_OF_SPRITES + 1 ; Make sure this number is valid
	jr c, .numberOfSpritesValid
	ld a, NB_OF_SPRITES ; This should never be reached, but... it might!
	ld [hl], a
.numberOfSpritesValid
	ld b, a ; Save the number of main sprites
	add a, a
	add a, a
	ld c, a
	inc hl
	ld a, [hl] ; Get previous count
	ld [hl], b ; Store current count
	sub b ; Calc diff
	jr c, .doneClearingOAM
	jr z, .doneClearingOAM
	ld h, HIGH(wVirtualOAM)
	ld l, c
.clearSprites
	ld [hl], 0
REPT 4
	inc l
ENDR
	dec a
	jr nz, .clearSprites
	
.doneClearingOAM
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
	cp $C9 ; Copied the RET?
	jr nz, .copyDMARoutine
	; b's value was determined through testing...
	; less means returning before the CPU has access (crash),
	; and more means CPU time is wasted
	ld bc, (41 << 8) + (rDMA & $FF)
	ldh a, [hOAMMode]
	and a
	ld a, HIGH(wVirtualOAM)
	jr z, .transferMainOAM
	xor a
	ldh [hOAMMode], a
	ld a, HIGH(wStagedOAM)
.transferMainOAM
	call hDMAScript
	
.dontTransferSprites
	
	
	ld a, [wTextboxStatus]
	and a
	jr z, .noTextbox
	ld b, TEXTBOX_MOVEMENT_SPEED
	bit 7, a
	jr z, .moveTextboxUpwards ; If bit 7 is reset, move upwards
	and $7F
	jr z, .doneDecrementing ; If status = $80, avoid decrementing (otherwise, causes a softlock)
.keepDecrementing
	dec a ; Move downwards 1 pixel
	jr z, .doneDecrementing ; Don't decrement if we reached the bottom
	dec b
	jr nz, .keepDecrementing
	or $80
	dec a
	ld [wTextboxStatus], a
	and $7F
	jr nz, .displayTextbox
.doneDecrementing
	ld [wTextboxStatus], a ; Clear "closing" bit
	jr .noTextbox
	
.moveTextboxUpwards
	cp TILE_SIZE * 6 + 1 ; If the textbox is fully deployed
	jr z, .displayTextbox
.keepIncrementing
	inc a
	cp TILE_SIZE * 6 + 1
	jr z, .doneIncrementing
	dec b
	jr nz, .keepIncrementing
.doneIncrementing
	ld [wTextboxStatus], a
.displayTextbox
	and $7F
	ld b, a
	ld a, LY_VBLANK
	sub b
	ldh [hTextboxLY], a
	ld [rLYC], a
	
	ld hl, rSTAT
	set 6, [hl]
	jr .textboxDone
	
.noTextbox
	dec a
	ldh [hTextboxLY], a
	ld hl, rSTAT
	res 6, [hl]
	
.textboxDone
	dec hl ; ld hl, rLCDC
	set 1, [hl]
	
	inc hl ; hl = rSTAT
	set 5, [hl] ; Enable Mode 2 interrupt to schedule music
	
	ldh a, [hSpecialEffectsLY]
	and a
	jr z, .noSpecialEffects
	bit 6, [hl] ; Check if textbox LYC is active
	jr z, .enableSpecialEffects ; If not, enable
	; If the effect's line is "in" the textbox, it has priority => don't
	; So, don't trigger if FX >= text => text-FX <= 0 => text-1-FX < 0
	ld e, a
	ldh a, [hTextboxLY]
	dec a
	cp e
	jr c, .noSpecialEffects
	ld a, e ; Get back special FX LY
.enableSpecialEffects
	set 6, [hl]
	ld [rLYC], a
.noSpecialEffects
	
	; Due to a hardware bug exclusive to the DMG, editing STAT immediately schedules a LCD interrupt (but not on the CGB)
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
	ld hl, rSTAT
	; a = [rSTAT]
	bit 2, a
	jr z, .musicTime ; not on LY=LYC
	
	; LY=LYC : check if it's textbox or special effects time
	ld a, [rLYC]
	ld h, a
	ldh a, [hTextboxLY]
	cp h
	ld h, $FF
	jr z, .waitHBlank ; If we're on the textbox's LY, it has priority
	
	; Then we have to perform a special effect
	push bc
	ld l, LOW(hSpecialEffectsBuf)
	; Wait until HBlank so the effect won't nuke the current line
	ld a, [hli] ; Get target
	and a
	jr z, .doneWithEffects
	dec a
	and 9
	add LOW(rSCY)
	ld c, a ; Get target in HRAM
	ld a, [hli] ; Read value
	ld [c], a ; Write
.doneWithEffects
	ldh a, [hTextboxLY] ; Make sure the textbox will render afterwards
	ld [rLYC], a ; (the value is $FF is the textbox is de-activated, so no prob')
	pop bc
	ld hl, rSTAT
	ld a, [rLY]
	cp $8F
	jr .endMode2
	
.waitHBlank
	bit 1, [hl]
	jr nz, .waitHBlank
	
	dec hl ; ld hl, rLCDC
	res 1, [hl] ; Zero OBJ bit
	set 3, [hl] ; Switch to textbox's tilemap
	
	ld l, rSCX & $FF
	xor a
	ld [hld], a ; Stick to left edge, go to rSCY
	dec a
	ld [rWX], a ; Put window off-screen
	ld a, [rLY]
	cpl
	ld [hli], a
	cp $8F ^ $FF ; Check if we were on last scanline ; if yes, we need to return quickly (VBlank is incoming)
.endMode2
	jp nz, .end
	pop hl
	pop af
	reti
	
.musicTime
	res 5, [hl] ; Disable mode 2 interrupt
	
	ld l, rIF & $FF
	res 1, [hl] ; Remove LCD interrupt, which is immediately requested on the GB due to a hardware bug
	
	ldh a, [hHDMAInUse]
	and a
	jr z, .HDMAInactive
	; The transfer may be "reserved" but not started (if the parameters are being written, for example)
	ld a, [rHDMA5]
	inc a ; Is the transfer active ?
	jr z, .HDMAInactive
	dec a ; The transfer is active, thus, it must be stopped
	ld [rHDMA5], a ; Write a value with bit 7 reset, which stops the transfer
	db $21 ; Absorbs the next two bytes, which trashes hl but we don't care
.HDMAInactive
	ld a, $FF
	ldh [hHDMALength], a
	
	ld a, BANK(DevSound_Play)
	ld [ROMBankLow], a
	ld a, BANK(DSVarsStart)
	ld [rSVBK], a
	
	
	ld hl, wNumOfTileAnims
	ld a, [hli]
	and a
	jp z, .noAnimators
	push de
	push bc
	ld b, a
	
	ld a, [rVBK] ; Save VRAM bank
	push af
.runAnimator
	ld a, [hl] ; Get current frame
	inc a ; Increment
	ld [hli], a
	sub [hl] ; Try subtracting the max frame
	jr c, .dontAnim ; If current < max, don't animate
	
	dec hl
	ld [hli], a ; Write back (current - max)
	inc hl
	ld a, [hli] ; Get current anim frame
	inc a ; Advance
.getFrame
	sub [hl]
	jr nc, .getFrame
	add [hl] ; Get modulo
	dec hl
	ld [hli], a ; Write back
	inc hl
	ld d, a ; Store this
	swap d
	
	ld a, [hli] ; Get tile ID
	ld e, a ; Store this
	res 7, e ; We're editing tiles $80-$FF, sure, but we'll transpose to $00-$7F for simplicity.
	swap e
	; Calculate target VRAM bank :
	; If tile ID < $80  (VRAM bank 0) : MSB = 0 -> Carry = 0 -> Carry = 1 -> a = $FF -> a = $00
	; If tile ID >= $80 (VRAM bank 1) : MSB = 1 -> Carry = 1 -> Carry = 0 -> a = $00 -> a = $01
	rlca ; Get MSB in carry
	ccf ; Complement it
	sbc a, a ; Perform ASM magic
	inc a
	ld [rVBK], a ; Switch to copy's dest bank
	
	; Check is HDMA is currently in use
	ldh a, [hHDMAInUse]
	and a
	jr nz, .useStandardCopy
	
	inc a
	ldh [hHDMAInUse], a
	
	ld c, rHDMA1 & $FF
	; Write copy's source pointer
	ld a, d ; Get back swap'd frame
	and $0F
	add a, [hl] ; Add base pointer's high byte
	inc hl
	ld [$FF00+c], a ; rHDMA1
	inc c
	ld a, d
	and $F0
	add a, [hl] ; Add base pointer's low byte
	ld [$FF00+c], a ; rHDMA2
	inc c
	
	ld a, e
	and $0F
	add a, v0Tiles1 >> 8
	ld [$FF00+c], a ; rHDMA3
	inc c
	ld a, e
	and $F0
;	add a, v0Tiles1 & $FF ; This is $00
	ld [$FF00+c], a ; rHDMA4
	inc c
	
	; Switch to copy's source bank
	ld a, BANK(wTileFrames)
	ld [rSVBK], a
	
	; Transfer 16 bytes (one tile) via HDMA, assuming it will be over by next animator
	ld a, $80
	ld [$FF00+c], a ; rHDMA5
	
	; Wait until rHDMA5 reads $FF, ie. transfer has completed.
.waitTransferDone
	ld a, [$FF00+c]
	inc a
	jr nz, .waitTransferDone
	; xor a
	ldh [hHDMAInUse], a
	jr .doneAnimating
	
.useStandardCopy
	push hl
	ld a, d
	and $0F
	add a, [hl]
	inc hl
	ld c, a
	ld a, d
	and $F0
	add a, [hl]
	ld l, a
	ld h, c
	
	ld a, e
	and $0F
	add a, v0Tiles1 >> 8
	ld d, a
	ld a, e
	and $F0
	ld e, a
	
	ld a, BANK(wTileFrames)
	ld [rSVBK], a
	
	ld c, VRAM_TILE_SIZE
	call CopyToVRAMLite
	pop hl
	
.doneAnimating
	
	ld a, 1
	ld [rSVBK], a ; Restore WRAM bank.
	
.dontAnim
	ld a, l
	and $F8
	add a, wTileAnim1_frameCount - wTileAnim0_frameCount
	ld l, a ; Can't overflow
	dec b
	jp nz, .runAnimator
	pop af
	ld [rVBK], a ; Restore VRAM bank
	pop bc
	pop de
.noAnimators
	call DevSound_Play ; Preserves all registers
	
	ldh a, [hCurRAMBank]
	push af
	ldh a, [hCurROMBank]
	push af
	
	ld hl, hThread2ID
	ld a, [hl]
	and a
	jr z, .noThread2 ; Don't jump if the index is 0. There's nothing to see there anyways.
IF !DEF(GlitchMaps)
	cp THREAD2_MAX
	jr nc, .badThread2 ; Forbid invalid Thread 2 indexes
ENDC
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
	
	ldh a, [hHDMALength] ; Check if HDMA was active
	inc a
	jr z, .end
	dec a ; If so, restart it
	or $80
	ld l, a ; Save this
.waitHDMAHBlank ; HDMA shouldn't be started during Mode 0, so wait until it's the beginning of Mode 3
	ld a, [rSTAT]
	and 3
	jr nz, .waitHDMAHBlank
.waitNotHBlank
	ld a, [rSTAT]
	and 3
	jr z, .waitNotHBlank
	ld a, l ; Get back length
	ld [rHDMA5], a
	
	
.end

IF !DEF(GlitchMaps)
	; Check the handler's return address
	ld hl, sp+$05
	bit 7, [hl] ; Is that RAM?
	jr nz, .RAMNotX ; YES?? OH GOD WHAT THE-
ENDC
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

