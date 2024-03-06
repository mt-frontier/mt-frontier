minetest.register_node("frontier_plants:saw_palmetto", {
	description = "Saw Palmetto",
	drawtype = "plantlike",
	tiles = {"frontier_plants_saw_palmetto.png"},
	inventory_image = "frontier_plants_saw_palmetto.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed ={
			{-1/2, 0 , -1/2, 1/2, -1/2, 1/2}
		}
	},
	groups = {snappy = 2, choppy = 3, oddly_breakable_by_hand = 1, attached_node = 1, flora = 1},
	after_place_node = function(pos)
		minetest.set_node(pos, {name = "frontier_plants:saw_palmetto", param2 = 2})
	end,
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_coniferous_litter", "default:sand"},
	sidelen = 8,
	noise_params = {
		offset = -0.01,
		scale = 0.1,
		spread = {x = 100, y = 100, z = 100},
		seed = 76,
		octaves = 3,
		persists = 0.7,
	},
	biomes = {"pine_savanna"},
	decoration = "frontier_plants:saw_palmetto",
	param2 = 2
})

frontier_craft.register_craft("hand", "farming:string", {inputs={"frontier_plants:saw_palmetto"}})