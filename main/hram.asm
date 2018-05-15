
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
; If bit 6 is non-zero, palettes will not be committed to the screen when loaded via LoadBG/OBJPalette
;  (use ReloadPalettes after)
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
	
; Parameters transferred to the corresponding registers on each VBlank
; The idea is that these can be edited anytime
; Also, this SCX is pre-screen shake, and WX and WY are ignored if hEnableWindow is zero
hSCY::
	ds 1
hSCX::
	ds 1
; Both of these are ignored if wEnableWindow is zero
hWY::
	ds 1
hWX::
	ds 1
	
; Controls whether the window should be displayed or not
; The window will be displayed anyways if the text box is active!
hEnableWindow::
	ds 1
	
; Controls how the screen should shake
; The screen moves one pixel laterally per frame
; This controls the amplitude of the effect
; 2 means the screen will oscillate between -2 and +2 like this :
; 0 -> 1 -> 2 -> 1 -> 0 -> -1 -> -2 -> -1 -> repeat
hScreenShakeAmplitude::
	ds 1
; Holds the current displacement applied to wSCX
; Ensure the displacement is within bounds - no error checking is done. This would simply produce a graphical oddity
; Avoiding editing this manually altogether is better IMHO
; This is zeroed when the amplitude is reset
hScreenShakeDisplacement::
	ds 1
	
; If this is zero, VBlank will transfer wVirtualOAM
; Otherwise, this will be cleared, and VBlank will transfer wStagedOAM instead
hOAMMode::
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
	
	
hTextboxLY::
	ds 1
	
; This is used by the STAT handler to help perform various effects
hSpecialEffectsLY:: ; Scanline at which the effect should happen
	ds 1
hSpecialEffectsBuf:: ; Pair (ID ; value), where value will be written to [rSCY + (ID - 1 & 9)]
	ds 2
	
hThread2ID::
	ds 1
hHDMALength:: ; Used by Thread 2 to know if HDMA can be used
	ds 1
	
UNION

hLoadingDoorAnimCount::
	ds 1
hLoadingFinalCount::
	ds 1
	
NEXTU
	
hLoadingWalkDirection::
	ds 1
hLoadingStepCounter::
	ds 1
	
NEXTU
	
hCloudScrollCount::
	ds 1
	
ENDU
	
	
; Set when HDMA is being used by something
hHDMAInUse::
	ds 1
	
	
; Contains the ID of the currently processed animation
hCurrentAnimationID::
	ds 1
hCurrentAnimation::
	ds 2
	
