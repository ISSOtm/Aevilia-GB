
img2tileset is a command-line Python 3 tool which provides easy conversion from PNG/JPG/BMP to a tileset.

img2tileset uses the Python module Pillow to read image data. Please ensure that this module (or a compatible one) is installed.

To obtain information on how to use the tool, please use the -h or --help command-line option.


The input image should be a collection of tiles stitched together with no gaps. There shouldn't be any padding, either.

The output file (which can be stdout) will first contain a dump of all tile data, then a dump of all palettes in raw format (4 times three component indices)


Inspired by bmp2tileset, by tmk -> https://github.com/gitendo/bmp2cgb

Written by ISSOtm with invaluable help from Parzival.
(c) 2018 AeviDev team.
