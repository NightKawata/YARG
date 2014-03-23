-- The Cave generator. Very cavey.
local cell = class("cell")
local cellbox = {}
local mem = 400
local map = {}
local dirs = {"up", "down", "left", "right"}

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
			self.dug = self.dug + 1
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
	--print("!")
	cellbox = {}
	mem = math.floor((state.map_width+state.map_height)/2)*10
	map = {}
	width, height = state.map_width-1, state.map_height-1
	for y = 1, height do
		map[y] = {}
		for x = 1, width do
			map[y][x] = 1
		end
	end
	local cx, cy = math.floor(width/2), math.floor(height/2)

	for i = 1, 6 do
		spawnCell(cx, cy)
	end

	local time = 0

	while (mem > 0) do -- Now let's generate this map
		time = time + 1
		for i,v in pairs(cellbox) do
			if v.active then v:dig() end
		end

		-- Just to keep this quick
		if time >= 25000 and #cellbox >= 1 then
			mem = mem - 1
		elseif time >= 30000 and #cellbox <= 1 then
			mem = mem - 1
		end

		if mem <= 0 then
			print("# OF ITERATIONS: "..time)
		end
	end

	for y = 1, height do
		room[y] = {}
		for x = 1, width do
			room[y][x] = {}
			if map[y] and map[y][x] then
				--local obj = room[y][x]
				room[y][x] = tile:new(x*8, y*8, (map[y][x]==1) and true or false)
				local r = room[y][x]
				if r.solid then 
					r.color = {32,128,32}
				else
					r.color = {128,64,0}
				end
			end
		end
	end

	room[cy][cx] = player:new(cx*8, cy*8)
	game.player = room[cy][cx]
end

return generate