import urllib
import os
import time
print "AEVILIA GB Online Makefile Wrapper\nWritten in Py2 by Parzival\nVersion COMPILER.TESTER12"
time.sleep(3)
print "Downloading dependencies... (1.2MB)"
linkone = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/dependencies.zip"
linktwo = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/7za.exe"
urllib.urlretrieve(linkone,"dependencies.zip")
print "Downloading decompression utility... (574KB)"
urllib.urlretrieve(linktwo,"7za.exe")
print "Decompressing dependencies..."
os.system("7za e dependencies.zip -y")
print "Building AEVILIA GB ROM..."
os.system("make all Makefile")
print "Cleaning up..."
os.system("make clean Makefile")
os.system("del lib*.dll")
os.system("del msvc*.dll")
os.system("del make.exe")
os.system("del dependencies.zip")
os.system("del 7za.exe")
print "Done! Exiting in 5 seconds..."
time.sleep(5)
