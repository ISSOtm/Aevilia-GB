
SECTION "Tile data", ROMX,BANK[1]
	
CursorTile::
	dw $8080, $C0C0, $A0E0, $90F0, $88F8, $D0F0, $A8B8, $1818
	
	
EvieTiles::
	dw $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20, $3F20
	dw $3F29, $171E, $171C, $233F, $1E19, $0F0E, $0F09, $0606
	dw $C0C0, $F030, $F808, $F808, $FC04, $FC04, $FC04, $FC04
	dw $FC94, $E878, $E838, $C4FC, $7898, $F070, $F090, $6060
	
	dw $0303, $0F0C, $1F10, $1F13, $3F24, $3F2B, $3C27, $3A2F
	dw $3A2F, $382F, $1F17, $2D36, $191E, $0F0E, $0F09, $0606
	dw $C0C0, $F030, $F808, $F8C8, $FC24, $FCD4, $3CE4, $5CF4
	dw $5CF4, $1CF4, $F8E8, $B46C, $9878, $F070, $F090, $6060
	
	dw $0303, $0F0C, $1F10, $3F28, $3F28, $373C, $171F, $141F
	dw $111F, $090F, $0707, $0407, $0407, $0302, $0704, $0303
	dw $C0C0, $F030, $F808, $FC04, $FC04, $FC04, $FC04, $FC84
	dw $FC84, $FC04, $FCE4, $B8D8, $50F0, $E020, $E020, $E0E0
	
EvieMovingTiles::
	dw $0000, $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20
	dw $3F20, $3F29, $1F1E, $171F, $151E, $0E0B, $0F09, $0606
	dw $0000, $C0C0, $F030, $F808, $F808, $FC04, $FC04, $FC04
	dw $FC04, $FC94, $F868, $E8F8, $C878, $30F0, $C0C0, $0000
	
	dw $0000, $0303, $0F0C, $1F10, $1F13, $3F24, $3F2B, $3C27
	dw $3A2F, $3A2F, $382F, $1F17, $151E, $0F0A, $0F09, $0606
	dw $0000, $C0C0, $F030, $F808, $F8C8, $FC24, $FCD4, $3CE4
	dw $5CF4, $5CF4, $1CF4, $E8F8, $C878, $B0F0, $C0C0, $0000
	
	dw $0000, $0303, $0F0C, $1F10, $3F28, $3F28, $373C, $171F
	dw $141F, $101F, $090F, $0707, $1D1F, $3C27, $1F13, $0C0C
	dw $0000, $C0C0, $F030, $F808, $FC04, $FC04, $FC04, $FC04
	dw $FC84, $FC84, $FC04, $FCE4, $78B8, $B8E8, $F8C8, $3030
	
TomTiles::
	dw $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20, $3F20
	dw $3F20, $1F1A, $273D, $2F3B, $181F, $0E0F, $0F09, $0606
	dw $C0C0, $FE3E, $FC0C, $F808, $FC04, $FC04, $FC04, $FC04
	dw $FC04, $F858, $E4BC, $F4DC, $18F8, $70F0, $F090, $6060
	
	dw $0303, $7F7C, $3F30, $1F10, $3F20, $3F26, $393F, $2A37
	dw $223F, $181F, $273F, $2D36, $191E, $0F0E, $0F09, $0606
	dw $C0C0, $F030, $F808, $F808, $FC04, $FC64, $9CFC, $54EC
	dw $44FC, $18F8, $E4FC, $B46C, $9878, $F070, $F090, $6060
	
	dw $0303, $0F0C, $1F10, $3F20, $3F28, $171C, $171F, $141F
	dw $101F, $080F, $0707, $0605, $0605, $0302, $0704, $0303
	dw $C0C0, $F030, $F8C8, $FC34, $FC04, $FC04, $FC04, $F888
	dw $F888, $F090, $E0E0, $90F0, $50F0, $E020, $E020, $E0E0
	
TomMovingTiles::
	dw $0000, $0303, $0F0C, $1F10, $1F10, $3F20, $3F20, $3F20
	dw $3F20, $3F20, $1F1A, $171D, $0F0B, $080F, $0F09, $0606
	dw $0000, $C0C0, $FE3E, $FC0C, $F808, $FC04, $FC04, $FC04
	dw $FC04, $FC04, $F878, $C8B8, $C8F8, $30F0, $C0C0, $0000
	
	dw $0000, $0303, $7F7C, $3F30, $1F10, $3F20, $3F26, $393F
	dw $2A37, $223F, $181F, $171F, $191E, $1F1E, $0F09, $0606
	dw $0000, $C0C0, $F030, $F808, $F808, $FC04, $FC64, $9CFC
	dw $54EC, $44FC, $38F8, $C8F8, $E858, $70F0, $8080, $0000
	
	dw $0000, $0303, $0F0C, $1F10, $3F20, $3F28, $171C, $171F
	dw $141F, $101F, $080F, $0707, $1D1F, $3C27, $1F13, $0C0C
	dw $0000, $C0C0, $F030, $F8C8, $FC34, $FC04, $FC04, $FC04
	dw $F888, $F888, $F090, $E0E0, $38F8, $B8E8, $F8C8, $3030
	
	
GameTiles:: ; Game Boy tiles, used for the text box
	dw $0F00, $1000, $1007, $1007, $1007, $1007, $1005, $1007
	dw $FF00, $0000, $00FF, $00FF, $0000, $0000, $0000, $0000
	dw $F000, $0800, $08E0, $08E0, $08E0, $08E0, $08E0, $08E0
	
	dw $1007, $1007, $1007, $1007, $1003, $1000, $1100, $1100
	dw $0000, $0000, $0000, $00FF, $00FF, $0000, $8000, $8000
	dw $08E0, $08E0, $08E0, $08E0, $08C0, $0800, $0800, $6800
	
	dw $1700, $1700, $1100, $1100, $1000, $1000, $0800, $0700
	dw $E300, $E300, $8000, $8000, $3600, $0000, $0000, $FF00
	dw $6800, $0800, $0800, $0800, $08E0, $08E0, $10E0, $E000
	
	
ConsoleTiles::
	; Crappy emulator
	dw $0000, $0000, $FFFF, $80FF, $80FF, $80FF, $80FF, $80FF
	dw $80FF, $81FF, $81FF, $80FF, $83FF, $87FC, $87FC, $83FF
	dw $80FF, $FFFF, $0000, $0000, $0000, $0101, $0000, $0000
	
	dw $0000, $0000, $FFFF, $10FF, $08FF, $3CFF, $7EC3, $3CE7
	dw $FFC3, $FF00, $DB36, $FF81, $FF3C, $FF18, $FF00, $FFFF
	dw $00FF, $FFFF, $1818, $1818, $1818, $FFFF, $0000, $0000
	
	dw $0000, $0000, $FFFF, $01FF, $01FF, $01FF, $01FF, $01FF
	dw $01FF, $81FF, $81FF, $01FF, $C1FF, $E13F, $E13F, $C1FF
	dw $01FF, $FFFF, $0000, $0000, $0000, $8080, $0000, $0000
	
	; 3DS VC
	dw $7F7F, $FFFF, $7FFF, $F8FF, $F8FF, $E8FF, $D8FF, $F8FF
	dw $F8FF, $F8FF, $FFFF, $7F40, $FFC0, $E699, $C2BD, $C2BD
	dw $E699, $FE81, $E699, $C2BD, $E798, $FE81, $7F7F, $0000
	
	dw $FFFF, $E7FF, $FFFF, $00FF, $00FF, $00FF, $00FF, $00FF
	dw $00FF, $00FF, $FFFF, $FF00, $FF00, $00FF, $00FF, $00FF
	dw $00FF, $00FF, $00FF, $00FF, $FF00, $24DB, $FFFF, $0000
	
	dw $FEFE, $FFFF, $FEFF, $1FFF, $1FFF, $17FF, $1BFF, $1EFF
	dw $1EFF, $1EFF, $FFFF, $FA06, $FF03, $6799, $7F81, $5BA5
	dw $5BA5, $7F81, $6799, $7F81, $FF01, $7F81, $FEFE, $0000
	
	; Good emulator
	dw $0000, $0000, $FFFF, $80FF, $80FF, $80FF, $80FF, $80FF
	dw $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF, $80FF
	dw $80FF, $FFFF, $0000, $0000, $0000, $0101, $0000, $0000
	
	dw $0000, $0000, $FFFF, $00FF, $FFFF, $FF81, $FFBD, $E7BD
	dw $E7BD, $FFBD, $FF81, $FFA5, $FFA9, $FF83, $FF85, $7EFF
	dw $00FF, $FFFF, $1818, $1818, $1818, $FFFF, $0000, $0000
	
	dw $0000, $0000, $FFFF, $01FF, $01FF, $01FF, $01FF, $01FF
	dw $01FF, $01FF, $01FF, $01FF, $01FF, $01FF, $01FF, $01FF
	dw $01FF, $FFFF, $0000, $0000, $0000, $8080, $0000, $0000
	
	; GBC
	dw $0707, $0F08, $0F0B, $0F0B, $0F0B, $0F0B, $0F0B, $0F0B
	dw $0F0B, $0F0B, $0F0B, $0F09, $0F08, $0F08, $0F08, $0F09
	dw $0F08, $0F08, $0F08, $0F08, $0F08, $0F08, $0706, $0101
	
	dw $FFFF, $FF00, $FFFF, $FFFF, $00FF, $00FF, $00FF, $00FF
	dw $00FF, $00FF, $FFFF, $FFFF, $FF00, $FF00, $FF81, $FFCD
	dw $FF8C, $FF00, $FF00, $FF00, $FF66, $FF00, $FF00, $FFFF
	
	dw $E0E0, $F010, $F0D0, $F0D0, $F0D0, $F0D0, $F0D0, $F0D0
	dw $F0D0, $F0D0, $F0D0, $F090, $F010, $F010, $F090, $F090
	dw $F010, $F010, $F010, $F010, $F0B0, $F050, $E060, $8080
	
	; GBA
	dw $0000, $0000, $0000, $0000, $0000, $011F, $3F3E, $7F40
	dw $7F41, $7F41, $FF83, $EF93, $C7BB, $EF93, $FB87, $FF83
	dw $FB85, $7F78, $0707, $0000, $0000, $0000, $0000, $0000
	
	dw $0000, $0000, $0000, $0000, $0000, $FFFF, $FF00, $FFFF
	dw $FFFF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $FFFF
	dw $FFFF, $FF00, $FF00, $FFFF, $0000, $0000, $0000, $0000
	
	dw $0000, $0000, $0000, $0000, $0000, $80F8, $FC7C, $FE02
	dw $FE82, $FE82, $FFC1, $FBC5, $EBD5, $EFD1, $FFC1, $FFCF
	dw $FF81, $FE1E, $E0E0, $0000, $0000, $0000, $0000, $0000
	
	
SECTION "Strings and text", ROMX,BANK[1]
	
AeviliaStr::
	dstr "AEVILIA GB"
	
VBAText::
	db "NICE EMULATOR YA GOT"
	db "  RIGHT THAR, MATE! "
	db "                    "
	db "WELL, ACTUALLY IT'S "
	db " A PRETTY BAD ONE.  "
	db "INSTEAD, YOU CAN TRY"
	db "  BGB OR GAMBATTE,  "
	db "OR A REAL GB COLOR. "
	db "    (OR ADVANCE,    "
	db "    IT WORKS TOO)   "
	db "                    "
	db "PRESS A TO DISMISS, "
	db " BUT DON'T BLAME ME "
	db "IF SOMETHING DOESN'T"
	db "  WORK CORRECTLY.   "
	db "                    "
	dstr "           --ISSOTM"
	
GameName::
	dstr "AEVILIA"
	
SaveDestroyed0::
	dstr "SAVE DATA IS"
SaveDestroyed1::
	dstr "DESTROYED!"
SaveDestroyed2::
	dstr "ALL FILES WILL"
SaveDestroyed3::
	dstr "BE DELETED."
SaveDestroyed4::
	dstr "SORRY :/"
	
SaveDestroyedText::
	print_pic GameTiles
	print_name GameName
	print_line SaveDestroyed0
	print_line SaveDestroyed1
	empty_line
	wait_user
	print_line SaveDestroyed2
	print_line SaveDestroyed3
	empty_line
	wait_user
	text_lda_imm 2
	text_sta wNumOfPrintedLines
	print_line SaveDestroyed4
	wait_user
	delay 5
	done
	
FirstTimeLoadingText::
	print_pic GameTiles
	print_name GameName
	print_line .line0
	print_line .line1
	print_line .line2
	wait_user
	clear_box
	print_line .line3
	print_line .line4
	print_line .line5
	wait_user
	print_line .line6
	wait_user
	clear_box
	print_line .line7
	print_line .line8
	wait_user
	clear_box
	print_line .line9
	print_line .line10
	print_line .line11
	wait_user
	clear_box
	print_line .line12
	print_line .line13
	wait_user
	clear_box
	delay 30
	print_line .line14
	wait_user
	done
	
.line0
	db "OH, "
	dstr "IT'S YOUR"
.line1
	dstr "FIRST TIME"
.line2
	dstr "PLAYING?"
.line3
	db "OKAY,"
	dstr " HERE ARE"
.line4
	dstr "THE CONTROLS"
.line5
	dstr "FOR THE MAIN"
.line6
	dstr "MENU."
.line7
	dstr "UP AND DOWN TO"
.line8
	dstr "SELECT A FILE."
.line9
	dstr "A OR START TO"
.line10
	db "CONFIRM,",0
.line11
	dstr "B TO CANCEL."
.line12
	dstr "USE SELECT FOR"
.line13
	dstr "OPTIONS."
.line14
	dstr "ENJOY!"
	