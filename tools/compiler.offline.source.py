import urllib

import os

import time

print "AEVILIA GB Makefile Wrapper\nWritten in Py2 by Parzival\nVersion COMPILER.PARANOIA"

print "If you don't have them, you need to install these dependencies:\nMAKE - http://gnuwin32.sourceforge.net/downlinks/make.php\nLibIntl - http://gnuwin32.sourceforge.net/downlinks/libintl.php\nLibIconv - http://gnuwin32.sourceforge.net/downlinks/libiconv.php\nVisual Studio 6.0 Runtime - https://www.microsoft.com/en-us/download/details.aspx?id=24417\nVisual C++ Redist 2005 - https://www.microsoft.com/en-us/download/details.aspx?id=3387\nVisual  C++ Redist 2008 - https://www.microsoft.com/en-us/download/details.aspx?id=29\nVisual C++ Redist 2010 - https://www.microsoft.com/en-us/download/details.aspx?id=5555\nOptional: Python 2.7.14+, x86 - https://www.python.org/ftp/python/2.7.14/python-2.7.14.msi\n\nYou have 30 seconds to copy these links and close the program.\nIf they're already installed or you've walked away from your keyboard\nto piss or something, we'll start the process after the 30 seconds are up.\n\n"
time.sleep(30)

#print "Downloading dependencies... (1.2MB)"

#linkone = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/dependencies.zip"

#linktwo = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/7za.exe"

#urllib.urlretrieve(linkone,"dependencies.zip")

#print "Downloading decompression utility... (574KB)"

#urllib.urlretrieve(linktwo,"7za.exe")

#print "Decompressing dependencies..."

#os.system("7za e dependencies.zip -y")

print "Alright. I\'m gonna assume all of these are installed correctly and on your PATH. Let's build!"
print "Building AEVILIA GB ROM..."

os.system("make all Makefile")

print "Done! Exiting in 5 seconds..."

time.sleep(5)
