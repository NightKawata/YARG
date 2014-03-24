-- This is pretty much the gist of the game, where it's playable and all.
require("obj.player")
require("obj.tile")
require("obj.moneybag")
require("obj.statuses")

require("items.item")
local __size = 8
local generators = {
	cave = require("generators/cave"),
}
local font = love.graphics.getFont()
--local statuses = require("obj/statuses")

game = {
	stats = {},
}
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
	self:setStats()
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

	for y = camera.y, camera.view_y do
		for x = camera.x, camera.view_x do
			if self.objects[y] and self.objects[y][x] then
				local o = self.objects[y][x]
				if o and not o.player and o.update then o:update(dt) end
			end
		end
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
	-- Map name
	love.graphics.print(game.map_name,0,233)
	-- Who are you?
	love.graphics.print(system.name.." the "..system.class,0,1)
	-- Status
	love.graphics.setColor(statuses[system.status].color)
	love.graphics.print("Status: "..statuses[system.status].name,0,9)
	love.graphics.setColor(255,255,255)
	-- Gold
	local gold_string = system.gold.."/"..system.max_gold..system.gold_icon
	love.graphics.print(gold_string,320-(font:getWidth(gold_string))-2,233)
	-- HP
	local hp_string = (system.hp).."/"..(system.max_hp+system.hp_bonus).."HP"
	love.graphics.print(hp_string,320-(font:getWidth(hp_string))-2,1)
	-- MP
	local mp_string = (system.mp).."/"..(system.max_mp+system.mp_bonus).."MP"
	love.graphics.print(mp_string,320-(font:getWidth(mp_string))-2,9)
	-- XP
	local xp_string = system.xp.."/"..system.max_hp.."XP"
	love.graphics.print(xp_string,320-(font:getWidth(xp_string))-2,17)
	-- LEVEL
	local level_string = "AGI "..system.agi
	love.graphics.print(level_string,320-(font:getWidth(level_string))-7,225)
end

function game:keypressed(k)
	if game.player and game.player.keypressed then game.player:keypressed(k) end

	if k == "r" then
		game:refresh()
	end

	if k == "p" then
		game:inflictStatus("poison")
	end

	if k == "b" then
		game:inflictStatus("frosted")
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
	game.gold_data = room.gold
	game.item_data = room.items
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

function game:kill(obj,dynamic)
	if obj.kill then obj:kill() end

	if dynamic then
		-- kill from a list
	else
		-- kill from a grid
		if game.objects[obj.y/8] and game.objects[obj.y/8][obj.x/8] then
			game.objects[obj.y/8][obj.x/8] = tile:new(obj.x, obj.y, false, {color=game.nonsolcolor})
		end
	end
end

function game:inflictStatus(status)
	if not status then return end
	if system.status == "normal" then
		self:setStats()
	end

	if status == "normal" then
		self:restoreStats()
	end

	system.status = status
	if statuses[status].init then statuses[status]:init() end
end

function game:setStats()
	local stats = game.stats
	stats.hp = system.hp
	stats.mp = system.mp
	stats.atk = system.atk
	stats.def = system.def
	stats.mat = system.mat
	stats.mdf = system.mdf
	stats.agi = system.agi
end

function game:restoreStats()
	local stats = game.stats
	system.hp = stats.hp
	system.mp = stats.mp
	system.atk = stats.atk 
	system.def = stats.def 
	system.mat = stats.mat
	system.mdf = stats.mdf 
	system.agi = stats.agi
end

return game