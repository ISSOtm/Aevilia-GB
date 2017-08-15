
.SHELL: /bin/bash
.PHONY: all
.SUFFIXES:
.DEFAULT_GOAL: all


ROMVersion = 0

bindir = ./bin
objdir = ./obj

CFLAGS = -E -p 0xFF
LFLAGS = 
FFLAGS = -Cjv -i ISSO -k 42 -l 0x33 -m 0x1B -n $(ROMVersion) -p 0xFF -r 4 -t AEVILIA


all: $(bindir)/aevilia.gbc

$(bindir)/aevilia.gbc: $(objdir)/aevilia.o $(objdir)/home.o $(objdir)/gfx.o $(objdir)/text_engine.o
	rgblink $(LFLAGS) -n aevilia.sym -m aevilia.map -o $@ $^
	rgbfix $(FFLAGS) $@
	
	
$(objdir)/%.o: constants.asm macros.asm constants/*.asm macros/*.asm
	
$(objdir)/aevilia.o: main.asm
	rgbasm $(CFLAGS) -o $@ $<
	
$(objdir)/home.o: home.asm
	rgbasm $(CFLAGS) -o $@ $<
	
$(objdir)/gfx.o: gfx/graphics.asm
	rgbasm $(CFLAGS) -o $@ $<
	
$(objdir)/text_engine.o: engine/text.asm
	rgbasm $(CFLAGS) -o $@ $<

