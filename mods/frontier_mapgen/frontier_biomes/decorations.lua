-- All mapgens except mgv6

function biomes.register_decorations()
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dry_dirt_with_dry_grass"},
		sidelen = 4,
		noise_params = {
			offset = -1.5,
			scale = -1.5,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 4,
			persist = 1.0
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:dry_dirt",
		place_offset_y = -1,
		flags = "force_placement",
	})

	-- Taiga and temperate coniferous forest pine tree, small pine tree and log

	minetest.register_decoration({
		name = "default:pine_tree",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = 0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest", "floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_tree.mts",
		flags = "place_center_x, place_center_z",
	})

	minetest.register_decoration({
		name = "default:small_pine_tree",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = -0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest", "floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/small_pine_tree.mts",
		flags = "place_center_x, place_center_z",
	})

	minetest.register_decoration({
		name = "default:pine_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		place_offset_y = 1,
		sidelen = 80,
		fill_ratio = 0.0018,
		biomes = {"taiga", "coniferous_forest", "floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		num_spawn_by = 8,
	})

	-- Cactus

	minetest.register_decoration({
		name = "default:cactus",
		deco_type = "simple",
		place_on = {"default:desert_sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.0003,
			scale = 0.0009,
			spread = {x = 200, y = 200, z = 200},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert"},
		y_max = 31000,
		y_min = 4,
		decoration = "default:cactus",
		height = 2,
		height_max = 8,
	})

	-- Bush

	minetest.register_decoration({
		name = "default:bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"grassland", "deciduous_forest",
			"floatland_grassland"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/bush.mts",
		flags = "place_center_x, place_center_z",
	})

	-- Blueberry bush

	minetest.register_decoration({
		name = "default:blueberry_bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass", "default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 697,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"grassland", "snowy_grassland"},
		y_max = 31000,
		y_min = 32,
		place_offset_y = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/blueberry_bush.mts",
		flags = "place_center_x, place_center_z",
	})

	-- Pine bush

	minetest.register_decoration({
		name = "default:pine_bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"taiga", "snowy_grassland"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_bush.mts",
		flags = "place_center_x, place_center_z",
	})

	-- Dry shrub

	minetest.register_decoration({
		name = "default:dry_shrub",
		deco_type = "simple",
		place_on = {"default:desert_sand",
			"default:sand", "default:silver_sand"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.02,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert", "sandstone_desert", "cold_desert"},
		y_max = 31000,
		y_min = 2,
		decoration = "default:dry_shrub",
		param2 = 4,
	})

	-- Tundra moss

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:permafrost_with_stones"},
		sidelen = 4,
		noise_params = {
			offset = -0.8,
			scale = 2.0,
			spread = {x = 100, y = 100, z = 100},
			seed = 53995,
			octaves = 3,
			persist = 1.0
		},
		biomes = {"tundra"},
		y_max = 50,
		y_min = 2,
		decoration = "default:permafrost_with_moss",
		place_offset_y = -1,
		flags = "force_placement",
	})

	-- Tundra patchy snow

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {
			"default:permafrost_with_moss",
			"default:permafrost_with_stones",
			"default:stone",
			"default:gravel"
		},
		sidelen = 4,
		noise_params = {
			offset = 0,
			scale = 1.0,
			spread = {x = 100, y = 100, z = 100},
			seed = 172555,
			octaves = 3,
			persist = 1.0
		},
		biomes = {"tundra", "tundra_beach"},
		y_max = 50,
		y_min = 1,
		decoration = "default:snow",
	})

	-- Coral reef

	minetest.register_decoration({
		name = "default:corals",
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 4,
		noise_params = {
			offset = -4,
			scale = 4,
			spread = {x = 50, y = 50, z = 50},
			seed = 7013,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {
			"desert_ocean",
			"savanna_ocean",
			"swamp_ocean",
		},
		y_max = -2,
		y_min = -8,
		flags = "force_placement",
		decoration = {
			"default:coral_green", "default:coral_pink",
			"default:coral_cyan", "default:coral_brown",
			"default:coral_orange", "default:coral_skeleton",
		},
	})

	-- Kelp

	minetest.register_decoration({
		name = "default:kelp",
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = -0.04,
			scale = 0.1,
			spread = {x = 200, y = 200, z = 200},
			seed = 87112,
			octaves = 3,
			persist = 0.7
		},
		biomes = {
			"taiga_ocean",
			"snowy_grassland_ocean",
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean",
			"sandstone_desert_ocean",
			"cold_desert_ocean"},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		decoration = "default:sand_with_kelp",
		param2 = 48,
		param2_max = 96,
	})
end

biomes.register_decorations()