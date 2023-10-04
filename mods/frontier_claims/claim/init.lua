local currency = "default:gold_ingot"

minetest.unregister_item("simple_protection:claim")

local function can_claim(player_name, pos)
    -- Separated out this check for additional security against modified clients sending fields.
    local data, index = s_protect.get_claim(pos)
    local reason = ""
    local claims, count = s_protect.get_player_claims(player_name)
    local price = 300
    if count == 0 then
        price = 0
    elseif count < 4 then
        price = 100
    elseif count < 16 then
        price = 200
    end
    if price == 0 or mtcoin.can_afford(player_name, currency .. " " .. price) then
        return price, index
    else
        reason = "You cannot afford to claim this area (" .. price .. " gold)"
    end
    return price, nil
end

local function get_deed(pos, player_name)
    local player = minetest.get_player_by_name(player_name)
    local inv = player:get_inventory()
    local data  = s_protect.get_claim(pos)
    local center = minetest.pos_to_string(s_protect.get_center(pos))
    local stack = ItemStack("claim:deed")
    local meta = stack:get_meta()
    meta:set_string("owner", data.owner)
    meta:set_string("location", center)
    inv:add_item("main", stack)
end

local function process_claim_action(itemstack, player_name, pos)
    local formspec = "size[4,3]"
    local function show_formspec()
        minetest.show_formspec(player_name,"claim_process", formspec)
    end
    if s_protect.old_is_protected(pos, player_name) then
        formspec = formspec ..
            "label[0,0.5;This area is already protected\n".. 
            "by an other protection mod.]"..
            "button_exit[1.5,2;1,1;ok;OK]"
        return show_formspec()
    end
    if s_protect.underground_limit then
        local minp, maxp = s_protect.get_area_bounds(pos)
        if minp.y < s_protect.underground_limit then
            formspec = formspec ..
                "label[0,0.5;You can not claim areas below\n  " .. s_protect.underground_limit .. " m]"..
                "button_exit[1.5,2;1,1;ok;OK]"
            return show_formspec()
        end
    end
    
    local data, index = s_protect.get_claim(pos)
    if data then
        if data.owner ~= player_name then
            formspec = formspec .. 
                "label[0,0.5;This area is owned by:]"..
                "label[0.5,1;" .. data.owner .. "]"..
                "button_exit[2,2;2,1;ok;OK]"
            return show_formspec()
        elseif data.owner == player_name then
            formspec = formspec ..
                "label[0,0.5;This area is owned by you.]"..
                "button_exit[1,1;2,1;".. minetest.pos_to_string(pos) .. ";Get deed]" ..
                "button[0,2;2,1;" .. minetest.pos_to_string(pos) .. ";Show area]" ..
                "button_exit[2,2;2,1;ok;OK]"
        end
        return show_formspec()
    end
    -- Count number of claims for this user
    local claims_max = s_protect.max_claims
    if minetest.check_player_privs(player_name, {simple_protection=true}) then
        claims_max = claims_max * 2
    end

    local claims, count = s_protect.get_player_claims(player_name)
    if count >= claims_max then
        minetest.chat_send_player(player_name,
            "You can not claim any further areas: Limit (@1) reached." .. tostring(claims_max))
        return
    end
    local price, index = can_claim(player_name, pos) 
    print(price)
    if index ~= nil then
        formspec = formspec ..
            "label[0,0.5;Purchase this claim?]" ..
            "label[0,1;Price: " .. price .. " gold]" ..
            "button_exit[0,2;2,1;" .. minetest.pos_to_string(pos) .. ";Purchase]" ..
            "button_exit[2,2;2,1;cancel;Cancel]"
        minetest.add_entity(s_protect.get_center(pos), "simple_protection:marker")
        return show_formspec()
    else reason = "You cannot afford this area"
    end
    
    --itemstack:take_item(1)
    
    formspec = formspec ..
        "label[0,0.5;".. reason .."]" ..
        "label[0,1;Price: " .. price .. " gold]" ..
        "button[0,2;2,1;" .. minetest.pos_to_string(pos) .. ";Show area]" ..
        "button_exit[2,2;2,1;ok;OK]"
    return show_formspec()
end

-- Claim itemstack

minetest.register_craftitem("claim:deed", {
    description = "Claim Deed",
    inventory_image = "default_paper.png^[colorize:#997733:100",
    stack_max = 1,
    groups = {not_in_creative_inventory=1},
    on_use = function(itemstack, user, pointed_thing)
        local player_name = user:get_player_name()
        local meta = itemstack:get_meta()
        local formspec = "size[4,3]"..
            "label[0,0.5;Deed to : " .. meta:get_string("location") .. "]" ..
            "label[0,1;Owner: " .. meta:get_string("owner") .. "]"
        minetest.show_formspec(player_name, "deed", formspec)
    end,
})

minetest.register_craftitem("claim:permit", {
	description = "Claim Permit",
	inventory_image = "default_paper.png^[colorize:#ccbb77:100",
	stack_max = 99,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local player_name = user:get_player_name()
		local pos = pointed_thing.under
		process_claim_action(itemstack, player_name, pos)
		return itemstack
	end,
})

minetest.register_craft({
    output = "claim:permit",
    recipe = {
        {"default:paper"}
    }
})

-- Form handling
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "claim_process" then
        return
    end
    local pos
    for k, v in pairs(fields) do
        if v == "Purchase" then
            pos = minetest.string_to_pos(k)
            break
        elseif v == "Get deed" then
            pos = minetest.string_to_pos(k)
            return get_deed(pos, player:get_player_name())
        elseif v == "Show area" then
            pos = minetest.string_to_pos(k)
            minetest.add_entity(s_protect.get_center(pos), "simple_protection:marker")
            return
        end
    end
    if pos == nil then
        return
    end

    local player_name = player:get_player_name()
    local price, index =  can_claim(player_name, pos)
    if price ~= nil then
        mtcoin.take_coins(player_name, currency .. " " ..price)
        s_protect.update_claims({
            [index] = {owner=player_name, shared={}}
        })
        return print("purchased")
    end
end)
