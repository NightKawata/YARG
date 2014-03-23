tile = class("tile")

function tile:initialize(x,y,solid,flags)
	self.x = x
	self.y = y
	self.solid = solid
	self.symbol = self.solid and "#" or "."
	self.color = flags and flags.color or {255,255,255}
end

function tile:draw()
	love.graphics.setColor(self.color)
	love.graphics.print(self.symbol, self.x, self.y)
	love.graphics.setColor(255,255,255)
end