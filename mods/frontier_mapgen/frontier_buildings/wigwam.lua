local schem_file = minetest.register_schematic("schems/wigwam.mts")
local wigwam_loot = {
	--item name, max # in stack, rarity
	{"bows:bow_wood", 1, 10},
	{"bows:arrow_steel", 9, 8},
	{"bows:arrow", 48, 5},
	{"bows:arrow_poison", 9, 10},
	{"default:pick_stone", 1, 8},
	{"default:axe_stone", 1, 9},
	{"frontier_trees:apple", 9, 7},
	{"farming:seed_cotton", 9, 8},
	{"crops:corn", 9, 8},
	{"crops:pumpkin_seed", 9, 8},
	{"crops:melon_seed", 9, 8},
}

wigwam_loot = buildings.sort_loot(wigwam_loot)

minetest.register_node("buildings:wigwam_seed", {
	description = "Placeholder for checking coditions for Cabin spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dry_dirt_with_dry_grass"},
	decoration = "buildings:wigwam_seed",
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 600, y = 600, z = 600},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},
	biomes = {"grassland", "savanna"},
})

minetest.register_lbm({
	label = "Wigwam Spawn",
	name = "buildings:spawn_wigwam",
	nodenames = {"buildings:wigwam_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)
		if buildings.check_foundation(pos, 5, 5, "soil") < 4 then
			return
		end
		pos.y = pos.y + 1 -- place above ground level
		minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
		local storage_search_pos = {x = pos.x, y = pos.y, z = pos.z}
		buildings.find_and_place_loot("default:chest", wigwam_loot, storage_search_pos, 5, 5)
	end,
})

