if not crops.difficulty then
	crops.settings = {
		chance = 16,
		interval = 120,
		light = 13,
		watercan = 25,
		watercan_max = 100,
		watercan_uses = 20,
		damage_chance = 4,
		damage_interval = 30,
		damage_tick_min = 3,
		damage_tick_max = 7,
		damage_max = 100,
		hydration = true,
	}
end


minetest.override_item("crops:beanpole_base", {
	groups = {seed=1,snappy=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1 },
})

minetest.override_item("crops:watering_can", {
	on_use = function(itemstack, user, pointed_thing)
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
		-- Wet farming soil underneath if dry
		local soil_pos = {x=pos.x, y=pos.y-1, z=pos.z}
		farming.wet_soil_in_area(soil_pos, 1)

		if not minetest.settings:get_bool("creative_mode") then
			itemstack:set_wear(math.min(65534, wear + (65535 / crops.settings.watercan_uses)))
		end
		return itemstack
	end
})