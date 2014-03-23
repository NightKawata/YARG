local _items = require("items.itemlist")
item = class("item")

function item:initialize(x,y,item)
	self.x = x
	self.y = y

	self.gx = x/8
	self.gy = y/8
	self.tag = "item"
	self.interactable = true

	if item and _items[item] then
		self.symbol = _items[item].symbol
		self.color = _items[item].color or {255,255,255}
		self.effect = _items[item].effect or function() end
	else
		self.symbol = "*"
		self.color = {255,255,255}
		self.effect = function() end
	end
end

function item:update(dt)
	self.gx = self.x/8
	self.gy = self.y/8
end

function item:draw()
	love.graphics.setColor(self.color)
	love.graphics.print(self.symbol, self.x, self.y)
	love.graphics.setColor(255, 255, 255)
end