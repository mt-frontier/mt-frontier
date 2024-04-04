
local mp = minetest.get_modpath("frontier_craft")

-- Manual crafting library
frontier_craft = {}

frontier_craft.settings = {
    item_entity_offset = 0.125
}

frontier_craft.registered_crafts = {}
frontier_craft.craft_index = {}
frontier_craft.craft_groups = {}

frontier_craft.craft_types = {
	hand = {max_inputs = 4},
    fire = {max_inputs = 1},
    pot = {max_inputs = 4},
	forge = {max_inputs = 4},
	table = {max_inputs = 4},
	mortar = {max_inputs = 1},
	mill = {max_inputs = 4},
    barrel = {max_inputs = 4}
}

for craft_type, _ in pairs(frontier_craft.craft_types) do
	frontier_craft.registered_crafts[craft_type] = {}
    frontier_craft.craft_index[craft_type] = {}
end

-- create crafting system inventories

minetest.register_on_joinplayer(function(player, last_login)
    -- Input preview inventories
    local input_inv = minetest.create_detached_inventory("frontier_craft:inputs",
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
        player:get_player_name()
    )

    for craft_type, craft_properties in pairs(frontier_craft.craft_types) do
        input_inv:set_size(craft_type, craft_properties.max_inputs)
        input_inv:set_size(craft_type .. ":required_item", 1)
    end

    -- Output inventories are particular to player
	local player_inv = minetest.get_inventory({type="player", name=player:get_player_name()})
	if not player_inv:get_list("frontier_craft:output") then
		player_inv:set_size('frontier_craft:output', 4)
		player_inv:set_size('frontier_craft:replacements', 2)
	end
end)

dofile(mp.."/functions.lua")
dofile(mp.."/craft_groups.lua")
dofile(mp.."/item_entity.lua")

-- Station GUIs
dofile(mp .. "/handcraft.lua")
dofile(mp .. "/fire.lua")
dofile(mp .. "/pot.lua")
dofile(mp .. "/mortar.lua")
dofile(mp .. "/mill.lua")
dofile(mp .. "/lighting.lua")
dofile(mp .. "/anvil.lua")
dofile(mp .. "/forge.lua")
dofile(mp .. "/barrel.lua")


dofile(mp .. "/crafts.lua")