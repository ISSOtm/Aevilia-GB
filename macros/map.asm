
map_size: MACRO
	db \1, \2
ENDM

; Header for a struct that can be parsed by ScanForInteraction
; interact_box ypos, xpos, ysize, xsize
interact_box: MACRO
	dw \1
	dw \2
	db \3
	db \4
ENDM

; interaction ypos, xpos, ysize, xsize, textPtr
interaction: MACRO
	interact_box \1, \2, \3, \4
	dw \5
	ds 8
ENDM

; load_zone ypos, xpos, ysize, xsize, thread2, destWarp, destMap
load_zone: MACRO
	interact_box \1, \2, \3, \4
	db \5 ; Thread 2
	db \6 ; Warp ID
	db \7 ; Map ID
	ds 7
ENDM

; npc ypos, xpos, ysize, xsize, interactID, sprite, dir, palettes (*4), movtPerms, movtSpeed
npc: MACRO
	interact_box \1, \2, \3, \4
	db \5
	db \6 << 2 | \7
	shift
	shift
	dn \6, \7, \8, \9
	REPT 2
		shift
		db \9
	ENDR
ENDM

; warp_to ypos, xpos, dir, flags, cameramanID, thread2, loadScript
warp_to: MACRO
	dw \1 ; Y pos
	dw \2 ; X pos
	db \3 ; Direction
	db \4 ; Flags
	db \5 ; Cameraman ID
	db \6 ; Thread 2 ID
	dw \7 ; Loading script
	ds 6
ENDM
