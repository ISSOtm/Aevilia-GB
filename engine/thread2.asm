
INCLUDE "macros.asm"
INCLUDE "constants.asm"

SECTION "Thread 2 pointers and functions", ROMX
	
Thread2Ptrs::
	dw OpenDoorAnim
	
OpenDoorAnim::
	ret

