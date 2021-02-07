buildings = {}
local loot_max_items = 6

function buildings.sort_loot(loot_table)
	local new_table = {}
	for _, loot in ipairs(loot_table) do
		if #new_table == 0 then
			table.insert(new_table, loot)
		else
			local chance = loot[3]
			for i, sorted in ipairs(new_table) do
				local sorted_chance = sorted[3]
				if chance <= sorted_chance then
					table.insert(new_table, i, loot)
					break
				end
			end
		end
	end
	return new_table
end

local function select_loot(num_items, loot_table)
	print("selecting loot...")
	local possible_loot = loot_table
	local selected_loot = {}
	while #selected_loot < num_items do
		for _, loot_item in ipairs(possible_loot) do
			local chance = 1/loot_item[3]
			if math.random() < chance then
				local loot = loot_item[1] .. " " .. math.random(1, loot_item[2])
				table.insert(selected_loot, loot)
			end
		end
	end
	print('done')
	return selected_loot
end

function buildings.place_loot(pos, loot_table)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("main", 8*4)
	local num_items = math.random(1, loot_max_items)
	local loot_list = select_loot(num_items, loot_table)
	for _, loot in ipairs(loot_list) do
		local inserted = false
		while inserted == false do
			local i = math.random(1, inv:get_size("main"))
			local stack = inv:get_stack("main", i)
			if stack:is_empty() then
				stack:add_item(loot)
				inv:set_stack("main", i, stack)
				inserted = true
			end
		end
	end
end

function buildings.place_furnace_loot(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("fuel", 1)
	inv:set_size("src", 1)
	inv:set_size("dst", 4)
	local fuel_loot = "default:coal_lump "..math.random(1,99)
	inv:set_stack("fuel", 1, fuel_loot)
	meta:set_string("formspec", default.get_furnace_inactive_formspec())
end

function buildings.check_corners(pos, width, depth)
	local corners = {}
	corners[1]= {x = pos.x, y = pos.y, z = pos.z}
	corners[2] = {x = pos.x + width, y = pos.y, z = pos.z + depth}
	corners[3] = {x = pos.x, y = pos.y, z = pos.z + depth}
	corners[4] = {x = pos.x + width, y = pos.y, z = pos.z}
end

dofile(minetest.get_modpath("buildings") .. "/cabin.lua")
dofile(minetest.get_modpath("buildings") .. "/cache.lua")
dofile(minetest.get_modpath("buildings") .. "/igloo.lua")
dofile(minetest.get_modpath("buildings") .. "/wigwam.lua")
dofile(minetest.get_modpath("buildings") .. "/saloon.lua")
dofile(minetest.get_modpath("buildings") .. "/puebloan.lua")


