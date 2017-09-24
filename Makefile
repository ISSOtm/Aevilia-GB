
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

objlist = $(objdir)/main.o $(objdir)/battle.o $(objdir)/engine.o $(objdir)/home.o $(objdir)/gfx.o $(objdir)/maps.o $(objdir)/save.o $(objdir)/sound.o $(objdir)/text.o $(objdir)/tileset.o

ASFLAGS  = -E -p $(FillValue)
LDFLAGS  = 
FIXFLAGS = -Cjv -i $(GameID) -k $(NewLicensee) -l $(OldLicensee) -m $(MBCType) -n $(ROMVersion) -p $(FillValue) -r $(SRAMSize) -t $(GameTitle)

RGBASM = ./rgbasm
RGBLINK = ./rgblink
RGBFIX = ./rgbfix


all: $(bindir)/aevilia.gbc $(bindir)/aevilia_glitchmaps.gbc

rebuild: clean all

clean:
	rm -f $(objdir)/*.o
	rm -f $(bindir)/aevilia.gbc $(bindir)/aevilia.map $(bindir)/aevilia.sym

$(bindir)/%.sym:
	if [ ! -d bin ]; then mkdir $(bindir); fi
	rm $(@:.sym=.gbc)
	make $(@:.sym=.gbc)

$(bindir)/aevilia.gbc: $(objlist)
	if [ ! -d bin ]; then mkdir $(bindir); fi
	$(RGBLINK) $(LDFLAGS) -n $(bindir)/aevilia.sym -m $(bindir)/aevilia.map -o $@ $^
	$(RGBFIX) $(FIXFLAGS) $(@)
	
$(bindir)/aevilia_glitchmaps.gbc: $(objlist:.o=_glitchmaps.o)
	if [ ! -d bin ]; then mkdir $(bindir); fi
	$(RGBLINK) $(LDFLAGS) -o $@ $^
	$(RGBFIX) $(FIXFLAGS) $@
	
	
$(objdir)/%.o: %.asm constants.asm macros.asm constants/*.asm macros/*.asm %/*.asm
	if [ ! -d obj ]; then mkdir $(objdir); fi
	$(RGBASM) $(ASFLAGS) -o $@ $<
	
$(objdir)/%_glitchmaps.o: %.asm constants.asm macros.asm constants/*.asm macros/*.asm %/*.asm
	if [ ! -d obj ]; then mkdir $(objdir); fi
	$(RGBASM) $(ASFLAGS) -D GlitchMaps -o $@ $<
	
	
# Define special dependencies here (see "$(objdir)/%.o" rule for default dependencies)
$(objdir)/maps.o: maps/*.blk
$(objdir)/maps_glitchmaps.o: maps/*.blk

$(objdir)/sound.o: sound/NoiseData.bin
$(objdir)/sound_glitchmaps.o: sound/NoiseData.bin
