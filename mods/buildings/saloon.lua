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
	fill_ratio = 0.0001,
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
		local get_node = minetest.get_node
		local get_group = minetest.get_item_group
		pos.y = pos.y - 1
		local corners = {}
		corners[1]= {x = pos.x, y = pos.y, z = pos.z}
		corners[2] = {x = pos.x + 12, y = pos.y, z = pos.z + 12}
		corners[3] = {x = pos.x, y = pos.y, z = pos.z + 12}
		corners[4] = {x = pos.x + 12, y = pos.y, z = pos.z}
		local function check_corners(pos)
			for _, corner_pos in ipairs(corners) do
				if get_group(get_node(corner_pos).name, "soil") == 0 then
					return false
				end
			end
			return true
		end
		if check_corners(pos) == true then
			minetest.place_schematic(pos, schem_file, "random", nil, true, {"place_center_x", "place_center_z", "place_center_y"})
			local pos1 = corners[1]
			pos1.y = pos1.y + 7
			local pos2 = corners[2]
			pos2.y = pos2.y + 7
			local chests = minetest.find_nodes_in_area(pos1, pos2, "default:chest")
			if chests[1] ~= nil then
				buildings.place_loot(chests[1], saloon_loot)	
			end
            local furnace = minetest.find_nodes_in_area(pos1, pos2, "default:furnace")
			if furnace[1] ~= nil then
				buildings.place_furnace_loot(furnace[1])
			end
		end
	end,
})

