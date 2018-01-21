
SECTION	"DevSound entry points",ROM0

DevSound_JumpTable:

DS_Init::
	ld c, a
	ld [wCurrentMusicID], a
	jpacross	DevSound_Init	
DS_Play::
	jpacross	DevSound_Play
DS_Stop::
	jpacross	DevSound_Stop
DS_Fade::
	ld c, a
	jpacross	DevSound_Fade

