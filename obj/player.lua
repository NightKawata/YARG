player = class("player")

local isDown = love.keyboard.isDown

function player:initialize(x,y)
	self.x = x
	self.y = y
	self.gx = x/8
	self.gy = y/8
	self.color = system.playercolor
	self.player = true
	self.can_move = true
	self.steps = 0
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
			self:step()
		end
	end

	if k == "down" then
		if self:check(self.gx, self.gy+1) then
			self.y = self.y + 8
			self:step()
		end
	end

	if k == "left" then
		if self:check(self.gx-1, self.gy) then
			self.x = self.x - 8
			self:step()
		end
	end

	if k == "up" then
		if self:check(self.gx, self.gy-1) then
			self.y = self.y - 8
			self:step()
		end
	end

	if k == " " then
		self:checkfloor()
	end
end

function player:check(x,y)
	-- Sees if you can even move that direction, or you might interact with entities
	if game.objects[y] and game.objects[y][x] then
		--print(game.objects[y][x])
		if game.objects[y][x].entity then
			self:interact(game.objects[y][x])
		end

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

function player:checkfloor()
	-- Checks the floor for anything interactable
	if game.objects[self.gy] and game.objects[self.gy][self.gx] then
		local g = game.objects[self.gy][self.gx]
		if g.interactable then
			self:interact(g)
		end
	end
end

function player:interact(obj)
	local events = {
		["default"] = function()
			-- Nothing
		end,

		["moneybag"] = function()
			system.gold = lume.clamp(system.gold + obj.money, 0, system.max_gold)
			game:kill(obj)
		end,

		["item"] = function()
			if obj.effect then 
				obj:effect(self) 
			end
			game:kill(obj)
		end,





	}
	events[obj.tag or "default"]()
end

function player:step()
	self.steps = self.steps + 1

	if system.status ~= "normal" then
		local s = statuses[system.status]
		if system.status == "poison" then
			if self.steps % s.steps == 0 then
				system.hp = math.max(1, system.hp - (math.floor(system.max_hp/10)))
			end
		end

		if system.status == "burn" then
			if self.steps % s.steps == 0 then
				game:inflictStatus("normal")
			end
		end

		if system.status == "armorless" then
			if self.steps % s.steps == 0 then
				game:inflictStatus("normal")
			end
		end

		if system.status == "frosted" then
			if self.steps % s.steps == 0 then
				system.agi = math.max(1,math.floor(system.agi/1.25))
			end

			if self.steps % s.cure_steps == 0 then
				game:inflictStatus("normal")
			end
		end
	end
end