@echo off
set ROMVERSION=0
title Compiling AEVILIA GB version 1.%ROMVERSION%
echo === COMPILATION ===
rgbasm -E -p 0xFF -o obj/main.o			 main.asm
rgbasm -E -p 0xFF -o obj/battle.o		 battle.asm
rgbasm -E -p 0xFF -o obj/engine.o		 engine.asm
rgbasm -E -p 0xFF -o obj/home.o			 home.asm
rgbasm -E -p 0xFF -o obj/gfx.o			 gfx.asm
rgbasm -E -p 0xFF -o obj/maps.o			 maps.asm
rgbasm -E -p 0xFF -o obj/save.o			 save.asm
rgbasm -E -p 0xFF -o obj/sound.o		 sound.asm
rgbasm -E -p 0xFF -o obj/tileset.o		 tileset.asm
echo.
echo COMPILATION DONE
echo.
echo.
echo === LINKING ===
rgblink -m bin/Aevilia.map -n bin/Aevilia.sym -o bin/aevilia.gbc obj/main.o obj/battle.o obj/engine.o obj/home.o obj/gfx.o obj/maps.o obj/save.o obj/sound.o obj/tileset.o
echo.
echo LINKING DONE
echo.
echo.
echo === FIXING ===
rgbfix -Cjv -i ISSO -k 42 -l 0x33 -m 0x1B -n %ROMVERSION% -p 0xFF -r 0x04 -t AEVILIA bin/aevilia.gbc
echo.
echo FIXING DONE
echo.
echo.
echo FILES READY !
pause
