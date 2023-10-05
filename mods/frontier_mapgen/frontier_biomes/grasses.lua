
-- Grasses

for length = 1, 5 do
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_coniferous_litter"},
		fill_ratio = 0.012,
		sidelen = 16,
		y_max = 30,
		y_min = 1,
		sidelen = 16,
		biomes = {"pine_savanna"},
		decoration = "default:grass_"..length,
	})
end

local function register_grass_decoration(offset, scale, length)

    minetest.register_decoration({
        name = "frontier_biomes:grass_" .. length,
        deco_type = "simple",
        place_on = {"default:dirt_with_coniferous_litter", "default:dirt_with_grass", "default:dirt_with_rainforest_litter", "default:dirt_with_rainforest_litter"},
        visual_scale = 1.4,
        sidelen = 16,
        noise_params = {
            offset = offset,
            scale = scale,
            spread = {x = 200, y = 200, z = 200},
            seed = 329,
            octaves = 3,
            persist = 0.6
        },
        biomes = {"swamp_forest", "swamp", "grassland", "deciduous_forest", "pine_savanna"},
        y_max = 31000,
        y_min = 1,
        decoration = "default:grass_" .. length,
    })
end

local function register_dry_grass_decoration(offset, scale, length)
    minetest.register_decoration({
        name = "frontier_biomes:dry_grass_" .. length,
        deco_type = "simple",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = 16,
        visual_scale = 1.4,
        noise_params = {
            offset = offset,
            scale = scale,
            spread = {x = 200, y = 200, z = 200},
            seed = 329,
            octaves = 3,
            persist = 0.6
        },
        biomes = {"savanna"},
        y_max = 31000,
        y_min = 1,
        decoration = "default:dry_grass_" .. length,
    })
end

local function register_fern_decoration(seed, length)
    minetest.register_decoration({
        name = "default:fern_" .. length,
        deco_type = "simple",
        place_on = {"default:dirt_with_coniferous_litter"},
        sidelen = 16,
        noise_params = {
            offset = 0,
            scale = 0.2,
            spread = {x = 100, y = 100, z = 100},
            seed = seed,
            octaves = 3,
            persist = 0.7
        },
        biomes = {"coniferous_forest", "floatland_coniferous_forest"},
        y_max = 31000,
        y_min = 6,
        decoration = "default:fern_" .. length,
    })
end

-- Grasses

register_grass_decoration(-0.03,  0.09,  5)
register_grass_decoration(-0.015, 0.075, 4)
register_grass_decoration(0,      0.06,  3)
register_grass_decoration(0.015,  0.045, 2)
register_grass_decoration(0.03,   0.03,  1)

-- Dry grasses

register_dry_grass_decoration(0.01, 0.05,  5)
register_dry_grass_decoration(0.03, 0.03,  4)
register_dry_grass_decoration(0.05, 0.01,  3)
register_dry_grass_decoration(0.07, -0.01, 2)
register_dry_grass_decoration(0.09, -0.03, 1)

-- Ferns

register_fern_decoration(14936, 3)
register_fern_decoration(801,   2)
register_fern_decoration(5,     1)