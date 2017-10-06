
; Constants for the interactions flag dependencies
flag_dep: MACRO
	dw \1 | \2
ENDM
FLAG_RESET	equ $0000
FLAG_SET	equ $8000

FLAG_DEP	equ $80
	
	
	; Flag IDs
	; Please group by 8 to help locate them in memory !
	enum_start
	
	enum_elem	FLAG_INTRO_MAP_STATUS_0
	enum_elem	FLAG_INTRO_MAP_STATUS_1
	enum_elem	FLAG_INTRO_MAP_STATUS_2
	enum_elem	FLAG_INTRO_MAP_STATUS_3
	enum_elem	FLAG_INTRO_MAP_UNUSED
	enum_elem	FLAG_INTRO_MAP_UNUSED2
	enum_elem	FLAG_INTRO_MAP_256_FRAMES
	enum_elem	FLAG_INTRO_MAP_SKIPPED_TUTORIAL
	
	enum_elem	FLAG_INTRO_MAP_DELAY_0
	enum_elem	FLAG_INTRO_MAP_DELAY_1
	enum_elem	FLAG_INTRO_MAP_DELAY_2
	enum_elem	FLAG_INTRO_MAP_DELAY_3
	enum_elem	FLAG_INTRO_MAP_DELAY_4
	enum_elem	FLAG_INTRO_MAP_DELAY_5
	enum_elem	FLAG_INTRO_MAP_DELAY_6
	enum_elem	FLAG_INTRO_MAP_DELAY_7
	
	enum_elem	FLAG_TEST_WARRIOR_SPOKE_ONCE
	enum_elem	FLAG_STARTHAM_LARGE_HOUSE_UNLOCKED
	enum_elem	FLAG_STARTHAM_SIBLING_ENTERED
	enum_elem	FLAG_LOAD_CUTSCENE_NPCS ; Use with NPCs that should only be loaded for a cutscene (reset after loading)
	enum_elem	FLAG_SIBLING_WATCHING_TV
	