
waitVBlank		equ $0000
isVBlanking		equ $0008
isVRAMOpen		equ $0010
fill			equ $0018
copy			equ $0020
bankswitch		equ $0028
copyStr			equ $0030
callHL			equ $0038

SRAMEnable		equ $0000
ROMBankLow		equ $2000
ROMBankHigh		equ $3000
SRAMBank		equ $4000

ROMVersion		equ $014C

rOAM			equ $FE00
OAMEnd			equ $FEA0

rJOYP			equ $FF00
rDIV			equ $FF04
rTIMA			equ $FF05
rTMA			equ $FF06
rTAC			equ $FF07
rIF				equ $FF0F
rNR10			equ $FF10
rNR11			equ $FF11
rNR12			equ $FF12
rNR13			equ $FF13
rNR14			equ $FF14
;rNR20			equ $FF15
rNR21			equ $FF16
rNR22			equ $FF17
rNR23			equ $FF18
rNR24			equ $FF19
rNR30			equ $FF1A
rNR31			equ $FF1B
rNR32			equ $FF1C
rNR33			equ $FF1D
rNR34			equ $FF1E
;rNR40			equ $FF1F
rNR41			equ $FF20
rNR42			equ $FF21
rNR43			equ $FF22
rNR44			equ $FF23
rNR50			equ $FF24
rNR51			equ $FF25
rNR52			equ $FF26
_AUD3WAVERAM	equ $FF30
rLCDC			equ $FF40
rSTAT			equ $FF41
rSCY			equ $FF42
rSCX			equ $FF43
rLY				equ $FF44
rLYC			equ $FF45
rDMA			equ $FF46
rBGP			equ $FF47
rOBP0			equ $FF48
rOBP1			equ $FF49
rWY				equ $FF4A
rWX				equ $FF4B
rKEY1			equ $FF4D ; Speed switch
rVBK			equ $FF4F ; VRAM Bank
rHDMA1			equ $FF51 ; GBC ("New") DMA source ptr
rHDMA2			equ $FF52 ; WARNING : POINTERS ARE ***BIG-ENDIAN***!!!!!
rHDMA3			equ $FF53 ; GBC DMA destination ptr
rHDMA4			equ $FF54
rHDMA5			equ $FF55 ; GBC DMA length
rBGPI			equ $FF68 ;  BG Pal Index
rBGPD			equ $FF69 ;  BG Pal Data
rOBPI			equ $FF6A ; OBJ Pal Index
rOBPD			equ $FF6B ; OBJ Pal Data
rSVBK			equ $FF70 ; WRAM Bank
rIE				equ $FFFF


OAM_SIZE		equ (OAMEnd - rOAM)
OAM_SPRITE_SIZE	equ 4
NB_OF_SPRITES	equ (OAM_SIZE / OAM_SPRITE_SIZE)

BG_PALETTE_STRUCT_SIZE	equ 4 * 3
OBJ_PALETTE_STRUCT_SIZE	equ 3 * 3

INTERACTION_STRUCT_SIZE	equ 16

NPC_STRUCT_SIZE	equ 16 ; (wNPC1_ypos - wNPC0_ypos)

