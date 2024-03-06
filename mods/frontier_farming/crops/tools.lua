--[[

Copyright (C) 2015 - Auke Kok <sofar@foo-projects.org>

"crops" is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1
of the license, or (at your option) any later version.

--]]

-- Intllib
local S = crops.intllib

local watercan_on_use = function(itemstack, user, pointed_thing)
	local pos = pointed_thing.under
		local ppos = pos
		if not pos then
			return itemstack
		end
		-- filling it up?
		local wear = itemstack:get_wear()
		if minetest.get_item_group(minetest.get_node(pos).name, "water") >= 3 then
			if wear ~= 1 then
				minetest.sound_play("crops_watercan_entering", {pos=pos, gain=0.8})
				minetest.after(math.random()/2, function(p)
					if math.random(2) == 1 then
						minetest.sound_play("crops_watercan_splash_quiet", {pos=p, gain=0.1})
					end
					if math.random(3) == 1 then
						minetest.after(math.random()/2, function(pp)
							minetest.sound_play("crops_watercan_splash_small", {pos=pp, gain=0.7})
						end, p)
					end
					if math.random(3) == 1 then
						minetest.after(math.random()/2, function(pp)
							minetest.sound_play("crops_watercan_splash_big", {pos=pp, gain=0.7})
						end, p)
					end
				end, pos)
				itemstack:set_wear(1)
			end
			return itemstack
		end
		-- using it on a top-half part of a plant?
		local meta = minetest.get_meta(pos)
		if meta:get_int("crops_top_half") == 1 then
			meta = minetest.get_meta({x=pos.x, y=pos.y-1, z=pos.z})
		end
		-- using it on a plant?
		local water = meta:get_int("crops_water")
		if water < 1 then
			local node = minetest.get_node(pos)
			if minetest.get_item_group(node.name, "plant") == 0
			and minetest.get_item_group(node.name, "seed") == 0
			and minetest.get_item_group(node.name, "flora") == 0 then
				return itemstack
			end
		end
		-- empty?
		if wear == 65534 then
			return itemstack
		end
		crops.particles(ppos, 2)
		minetest.sound_play("crops_watercan_watering", {pos=pos, gain=0.8})
		water = math.min(water + crops.settings.watercan, crops.settings.watercan_max)

		meta:set_int("crops_water", water)
		crops.update_infotext(pos)
		-- Wet farming soil underneath if dry
		crops.update_soil_under_crop(pos)

		if not minetest.settings:get_bool("creative_mode") then
			itemstack:set_wear(math.min(65534, wear + (65535 / crops.settings.watercan_uses)))
		end
		return itemstack
end

minetest.register_tool("crops:watering_can", {
	description = S("Watering Can"),
	inventory_image = "crops_watering_can.png",
	liquids_pointable = true,
	range = 3,
	stack_max = 1,
	wear = 65535,
	tool_capabilities = {},
	on_use = function(itemstack, user, pointed_thing)
		return watercan_on_use(itemstack, user, pointed_thing)
	end,
})


minetest.register_tool("crops:watering_jug", {
	description = S("Watering Jug"),
	inventory_image = "crops_watering_jug.png",
	liquids_pointable = true,
	range = 2.5,
	stack_max = 1,
	wear = 65535,
	tool_capabilities = {},
	on_use = function(itemstack, user, pointed_thing)
		return watercan_on_use(itemstack, user, pointed_thing)
	end,
})