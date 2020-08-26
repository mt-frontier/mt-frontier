minetest.register_node("frontier_biomes:dirt_with_deciduous_litter", {
	description = "Dirt with Deciduous Litter",
	tiles = {"frontier_biomes_deciduous_litter.png", "default_dirt.png",
		{name = "default_dirt.png^frontier_biomes_deciduous_litter_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_biome({
		name = "deciduous_highland",
		node_top = "frontier_biomes:dirt_with_deciduous_litter",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 8,
		heat_point = 53,
		humidity_point = 60,
})
