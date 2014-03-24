statuses = {
	poison = {
		-- POISON: Constant damage until healed
		name = "Poison",
		color = {128, 0, 255},
		floordamage = true,
		steps = 10,
	},

	normal = {
		-- NORMAL: Boring
		name = "Normal",
		color = {255, 255, 255},

	},

	burn = {
		-- BURN: Cripples ATK, boosts fire power
		name = "Burn",
		color = {255, 128, 0},
		steps = 100,
		init = function()
			system.atk = math.floor(system.atk/4)
		end,
	},

	armorless = {
		-- ARMORLESS: No base DEF! Oh noes!
		name = "Armorless",
		color = {128, 128, 128},
		steps = 100,
		init = function()
			system.def = 0
		end,
	},

	frosted = {
		-- FROSTED: You'll be slowing down quite a bit!
		name = "Frosted",
		color = {0, 255, 255},
		steps = 10,
		cure_steps = 100,
		init = function()
			system.agi = math.max(1,math.floor(system.agi/1.25))
		end,
	}
}