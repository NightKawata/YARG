--[[
	THE CAVE GENERATOR

	100% CAVE, 200% TEDIOUS TO PROGRAM

	-----Docs-----
	
	Q: What are unique items?
	A: They'll only spawn once on that map.

	Q: What are global items?
	A? They'll only ever spawn once.

	Q: What's the difference between global items and unique items?
	A: Have you been drinking brake fluid? Global items only spawn once in a game, 
	and unique items only spawn once on that map.

	Q: How long did this take to make?
	A: Oh god I don't even know

]]--
local cell = class("cell")
local cellbox = {}
local mem = 400
local map = {}
local dirs = {"up", "down", "left", "right"}
local __solcolor = {32,128,32}
local __nonsolcolor = {128,64,0}

local function spawnCell(x,y)
	if mem > 0 then
		table.insert(cellbox, cell:new(x,y))
		mem = mem - 1
		--print("*** CELLS LEFT TO FILL: "..mem)
	end
end

function cell:initialize(x,y)
	self.x = x
	self.y = y
	self.active = true
	self.dug = 0
	self.dir = dirs[love.math.random(1,#dirs)]
	--print("** X/Y: "..self.x..", "..self.y)
end

function cell:dig()
	if self.dir == "up" then
		self.y = self.y - 1
	elseif self.dir == "down" then
		self.y = self.y + 1
	elseif self.dir == "left" then
		self.x = self.x - 1
	elseif self.dir == "right" then
		self.x = self.x + 1
	end
	if map[self.y] and map[self.y][self.x] then -- Make sure it exists
		if map[self.y][self.x] == 1 then -- Is something there?
			--print("*** GOT A BLOCK!")
			map[self.y][self.x] = 0
		else
			--print("*** NO BLOCK!")
			--self.active = false
			--spawnCell(self.x,self.y)
			self.dir = dirs[love.math.random(1,#dirs)]
			self:dig()
		end
	end
	local spawnchance = love.math.random(1,20)
	if spawnchance == 1 then
		spawnCell(self.x,self.y)
	end
	self.dug = self.dug + 1
	if self.dug >= 25 then
		self.active = false
	end
end


local function generate(state, room)
	-- 1 is not passable, 0 is
	cellbox = {} -- Hold all the cells
	mem = math.floor((state.map_width+state.map_height)/2)*10 -- Calculate dynamic memory
	map = {}

	-- First make a massive filled space
	width, height = state.map_width-1, state.map_height-1
	for y = 1, height do
		map[y] = {}
		for x = 1, width do
			map[y][x] = 1
		end
	end
	local cx, cy = math.floor(width/2), math.floor(height/2)

	-- Now we need some cells
	for i = 1, 6 do
		spawnCell(cx, cy)
	end

	-- Now it's time to generate the map
	local time = 0
	while (mem > 0) do
		time = time + 1
		for i,v in pairs(cellbox) do
			if v.active then v:dig() end -- Make them dig
		end

		-- Just to keep this quick
		if time >= 300 and #cellbox >= 1 then
			mem = mem - 30
		elseif time >= 325 and #cellbox <= 1 then
			mem = mem - 60
		end

		-- We're done!
		--[[
		if mem <= 0 then
			print("# OF ITERATIONS: "..time)
		end
		--]]
	end


	room.items = {}

	for y = 1, height do
		room[y] = {}
		for x = 1, width do
			room[y][x] = {}
			if map[y] and map[y][x] then
				local goldgen = love.math.random(1,
				state.gold_data and state.gold_data.spawnchance or 600) -- for spawning random stuff
				local itemgen = love.math.random(1,
				state.item_data and state.item_data.spawnchance or 300) -- for items
				if (goldgen == 4 or goldgen == 16) and map[y][x] == 0 then
					-- Spawn gold
					local gold_amount = 0 -- How much gold

					-- Make it bad if it wants to be bad
					local spawn_bad = false
					local e = love.math.random(1,25)
					if e == 1 then spawn_bad = true end -- WHO'S BAD

					-- Now figure out how much gold to spawn
					local gdata = state.gold_data
					if gdata then
						gold_amount = love.math.random(gdata.min, gdata.max)
					else
						gold_amount = love.math.random(1, 10)
					end

					-- Now actually spawn gold
					room[y][x] = moneybag:new(x*8, y*8, {money=gold_amount,bad=spawn_bad})
				elseif (itemgen == 1) and map[y][x] == 0 then
					-- Now to spawn items!
					local idata = state.item_data
					if idata then
						for i = 1, #idata do
							local chance = love.math.random(1, (idata[i].chance) or 5)
							if chance == 1 then
								if not room.items[idata[i].name]
								and not system.items[idata[i].name] then
									if idata[i].unique then
										room.items[idata[i].name] = true
									end

									if idata[i].global then
										system.items[idata[i].name] = true
									end
									room[y][x] = item:new(x*8, y*8, idata[i].name)
								end
								break
							else
								room[y][x] = tile:new(x*8, y*8, false)
								room[y][x].color = __nonsolcolor
							end
						end
					end
				else
					-- Spawn a tile
					room[y][x] = tile:new(x*8, y*8, (map[y][x]==1) and true or false)
					local r = room[y][x]
					if r.solid then 
						r.color = __solcolor
					else
						r.color = __nonsolcolor
					end
				end
			end
		end
	end

	room[cy][cx] = player:new(cx*8, cy*8)
	game.player = room[cy][cx]
	state.solcolor = __solcolor
	state.nonsolcolor = __nonsolcolor
end

return generate