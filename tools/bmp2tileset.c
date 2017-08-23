
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


// Not actually the BMP header, it's the BMP header plus some fields common to all DIB headers.
typedef struct {
	int fileSize;
	int reserved; // 2x 2 reserved bytes.
	int dataOffset;
	int headerSize;
	int horizSize;
	int vertSize;
	short numOfPlanes;
	short numOfBpp;
	int compressionType;
	int imageSize;
	int resolutionHoriz;
	int resolutionVert;
	int numOfColors;
	int importantColors;
} BMPHeader;

typedef enum {
	BI_RGB,
	BI_RLE8,
	BI_RLE4,
	UNSUPPORTED
} CompressionType;


void showhelp();

int main(int argc, char** argv);


int options = 0;
char* optionLetters = "iv";
#define MASK_DISPHEADER (1 << 0)
#define MASK_BEVERBOSE (1 << 1)


void showhelp() {
	printf("Usage:\n");
	printf("\tbmp2tileset [-i] image.bmp\n");
	printf("\n");
	printf("-i\tDisplays information from the image's header.\n");
	printf("-v\tBe verbose, display info about what's being done.\n");
	printf("\n");
}

int main(int argc, char** argv) {
	char* filename = NULL;
	FILE* file = NULL;
	int argindex = 1;
	
	for( ; argindex < argc; argindex++) {
		if(argv[argindex][0] == '-') {
			int optionID = 0;
			
			for( ; optionLetters[optionID] != '\0'; optionID++) {
				if(optionLetters[optionID] == argv[argindex][1]) {
					break;
				}
			}
			
			if(optionLetters[optionID] == '\0') {
				printf("Unknown option \"%s\".\n\n", argv[argindex]);
				showhelp();
				exit(1);
			}
			
			options |= 1 << optionID;
		} else {
			if(filename) {
				printf("Please supply only 1 file.\n");
				showhelp();
				exit(1);
			}
			filename = argv[argindex];
		}
	}
	
	if(!filename) {
		printf("No file supplied!\n");
		showhelp();
		exit(1);
	}
	
	if(options & MASK_BEVERBOSE) {
		printf("File name:\t%s\n", filename);
	}
	
	file = fopen(filename, "rb");
	
	if(!file) {
		perror("Failed to open file.\n");
		exit(1);
	}
	
	if(options & MASK_BEVERBOSE) {
		printf("Opened file successfully.\n");
	}
	
	// Read the first two bytes for the "BM".
	if(fgetc(file) != 'B' || fgetc(file) != 'M') {
		printf("Invalid BMP file.\n");
		
		fclose(file);
		exit(1);
	}
	
	if(options & MASK_BEVERBOSE) {
		printf("Magic bytes successfully found.\n");
	}
	
	BMPHeader header;
	size_t numOfItemsRead = fread(&header, sizeof(header), 1, file);
	if(numOfItemsRead < 1) {
		if(feof(file)) {
			printf("File is too short.\n");
		} else {
			perror("Failed to read file.\n");
		}
		fclose(file);
		exit(1);
	}
	
	if(options & MASK_BEVERBOSE) {
		printf("Successfully read header.\n");
	}
	
	if(options & MASK_DISPHEADER) {
		printf("File size:\t\t%#010x\n", header.fileSize);
		printf("Data offset:\t\t%#010x\n", header.dataOffset);
		printf("Header size:\t\t%#010x\n", header.headerSize);
		printf("Image width:\t\t%d\n", header.horizSize);
		printf("Image height:\t\t%d\n", header.vertSize);
		printf("Num of planes:\t\t%d\n", header.numOfPlanes);
		printf("Num of bpp:\t\t%d\n", header.numOfBpp);
		printf("Compression type:\t%d\n", header.compressionType);
		printf("Image size:\t\t%#010x\n", header.imageSize);
		printf("Horiz resolution:\t%d\n", header.resolutionHoriz);
		printf("Vert resolution:\t%d\n", header.resolutionVert);
		printf("Num of colors:\t\t%d\n", header.numOfColors);
		printf("Num of imp. colors:\t%d\n", header.importantColors);
		printf("\n");
	}
	
	if(header.horizSize % 8 != 0 || header.vertSize % 8 != 0) {
		printf("Image dimensions must be multiples of 8 !\n");
		
		fclose(file);
		exit(1);
	}
	
	if(header.numOfBpp > 8) {
		printf("Cannot process this type of BMP !\n");
		printf("Use a 256-color BMP instead.\n\n");
		printf("(AND DON'T USE PAINT TO DO THE CONVERSION.)\n");
		printf("(IT SUCKS.)\n");
		
		fclose(file);
		exit(1);
	}
	
	const int imageSize = header.horizSize * header.vertSize;
	char* decompressedImage = malloc(imageSize);
	if(decompressedImage == NULL) {
		printf("Not enough memory to start.\n");
		
		fclose(file);
		exit(1);
	}
	
	if(fseek(file, header.dataOffset, SEEK_SET) != 0) {
		printf("fseek failed.\n");
		
		free(decompressedImage);
		fclose(file);
		exit(1);
	}
	
	if(options & MASK_BEVERBOSE) {
		printf("Successfully allocated %d bytes.\n", imageSize);
	}
	
	int colors[32][3];
	int conversionTable[256];
	
	if(header.numOfBpp == 8) {
		if(options & MASK_BEVERBOSE) {
			printf("Decompressing 8bpp image.\n");
		}
		
		if(header.compressionType == BI_RGB) {
			if(options & MASK_BEVERBOSE) {
				printf("Image is not compressed.\n");
			}
			
			if(header.vertSize < 0) {
				if(options & MASK_BEVERBOSE) {
					printf("Vertical size negative, using top-down decompression.\n");
				}
				
				numOfItemsRead = fread(decompressedImage, sizeof(char), imageSize, file);
				if(numOfItemsRead != imageSize) {
					printf("BMP is apparently corrupted.\n");
					
					free(decompressedImage);
					fclose(file);
					exit(1);
				}
			} else {
				if(options & MASK_BEVERBOSE) {
					printf("Vertical size positive, using down-top decompression.\n");
				}
				
				int ofs = imageSize;
				while(ofs != 0) {
					ofs -= header.horizSize;
					numOfItemsRead = fread(decompressedImage + ofs, sizeof(char), header.horizSize, file);
					if(numOfItemsRead != header.horizSize) {
						printf("BMP is apparently corrupted, could only read %d lines out of %d.\n", header.vertSize - ofs / header.horizSize, header.vertSize);
						
						free(decompressedImage);
						fclose(file);
						exit(1);
					}
				}
			}
		} else if(header.compressionType == BI_RLE8) {
			printf("Compression isn't supported yet.\n"); // NYI
			
			free(decompressedImage);
			fclose(file);
			exit(1);
		} else {
			printf("Invalid or unsupported compression type.\n");
			
			free(decompressedImage);
			fclose(file);
			exit(1);
		}
		
		if(options & MASK_BEVERBOSE) {
			printf("Constructing color palette.\n");
		}
		
		#define BMP_HEADER_SIZE 0x0E
		if(fseek(file, BMP_HEADER_SIZE + header.headerSize, SEEK_SET) != 0) {
			printf("Failed to read color palette.\n");
			
			free(decompressedImage);
			fclose(file);
			exit(1);
		}
		
		const int numOfColors = (header.numOfColors != 0) ? header.numOfColors : 256;
		if(options & MASK_BEVERBOSE) {
			printf("Color palette contains %d colors.\n", numOfColors);
		}
		
		// Number of allocated colors.
		int allocatedColors = 0;
		int i = 0;
		int j;
		for( ; i < numOfColors; i++) {
			// First, get the color.
			// Shifts occur because the GBC only uses 5 bits, so we can "blend" some colors together.
			int b = fgetc(file) >> 3;
			int g = fgetc(file) >> 3;
			int r = fgetc(file) >> 3;
			// Dummy byte.
			(void)fgetc(file);
			
			// Look if the color is already in the table.
			int* color;
			for(j = 0; j < allocatedColors; j++) {
				color = colors[j];
				if(color[0] == r && color[1] == g && color[2] == b) {
					break;
				}
			}
			
			if(j == allocatedColors) {
				colors[j][0] = r;
				colors[j][1] = g;
				colors[j][2] = b;
				
				allocatedColors++;
				if(allocatedColors > 32) {
					printf("The image contains more than 32 unique colors.\n");
					
					free(decompressedImage);
					fclose(file);
					exit(1);
				}
			}
			
			conversionTable[i] = j;
		}
		
		if(options & MASK_BEVERBOSE) {
			printf("Number of unique colors: %d.\n", allocatedColors);
		}
		
		// Perform conversion of all bytes.
		char* ofs;
		for(i = 0; i < header.vertSize; i++) {
			for(j = 0; j < header.horizSize; j++) {
				ofs = decompressedImage + i * header.horizSize + j;
				*ofs = conversionTable[*ofs];
			}
		}
	} else {
		printf("This type of BMP isn't supported yet.\n"); // NYI
		
		free(decompressedImage);
		fclose(file);
		exit(1);
	}
	
	if(options & MASK_BEVERBOSE) {
		printf("Successfully decompressed image.\n");
	}
	
	const int numOfTiles = imageSize / 64; // One tile is 8x8 pixels, thus 64 pixels. (This works because we checked the dimensions of the image.)
	// Array containing the tiles' data.
	short tiles[numOfTiles][8][8];
	// Contains the four color indexes for each tile. (Used to distribute colors across palettes.)
	int tileColors[numOfTiles][4];
	
	// Generate the tile data.
	int tileID = 0;
	int row;
	int col;
	const int tilesPerRow = header.horizSize / 8;
	char* baseOfs; // Offset of the top-left pixel of the tile.
	char* ofs;
	int color;
	for( ; tileID < numOfTiles; tileID++) {
		int numOfColors = 0;
		baseOfs = (/* Offset on a "tile grid" */ (/* Row */ tileID / tilesPerRow) * header.horizSize + (/* Column */ tileID % tilesPerRow)) /* Upscale by 8 to do tile->pixel conversion */ * 8 + decompressedImage;
		for(row = 0; row < 8; row++) {
			ofs = baseOfs + row * header.horizSize;
			for(col = 0; col < 8; col++) {
				color = *ofs;
				ofs++;
				tiles[tileID][row][col] = color;
				
				// If the color wasn't in the table,
				char isColorInTable = 0;
				int i = 0;
				for( ; i < numOfColors && !isColorInTable; i++) {
					if(tileColors[tileID][i] == color) {
						isColorInTable = 1;
					}
				}
				if(!isColorInTable) {
					if(numOfColors > 3) {
						printf("Tile #%d contains more than 4 colors!\n", tileID);
						free(decompressedImage);
						fclose(file);
						exit(1);
					}
					// Add it.
					tileColors[tileID][numOfColors] = color;
					numOfColors++;
				}
			}
		}
		
		// Sort the table of the colors that the tile uses.
		int compareColors(/*int color1, int color2) {/*/const void* color1Ptr, const void* color2Ptr) {
			int color1 = *(int*)color1Ptr;
			int color2 = *(int*)color2Ptr;
			
			int color1Brightness = (colors[color1][0] + colors[color1][1] + colors[color1][2]) / 3;
			int color2Brightness = (colors[color2][0] + colors[color2][1] + colors[color2][2]) / 3;
			return color1Brightness - color2Brightness;
		}
		// Somehow this line causes a segfault, so... instead, I'll use a custom function. I guess.
		qsort(tileColors[tileID], numOfColors, sizeof(int), compareColors);
	}
	free(decompressedImage);
	
	if(options & MASK_BEVERBOSE) {
		printf("Successfully generated Stage 1 tile data.\n");
	}
	// 6 palettes of 4 colors each, one color being three R,G,B bytes.
	char palettes[6][4][3];
	char allocatedColors[6][4];
	// Make sure nothing is allocated.
	memset(&allocatedColors, 0, sizeof(allocatedColors));
	
	// Build the palette array.
	
	fclose(file);
	
	return 0;
}