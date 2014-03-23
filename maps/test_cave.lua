local room = {
	random_bounds = false,
	width = 50,
	height = 50,
	fov = 25,
	type = "cave",
	name = "Test Cave",

	gold = {min = 10, max = 100, spawnchance = 850},
	items = {
		spawnchance = 350,
		{name="blue_mail",chance=15,unique=true,global=true},
		{name="purple_mail",chance=30},
	}
}

return room