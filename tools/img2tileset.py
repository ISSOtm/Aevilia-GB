#!/usr/bin/python

try:
	from PIL import Image
except ModuleNotFoundError:
	print("Please ensure that module \"Pillow\" is installed, and is compatible with your Python version.")
	exit(1)

from sys import argv

# Stage 0 - Make sure the user entered something valid
if len(argv) < 3:
	print("Usage:\n\t{scriptname} file/to/open.png out/put/file.txt".format(scriptname= argv[0]))
	exit(1)

# Stage 1 - Get pixel data
try:
	img = Image.open(argv[1]).convert("RGB")
except IOError:
	print("Failed to open image!")
	exit(1)
	
pixels = img.load()
width, height = img.size

if width % 8 != 0 or height % 8 != 0:
	print("The image must contain an integer amount of tiles. (Your picture must be a multiple of 8 in both height and width.)")
	exit(1)
	
if width * height >= 256 * 8 * 8:
	print("Only a maximum of 256 tiles are allowed! (Your image would end up being {tiles} tiles.)".format(tiles= width * height / 64))
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
tile_palettes = []
is_image_invalid = False

for i in range(len(tiles)): # Iterate over all tiles
	tile_palettes.append([])
	
	for color in tiles[i]: # Iterate over every pixel
		
		if not color in tile_palettes[i]:
			tile_palettes[i].append(color)
	
	tile_palettes[i].sort(key= lambda x: sum(x) / 3, reverse= True) # Sort palettes by greyscale, in reverse order (ie. darkest is last)
	
	if len(tile_palettes[i]) > 4: # Check if there aren't too many colors in the palette
		is_image_invalid = True
		print("Tile #{id} has too many colors! (vert #{y}, horiz #{x})".format(id= i, y= i // (width // 8), x= i % (width // 8)))
		faulty_tile = []
		line = []
		x = 0
		for color in tiles[i]:
			line.append(tile_palettes[i].index(color))
			
			x += 1
			if x == 8:
				x = 0
				faulty_tile.append(str(line))
				line = []
		
		print("Here is a color map:\n[{tile}]\n".format(tile= "\n ".join(faulty_tile)))
		

if is_image_invalid:
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

try:
	outfile = open(argv[2], "w")
except IOError:
	print("Cannot open {file} for writing.".format(file= argv[2]))
	exit(1)

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

