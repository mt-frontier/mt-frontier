local schem_file = minetest.register_schematic("schems/cabin.mts")
local loot_max_items = 6
local cabin_loot = {
	--item name, max # in stack, rarity
	{"mtcoin:gold", 9, 8},
	{"bows:bow_wood", 1, 10},
	{"default:pick_steel", 1, 10},
	{"default:pick_bronze", 1, 8},
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
	{"craftguide:book", 1, 10}
}

local function sort_loot(loot_table)
	local new_table = {}
	for _, loot in ipairs(loot_table) do
		if #new_table == 0 then
			table.insert(new_table, loot)
		else
			local chance = loot[3]
			for i, sorted in ipairs(new_table) do
				sorted_chance = sorted[3]
				if chance <= sorted_chance then
					table.insert(new_table, i, loot)
					break
				end
			end
		end
	end
	return new_table
end

local function select_loot(max_items)
	local possible_loot = sort_loot(cabin_loot) 
	local selected_loot = {}
	for _, loot_item in ipairs(possible_loot) do
		local chance = 1/possible_loot[3]
		if math.random() < chance then
			loot = loot_item[1] .. " " .. math.random(1, possible_loot[2])
			table.insert(selected_loot, loot)
		end

	end
	return selected_loot
end

local function place_loot(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("main", 8*4)
	local max_n = math.random(1, loot_max_items)
	local loot_list = select_loot(max_n)
	for _, loot in ipairs(loot_list) do
		local inserted = false
		while inserted == false do
			local i = math.random(1, inv:get_size("main"))
			local stack = inv:get_stack("main", i)
			if stack:is_empty() then
				local loot = select_loot()
				stack:add_item(loot)
				inv:set_stack("main", i, stack)
				inserted = true
			end
		end
	end
end

local function place_furnace_loot(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("fuel", 1)
	inv:set_size("src", 1)
	inv:set_size("dst", 4)
	local fuel_loot = "default:coal_lump "..math.random(1,99)
	inv:set_stack("fuel", 1, fuel_loot)
	meta:set_string("formspec", default.get_furnace_inactive_formspec())
end

minetest.register_node("buildings:cabin_seed", {
	description = "Placeholder for checking coditions for Cabin spawning",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	decoration = "buildings:cabin_seed",
	sidelen = 16,
	fill_ratio = 0.00007,
	--[[noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 400, y = 400, z = 400},
		seed = 90459126,
		octaves = 2,
		persist = 0.6
	},]]--
	biomes = {"grasslands", "deciduous_forest", "coniferous_forest"},
})

minetest.register_lbm({
	label = "Cabin Spawn",
	name = "buildings:spawn_cabin",
	nodenames = {"buildings:cabin_seed"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.remove_node(pos)	
		local get_node = minetest.get_node
		local get_group = minetest.get_item_group
		local corners = {}
		pos.y = pos.y - 1
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
			
			local pos2 = corners[2]
			pos2.y = pos2.y + 2
			local chests = minetest.find_nodes_in_area(pos1, pos2, "default:chest")
			if chests[1] ~= nil then
				place_loot(chests[1])	
			end
			local furnace = minetest.find_nodes_in_area(pos1, pos2, "default:furnace")
			if furnace[1] ~= nil then
				place_furnace_loot(furnace[1])
			end
		end
	end,
})

