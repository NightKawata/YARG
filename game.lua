-- This is pretty much the gist of the game, where it's playable and all.
require("obj.player")
require("obj.tile")
local __size = 8
local generators = {
	cave = require("generators/cave"),
}

game = {}
camera = {
	x = 1,
	y = 1,
	view_x = 20,
	view_y = 20,
	fov = 20,
}

function game:open()
	self:refresh()
end

function game:refresh()
	love.keyboard.setKeyRepeat(true)
	self:loadMap()
end

function game:update(dt)
	if game.player then
		camera.x = (game.player.x/__size) - (camera.fov/2)
		camera.y = (game.player.y/__size) - (camera.fov/2)
		camera.view_x = camera.x + camera.fov
		camera.view_y = camera.y + camera.fov
		camera.vx = game.player.x - 160
		camera.vy = game.player.y - 120

		if game.player.update then game.player:update(dt) end
	end

	--print(camera.x, camera.y)
end

function game:draw()
	love.graphics.push()
	love.graphics.translate(-camera.vx, -camera.vy)
	for y = camera.y, camera.view_y do
		for x = camera.x, camera.view_x do
			if self.objects[y] and self.objects[y][x] then
				local o = self.objects[y][x]
				if o and not o.player and o.draw then o:draw() end
			end
		end
	end
	if game.player and game.player.draw then game.player:draw() end
	love.graphics.pop()
	love.graphics.print(game.map_name,0,233)
	love.graphics.print(system.name.." the "..system.class,0,1)
end

function game:keypressed(k)
	if game.player and game.player.keypressed then game.player:keypressed(k) end

	if k == "r" then
		game:refresh()
	end
end

function game:keyreleased(k)
	if game.player and game.player.keyreleased then game.player:keyreleased(k) end
end

function game:loadMap(mapfile)
	self:clearObjects()
	-- We need to get our map, so let's do that
	local map = mapfile or system.first_map
	local room = love.filesystem.load(system.map_path..map..".lua")()

	-- Do we need to make the width/height random?
	game.map_name = room.name -- We'll need that
	if room.random_bounds then
		game.map_width = love.math.random(room.min_width, room.max_width)-1
		game.map_height = love.math.random(room.min_height, room.max_height)-1
	else
		-- If not, it's set, so don't worry (be happy)
		game.map_width = room.width-1
		game.map_height = room.height-1
	end
	generators[(room.type or "cave")](self, self.objects)
end

function game:clearObjects()
	self.objects = nil
	self.objects = {}
	self.player = nil
end

return game