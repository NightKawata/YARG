local itemlist = {
	["blue_mail"] = {
		symbol = "M",
		color = {128, 128, 255},
		effect = function(player) 
			system.def_bonus = 3
			system.playercolor = {128, 128, 255}
			game.player.color = {128, 128, 255}
		end,
	},




}

return itemlist