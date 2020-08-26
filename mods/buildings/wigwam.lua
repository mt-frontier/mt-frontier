local schem_file = minetest.register_schematic("schems/wigwam.mts")
local wigwam_loot = {
	--item name, max # in stack, rarity
	{"mtcoin:copper", 9, 8},
	{"bows:bow_wood", 1, 10},
	{"bows:arrow_steel", 9, 8},
	{"bows:arrow", 48, 5},
	{"bows:arrow_poison", 9, 10},
	{"default:pick_stone", 1, 8},
	{"default:axe_stone", 1, 9},
	{"frontier_trees:apple", 9, 7},
	{"farming:seed_cotton", 9, 8},
	{"crops:corn", 9, 8},
	{"crops:potato_eyes", 9, 8},
	{"crops:pumpkin_seed", 9, 8},
	{"crops:melon_seed", 9, 8},
	{"default:blueberries", 9, 4},
}

wigwam_loot = buildings.sort_loot(wigwam_loot)

minetest.register_node("buildings:wigwam_seed", {
	description = "Placeholder for checking coditions for Cabin spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_dry_grass"},
	decoration = "buildings:wigwam_seed",
	sidelen = 16,
	fill_ratio = 0.0001,
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	biomes = {"grassland", "savanna"},
})

minetest.register_lbm({
	label = "Wigwam Spawn",
	name = "buildings:spawn_wigwam",
	nodenames = {"buildings:wigwam_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)	
		local get_node = minetest.get_node
		local get_group = minetest.get_item_group
		pos.y = pos.y - 1
		local corners = {}
		corners[1]= {x = pos.x, y = pos.y, z = pos.z}
		corners[2] = {x = pos.x + 8, y = pos.y, z = pos.z + 8}
		corners[3] = {x = pos.x, y = pos.y, z = pos.z + 8}
		corners[4] = {x = pos.x + 8, y = pos.y, z = pos.z}
		local function check_corners(pos)
			for _, corner_pos in ipairs(corners) do
				if get_group(get_node(corner_pos).name, "soil") == 0 then
					return false
				end
			end
			return true
		end
		if check_corners(pos) == true then
			pos.y = pos.y + 1
			minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
			local pos1 = corners[1]
			
			local pos2 = corners[2]
			pos2.y = pos2.y + 2
			local chests = minetest.find_nodes_in_area(pos1, pos2, "default:chest")
			if chests[1] ~= nil then
				buildings.place_loot(chests[1], wigwam_loot)	
			end
		end
	end,
})

