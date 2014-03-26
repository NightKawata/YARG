--[[
	The System Class is responsible for keeping YARG
	healthy.

	To boot it, you must simply require the class,
	call :new(), and then :boot().

	Requires MiddleClass.
]]--

-- Default stuff
local __TITLE = "YARG"
local __DEFAULT_WIDTH = 320
local __DEFAULT_HEIGHT = 240
local __DEFAULT_SCALE = 1
local __DEFAULT_FLAGS = {
	fullscreen = false,
	fullscreentype = "desktop",
	vsync = true,
}
-- Now the juicy bits
local system = class("explorers.system")

function system:initialize(title, w, h, flags)
	-- Sets all the default stuff. Arguments are optional.
	self:setTitle(title)
	self:setWidth(w)
	self:setHeight(h)
	self:setFlags(flags)
	self:setScale(flags and flags.scale or __DEFAULT_SCALE)
	self:setupWindow()
	self:setupVars()

	self.state = nil
end

function system:boot(boot_state)
	-- Boots up the system and gets ready to ROCK.
	-- boot_state is the state that the system will boot into.
	self:switchState(boot_state)
end

function system:setupWindow()
	-- Makes sure the window is set up properly.
	love.graphics.setDefaultFilter("nearest","nearest")
	love.window.setTitle(self.title)
	love.window.setMode(self.width*self.scale, self.height*self.scale, self.flags)
end

function system:setTitle(title)
	-- Sets the name of the window.
	self.title = title or __TITLE
end

function system:setWidth(w)
	-- Sets the window's width.
	self.width = w or __DEFAULT_WIDTH
end

function system:setHeight(h)
	-- Sets the window's height.
	self.height = h or __DEFAULT_HEIGHT
end

function system:setFlags(flags)
	-- Sets various flags for the window.
	self.flags = flags or __DEFAULT_FLAGS
end

function system:setScale(scale)
	-- Sets the window scale.
	self.scale = scale or __DEFAULT_SCALE
end

function system:switchState(state)
	-- Switches the system's state. With no arguments, it does nothing.
	if not state then return end
	if self.state then if self.state.close then self.state:close() end end
	self.state = state
	if self.state.open then self.state:open() end
end

function system:setupVars()
	-- base stats
	self.max_hp = 50
	self.max_mp = 10
	self.hp = self.max_hp
	self.mp = self.max_mp
	self.atk = 5
	self.def = 5
	self.mat = 5
	self.mdf = 5
	self.agi = 5
	-- stat bonuses
	self.hp_bonus = 0
	self.mp_bonus = 0
	self.atk_bonus = 0
	self.def_bonus = 0
	self.mat_bonus = 0
	self.mdf_bonus = 0
	self.agi_bonus = 0
	-- classy stuff
	self.level = 1
	self.class = "Adventurer"
	self.name = "???"
	-- xp (because yes)
	self.xp = 0
	self.max_xp = 100
	-- gold stuff
	self.gold = 0
	self.max_gold = 500
	self.gold_icon = "G"
	-- buff stuff
	self.status = "normal"
	-- system stuff
	self.first_map = "test_cave"
	self.map_path = "maps/"
	self.playercolor = {255,255,255}
	system.keyrepeat = true

	self.items = {} -- for items that have spawned in the past (only for global items)

	local font = love.graphics.newFont("gfx/VGA8.ttf",8)
	love.graphics.setFont(font)
end

-- System related callbacks

function system:update(dt)
	if self.state and self.state.update then self.state:update(dt) end
end

function system:draw()
	love.graphics.scale(self.scale,self.scale)
	if self.state and self.state.draw then self.state:draw() end
	love.graphics.scale(self.scale,self.scale)
end

function system:keypressed(k)
	if self.state and self.state.keypressed then self.state:keypressed(k) end
end

function system:keyreleased(k)
	if self.state and self.state.keyreleased then self.state:keyreleased(k) end
end

function system:quit()
	if self.state and self.state.quit then self.state:quit() end
end

return system