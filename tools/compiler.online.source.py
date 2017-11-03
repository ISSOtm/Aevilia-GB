import urllib
import os
import time

print "AEVILIA GB Online Makefile Wrapper\nWritten in Py2 by Parzival\nVersion COMPILER.TESTER12"
print "This version downloads repacked files from a server in order to run them. \nIf you don't like this, use the Offline Wrapper. It'll tell you what you need to download."
print "\nDownload will begin in 30 seconds. Total size: 3 MB"
time.sleep(30)

print "Downloading dependencies... (1.2MB)"

linkone = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/dependencies.zip"

linktwo = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/7za.exe"

urllib.urlretrieve(linkone,"dependencies.zip")

print "Downloading decompression utility... (574KB)"

urllib.urlretrieve(linktwo,"7za.exe")

print "Decompressing dependencies...\n"

os.system("7za e dependencies.zip -y")

print "\nBuilding AEVILIA GB ROM...\n"

os.system("make all \%CD\%\\Makefile")

print "\nCleaning up...\n"

os.system("del lib*.dll")
os.system("del msvc*.dll")
os.system("del make.exe")
os.system("del dependencies.zip")
os.system("del 7za.exe")

print "Done! Exiting in 5 seconds..."

time.sleep(5)