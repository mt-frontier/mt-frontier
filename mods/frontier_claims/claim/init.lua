minetest.unregister_item("simple_protection:claim")

minetest.register_craftitem("claim:deed", {
    description = "Claim Deed",
    inventory_image = "default_paper.png^[colorize:#997733:100",
    stack_max = 1
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
		if s_protect.old_is_protected(pos, player_name) then
			minetest.chat_send_player(player_name, 
                "This area is already protected by an other protection mod.")
			return
		end
		if s_protect.underground_limit then
			local minp, maxp = s_protect.get_area_bounds(pos)
			if minp.y < s_protect.underground_limit then
				minetest.chat_send_player(player_name,
					"You can not claim areas below @1." .. s_protect.underground_limit .. "m")
				return
			end
		end
		local data, index = s_protect.get_claim(pos)
		if data then
			minetest.chat_send_player(player_name,
					"This area is already owned by: @1", data.owner)
			return
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

		--itemstack:take_item(1)
		s_protect.update_claims({
			[index] = {owner=player_name, shared={}}
		})

		minetest.add_entity(s_protect.get_center(pos), "simple_protection:marker")
		minetest.chat_send_player(player_name, "Congratulations! You now own this area.")
		return itemstack
	end,
})

local function make_formspec(price)
    local claim_formspec = "size[3,2]" ..
        "label[0,0;Purchase this claim for " .. price .. " gold coins?]" ..
        "button[0,1;1,1;purchase,Purchase]" ..
        "button_exit[0,2.5;1,1;cancel;Cancel]"
    
    return claim_formspec
end
    