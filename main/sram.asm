
SECTION "Additional RAM", SRAM,BANK[0]
sExtra2KB::
	ds 0
	
	
SECTION "Save common", SRAM,BANK[1]
; Used to check SRAM integrity
sCommonPattern::
	ds $1000 - 3
sCommonPatternEnd::
	
; Save files non-void and valid are okay and can be loaded
; Save files non-void and invalid make a message pop up and are replaced with their backup
; Save files void are empty, their contents can't be loaded : they are overwritten with default save data anyways
; Save files are backed up during their loading only, not when saving.
sNonVoidSaveFiles::
	ds 3 ; Bitfield
	
sFirstBootPattern::
	ds $1000
sFirstBootPatternEnd::
	
	
	
SECTION "Unused bank 0", SRAM,BANK[2]
	ds 0
	
	
SECTION "Unused bank 1", SRAM,BANK[3]
	ds 0
	
	
	
SECTION "Save file 1 bank 0", SRAM,BANK[4]
sFile1Header0::
	
sFile1MagicString0::
	ds 8
	
sFile1Checksums0::
	ds $F8 ; 2 * ($2000 - $100) / $40
	
	
sFile1Data0Start::
	
sFile1WarpID::
	ds 1
sFile1MapID::
	ds 1
	
sFile1PlayerData::
	ds 14
	
sFile1ButtonFilter::
	ds 1
	
sFile1RNG::
	ds 2
	
sFile1Interactions::
	ds $400
	
sFile1InteractionCounts::
	ds 4
	
sFile1NPCScripts::
	ds 3
	
sFile1NPCArray::
	ds 9 * $10
	
sFile1Flags::
	ds $1000
	
	
SECTION "Save file 1 bank 1", SRAM,BANK[5]
sFile1Header1::
	
sFile1MagicString1::
	ds 8
	
sFile1Checksums1::
	ds $F8 ; 2 * ($2000 - $100) / $40
	
sFile1Data1Start::
	
	
SECTION "Save file 1 backup bank 0", SRAM,BANK[6]
sBackup1Header0::
	
sBackup1MagicString0::
	ds 8
	
sBackup1Checksums0::
	ds $F8 ; 2 * ($2000 - $100) / $40
	
	
sBackup1Data0Start::
	
sBackup1WarpID::
	ds 1
sBackup1MapID::
	ds 1
	
sBackup1OverworldData::
	ds 13
	
sBackup1ButtonFilter::
	ds 1
	
sBackup1MapStatuses::
	ds 3
	
SECTION "Save file 1 backup bank 1", SRAM,BANK[7]
sBackup1Header1::
	
sBackup1MagicString1::
	ds 8
	
sBackup1Checksums1::
	ds $F8 ; 2 * ($2000 - $100) / $40
	
sBackup1Data1Start::
	

	
SECTION "Save file 2 bank 0", SRAM,BANK[8]
	ds 0
	
	
SECTION "Save file 2 bank 1", SRAM,BANK[9]
	ds 0
	
	
SECTION "Save file 2 backup bank 0", SRAM,BANK[10]
	ds 0
	
	
SECTION "Save file 2 backup bank 1", SRAM,BANK[11]
	ds 0
	
	
	
SECTION "Save file 3 bank 0", SRAM,BANK[12]
	ds 0
	
	
SECTION "Save file 3 bank 1", SRAM,BANK[13]
	ds 0
	
	
SECTION "Save file 3 backup bank 0", SRAM,BANK[14]
	ds 0
	
	
SECTION "Save file 3 backup bank 1", SRAM,BANK[15]
	ds 0
