# Aevilia GB

A RPG for the Game Boy Color, written in pure Sharp LR35602 (aka GBz80) assembly.

Note : this is neither a tutorial nor a walkthrough for the game.


- [Licensing](#licensing)
- [Contents](#contents)
- [Credits](#credits)
- [Contact](#contact)


# Compiling The Game

If you are looking for one of stable versions, check out the [stable releases](http://github.com/ISSOtm/Aevilia-GB/releases/tag/stable) page.

If you want to build the ROM from source, please refer to the [INSTALL.md](http://github.com/ISSOtm/Aevilia-GB/blob/master/INSTALL.md) file.


# Running The Game

To play the game, you can either play it on hardware, or use an emulator.

For hardware, we recommend the [Everdrive X5](https://krikzz.com/store/home/47-everdrive-gb.html) flashcart, although any flashcart should work. We may also release cartridges of the game, when it's finished.

If you're looking for emulator advice, check out [our wiki page](http://github.com/ISSOtm/Aevilia-GB/wiki/Emulators) about that.


# Licensing

Aevilia is licensed under the Apache 2.0 license (please refer to the [LICENSE](http://github.com/ISSOtm/Aevilia-GB/blob/master/LICENSE) file).

[DevSound](http://github.com/DevEd2/DevSound/) is licensed under the MIT license (please refer to [its own LICENSE file](http://github.com/DevEd2/DevSound/blob/master/LICENSE)).

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


# Credits

Most programming was done by [ISSOtm](http://github.com/ISSOtm/).

[Sound engine](http://github.com/DevEd2/DevSound/) by [DevEd](http://github.com/DevEd2/) and [Pigu](http://github.com/Pigu-A/), soundtrack by [DevEd](http://github.com/DevEd2/).

Most graphics were drawn by [Kai](http://github.com/kaikun97).

Map-making by [Parzival](http://github.com/ParzivalWolfram/) and [Charmy](http://github.com/CharmyBee99).


# Contact

Replace "@..." with "@gmail.com" in any of these.
- ISSOtm   : eldredhabert0@... (if you speak French, that's my main language !)
- DevEd    : deved8@...
- Parzival : parzivalwolfram@...
- Charmy   : amazingcharm4757@...
