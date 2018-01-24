
SECTION "Tiles bank 0", VRAM[$8000],BANK[0]
v0Tiles0::
vPlayerTiles::
;	dtile 4 * 3		Overlap
	dtile 1
	
vFileSelectCornerTile::
	dtile 1
	
vFileSelectConsoleTiles::
	dtile 9
	
	dtile 2 ; Last two vPlayerTiles
	
	dtile $13
	
vDMGFontTiles::
	dtile $3C
	
	dtile $24
	
	
v0Tiles1::
	dtile $80
	
	
v0Tiles2::
	dtile 1
vBattleTextboxBorderTiles::
	dtile 3
vPicTiles::
vPicTilesRow0::
	dtile 3
vPicTilesRow1::
	dtile 3
vPicTilesRow2::
	dtile 3
vPicTilesRow3::
	dtile 3
	
vTextboxBorderTiles::
	dtile 3
	dtile 13
	
vFontTiles::
	dtile $3B
	
	dtile $24
	
	
	
SECTION "Tiles bank 1", VRAM[$8000],BANK[1]
v1Tiles0::
vPlayerWalkingTiles::
	dtile 4 * 3
	
	dtile 112
	
vEmoteTiles::
	dtile 4
	
v1Tiles1::
	dtile $80
	
v1Tiles2::
	dtile $20
	
vAlternateFontTiles::
	dtile $3C
	
	dtile $24
	
	
	
SECTION "Tile Maps", VRAM[$9800],BANK[0]
vTileMap0::
	ds $400
	
	
vTileMap1::
	ds $100
	
vTextboxTileMap::
	ds 5
vTextboxName::
	ds 27
	
	ds 1
vTextboxPicRow0::
	ds 3
	ds 1
; No text line here
	ds 27
	
	ds 1
vTextboxPicRow1::
	ds 3
	ds 1
vTextboxLine0::
	ds 27
	
	ds 1
vTextboxPicRow2::
	ds 3
	ds 1
vTextboxLine1::
	ds 27
	
	ds 1
vTextboxPicRow3::
	ds 3
	ds 1
vTextboxLine2::
	ds 27
	
vTextboxBottomBorder::
	ds VRAM_ROW_SIZE
	
vFixedMap::
	ds SCREEN_HEIGHT * VRAM_ROW_SIZE
	
	
	
SECTION "Attribute Maps", VRAM[$9800],BANK[1]
vAttrMap0::
	ds $400
	
	
vAttrMap1::
	ds $400
