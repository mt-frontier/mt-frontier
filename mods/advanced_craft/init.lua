adv_craft = {}
local mp = minetest.get_modpath("adv_craft")

dofile(mp .. "/materials.lua")
dofile(mp .. "/mill.lua")
dofile(mp .. "/lighting.lua")
dofile(mp .. "/anvil.lua")

function adv_craft.player_has_item(player, itemstring)
	local stack = ItemStack(itemstring)
	local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	if not inv:contains_item("main", stack) then
		return false
	end
	return true
end
