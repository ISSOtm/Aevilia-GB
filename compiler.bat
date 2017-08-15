@echo off
set ROMVERSION=0
title Compiling AEVILIA GB version 1.%ROMVERSION%
echo === COMPILATION ===
rgbasm -E -p 0xFF -o obj/aevilia.o  	 main.asm
rgbasm -E -p 0xFF -o obj/home.o     	 home.asm
rgbasm -E -p 0xFF -o obj/gfx.o      	 gfx/graphics.asm
rgbasm -E -p 0xFF -o obj/txt.o      	 engine/text.asm
rgbasm -E -p 0xFF -o obj/error_handler.o engine/error_handler.asm
rgbasm -E -p 0xFF -o obj/save.o     	 engine/save.asm
rgbasm -E -p 0xFF -o obj/map.o      	 engine/map.asm
rgbasm -E -p 0xFF -o obj/font.o          engine/font.asm
rgbasm -E -p 0xFF -o obj/thread2.o       engine/thread2.asm
rgbasm -E -p 0xFF -o obj/testmaps.o 	 maps/test.asm
rgbasm -E -p 0xFF -o obj/intromap.o 	 maps/intro.asm
rgbasm -E -p 0xFF -o obj/sound.o    	 sound/DevSound.asm
rgbasm -E -p 0xFF -o obj/battle.o   	 battle/battle_engine.asm
rgbasm -E -p 0xFF -o obj/defaultsave.o	 save/defaultsave.asm
rgbasm -E -p 0xFF -o obj/rants.o		 save/rants.asm
echo.
echo COMPILATION DONE
echo.
echo.
echo === LINKING ===
rgblink -m bin/Aevilia.map -n bin/Aevilia.sym -o bin/aevilia.gbc obj/aevilia.o obj/home.o obj/gfx.o obj/txt.o obj/error_handler.o obj/save.o obj/map.o obj/font.o obj/thread2.o obj/testmaps.o obj/intromap.o obj/sound.o obj/battle.o obj/defaultsave.o obj/rants.o
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
