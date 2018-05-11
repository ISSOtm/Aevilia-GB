import urllib
import os

deps_link = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/dependencies.zip"
extractor_link = "https://stuff-for-my-programs.weebly.com/uploads/1/1/4/2/114279849/7za.exe"
dll_list = ["libiconv2.dll", "libintl3.dll", "msvcp60.dll", "msvcrt.dll"]

"""
Downloaded File List:
dependencies.zip:
{
msvcp60.dll
msvcrt.dll
libiconv2.dll
libintl3.dll
make.exe
}

7za.exe

maybe later i'll use the shitty builtin zip module instead but i doubt it
"""


def in_PATH(fileToCheck):
	path = os.getenv("PATH").split(";")
	for dir in path:
		if os.path.isfile(dir + fileToCheck):
			return True
	return False
	
def check_deps():
	for dll in dll_list:
		if not in_PATH(dll):
			return False
	return in_PATH("make.exe")
	
def download_deps():
	print "==================================\nAEVILIA GB Online Makefile Wrapper\n==================================\nWritten in Py2 by Parzival\nMaintained by Parzival and ISSOtm\nThis version downloads repacked files from a server in order to run them. Nothing will be permanently installed.\nIf you don't like this, use the Offline Wrapper. It'll tell you what you need to download.\n\nIf you wish to download and unpack the files, type YES and press Enter.\nIf you do not wish to, either close this program or type anything else."
	try:
		confirm_str = raw_input("\"YES\" to confirm > ")
	except EOFError:
		return False
	if confirm_str.lower() != "yes":
		return False
	
	print "\nDownload will begin now. Total size: 3 MB"
	print "Downloading dependencies... (1.2MB)"
	urllib.urlretrieve(deps_link,"dependencies.zip")
	print "Downloading decompression utility... (574KB)"
	urllib.urlretrieve(extractor_link,"7za.exe")
	
	print "Decompressing dependencies...\n"
	os.system("7za e dependencies.zip -y")
	os.system("del dependencies.zip")
	os.system("del 7za.exe")
	
	return True
	
	
def compile_rom():	
	if check_deps():
		print "Compilation tools detected, skipping download."
	else:
		if not download_deps():
			print "Aborted."
			return
	
	print "\nBuilding AEVILIA GB ROM...\n"
	os.system("make -f Makefile")
	
	print "\nDo you want to clean up the files you downloaded? If you don't, you won't have to re-download them next time."
	print "If you want to keep the files, simply close the program. Otherwise, type anything then hit Enter."
	try:
		raw_input()
	except EOFError:
		return
	
	# If we reach here, the user asked for cleanup. Ok.
	print "\nCleaning up...\n"
	for dll in dll_list:
		os.system("del " + dll + " /f")
	os.system("del make.exe /f")
	os.system("del dependencies.zip /f")
	os.system("del 7za.exe /f")
	
	print "Done! Exiting..."


compile_rom()

