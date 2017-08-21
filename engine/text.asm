
SECTION "Text engine", ROMX
	
EnableTextbox::
	ld a, 1
	ld [wTextboxStatus], a
	ret
	
WaitForTextbox::
.wait
	rst waitVBlank
	ld a, [wTextboxStatus]
	cp TILE_SIZE * 6 + 1
	jr nz, .wait
	ret
	
DisableTextbox::
	ld hl, wTextboxStatus
	set 7, [hl]
.waitUntilTextboxIsDown
	rst waitVBlank
	ld a, [wTextboxStatus]
	and a
	jr nz, .waitUntilTextboxIsDown
	rst waitVBlank ; Textbox actually needs one extra frame
	ret
	
ClearTextbox::
	ld hl, wTextFlags
	res TEXT_PIC_FLAG, [hl]
	
	ld hl, wTextboxTileMap
	ld a, $11
	ld [hli], a
	inc a
	ld c, SCREEN_WIDTH - 2
	rst fill
	dec a
	ld [hli], a
	dec a
	ld b, 4
.clearRow
	ld [hli], a
	xor a
	ld c, SCREEN_WIDTH - 2
	rst fill
	ld a, $10
	ld [hli], a
	dec b
	jr nz, .clearRow
	inc a
	ld [hli], a
	inc a
	ld c, SCREEN_WIDTH - 2
	call FillVRAMLite
	dec a
	ld [hl], a
	
	; a != 0
	ld hl, wTransferRows
	ld c, 6
	rst fill
	
	ld a, 1
	ld [rVBK], a
	ld hl, vTextboxTileMap
	ld b, 5
.initRowAttr
	ld a, 1
	ld c, SCREEN_WIDTH - 1
	call FillVRAMLite
.waitVRAM1
	rst isVRAMOpen
	jr nz, .waitVRAM1
	ld a, $21
	ld [hli], a
	ld a, l
	add a, VRAM_ROW_SIZE - SCREEN_WIDTH
	ld l, a
	dec b
	jr nz, .initRowAttr
	; Init last row, which is the same but with a VFlip
	ld a, $41
	ld c, SCREEN_WIDTH - 1
	call FillVRAMLite
.waitVRAM2
	rst isVRAMOpen
	jr nz, .waitVRAM2
	ld a, $61
	ld [hl], a
	xor a
	ld [rVBK], a
	ld [wNumOfPrintedLines], a
	
	ld hl, TextboxBorderTiles
	ld de, vTextboxBorderTiles
	ld c, TextboxBorderTilesEnd - TextboxBorderTiles
	jp CopyToVRAMLite
	
TextboxBorderTiles::
	dw $3814, $3814, $3814, $3814, $3814, $3814, $3814, $3814 ; Vertical edge
	dw $0000, $7C00, $4738, $473F, $4738, $7C03, $3814, $3814 ; Corner
	dw $0000, $0000, $FF00, $FFFF, $FF00, $00FF, $0000, $0000 ; Horizontal edge
	dw $0000, $0000, $FF00, $FFFF, $FF00, $00FE, $0000, $0000 ; Tile on the arrow's left
	dw $0000, $0000, $C700, $9383, $3900, $7C00, $FE00, $0000 ; Arrow (will be flipped, remember)
	dw $0000, $1000, $F000, $F0F0, $F000, $10E0, $0000, $0000 ; Edge for name, left
	dw $0000, $2000, $3F00, $3F3F, $3F00, $201F, $0000, $0000 ; Edge for name, right
TextboxBorderTilesEnd::
	
ProcessText_Hook::
	ld b, c
	ld h, d
	ld l, e
	
; Process the text pointed to by b:hl
; Text is actually a byte stream, you should use the macros defined in text_constants.asm to build a text stream
ProcessText::
	push bc ; Save ROM bank
	push hl ; Save read pointer
	ld a, 1
	call SwitchRAMBanks ; Switch to the text-related RAM bank
	call ClearTextbox
.mainLoop
	; Step 1 : copy data about to be processed
	pop hl ; Retrieve read pointer
	pop bc ; Retrieve ROM bank
	push bc ; Place them back
	push hl ; Not using "inc sp"s, because if a handler fires right now the stack is modified :P
	ld de, wDigitBuffer
	ld c, 5
	call CopyAcrossLite ; Copy next 5 bytes for command to analyze
	
	; Step 2 : process copied data
	ld hl, wDigitBuffer
	ld a, [hli] ; Get command ID
	; Check if ID is invalid (out of bounds)
	; Also means we can't lose MSB on later "add a, a"
	cp INVALID_TXT_COMMAND
	; Print error message and end text
	jr nc, .printErrorAndEnd
	; Check if command is #0
	and a
	; End text normally if so
	jr z, .end
	
	; Step 3 : run text command
	; Get operation ID, we just ensured it is valid
	add a, a ; Double a (MSB can only be zero because of above check :)
	ld hl, TextCommandsPointers - 2 ; - 2 because first offset is for a = 1
	add a, l
	ld l, a
	jr nc, .noCarry1
	inc h
.noCarry1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst callHL ; Call appropriate command
	; Should return number of bytes consumed in a
	
	; Step 4 : prepare next call
	pop hl ; Get read pointer back
	; Put offset in bc
	ld c, a
	; Make b = 0 if c >= 0, and b = $FF if c < 0
	rla ; Move MSB (sign bit) into carry
	sbc a, a ; a <- a - a - carry : 0 if carry isn't set, $FF if set. Neat !
	ld b, a
	; bc now contains our movement offset
	add hl, bc ; Move read pointer
	push hl ; Save it
	
	; Step 5 : ensure at most one command is processed per frame
	rst waitVBlank
	jr .mainLoop
	
.printErrorAndEnd
	call ClearTextbox
	ld hl, TextErrorStr
	ld b, BANK(TextErrorStr)
	call PrintKnownPointer ; Print text error string
	ld hl, wTextboxStatus ; Make sure text box is up
	ld [hl], TILE_SIZE * 5
	ld bc, 40 ; Wait for user to read
	call DelayBCFrames
.end
	add sp, 4; Free top 2 stack entries, they contain read pointer and ROM bank
	jpacross DisableTextbox
	
	
	
TextCommandsPointers::
	dw ClearText
	dw PrintPic
	dw PrintNameAndWaitForTextbox
	dw WaitForButtonPress
	dw PrintLine
	dw PrintEmptyLine
	dw DelayNFrames
	dw SetTextLoopCounter
	dw CopyTextLoopCounter
	dw TextDjnz
	dw DisplayNumber
	dw DisplayTextboxInstant
	dw CloseTextboxInstant
	dw DisplayTextboxWithoutWait
	dw CloseTextboxWithoutWait
	dw MakeNPCWalk
	dw MakeChoice
	dw MakeChoice ; Difference between commands handled by function itself
	dw SetFadeSpeed
	dw Fadein_TextWrapper
	dw Fadeout_TextWrapper
	dw ReloadPalettes_TextWrapper
	dw TextLDA
	dw TextLDA_imm8
	dw TextSTA
	dw TextCMP
	dw TextDEC
	dw TextINC
	dw TextADD
	dw TextADC
	dw TextADD_mem
	dw TextSBC
	dw TextSUB_mem
	dw TextSetFlags
	dw TextToggleFlags
	dw TextCallFunc
	dw InstantPrintLines
	dw ReloadTextFlags
	dw TextJR
	dw TextJR_Conditional ; nc
	dw TextJR_Conditional ; c
	dw TextJR_Conditional ; p
	dw TextJR_Conditional ; n
	dw TextJR_Conditional ; pe
	dw TextJR_Conditional ; po
	dw TextJR_Conditional ; nz
	dw TextJR_Conditional ; z
	dw TextRAMBankswitch
	dw TextAND
	dw TextOR
	dw TextXOR
	dw TextBIT
	dw EndTextWithoutClosing
	dw TextFadeMusic
	dw TextPlayMusic
	dw TextStopMusic
	dw OverrideTextboxPalette
	
	
; A clone of ProcessText, but for the battle engine !
; Process the text pointed to by c:de
; Text stream is the same as ProcessText, but :
;  - Some commands will act differently
;  - Some commands are effectively NOPs of varying sizes
; This notably due to not having any textbox anymore - and thus not having to deal with it anyways
ProcessBattleText::
	ld b, a
	ld h, d
	ld l, e
	push bc ; Save ROM bank
	push hl ; Save read pointer
	ld a, 1
	call SwitchRAMBanks ; Switch to the text-related RAM bank
	call ClearBattleTextbox
.mainLoop
	; Step 1 : copy data about to be processed
	pop hl ; Retrieve read pointer
	pop bc ; Retrieve ROM bank
	push bc ; Place them back
	push hl ; Not using "inc sp"s, because if a handler fires right now the stack is modified :P
	ld de, wDigitBuffer
	ld c, 5
	call CopyAcrossLite ; Copy next 5 bytes for command to analyze
	
	; Step 2 : process copied data
	ld hl, wDigitBuffer
	ld a, [hli] ; Get command ID
	; Check if ID is invalid (out of bounds)
	; Also means we can't lose MSB on later "add a, a"
	cp INVALID_TXT_COMMAND
	; Print error message and end text
	jr nc, .printErrorAndEnd
	; Check if command is #0
	and a
	; End text normally if so
	jr z, .end
	
	; Step 3 : run text command
	; Get operation ID, we just ensured it is valid
	add a, a ; Double a (MSB can only be zero because of above check :)
	ld hl, BattleTextCommandsPointers - 2 ; - 2 because first offset is for a = 1
	add a, l
	ld l, a
	jr nc, .noCarry1
	inc h
.noCarry1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	rst callHL ; Call appropriate command
	; Should return number of bytes consumed in a
	
	; Step 4 : prepare next call
	pop hl ; Get read pointer back
	; Put offset in bc
	ld c, a
	; Make b = 0 if c >= 0, and b = $FF if c < 0
	rla ; Move MSB (sign bit) into carry
	sbc a, a ; a <- a - a - carry : 0 if carry isn't set, $FF if set. Neat !
	ld b, a
	; bc now contains our movement offset
	add hl, bc ; Move read pointer
	push hl ; Save it
	
	; Step 5 : ensure at most one command is processed per frame
	rst waitVBlank
	jr .mainLoop
	
.printErrorAndEnd
	call ClearBattleTextbox
	ld hl, TextErrorStr
	ld b, BANK(TextErrorStr)
	call PrintKnownPointer ; Print text error string
	ld bc, 40 ; Wait for user to read
	call DelayBCFrames
.end
	add sp, 4 ; Free top 2 stack entries, they contain read pointer and ROM bank
	ret
	
	
	
BattleTextCommandsPointers::
	dw ClearBattleText
	dw BattleDummy_4Bytes
	dw BattlePrintName ; TODO
	dw WaitForButtonPress
	dw BattlePrintLine ; TODO
	dw BattlePrintEmptyLine ; TODO
	dw DelayNFrames
	dw SetTextLoopCounter
	dw CopyTextLoopCounter
	dw TextDjnz
	dw BattleDisplayNumber ; TODO
	dw BattleDummy_1Byte
	dw BattleDummy_1Byte
	dw BattleDummy_1Byte
	dw BattleDummy_1Byte
	dw BattleDummy_5Bytes
	dw BattleMakeChoice ; TODO
	dw BattleMakeChoice ; Difference between commands handled by function itself
	dw SetFadeSpeed
	dw Fadein_TextWrapper
	dw Fadeout_TextWrapper
	dw ReloadPalettes_TextWrapper
	dw TextLDA
	dw TextLDA_imm8
	dw TextSTA
	dw TextCMP
	dw TextDEC
	dw TextINC
	dw TextADD
	dw TextADC
	dw TextADD_mem
	dw TextSBC
	dw TextSUB_mem
	dw TextSetFlags
	dw TextToggleFlags
	dw TextCallFunc
	dw InstantPrintLines
	dw ReloadTextFlags
	dw TextJR
	dw TextJR_Conditional ; nc
	dw TextJR_Conditional ; c
	dw TextJR_Conditional ; p
	dw TextJR_Conditional ; n
	dw TextJR_Conditional ; pe
	dw TextJR_Conditional ; po
	dw TextJR_Conditional ; nz
	dw TextJR_Conditional ; z
	dw TextRAMBankswitch
	dw TextAND
	dw TextOR
	dw TextXOR
	dw TextBIT
	dw EndTextWithoutClosing
	dw TextFadeMusic
	dw TextPlayMusic
	dw TextStopMusic
	dw OverrideTextboxPalette
	
TextErrorStr::
	db "TEXT ERROR."
EmptyStr::
	db 0
	
YesNoCapsChoice::
	dstr "YES"
	dstr "NO"
	
YesNoChoice::
	dstr "Yes"
	dstr "No"
	
	
; Clears all three textbox lines
ClearText::
	ld hl, wTextFlags
	bit TEXT_PIC_FLAG, [hl]
	ld hl, wTextboxLine0
	ld c, SCREEN_WIDTH - 6
	jr nz, .picPresent
	ld c, SCREEN_WIDTH - 2
	ld l, wTextboxPicRow1 & $FF
.picPresent
	ld a, l
	add a, SCREEN_WIDTH
	ld e, a ; Save the next line's low byte
	ld d, c ; Save the length
	xor a
	; Clear all 3 text rows
	rst fill
	ld l, e
	ld a, e ; Move to the next line
	add a, SCREEN_WIDTH
	ld e, a
	ld c, d
	xor a
	rst fill
	ld l, e
	ld c, d
	rst fill
	
	xor a
	ld [wNumOfPrintedLines], a
	inc a
	ld hl, wTransferRows + 2
	ld c, 3
	; a is nonzero
	rst fill ; Mark rows as dirty
	
	; Consumed one byte
	ret
	
	
; Clears the whole battle textbox
ClearBattleTextbox::
	ld hl, wFixedTileMap + 1
	ld a, 1
	ld c, SCREEN_WIDTH - 2
	rst fill
	ld [wTransferRows + 5], a
	
; Clears all three textbox lines
ClearBattleText::
	ld hl, wFixedTileMap + SCREEN_WIDTH + 1
	xor a
	ld [wNumOfPrintedLines], a
	ld b, SCREEN_WIDTH - 2
	; Clear all 3 text rows
	ld c, b
	rst fill
	inc hl
	inc hl
	ld c, b
	rst fill
	inc hl
	inc hl
	ld c, b
	rst fill
	
	ld hl, wTransferRows + 6
	ld c, 3
	inc a ; a = $01
	rst fill
	; Consumed one byte
	ret
	
	
; Prints the picture pointed to to VRAM and displays it on the textbox
PrintPic::
	ld hl, wTextFlags
	set TEXT_PIC_FLAG, [hl] ; Set pic flag
	
	ld hl, wDigitBuffer + 1
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, b
	ld de, vPicTiles
	ld bc, VRAM_TILE_SIZE * 9
	call CopyAcrossToVRAM
	ld h, d
	ld l, e
	ld c, VRAM_TILE_SIZE * 3
	xor a
	call FillVRAMLite ; Blank out last 3 tiles (for text scrolling animation)
	
	ld a, 4
	ld hl, wTextboxPicRow0
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	
	ld l, wTextboxPicRow1 & $FF
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	
	ld l, wTextboxPicRow2 & $FF
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	
	ld l, wTextboxPicRow3 & $FF
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	
	; a is nonzero
	ld hl, wTransferRows + 1
	ld c, 4
	rst fill
	
BattleDummy_4Bytes::
	ld a, 4 ; Consumed command byte + bank byte + pic ptr
	ret
	
	
; Prints the name and waits for the textbox to finish rising...
; Note : if the textbox is already rising, its animation will not restart
; And if the textbox is already fully up, it will not rise again
PrintNameAndWaitForTextbox::
	ld hl, wTextFlags
	bit TEXT_PIC_FLAG, [hl]
	
	ld de, wTextboxName
	jr nz, .picPresent
	ld e, (wTextboxName - 4) & $FF
.picPresent

	ld hl, wDigitBuffer + 1
	ld a, [hli] ; Get bank
	ld b, a
	ld a, [hli] ; Get pointer
	ld h, [hl]
	ld l, a
	or h
	jr z, .noName
	ld a, $15
	ld [de], a
	inc de
	call CopyStrAcross
	dec de
	ld a, $16
	ld [de], a
	
	ld a, 1 ; Ask to transfer row
	ld [wTransferRows], a
	
.noName
	ld hl, wTextboxStatus
	ld a, [hl]
	and $7F ; Check if textbox status is zero (don't care about bit 7)
	jr nz, .textboxAlreadyUp
	inc a
	ld [hl], a ; Make textbox begin to appear
.textboxAlreadyUp
	call WaitForTextbox
	
	ld a, 4 ; Consumed command byte + bank byte + name ptr
	ret
	
; Prints the name
BattlePrintName::
	ld hl, wDigitBuffer + 1
	ld a, [hli] ; Get bank
	ld b, a
	ld a, [hli] ; Get pointer
	ld h, [hl]
	ld l, a
	ld de, wTextboxName
	call CopyStrAcross
	
	ld a, 1 ; Ask to transfer row
	ld [wTransferRows], a
	
	ld a, 4 ; Consumed command byte + bank byte + name ptr
	ret
	
	
; Wait until the user has pressed a button
WaitForButtonPress::
	ld hl, vTextboxLine2 + VRAM_ROW_SIZE + 13
	ld a, $14
	ld [hld], a
	dec a
	ld [hl], a
	
.waitLoop
	rst waitVBlank
	ldh a, [hFrameCounter]
	and $1F
	jr nz, .noBlink
	ld a, $13 ^ $12 ; Change between border and arrow'd border
	xor [hl]
	ld [hli], a
	ld a, $14 ^ $12
	xor [hl]
	ld [hld], a
.noBlink
	ldh a, [hPressedButtons]
	and 3
	jr z, .waitLoop
	
	ld a, $12
	ld [hli], a
	ld [hl], a
	
	ld a, 1 ; Consumed command byte
	ret
	
	
; Prints a line of text
PrintLine::
	ld hl, wDigitBuffer + 1
	ld a, [hli] ; Get source bank
	ld b, a
	ld a, [hli] ; Get pointer
	ld h, [hl]
	ld l, a
	call PrintKnownPointer
	
	ld a, 4 ; Consumed command byte + bank byte + str ptr
	ret
	
; Use this hook when "callacross"-ing PrintKnownPointer ; put the print pointer in de instead of hl, and the bank in c instead of b
PrintKnownPointer_Hook::
	ld h, d
	ld l, e
	ld b, c
	
PrintKnownPointer::
	ld a, [wNumOfPrintedLines]
	and 3
	cp 3
	jp c, .printNewLine ; Too far to jr
	
	push hl ; Save read pointer
	push bc ; Save bank
	
	ld b, 0
.scrollLoop
	rst waitVBlank
	
.shiftPic
	ld hl, $9070
.shiftColumn
	ld de, 0
.shiftTile
	ld c, $08 ; Move the 8 lines
.shiftByte
	rst isVRAMOpen
	jr nz, .shiftByte
	ld a, e
	ld e, [hl]
	ld [hli], a
	ld a, d
	ld d, [hl]
	ld [hli], a
	dec c
	jr nz, .shiftByte
	ld a, l
	add a, $20
	ld l, a
	cp $30
	jr nc, .shiftTile
	ld a, l
	add a, $80
	ld l, a
	cp $A0
	jr nz, .shiftColumn
	inc b
	bit 0, b
	jr nz, .shiftPic
	
	ld a, [rLYC] ; Calc scanline on which scroll will happen
	add a, TILE_SIZE * 2
	cp $8F ; Check if it's displayed
	jr nc, .effectIsOffscreen
	ld c, a
	
	ld a, [rLCDC]
	ld e, a ; Save LCDC for later restoring
	ld hl, rLYC ; Will be used for later writing
	ld a, b
	sub [hl]
	dec a
	ld d, a ; Precalc target SCY value
	ld l, rSCX & $FF ; hl = rSCX
.waitUntilText
	ld a, [rLY]
	cp c
	jr c, .waitUntilText
	
	; Scroll register writes will be ignored until next line
	; Values will be restored by VBlank handler (wSCY, wSCX, wTileMapMode, etc.)
	xor a
	ld [hld], a ; Write to SCX
	ld [hl], d ; Write precalc'd value to SCY
	
.waitUntilLineEnds
	rst isVRAMOpen
	jr nz, .waitUntilLineEnds
	
	ld hl, vTextboxPicRow0
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	
	; Writing while the tilemap is transferred seems to cause graphical issues
	ld a, $E9
	ld [rLCDC], a
	ld a, 7 + $9F
	ld [rWX], a
	
	ld a, c
	sub b
	add a, 3 * 8 + 1
	cp $90
	jr c, .noCap
	ld a, $8F
.noCap
	
	ld hl, rSCY
	ld c, a
.waitUntilTextBottom
	ld a, [rLY]
	cp c
	jr c, .waitUntilTextBottom
	
	ld a, 120 + TILE_SIZE
	add a, b
	ld [hl], a ; Force current "window" line to be 16th
	
.blankUnderText
	rst isVRAMOpen
	jr z, .blankUnderText
.waitLineEnd
	rst isVRAMOpen
	jr nz, .waitLineEnd
	
	dec [hl]
	ld a, [rLY]
	cp $8F - 7
	jr c, .blankUnderText
	
	ld a, e
	ld [rLCDC], a
	ld a, 7
	ld [rWX], a
	dec [hl]
	
	; Transfer textbox row #2 to restore picture (if needed)
	; a is non-zero
	ld [wTransferRows + 1], a
	
	ld a, [wSCY]
	ld [hli], a
	ld a, [wSCX]
	ld [hl], a
	
.effectIsOffscreen
	ld a, b
	cp 8
	jp nz, .scrollLoop ; Too far (though by REALLY not much)
	
	; Now we're going to race the beam. Goal : have the text box set up by the time it's rendered.
	ld hl, $90A0
	ld de, $9070
	ld c, $10 * 6
	call CopyToVRAMLite
	ld l, e
	dec h
	ld c, $30
	xor a
	call FillVRAMLite
	
	ld hl, wTextFlags
	bit TEXT_PIC_FLAG, [hl]
	ld bc, wTextboxPicRow1
	jr z, .picNotPresent
	ld c, wTextboxLine0 & $FF
.picNotPresent
	ld hl, SCREEN_WIDTH
	add hl, bc ; Move to second line
	ld d, h
	ld e, l ; Store pointer
	ld hl, SCREEN_WIDTH * 2
	add hl, bc ; Move to third line
.moveLines
	ld a, [de]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [de], a
	inc de
	xor a
	ld [hli], a
	ld a, c
	cp (wTextboxLine0 + 14) & $FF
	jr nz, .moveLines
	
	ld hl, wTextboxTileMap + SCREEN_WIDTH * 2
	ld de, vTileMap1 + VRAM_ROW_SIZE * 2
.commitLines
	ld c, SCREEN_WIDTH
	call CopyToVRAMLite
	ld a, e
	add a, VRAM_ROW_SIZE - SCREEN_WIDTH
	ld e, a
	cp (vTileMap1 + VRAM_ROW_SIZE * 6) & $FF
	jr nz, .commitLines
	
	pop bc ; Retrieve bank
	; Print at last line
	ld de, wTextboxLine2
	pop hl ; Get back read pointer
	jr .printLine
	
.printNewLine
	inc a
	ld [wNumOfPrintedLines], a
	ld c, a
	ld de, wTextboxLine0 - SCREEN_WIDTH
.calcDest
	ld a, SCREEN_WIDTH
	add a, e
	ld e, a ; Cannot overflow
	dec c
	jr nz, .calcDest
	
.printLine
	ld a, [wTextFlags]
	bit TEXT_PIC_FLAG, a ; Check if pic is present
	jr nz, .picIsPresent
	ld a, e ; Place text on pic's space since it's free
	sub (wTextboxLine0 - wTextboxPicRow1)
	ld e, a
.picIsPresent
	; Copy string across banks (b preserved thus far :D)
	push de
	
	; This is almost equivalent to CopyStrAcross, but doesn't copy the terminating $00 if it would overwrite the border
	call TextCopyAcross
	
	ld d, h ; Get after-copy hl
	ld e, l
	pop hl
	push de ; Save for later
	ld d, vTextboxLine0 >> 8
	ld a, [wNumOfPrintedLines]
	and 3
	add a, a ; Mult by 2
	swap a ; Mult by 16 (since original 4 upper bits are zero)
	add a, vTextboxPicRow0 & $FF
	ld e, a
	ld c, 18
	ld a, [wTextFlags]
	bit TEXT_PIC_FLAG, a
	jr z, .noPicThere
	ld a, e
	add a, (wTextboxLine0 - wTextboxPicRow1) ; Add pic offset
	ld e, a
	ld c, 14
.noPicThere
	
.printLoop
	rst waitVBlank
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr z, .endPrint
	dec c
	jr nz, .printLoop
.endPrint
	ld d, h
	ld e, l
	pop hl
	ret
	
	
; Prints a line of text
BattlePrintLine::
	ld hl, wDigitBuffer + 1
	ld a, [hli] ; Get source bank
	ld b, a
	ld a, [hli] ; Get pointer
	ld h, [hl]
	ld l, a
	call BattlePrintKnownPointer
	
	ld a, 4 ; Consumed command byte + bank byte + str ptr
	ret
	
; Use this hook when "callacross"-ing BattlePrintKnownPointer ; put the print pointer in de instead of hl, and the bank in c instead of b
BattlePrintKnownPointer_Hook::
	ld h, d
	ld l, e
	ld b, c
	
BattlePrintKnownPointer::
	ld a, [wNumOfPrintedLines]
	and 3
	cp 3
	jp c, .printNewLine ; Too far to jr
	
	push hl ; Save read pointer
	push bc ; Save bank
	
	ld b, 0
.scrollLoop
	rst waitVBlank
	
	ld a, [rWY] ; Calc scanline on which scroll will happen
	add a, 15
	cp $8F ; Check if it's displayed
	jr nc, .effectIsOffscreen
	ld c, a
	
	ld a, [rLCDC]
	ld e, a ; Save LCDC for later restoring
	ld hl, rWY ; Will be used for later writing
	ld a, b
	sub [hl]
	ld d, a ; Precalc target SCY value
	ld l, rSCX & $FF ; hl = rSCX
.waitUntilText
	ld a, [rLY]
	cp c
	jr c, .waitUntilText
	
	; Scroll register writes will be ignored until next line
	; Values will be restored by VBlank handler (wSCY, wSCX, wTileMapMode, etc.)
	xor a
	ld [hld], a ; Write to SCX
	ld [hl], d ; Write precalc'd value to SCY
	
.waitUntilLineEnds
	rst isVRAMOpen
	jr nz, .waitUntilLineEnds
	
	; Writing while the tilemap is transferred seems to cause graphical issues
	ld a, $89
	ld [rLCDC], a
	
	ld a, c
	sub b
	add a, 3 * 8 + 1
	cp $90
	jr c, .noCap
	ld a, $8F
.noCap
	
	ld c, a
.waitUntilTextBottom
	ld a, [rLY]
	cp c
	jr c, .waitUntilTextBottom
	
	ld a, 119
	add a, b
	ld [hl], a ; Force current "window" line to be 7th, since it should be blank
	
.blankUnderText
	rst isVRAMOpen
	jr z, .blankUnderText
.waitLineEnd
	rst isVRAMOpen
	jr nz, .waitLineEnd
	
	dec [hl]
	ld a, [rLY]
	cp $8F
	jr c, .blankUnderText
	
	ld a, e
	ld [rLCDC], a
	
.effectIsOffscreen
	ld a, b
	cp 8
	jr nz, .scrollLoop
	
	; Now we're going to race the beam. Goal : have the text box set up by the time it's rendered.
	ld hl, $90A0
	ld de, $9070
	ld c, $10 * 6
	call CopyToVRAMLite
	ld l, e
	dec h
	ld c, $30
	xor a
	call FillVRAMLite
	
	ld hl, wTextboxLine2
	ld de, wTextboxLine1
	ld bc, wTextboxLine0
.moveLines
	ld a, [de]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [de], a
	inc de
	xor a
	ld [hli], a
	ld a, c
	cp $54
	jr nz, .moveLines
	
	ld hl, wTextboxLine0
	ld de, vTextboxLine0
.commitLines
	ld c, 15
	call CopyToVRAMLite
	ld a, l
	add a, 5
	ld l, a
	ld a, e
	add a, $20 - 15
	ld e, a
	cp $A5
	jr nz, .commitLines
	
	pop bc ; Retrieve bank
	; Print at last line
	ld de, wTextboxLine2
	pop hl ; Get back read pointer
	jr .printLine
	
.printNewLine
	inc a
	ld [wNumOfPrintedLines], a
	ld de, wTextboxLine0 - SCREEN_WIDTH
	ld c, a
.calcDest
	ld a, SCREEN_WIDTH
	add a, e
	ld e, a ; Cannot overflow
	dec c
	jr nz, .calcDest
	
.printLine
	; Copy string across banks (b preserved thus far :D)
	push de
	call CopyStrAcross
	ld d, h ; Get after-copy hl
	ld e, l
	pop hl
	push de ; Save for later
	ld d, vTextboxLine0 >> 8
	ld a, [wNumOfPrintedLines]
	and 3
	inc a
	add a, a ; Mult by 2
	swap a ; Mult by 16 (since original 4 upper bits are zero)
	add a, 5 ; Add pic offset
	ld e, a
	
.printLoop
	rst waitVBlank
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .printLoop
	ld d, h
	ld e, l
	pop hl
	ret
	
PrintEmptyLine::
	ld hl, EmptyStr
	ld b, BANK(EmptyStr)
	call PrintKnownPointer
	
BattleDummy_1Byte::
	ld a, 1 ; Consumed command byte
	ret
	
BattlePrintEmptyLine::
	ld hl, EmptyStr
	ld b, BANK(EmptyStr)
	call BattlePrintKnownPointer
	ld a, 1
	ret
	
	
DelayNFrames::
	ld hl, wDigitBuffer + 1 ; Get number of frames to delay
	ld c, [hl]
	inc hl
	ld b, [hl]
	call DelayBCFrames
	
	ld a, 3 ; Consumed command byte + delay word
	ret
	
	
SetTextLoopCounter::
	ld a, [wDigitBuffer + 1] ; Get counter
	ld [wTextLoopCounter], a
	
	ld a, 2 ; Consumed command byte + counter byte
	ret
	
CopyTextLoopCounter::
	ld hl, wDigitBuffer
	ld a, [hli] ; Get pointer
	ld h, [hl]
	ld l, a
	; Get counter from pointer
	ld a, [hl]
	ld [wTextLoopCounter], a
	
	ld a, 3 ; Consumed command byte + counter pointer
	ret
	
TextDjnz::
	ld a, 2 ; Consumed command byte + offset
	ld hl, wTextLoopCounter
	dec [hl]
	ret z ; Done decrementing, no jr. Already set consumed bytes !
	
TextJR::
	ld a, [wDigitBuffer + 1] ; Get offset
	; Say it's the number of bytes we consumed
	ret
	
TextJR_Conditional::
	ld hl, wDigitBuffer
	ld a, [hli]
	sub TEXT_JR_NC - 2 ; So b will be at least 1 (if conditional is correct, though)
	srl a
	ld b, a
	ld a, [wTextFlags]
	jr nc, .jumpIfFlagReset
	cpl ; Invert flags, so the jump will occur if the flag is reset (instead of set...)
.jumpIfFlagReset
.getFlagLoop
	add a, a
	dec b
	jr nz, .getFlagLoop
	
	ld a, 2
	ret c ; Flag is set -> jump shouldn't occur
	
	ld a, [hl]
	ret
	
	
DisplayNumber::
	ld hl, wDigitBuffer + 1
	ld a, [hli] ; Get display type
	and a ; Check whether we display a byte or a word
	
	ld a, [hli] ; Get pointer
	ld e, a
	ld d, [hl]
	
	ld h, 0
	jr z, .byte ; Z hasn't changed since "and a"
	ld a, [de] ; Word ? Get high byte !
	ld h, a ; Also overwrite b, which was 1
	inc de
.byte
	ld a, [de]
	ld l, a
	
	xor a
	ld de, wDigitBuffer + 4 ; Write destination
	ld [de], a ; Make sure to terminate the string
.loop
	push de ; Save write offset
	ld de, 10
	call DivideHLByDE_KnownDE ; DE is known, skip the "divide by zero" check
	add hl, de ; Get remainder in hl
	pop de ; Get write offset back
	
	; hl contains remainder ; it cannot be invalid (except if I coded my divide function badly :P)
	ld a, l
	add a, "0" ; Add tile offset...
	dec de ; Write to digit buffer
	ld [de], a
	
	; Get hl / de back into hl, making sure it's not 0
	ld h, b
	ld l, c
	
	ld a, b
	or c
	jr nz, .loop ; If we printed all digits then it's done
	
	; de points to first digit
	call PrintKnownPointer_Hook ; Setting b is pointless, we're in WRAM :D
	
	ld a, 4 ; Consumed command byte + display type byte + display ptr
	ret
	
BattleDisplayNumber::
	ld hl, wDigitBuffer + 1
	ld a, [hli] ; Get display type
	and a ; Check whether we display a byte or a word
	
	ld a, [hli] ; Get pointer
	ld e, a
	ld d, [hl]
	
	ld h, 0
	jr z, .byte ; Z hasn't changed since "and a"
	ld a, [de] ; Word ? Get high byte !
	ld h, a ; Also overwrite b, which was 1
	inc de
.byte
	ld a, [de]
	ld l, a
	
	xor a
	ld de, wDigitBuffer + 4 ; Write destination
	ld [de], a ; Make sure to terminate the string
.loop
	push de ; Save write offset
	ld de, 10
	call DivideHLByDE_KnownDE ; DE is known, skip the "divide by zero" check
	add hl, de ; Get remainder in hl
	pop de ; Get write offset back
	
	; hl contains remainder ; it cannot be invalid (except if I coded my divide function badly :P)
	ld a, l
	add a, "0" ; Add tile offset...
.unknownDigit
	dec de ; Write to digit buffer
	ld [de], a
	
	; Get hl / de back into hl, making sure it's not 0
	ld h, b
	ld l, c
	
	ld a, b
	or c
	jr nz, .loop ; If we printed all digits then it's done
	
	; de points to first digit
	call PrintKnownPointer_Hook ; Setting b is pointless, we're in WRAM :D
	
	ld a, 4 ; Consumed command byte + display type byte + display ptr
	ret
	
	
DisplayTextboxInstant::
	ld a, $28
	ld [wTextboxStatus], a
	
	ld a, 1 ; Consumed command byte
	ret
	
CloseTextboxInstant::
	xor a
	ld [wTextboxStatus], a
	
	inc a ; Consumed command byte
	ret
	
	
DisplayTextboxWithoutWait::
	ld a, 1
	ld [wTextboxStatus], a
	
	; Consumed bytes : OK
	ret
	
CloseTextboxWithoutWait::
	xor a
	ld [wTextboxStatus], a
	
	inc a ; Consumed command byte
	ret
	
	
MakeNPCWalk::
	ld hl, wDigitBuffer + 1
	ld a, [hli]
	and 7 ; Max out ! Hehehe, no buffer overflow :D
	ld de, wNPC0_ypos
	inc a ; Go to next NPC (wait, what ???)
	add a, a
	add a, a
	add a, a
	add a, e
	ld e, a
	dec de ; Direction of current NPC (aaah, okay)
	
	ld a, [hli]
	ld b, a ; Save this for later
	bit 2, a
	jr nz, .dontTurnNPC
	and 3
	ld [de], a
.dontTurnNPC
	bit 1, a ; Check which axis
	ld a, -5
	jr nz, .horizontalMovement
	ld a, -7
.horizontalMovement
	add a, e
	ld e, a ; de points to target value
	
	ld a, [hli] ; Get length of movement
	ld c, a
	ld a, [hl] ; Get speed of movement
	ld l, b ; Movement direction, saved from above
	ld b, a
	
.movementLoop
	ld a, [de]
	bit 0, l
	jr nz, .subtract
	
	jr .movementDone
.subtract
	
.movementDone
	
	push bc
	push de
	push hl
	call ProcessNPCs ; Update NPC sprite
	pop hl
	pop de
	pop bc
	dec c
	jr nz, .movementLoop
	
BattleDummy_5Bytes::
	ld a, 5
	ret
	
	
CURSOR_TILE	equ $7F
	
MakeChoice::
	ld a, [wTextFlags]
	ld c, a
	bit TEXT_PIC_FLAG, c
	
	ld hl, wDigitBuffer + 1
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wTextboxLine2 + 1
	jr nz, .picPresent
	ld e, (wTextboxLine2 - 3) & $FF
.picPresent
	call CopyStrAcross ; Preserves c
	xor a
	ld [de], a
	inc de
	call CopyStrAcross ; Preserves c
	
	ld hl, wTextboxLine2 - 4
	ld de, vTextboxLine2 - 4
	bit TEXT_PIC_FLAG, c
	jr z, .picNotPresent
	ld l, wTextboxLine2 & $FF
	ld e, vTextboxLine2 & $FF
.picNotPresent
	ld b, h
	ld c, l
	ld [hl], CURSOR_TILE
.drawChoiceText1
	rst waitVBlank
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .drawChoiceText1
	
	push hl
	ld [de], a
	inc hl
	inc de
	
.drawChoiceText2
	rst waitVBlank
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .drawChoiceText2
	
	pop hl
	
.loop
	rst waitVBlank
	ldh a, [hPressedButtons]
	rrca
	jr c, .done
	rrca
	jr nc, .checkDirections
	ld d, a
	ld a, [wDigitBuffer]
	cp MAKE_B_CHOICE
	ld a, d
	jr nz, .checkDirections
	
	ld a, CURSOR_TILE
	ld [hl], a
	ld [wTransferRows + 4], a
	xor a
	ld [bc], a
REPT 4
	rst waitVBlank
ENDR
	jr .done
	
.checkDirections
	and $30 >> 2
	jr z, .loop
	ld [wTransferRows + 4], a ; Next VBlank won't trigger soon, so this is ok
	and $20 >> 2
	jr nz, .goingLeft
	ld [hl], CURSOR_TILE
	xor a
	jr .writeOtherCursor
.goingLeft
	ld [hl], 0
	ld a, CURSOR_TILE
.writeOtherCursor
	ld [bc], a
	jr .loop
	
.done
	ld a, [hl]
	and a
	ld hl, wTextFlags
	set TEXT_ZERO_FLAG, [hl] ; Set status
	ld a, 5
	ret z ; Didn't select the second option
	res TEXT_ZERO_FLAG, [hl]
	ld a, [wDigitBuffer + 4]
	ret
	
BattleMakeChoice::
	ld hl, wDigitBuffer + 1
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wTextboxLine2 + 1
	call CopyStrAcross
	xor a
	ld [de], a
	inc de
	call CopyStrAcross
	
	ld hl, wTextboxLine2
	ld de, vTextboxLine2
	ld [hl], CURSOR_TILE
.drawChoiceText1
	rst waitVBlank
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .drawChoiceText1
	
	push hl
	ld [de], a
	inc hl
	inc de
	
.drawChoiceText2
	rst waitVBlank
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .drawChoiceText2
	
	pop hl
	
.loop
	rst waitVBlank
	ldh a, [hPressedButtons]
	rrca
	jr c, .done
	rrca
	jr nc, .checkDirections
	ld b, a
	ld a, [wDigitBuffer]
	cp MAKE_B_CHOICE
	ld a, b
	jr nz, .checkDirections
	
	ld a, CURSOR_TILE
	ld [hl], a
	ld [wTransferRows + 4], a
	xor a
	ld [wTextboxLine2], a
REPT 4
	rst waitVBlank
ENDR
	jr .done
	
.checkDirections
	and $30 >> 2
	jr z, .loop
	ld [wTransferRows + 4], a ; Next VBlank won't trigger soon, so this is ok
	and $20 >> 2
	jr nz, .goingLeft
	ld [hl], CURSOR_TILE
	xor a
	jr .writeOtherCursor
.goingLeft
	ld [hl], 0
	ld a, CURSOR_TILE
.writeOtherCursor
	ld [wTextboxLine2], a
	jr .loop
	
.done
	ld a, [hl]
	and a
	ld hl, wTextFlags
	set TEXT_ZERO_FLAG, [hl] ; Set status
	ld a, 5
	ret z ; Didn't select the second option
	res TEXT_ZERO_FLAG, [hl]
	ld a, [wDigitBuffer + 4]
	ret
	
	
SetFadeSpeed::
	ld a, [wDigitBuffer + 1]
	ld [wFadeSpeed], a
	
	ld a, 2
	ret
	
Fadein_TextWrapper::
	callacross Fadein ; Returns with a = 0
	
	inc a
	ret
	
Fadeout_TextWrapper::
	callacross Fadeout
	
	ld a, 1
	ret
	
ReloadPalettes_TextWrapper::
	callacross ReloadPalettes
	
	ld a, 1
	ret
	
	
TextLDA::
	ld hl, wDigitBuffer + 1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [hl]
	ld [wTextAcc], a
	
	ld a, 3
	ret
	
TextLDA_imm8::
	ld a, [wDigitBuffer + 1]
	ld [wTextAcc], a
	
	ld a, 2
	ret
	
TextSTA::
	ld hl, wDigitBuffer + 1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [wTextAcc]
	ld [hl], a
	
	ld a, 3
	ret
	
TextDEC::
	ld hl, wTextAcc
	ld a, [hl]
	inc [hl]
	
	inc hl
	res TEXT_CARRY_FLAG, [hl]
	and a
	jr nz, .noCarry
	set TEXT_CARRY_FLAG, [hl]
.noCarry
	
	jr INCDECCommon
	
TextINC::
	ld hl, wTextAcc
	inc [hl]
INCDECCommon:
	call UpdateTextFlags
	ld a, 1
	ret
	
TextAND::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextAcc
	and [hl]
	jr Text2ByteArithCommon
	
TextOR::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextAcc
	or [hl]
	jr Text2ByteArithCommon
	
TextXOR::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextAcc
	xor [hl]
	jr Text2ByteArithCommon
	
TextADD::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextAcc
	add a, [hl]
	jr Text2ByteArithCommon
	
TextADC::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextAcc
	adc a, [hl]
	jr Text2ByteArithCommon
	
TextCMP::
	ld a, [wDigitBuffer + 1]
	ld b, a
	ld hl, wTextAcc
	ld a, [hli]
	sub b
	jr Text2ByteArithCommon_NoWriteback
	
TextBIT::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextAcc
	and [hl]
	jr Text2ByteArithCommon_NoWriteback
	
TextSBC::
	ld a, [wDigitBuffer + 1]
	ld b, a
	ld hl, wTextAcc
	ld a, [hl]
	sbc a, b
Text2ByteArithCommon:
	ld [hli], a
Text2ByteArithCommon_NoWriteback:
	res TEXT_CARRY_FLAG, [hl]
	jr nc, .noCarry
	set TEXT_CARRY_FLAG, [hl]
.noCarry
	call UpdateTextFlags
	; a = 1
	inc a ; a = 2
	ret
	
TextADD_mem::
	ld hl, wDigitBuffer + 1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [hl]
	ld hl, wTextAcc
	add a, [hl]
	jr Text3ByteArithCommon
	
TextSUB_mem::
	ld hl, wDigitBuffer + 1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [hl]
	ld b, a
	ld hl, wTextAcc
	ld a, [hl]
	sbc a, b
Text3ByteArithCommon:
	ld [hli], a
Text3ByteArithCommon_NoWriteback:
	res TEXT_CARRY_FLAG, [hl]
	jr nc, .noCarry
	set TEXT_CARRY_FLAG, [hl]
.noCarry
	call UpdateTextFlags
	ld a, 3
	ret
	
TextSetFlags::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextFlags
	or [hl]
	jr TextFlagOpsCommon
	
TextToggleFlags::
	ld a, [wDigitBuffer + 1]
	ld hl, wTextFlags
	xor [hl]
TextFlagOpsCommon:
	ld [hl], a
	ld a, 1
	ret
	
	
TextCallFunc::
	ld hl, wDigitBuffer + 1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	rst callHL
	
	ld a, 3
	ret
	
	
InstantPrintLines::
	ld hl, wDigitBuffer + 1
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [wTextFlags]
	bit TEXT_PIC_FLAG, a ; Check if pic is there
	ld de, wTextboxPicRow1
	jr z, .picNotPresent
	ld e, wTextboxLine0 & $FF
.picNotPresent
	ld c, 3
.loop
	push de
	call TextCopyAcross
.clearLoop
	ld a, [de]
	cp $10
	jr z, .endClear
	xor a
	ld [de], a
	inc de
	jr .clearLoop
.endClear
	pop de
	ld a, SCREEN_WIDTH
	add a, e
	ld e, a
	dec c
	jr nz, .loop
	
	ld hl, wTransferRows + 2
	ld a, 3
	ld c, a ; ld c, 3
	rst fill
	
	rst waitVBlank
	rst waitVBlank
	
	ld a, 4
	ret
	
	
ReloadTextFlags::
	ld a, [wTextAcc]
UpdateTextFlags::
	ld b, a
	ld hl, wTextFlags
	ld a, [hl]
	and (1 << TEXT_CARRY_FLAG) | (1 << TEXT_PIC_FLAG) ; Reset all flags, but preserve carry and pic flag
	ld [hl], a
	
	ld a, b ; Get accumulator value
	and a ; For Z flag check
	jr nz, .noZero
	set TEXT_ZERO_FLAG, [hl]
.noZero
	rrca
	jr nc, .parityEven
	set TEXT_PARITY_FLAG, [hl]
.parityEven
	rlca
	rlca
	jr nc, .positive
	set TEXT_SIGN_FLAG, [hl]
.positive
	
	ld a, 1
	ret
	
	
TextRAMBankswitch::
	ld a, [wDigitBuffer + 1]
	call SwitchRAMBanks
	ld a, 2
	ret
	
	
EndTextWithoutClosing:: ; To do so, bypasses the end of ProcessText and directly returns to the parent. This requires removing a few things from the stack :
	; Remove return address
	; Remove read pointer
	; Remove bank
	add sp, 6
	ret ; End operations
	
	

TextFadeMusic::
	ld a, [wDigitBuffer + 1]
	call DS_Fade
	ld a, 2
	ret
	
TextPlayMusic::
	ld a, [wDigitBuffer + 1]
	call DS_Init
	ld a, 2
	ret
	
TextStopMusic::
	call DS_Stop
	ld a, 1
	ret
	
	
OverrideTextboxPalette::
	ld hl, wDigitBuffer + 1
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld c, 1
	callacross LoadBGPalette
	ld a, 3
	ret
