# Cloning

Please note that this repository has a submodule (DevSound) ; if the compilation process fails because of missing files, check if you correctly updated the submodules.


# Compiling

Please note that [RGBDS](http://github.com/rednex/rgbds) should be installed on your computer first. Versions prior to [0.3.3](https://github.com/rednex/rgbds/releases/tag/v0.3.3) will not work, and later versions aren't guaranteed to work.

## Linux

Once RGBDS is installed, Aevilia can be built using `make`. It is possible to compile either ROM individually, or any of the `.sym` files.


## Windows

You can compile from command-line (`make all -f WinMakefile`), or use the `WinCompiler.bat` file provided. This assumes you have Make installed.

Another option is to compile each file by hand. We have yet to write a Windows compilation script.

