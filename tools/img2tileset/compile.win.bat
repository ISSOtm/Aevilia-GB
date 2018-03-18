@echo off
pyinstaller --onefile img2tileset.py 2> compile.log
copy build\img2tileset\warnimg2tileset.txt warn.log > nul
del build\img2tileset\*.* /f /q > nul
rmdir build\img2tileset > nul
rmdir build > nul
copy dist\*.* *.* > nul
del dist\*.* /f /q
del __pycache__\*.* /f /q
rmdir __pycache__
rmdir dist
del img2tileset.spec
