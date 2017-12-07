

; Song IDs

	enum_start
	enum_elem MUSIC_SAFE_PLACE
	enum_elem MUSIC_BATTLE_1
	enum_elem MUSIC_FILESELECT
	enum_elem MUSIC_OVERWORLD
	enum_elem MUSIC_BOSS_1
	enum_elem MUSIC_SCARECHORD
	enum_elem MUSIC_NEO_SAFE_PLACE
	enum_elem MUSIC_AVOCADO_INVADERS
	
	enum_elem MUSIC_INVALIDTRACK ; IDs >= this are invalid (except $FF)
	
	enum_set $FF
	enum_elem MUSIC_NONE
	
	
	enum_start
	enum_elem MUSICFADE_OUT
	enum_elem MUSICFADE_IN
	enum_elem MUSICFADE_OUT_STOP
	
	enum_start
	enum_elem SFX_NPC_SURPRISE
	enum_elem SFX_TEXT_CONFIRM
	enum_elem SFX_TEXT_DENY
	enum_elem SFX_STAIRS
	enum_elem SFX_TEXT_ADVANCE
	enum_elem SFX_BATTLE_THUD
	enum_elem SFX_MISC_BELL
	enum_elem SFX_PHONE_RINGING
	enum_elem SFX_PHONE_HANG_UP
	enum_elem SFX_DOOR_KNOCK
	enum_elem SFX_MISC_ZAP
	enum_elem SFX_TEXT_SELECT
	enum_elem SFX_DOOR_OPEN
	enum_elem SFX_MENU_OPEN
	enum_elem SFX_MISC_RUMBLE		; loop this sound every 8 frames (could also be used as a "distant thud" sound)
	enum_elem SFX_NPC_JUMP
	enum_elem SFX_ARCADE_SHOOT
	enum_elem SFX_ARCADE_HIT_ENEMY
	enum_elem SFX_ARCADE_UFO		; loop this sound every 24 frames
	enum_elem SFX_ARCADE_POWERUP
	enum_elem SFX_ARCADE_YOU_LOSE
	
	enum_set $FF
	enum_elem SFX_NONE


; ================================================================
; DevSound constants
; ================================================================

; Note values

C_2		equ	$00
C#2		equ	$01
D_2		equ	$02
D#2		equ	$03
E_2		equ	$04
F_2		equ	$05
F#2		equ	$06
G_2		equ	$07
G#2		equ	$08
A_2		equ	$09
A#2		equ	$0a
B_2		equ	$0b
C_3		equ	$0c
C#3		equ	$0d
D_3		equ	$0e
D#3		equ	$0f
E_3		equ	$10
F_3		equ	$11
F#3		equ	$12
G_3		equ	$13
G#3		equ	$14
A_3		equ	$15
A#3		equ	$16
B_3		equ	$17
C_4		equ	$18
C#4		equ	$19
D_4		equ	$1a
D#4		equ	$1b
E_4		equ	$1c
F_4		equ	$1d
F#4		equ	$1e
G_4		equ	$1f
G#4		equ	$20
A_4		equ	$21
A#4		equ	$22
B_4		equ	$23
C_5		equ	$24
C#5		equ	$25
D_5		equ	$26
D#5		equ	$27
E_5		equ	$28
F_5		equ	$29
F#5		equ	$2a
G_5		equ	$2b
G#5		equ	$2c
A_5		equ	$2d
A#5		equ	$2e
B_5		equ	$2f
C_6		equ	$30
C#6		equ	$31
D_6		equ	$32
D#6		equ	$33
E_6		equ	$34
F_6		equ	$35
F#6		equ	$36
G_6		equ	$37
G#6		equ	$38
A_6		equ	$39
A#6		equ	$3a
B_6		equ	$3b
C_7		equ	$3c
C#7		equ	$3d
D_7		equ	$3e
D#7		equ	$3f
E_7		equ	$40
F_7		equ	$41
F#7		equ	$42
G_7		equ	$43
G#7		equ	$44
A_7		equ	$45
A#7		equ	$46
B_7		equ	$47
C_8		equ $48
rest	equ	$49
___		equ	$4A
release	equ	$4B
rel		equ	release

fix		equ	C_2

; Command definitions

SetInstrument		equ	$80
SetLoopPoint		equ	$81
GotoLoopPoint		equ	$82
CallSection			equ	$83
SetChannelPtr		equ	$84
PitchBendUp			equ	$85
PitchBendDown		equ	$86
SetSweep			equ	$87
SetPan				equ	$88
SetSpeed			equ	$89
SetInsAlternate		equ	$8a
RandomizeWave		equ	$8b
CombineWaves		equ	$8c
EnablePWM			equ	$8d
EnableRandomizer	equ	$8e
DisableAutoWave		equ	$8f
Arp					equ	$90
TonePorta			equ	$91
ChannelVolume		equ	$92
DummyCommand		equ	$93
EndChannel			equ	$FF
