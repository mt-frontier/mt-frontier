-- Liquid
-- Swamp

local swamp_color =  "^[colorize:#88AA00:150"

minetest.register_node("frontier_biomes:swamp_water_source", {
	description = "Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png"..swamp_color,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_water_source_animated.png"..swamp_color,
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	alpha = 200,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 2,
	liquidtype = "source",
	liquid_alternative_flowing = "frontier_biomes:swamp_water_flowing",
	liquid_alternative_source = "frontier_biomes:swamp_water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 180, r = 30, g = 90, b = 60},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("frontier_biomes:swamp_water_flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png"..swamp_color,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png"..swamp_color,
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 200,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "frontier_biomes:swamp_water_flowing",
	liquid_alternative_source = "frontier_biomes:swamp_water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 180, r = 30, g = 90, b = 60},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

