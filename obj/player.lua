player = class("player")

local isDown = love.keyboard.isDown

function player:initialize(x,y)
	self.x = x
	self.y = y
	self.gx = x/8
	self.gy = y/8
	self.color = {255, 255, 255}
	self.player = true
	self.can_move = true
end

function player:update(dt)
	self.gx = self.x/8
	self.gy = self.y/8
end

function player:draw()
	love.graphics.setColor(self.color)
	love.graphics.print("@", self.x, self.y)
	love.graphics.setColor(255, 255, 255)
end

function player:keypressed(k)
	if k == "right" then
		if self:check(self.gx+1, self.gy) then
			self.x = self.x + 8
		end
	end

	if k == "down" then
		if self:check(self.gx, self.gy+1) then
			self.y = self.y + 8
		end
	end

	if k == "left" then
		if self:check(self.gx-1, self.gy) then
			self.x = self.x - 8
		end
	end

	if k == "up" then
		if self:check(self.gx, self.gy-1) then
			self.y = self.y - 8
		end
	end
end

function player:check(x,y)
	-- Sees if you can even move that direction
	if game.objects[y] and game.objects[y][x] then
		--print(game.objects[y][x])
		if game.objects[y][x].solid then
			return false
		else
			return true
		end
	else
		-- What are we even doing
		return false
	end
end