--[[minetest.register_node("frontier_death:tombstone", {
    description = "Tombstone",
    drawtype = "nodebox",
    tiles = {"default_stone.png"},
    node_box = {
        type = "fixed",
        fixed = {
            {1/8, -1/2, -3/8, -1/8, 3/16, 3/8},
            {1/8, 3/16, -5/16, -1/8, 1/4, 5/16},
            {1/8, 1/4, -1/4, -1/8, 5/16, 1/4}
        }
    },
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
})
]]--

minetest.register_on_dieplayer(function(player, reason)
    local meta = player:get_meta()
    meta:set_string("gender", "")
    meta:set_string("class", "")
    
    local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
    for list_name, list in pairs(inv:get_lists()) do
        if list_name ~= "badges" and list_name ~= "purse" then
            print(list_name)

                for i = 1, inv:get_size(list_name) do
                        local stack = inv:get_stack(list_name, i)
                        local n = stack:get_count()
                        stack:take_item(n)
                        inv:set_stack(list_name, i, stack)
                end
        end
    end
end)