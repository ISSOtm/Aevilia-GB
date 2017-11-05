
SECTION "Rant #0", ROMX[$6000]
	
SRAMCommonPattern::
	db "Well, I need to make a $1000 (minus 3! :p) byte long pattern. So I thought I would write some nice rant to fill that up, yeah?"
	ds 16
	db "First, let me give some credits to some guys who helped me quite a bit. "
	db "DevEd has been a big help, giving me his sound driver free of charge, and with some sample music tracks to help test the implementation. "
	db "avivace and Nolandis helped a bunch too, mostly with ideas. Also with some coding help."
	ds 16 * 2
	db "I'm realizing I don't have nearly enough thoughts to fill $1000 - 3 bytes, so I think I'll write stuff about developing this game?"
	ds 16
	db "This actually started as a PC game, but I had too much trouble finding a correct graphics library. It was fun nonetheless, and maybe a good C exercise. "
	db "But I went back to a platform I mastered quite well, the GB. I already had graphics (unless I changed this, they should be loaded in tileset #0. Try loading map #0), "
	db "but they were colorized. I got lazy and thought to myself: \"Fuck grayscale compatibility.\". Also I think, now, nobody has only a DMG. And this will probably be played on emulators anyways."
	ds 16
	db "So I started by doing the init code - y'know, clear out the whole VRAM, WRAM, HRAM and OAM. And checking which console I am on. "
	db "I also added most code you can see before $100. I call it \"my asm stdlib\". Tough times choosing what to put as RST's."
	ds 16
	db "I'm not sure what came next. Probably the VBlank handler. I thought about what features I might need \"detached\" from the main game code. "
	db "First was WRAM SCX/Y, WX/Y, things like that. Somehow the next thing was screen shake. I also tried to implement distort in HBlank, but it was too difficult, mostly because of lack of CPU time. "
	db "When it comes to the GB(C), you're golden as a programmer. You got nice raster interrupts (I'm lol-ing at the NES right now. :D), not too many hardware bugs... What could go wrong?"
	ds 16
	db "The VRAM. The VRAM is a bitch. Never there when you need it. "
	db "CopyToVRAM, CopyAcrossToVRAM... tough times writing some of those. Also tough times trying to use \"normal\" functions in their stead, like right after VBlanking. Saves some CPU. "
	db "Saving CPU is soooo important, man. Now it's less so, I guess, but on a GB, the more time you spend in HALT - CPU idle, waiting for an interrupt - the more battlery you save. "
	db "That's also why right now the game doesn't use double-speed mode. It sucks up battery dry."
	ds 16 * 2
	db "When making the overworld engine, I had three things in mind. "
	ds 16
	db "1. Diagonal movement MUST be a thing. "
	db "2. The player MUST move pixel by pixel, not on a grid. Biggest challenge for an 8-bit game, probably. "
	db "3. Speed MUST be a variable. I didn't want to implement subpixels, though, because even though they may look better they tend to create massive movement-related bugs. "
	db "Also EarthBound taught me subpixels don't look so good with diagonal movement."
	ds 16
	db "EarthBound is great by the way. It inspired me lots. Think about the text engine - EarthBound's is a huge mess - but it's pretty darn powerful. "
	db "So powerful it might be possible to make the engine run an emulator. Why not. "
	db "I wanted to have that, too: a text engine very powerful."
	ds 16
	db "It's kinda what happened. It's got some direct memory manipulation capabilities, as well as a basic ALU. add, sub, bit, set, res. And ld. Not very complex, but at least pretty flexible. "
	db "Change a constant (the max command ID), add a pointer to your new func, have it read its arguments from the buffer, and return the number of bytes consumed in a. Easy!"
	ds 16 * 2
	db "Oh, I am reaching the limit here. Gonna pad this with a few $FF bytes, and it's time to say goodbye :)"
SRAMCommonEnd::
	ds ($1000 - 4) - (SRAMCommonEnd - SRAMCommonPattern) - 1
	db 0
	
	
; SECTION "Rant #1", ROMX[$7000]
	
SRAMFirstBootPattern::
	db "AEVILIA GB"
	ds 16
	db "CREDITS"
	ds 16 * 2
	db "PROGRAMMING"
	ds 16
	db "ISSOtm  (Eldred Habert)"
	ds 16
	db "DevEd  (Edward Whalen)"
	ds 16 * 2
	db "LEAD GRAPHICS"
	ds 16
	db "Kaikun97 (Kai)"
	ds 16 * 2
	db "GRAPHICS"
	ds 16
	db "Mian"
	ds 16
	db "Citx"
	ds 16
	db "Alpha"
	ds 16
	db "ISSOtm"
	ds 16 * 2
	db "SOUND"
	ds 16
	db "DevEd"
	ds 16 
	db "MAP FORGING"
	ds 16
	db "ISSOtm"
	ds 16
	db "Parzival Wolfram"
	ds 16
	db "Kaikun97 (Kai)"
	ds 16 * 2
	db "TESTING AND DEBUGGING"
	ds 16
	db "Parzival Wolfram"
	ds 16
	db "Charmy"
	ds 16
	db "Kai"
	ds 16
	db "Citx"
	ds 16 * 2
	db "SPECIAL 3DS SUPPORT"
	ds 16
	db "Parzival Wolfram"
	ds 16 * 2
	db "SPECIAL THANKS"
	ds 16
	db "Extra Credits  (Check out their YouTube channel, they give awesome tips on game design)"
	ds 16
	db "Celeste, for her support"
	ds 16
	db "gbdev wiki, for their cool resources"
	ds 16
	db "gbdev Discord, for their help and feedback"
	ds 16
	db "Bas Steendijk, for BGB being a superb emulator amazing for development. Making the text smooth-scroller without this quality of an emulator would have been a nightmare."
	ds 16
	db "Carsten Sorensen, for RGBDS. Pretty good compiler, has its problems but at least it compiles nicely."
	ds 16
	db "By the way, I hate GBDK."
	ds 16
	db "GCL forums, for getting me into GB stuff"
	ds 16
	db "GCL Discord, for the amazing shitposting there"
	ds 16
	db "Game Freak, thank you very very VERY much for Red/Blue/Yellow being so broken! It's fun STILL finding bugs in your code :D"
	ds 256
	db "Maybe I should also credit you for taking time to read your save as text. Here is some info on how save files work, if you're interested."
	ds 16
	db "You'll probably figure out the save files are checksummed, but I'm giving ya a hint: they are also check-XOR'ed. "
	db "By that I mean the game does an operation on each block of $40 bytes in $A100-$AFFF. It calculates the sum (modulo 256) and XOR of all bytes in that block. "
	db "That makes the check on the whole block. So you might guess the game re-calculates these when loading, and if anything doesn't match... guess what happens, lol."
	ds 16
	db "You may have guessed that $A000-$A0FF is the header. Quick math will give you that $F8 bytes must be used for checksumming. "
	db "So, in the first 8 bytes, there is a string, which is just there to act as a cookie. Y'know, if it's ever overwritten, everything blows up. "
	db "I just needed a sting 7 chars long (plus NULL, that's 8 bytes, lining up neatly). \"AEVILIA\" fitted just right... by pure coincidence. So it's there. "
	db "Unless I change it later?"
	
SRAMFirstBootEnd::
	ds $1000 - (SRAMFirstBootEnd - SRAMFirstBootPattern) - 1
	db 0
	
