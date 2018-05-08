# Cloning

Please note that this repository has a submodule (DevSound) ; if the compilation process fails because of missing files, check if you correctly updated the submodules.


# Compiling

Please note that [RGBDS](http://github.com/rednex/rgbds) should be installed on your computer first. Here is a list of versions that have been confirmed to work at least once (if doubting, use the recommended version)
- [0.3.7](https://github.com/rednex/rgbds/releases/tag/v0.3.7) *recommended*
- [0.3.5](https://github.com/rednex/rgbds/releases/tag/v0.3.5)
- [0.3.4](https://github.com/rednex/rgbds/releases/tag/v0.3.4)
Release 0.3.6 has a known bug that breaks the way the game handles conditionally calling `hl`. This breaks at least the intro map, which heavily relies on the map script, which uses the broken feature.

Release 0.3.3 has worked at some point, but as per [#7](https://github.com/ISSOtm/Aevilia-GB/issues/7), it is known that compiling the game using 0.3.3 yields a broken ROM. So, this version is currently deemed non-deterministic.

## Linux

Once RGBDS is installed, Aevilia can be built using `make`. It is possible to compile either ROM individually, or any of the `.sym` files.


## Windows

You can compile from command-line (`make all -f WinMakefile`), or use the `WinCompiler.bat` file provided. This assumes you have Make installed.

Another option is to compile each file by hand. We have yet to write a Windows compilation script.

