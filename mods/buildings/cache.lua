local schem_file = minetest.register_schematic("schems/cache.mts")
local cache_loot = {
	--item name, max # in stack, rarity
	{"bows:bow_wood", 1, 10},
	{"bows:arrow", 48, 6},
	{"default:furnace", 1, 5},
	{"default:coal_lump", 36, 7},
	{"default:pine_wood", 99, 8},
	{"default:pick_steel", 1, 9},
	{"default:axe_steel", 1, 7},
	{"default:pick_bronze", 1, 6},
	{"frontier_trees:apple", 9, 7},
	{"farming:bread", 1, 7},
	{"fire:flint_and_steel", 1, 6},
	{"default:torch", 18, 5},
	{"craftguide:book", 1, 10},
	{"frontier_guns:shotgun_shell", 3, 20},
	{"frontier_guns:shotgun", 1, 90},
	{"frontier_guns:bullet", 2, 40},
	{"mobs:meat", 9, 6},
}

cache_loot = buildings.sort_loot(cache_loot)

minetest.register_node("buildings:cache_seed", {
	description = "Placeholder for cache spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_snow"},
	decoration = "buildings:cache_seed",
	sidelen = 16,
	y_max = 26,
	fill_ratio = 0.00002,
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	biomes = {"taiga", "snowy_grassland"},
})

minetest.register_lbm({
	label = "Cache Spawn",
	name = "buildings:spawn_cache",
	nodenames = {"buildings:cache_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)	
		pos.y = pos.y - 1
		minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
		pos.y = pos.y + 6
		buildings.find_and_place_loot("default:chest", cache_loot, pos, 3, 3)
	end,
})