
-- AEVILIA HELPER
-- v0.1.0 by ISSOtm


-- Wrap everything in this function so ending the script doesn't spawn a shitton of errors in the console

function drawHUD()
	-- Addresses and constants
	
	wCameraYPos = 0xC249
	wCameraXPos = 0xC24B
	
	wWalkInterCount = 0x01D400
	wBtnInterCount = 0x01D401
	wWalkingInteractions = 0x01D200
	wButtonInteractions = 0x01D280
	
	wWalkLoadZoneCount = 0x01D402
	wBtnLoadZoneCount = 0x01D403
	wWalkingLoadZones = 0x01D300
	wButtonLoadZones = 0x01D380
	
	wNumOfNPCs = 0x01D40F
	wNPC0_ypos = 0x01D410
	NPCstructlength = 16
	
	wYPos = 0xC243
	wXPos = 0xC245
	wPlayerDir = 0xC247
	
	rVBK = 0xFF4F
	rSVBK = 0xFF70
	
	interactionoffsets = {{7, 7}, {16, 7}, {9, 1}, {9, 14}}
	
	wLoadedMapROMBank = 0xC238
	wMapWidth = 0xC23C
	wBlockPointer = 0xC23E
	
	wBlockMetadata = 0x01D000
	blockstructlength = 8
	
	
	-- Utilities
	
	hexdigits = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	function dectohex(input)
		num = math.floor(input)
		if num ~= input then
			console.log("Warning : " .. input .. " is not a number. Parsing " .. num)
		end
		
		if num == 0 then
			return "0"
		else
			str = ""
			while num ~= 0 do
				str = hexdigits[num % 16 + 1] .. str
				num = math.floor(num / 16)
			end
			return str
		end
	end
	
	function readmemory(addr, func)
		memory.usememorydomain("System Bus")
		
		busaddr = addr % 0x10000
		bank = math.floor(addr / 0x10000)
		readbyte = 0
		
		if busaddr < 0x4000 then
			-- ROM0
			
			if bank ~= 0 then
				console.log("Warning : ROM0 is not bankable !")
			end
			
			readbyte = func(busaddr)
		elseif busaddr < 0x8000 then
			-- ROMX
			
			if bank > 0xFF then
				console.log("Warning : bank is too large !" .. bank)
				bank = bank % 0x100
			end
			
			memory.usememorydomain("ROM")
			readbyte = func(bank * 0x4000 + (busaddr - 0x4000))
		elseif busaddr < 0xA000 then
			-- VRAM
			
			if bank > 0x01 then
				console.log("Warning : bank is too large !" .. bank)
				bank = bank % 0x02
			end
			
			oldbank = memory.readbyte(rVBK)
			memory.writebyte(rVBK, bank)
			readbyte = func(busaddr)
			memory.writebyte(rVBK, oldbank)
		elseif busaddr < 0xC000 then
			-- SRAM (NYI)
			
			if bank > 0x0F then
				console.log("Warning : bank is too large !" .. bank)
				bank = bank % 0x10
			end
			
			readbyte = func(busaddr)
		elseif busaddr < 0xD000 then
			-- WRAM0
			
			if bank ~= 0 then
				console.log("Warning : WRAM0 is not bankable !")
			end
			
			oldbank = memory.readbyte(rSVBK)
			memory.writebyte(rSVBK, bank)
			readbyte = func(busaddr)
			memory.writebyte(rSVBK, oldbank)
		elseif busaddr < 0xE000 then
			-- WRAMX
			
			if bank > 0x07 then
				console.log("Warning : bank is too large !" .. bank)
				bank = bank % 0x08
			end
			
			readbyte = func(busaddr)
		elseif busaddr < 0xF000 then
			-- ECH0
			
			if bank ~= 0 then
				console.log("Warning : ECH0 is not bankable !")
			end
			
			readbyte = func(busaddr)
		elseif busaddr < 0xFE00 then
			-- ECHX
			
			if bank > 0x07 then
				console.log("Warning : bank is too large !" .. bank)
				bank = bank % 0x08
			end
			
			oldbank = memory.readbyte(rSVBK)
			memory.writebyte(rSVBK, bank)
			readbyte = func(busaddr)
			memory.writebyte(rSVBK, oldbank)
		else
			-- OAM, ----, I/O, HRAM and IE
			
			if bank ~= 0 then
				console.log("Warning : FE00-FFFF is not bankable !")
			end
			
			readbyte = func(busaddr)
		end
		
		return readbyte
	end
	
	function drawbox(xpos, ypos, xsize, ysize, color)
		if xsize > 0 then
			if ysize > 0 then
				gui.drawRectangle(xpos, ypos, xsize, ysize, color)
			else
				gui.drawLine(xpos, ypos, xpos + xsize, ypos, color)
			end
		elseif ysize > 0 then
			gui.drawLine(xpos, ypos, xpos, ypos + ysize, color)
		end
	end
	
	
	-- Global variables
	
	cameraypos = 0
	cameraxpos = 0
	
	ypos = 0
	xpos = 0
	playerdir = 0
	
	mapROMbank = 0
	mapwidth = 0
	blockpointer = 0
	
	function updateglobalvars()
		cameraypos = readmemory(wCameraYPos, memory.read_u16_le)
		cameraxpos = readmemory(wCameraXPos, memory.read_u16_le)
		
		ypos = readmemory(wYPos, memory.read_u16_le)
		xpos = readmemory(wXPos, memory.read_u16_le)
		playerdir = readmemory(wPlayerDir, memory.read_u8)
		
		mapROMbank = readmemory(wLoadedMapROMBank, memory.read_u8)
		mapwidth = readmemory(wMapWidth, memory.read_u8)
		blockpointer = readmemory(wBlockPointer, memory.read_u16_le)
	end
	
	updateglobalvars()
	
	
	-- Submodules
	
	function drawinteractions()
	--	gui.DrawNew("Interactions")
		
		baseaddr = wWalkingInteractions
		
		for i = 1,readmemory(wWalkInterCount, memory.read_u8) do
			interypos = readmemory(baseaddr, memory.read_u16_le)
			interxpos = readmemory(baseaddr + 2, memory.read_u16_le)
			interybox = readmemory(baseaddr + 4, memory.read_u8)
			interxbox = readmemory(baseaddr + 5, memory.read_u8)
			
			drawbox(interxpos - cameraxpos, interypos - cameraypos, interxbox - 1, interybox - 1, 0xFF0000FF)
			
			baseaddr = baseaddr + 8
		end
		
		baseaddr = wButtonInteractions
		
		for i = 1,readmemory(wBtnInterCount, memory.read_u8) do
			interypos = readmemory(baseaddr, memory.read_u16_le)
			interxpos = readmemory(baseaddr + 2, memory.read_u16_le)
			interybox = readmemory(baseaddr + 4, memory.read_u8)
			interxbox = readmemory(baseaddr + 5, memory.read_u8)
			
			drawbox(interxpos - cameraxpos, interypos - cameraypos, interxbox - 1, interybox - 1, 0xFF0080FF)
			
			baseaddr = baseaddr + 8
		end
		
	--	gui.DrawFinish()
	end
	
	function drawloadzones()
	--	gui.DrawNew("Loadzones")
		
		baseaddr = wWalkingLoadZones
		
		for i = 1,readmemory(wWalkLoadZoneCount, memory.read_u8) do
			loadzoneypos = readmemory(baseaddr, memory.read_u16_le)
			loadzonexpos = readmemory(baseaddr + 2, memory.read_u16_le)
			loadzoneybox = readmemory(baseaddr + 4, memory.read_u8)
			loadzonexbox = readmemory(baseaddr + 5, memory.read_u8)
			
			drawbox(loadzonexpos - cameraxpos, loadzoneypos - cameraypos, loadzonexbox - 1, loadzoneybox - 1, 0xFF8000FF)
			
			baseaddr = baseaddr + 8
		end
		
		baseaddr = wButtonLoadZones
		
		for i = 1,readmemory(wBtnLoadZoneCount, memory.read_u8) do
			loadzoneypos = readmemory(baseaddr, memory.read_u16_le)
			loadzonexpos = readmemory(baseaddr + 2, memory.read_u16_le)
			loadzoneybox = readmemory(baseaddr + 4, memory.read_u8)
			loadzonexbox = readmemory(baseaddr + 5, memory.read_u8)
			
			drawbox(loadzonexpos - cameraxpos, loadzoneypos - cameraypos, loadzonexbox - 1, loadzoneybox - 1, 0xFF8080FF)
			
			baseaddr = baseaddr + 8
		end
		
	--	gui.DrawFinish()
	end
	
	function drawnpcs()
	--	gui.DrawNew("NPCs")
		
		baseaddr = wNPC0_ypos
		
		for i = 0,readmemory(wNumOfNPCs, memory.read_u8) do
			npcypos = readmemory(baseaddr, memory.read_u16_le)
			npcxpos = readmemory(baseaddr + 2, memory.read_u16_le)
			npcybox = readmemory(baseaddr + 4, memory.read_u8)
			npcxbox = readmemory(baseaddr + 5, memory.read_u8)
			
			if npcxbox ~= 0 and npcybox ~= 0 then
				drawbox(npcxpos - cameraxpos, npcypos - cameraypos, npcxbox - 1, npcybox - 1)
			end
			
			baseaddr = baseaddr + NPCstructlength
		end
		
	--	gui.DrawFinish()
	end
	
	function drawplayerbox()
	--	gui.DrawNew("Player Box")
		
		drawbox((xpos - cameraxpos + 2) % 0x10000, (ypos - cameraypos + 8) % 0x10000, 11, 7, 0xFFFF0000)
		
	--	gui.DrawFinish()
	end
	
	function drawplayerinteractpoints()
	--	gui.DrawNew("Player Interact Point")
		
		gui.drawPixel(xpos - cameraxpos, ypos - cameraypos, 0xFFC0C0C0)
		offsets = interactionoffsets[playerdir + 1]
		gui.drawPixel(xpos - cameraxpos + offsets[2], ypos - cameraypos + offsets[1], 0xFFFFFF00)
		
	--	gui.DrawFinish()
	end
	
	function drawcollision()
	--	gui.DrawNew("Collision")
		
		addr = (mapROMbank * 0x10000) + blockpointer + (math.floor(cameraypos / 16) * mapwidth + math.floor(cameraxpos / 16))
		
		for y = 0,10 do
			lineaddr = addr
			for x = 0,11 do
				blockID = readmemory(addr, memory.read_u8)
				if bit.band(readmemory(wBlockMetadata + blockID * blockstructlength + 1, memory.read_u8), 0x10) == 0 then
					gui.drawRectangle(x * 16 - (cameraxpos % 16) - 1, y * 16 - (cameraypos % 16) - 1, 17, 17, 0, 0x80FF0000)
				end
				addr = addr+1
			end
			addr = lineaddr + mapwidth -- Advance by 1 width
		end
		
	--	gui.DrawFinish()
	end
	
	
	-- Main code
	
--	gui.clearGraphics()
	
	drawcollision()
	drawnpcs()
	drawinteractions()
	drawloadzones()
	drawplayerbox()
	drawplayerinteractpoints()
end

while true do
	drawHUD()
	emu.frameadvance()
end

