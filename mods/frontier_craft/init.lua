-- Manual crafting library
frontier_craft = {}
frontier_craft.skills = {}
frontier_craft.craft_stations = {}
frontier_craft.registered_crafts = {}

local mp = minetest.get_modpath("frontier_craft")


function frontier_craft.register_craft_station(station_name, num_inputs)
end

function frontier_craft.register_craft(station, output, inputs, craft_time, energy_src)
	assert(energy_src == "fuel" or energy_src == "manual")


end

function frontier_craft.player_has_item(player, itemstring)
	local stack = ItemStack(itemstring)
	local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	if not inv:contains_item("main", stack) then
		return false
	end
	return true
end

dofile(mp .. "/skill.lua")
dofile(mp .. "/mortar.lua")
--dofile(mp .. "/materials.lua")
dofile(mp .. "/mill.lua")
dofile(mp .. "/lighting.lua")
dofile(mp .. "/anvil.lua")


