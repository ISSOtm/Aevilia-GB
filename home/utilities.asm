

SECTION "Utilities 1", ROM0[$0061]

; Fills bc bytes from hl
; Zeroes bc, moves hl, preserves a
Fill::
	dec c
	inc c
	jr nz, .loop
	dec b
.loop
	rst fill
	ld c, a
	ld a, b
	and a
	ld a, c
	ld c, 0
	ret z
	dec b
	jr .loop
	
; Copies bc bytes from hl to de
; Zeroes bc, moves hl and de, zeroes a
Copy::
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, Copy
	ret
	
	
; Fill c bytes in VRAM
FillVRAMLite::
	ld d, a
.fillLoop
	rst isVRAMOpen
	jr nz, .fillLoop
	ld a, d
	ld [hli], a
	dec c
	jr nz, .fillLoop
	ret
	
; Copy c bytes from hl to de, assuming de is in VRAM
; Thus, you guess what it does and that I am tired of copy-pasting that line over and over
CopyToVRAMLite::
	rst isVRAMOpen
	jr nz, CopyToVRAMLite
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, CopyToVRAMLite
	ret
	
; Copies bc bytes from de to hl
; Assumes de points to VRAM, so doesn't copy unless VRAM can be accessed
CopyToVRAM::
	rst isVRAMOpen
	jr nz, CopyToVRAM
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, CopyToVRAM
	ret
	
; Copies the string pointed to by hl to de
; Assumes de points to VRAM, so doesn't copy unless VRAM can be accessed
CopyStrToVRAM::
	rst isVRAMOpen
	jr nz, CopyStrToVRAM
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, CopyStrToVRAM
	ret
	
	
; Call routine at hl in bank b
; c and de are passed to the function intact
CallAcrossBanks::
	ldh a, [hCurROMBank]
	push af
	ld a, b
	rst bankswitch
	rst callHL
	pop af
	rst bankswitch
	ret
	
; Copy c bytes from b:hl to de
CopyAcrossLite::
	ldh a, [hCurROMBank]
	push af
	ld a, b
	rst bankswitch
	rst copy
	pop af
	rst bankswitch
	ret
	
	
; Both of these functions have a failsafe that prevents underflows and overflows
; The first prevents allowing movement if permissions are $FF
; (even though IMO this should never happen due to the second failsafe)
; The second prevents setting permissions to $FF when calling Allow while permissions are already 0
; My glitching experience has taught me this happens in many games, hence the traps
; (even though they might end up to never be triggered)
	
; Prevents joypad-induced player movement
; a equals new permissions, EXCEPT
; if it is zero (Z flag is set as well) then permissions are $FF,
; which means underflow has been prevented
PreventJoypadMovement::
	ld a, [wUnlinkJoypad]
	inc a
	and a
	ret z ; Prevent overflow, which would enable movement - not prevent it
	jr ModifyJoypadMovement
	
; Allows joypad-induced player movement
; a equals new permissions
; If Z flag is set (a will be zero) then permissions already were 0
; and underflow has been prevented
AllowJoypadMovement::
	ld a, [wUnlinkJoypad]
	and a
	ret z ; Prevent underflowing, which would lock the player's movement
	dec a
ModifyJoypadMovement:
	ld [wUnlinkJoypad], a
	ret
	
	
; FAST BOI
SpeedUpCPU::
	ld a, [rKEY1]
	rla ; Bit 7 goes into carry
	ret c ; Already at double speed
	
	jr SwitchCPUSpeed
	
; Less power-consuming
SlowDownCPU::
	ld a, [rKEY1]
	rla
	ret nc ; Not at double-speed
	
SwitchCPUSpeed:
	ld a, SELECT_NONE ; Prevent missclicking...
	ld [rJOYP], a
	ld a, 1
	ld [rKEY1], a ; Request speed switch
	ld a, [rIF] ; Save interrupts
	ld b, a
	xor a
	ld [rIF], a ; Prevent any interrupt
	stop ; GO!!
	ld a, b
	ld [rIF], a ; Restore ints
	ret
	

; hl = a * de
MultiplyDEByA::
	ld hl, 0
	and a
	ret z
.loop
	rra
	jr nc, .dontAdd
	add hl, de
	and a ; Clear carry
.dontAdd
	rl e ; Multiply de by 2
	rl d
	and a
	jr nz, .loop
	ret
