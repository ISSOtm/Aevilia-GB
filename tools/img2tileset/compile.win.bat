@echo off
pyinstaller --onefile img2tileset.py 2> compile.log
copy build\img2tileset\warnimg2tileset.txt warn.log > nul
del build\img2tileset\*.* /f /q > nul
rmdir build\img2tileset > nul
rmdir build > nul
move dist\*.* *.* > nul
rmdir dist
