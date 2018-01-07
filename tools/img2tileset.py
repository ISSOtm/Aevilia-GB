#!/usr/bin/python

try:
	from PIL import Image
except e:
	print("Please ensure that the Py2 module \"pillow\" is installed.")
	exit(1)

from sys import argv

# Stage 0 - Make sure the user entered something valid
if len(argv) < 3:
	print("Usage:\n\t{scriptname} file/to/open.png out/put/file.txt".format(scriptname= argv[0]))
	exit(1)

try:
	outfile = open(argv[2], "w")
except e:
	print("Cannot open {file} for writing.".format(file= argv[2]))
	exit(1)

# Stage 1 - Get pixel data
try:
	img = Image.open(argv[1])
except e:
	print("Failed to open image!")
	outfile.close()
	exit(1)

try:
	pixels = img.load() 
except e:
	print("Failed to copy image data to RAM!")
	outfile.close()
	img.close()
	exit(1)

width, height = img.size

try:
	img.close()
except e:
	print("Failed to unload image!")
	outfile.close()
	exit(1)

if width % 8 != 0 or height % 8 != 0:
	print("The image must contain an integer amount of tiles. (Your picture must be a multiple of 8 in both height and width.)")
	outfile.close()
	exit(1)
	
if width * height >= 256 * 8 * 8:
	print("Only a maximum of 256 tiles are allowed! (Your image would end up being {tiles} tiles.)".format(tiles= width * height / 64))
	outfile.close()
	exit(1)

print("{name}:\n\tSize: {h}h * {w}w, {tiles} tiles. \n\tFormat: {fileFormat}\n\n".format(name= argv[1], h= height, w= width, tiles= height * width // 64, fileFormat= str(img.format)))

# Stage 2 - Turn pixel data into tiles
tiles = []

x = 0
y = 0
while y < height:
	tile = []
	dy = 0
	while dy < 8:
		dx = 0
		while dx < 8:
			pixel = pixels[x, y] # Returns a (R, G, B) tuple
			CGB_pixel = [pixel[i] // 8  for i in range(3)] # pixel has 8-bit values, CGB only has 5, so downgrade quality
			tile.append(CGB_pixel)
			
			x += 1
			dx += 1
		
		x -= 8
		y += 1
		dy += 1

	tiles.append(tile)
	if x + 8 >= width:
		x = 0
	else:
		y -= 8
		x += 8

# Stage 3 - Generate palettes
tile_palettes = [[]] * len(tiles)
is_tile_invalid = False
for i in range(len(tiles)): # Iterate over all tiles
	for color in tiles[i]: # Iterate over every pixel
		
		if not color in tile_palettes[i]:
			tile_palettes[i].append(color)
			if len(tile_palettes[i]) == 5: # If we added a fifth color, tell the tile is wrong
				is_tile_invalid = True # We'll still iterate over all tiles, to report them all
				print("Tile #{id} has too many colors! (vert #{y}, horiz #{x})".format(id= i, y= i // (width // 8), x= i % (width // 8)))
				print("Faulty palette: Number " + str(i) + " , " + str(tile_palettes[i]))
	tile_palettes[i].sort(key= lambda x: sum(x) / 3, reverse= True) # Sort palettes by greyscale, in reverse order (ie. darkest is last)

if is_tile_invalid:
	outfile.close()
	exit(1)

# Stage 4 - Generate hex tiles
hex_tiles = []
for i in range(len(tiles)):
	hex_tile = []
	LSB = 0
	MSB = 0
	counter = 0
	
	for pixel in tiles[i]:
		index = tile_palettes[i].index(pixel)
		LSB = LSB * 2 + index % 2
		MSB = MSB * 2 + index // 2
		
		counter += 1
		if counter == 8:
			hex_tile.append("$" + hex(MSB)[2:].upper().zfill(2) + hex(LSB)[2:].upper().zfill(2))
			LSB = 0
			MSB = 0
			counter = 0
	
	hex_tiles.append(hex_tile)

# Stage 5 - Produce output
for tile in hex_tiles:
	outfile.write("\tdb {data}\n".format(data= ", ".join(tile)))

outfile.write("\n")

for palette in tile_palettes:
	for color in palette:
		outfile.write("\tdb ${data}\n".format(data= ", $".join([str(value).upper().zfill(2)  for value in color])))
	outfile.write("\n")

outfile.flush()
outfile.close()

