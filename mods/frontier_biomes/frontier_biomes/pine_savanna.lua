minetest.register_biome({
	name = "pine_savanna",
	node_top = "default:dirt_with_coniferous_litter",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_water = "default:water_source",
	y_max = 26,
	y_min = 1,
	vertical_blend = 2,
	heat_point = 80,
	humidity_point = 60,
})

minetest.register_biome ({
	name = "pine_savanna_shore",
	node_top = "default:dirt",
	depth_top = 1,
	node_filler = "default_dirt",
	depth_filler = 3,
	node_water = "default:water_source",
	y_max = 0,
	y_min = -2,
	heat_point = 80,
	humidity_point = 60,
})

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
