
.SHELL: /bin/bash
.PHONY: all rebuild clean
.SUFFIXES:
.DEFAULT_GOAL: all


FillValue = 0xFF

ROMVersion = 0
GameID = ISSO
GameTitle = AEVILIA
NewLicensee = 42
OldLicensee = 0x33
# MBC5+RAM+BATTERY
MBCType = 0x1B
# ROMSize = 0x02
SRAMSize = 0x04

bindir = ./bin
objdir = ./obj

objlist = $(objdir)/main.o $(objdir)/battle.o $(objdir)/engine.o $(objdir)/home.o $(objdir)/gfx.o $(objdir)/maps.o $(objdir)/save.o $(objdir)/sound.o $(objdir)/tileset.o

CFLAGS = -E -p $(FillValue)
LFLAGS = 
FFLAGS = -Cjv -i $(GameID) -k $(NewLicensee) -l $(OldLicensee) -m $(MBCType) -n $(ROMVersion) -p $(FillValue) -r $(SRAMSize) -t $(GameTitle)

RGBASM = ./rgbasm
RGBLINK = ./rgblink
RGBFIX = ./rgbfix


# Define special dependencies here (see "$(objdir)/%.o" rule for default dependencies
maps_deps	= maps/*.blk
sound_deps	= sound/NoiseData.bin


all: $(bindir)/aevilia.gbc $(bindir)/aevilia_glitchmaps.gbc

rebuild: clean all

clean:
	rm $(objdir)/*.o
	rm $(bindir)/aevilia.gbc $(bindir)/aevilia.map $(bindir)/aevilia.sym

$(bindir)/aevilia.sym:
	if [ ! -d bin ]; then mkdir $(bindir); fi
	rm $(bindir)/aevilia.gbc
	make $(bindir)/aevilia.gbc

$(bindir)/aevilia.gbc: $(objlist)
	if [ ! -d bin ]; then mkdir $(bindir); fi
	$(RGBLINK) $(LFLAGS) -n $(bindir)/aevilia.sym -m $(bindir)/aevilia.map -o $@ $^
	$(RGBFIX) $(FFLAGS) $@
	
$(bindir)/aevilia_glitchmaps.gbc: $(objlist:.o=_glitchmaps.o)
	if [ ! -d bin ]; then mkdir $(bindir); fi
	$(RGBLINK) $(LFLAGS) -o $@ $^
	$(RGBFIX) $(FFLAGS) $@
	
	
$(objdir)/%.o: %.asm constants.asm macros.asm constants/*.asm macros/*.asm %/*.asm $(%_deps)
	if [ ! -d obj ]; then mkdir $(objdir); fi
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/%_glitchmaps.o: %.asm constants.asm macros.asm constants/*.asm macros/*.asm %/*.asm $(%_deps)
	if [ ! -d obj ]; then mkdir $(objdir); fi
	$(RGBASM) $(CFLAGS) -D GlitchMaps -o $@ $<
