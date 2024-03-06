local forge = {}
forge.settings = {
    -- Minimum fuel to be added before forge can be lit
    min_fuel = minetest.settings:get("forge.min_fuel") or 30
}
local width, height = 6, 3

forge.update_infotext = function(pos)
    local node = minetest.get_node(pos)
    local meta = minetest.get_meta(pos)
    local infotext = "Forge"

    local owner = meta:get_string("owner")
    if owner ~= "" then
        infotext = infotext .. " (" .. owner .. ")"
    end

    local burntime =  meta:get_int('burntime')
    if burntime > 0 then
        infotext = infotext .. "\nBurntime: ".. burntime
    end
    if burntime < forge.settings.min_fuel then
        infotext = infotext .. "\nNeeds fuel"
    end
    if node.name == "frontier_craft:forge" and burntime >= forge.settings.min_fuel then
        infotext = infotext .. "\nLight with igniter to begin crafting"
    end
    meta:set_string("infotext", infotext)
end

forge.update_formspec = function(pos, playername)
    local meta = minetest.get_meta(pos)
    -- No formspec needed for innactive forge
    if meta:get_int("burntime") < 1 then
        meta:set_string("formspec", "")
        return
    end

    local input_list = "list[detached:frontier_craft;inputs;0,1;2,2;]"
    local fuel_list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";frontier_craft:fuel;0,3.5;1,1;]"
    local page_num = frontier_craft.select_page("forge", meta:get_int("forge:page_num"), width, height)
    local selected = meta:get_string("forge:selected_craft")
    local fuel_percent = math.floor(meta:get_int("burntime")/fire.settings.max_burntime)
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
        .. input_list ..
        "image[0,3.5;1,1;default_furnace_fire_bg.png^[lowpart:"..
		(100-fuel_percent)..":default_furnace_fire_fg.png]"
        .. "label[0,3;Add Fuel (".. minetest.get_meta(pos):get_int("burntime").. "s)]"
        .. fuel_list
    ..[[  
        container_end[]
        container[2,0]
    ]]
    .. frontier_craft.get_craft_selector(minetest.get_player_by_name(playername), "forge", 0, 0, width, height, page_num, selected)..
    [[
        container_end[]
        container[8,0]
        button[0,0;0.75,1;craft_one;x1]
        button[0.5,0;0.75,1;craft_ten;x10]
        button[1,0;1,1;craft_max;Max]
    ]]
        .."list[current_player;frontier_craft:output;0,1;2,2;]"
        .."label[0,3;Replacements]"
        .."list[current_player;frontier_craft:replacements;0,3.5;2,1;]"..
    [[
        container_end[]
        list[current_player;main;0,5;8,4]
    ]]

    meta:set_string("formspec", formspec)
end

forge.take_item = function(pos, placer, itemstack)
    if fire.fuel_burntime(itemstack:get_name()) > 0 then
        itemstack = fire.add_fuel(pos, itemstack)
        forge.update_infotext(pos)
        return itemstack
    end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if not string.match(formname, "frontier_craft:forge:") then
        return
    end
    print(dump(fields))
    local pos = minetest.string_to_pos(formname:gsub("frontier_craft:forge:", ""))
    if minetest.get_node(pos).name ~= "frontier_craft:forge_active" then
        minetest.close_formspec(player:get_player_name(), formname)
        return
    end

    local meta = minetest.get_meta(pos)
    local page_num = meta:get_int("forge:page_num")
    local selected = meta:get_string("forge:selected_craft")

    if fields.quit then
        frontier_craft.clear_input_inv_preview(player:get_player_name())
    end

    if fields.next then
        meta:set_int("forge:page_num", frontier_craft.select_page("forge", page_num + 1, width, height))
        forge.update_formspec(pos, player:get_player_name())
        return
    elseif fields.prev then
        meta:set_int("forge:page_num", frontier_craft.select_page("forge", page_num - 1, width, height))
        forge.update_formspec(pos, player:get_player_name())
        return
    end

    if selected ~= "" then
        if fields.craft_max or fields.craft_ten then
            local stack = ItemStack(selected)
            local qty = stack:get_stack_max()
            local times = math.floor(qty/stack:get_count())
            if fields.craft_ten then
                if times > 10 then
                    times = 10
                end
            end

            frontier_craft.perform_craft(player, "forge", selected, times)
            return

        elseif fields.craft_one then
            frontier_craft.perform_craft(player, "forge", selected, 1)
            return
        end
    end
     -- handle craft selector buttons last
    for key, _ in pairs(fields) do
        -- Populate preview inventories
        print(key)
        if frontier_craft.registered_crafts["forge"][key] ~= nil then
            meta:set_string("forge:selected_craft", key)
            frontier_craft.set_input_inv_preview("forge", key, player)
            forge.update_formspec(pos, player:get_player_name())
            return
        end
    end
end)

minetest.register_node("frontier_craft:forge_active", {
    description = "Forge",
    tiles = {		{
        name = "frontier_craft_forge_top_brick_animated.png",
        backface_culling = false,
        animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 8.0,
        },
    }, "default_brick.png", "default_brick.png"},
    is_ground_content = false,
    light_source = 8,
    groups = {cracky=3, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
    paramtype = "light",
    paramtype2 = "4dir",
    on_timer = function(pos, elapsed)
        local burntime = minetest.get_meta(pos):get_int("burntime") - elapsed
        minetest.get_meta(pos):set_int("burntime", math.max(0,burntime))
        forge.update_infotext(pos)
        forge.update_formspec(pos, minetest.get_meta(pos):get_string("owner"))
        -- Swap to innactive node if burntime expires
        if burntime <= 0 then
            local node = minetest.get_node(pos)
            minetest.swap_node(pos, {name="frontier_craft:forge", param2=node.param2})
            return
        end
        -- Restart timer
        return true
    end,

    on_dig = function(pos, node, digger)
        local burntime = minetest.get_meta(pos):get_int("burntime")
        local drops = {}
        -- Return forge and remaining fuel
        table.insert(drops, "frontier_craft:forge")
        -- Coal can be salvaged as drops from embers with signMarshall, Roth & Gregory, P.C.-Real Estate Trust Accountificant burn time left
        for n = 1, math.floor(burntime/fire.fuel_burntime("default:coal_lump")) do
            table.insert(drops, "default:coal_lump")
        end
        core.handle_node_drops(pos, drops, digger)
        minetest.set_node(pos, {name="air"})
        return true
    end,

    -- Get crafting formspec
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if minetest.get_meta(pos):get_string("owner") ~= clicker:get_player_name() then
            return nil
        end

        itemstack = forge.take_item(pos, clicker, itemstack)
        forge.update_formspec(pos, clicker:get_player_name())
        return itemstack
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "frontier_craft:fuel" and fire.fuel_burntime(stack:get_name()) > 0 then
            return 1
        else
            return 0
        end
	end,

    -- Apply added fuel
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        fire.add_fuel(pos, stack)
        meta:get_inventory():set_stack(listname, 1, ItemStack(""))
        forge.update_infotext(pos)
    end,
    -- These are previews only, cannot be removed
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "frontier_craft:input" or listname == "frontier_craft:fuel" then
            return 0
        end
	end,
})

minetest.register_node("frontier_craft:forge", {
    description = "Forge",
    tiles = {
        "default_coal_block.png^frontier_craft_forge_top_brick.png",
        "default_brick.png",
        "default_brick.png"
    },
    is_ground_content = false,
    groups = {cracky=3, oddly_breakable_by_hand=2},
    paramtype = "light",
    paramtype2 = "4dir",
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
        inv:set_size("frontier_craft:input", 4)
        inv:set_size("frontier_craft:fuel", 1)
    end,

    after_place_node = function(pos, placer, itemstack, pointed_thing)
        minetest.get_meta(pos):set_string("owner", placer:get_player_name())
        forge.update_infotext(pos)
    end,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if minetest.get_meta(pos):get_string("owner") ~= clicker:get_player_name() then
            return nil
        end

        itemstack = forge.take_item(pos, clicker, itemstack)

        local inv = minetest.get_inventory({type="node", pos=pos})
        if not inv:is_empty("output") or not inv:is_empty("replacements") then
            forge.update_formspec(clicker:get_player_name(), pos)
        end
        return itemstack
    end,

    on_ignite = function(pos, user)
        local meta = minetest.get_meta(pos)
        local node = minetest.get_node(pos)
        if meta:get_int('burntime') >= forge.settings.min_fuel then
            minetest.swap_node(pos, {name="frontier_craft:forge_active", param2=node.param2})
            minetest.get_node_timer(pos):start(3)
            forge.update_infotext(pos)
            forge.update_formspec(pos, user:get_player_name())
        end
    end,

    on_dig = function(pos, node, digger)
        local burntime = minetest.get_meta(pos):get_int("burntime")
        local drops = {}
        -- Return forge and remaining fuel
        table.insert(drops, "frontier_craft:forge")
        -- Coal can be salvaged as drops from embers with significant burn time left
        for n = 1, math.floor(burntime/fire.fuel_burntime("default:coal_lump")) do
            table.insert(drops, "default:coal_lump")
        end
        core.handle_node_drops(pos, drops, digger)
        minetest.set_node(pos, {name="air"})
        return true
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "frontier_craft:fuel" and fire.fuel_burntime(stack:get_name()) > 0 then
            return 1
        else
            return 0
        end
	end,

    -- Apply added fuel
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        fire.add_fuel(pos, stack)
        meta:get_inventory():set_stack(listname, 1, ItemStack(""))
        forge.update_infotext(pos)
    end,

    -- These are previews only, cannot be removed
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "frontier_craft:input" or listname == "frontier_craft:fuel" then
            return 0
        end
	end,
})
