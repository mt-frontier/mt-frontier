-- Manual crafting library
frontier_craft = {}
frontier_craft.registered_crafts = {}
frontier_craft.craft_index = {}

frontier_craft.craft_types = {
	hand = {max_inputs = 3},
	table = {max_inputs = 8},
	forge = {max_inputs = 8},
	mortar = {max_inputs = 1},
	mill = {max_inputs = 8}
}

frontier_craft.craft_groups = {}

for craft_type, _ in pairs(frontier_craft.craft_types) do
    print(craft_type)
	frontier_craft.registered_crafts[craft_type] = {}
    frontier_craft.craft_index[craft_type] = {}
end

local mp = minetest.get_modpath("frontier_craft")

-- crafting inventories

minetest.register_on_joinplayer(function(player, last_login)
    local player_name = player:get_player_name()
	local player_inv = minetest.get_inventory({type="player", name=player:get_player_name()})
    local input_inv = minetest.create_detached_inventory("frontier_craft:hand",
        {
            allow_move = function()
                return 0
            end,
            allow_take = function()
                return 0
            end,
            allow_put = function()
                return 0
            end
        },
        player_name
    )
    input_inv:set_size('inputs', 4)
    input_inv:set_size('required_item', 1)
	-- Check for player craft inventories
	if not player_inv:get_list("frontier_craft:output") then
		player_inv:set_size('frontier_craft:output', 4)
		player_inv:set_size('frontier_craft:replacements', 2)
	end
end)

dofile(mp.."/functions.lua")
dofile(mp.."/craft_groups.lua")
dofile(mp.."/handcraft.lua")
dofile(mp.."/mortar.lua")
dofile(mp.."/mill.lua")
dofile(mp.."/lighting.lua")
dofile(mp.."/anvil.lua")
