local schem_file = minetest.register_schematic("schems/chapel.mts")
local chapel_loot = {
	--item name, max # in stack, rarity
	{"mtcoin:gold", 3, 13},
	{"farming:bread", 3, 8},
	{"craftguide:book", 1, 10},
    {"default:book", 1, 9},
    {"default:paper", 9, 9},
}

chapel_loot = buildings.sort_loot(chapel_loot)

minetest.register_node("buildings:chapel_seed", {
	description = "Placeholder for checking coditions for chapel spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	decoration = "buildings:chapel_seed",
	sidelen = 16,
	fill_ratio = 0.00001,
	--[[noise_params = {
		offset = 0,coniferous_litter
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	biomes = {"deciduous_forest", "grassland"},
})

minetest.register_lbm({
	label = "Chapel Spawn",
	name = "buildings:spawn_chapel",
	nodenames = {"buildings:chapel_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)	
		pos.y = pos.y - 1
		if buildings.check_foundation(pos, 14, 14, "soil") < 4 then
			return
		end
		minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
		storage_search_pos = {x = pos.x, y = pos.y + 3, z = pos.z}
		buildings.find_and_place_loot("ts_furniture:frontier_trees_maple_wood_cabinet_closed", chapel_loot, storage_search_pos, 14, 14)
	end,
})

