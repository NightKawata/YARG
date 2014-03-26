door = class("door")

function door:initialize(x,y,flags)
	self.x = x 
	self.y = y
	self.color = flags and flags.color or {255, 255, 255}
	self.symbol = flags and (flags.exit==true and ">" or "<") or "<"
	self.warp = flags and flags.warp or system.first_map
	self.tag = "door"
	self.interactable = true
end

function door:draw()
	love.graphics.setColor(self.color)
	love.graphics.print(self.symbol, self.x, self.y)
	love.graphics.setColor(255, 255, 255)
end