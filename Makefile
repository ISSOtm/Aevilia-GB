
.SHELL: /bin/bash
.PHONY: all rebuild
.SUFFIXES:
.DEFAULT_GOAL: all


ROMVersion = 0

bindir = ./bin
objdir = ./obj

CFLAGS = -E -p 0xFF
LFLAGS = 
FFLAGS = -Cjv -i ISSO -k 42 -l 0x33 -m 0x1B -n $(ROMVersion) -p 0xFF -r 0x03 -t AEVILIA

RGBASM = ./rgbasm
RGBLINK = ./rgblink
RGBFIX = ./rgbfix


all: $(bindir)/aevilia.gbc

rebuild: clean all

clean:
	rm $(objdir)/*.o
	rm $(bindir)/aevilia.gbc $(bindir)/aevilia.sym $(bindir)/aevilia.map

$(bindir)/aevilia.sym:
	rm $(bindir)/aevilia.gbc
	make $(bindir)/aevilia.gbc

$(bindir)/aevilia.gbc: $(objdir)/aevilia.o $(objdir)/home.o $(objdir)/gfx.o $(objdir)/txt.o $(objdir)/error_handler.o $(objdir)/save.o $(objdir)/map.o $(objdir)/font.o $(objdir)/thread2.o $(objdir)/testmaps.o $(objdir)/intromap.o $(objdir)/sound.o $(objdir)/battle.o $(objdir)/defaultsave.o $(objdir)/rants.o
	$(RGBLINK) $(LFLAGS) -n $(bindir)/aevilia.sym -m $(bindir)/aevilia.map -o $@ $^
	$(RGBFIX) $(FFLAGS) $@
	
	
$(objdir)/%.o: constants.asm macros.asm constants/*.asm macros/*.asm
	
$(objdir)/aevilia.o: main.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/home.o: home.asm home/*.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/gfx.o: gfx/graphics.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/txt.o: engine/text.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/error_handler.o: engine/error_handler.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/save.o: engine/save.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/map.o: engine/map.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/font.o: engine/font.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/thread2.o: engine/thread2.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/testmaps.o: maps/test.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/intromap.o: maps/intro.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/sound.o: sound/DevSound.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/battle.o: battle/battle_engine.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/defaultsave.o: save/defaultsave.asm
	$(RGBASM) $(CFLAGS) -o $@ $<
	
$(objdir)/rants.o: save/rants.asm
	$(RGBASM) $(CFLAGS) -o $@ $<

