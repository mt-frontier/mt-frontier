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
	{"frontier_guns:shotgun", 1, 72},
	{"frontier_guns:bullet", 2, 40},
	{"frontier_guns:revolver", 1, 99},
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
	description = "Placeholder for checking coditions for Cabin spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:snowblock"},
	decoration = "buildings:igloo_seed",
	sidelen = 16,
	fill_ratio = 0.0001,
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
		local get_node = minetest.get_node
		local get_group = minetest.get_item_group
		local corners = {}
		corners[1]= {x = pos.x, y = pos.y, z = pos.z}
		corners[2] = {x = pos.x + 12, y = pos.y, z = pos.z + 12}
		corners[3] = {x = pos.x, y = pos.y, z = pos.z + 12}
		corners[4] = {x = pos.x + 12, y = pos.y, z = pos.z}
		local function check_corners(pos)
			for _, corner_pos in ipairs(corners) do
				if get_group(get_node(corner_pos).name, "cools_lava") == 0 
				and get_group(get_node(corner_pos).name, "soil") == 0 then
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
				buildings.place_loot(chests[1], igloo_loot)	
			end
			local furnace = minetest.find_nodes_in_area(pos1, pos2, "default:furnace")
			if furnace[1] ~= nil then
				buildings.place_furnace_loot(furnace[1])
			end
		end
	end,
})

