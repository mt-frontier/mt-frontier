pot = {}

pot.update_infotext = function(pos)
    local meta = minetest.get_meta(pos)
    -- No formspec needed for innactive forge
    if minetest.get_node(pos).name == "frontier_craft:forge" then
        meta:set_string("formspec", "")
        return
    end
end

pot.update_formspec = function(pos, playername)

    local meta = minetest.get_meta(pos)
    -- pot formspec only when pot is over fueled heat source
    local below = {x=pos.x, y=pos.y-1, z=pos.z}
    local meta_below = minetest.get_meta(below)
    if meta_below:get_int("burntime") < 1 then
        meta:set_string("formspec", "")
        return
    end

    local width, height = 6, 3
    local input_list = "list[detached:frontier_craft;inputs;0,1;2,4;]"
    local page_num = frontier_craft.select_page("forge", meta:get_int("pot:page_num"), width, height)
    local selected = meta:get_string("pot:selected_craft")

    if selected == "" then
        frontier_craft.clear_input_inv_preview(playername)
    else
        frontier_craft.set_input_inv_preview("forge", selected, minetest.get_player_by_name(playername))
    end

    local formspec = [[
        size[10,9]
        container[0,0]
        label[0,0.5;Required Materials]
    ]]
        .. input_list

    ..[[  
        container_end[]
        container[2,0]
    ]]
    .. frontier_craft.get_craft_selector(minetest.get_player_by_name(playername), "pot", 0, 0, width, height, page_num, selected)..
    [[
        container_end[]
        container[8,0]
        button[0,0;2,1;cook;Cook]
        container_end[]
        list[current_player;main;0,5;8,4]
    ]]

    meta:set_string("formspec", formspec)
end

-- 
pot.place = function(pos, placer, itemstack)
    minetest.swap_node(pos, {name=itemstack:get_name()})
    pot.update_formspec(pos, placer:get_player_name())
    return itemstack:take_item()
end

minetest.register_node("frontier_craft:pot", {
    description = "Cooking Pot",
    drawtype = "nodebox",
    tiles = {
        "frontier_craft_pot_top.png",
        "frontier_craft_pot_bottom.png",
        "frontier_craft_pot_side.png",
        "frontier_craft_pot_side.png",
        "frontier_craft_pot_front.png",
        "frontier_craft_pot_front.png",
    },
    node_box = {
        type = "fixed",
        fixed = {
            {-0.125, 0.125, -0.0625, 0.125, 0, 0.0625},
            {-0.375, -0.475, -0.375, 0.375, 0, 0.375}
        }
    },
    paramtype = "light",
    groups = {cracky=3, oddly_breakable_by_hand=3, cooking_pot=1},
    on_construct = function(pos)
        local inv = minetest.get_meta(pos):get_inventory()
        inv:set_size("output", 1)
    end,

    after_place_node = function(pos, placer, itemstack, pointed_thing)
        minetest.get_meta(pos):set_string("owner", placer:get_player_name())
        pot.update_formspec(pos, placer:get_player_name())
    end,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if clicker:get_player_name() ~= minetest.get_meta(pos):get_string("owner") then
            return itemstack
        end

        pot.update_formspec(pos, clicker:get_player_name())

        local output_stack = minetest:get_meta(pos):get_inventory():get_stack("output", 1)
        if not output_stack or output_stack:get_count() == 0 then
            return itemstack
        end
        if minetest.get_item_group(itemstack:get_name(), "food_bowl") > 1 then
            local count = math.min(itemstack:get_count(), output_stack:get_count())
            itemstack:take_item(count)
            minetest.item_drop(output_stack:take_item(count), clicker, pos)
        end
        return itemstack
    end,
})