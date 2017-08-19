# Aevilia-GB

A RPG for the Game Boy Color, written in pure assembly.

Note : this is neither a tutorial nor a walkthrough for the game.


# Source's contents

- _aevilia.gbc_<br/>
  The game's ROM. Load it in your favorite emulator to play.<br/>
  Except if it's VBA, You already know the A doesn't stand for 'accuracy'.<br/>
- _aevilia.sym_, _aevilia.map_<br/>
  Helper files for debugging. Not required if you just want to play the game.
- _HUD.lua_<br/>
  Load it with the game in BizHawk to obtain a nice little HUD, showing collision, interaction boxes, etc.<br/>
  Again, useful for debugging, not for playing. Except maybe if TASing.
- _Makefile_, _rgbasm_, _rgblink_, _rgbfix_<br/>
  To build the game on systems supporting _make_ and Linux ELFs. Includes Linux and Linux Subsystem for Windows.
- _compiler.bat_, _rgbasm.exe_, _rgblink.exe_, _rgbfix.exe_<br/>
  To build the game on Windows. Wine is probably fine, too. But why doing thi--
- _TODO.txt_<br/>
  Peek at the """upcoming""" features of the game !
- _tools/*_<br/>
  Stuff to help building and modifying Aevilia, such as a map editor.
- _doc/*_<br/>
  Incomplete (largely so) documentation on the game engine.
- _images/*_<br/>
  Resources, be it original copies before they are encoded in the game, or concept art.
- _obj/_<br/>
  Intermediate files for compilation. No touchy.
- The rest<br/>
  The game's source code. All the goodness for you GB ASM devs.


# Policy

The game is open-source, you are allowed and actually encouraged to modify it. DO YOUR ROM HACKS, MAN ! Just take note that there is a license, and for a reason.

You are not allowed to distribute your modified copy claiming it's the original. We (the Aevilia Dev Team) reserve the right to shut down any modified copy of the game infringing this.

tl;dr : play by the rules and we'll support you.
