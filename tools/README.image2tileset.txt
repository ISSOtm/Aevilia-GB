img2tileset is a tool written by Parzival and ISSOtm for the purpose of allowing easy conversion from PNG/JPG/BMP/GIF to a tileset.

There are two versions:
img2tileset Single and img2tileset Batch.
The one you'll use is dependent on what you need.

img2tileset Single (img2tileset.py or img2tileset.exe) is for only converting one image to tileset. You will need to run it via a Command Prompt or Terminal.
Format for command:

Windows:
img2tileset file/to/open.img out/put/file.txt

Linux:
./img2tileset.py file/to/open.img out/put/file.txt

Use / instead of \ on Windows.

This will (hopefully) convert the first file into the second. Recommended output file extension is ".bin", ".blk" or ".til", but anything goes.

img2tileset Batch (img2tileset.batch.py or img2tileset.batch.exe) is for converting multiple images to tileset all at once. You will need to do some setup before you can run the script.

You will need to create a file called "infilepaths.txt". Put the full paths to the images you want to convert here, one per line.
Then open the file of your choice. A double-click will do. If all goes well, all your images will be converted, one-by-one. You'll find a ".bin" file with the same name next to every picture you defined in "infilepaths.txt". This is the converted image. However, if an error occurs, some of the output ".bin" files may have been placed next to the picture as normal, but no data will be added. If an error occurs but some files were made, check their size. If a file is 0 bytes in size, it failed to add the data. You'll have to create a support ticket for help.




Readme written by Parzival