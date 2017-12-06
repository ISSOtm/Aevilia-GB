
.SHELL: /bin/bash
.PHONY: all rebuild clean
.SUFFIXES:
.DEFAULT_GOAL: all


FillValue = 0xFF

# ROM version rule :
# If the version is even, it's a debugging version : set DebugMode to 1
# If the version is odd, it's a production version : set DebugMode to 0
ROMVersion = 0
DebugMode = 1

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

ifeq ($(DebugMode), 1)
ASFLAGS := $(ASFLAGS) -D DebugMode
endif


all: $(bindir)/aevilia.gbc $(bindir)/aevilia_glitchmaps.gbc

rebuild: clean all

clean:
	rm -f $(objdir)/*.o
	rm -f $(bindir)/aevilia.gbc $(bindir)/aevilia.map $(bindir)/aevilia.sym

$(bindir)/%.sym:
	@if [ ! -d bin ]; then mkdir $(bindir); fi
	rm $(@:.sym=.gbc)
	make $(@:.sym=.gbc)
	
$(bindir)/%.gbc:

$(bindir)/aevilia.gbc: $(objlist)
	@if [ ! -d bin ]; then mkdir $(bindir); fi
ifeq ($(DebugMode), 1)
	@echo
	@echo "*** WARNING! COMPILING IN DEBUG MODE!"
	@echo "*** DO NOT REDISTRIBUTE THIS ROM!"
	@echo To disable debug mode, edit the Makefile.
	@echo
endif
	$(RGBLINK) $(LDFLAGS) -n $(bindir)/aevilia.sym -m $(bindir)/aevilia.map -o $@ $^
	$(RGBFIX) $(FIXFLAGS) $(@)
	
$(bindir)/aevilia_glitchmaps.gbc: $(objlist:.o=_glitchmaps.o)
	@if [ ! -d bin ]; then mkdir $(bindir); fi
ifeq ($(DebugMode), 1)
	@echo
	@echo "*** WARNING! COMPILING IN DEBUG MODE!"
	@echo "*** DO NOT REDISTRIBUTE THIS ROM!"
	@echo To disable debug mode, edit the Makefile.
	@echo
endif
	$(RGBLINK) $(LDFLAGS) -o $@ $^
	$(RGBFIX) $(FIXFLAGS) $@
	
	
$(objdir)/%.o: %.asm constants.asm macros.asm constants/*.asm macros/*.asm %/*.asm
	@if [ ! -d obj ]; then mkdir $(objdir); fi
	$(RGBASM) $(ASFLAGS) -o $@ $<
	
$(objdir)/%_glitchmaps.o: %.asm constants.asm macros.asm constants/*.asm macros/*.asm %/*.asm
	@if [ ! -d obj ]; then mkdir $(objdir); fi
	$(RGBASM) $(ASFLAGS) -D GlitchMaps -o $@ $<
	
	
# Define special dependencies here (see "$(objdir)/%.o" rule for default dependencies)
$(objdir)/maps.o: maps/*.blk
$(objdir)/maps_glitchmaps.o: maps/*.blk

$(objdir)/sound.o: sound/NoiseData.bin
$(objdir)/sound_glitchmaps.o: sound/NoiseData.bin
