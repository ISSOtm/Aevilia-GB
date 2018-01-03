
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
	enum_start
	enum_elem ERR_UNKNOWN
	enum_elem ERR_PC_IN_RAM
	enum_elem ERR_DIV_BY_ZERO
	enum_elem ERR_WRONG_WARP
	enum_elem ERR_BAD_MAP
	enum_elem ERR_BATT_TRANS
	enum_elem ERR_BAD_ENEMY
	enum_elem ERR_BAD_THREAD2
	enum_elem ERR_MAX

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

TEXTBOX_MOVEMENT_SPEED	EQU 4

; -------------- MAP ----------------
NB_OF_NPCS		EQU 8
NO_SCRIPT		EQU $0000
OPEN_DOOR_FIRST_TILE	EQU $B1


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

ROM_VERSION		EQU 0

