local schem_file = minetest.register_schematic("schems/saloon.mts")
local saloon_loot = {
	--item name, max # in stack, rarity
	{"mtcoin:gold", 9, 8},
	{"bows:bow_wood", 1, 10},
	{"bows:arrow_steel", 9, 8},
	{"bows:arrow", 48, 5},
	{"craftguide:book", 1, 10},
	{"frontier_guns:shotgun_shell", 3, 14},
	{"frontier_guns:shotgun", 1, 72},
	{"frontier_guns:bullet", 2, 40},
	{"frontier_guns:revolver", 1, 99},
}

saloon_loot = buildings.sort_loot(saloon_loot)

minetest.register_node("buildings:saloon_seed", {
	description = "Placeholder for checking coditions for saloon spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_dry_grass"},
	decoration = "buildings:saloon_seed",
	sidelen = 16,
	fill_ratio = 0.00009,
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	--biomes = {"savanna"},
})

minetest.register_lbm({
	label = "Saloon Spawn",
	name = "buildings:spawn_saloon",
	nodenames = {"buildings:saloon_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)
		pos.y = pos.y - 1
		if buildings.check_foundation(pos, 12, 12, "soil") < 4 then
			return
		end
		minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
		local storage_search_pos = {x = pos.x, y = pos.y + 1, z = pos.z} 
		buildings.find_and_place_loot("ts_furniture:frontier_trees_mesquite_wood_cabinet_closed", saloon_loot, storage_search_pos, 12, 12)
		
		storage_search_pos.y = storage_search_pos.y + 6
		buildings.find_and_place_loot("default:chest", saloon_loot, storage_search_pos, 12, 12)
		buildings.find_and_place_loot("default:furnace", saloon_loot, storage_search_pos, 12, 12)
	end,
})

