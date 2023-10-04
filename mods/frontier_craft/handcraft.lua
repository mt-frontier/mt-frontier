local input_inv_name = "frontier_craft:hand"

local function set_craft_input_preview(item_key, player)
    if frontier_craft.registered_crafts["hand"][item_key] == nil then
        return false
    end
    local inputs = frontier_craft.registered_crafts["hand"][item_key]["inputs"]
    local required_item = frontier_craft.registered_crafts["hand"][item_key]["required_item"]
    local inv = minetest.get_inventory({type="detached", name=input_inv_name, player_name=player:get_player_name()})
    for i = 1, inv:get_size("inputs") do
        if i <= #inputs then
            inv:set_stack("inputs", i, inputs[i])
        else
            inv:set_stack("inputs", i, "")
        end
    end
    if required_item ~= nil then
        inv:set_stack("required_item", 1, required_item)
    else
        inv:set_stack("required_item", 1, "")
    end
    return true
end
-- Hand crafting in sfinv
sfinv.override_page("sfinv:crafting", {
	title = "Crafting",
	get = function(self, player, context)
        if context.page_num == nil then
            context.page_num = 1
        end

        local formspec = [[
            container[2,0]
        ]]
        ..frontier_craft.get_craft_selector(player, "hand", 0, 0, 6, 3)..
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
            container[0,0]
            label[0,0.5;Required Materials]
            list[detached:frontier_craft:hand;inputs;0,1;2,2;] 
            label[0,3;Required Item]
            list[detached:frontier_craft:hand;required_item;0,3.5;1,1;]
            container_end[]
            listring[current_player;main]
        ]]

		return sfinv.make_formspec(player, context, formspec, true, "size[10,8.6]")
	end,
    on_player_receive_fields = function(self, player, context, fields)
        if context ~= nil then
            if context.page == "sfinv:crafting" then
                -- Handle paging in craft selector
                if fields.next then
                    print("next")
                    context.page_num = context.page_num + 1
                    sfinv.set_page(player, context.page)
                elseif fields.prev then
                    context.page_num = context.page_num - 1
                    sfinv.set_page(player, context.page)
                end
                
                -- Handle crafting
                if context.selected_craft ~= nil then
                    if fields.craft_max or fields.craft_ten then
                        local stack = ItemStack(context.selected_craft)
                        local qty = stack:get_stack_max()
                        local times = math.floor(qty/stack:get_count())
                        if fields.craft_ten then
                            if times > 10 then
                                times = 10
                            end
                        end

                        frontier_craft.perform_craft(player, "hand", context.selected_craft, times)
                        return
                    elseif fields.craft_one then
                        frontier_craft.perform_craft(player, "hand", context.selected_craft, 1)
                        return
                    end
                end
                -- handle craft selector buttons
                for key, _ in pairs(fields) do
                    -- Populate preview inventories
                    if set_craft_input_preview(key, player) == true then
                        context.selected_craft = key
                        sfinv.set_page(player, context.page)
                        return
                    end
                end
            end
        end
    end
})
