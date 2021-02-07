local schem_file = minetest.register_schematic("schems/puebloan.mts")
local puebloan_loot = {
	--item name, max # in stack, rarity
	{"mtcoin:copper", 9, 8},
	{"bows:bow_wood", 1, 10},
	{"bows:arrow_steel", 9, 8},
	{"bows:arrow", 48, 5},
	{"bows:arrow_poison", 9, 10},
	{"default:pick_bronze", 1, 8},
	{"default:axe_stone", 1, 9},
	{"frontier_trees:apple", 9, 7},
	{"farming:seed_cotton", 9, 8},
	{"crops:corn", 9, 8},
	{"crops:potato_eyes", 9, 8},
	{"crops:pumpkin_seed", 9, 8},
	{"crops:melon_seed", 9, 8},
	{"default:blueberries", 9, 4},
}

puebloan_loot = buildings.sort_loot(puebloan_loot)

minetest.register_node("buildings:puebloan_seed", {
	description = "Placeholder for checking coditions for Cabin spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"group:sand"},
	decoration = "buildings:puebloan_seed",
	sidelen = 16,
	fill_ratio = 0.0003,
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	y_min = 10,
	biomes = {"sandstone_desert", "desert"},
})

minetest.register_lbm({
	label = "Puebloan Spawn",
	name = "buildings:spawn_puebloan",
	nodenames = {"buildings:puebloan_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)	
		local get_node = minetest.get_node
		local get_group = minetest.get_item_group
		pos.y = pos.y - 1
		if buildings.check_foundation(pos, 5, 5, {"cracky", "crumbly"}) < 4 then
            return
        end
        local dir = 90 * math.random(0,3)
        pos.y = pos.y + 1
        minetest.place_schematic(pos, schem_file, dir, nil, true, {"place_center_x", "place_center_z", "place_center_y"})
        
        local chest_search_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        buildings.find_and_place_loot("default:chest", puebloan_loot, chest_search_pos, 5, 5)

        pos.y = pos.y + 5
        chest_search_pos.y = chest_search_pos.y + 5
        if buildings.check_foundation(pos, 5, 5, {"cracky", "crumbly"}) < 1 then
            return
        end
        minetest.place_schematic(pos, schem_file, dir, nil, true, {"place_center_x", "place_center_z", "place_center_y"})
        --chests = minetest.find_nodes_in_area(pos1, pos2, "default:chest")
        buildings.find_and_place_loot("default:chest", puebloan_loot, chest_search_pos, 5, 5)
	end,
})
