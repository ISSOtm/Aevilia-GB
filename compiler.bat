@echo off
set /p VER=<version.txt
set /p BUILD=<build.txt
title AEVILIA GB version %VER% build %BUILD%

if NOT exist bin/	mkdir bin
if NOT exist obj/	mkdir obj

echo AEVILIA GB version %VER% build %BUILD%

echo === Compiling... ===
rgbasm -E -p 0xFF -o obj/main.o			 main.asm
rgbasm -E -p 0xFF -o obj/battle.o		 battle.asm
rgbasm -E -p 0xFF -o obj/engine.o		 engine.asm
rgbasm -E -p 0xFF -o obj/home.o			 home.asm
rgbasm -E -p 0xFF -o obj/gfx.o			 gfx.asm
rgbasm -E -p 0xFF -o obj/maps.o			 maps.asm
rgbasm -E -p 0xFF -o obj/save.o			 save.asm
rgbasm -E -p 0xFF -o obj/sound.o		 sound.asm
rgbasm -E -p 0xFF -o obj/text.o          text.asm
rgbasm -E -p 0xFF -o obj/tileset.o		 tileset.asm
echo.
echo Compile finished.
echo.
echo.

echo === Linking... ===
rgblink -m bin/Aevilia.map -n bin/Aevilia.sym -o bin/aevilia.gbc obj/main.o obj/battle.o obj/engine.o obj/home.o obj/gfx.o obj/maps.o obj/save.o obj/sound.o obj/text.o obj/tileset.o
echo.
echo Linking finished.
echo.
echo.

echo === Fixing... ===
rgbfix -Cjv -i ISSO -k 42 -l 0x33 -m 0x1B -n %BUILD% -p 0xFF -r 0x04 -t AEVILIA bin/aevilia.gbc
echo.
echo Fixing finished.
echo.
echo.

echo Build successful.
pause
