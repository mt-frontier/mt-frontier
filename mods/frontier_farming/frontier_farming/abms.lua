local nodenames = {}
minetest.register_on_mods_loaded(function()
	for i = 1,table.getn(crops.plants) do
		table.insert(nodenames, crops.plants[i].name)
	end

	minetest.register_abm({
		label = "Crops growing",
		nodenames = nodenames,
		neighbors = {"group:soil"},
		interval = crops.settings.interval,
		chance = crops.settings.chance,
		catch_up = true,
		action = function(pos, node, active_object_count, active_object_count_wider)
			if not crops.can_grow(pos) then
				return
			end
			crops.grow(pos)
		end
	})

	-- water handling code
	if crops.settings.hydration then
		minetest.register_abm({
			label = "Crops hydration and damage",
			nodenames = nodenames,
			interval = crops.settings.damage_interval,
			chance = crops.settings.damage_chance,
			action = function(pos, node, active_object_count, active_object_count_wider)
				local meta = minetest.get_meta(pos)
				local water = meta:get_int("crops_water")
				local damage = meta:get_int("crops_damage")

				-- get plant specific data
				local plant = crops.find_plant(node)
				if plant == nil then
					return
				end

				-- increase water for nearby water sources
				local water_nodes = minetest.find_nodes_in_area({x=pos.x-2, y = pos.y-1, z = pos.z-2}, {x=pos.x+2, y=pos.y, z=pos.z+2}, "group:water")
				if #water_nodes > 0 then
					for n = 1, #water_nodes do
						water = math.min(100, water + 1)
					end
				end
				
				-- local f = minetest.find_node_near(pos, 1, {"default:water_source", "default:water_flowing"})
				-- if not f == nil then
				-- 	water = math.min(plant.properties.soak-1, water + 50)
				-- else
				-- 	f = minetest.find_node_near(pos, 2, {"default:water_source", "default:water_flowing"})
				-- 	if not f == nil then
				-- 		water = math.min( plant.properties.soak-1, water + 25)
				-- 	end
				-- end

				if minetest.get_node_light(pos, nil) < plant.properties.night then
					-- compensate for light: at night give some water back to the plant
					water = math.min(100, water + 1)
				else
					-- dry out the plant. Higher temperature costs more water.
					local wateruse = plant.properties.wateruse
					local temp = 0
					if temperature then
						temp = temperature.get_adjusted_temp(pos)
						if temp > 95 then
							wateruse = wateruse + 2
						elseif temp > 75 then
							wateruse = wateruse + 1
						end
					end
					water = math.max(1, water - wateruse)
				end

				meta:set_int("crops_water", water)

				-- for convenience, copy water attribute to top half
				-- if not plant.properties.doublesize == nil and plant.properties.doublesize then
				-- 	local above = { x = pos.x, y = pos.y + 1, z = pos.z}
				-- 	local abovemeta = minetest.get_meta(above)
				-- 	abovemeta:set_int("crops_water", water)
				-- end

				-- Cold temperature damages plants
				if temperature then
					local temp = temperature.get_adjusted_temp(pos)
					if temp < plant.properties.cold_damage then
						damage = damage + math.random(crops.settings.damage_tick_min, crops.settings.damage_tick_max)
					end
				end

				if water <= plant.properties.wither_damage then
					crops.particles(pos, 0)
					damage = damage + math.random(crops.settings.damage_tick_min, crops.settings.damage_tick_max)
				elseif water <= plant.properties.wither then
					crops.particles(pos, 0)
				elseif water >= plant.properties.soak_damage then
					crops.particles(pos, 1)
					damage = damage + math.random(crops.settings.damage_tick_min, crops.settings.damage_tick_max)
				elseif water >= plant.properties.soak then
					crops.particles(pos, 1)
				end
				meta:set_int("crops_damage", math.min(crops.settings.damage_max, damage))
				crops.update_infotext(pos)
				-- is it dead?
				if damage >= 100 then
					crops.die(pos)
				end
			end
		})
	end
end)
