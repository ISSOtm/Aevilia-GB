#!/usr/bin/python3

try:
	from PIL import Image
except ModuleNotFoundError:
	print("Please ensure that module \"Pillow\" is installed, and is compatible with your Python version.")
	exit(1)

import sys
import argparse


def sort_palette(palette):
	palette.sort(key= lambda x: sum(x) / 3, reverse= True) # Sort palettes by greyscale, in reverse order (ie. darkest is last)


# Stage 0 - Parse arguments
parser = argparse.ArgumentParser(description= "Convert an image to a tileset's gfx data.")
parser.add_argument("--dry", action="store_true",
	help="only print if the image is parseable (and if so, print info about it)")
parser.add_argument("imgfile_name", metavar= "path/to/input.img",
	help="the path to the input image")
parser.add_argument("outfile", metavar= "path/to/output.txt", nargs="?", default=sys.stdout, type=argparse.FileType("wt"),
	help="the path to the output image. If unspecified or equals \"-\", defaults to stdout.")

args = parser.parse_args()

run_dry = args.dry
imgfile_name = args.imgfile_name
outfile = args.outfile


# Stage 1 - Get pixel data
try:
	img = Image.open(imgfile_name).convert("RGB")
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

print("Size: {h}h * {w}w, {tiles} tiles.\n\tFormat: {fileFormat}\n".format(h= height, w= width, tiles= height * width // 64, fileFormat= str(img.format)))

if run_dry:
	exit(0)


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
	
	sort_palette(tile_palettes[i])
	
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
		

if is_image_invalid:
	exit(1)


# Stage 4 - Determine color palettes
color_palettes = []
palette_ids = []
for palette in tile_palettes:
	chosen_palette = -1
	colors_matching = 0
	
	for palette_id in range(len(color_palettes)):
		registered_palette = color_palettes[palette_id]
		colors_matching_this_palette = 0
		
		for color in palette:
			if color in registered_palette:
				colors_matching_this_palette += 1
		
		colors_not_in_palette = len(palette) - colors_matching_this_palette
		
		# Don't try to merge into a palette if there isn't room for it
		if len(registered_palette) + colors_not_in_palette <= 4:
			# Only pick a palette if it's better to take it
			if colors_matching < colors_matching_this_palette:
				chosen_palette = palette_id
	
		
	if chosen_palette == -1:
		chosen_palette = len(color_palettes)
		color_palettes.append(palette)
	else:
		# Merge both palettes
		registered_palette = color_palettes[chosen_palette]
		for color in palette:
			# Do not duplicate colors
			if not color in registered_palette:
				registered_palette.append(color)
		
		sort_palette(registered_palette)
	
	palette_ids.append(chosen_palette)


# Stage 5 - Attempt to merge some palettes, and pad the others
nb_colors = [len(palette) for palette in color_palettes]

def merge_palettes(i, j):
	global nb_colors
	global color_palettes

	color_palettes[i].extend(color_palettes[j])
	nb_colors[i] += nb_colors[j]
	del nb_colors[j]
	del color_palettes[j]


# Attempt to merge 3-color and 1-color palettes
try:
	while True:
		# Look for two palettes that can be merged
		i = nb_colors.index(3) # This errors if there is none, which exits the loop
		j = nb_colors.index(1) # Same here

		merge_palettes(i, j)

except ValueError:
	pass


# Attempt to merge 2-color palettes
try:
	while True:
		i = nb_colors.index(2)
		nb_colors[i] = -1 # Temporarily replace value to exclude from next search
		try:
			j = nb_colors.index(2)
		finally:
			nb_colors[i] = 2 # Make sure the value is restored, even if an error is raised!
		
		merge_palettes(i, j)

except ValueError:
	pass


# Attempt to merge a possibly remaining 2-color palette with 1-color palettes
# There can't be two remaining palettes, otherwise they'd have been merged together
try:
	i = nb_colors.index(2)

	while nb_colors[i] < 4:
		j = nb_colors.index(1)
		merge_palettes(i, j)

except ValueError:
	pass


# Attempt to merge 1-color palettes together
try:
	while True:
		# It's possible to merge multiple palettes into one
		i = nb_colors.index(1)

		while nb_colors[i] < 4:
			tmp = nb_colors[i]
			nb_colors[i] = -1

			try:
				j = nb_colors.index(1)
			finally:
				nb_colors[i] = tmp
			
			merge_palettes(i, j)

except ValueError:
	pass


for palette in color_palettes:
	while len(palette) < 4:
		palette.append((0, 0, 0))


# Stage 6 - Generate hex tiles
hex_tiles = []
for i in range(len(tiles)):
	hex_tile = []
	LSB = 0
	MSB = 0
	counter = 0
	
	for pixel in tiles[i]:
		index = color_palettes[palette_ids[i]].index(pixel)
		LSB = LSB * 2 + index % 2
		MSB = MSB * 2 + index // 2
		
		counter += 1
		if counter == 8:
			hex_tile.append("$" + hex(MSB)[2:].upper().zfill(2) + hex(LSB)[2:].upper().zfill(2))
			LSB = 0
			MSB = 0
			counter = 0
	
	hex_tiles.append(hex_tile)


# Stage 7 - Produce output
for i in range(len(hex_tiles)):
	outfile.write("\tdb {data} ; Tile ${id}, palette #{palette}\n".format(data= ", ".join(hex_tiles[i]), id= i, palette= palette_ids[i]))

for i in range(len(color_palettes)):
	outfile.write("\nPalette #{id}\n".format(id= i))
	for color in color_palettes[i]:
		outfile.write("\tdb ${data}\n".format(data= ", $".join([hex(value).lstrip("0x").upper().zfill(2)  for value in color])))

outfile.flush()
outfile.close()

