	
SECTION "Palette data", ROMX,BANK[1]
	
DefaultPalette::
	db $1F, $1F, $1F
GrayPalette::
	db $15, $15, $15 ; These 3 are shared by Default- and GrayPalette
	db $0A, $0A, $0A
	db $00, $00, $00
InvertedPalette::
	db $00, $00, $00 ; Shared with GrayPalette
	db $0A, $0A, $0A
	db $15, $15, $15
DarkTextPalette::
	db $1F, $1F, $1F ; Shared
	db $00, $00, $00
	db $00, $00, $00
	db $00, $00, $00
	
	
; Console palettes for file select screen
ConsolePalettes::
	; Crappy emulator
	db $14, $14, $14
	db $10, $06, $05
	db $00, $00, $00
	
	; 3DS VC
	db $10, $10, $10
	db $00, $00, $12
	db $00, $00, $00
	
	; Decent emulator
	db $10, $10, $10
	db $00, $00, $00
	db $00, $00, $00
	
	; Awesome emulator
	db $14, $14, $14
	db $1F, $1C, $00
	db $00, $00, $00
	
	; GBC
	db $14, $14, $14
	db $1F, $1C, $00
	db $00, $00, $00
	
	; GBA (NYI)
	db $14, $14, $14
	db $07, $04, $0D
	db $00, $00, $00
	
	
; Title screen BG palettes
TitleScreenCloudPalette::
	db $0B, $10, $1B
	db $1F, $1F, $1F
	db $14, $14, $14
	db $00, $00, $00
TitleScreenAeviDevPalette::
	db $0B, $10, $1B
	db $08, $17, $04
	db $00, $10, $00
	db $00, $00, $00
TitleScreenDevSoftPalette::
	db $0B, $10, $1B
	db $05, $08, $15
	db $04, $04, $04 ; Text
	db $00, $00, $00
TitleScreenLogoPalette0::
	db $0B, $10, $1B
	db $05, $0D, $15
	db $05, $09, $15
	db $00, $00, $00
TitleScreenLogoPalette1::
	db $0B, $10, $1B
	db $02, $11, $1A
	db $05, $0D, $15
	db $00, $00, $00
TitleScreenLogoPalette2::
	db $0B, $10, $1B
	db $00, $17, $1B
	db $02, $11, $1A
	db $00, $00, $00
TitleScreenEvieHeadPalette::
	db $0B, $10, $1B
	db $1F, $17, $16
	db $1F, $00, $0F
	db $00, $00, $00
TitleScreenTomHeadPalette::
	db $0B, $10, $1B
	db $1F, $17, $16
	db $08, $02, $02
	db $00, $00, $00
	
; Title screen OBJ palettes
TitleScreenEyePalette::
	db $1F, $1F, $1F
	db $09, $0F, $1F
	db $08, $17, $04
TitleScreenClothesPalette::
	db $1F, $48, $1F
	db $19, $09, $09
	db $00, $00, $00
TitleScreenArmsPalette::
	db $1F, $17, $16
	db $0A, $0A, $0A ; Unused
	db $00, $00, $00
TitleScreenTomJeansPalette::
	db $02, $0B, $12
	db $03, $07, $11
	db $00, $00, $00
TitleScreenEvieJeansPalette::
	db $09, $0F, $1F
	db $02, $0B, $12
	db $00, $00, $00
	
	
CharSelectTextPalette::
	db $1F, $1F, $1F
	db $0A, $0A, $0A
	db $00, $00, $1F
	db $00, $00, $00
CharSelectEviePalette0::
	db $1F, $1F, $1F
	db $1F, $17, $16
	db $1F, $00, $0F
	db $00, $00, $00
CharSelectEviePalette1::
	db $1F, $17, $16
	db $00, $00, $1F
	db $00, $00, $10
	db $1E, $13, $10
CharSelectTomPalette0::
	db $1F, $1F, $1F
	db $1F, $17, $16
	db $08, $02, $02
	db $00, $00, $00
CharSelectTomPalette1::
	db $1F, $17, $16
	db $0C, $1B, $0E
	db $02, $1F, $02
	db $1E, $13, $10
	
	
IntroMatrixPalette
	db $00, $00, $00
	db $00, $00, $00 ; Unused
	db $00, $1F, $00
	db $00, $00, $00 ; Unused
	
	
IntroNPCPalette::
; Test NPC palette
TestNPCPalette::
	db $1F, $1F, $1F
	db $00, $00, $00
	db $00, $00, $00
	
	
EvieDefaultPalette:: ; Sprite palette : 3 colors per horizontal half
	db $1F, $17, $13
	db $1F, $0C, $1A
	db $00, $00, $00
EvieTextboxPalette::
	db $1F, $1F, $1F
	db $0A, $0A, $0A
	db $00, $00, $00
	db $1F, $0C, $1A
	
TomDefaultPalette::
	db $1F, $17, $13
	db $09, $00, $03
	db $00, $00, $00
TomTextboxPalette::
	db $1F, $1F, $1F
	db $0A, $0A, $0A
	db $00, $00, $00
	db $09, $00, $03
	
	
GenericBoyAPalette::
	db $1F, $17, $13
	db $00, $1B, $06
	db $00, $00, $00
	
	
; A few test exterior palettes
	
GrassPalette::
	db $1B, $1B, $11 ; Background
	db $12, $18, $08 ; Green
	db $09, $10, $05 ; Darker green
	db $00, $00, $00 ; Black
	
HousePalette::
	db $1B, $1B, $11 ; Grass color
	db $1A, $10, $0C ; Wall
	db $19, $0F, $09 ; Brick
	db $00, $00, $00 ; Edges
	
DoorWindowPalette::
	db $1F, $1F, $1F ; Glass
	db $1A, $10, $0C ; Wall
	db $15, $0F, $09 ; Wood
	db $00, $00, $00 ; Edges
	
RoofPalette::
	db $1B, $1B, $11 ; Grass color
	db $08, $0C, $0C ; Light color
	db $08, $0A, $0A ; Darker color
	db $00, $00, $00 ; Edges
	
WaterPalette::
	db $00, $00, $00 ; Unused
	db $08, $0F, $1F ; Darker spots
	db $08, $0A, $1F ; Water fill
	db $00, $00, $00 ; Unused
	
RockPalette::
	db $1F, $1F, $1F
	db $18, $11, $0C
	db $11, $0D, $07
	db $00, $00, $00
	
	
; Test interior palettes

InsideHousePalette::
	db $18, $1B, $18 ; Window
	db $0C, $08, $00 ; Wood
	db $1C, $0C, $00 ; Wall
	db $00, $00, $00 ; Edges
	
TestWarriorTopPalette::
	db $1F, $17, $13
	db $16, $16, $06
	db $00, $00, $00
	
TestWarriorBottomPalette::
	db $1F, $17, $13
	db $1F, $00, $04
	db $00, $00, $00
	
	
; Interior tileset palettes
	
InteriorMainPalette::
	db $1A, $1A, $19
	db $16, $0F, $09
	db $11, $0B, $09
	db $00, $00, $00
	
InteriorWallPalette::
	db $1F, $1F, $1F
	db $15, $1B, $1F
	db $0E, $17, $1C
	db $00, $00, $00
	
InteriorGreenPalette::
	db $1A, $1A, $19
	db $12, $18, $08
	db $09, $10, $05
	db $00, $00, $00
	
InteriorChairPalette::
	db $1A, $1A, $19
	db $16, $0F, $09
	db $1F, $10, $1C
	db $00, $00, $00
	
; Interior tileset palettes (darkened)
	
InteriorMainDarkPalette::
	db $0E, $0E, $0D
	db $0A, $03, $00
	db $05, $00, $00
	db $00, $00, $00
	
InteriorWallDarkPalette::
	db $13, $13, $13
	db $09, $0F, $13
	db $02, $0B, $10
	db $00, $00, $00
	
InteriorGreenDarkPalette::
	db $0E, $0E, $0D
	db $06, $0C, $00
	db $00, $04, $00
	db $00, $00, $00
	
InteriorChairDarkPalette::
	db $0E, $0E, $0D
	db $16, $0F, $09
	db $13, $04, $10
	db $00, $00, $00
	
	
EmotePalette::
	db $1F, $1F, $1F
	db $1F, $00, $00
	db $00, $00, $00
	
