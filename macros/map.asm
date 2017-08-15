
map_size: MACRO
	db \1, \2
ENDM

; Header for a struct that can be parsed by ScanForInteraction
; interact_box ypos xpos ysize xsize
interact_box: MACRO
	dw \1
	dw \2
	db \3
	db \4
ENDM
