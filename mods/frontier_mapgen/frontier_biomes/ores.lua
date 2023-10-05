-- All mapgens except mgv6

function biomes.register_ores()

	-- Stratum ores.
	-- These obviously first.

	-- Silver sandstone

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:silver_sandstone",
		wherein         = {"default:stone"},
		clust_scarcity  = 1,
		y_max           = 46,
		y_min           = 10,
		noise_params    = {
			offset = 28,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 4,
		biomes = {"cold_desert"},
	})

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:silver_sandstone",
		wherein         = {"default:stone"},
		clust_scarcity  = 1,
		y_max           = 42,
		y_min           = 6,
		noise_params    = {
			offset = 24,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 2,
		biomes = {"cold_desert"},
	})

	-- Desert sandstone

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:desert_sandstone",
		wherein         = {"default:desert_stone"},
		clust_scarcity  = 1,
		y_max           = 46,
		y_min           = 10,
		noise_params    = {
			offset = 28,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 4,
		biomes = {"desert"},
	})

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:desert_sandstone",
		wherein         = {"default:desert_stone"},
		clust_scarcity  = 1,
		y_max           = 42,
		y_min           = 6,
		noise_params    = {
			offset = 24,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 2,
		biomes = {"desert"},
	})

	-- Sandstone

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:sandstone",
		wherein         = {"default:desert_stone"},
		clust_scarcity  = 1,
		y_max           = 39,
		y_min           = 3,
		noise_params    = {
			offset = 21,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 2,
		biomes = {"desert"},
	})

	-- Blob ore.
	-- These before scatter ores to avoid other ores in blobs.

	-- Clay

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:clay",
		wherein         = {"default:sand"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 0,
		y_min           = -15,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Silver sand

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:silver_sand",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 2316,
			octaves = 1,
			persist = 0.0
		},
		biomes = {"icesheet_ocean", "tundra", "tundra_beach", "tundra_ocean",
			"taiga", "taiga_ocean", "snowy_grassland", "snowy_grassland_ocean",
			"grassland", "grassland_ocean", "coniferous_forest",
			"coniferous_forest_ocean", "deciduous_forest",
			"deciduous_forest_shore", "deciduous_forest_ocean", "cold_desert",
			"cold_desert_ocean", "savanna", "savanna_shore", "savanna_ocean",
			"swamp_forest", "swamp", "swamp_ocean", "underground",
			"floatland_coniferous_forest", "floatland_coniferous_forest_ocean"}
	})

	-- Dirt

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:dirt",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
		},
		biomes = {"taiga", "snowy_grassland", "grassland", "coniferous_forest",
			"deciduous_forest", "deciduous_forest_shore", "savanna", "savanna_shore",
			"swamp_forest", "swamp", "floatland_coniferous_forest"}
	})

	-- Gravel

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gravel",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
		biomes = {"icesheet_ocean", "tundra", "tundra_beach", "tundra_ocean",
			"taiga", "taiga_ocean", "snowy_grassland", "snowy_grassland_ocean",
			"grassland", "grassland_ocean", "coniferous_forest",
			"coniferous_forest_ocean", "deciduous_forest",
			"deciduous_forest_shore", "deciduous_forest_ocean", "cold_desert",
			"cold_desert_ocean", "savanna", "savanna_shore", "savanna_ocean",
			"swamp_forest", "swamp", "swamp_ocean", "underground",
			"floatland_coniferous_forest", "floatland_coniferous_forest_ocean"}
	})

	-- Sheet ores

	-- Coal

	minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		column_height_min = 1,
		column_height_max = 1,
		column_midpoint_factor = 0.5,
		y_max          = 1000,
		y_min          = -30000,
		noise_threshold = 0,
		noise_params = {
			offset = -0.1,
			scale = 0.2,
			spread = {x = 6, y = 6, z = 6},
			seed = 59,
			octaves = 2,
			persists = 0.6
		}
	})
	
	minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		column_height_min = 1,
		column_height_max = 1,
		column_midpoint_factor = 0.5,
		y_max          = -32,
		y_min          = -30000,
		noise_threshold = 0,
		noise_params = {
			offset = -0.07,
			scale = 0.2,
			spread = {x = 6, y = 6, z = 6},
			seed = 131,
			octaves = 2,
			persists = 0.6
		}
	})

	minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		column_height_min = 1,
		column_height_max = 1,
		column_midpoint_factor = 0.5,
		y_max          = -128,
		y_min          = -30000,
		noise_threshold = 0,
		noise_params = {
			offset = -0.05,
			scale = 0.2,
			spread = {x = 6, y = 6, z = 6},
			seed = 377,
			octaves = 2,
			persists = 0.6
		}
	})

	-- Iron
	
	minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:stone_with_iron",
		wherein        = "default:stone",
		column_height_min = 1,
		column_height_max = 1,
		column_midpoint_factor = 0.5,
		y_max          = -64,
		y_min          = -30000,
		noise_threshold = 0,
		noise_params = {
			offset = -0.09,
			scale = 0.2,
			spread = {x = 4, y = 4, z = 4},
			seed = 81,
			octaves = 2,
			persists = 0.6
		}
	})

	minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:stone_with_iron",
		wherein        = "default:stone",
		column_height_min = 1,
		column_height_max = 1,
		column_midpoint_factor = 0.5,
		y_max          = -128,
		y_min          = -30000,
		noise_threshold = 0,
		noise_params = {
			offset = -0.04,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 81,
			octaves = 2,
			persists = 0.6
		}
	})
	
	-- Gold

	minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		column_height_min = 1,
		column_height_max = 1,
		column_midpoint_factor = 0.5,
		y_max          = 128,
		y_min          = -30000,
		noise_threshold = 0,
		noise_params = {
			offset = -0.16,
			scale = 0.2,
			spread = {x = 3, y = 3, z = 3},
			seed = 107,
			octaves = 2,
			persists = 0.6
		}
	})

	minetest.register_ore({
		ore_type       = "sheet",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		column_height_min = 1,
		column_height_max = 1,
		column_midpoint_factor = 0.5,
		y_max          = -128,
		y_min          = -30000,
		noise_threshold = 0,
		noise_params = {
			offset = -0.11,
			scale = 0.2,
			spread = {x = 3, y = 3, z = 3},
			seed = 731,
			octaves = 2,
			persists = 0.6
		}
	})
end

biomes.register_ores()