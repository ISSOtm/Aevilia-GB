
HIGHLIGHT_LENGTH equ 14
	
SECTION "File select", ROMX,ALIGN[4]
	
FileSelectHeights::
	db $7C, $7C, $7D, $7E, $7F, $80, $81, $82
	db $82, $82, $82, $81, $80, $7F, $7E, $7D

FileSelectHighlight::
	ld b, 3
.highlightLoop
	ld c, HIGHLIGHT_LENGTH
	call FillVRAMLite
	ld de, VRAM_ROW_SIZE - HIGHLIGHT_LENGTH
	add hl, de
	dec b
	jr nz, .highlightLoop
	ret
	
FileSelectOptionStrings::
	dstr "MANAGE FILES"
	dstr "COPY FILE..."
	dstr "ERASE FILE..."
	
FileSelectOptions::
	ld a, 1
	ld [wTextboxStatus], a
	ld [rVBK], a
	
	ld hl, $9C00
	ld c, $20
	ld a, $40
	call FillVRAMLite
	ld c, $20
	xor a
	call FillVRAMLite
	
	ld c, 14
	ld a, $42
	call FillVRAMLite
	
	ld a, 1
	ld bc, $186
	call FillVRAM
	
	xor a
	ld [rVBK], a
	
	ld hl, $9C00
	ld c, $20
	ld a, "_"
	call FillVRAMLite
	xor a
	ld c, $21
	call FillVRAMLite
	ld c, 13
	ld a, "_"
	call FillVRAMLite
	xor a
	ld bc, $122
	call FillVRAM
	
	ld hl, FileSelectOptionStrings
	ld de, $9C21
	call CopyStrToVRAM
	ld e, $84
	call CopyStrToVRAM
	ld e, $C4
	call CopyStrToVRAM
	
	ld hl, wTextboxStatus
.waitTextboxRose
	rst waitVBlank
	ld a, [hl]
	cp $31
	jr nz, .waitTextboxRose
	inc [hl] ; Go past the window's normal boundary, which will make it continue rising
	
	ld hl, wVirtualOAM
	ld a, $50
	ld [hli], a
	ld a, $48
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld [hl], a
	
	ld a, $1E
	ldh [hWY], a
	ld a, 7
	ldh [hWX], a
	
	; Perform rest of scrolling animation
.scrollingLoop
	rst waitVBlank
	ld a, [wTextboxStatus]
	cp TILE_SIZE * 14
	jr c, .scrollingLoop
	
	; Keeping using the textbox system would require constantly overwriting wTextboxStatus,
	; so instead we just move the window normally
	; Besides, the textbox disables sprites, and we need one.
	xor a ; Disable textbox trickery
	ld [wTextboxStatus], a
	inc a ; ld a, 1
	ldh [hEnableWindow], a
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	
	ld hl, CursorTile
	ld de, $8010
	ld bc, VRAM_TILE_SIZE
	ld a, BANK(CursorTile)
	call CopyAcrossToVRAM
	
	ld a, $40
	ld [wYPos], a
	ld [wXPos], a
	
	; Clear the area under the window
	xor a
	ld hl, $98C0
	ld bc, 14 * VRAM_ROW_SIZE
	call FillVRAM
	; Returns with a = 0 !
	inc a ; ld a, 1
	ld [rVBK], a
	ld hl, $98C0
	ld bc, 14 * VRAM_ROW_SIZE
	call FillVRAM
	xor a
	ld [rVBK], a
	
	ld bc, 10
	call DelayBCFrames
	
.mainloop
	rst waitVBlank
	ldh a, [hPressedButtons]
	ld b, a
	and $06
	jp nz, FileSelectOptionsEnd
	
	ldh a, [hHeldButtons]
	and $F0
	jr z, .dontMove
	
	; Use keys to move sprite on-screen
	rlca
	jr nc, .notDown
	rlca
	ld c, a
	ld a, [wYPos]
	cp $8F
	jr z, .noVertMovement
	inc a
	ld [wYPos], a
	jr .noVertMovement
.notDown
	rlca
	jr nc, .noVertMovement + 1
	ld c, a
	ld a, [wYPos]
	and a
	jr z, .noVertMovement
	dec a
	ld [wYPos], a
.noVertMovement
	ld a, c
	rlca
	jr nc, .noLeft
	ld a, [wXPos]
	and a
	jr z, .noHorizMovement
	dec a
	ld [wXPos], a
	jr .noHorizMovement
.noLeft
	rlca
	jr nc, .noHorizMovement
	ld a, [wXPos]
	cp $9F
	jr z, .noHorizMovement
	inc a
	ld [wXPos], a
	
.noHorizMovement
	ld hl, wVirtualOAM
	ld a, [wYPos]
	add a, $10
	ld [hli], a
	ld a, [wXPos]
	add a, 8
	ld [hl], a
	
	ld a, 1
	ld [wTransferSprites], a
	
.dontMove
	bit 0, b
	jr z, .mainloop
	
	; Perform A button action depending on position
	ld a, [wYPos]
	cp $3B
	jr c, .mainloop
	cp $58
	jr nc, .mainloop
	ld b, a
	
	; This may be either "Copy file" or "Erase file"
	ld a, [wXPos]
	cp $1C
	jr c, .mainloop
	cp $85
	jr nc, .mainloop
	
	; This is either "Copy" or "Erase"
	; Perform common operations
	xor a
	ld [wXPos + 1], a
	ld [wNumOfSprites], a
	dec a ; ld a, $FF
	ld [wTransferSprites], a
	ld de, $9922
	ld [de], a
	inc de
	ld hl, FileIDsStr
	call CopyStrToVRAM
	
	ld de, $9901
	
	; Determine which one has been selected
	ld a, b
	cp $4B
	jp c, FileSelectOptions_Copy
	
FileSelectOptions_Erase:
	ld hl, EraseWhichFileStr
	call CopyStrToVRAM
	
	ld c, LOW(hWY)
.moveWindowDown
	rst waitVBlank
	ld a, [c]
	inc a
	inc a
	ld [c], a
	cp $60
	jr nz, .moveWindowDown
	
	ld hl, $9922
.mainloop
	rst waitVBlank
	ldh a, [hPressedButtons]
	bit 1, a ; B
	jr nz, .done
	ld c, a ; Save keys
.waitVRAM1
	rst isVRAMOpen
	jr nz, .waitVRAM1
	ld [hl], 0
	bit 5, c
	jr nz, .left
	bit 4, c
	jr z, .dontmove
	; Go right
	ld a, l
	add a, 3
	cp $22 + 9
	jr nz, .moved
	ld a, $22
	jr .moved
	
.left
	ld a, l
	cp $22
	jr nz, .noleftwrap
	ld a, $22 + 9
.noleftwrap
	sub a, 3
	
.moved
	ld l, a
.dontmove
.waitVRAM2
	rst isVRAMOpen
	jr nz, .waitVRAM2
	ld [hl], $7F
	
	ld a, c
	and $0D
	jr z, .mainloop
	
	push hl
	ld c, BANK(ConfirmDeletionText)
	ld de, ConfirmDeletionText
	callacross ProcessText_Hook
	ld hl, wTextFlags
	bit 4, [hl] ; Will be set if the first option has been selected
	pop hl
	jr nz, .done
	; So, it's time to erase the file, huh.
	ld a, l
	sub $22
	jr z, .gotDaID
	; 03 or 06
	dec a ; 02 or 05
	rrca ; 01 or 02!
.gotDaID
	add a, sNonVoidSaveFiles & $FF
	ld l, a
	ld h, sNonVoidSaveFiles >> 8
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ld a, BANK(sNonVoidSaveFiles)
	ld [SRAMBank], a
	ld [hl], 0 ; Mark save file as empty
	xor a
	ld [SRAMBank], a
	ld [SRAMEnable], a
	
.done
	jp FileSelectOptions
	
FileSelectOptions_Copy:
	ld hl, CopyWhichFileStr
	call CopyStrToVRAM
	
	ld c, LOW(hWY)
.moveWindowDown
	rst waitVBlank
	ld a, [c]
	inc a
	inc a
	ld [c], a
	cp $60
	jr nz, .moveWindowDown
	
	ld hl, $9922
.mainloop
	rst waitVBlank
	ldh a, [hPressedButtons]
	bit 1, a ; B
	jr nz, .done
	ld c, a ; Save keys
.waitVRAM1
	rst isVRAMOpen
	jr nz, .waitVRAM1
	ld [hl], 0
	bit 5, c
	jr nz, .left
	bit 4, c
	jr z, .dontmove
	; Go right
	ld a, l
	add a, 3
	cp $22 + 9
	jr nz, .moved
	ld a, $22
	jr .moved
	
.left
	ld a, l
	cp $22
	jr nz, .noleftwrap
	ld a, $22 + 9
.noleftwrap
	sub a, 3
	
.moved
	ld l, a
.dontmove
.waitVRAM2
	rst isVRAMOpen
	jr nz, .waitVRAM2
	ld [hl], $7F
	
	ld a, c
	and $0D
	jr z, .mainloop
	
	push hl
	ld c, BANK(ConfirmCopyText)
	ld de, ConfirmCopyText
	xor a
	ldh [hEnableWindow], a
	callacross ProcessText_Hook
	ld hl, wTextFlags
	bit 4, [hl] ; Will be set if the first option has been selected
	pop hl
	jr nz, .done
	; So, it's time to erase the file, huh.
	ld a, l
	sub $22
	jr z, .gotDaID
	; 03 or 06
	dec a ; 02 or 05
	rrca ; 01 or 02!
.gotDaID
	add a, sNonVoidSaveFiles & $FF
	ld l, a
	ld h, sNonVoidSaveFiles >> 8
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ld a, BANK(sNonVoidSaveFiles)
	ld [SRAMBank], a
	ld [hl], 0 ; Mark save file as empty
	xor a
	ld [SRAMBank], a
	ld [SRAMEnable], a
	
.done
	jp FileSelectOptions
	
	
FileSelectOptionsEnd:
DrawFileSelect::
	; Clean up
	ld c, $81
	callacross LoadFont
	ld c, 0
	callacross LoadFont
	ld a, 1
	ld [rVBK], a
	ld hl, vAttrMap0
	ld bc, VRAM_ROW_SIZE * (SCREEN_HEIGHT + 5)
	call FillVRAM
	xor a
	ld [rVBK], a
	ld hl, v0Tiles2
	ld c, VRAM_TILE_SIZE
	call FillVRAMLite
	ld hl, vTileMap0
	ld bc, VRAM_ROW_SIZE * (SCREEN_HEIGHT + 5)
	call FillVRAM
	; Redraw "Aevilia GB" string
	; Do last to avoid displaying anything
	ld c, 0
	ld de, GrayPalette
	callacross LoadBGPalette_Hook
	ld c, 1
	ld de, DefaultPalette
	callacross LoadBGPalette_Hook
	
	xor a
	ld [wSaveA], a ; Reset Konami cheat
	
	ld a, $10
	ldh [hSCY], a
	
	ld de, InvertedPalette + 3
	ld c, 0
	callacross LoadOBJPalette_Hook ; Load the palette for the sprites
	
	; Print the "save file" texts
	ld de, $9904
	ldh a, [hSRAM32kCompat]
	and a
	jr z, .printSaveFiles
	
	; SRAM32k has only one file
	inc de
	ld hl, SaveFileStr
	call CopyStrToVRAM
	jr .donePrinting
	
.printSaveFiles
	ld bc, (3 << 8) | "1"
.printSaveFilesLoop
	ld hl, SaveFileStr
	call CopyStrToVRAM
.printIDWaitLoop
	rst isVRAMOpen
	jr nz, .printIDWaitLoop
	ld a, c ; Write ID
	ld [de], a
	inc c
	
	ld hl, $55 ; Offset from one ID to the next start (3 lines - 11 chars)
	add hl, de
	ld d, h
	ld e, l
	
	dec b
	jr nz, .printSaveFilesLoop
.donePrinting

	ldh a, [hEnableWindow]
	and a
	jr z, .optionsNotShown
	xor a
	ldh [hEnableWindow], a ; Disable "normal" window
	ld [wNumOfSprites], a
	ld a, $F6
	ld [wTextboxStatus], a ; Make window begin its descent, the rest will be handled automatically.
	ld [wTransferSprites], a
	rst waitVBlank
.optionsNotShown
	
	; Copy tile used for corners
	ld hl, SaveFileCornerTile
	ld de, vFileSelectCornerTile
	ld bc, 16
	call CopyToVRAM
	
	; Copy sprites to virtual OAM
	; hl is correctly positioned
	ld de, wVirtualOAM
	ld c, 4 * (4 + 9)
	rst copy
	
	; Transfer sprites
	ld a, 4 + 9
	ld [wNumOfSprites], a
	ld [wTransferSprites], a
	
	; Draw the console strings on-screen
	ldh a, [hConsoleType]
	add a, a
	ld hl, ConsoleTypes
	add a, l ; Assumed not to overflow (if needed move the pointer array around)
	ld l, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $9A24
	call CopyStrToVRAM
	ld de, $9A45
	call CopyStrToVRAM
	
	ld a, 1
	ld [rVBK], a ; Load VRAM bank 1
	
	; Highlight first save file
	xor a
	ld hl, $98E3
	call FileSelectHighlight
	
	; Make both console lines black instead of grey
	ld hl, $9A24
	ld a, 2
	ld c, $30
	call FillVRAMLite
	
	ld c, a ; ld c, 2
	ld de, DarkTextPalette
	callacross LoadBGPalette_Hook
	
	; Zero cursor position
	xor a
	ld [wYPos], a
	ldh [hFrameCounter], a
	
	; Wait until the options window (managed by the textbox code at this point) is down to avoid gfx issues
.waitTextboxDown
	ld a, [wTextboxStatus]
	and a
	jr nz, .waitTextboxDown
	
	ldh a, [hSRAM32kCompat]
	and a
	jr z, SelectFile ; Don't display the text if this isn't SRAM32k
	
	; Display the message only at first boot
	ld a, BANK(sSRAM32kMessageDisplayed)
	ld [SRAMBank], a
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ld hl, sSRAM32kMessageDisplayed
	ld a, [hl]
	and a
	ld [hl], 1
	ld a, 0
	ld [SRAMEnable], a
	ld [SRAMBank], a
	jr nz, SelectFile
	
	ldh a, [hHeldButtons] ; Skip the message if Select and B are held
	cp DPAD_UP | BUTTON_B | BUTTON_A
	jr z, SelectFile
	
	ld c, BANK(CompatExplanationText)
	ld de, CompatExplanationText
	callacross ProcessText_Hook
	
	
SelectFile:
	; Move console up and down
	ldh a, [hFrameCounter]
	rrca
	rrca
	rrca
	and $0F
	ld hl, FileSelectHeights
	add a, l
	ld l, a
	ld a, [hl]
	ld hl, wVirtualOAM + 4 * 4
	ld b, 3
.moveSpritesLoop
	ld c, 3
.moveColumnLoop
	ld [hli], a
	inc hl
	inc hl
	inc hl
	add a, 8
	dec c
	jr nz, .moveColumnLoop
	sub $18
	dec b
	jr nz, .moveSpritesLoop
	ld a, 1
	ld [wTransferSprites], a ; Schedule transfer
	
	rst waitVBlank
	ldh a, [hPressedButtons]
	ld b, a
	; In SRAM32k mode, only thing you're allowed to do is load the file.
	ldh a, [hSRAM32kCompat]
	and a
	ld a, b
	jr z, .notCompat
	and $0D ; Only allow A, SELECT and START
	; This prevents moving, acessing options, and outright performing the Konami Code (only the last input can be performed...)
.notCompat
	and a
	jr z, SelectFile ; Skip everything if no button is pressed
	
	and $04 ; Filter SELECT button
	jp nz, FileSelectOptions
	
	ld a, [wSaveA]
	ld d, KonamiCheatKeys >> 8
	ld e, a
	ld a, [de] ; Get expected button
	cp b
	ld a, 0 ; Reset cheat if incorrect button
	jr nz, .noCheat
	ld a, e
	inc a
.noCheat
	ld [wSaveA], a
	
	ld a, b ; Restore keys
	and $C0 ; Filter next keys
	jr z, .noScreenUpdate
	
	push af
	; Clear currently highlighted file
	ld hl, $98E3
	ld a, [wYPos]
	ld b, a
	add a, a
	add a, b ; *3
	swap a ; *16
	add a, a
	jr nc, .noCarry1
	inc h
.noCarry1
	add a, l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
	ld a, 1
	call FileSelectHighlight
	
	pop bc
.moveAgain
	ld a, b
	rlca
	ld a, [wYPos]
	jr nc, .moveUp
	inc a
	inc a
.moveUp
	dec a
	and 3
	ld [wYPos], a
	cp 3
	jr z, .moveAgain
	
.moved
	
	; Highlight new file
	ld hl, $98E3
	ld b, a
	add a, a
	add a, b ; *3
	ld b, a
	swap a ; *16
	add a, a
	jr nc, .noCarry3
	inc h
.noCarry3
	add a, l
	ld l, a
	jr nc, .noCarry4
	inc h
.noCarry4
	ld a, b
	add a, a
	add a, a
	add a, a
	add a, $38
	ld [wVirtualOAM], a
	ld [wVirtualOAM + 4], a
	add a, 16
	ld [wVirtualOAM + 8], a
	ld [wVirtualOAM + 12], a
	ld a, 1
	ld [wTransferSprites], a
	rst waitVBlank
	xor a
	call FileSelectHighlight
	
	; Play a little SFX (also served as a test)
	push bc
	ld	c,SFX_TEXT_SELECT
	callacross	FXHammer_Trig
	pop	bc
	
.noScreenUpdate
	ld a, b
	and $09
	jp z, SelectFile ; Too far
	
FileSelected:

	xor a
	ld [wNumOfSprites], a
	inc a
	ld [wTransferSprites], a
	
	; A file has been selected!
	
	rst waitVBlank
	ld a, 1
	ld [rVBK], a
	ld hl, $98E3
	ld c, $AE
	call FillVRAMLite
	ld l, $A3
	ld c, $AE
	call FillVRAMLite
	
	xor a
	ld [rVBK], a
	ld hl, $9865
	ld c, 10
	call FillVRAMLite
	
	; a = 0
	ld hl, $9A24
	ld c, $30
	call FillVRAMLite
	
	ld hl, $9904
	ld a, [wSaveA]
	cp 10
	jr z, .konamiCheatOn ; Put an absurd number instead
	ld a, [wYPos]
.konamiCheatOn
	ld e, a
	inc e
	ld b, 3
.clearFilesLoop
	dec e
	jr z, .skipThisFile
	xor a
	ld c, 12
	call FillVRAMLite
.skipThisFile
	ld a, l
	and $E0
	add a, $64
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	dec b
	jr nz, .clearFilesLoop
	
	ld a, [wSaveA] ; Check Konami cheat progression
	cp 10
	jr nz, .notKonamiCode
	
	ld hl, DLCName
	ld de, $9866
	call CopyStrToVRAM
	
	ld hl, DLCUnavailableText
	ret
	
.notKonamiCode
	xor a
	ld [wSaveA], a ; Clear Konami cheat
	
	; Scroll text in the right place
	; Don't ask how it works. I made it a bit... randomly.
REPT 3
	inc e
ENDR
	ld b, (8 * 3) * 2 + 1
	xor a
	ldh [hFrameCounter], a
.scrollLoop
	rst waitVBlank
	dec b
	jr z, .loadFile
	ldh a, [hFrameCounter]
	and 3
	sub e
	jr nc, .scrollLoop
	ldh a, [hSCY]
	inc a
	inc a
	ldh [hSCY], a
	jr .scrollLoop
	
.loadFile
	ld a, BANK(sNonVoidSaveFiles)
	ld [SRAMBank], a
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ld hl, sNonVoidSaveFiles - 1
	ld a, l
	add a, e ; Get file's voidness ptr in array
	ld l, a
	ld a, [hl] ; Get voidness
	and a ; Check if void
	ld a, e ; Get back file ID
	ld [wSaveFileID], a ; Store it
	ld hl, EmptyFileText
	ret z ; It's void
	
	ldh a, [hSRAM32kCompat]
	and a
	jr z, .notSRAM32k
	ld a, 2
	jr .gotBank
.notSRAM32k
	ld a, e
	add a, a ; Still equals file ID
	add a, a
.gotBank
	call VerifyChecksums
	jr nz, .fileValid
	ld a, 1 ; Let the loader know the file is corrupted
	ld [wSaveA], a
	
	ldh a, [hSRAM32kCompat]
	and a
	ld hl, CorruptedFileText
	ret z
	ld hl, CompatFileCorruptedText ; SRAM32k doesn't have backups, thus uses a different text
	ret
	
.fileValid
	ld hl, ConfirmLoadText
	ret
	
; Call with a = 1st bank of save file
; Returns a = 0 if file invalid (also Z set)
; Otherwise file is valid
VerifyChecksums::
	ld c, a ; Save that bank
	ld [SRAMBank], a ; Set SRAM bank
	
	; Calculate save file #e's validity
	ld hl, sFile1MagicString0
	ld de, MagicString
.compareMagicStrings
	ld a, [de]
	and a ; If we reached the end of the magic string
	jr z, .checkVersion
	inc de
	cp [hl]
	jr nz, .endTests
	inc hl
	jr .compareMagicStrings
	
.checkVersion
	ld a, [ROMVersion]
	cp [hl]
	jr nz, .endTests
	
	ld a, c ; Get back bank
.calcOneBankSums
	ld [SRAMBank], a
	push af
	ld hl, sFile1Data0Start
	ld de, sFile1Checksums0
.nextBlock
	ld bc, 0
.checksumOneBlock
	ld a, [hl]
	add a, b
	rrca ; Add in a little bit of asymmetry...
	ld b, a
	ld a, [hli]
	xor c
	rlca
	ld c, a
	ld a, l
	and $3F
	jr nz, .checksumOneBlock
	
	ld a, [de]
	cp b
	jr nz, .popAndEndTests
	inc de
	ld a, [de]
	cp c
	jr nz, .popAndEndTests
	inc de
	
	ld a, e
	and a
	jr nz, .nextBlock
	
	pop af
	inc a
	bit 1, a
	jr nz, .calcOneBankSums
	
	and a ; Should be non-zero
	ret
	
.popAndEndTests
	pop af
.endTests
	xor a
	ret
	
	
SaveFileCornerTile::
	dw $F0F0, $C0C0, $8080, $8080, $0000, $0000, $0000, $0000
	; These two must follow each other!
SaveFileSprites::
	dspr 40, 24 , 1, $00
	dspr 40, 128, 1, $20
	dspr 56, 24 , 1, $40
	dspr 56, 128, 1, $60
	
	dspr $70,  2,  2, 1
	dspr $78,  2,  3, 1
	dspr $80,  2,  4, 1
	dspr $70, 10,  5, 1
	dspr $78, 10,  6, 1
	dspr $80, 10,  7, 1
	dspr $70, 18,  8, 1
	dspr $78, 18,  9, 1
	dspr $80, 18, 10, 1
	
ConsoleTypes::
	dw .crap
	dw .vc
	dw .decent
	dw .gbc
	dw .gba
	
.crap
	dstr "EMULATOR:"
	dstr "CRAP"
.vc
	dstr "CONSOLE:"
	dstr "3DS"
.decent
	dstr "EMULATOR:"
	dstr "DECENT"
.gbc
	dstr "CONSOLE:"
	dstr "GBC"
.gba
	dstr "CONSOLE:"
	dstr "GBA"
	
; DO NOT CHANGE THE LENGTH OF THIS STRING
; Also make sure it matches `DefaultSaveMagicString0/1`
MagicString::
	dstr "Aevilia"
	
SaveFileStr::
	dstr "Save file "
	
EraseWhichFileStr::
	dstr "ERASE WHICH FILE?"
	
CopyWhichFileStr::
	dstr "COPY WHICH FILE?"
	
FileIDsStr::
	dstr "1  2  3"
	
	
SECTION "File select text", ROMX

CompatExplanationText::
	print_name TechCrewName
	print_line .line0
	print_line .line1
	print_line .line2
	wait_user
	print_line .line3
	print_line .line4
	print_line .line5
	wait_user
	clear_box
	print_line .line6
	print_line .line7
	delay 30
	print_line .line8
	wait_user
	clear_box
	print_line .line9
	wait_user
	print_line .line10
	print_line .line11
	delay 120
	print_line .line12
	wait_user
	clear_box
	print_line .line13
	print_line .line14
	print_line .line15
	wait_user
	print_line .line16
	print_line .line17
	print_line .line18
	wait_user
	clear_box
	print_line .line19
	delay 60
	print_line .line20
	print_line .line21
	delay 120
	wait_user
	clear_box
	print_line .line22
	print_line .line23
	wait_user
	print_line .line24
	print_line .line25
	wait_user
	print_line .line26
	print_line .line27
	wait_user
	clear_box
	print_line .line28
	print_line .line29
	print_line .line30
	wait_user
	clear_box
	print_line .line31
	print_line .line32
	wait_user
	done
	
.line0
	dstr "You may notice"
.line1
	dstr "there's only 1"
.line2
	db "save file,",0
.line3
	dstr "out of the 3"
.line4
	dstr "promised on the"
.line5
	dstr "tin."
.line6
	dstr "You might be"
.line7
	dstr "wondering:"
.line8
	dstr "Why?"
.line9
	dstr "Because"
.line10
	dstr "THERE CAN BE ONLY"
.line11
	dstr "ONE..."
.line12
	dstr "save file."
.line13
	db "Nah,"
	dstr " actually your"
.line14
	dstr "emulator is having"
.line15
	dstr "trouble with save"
.line16
	db "data,"
	dstr " so we're"
.line17
	dstr "allowed only 1/4"
.line18
	dstr "of what we asked."
.line19
	dstr "BUT!"
.line20
	dstr "WE STILL MANAGED"
.line21
	dstr "TO FIT ONE FILE!"
.line22
	dstr "At the cost of the"
.line23
	db "two others,",0
.line24
	dstr "(they were a bit"
.line25
	db "grumpy,"
	dstr " though)"
.line26
	dstr "and at the cost of"
.line27
	dstr "the backups."
.line28
	db "Thus,"
	dstr " I really"
.line29
	dstr "recommend you use"
.line30
	dstr "another emulator."
.line31
	dstr "But do as you"
.line32
	db "wish,"
	dstr " man!"
	
CompatFileCorruptedText::
	text_lda_imm SRAM_UNLOCK
	text_sta SRAMEnable
	text_lda_imm BANK(sNonVoidSaveFiles)
	text_sta SRAMBank
	text_lda_imm 0
	text_sta sNonVoidSaveFiles
	text_sta SRAMEnable
	text_sta SRAMBank
	print_name TechCrewName
	print_line .line0
	print_line .line1
	wait_user
	print_line .line2
	print_line .line3
	print_line .line4
	wait_user
	clear_box
	print_line .line5
	print_line .line6
	wait_user
	print_line .line7
	wait_user
	done
	
.line0
	dstr "The file is"
.line1
	dstr "corrupted!"
.line2
	dstr "And since we're in"
.line3
	dstr "Compatibility Mode"
.line4
	dstr "there's no backup."
.line5
	dstr "So the file has"
.line6
	dstr "been deleted."
.line7
	dstr "Sorry!"
	
TechCrewName::
	dstr "Tech crew"
	
ConfirmDeletionText::
	display_quick
	print_pic GameTiles
	print_name GameName
	text_lda_imm 0
	text_sta hEnableWindow
	print_line .line0
	print_line .line1
	wait_user
	clear_box
	print_line .line2
	print_line .line3
	fake_choice .choice
	done
	
.line0
	dstr "REALLY DELETE"
.line1
	dstr "THIS FILE?"
.line2
	dstr "THIS CAN'T BE"
.line3
	dstr "CANCELLED."
.choice
	dstr "NO"
	dstr "DELETE"
	
ConfirmCopyText::
	display_quick
	print_pic GameTiles
	print_name GameName
	text_lda_imm 0
	text_sta hEnableWindow
	print_line .line0
	print_line .line1
	wait_user
	clear_box
	print_line .line2
	print_line .line3
	fake_choice .choice
	done
	
.line0
	dstr "REALLY COPY"
.line1
	dstr "THIS FILE?"
.line2
	dstr "THIS CAN'T BE"
.line3
	dstr "CANCELLED."
.choice
	dstr "NO"
	dstr "COPY"
	
ConfirmLoadText::
	print_pic GameTiles
	print_name GameName
	print_line .line0
	print_line .line1
	fake_b_choice YesNoCapsChoice
	done
.line0
	dstr "OK TO LOAD"
.line1
	dstr "THIS FILE?"
	
CorruptedFileText::
	print_pic GameTiles
	print_name GameName
	print_line .line0
	print_line .line1
	wait_user
	clear_box
	print_line .line2
	print_line .line3
	wait_user
	print_line .line4
	print_line .line5
	wait_user
	clear_box
	print_line .line6
	empty_line
	fake_b_choice YesNoCapsChoice
	done
	
.line0
	dstr "THE SAVE WAS"
.line1
	dstr "CORRUPTED!"
.line2
	db "LUCKILY,"
	dstr " I"
.line3
	db "HAVE A BACKUP,",0
.line4
	dstr "SO I CAN"
.line5
	dstr "RESTORE IT."
.line6
	dstr "SHOULD I?"
	
BackupCorruptedText::
	print_pic GameTiles
	print_name GameName
	print_line .line0
	print_line .line1
	print_line .line2
	wait_user
	clear_box
	print_line .line3
	print_line .line4
	print_line .line5
	wait_user
	clear_box
	print_line .line6
	print_line .line7
	wait_user
	print_line .line8
	wait_user
	done
	
.line0
	dstr "YOU CERTAINLY"
.line1
	dstr "DID YOUR"
.line2
	dstr "WORST."
.line3
	dstr "EVEN THE"
.line4
	dstr "BACKUP"
.line5
	dstr "IS CORRUPTED!"
.line6
	db "SO, "
	dstr "LET'S"
.line7
	dstr "START OVER."
.line8
	dstr "OKAY?"
	
EmptyFileText::
	print_pic GameTiles
	print_name GameName
	print_line EmptyFileLine0
	print_line EmptyFileLine1
	print_line EmptyFileLine2
	wait_user
	print_line EmptyFileLine3
	print_line EmptyFileLine4
	empty_line
	fake_b_choice YesNoCapsChoice
	done
EmptyFileLine0::
	dstr "WELCOME TO"
EmptyFileLine1::
	dstr "A BRAND"
EmptyFileLine2::
	dstr "NEW FILE!"
EmptyFileLine3::
	dstr "SHOULD I"
EmptyFileLine4::
	dstr "LOAD IT?"


DLCName::
	dstr "DLC MENU"
DLCUnavailableText::
	print_pic GameTiles
	print_name GameName
	print_line DLCUnavailableLine0
	print_line DLCUnavailableLine1
	print_line DLCUnavailableLine2
	wait_user
	clear_box
	print_line DLCUnavailableLine3
	wait_user
	done
DLCUnavailableLine0::
	dstr "DLC is unavai-"
DLCUnavailableLine1::
	dstr "lable because"
DLCUnavailableLine2::
	dstr "it's not."
DLCUnavailableLine3::
	dstr "Deal with it."
	
	
SECTION "Save file management", ROMX
	
LoadFile::
	ld bc, SaveBlocks
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ldh a, [hSRAM32kCompat]
	and a
	jr nz, .compatMode
	ld a, [wSaveFileID]
	add a, a
	add a, a
	db $11
.compatMode
	ld a, 2
	
.copyOneBank
	push af
	ld [SRAMBank], a
	ld hl, sFile1Data0Start
.copyLoop
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	and a
	jr z, .doneCopying
	ld d, a
	bit 4, a
	jr z, .toWRAM0
	and $E0
	jr z, .toHRAM
	rlca
	rlca
	rlca
	call SwitchRAMBanks
.toWRAM0
	ld a, d
	and $1F
	or $C0
	ld d, a
.highByteDone
	ld a, [bc]
	inc bc
	push bc
	ld c, a
	rst copy ; Copy block
	pop bc
	jr .copyLoop
	
.toHRAM
	ld d, $FF
	jr .highByteDone
	
.doneCopying
	pop af
	inc a
	bit 0, a ; See next function
	jr nz, .copyOneBank
	
	ret
	
SaveFile::
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ldh a, [hSRAM32kCompat]
	and a
	jr nz, .compatMode
	ld a, [wSaveFileID]
	add a, a
	add a, a
	db $11
.compatMode
	ld a, 2
	
	ld [SRAMBank], a
	ld hl, sFile1MagicString0
	ld [hl], 0 ; Make file invalid to prevent making bad saves 'cause of resets
	
	ld bc, SaveBlocks
.copyOneBank
	push af
	ld [SRAMBank], a
	ld de, sFile1Data0Start
.copyLoop
	ld a, [bc]
	inc bc
	ld l, a
	ld a, [bc]
	inc bc
	and a
	jr z, .doneCopying
	ld h, a
	bit 4, a
	jr z, .fromWRAM0
	and $E0
	jr z, .fromHRAM
	rlca
	rlca
	rlca
	call SwitchRAMBanks
.fromWRAM0
	ld a, h
	and $1F
	or $C0
	ld h, a
.highByteDone
	ld a, [bc]
	inc bc
	push bc
	ld c, a
	rst copy ; Copy block
	pop bc
	jr .copyLoop
	
.fromHRAM
	ld h, $FF
	jr .highByteDone
	
.doneCopying
	pop af
	inc a
	bit 0, a ; We start at the even bank, so only re-loop if we have to process the odd bank
	jr nz, .copyOneBank
	
	dec a ; That pointed to the bank following the odd one, we need one less
	
CalculateFileChecksums:
	; Calculate header checksums
	; Call with a = bank right after both "main" banks
.calcOneBankSums
	push af
	ld [SRAMBank], a
	ld hl, sFile1Data0Start
	ld de, sFile1Checksums0
.nextBlock
	ld bc, 0
.checksumOneBlock
	ld a, [hl]
	add a, b
	rrca
	ld b, a
	ld a, [hli]
	xor c
	rlca
	ld c, a
	ld a, l
	and $3F
	jr nz, .checksumOneBlock
	
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	
	ld a, e
	and a
	jr nz, .nextBlock
	
	pop af
	dec a
	bit 0, a ; We started with the odd bank, re-loop for the even bank
	jr z, .calcOneBankSums
	
	; Finally, make file (potentially) valid by re-writing the string in the even bank
	; This is done last, so no cheating is possible... :)
	ld b, BANK(DefaultSaveMagicString0)
	ld hl, DefaultSaveMagicString0
	ld de, sFile1MagicString0
	call CopyStrAcross
	
	xor a
	ld [SRAMEnable], a
	ld [SRAMBank], a
	ret
	
CalculateFileChecksums_Hook::
	ldh a, [hSRAM32kCompat]
	and a
	jr z, .notCompatMode
	ld a, 3 ; The second used bank
	jr .compatMode
.notCompatMode
	ld a, [wSaveFileID]
	add a, a
	add a, a
	inc a
.compatMode
	call CalculateFileChecksums
	ld a, SRAM_UNLOCK
	ld [SRAMEnable], a
	ret
	
	
wram0_block: MACRO
	dw (\1 & $1FFF) | $8000
	db \2
ENDM

wramx_block: MACRO
	dw (\1 & $1FFF) | (BANK(\1) << 13)
	db \2
ENDM

hram_block: MACRO
	dw $1000 | LOW(\1)
	db \2
ENDM

flags_block: MACRO
	dw (wFlags & $1FFF + 256 * \1) | (BANK(wFlags) << 13)
	db 0 ; 256 bytes
ENDM

SaveBlocks::
	; Bank 0
	wram0_block wTargetWarpID, 2
	wram0_block wYPos, (wCameraXPos + 2 - wYPos)
	hram_block hOverworldButtonFilter, 1
	hram_block hRandInt, 2
	wramx_block wWalkingInteractions, 0
	wramx_block wWalkingLoadZones, 0
	wramx_block wButtonInteractions, 0
	wramx_block wButtonLoadZones, 0
	wramx_block wWalkInterCount, 7
	wramx_block wNPCArray, $90
	wramx_block wEmoteGfxID, 3
	wram0_block wAnimationSlots, 8 * 8
	wram0_block wAnimationStacks, 8 * 8
	wram0_block wActiveAnimations, 9 + 8 ; Also wAnimationTargetNPCs
	
	enum_start
REPT $10
	flags_block enum_value
	enum_skip
ENDR
	dw 0 ; Terminate
	
	; Bank 1
	dw 0 ; Terminate
