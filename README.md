# Aevilia-GB

A RPG for the Game Boy Color, written in pure Sharp LR35602 (aka GBz80) assembly.

Note : this is neither a tutorial nor a walkthrough for the game.


# Credits

Most programming was done by [ISSOtm](http://github.com/ISSOtm/).

[Sound engine](http://github.com/DevEd2/DevSound/) by [DevEd](http://github.com/DevEd2/) and [Pigu](http://github.com/Pigu-A/), soundtrack by [DevEd](http://github.com/DevEd2/).

Most graphics were drawn by [Kai](http://github.com/kaikun97).

Map-making by [Parzival](http://github.com/ParzivalWolfram/) and [Charmy](http://github.com/CharmyBee99).


# A Note on Compiling

On Linux, compiling is done by typing `make` while in the root folder of this repository.


There are two EXEs for compiling: _compiler.offline.exe_, _compiler.online.exe_. These two EXEs are simply compiled versions of the `.py` files found in the `tools/` repository, so if you have Python and prefer to run them, copy them out of the `tools/` folder and run them (with Python 2.X).

_compiler.offline.exe_ ("the Offline compiler") is for those who want to compile the ROM without sacrificing the ability to have a stroke in the process.
The program will tell you exactly what you need to install (a lot) to get the five or so files you need on your system for compiling to work. There's also no instructions on how you need to set these downloaded programs up properly (yet). It's the Online compiler for the paranoid.

_compiler.online.exe_ ("the Online compiler") is for those who are willing to let the program automatically download six or seven files and run them (and then delete them because no one likes clutter) so you can have your shiny new ROM with a one-click solution. The total download size is about 30MB, so it's light enough for those on tight bandwidths and/or mobile tethering and/or dial-up, too. The ultimate convenience tool!


# Licensing

Aevilia is licensed under the Apache 2.0 license (please refer to the [LICENSE](http://github.com/ISSOtm/Aevilia-GB/blob/master/LICENSE) file).

[DevSound](http://github.com/DevEd2/DevSound/) is licensed under the MIT license (please refer to [its own LICENSE file](http://github.com/DveEd2/DevSound/blob/master/LICENSE)).

The gist of these licenses is that re-use of the code/assets present in these repositories is allowed, even for commercial uses, as long as the licenses are included, and the modifications are clearly stated (in the case of Aevilia's license). If you want more info, you can always read the whole licenses (although I wish that to nobody), ask us (there's contact info below), or even just google what you're allowed to do.


# Contents

- _bin/aevilia.gbc_<br/>
  The game's ROM. To obtain this, compile the source (refer further down)<br>Load it in your favorite emulator to play.<br/>
  Except VBA. You already know the A doesn't stand for 'accuracy'.<br/>
- _bin/aevilia.sym_, _bin/aevilia.map_<br/>
  Helper files for debugging, also generated when compiling. Not required if you just want to play the game.
- _bin/HUD.lua_<br/>
  Load it with the game in BizHawk to obtain a nice little HUD, showing collision, interaction boxes, etc.<br/>
  Again, useful for debugging, not for playing. Except maybe if TASing, as the emulator slows down a lot (20~40 fps) while using it.
- _compiler.offline.exe_, _compiler.online.exe_<br/>
  Help build the game on Windows.
- _tools/*_<br/>
  Stuff to help building and modifying Aevilia, such as a map editor.
- _doc/*_<br/>
  Incomplete (largely so) documentation on the game engine.
- _images/*_<br/>
  Resources, be it original copies before they are encoded in the game, or concept art.
- _corruptions/*_<br/>
  Some fun the team had while messing with corruptors and this very game. Note that all of these are older builds and ~90% are unplayable.


# Contacting us

Replace "@..." with "@gmail.com" in any of these

ISSOtm   : eldredhabert@... (if you speak French, that's my main language !)

DevEd    : deved8@...

Parzival : parzivalwolfram@...
  
