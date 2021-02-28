minetest.override_item("crops:beanpole_base", {
	groups = {seed=1,snappy=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1 },
})

function farming.update_soil(pos, node) 
	local n_def = minetest.registered_nodes[node.name] or nil
	local wet = n_def.soil.wet or nil
	local base = n_def.soil.base or nil
	local dry = n_def.soil.dry or nil
	if not n_def or not n_def.soil or not wet or not base or not dry then
		return
	end

	pos.y = pos.y + 1
	local nn = minetest.get_node_or_nil(pos)
	if not nn or not nn.name then
		return
	end
	local nn_def = minetest.registered_nodes[nn.name] or nil
	pos.y = pos.y - 1

	if nn_def and nn_def.walkable and minetest.get_item_group(nn.name, "plant") == 0 then
		minetest.set_node(pos, {name = base})
		return
	end
	-- check if there is water nearby
	local wet_lvl = minetest.get_item_group(node.name, "wet")
	if minetest.find_node_near(pos, 3, {"group:water"}) then
		-- if it is dry soil and not base node, turn it into wet soil
		if wet_lvl == 0 then
			minetest.set_node(pos, {name = wet})
		end
	else
		-- only turn back if there are no unloaded blocks (and therefore
		-- possible water sources) nearby
		if not minetest.find_node_near(pos, 3, {"ignore"}) then
			-- turn it back into base if it is already dry
			if wet_lvl == 0 then
				-- only turn it back if there is no plant/seed on top of it
				if minetest.get_item_group(nn.name, "plant") == 0 
				and minetest.get_item_group(nn.name, "seed") == 0 
				and minetest.get_item_group(nn.name, "flora") == 0 then
					minetest.set_node(pos, {name = base})
				end

			-- if its wet turn it back into dry soil
			elseif wet_lvl == 1 then
				minetest.set_node(pos, {name = dry})
			end
		end
	end
end