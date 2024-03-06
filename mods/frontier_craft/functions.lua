local craft_index = frontier_craft.craft_index

local index_craft_abc = function(craft_type, craft_output)
    local pt1 = 1
    local pt2  = #craft_index[craft_type]
    -- Manually add first 2 values to simplify search loop 
    if #craft_index[craft_type] == 0 then
        craft_index[craft_type][1] = craft_output
        return
    end

    if #craft_index[craft_type] == 1 then
        if craft_output < craft_index[craft_type][1] then
            table.insert(craft_index[craft_type], 1, craft_output)
        else
            craft_index[craft_type][2] = craft_output
        end
        return
    end
    --  Check if new value is lower or higher than current values in index 
    if craft_output < craft_index[craft_type][1] then
        table.insert(craft_index[craft_type], 1, craft_output)
        return
    elseif craft_output > craft_index[craft_type][pt2] then
        craft_index[craft_type][pt2 + 1] = craft_output
        return
    end
    -- index crafts in alphabetic order on registration
    while true do
        if pt2 - pt1 == 1 or pt1 == pt2 then
            if craft_output < craft_index[craft_type][pt2] and craft_output > craft_index[craft_type][pt1] then
                table.insert(craft_index[craft_type], pt2, craft_output)
                return
            elseif craft_output < craft_index[craft_type][pt1] then
                table.insert(craft_index[craft_type], pt1, craft_output)
            end
        end
        local mid_point = math.floor(pt2-(pt2-pt1)/2)
        if craft_output < craft_index[craft_type][mid_point] then
            pt2 = mid_point
            --return
        else
            pt1 = mid_point
            --return
        end
    end
end

-- Register group:item as its own inventory items/node for GUI usage and stores lookup of items in group in '_craft_group'.
frontier_craft.register_craft_group_item = function(group_name, group_texture, item_list)
    if type(item_list) ~= "table" then
        minetest.log("[frontier_craft] Craft group item_list invalid. Must be a list of items in a table")
        return false
    end
    local item_name = ":group:"..group_name
    local item_def = {}
    item_def.groups = {not_in_creative_inventory = 1, craft_group = 1}
    item_def.description = "Group ".. group_name
    item_def._craft_group = item_list
    if type(group_texture) == "string" then
        item_def.inventory_image = group_texture
        minetest.register_craftitem(item_name, item_def)
    elseif type(group_texture) == "table" then
        item_def.groups["dig_immediate"] = 3
        item_def.drop = ""
        item_def.tiles = group_texture
        minetest.register_node(item_name, item_def)
    else
        minetest.log("warning", "[frontier_craft] No texture forund for craft group ".. group_name .. ". Group not registered")
        return false
    end
    return true
end

-- Add to list of craft groups
function frontier_craft.register_craft_group(group_name)
    local error_head = "[frontier_craft] Ignoring craft group "
    if frontier_craft.craft_groups[group_name] ~= nil then
        minetest.log("warning", error_head .. group_name .. ". group already exists")
        return false
    end
    -- Register craft items for groups to display in craft guide and item lookup only.
    frontier_craft.craft_groups[group_name] = {}
    minetest.log("action", "[frontier_craft] Registered craft group: " .. group_name)
    return true
end

function frontier_craft.register_craft(craft_type, output, craft_definition)
    local error_head = "[frontier_craft] Warning: Craft registration failed. "
    assert(type(craft_definition) == "table", "Craft definition is missing or not a table")
    local inputs = craft_definition.inputs
    local replacements = craft_definition.replacements
    local required_item = craft_definition.required_item
    craft_type = craft_type or "hand"

    if frontier_craft.craft_types[craft_type] == nil then
		craft_type = "hand"
    end

    if (type(output) ~= "string") then
        return minetest.log("error", error_head .. "Invalid output type.")
    end

	if type(inputs) == "table" then
		if #inputs > frontier_craft.craft_types[craft_type].max_inputs then
            return minetest.log(error_head .. "Craft for " .. output .. " contains more than the maximum input items for craft type")
        end
	end

	if replacements ~= nil then
        if type(replacements) == "table" then
            if #replacements > #inputs then
                return minetest.log(error_head .. "Craft for " .. output .. " contains more than number of inputs")
            end
        end
    end

    if type(inputs) == "string" then
        inputs = {inputs}
    end

    if type(inputs) ~= "table" then
        return minetest.log(error_head .. "Craft for " .. output .. " contains invalid inputs. Must be itemstring or table list of itemstrings")
    end

    if frontier_craft.registered_crafts[craft_type][output] ~= nil then
        return minetest.log(error_head .. "Craft for " .. output .. " already exists for " .. craft_type .. "craft type.")
    end
    -- Add crafts
    frontier_craft.registered_crafts[craft_type][output] = craft_definition
    index_craft_abc(craft_type, output)
    -- Support group:item crafting
    local craft_items = table.copy(inputs)
    if required_item ~= nil then
        table.insert(craft_items, required_item)
    end
    for i, input in ipairs(craft_items) do
        if string.match(input, "group:") then
            local group_name = ItemStack(input):get_name():gsub("group:", "")
            frontier_craft.register_craft_group(group_name)
        end
    end
end

-- Check for items in player main inventory
local function seek_player_stack(inv, stack)
    -- Returns first matching stack from inv that contains stack
    if inv:contains_item("main", stack) then
        for i, inv_stack in ipairs(inv:get_list("main")) do
            if inv_stack:get_name() == stack:get_name() then
                if inv_stack:get_count() >= stack:get_count() then
                    return inv_stack
                end
            end
        end
        return false
    else
        return false
    end
end
-- Check if there is <count> number of any of list <group_items> in players inventory 
-- Returns stack from players inventory or false.
local seek_player_item_group = function(inv, group_items, count)
    for i = 1, inv:get_size("main") do
        local stack = inv:get_stack("main", i)
        for _, craft_item in ipairs(group_items) do
            if stack:get_name() == craft_item and stack:get_count() >= count then
                return stack
            end
        end
    end
    return false
end

frontier_craft.player_has_item_or_group = function(player, itemstring)
    local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
    local itemstack = ItemStack(itemstring)
    local group_items = itemstack:get_definition()._craft_group
        -- Handle group:item crafting 
    if group_items ~= nil then
        local count = itemstack:get_count() -- maintain quantity of original itemstring
        return seek_player_item_group(inv, group_items, count)
    else -- regular item
	   return seek_player_stack(inv, itemstack)
    end
end

-- Checks all conditions to see if a craft is possible. Returns false or possible to craft
frontier_craft.can_craft = function(player, craft_type, output, times)
    local player_inv = minetest.get_inventory({type="player", name=player:get_player_name()})
    local output_stack = ItemStack(output)

-- Craft look up 
    if craft_type == nil then
        craft_type = "hand"
    end
    if frontier_craft.registered_crafts[craft_type] == nil then
        return false
    end
    if frontier_craft.registered_crafts[craft_type][output] == nil then
        return false
    end
    -- Always true if player has creative priv 
    local privs = minetest.get_player_privs(player:get_player_name())
    if privs.creative then
        return times
    end

    -- Calculate number of time player can perform craft
    local inputs = frontier_craft.registered_crafts[craft_type][output]["inputs"]
    local replacements = frontier_craft.registered_crafts[craft_type][output]["replacements"]
    local required_item = frontier_craft.registered_crafts[craft_type][output]["required_item"]

    if required_item ~= nil then
        local player_item = frontier_craft.player_has_item_or_group(player, required_item)
        if player_item == false or player_item == nil then
            return false
        end
    end
    -- Check first available matching stack and adjust times craft may be performed based on inventory.
    local player_inputs = {}
    for i, item in ipairs(inputs) do
        local item_stack = ItemStack(item)
        local qty = item_stack:get_count()
        local inv_stack = frontier_craft.player_has_item_or_group(player, item)
        if inv_stack == false or inv_stack == nil then
            minetest.log("action", "Player " .. player:get_player_name() .. " failed to craft " .. output .. ". Missing required amount of " .. item .. ".")
            return false
        elseif inv_stack:get_count() < item_stack:get_count() * times then
            times = math.floor(inv_stack:get_count() / item_stack:get_count())
            if times == 0 then
                minetest.log("action", "Player " .. player:get_player_name() .. " failed to craft " .. output .. ". Missing required amount of " .. item .. ".")
                return false
            end
        end
        inv_stack:set_count(qty)
        table.insert(player_inputs, inv_stack)
    end
    -- Check for room
    output_stack:set_count(output_stack:get_count()*times)

    if not player_inv:room_for_item("frontier_craft:output", output_stack) then
        return false
    end
    return times, player_inputs
end
-- Adds wear to tools as if they were used when required for crafts
frontier_craft.wear_player_tool = function(inv, tool_name, times)
    times = times or 1
    for i, player_tool in ipairs(inv:get_list("main")) do
        if player_tool:get_name() == tool_name then
            local uses = player_tool:get_tool_capabilities().uses
            if uses ~= nil then
                player_tool:add_wear( 65535/(uses-times))
            else
                player_tool:add_wear(1000*times)
            end
            inv:set_stack("main", i, player_tool)
            minetest.sound_play({name = "default_wood_footstep", gain = 1.0})
            return
        end
    end
end
-- Craft handler
frontier_craft.perform_craft = function(player, craft_type, output, times)
    minetest.log("info", "[frontier_craft] Player " .. player:get_player_name() .. " attempting craft: " .. output)
    local player_inv = minetest.get_inventory({type="player", name=player:get_player_name()})
    local privs = minetest.get_player_privs(player:get_player_name())
    times = times or 1
    local player_inputs = {}
    times, player_inputs = frontier_craft.can_craft(player, craft_type, output, times)

    if not privs.creative == true then
        if times == false or times == 0 then
            return false
        end
        for _, input in ipairs(player_inputs) do
            local input_stack = ItemStack(input)
            input_stack:set_count(input_stack:get_count() * times)
            player_inv:remove_item("main", input_stack)
        end
           -- Stamina support
        if stamina ~= nil then
            stamina.exhaust_player(player, ItemStack(output):get_count()*times*2, "crafting")
        end
        -- Tool wear for required_items
        local required_item = frontier_craft.registered_crafts[craft_type][output].required_item
        if required_item ~= nil then
            required_item = frontier_craft.player_has_item_or_group(player, required_item):get_name()
            if minetest.registered_tools[required_item] ~= nil then
                --local player_tool = frontier_craft.player_has_item_or_group(player, required_item)
                frontier_craft.wear_player_tool(player_inv, required_item, times*ItemStack(output):get_count())
            end
        end
    end

    local output_stack = ItemStack(output)
    output_stack:set_count(output_stack:get_count() * times
)
    -- place craft output
    local craft_time = 0
    minetest.after(craft_time, function()
        player_inv:add_item("frontier_craft:output", output_stack)
        minetest.sound_play({name="default_place_node", gain=1.0})
    -- Handle craft replacement items
        local replacements = frontier_craft.registered_crafts[craft_type][output].replacements
        if type(replacements) == "table" then
            for _, replacement in ipairs(replacements) do
                local item_stack = ItemStack(replacement)
                item_stack:set_count(item_stack:get_count()*times)
                if player_inv:room_for_item("frontier_craft:replacements", item_stack) then
                    player_inv:add_item("frontier_craft:replacements", item_stack)
                end
            end
        end
        minetest.log("action", "[frontier_craft] " .. player:get_player_name() .. " crafted " .. output .. " by " .. craft_type)
    end)
    return true
end

-- Build craft selector for crafting formspecs

-- Handle page selection and auto wrapping to beginning or end
frontier_craft.select_page = function(craft_type, page_num, width, height)
    local num_pages = math.ceil(#craft_index[craft_type]/(width*height))
    if page_num == nil then
        page_num = 1
    elseif page_num > num_pages then
        page_num = 1
    elseif page_num < 1 then
        page_num = num_pages
    end
    return page_num
end

-- Generate page of available crafts
frontier_craft.craft_page = function(craft_type, invx, invy, width, height, page_num, selected)
    local formspec = ""
    local num_pages = math.ceil(#craft_index[craft_type]/(width*height))
    
    if num_pages > 1 then
        formspec = "button[" .. math.floor(width/2)-2 .. "," .. height+0.5 .. ";1,0.75;prev;<]" ..
        "label[".. math.floor(width/2)-0.3 .."," .. height+0.5 .. ";"..page_num.." / "..num_pages.."]" ..
        "button[".. width/2+1 .."," .. height+0.5 .. ";1,0.75;next;>]"
    end
    
    
    local n = 1
    local column = 1
    local num_per_page = width*height
    for i = num_per_page*(page_num-1)+1, num_per_page*page_num do
        local craft_output = frontier_craft.craft_index[craft_type][i]
        if craft_output == nil then
            -- End of craft registrations
            break
        end
        -- wrap back to column 1
        if column > width then
            column = 1
        end
        local x = invx + (column-1)
        local y = invy + math.floor((n-1)/width) + 0.5
        local item_name = craft_output
        -- Make selector box
        -- if selected ~= nil then
        --     if item_name == selected then
        --         formspec = formspec .. "box["..(x-0.05)..","..(y-0.05)..";0.9,0.95;#ccca]"
        --     end
        -- end
        formspec = formspec .. "item_image_button["..(x+0.01)..","..(y+0.01)..";1,1;"..item_name..";"..item_name..";]"
        if selected ~= nil then
            if item_name == selected then
            --    formspec = formspec .. "box["..(x-0.05)..","..(y-0.05)..";0.9,0.95;#ccca]"
                formspec = formspec .. "image["..(x-0.09)..","..(y-0.09)..";1.2,1.2;gui_hotbar_selected.png]"
        end
        end
        column = column + 1
        n = n + 1
    end
    return formspec
end

-- Build selectable craft page
frontier_craft.get_craft_selector = function(player, craft_type, invx, invy, width, height, page_num, selected)
    local formspec = "label[" .. invx-2 .. ",0;Crafting (".. craft_type .."):]"
    local description = ""
    if selected ~= nil then
        local selected_stack = ItemStack(selected)
        description = "Selected: " .. selected_stack:get_description() .. " x " .. selected_stack:get_count()
        formspec = formspec .."label[" .. invx+0.2 .. ",0;" .. description .. "]"
    end

    formspec = formspec .. frontier_craft.craft_page(craft_type, invx, invy, width, height, page_num, selected)
    return formspec
end

-- Clear input inventory 
frontier_craft.clear_input_inv_preview = function(playername)
    if playername == nil then
        return
    end
    local inv = minetest.get_inventory({type="detached", name="frontier_craft"})
    if not inv then
        return
    end
    local context = sfinv.get_or_create_context(minetest.get_player_by_name(playername))
    -- Reset input inv to selected handcraft 
    if context.selected_craft ~= nil and context.selected_craft ~= "" then
        if frontier_craft.set_input_inv_preview("hand", context.selected_craft, minetest.get_player_by_name(playername)) then
            return true
        end
    end
    -- Clear input inventory
    if inv:get_size("inputs") > 0 then
        for i = 1, inv:get_size("inputs") do
            inv:set_stack("inputs", i, "")
        end
        inv:set_stack("required_item", 1, "")
        return true
    end
end

-- Reset/Populate input inventory
frontier_craft.set_input_inv_preview = function(craft_type, item_name, player)
    if frontier_craft.registered_crafts[craft_type][item_name] == nil then
        return false
    end
    local inputs = frontier_craft.registered_crafts[craft_type][item_name]["inputs"]
    local required_item = frontier_craft.registered_crafts[craft_type][item_name]["required_item"]
    
    if craft_type == "hand" then
        local inv = minetest.get_inventory({type="detached", name="frontier_craft"})
        local size = frontier_craft.craft_types[craft_type].max_inputs
        if inv:get_size("inputs") ~= size then
            inv:set_size("inputs", size)
        end
    end
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
