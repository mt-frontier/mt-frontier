
-- register group:items based on all groups used by crafting
-- Use items in craft interface

minetest.register_on_mods_loaded(function()
    -- List registered items that are in crafting groups for faster look up later
    for item, def in pairs(minetest.registered_items) do
        if def.groups then
            for group_name, _ in pairs(def.groups) do
                if frontier_craft.craft_groups[group_name] ~= nil then
                    table.insert(frontier_craft.craft_groups[group_name], item)
                end
            end
        end
    end
    -- Register group item to represent group in crafting recipe preview
    for group_name, group_items in pairs(frontier_craft.craft_groups) do
        if #group_items == 0 then
            minetest.log("warning", "[Frontier Craft] No registered items in craft group, ".. group_name .. ". Group not registered")
        else
            local group_item_def = minetest.registered_items[group_items[1]]
            local group_texture = group_item_def.inventory_image
            if group_texture == "" then
                group_texture = group_item_def.tiles
            end
            if frontier_craft.register_craft_group_item(group_name, group_texture, group_items) then
                minetest.log("action", "[Frontier Craft] " .. group_name.. " craft group registered successfully: " .. dump(group_items))
            end
        end
    end
end)
