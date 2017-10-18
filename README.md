# Aevilia-GB

A RPG for the Game Boy Color, written in pure assembly.

Note : this is neither a tutorial nor a walkthrough for the game.


# Credits

Most programming was done by [ISSOtm](http://github.com/ISSOtm/).

[Sound engine](http://github.com/DevEd2/DevSound/) by [DevEd](http://github.com/DevEd2/) and [Pigu](http://github.com/Pigu-A/), soundtrack by DevEd.

Most graphics were drawn by [Kai](http://github.com/kaikun97).

Map-making by [Parzival](http://github.com/ParzivalWolfram/) and [Charmy](http://github.com/CharmyBee99).


# Source's contents

- _aevilia.gbc_<br/>
  The game's ROM. To obtain this, compile the source (refer further down)<br>Load it in your favorite emulator to play.<br/>
  Except if it's VBA, You already know the A doesn't stand for 'accuracy'.<br/>
- _aevilia.sym_, _aevilia.map_<br/>
  Helper files for debugging. Not required if you just want to play the game.
- _HUD.lua_<br/>
  Load it with the game in BizHawk to obtain a nice little HUD, showing collision, interaction boxes, etc.<br/>
  Again, useful for debugging, not for playing. Except maybe if TASing, as the game slows down dramatically while using it.
- _Makefile_, _rgbasm_, _rgblink_, _rgbfix_<br/>
  To build the game on systems supporting _make_ and Linux ELFs.
- _compiler.bat_, _rgbasm.exe_, _rgblink.exe_, _rgbfix.exe_<br/>
  To build the game on Windows.
- _tools/*_<br/>
  Stuff to help building and modifying Aevilia, such as a map editor.
- _doc/*_<br/>
  Incomplete (largely so) documentation on the game engine.
- _images/*_<br/>
  Resources, be it original copies before they are encoded in the game, or concept art.
- _corruptions/*_<br/>
Some fun the team had while messing with some corruptors and this very game. Note that all of these are older bulids and ~90% are unplayable.
- _obj/_<br/>
  Intermediate files for compilation. No touchy.
- The rest<br/>
  The game's source code. All the goodness for you GB ASM devs.


# Policy

The game is open-source, you are allowed and actually encouraged to modify it. DO YOUR ROM HACKS, MAN ! Just take note that there is a license, and for a reason.

You are not allowed to distribute your modified copy claiming it's the original. We (the AeviDev Team) reserve the right to shut down any modified copy of the game infringing this.

tl;dr : play by the rules and we'll support you. Don't, and... just don't.
