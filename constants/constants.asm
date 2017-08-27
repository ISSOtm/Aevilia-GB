
; ------------- JOYPAD --------------
SELECT_DPAD		EQU (1 << 5)
SELECT_BUTTONS 	EQU (1 << 4)
SELECT_NONE		EQU (SELECT_BUTTONS | SELECT_DPAD)

DPAD_DOWN		EQU (1 << 7)
DPAD_UP			EQU (1 << 6)
DPAD_LEFT		EQU (1 << 5)
DPAD_RIGHT		EQU (1 << 4)

BUTTON_START	EQU (1 << 3)
BUTTON_SELECT	EQU (1 << 2)
BUTTON_B		EQU (1 << 1)
BUTTON_A		EQU (1 << 0)

; ---------- ERROR CODES ------------
ERR_UNKNOWN		EQU 0
ERR_PC_IN_RAM	EQU 1
ERR_DIV_BY_ZERO	EQU 2
ERR_WRONG_WARP	EQU 3
ERR_BAD_MAP		EQU 4
ERR_BATT_TRANS	EQU 5
ERR_BAD_ENEMY	EQU 6
ERR_BAD_THREAD2	EQU 7
ERR_MAX			EQU 8

; ---------- THREAD 2 IDS -----------
THREAD2_DISABLED	EQU 0
THREAD2_OPENDOOR	EQU 1
THREAD2_MAX			EQU 2

; -------------- GFX ----------------
LY_VBLANK		EQU $90
SCREEN_WIDTH	EQU 20
SCREEN_HEIGHT	EQU 18

TILE_SIZE		EQU 8 ; Size of a tile in pixels

MAX_CAM_SPEED	EQU 15	; A row / column of tiles can be updated in a frame, but no more.
						; Avoid making the camera faster than 16 px/frame! I think 16 px looks weird, though, so it's 15.

VRAM_TILE_SIZE	EQU 16 ; Size of a tile in VRAM
VRAM_ROW_SIZE	EQU $20 ; Size of a row of tiles in VRAM

TITLE_NAME_DEST	EQU $9865

; -------------- MAP ----------------
NB_OF_NPCS		EQU 8
NO_SCRIPT		EQU $0000


; ------------- WARPS ---------------
NO_WALKING		EQU 0
KEEP_WALKING	EQU 1


; ------------ DIRECTION ------------
	enum_start
	enum_elem DIR_UP
	enum_elem DIR_DOWN
	enum_elem DIR_LEFT
	enum_elem DIR_RIGHT


; ---------- INTERACTIONS -----------
WALK_INTERACT	EQU 0
BTN_INTERACT	EQU 1
WALK_LOADZONE	EQU 2
BTN_LOADZONE	EQU 3

; ------------- BATTLE --------------
MAX_BATT_TRANS	EQU 1
MAX_BATT_ID		EQU 1

; -------------- MISC ---------------
SRAM_UNLOCK		EQU $0A

CONSOLE_CRAP	EQU $00
CONSOLE_3DS		EQU $01
CONSOLE_DECENT	EQU $02
CONSOLE_GBC		EQU $03
CONSOLE_GBA		EQU $04

LFSR_MASK		EQU $2A ; Arbitray, modify this if needed

