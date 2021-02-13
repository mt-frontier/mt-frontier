local schem_file = minetest.register_schematic("schems/igloo.mts")
local igloo_loot = {
	--item name, max # in stack, rarity
	{"bows:bow_wood", 1, 10},
	{"bows:arrow_steel", 9, 9},
	{"default:torch", 36, 8},
	{"default:coal_lump", 36, 7},
	{"default:coalblock", 9, 10},
	{"default:pick_steel", 1, 8},
	{"default:axe_steel", 1, 7},
	{"frontier_trees:apple", 9, 7},
	{"fire:flint_and_steel", 1, 6},
	{"craftguide:book", 1, 10},
	{"frontier_guns:shotgun_shell", 3, 14},
	{"frontier_guns:shotgun", 1, 48},
	{"frontier_guns:bullet", 2, 20},
	{"frontier_guns:revolver", 1, 64},
	{"mobs:meat", 9, 6},
}

igloo_loot = buildings.sort_loot(igloo_loot)

minetest.register_node("buildings:snowbrick", {
	description = "Packed Snow Brick",
	tiles = {"buildings_snowbrick.png"},
	is_ground_content = false,
	groups = {cracky = 3, cools_lava = 1}
})

stairs.register_stair_and_slab(
	"snowbrick",
	"buildings:snowbrick",
	{cracky = 3, cools_lava = 1},
	{"buildings_snowbrick.png"},
	"Packed Snow Brick Stair",
	"Packed Snow Brick Slab",
	default.node_sound_snow_defaults(),
	true
)

minetest.register_craft({
	output = "buildings:snowbrick",
	recipe = {
		{"default:snowblock", "default:snowblock"},
		{"default:snowblock", "default:snowblock"},
	}
})

minetest.register_node("buildings:igloo_seed", {
	description = "Placeholder for checking coditions for igloo spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:snowblock"},
	decoration = "buildings:igloo_seed",
	sidelen = 16,
	fill_ratio = 0.0002,
	y_max = 18,
	y_min = 0,
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	biomes = {"icesheet"},
})

minetest.register_lbm({
	label = "Igloo Spawn",
	name = "buildings:spawn_igloo",
	nodenames = {"buildings:igloo_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)
		pos.y = pos.y - 1
		if buildings.check_foundation(pos, 12, 12, "cools_lava") < 4 then
			return
		end
		minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
		local storage_search_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		buildings.find_and_place_loot("default:chest", igloo_loot, storage_search_pos, 12, 12)
		buildings.find_and_place_loot("default:furnace", nil, storage_search_pos, 12, 12)
	end,
})

