moneybag = class("money bag")

function moneybag:initialize(x,y,p)
	self.x = x
	self.y = y
	self.color = p.bad and {128, 128, 0} or {255, 255, 0}
	if p.bad then
		self.money = -p.money or -1
	else
		self.money = p.money or 1
	end
	self.solid = false
	self.interactable = true
	self.tag = "moneybag"
	--self.entity = true
	--print(self.money)
end

function moneybag:draw()
	love.graphics.setColor(self.color)
	love.graphics.print("$",self.x,self.y)
	love.graphics.setColor(255,255,255)
end