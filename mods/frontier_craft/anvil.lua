local S = minetest.get_translator(minetest.get_current_modname())

anvil = {}
anvil.settings ={
    item_displacement = 0.125,
}

local hud_timeout = 1  -- seconds
local hud_info_by_puncher_name = {}

local hud_timer = 0
minetest.register_globalstep(function(dt)
    hud_timer = hud_timer + dt
    if hud_timer < hud_timeout/2 then
        return
    end

    hud_timer = 0
	local now = os.time()

	for puncher_name, hud_info in pairs(hud_info_by_puncher_name) do
		local hud2, hud3, hud_expire_time = unpack(hud_info)
		if now > hud_expire_time then
			local puncher = minetest.get_player_by_name(puncher_name)
			if puncher then
				local hud2_def = puncher:hud_get(hud2)
				if hud2_def and hud2_def.name == "anvil_background" then
					puncher:hud_remove(hud2)
				end

				local hud3_def = puncher:hud_get(hud3)
				if hud3_def and hud3_def.name == "anvil_foreground" then
					puncher:hud_remove(hud3)
				end
			end

			hud_info_by_puncher_name[puncher_name] = nil
		end
	end
end)


anvil.make_unrepairable = function(item_name)
	local item_def = minetest.registered_items[item_name]
	if item_def then
		local groups = table.copy(item_def.groups)
		groups.not_repaired_by_anvil = 1
		minetest.override_item(item_name, {groups = groups})
	end
end

anvil.make_unrepairable("frontier_tools:flint_and_steel")
anvil.make_unrepairable("frontier_tools:friction_bow")

minetest.register_node("frontier_craft:anvil", {
	drawtype = "nodebox",
	description = S("Anvil"),
	_doc_items_longdesc = S("A tool for repairing other tools in conjunction with a blacksmith's hammer."),
	_doc_items_usagehelp = S("Right-click on this anvil with a damaged tool to place the damaged tool upon it. " ..
		"You can then repair the damaged tool by striking it with a blacksmith's hammer. " ..
		"Repeated blows may be necessary to fully repair a badly worn tool. " ..
		"To retrieve the tool either punch or right-click the anvil with an empty hand."),
	tiles = {"default_coal_block.png"},
	paramtype = "light",
	paramtype2 = "facedir",
    is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
	-- the nodebox model comes from realtest
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3, 0.5, -0.4, 0.3},
			{-0.35, -0.4, -0.25, 0.35, -0.3, 0.25},
			{-0.3, -0.3, -0.15, 0.3, -0.1, 0.15},
			{-0.35, -0.1, -0.2, 0.35, 0.1, 0.2},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3, 0.5, -0.4, 0.3},
			{-0.35, -0.4, -0.25, 0.35, -0.3, 0.25},
			{-0.3, -0.3, -0.15, 0.3, -0.1, 0.15},
			{-0.35, -0.1, -0.2, 0.35, 0.1, 0.2},
		}
	},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
	end,

	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		local stackmeta = itemstack:get_meta()
		if stackmeta:get_int("shared") == 1 then
			meta:set_int("shared", 1)
			meta:set_string("infotext", S("Shared anvil"))
		else
			meta:set_string("owner", placer:get_player_name() or "")
			meta:set_string("infotext", S("@1's anvil", placer:get_player_name()))
		end
	end,

	preserve_metadata = function(pos, oldnode, oldmeta, drops)
		if next(drops) and tonumber(oldmeta.shared) == 1 then
			local meta = drops[next(drops)]:get_meta()
			meta:set_int("shared", 1)
			meta:set_string("description", S("Shared anvil"))
		end
		return drops
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if not inv:is_empty("input") then
			return false
		end
		return true
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if listname ~= "input" then
			return 0
		end

		if not frontier_craft.has_access(pos, player) then
            return 0
		end

		local player_name = player:get_player_name()
		if stack:get_wear() == 0 then
			minetest.chat_send_player(player_name, S("This anvil is for damaged tools only."))
			return 0
		end

		local stack_name = stack:get_name()
		if minetest.get_item_group(stack_name, "not_repaired_by_anvil") ~= 0 then
			local item_def = minetest.registered_items[stack_name]
			minetest.chat_send_player(player_name, S("@1 cannot be repaired with an anvil.", item_def.description))
			return 0
		end

		if meta:get_inventory():room_for_item("input", stack) then
			return stack:get_count()
		end
		return 0
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if not frontier_craft.has_access(pos, player) then
			return 0
		end

		if listname ~= "input" then
			return 0
		end
		return stack:get_count()
	end,

	on_rightclick = function(pos, node, clicker, itemstack)
		if not clicker or not itemstack then
			return
		end
		local meta = minetest.get_meta(pos)
		local name = clicker:get_player_name()
		local owner = meta:get_string("owner")
		local shared = meta:get_int("shared") == 1

		if name ~= owner and not shared then
			return itemstack
		end
		if itemstack:get_count() == 0 then
			local inv = meta:get_inventory()
			if not inv:is_empty("input") then
				local return_stack = inv:get_stack("input", 1)
				inv:set_stack("input", 1, nil)
				local wield_index = clicker:get_wield_index()
				clicker:get_inventory():set_stack("main", wield_index, return_stack)
				if shared then
					meta:set_string("infotext", S("Shared anvil"))
				else
					meta:set_string("infotext", S("@1's anvil", owner))
				end
				frontier_craft.remove_item_entity(pos, node)
				return return_stack
			end
		end
		local this_def = minetest.registered_nodes[node.name]
		if this_def.allow_metadata_inventory_put(pos, "input", 1, itemstack:peek_item(), clicker) > 0 then
			local s = itemstack:take_item()
			local inv = meta:get_inventory()
			inv:add_item("input", s)
			local meta_description = s:get_meta():get_string("description")
			if "" ~= meta_description then
				if shared then
					meta:set_string("infotext", S("Shared anvil"))
				else
					meta:set_string("infotext", S("@1's anvil", owner) .. "\n" .. meta_description)
				end
			end
			meta:set_int("informed", 0)
			local item_pos = {x=pos.x, y=pos.y, z=pos.z}
			frontier_craft.update_item_entity(item_pos, node)
		end

		return itemstack
	end,

	on_punch = function(pos, node, puncher)
		if not pos or not node or not puncher then
			return
		end

		local wielded = puncher:get_wielded_item()
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local owner = meta:get_string("owner")
		local shared = meta:get_int("shared") == 1
		local puncher_name = puncher:get_player_name()
		if not shared and owner ~= puncher_name then
			return
		end

		if wielded:get_count() == 0 then
			if not inv:is_empty("input") then
				local return_stack = inv:get_stack("input", 1)
				inv:set_stack("input", 1, nil)
				local wield_index = puncher:get_wield_index()
				puncher:get_inventory():set_stack("main", wield_index, return_stack)
				if shared then
					meta:set_string("infotext", S("Shared anvil"))
				else
					meta:set_string("infotext", S("@1's anvil", owner))
				end
				frontier_craft.remove_item_entity(pos, node)
			end
		end

		-- only punching with the hammer is supposed to work
		if wielded:get_name() ~= "frontier_tools:forge_hammer" then
			return
		end
		local input = inv:get_stack("input", 1)

		-- only tools can be repaired
		if not input or input:is_empty() then
			return
		end

        -- do the actual repair
		input:add_wear(-5000) -- equals to what technic toolshop does in 5 seconds
		inv:set_stack("input", 1, input)

		-- 65535 is max damage
		local damage_state = 40 - math.floor(input:get_wear() / 1638)
        print(damage_state)
		local tool_name = input:get_name()

		if input:get_wear() >= 0 then
			local hud2, hud3, hud3_def

			if hud_info_by_puncher_name[puncher_name] then
				hud2, hud3 = unpack(hud_info_by_puncher_name[puncher_name])
				hud3_def = puncher:hud_get(hud3)
			end

			if hud3_def and hud3_def.name == "anvil_foreground" then
				puncher:hud_change(hud3, "number", damage_state)

			else
				hud2 = puncher:hud_add({
					name = "anvil_background",
					hud_elem_type = "statbar",
					text = "default_cloud.png^[colorize:#ff0000:256",
					number = 40,
					direction = 0, -- left to right
					position = {x = 0.5, y = 0.5},
					alignment = {x = 0, y = 0},
					offset = {x = -160, y = -120},
					size = {x = 16, y = 16},
				})
				hud3 = puncher:hud_add({
					name = "anvil_foreground",
					hud_elem_type = "statbar",
					text = "default_cloud.png^[colorize:#00ff00:256",
					number = damage_state,
					direction = 0, -- left to right
					position = {x = 0.5, y = 0.5},
					alignment = {x = 0, y = 0},
					offset = {x = -160, y = -120},
					size = {x = 16, y = 16},
				})
			end
            
			hud_info_by_puncher_name[puncher_name] = {hud2, hud3, os.time() + hud_timeout}
		end

		-- tell the player when the job is done
		if input:get_wear() == 0 then
			-- but only once
			if 0 < meta:get_int("informed") then
				return
			end
			meta:set_int("informed", 1)
			local tool_desc
			local meta_description = input:get_meta():get_string("description")
			if "" ~= meta_description then
				tool_desc = meta_description
			elseif minetest.registered_items[tool_name] and minetest.registered_items[tool_name].description then
				tool_desc = minetest.registered_items[tool_name].description
			else
				tool_desc = tool_name
			end
			minetest.chat_send_player(puncher_name, S("Your @1 has been repaired successfully.", tool_desc))
			return
		else
			pos.y = pos.y + frontier_craft.settings.item_entity_offset
			minetest.sound_play({name = "anvil_clang"}, {pos = pos, gain=0.25})
			minetest.add_particlespawner({
				amount = 10,
				time = 0.1,
				minpos = pos,
				maxpos = pos,
				minvel = {x = 2, y = 3, z = 2},
				maxvel = {x = -2, y = 1, z = -2},
				minacc = {x = 0, y = -10, z = 0},
				maxacc = {x = 0, y = -10, z = 0},
				minexptime = 0.5,
				maxexptime = 1,
				minsize = 1,
				maxsize = 1,
				collisiondetection = true,
				vertical = false,
				texture = "anvil_spark.png",
			})
		end

		-- damage the hammer slightly
		wielded:add_wear(100)
		puncher:set_wielded_item(wielded)
	end,
})
