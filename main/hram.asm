
SECTION "QuickRAM", HRAM
; Check the CONSOLE_* constants for the types.
hConsoleType::
	ds 1

hCurRAMBank::
	ds 1
hCurROMBank::
	ds 1
	
	
; Flags for graphics
; If bit 7 is non-zero, will trigger the compensation for GBA screens
hGFXFlags::
	ds 1
	
	
; Layout of these : DOWN-UP-LEFT-RIGHT-START-SELECT-B-A
; Bit 1 = button active (unlike the port it is pulled from, eh?)
; Buttons currently held
hHeldButtons::
	ds 1
; Buttons pressed on this frame
hPressedButtons::
	ds 1
; 1 if the START+SELECT+A+B button combo should not trigger a soft reset
hPreventSoftReset::
	ds 1
; A mask applied to hPressedButtons in the overworld
hOverworldButtonFilter::
	ds 1
; Overworld copies of corresponding bytes, to avoid issues caused by lag (which would refresh hHeldButtons and hPressedButtons mid-processing)
hOverworldHeldButtons::
	ds 1
hOverworldPressedButtons::
	ds 1
	
	
; Incremented by the VBlank handler
hFrameCounter::
	ds 1
	
; Incremented on each overworld loop iteration
hOverworldFrameCounter::
	ds 1
; Set to 1, usually by the map script, to ignore the player's actions for a single frame
hIgnorePlayerActions::
	ds 1
	
; Set to 1 if the current overworld frame should be aborted, e.g. when a new map is loaded mid-frame.
hAbortFrame::
	ds 1
	
	
; Serves currently no purpose, but should be used later to check which rendering mode is active
; (Either scrollable in all directions, or fully fixed)
hTilemapMode::
	ds 1
	
	
; Set if the game's SRAM has been limited to 32k by the emulator
; Disables most SRAM features, and restricts saving to banks 2 and 3. Plus, no backup.
hSRAM32kCompat::
	ds 1
	
	
hDMAScript::
	ds 5
	
hRandInt::
hRandIntLow::
	ds 1
hRandIntHigh::
	ds 1
	
hThread2ID::
	ds 1
hHDMALength:: ; Used by Thread 2 to know if HDMA can be used
	ds 1
hLoadingDoorAnimCount::
hLoadingWalkDirection::
	ds 1
hLoadingFinalCount::
	ds 1
	
	
; Set when HDMA is being used by something
hHDMAInUse::
	ds 1
	
