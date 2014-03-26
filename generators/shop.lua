local map = {}
local solcolor = {128, 128, 128}
local nonsolcolor = {32, 32, 32}

local function generate(state, room, rdata)
	map = {} -- clear out the map
	local width, height = state.map_width, state.map_height
	local cx, cy = math.ceil(width/2), height-1

	-- First off, we need to create an empty space.
	for y = 1, height do
		map[y] = {}
		for x = 1, width do
			map[y][x] = 0
		end
	end
	
	-- Now we must make the "fencing."
	for x = 1, width do
		map[1][x] = 1
		map[height][x] = 1
	end
	map[height][math.ceil(width/2)] = 2

	for y = 1, height do
		map[y][1] = 1
		map[y][width] = 1
	end

	-- Now we must make the room based on the map

	for y = 1, height do
		room[y] = {}
		for x = 1, width do
			room[y][x] = {}
			if map[y] and map[y][x] == 0 then
				room[y][x] = tile:new(x*8, y*8, false)
				room[y][x].color = nonsolcolor
			elseif map[y] and map[y][x] == 1 then
				room[y][x] = tile:new(x*8, y*8, true)
				room[y][x].color = solcolor
			end
		end
	end

	-- now generate objects
	room[cy][cx] = player:new(cx*8, cy*8)
	game.player = room[cy][cx]
	room[height][cx] = door:new(cx*8, height*8, {warp=rdata.warp or system.first_map, exit=true})
end

return generate