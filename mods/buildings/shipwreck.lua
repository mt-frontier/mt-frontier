local schem_file = minetest.register_schematic("schems/shipwreck.mts")
local shipwreck_loot = {
	--item name, max # in stack, rarity
	{"mtcoin:gold", 18, 9},
    {"default:gold_ingot", 9, 8},
	{"frontier_guns:shotgun_shell", 6, 20},
	{"frontier_guns:shotgun", 1, 48},
	{"frontier_guns:bullet", 6, 10},
	{"frontier_guns:revolver", 1, 48},
}

shipwreck_loot = buildings.sort_loot(shipwreck_loot)

minetest.register_node("buildings:shipwreck_seed", {
	description = "Placeholder for checking coditions for shipwreck spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:sand"},
    --spawn_by = "default:water_source",
	decoration = "buildings:shipwreck_seed",
	sidelen = 16,
	fill_ratio = 0.0002,
    y_max =-24,
    y_min = -130,
    flags = "force_placement"
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
})

minetest.register_lbm({
	label = "Shipwreck Spawn",
	name = "buildings:spawn_shipwreck",
	nodenames = {"buildings:shipwreck_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)
		pos.y = pos.y - 1
		if buildings.check_foundation(pos, 24, 24, {"sand", "soil"}) < 4 
		and buildings.check_foundation(pos, 24, 24, "cracky") > 0 
		and buildings.check_foundation(pos, 12, 12, "cracky") > 0 then
			return
		end
		minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
		local storage_search_pos = {x = pos.x, y = pos.y, z = pos.z}
		buildings.find_and_place_loot("default:chest", shipwreck_loot, storage_search_pos, 24, 24)
		storage_search_pos.y = storage_search_pos.y + 4
		buildings.find_and_place_loot("ts_furniture:frontier_trees_cypress_wood_cabinet_closed", shipwreck_loot, storage_search_pos, 24, 24)
	end,
})

