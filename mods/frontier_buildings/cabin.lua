local schem_file = minetest.register_schematic("schems/cabin.mts")
local cabin_loot = {
	--item name, max # in stack, rarity
	{"default:gold_ingot", 3, 8},
	{"default:torch", 9, 5},
	{"bows:bow_wood", 1, 10},
	{"bows:arrow", 36, 9},
	{"default:pick_steel", 1, 10},
	{"default:dagger_stone", 1, 9},
	{"frontier_trees:apple", 9, 7},
	{"farming:bread", 1, 8},
	{"farming:seed_wheat", 9, 6},
	{"farming:seed_cotton", 9, 8},
	{"crops:green_bean_seed", 9, 8},
	{"crops:tomato_seed", 9, 8},
	{"crops:corn", 9, 8},
	{"crops:potato_eyes", 9, 8},
	{"crops:pumpkin_seed", 9, 8},
	{"crops:melon_seed", 9, 8},
	{"frontier_guns:shotgun", 1, 14},
	{"frontier_guns:shotgun_shell", 6, 11},
}

cabin_loot = buildings.sort_loot(cabin_loot)

minetest.register_node("buildings:cabin_seed", {
	description = "Placeholder for checking conditions for Cabin spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_coniferous_litter"},
	decoration = "buildings:cabin_seed",
	sidelen = 16,
	fill_ratio = 0.00006,
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	biomes = {"coniferous_forest", "pine_savanna"},
})

minetest.register_lbm({
	label = "Cabin Spawn",
	name = "buildings:spawn_cabin",
	nodenames = {"buildings:cabin_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)	
		pos.y = pos.y - 1
		if buildings.check_foundation(pos, 12, 12, "soil") < 4 then
			return
		end
		minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
		local storage_search_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		buildings.find_and_place_loot("default:chest", cabin_loot, storage_search_pos, 12, 12)
		buildings.find_and_place_loot("default:furnace", nil, storage_search_pos, 12, 12)
	end,
})

minetest.register_craftitem("buildings:cabin_plan", {
	inventory_image = "buildings_cabin_plan.png",
	on_place = function(itemstack, placer, pointed_thing)
		print(pointed_thing.type)
	end,
})