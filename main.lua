--[[
	YARG - Yet Another Roguelike Game
	
	2014 NEO NEKUZEN
]]--
local sys

function love.load()
	class = require("class")
	sys = require("system")
	game = require("game")
	pmenu = require("pmenu")
	lume = require("lume")
	system = sys:new()

	system:boot(game)
end

function love.update(dt)
	system:update(dt)
end

function love.draw()
	system:draw()
end

function love.keypressed(k)
	if k == "escape" then
		love.event.quit()
	end
	system:keypressed(k)
end

function love.keyreleased(k)
	system:keyreleased(k)
end