
-------------
-- Marsh grass
-------------

minetest.register_node("frontier_plants:dirt_with_marsh_grass", {
	description = "Marsh Grass",
	drawtype = "plantlike_rooted",
	waving = 1,
	tiles = {"default_dirt.png"},
	special_tiles = {{name = "frontier_plants_marsh_grass.png", tileable_vertical= true}},
	visual_scale = 2,
	inventory_image = "frontier_plants_marsh_grass.png",
	paramtype = "light",
	paramtype2 = "leveled",
	groups = {crumbly = 3},
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 1.75, 0.5},
		},
	},
	node_dig_prediction = "default:dirt",
	node_placement_prediction = "",
	drop = "frontier_plants:marsh_grass",
	after_dig_node = function(pos)
		minetest.set_node(pos, {name = "default:dirt"})
	end,
	sounds = default.node_sound_sand_defaults({
		dig = {name = "default_dig_snappy", gain = 0.2},
		dug = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_craftitem("frontier_plants:marsh_grass", {
	description = "Marsh Grass",
	inventory_image = "frontier_plants_marsh_grass.png",
})

minetest.register_craft({
	type = "fuel",
	recipe = "frontier_plants:marsh_grass",
	burntime = 2,
})

minetest.register_decoration({
	name = "frontier_plants:dirt_with_marsh_grass",
	deco_type = "simple",
	place_on = {"default:dirt"},
	sidelen = 16,
	noise_params = {
		offset = 0.3,
		scale = 0.3,
		spread = {x = 200, y = 200, z = 200},
		seed = 137,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"pine_savanna_shore", "pine_savanna"},
	y_max = 1,
	y_min = 0,
	decoration = "frontier_plants:dirt_with_marsh_grass",
	param2_max = 16,
	param2 = 16,
	place_offset_y = -1,
	flags = "force_placement",
})
