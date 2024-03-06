
--[[

Copyright (C) 2015 - Auke Kok <sofar@foo-projects.org>

"crops" is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1
of the license, or (at your option) any later version.

--]]

crops = {}
crops.plants = {}
crops.settings = {}

local settings = {}
settings.easy = {
	chance = 4,
	interval = 30,
	light = 8,
	watercan = 25,
	watercan_max = 90,
	watercan_uses = 20,
	damage_chance = 8,
	damage_interval = 30,
	damage_tick_min = 0,
	damage_tick_max = 1,
	damage_max = 25,
	hydration = false,
}
settings.normal = {
	chance = 8,
	interval = 30,
	light = 10,
	watercan = 25,
	watercan_max = 90,
	watercan_uses = 20,
	damage_chance = 8,
	damage_interval = 30,
	damage_tick_min = 0,
	damage_tick_max = 5,
	damage_max = 50,
	hydration = true,
}
settings.difficult = {
	chance = 16,
	interval = 30,
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
settings.frontier = {
	chance = 8,
	interval = 31,
	light = 13,
	watercan = 25,
	watercan_max = 100,
	watercan_uses = 24,
	damage_chance = 4,
	damage_interval = 67,
	damage_tick_min = 3,
	damage_tick_max = 6,
	damage_max = 100,
	hydration = true,
}

local worldpath = minetest.get_worldpath()
local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Load support for intllib.
local S, _ = dofile(modpath .. "/intllib.lua")
crops.intllib = S

dofile(modpath .. "/crops_settings.txt")

if io.open(worldpath .. "/crops_settings.txt", "r") == nil then
	io.input(modpath .. "/crops_settings.txt")
	io.output(worldpath .. "/crops_settings.txt")

	local size = 4096
	while true do
		local buf = io.read(size)
		if not buf then
			io.close()
			break
		end
		io.write(buf)
	end
else
	dofile(worldpath .. "/crops_settings.txt")
end

if not crops.difficulty then
	crops.difficulty = "frontier"
	minetest.log("action", "[crops] "..S("Defaulting to \"frontier\" difficulty settings"))
end
crops.settings = settings[crops.difficulty]
if not crops.settings then
	minetest.log("action", "[crops] "..S("Defaulting to \"frontier\" difficulty settings"))
	crops.settings = settings.frontier
end
if crops.settings.hydration then
	minetest.log("action", "[crops] "..S("Hydration and dehydration mechanics are enabled."))
end

crops.find_plant = function(node)
	for i = 1,table.getn(crops.plants) do
		if crops.plants[i].name == node.name then
			return crops.plants[i]
		end
	end
	minetest.log("warning", "[crops] "..S("Unable to find plant \"@1\" in crops table", node.name))
	return false
end

crops.register = function(plantdef)
	table.insert(crops.plants, plantdef)
end

crops.plant = function(pos, node)
	minetest.set_node(pos, node)
	local meta = minetest.get_meta(pos)
	local plant = crops.find_plant(node)
	meta:set_int("crops_water", math.max(plant.properties.waterstart, 1))
	meta:set_int("crops_damage", 0)
	meta:set_int("crops_time_grew", minetest.get_gametime())
	crops.update_infotext(pos, "Germinating")
end

-- Update crop infotext
crops.update_infotext = function(pos, status)
	local node = minetest.get_node(pos)
	local plant = crops.find_plant(node)
	if not plant and minetest.get_item_group(node.name, "flora") == 0 then
		minetest.log("warning", "[crops] Failed to find crop to update infotext at ".. minetest.pos_to_string(pos), 0)
		return
	end
	local meta = minetest.get_meta(pos)
	local infotext = minetest.registered_nodes[node.name].description
	if crops.settings.hydration and plant then
		infotext = infotext .. "\nMoisture: " .. meta:get_int("crops_water")  .. "%"
	end
	local damage = meta:get_int("crops_damage")
	if damage > 0 and plant then
		infotext = infotext .. "\nDamage: " .. damage .. "%"
	end
	if meta:get_int("crops_time_grew") > 0 and plant then
		local time_left = math.floor((plant.properties.time_to_grow - (minetest.get_gametime() - meta:get_int("crops_time_grew")))/60)
		if time_left > 0 then
			infotext = infotext .. "\nGrowing in: ~" .. time_left .. "'"
		else
			infotext = infotext .. "\nReady to grow"
		end
	end
	if type(status) == "string" then
		infotext = infotext .. "\n" .. status
	end
	meta:set_string("infotext", infotext)
end

-- Farming soil wet or dry depending on crops water level
crops.update_soil_under_crop = function(crop_pos)
	local plant = crops.find_plant(minetest.get_node(crop_pos))
	if not plant then
		return
	end
	local watered = minetest.get_meta(crop_pos):get_int("crops_water") > plant.properties.wither
	local pos = {x=crop_pos.x, y=crop_pos.y-1, z=crop_pos.z}
	local node = minetest.get_node(pos)
    local n_def = minetest.registered_nodes[node.name] or nil
	if n_def == nil then
		return
	elseif n_def.soil == nil then
		return
	end
	local wet = n_def.soil.wet or nil
	local base = n_def.soil.base or nil
	local dry = n_def.soil.dry or nil
	if not wet or not base or not dry then
		return
	end
	if watered and node.name == dry then
        minetest.set_node(pos, {name=wet})
    elseif not watered and node.name == wet then
		minetest.set_node(pos, {name=dry})
	end
end

crops.selection_boxes = {
	seed = {-0.4375, -0.5, -0.4375,  0.4375, -0.4375, 0.4375},
	base = {-0.4375, -0.5, -0.4375,  0.4375, -0.25, 0.4375},
	full = {-0.4375, -0.5, -0.4375,  0.4375, 0.5, 0.4375},
	double = {-0.4375, -0.5, -0.4375,  0.4375, 1.5, 0.4375}
}

crops.can_grow = function(pos)
	if minetest.get_node_light(pos) < crops.settings.light then
		return false
	end
	local node = minetest.get_node(pos)
	local plant = crops.find_plant(node)
	if not plant then
		return false
	end
	crops.update_infotext(pos)
	-- Crops reduced chance of growing when cold and do not grow when cold enough to cause damage
	if temperature then
		local temp = temperature.get_adjusted_temp(pos)
		if temp < plant.properties.cold_damage then
			crops.update_infotext(pos, "Freezing!")
			return false
		elseif temp < plant.properties.cold then
			crops.update_infotext(pos, "Cold")
			if math.random(0,1) == 0 then
				return false
			end
		end
	end
	local meta = minetest.get_meta(pos)
	local time_grew = meta:get_int("crops_time_grew")
	if time_grew > 0 then
		local time_to_grow = plant.properties.time_to_grow
		if time_to_grow then
			if minetest.get_gametime() < time_to_grow + time_grew then
				crops.update_infotext(pos)
				return false
			end
		end
	end

	if crops.settings.hydration then
		local water = meta:get_int("crops_water")
		crops.update_soil_under_crop(pos)
		if water < plant.properties.wither_damage or water > plant.properties.soak_damage then
			if math.random(0,100) > math.max(25, water) then
				return false
			end
		elseif water < plant.properties.wither or water > plant.properties.soak then
			if math.random(0,3) == 0 then
				return false
			end
		end
	end

	local damage = meta:get_int("crops_damage")
	if not damage == 0 then
		if math.random(math.min(50, damage), 100) > 75 then
			return false
		end
	end
	-- allow the plant to grow
	return true
end

crops.grow = function(pos)
	local plant = crops.find_plant(minetest.get_node(pos))
	if not plant then
		return
	end
	if not plant.properties.grow then
		return
	end
	plant.properties.grow(pos)
	local meta = minetest.get_meta(pos)
	meta:set_int("crops_time_grew", minetest.get_gametime())
	-- growing costs water!
	if crops.settings.hydration then
		local water = meta:get_int("crops_water")
		meta:set_int("crops_water", math.max(1, water - plant.properties.wateruse))
	end
	crops.update_infotext(pos)
end

crops.particles = function(pos, flag)
	if flag == 0 then
		-- wither (0)
		minetest.add_particlespawner({
			amount = 1 * crops.settings.interval,
			time = crops.settings.interval,
			minpos = { x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4 },
			maxpos = { x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4 },
			minvel = { x = 0, y = 0.2, z = 0 },
			maxvel = { x = 0, y = 0.4, z = 0 },
			minacc = { x = 0, y = 0, z = 0 },
			maxacc = { x = 0, y = 0.2, z = 0 },
			minexptime = 3,
			maxexptime = 5,
			minsize = 1,
			maxsize = 2,
			collisiondetection = false,
			texture = "crops_wither.png",
			vertical = true,
		})
	elseif flag == 1 then
		-- soak (1)
		minetest.add_particlespawner({
			amount = 8 * crops.settings.interval,
			time = crops.settings.interval,
			minpos = { x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4 },
			maxpos = { x = pos.x + 0.4, y = pos.y - 0.4, z = pos.z + 0.4 },
			minvel = { x = -0.04, y = 0, z = -0.04 },
			maxvel = { x = 0.04, y = 0, z = 0.04 },
			minacc = { x = 0, y = 0, z = 0 },
			maxacc = { x = 0, y = 0, z = 0 },
			minexptime = 3,
			maxexptime = 5,
			minsize = 1,
			maxsize = 2,
			collisiondetection = false,
			texture = "crops_soak.png",
			vertical = false,
		})
	elseif flag == 2 then
		-- watering (2)
		minetest.add_particlespawner({
			amount = 30,
			time = 3,
			minpos = { x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4 },
			maxpos = { x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4 },
			minvel = { x = 0, y = 0.0, z = 0 },
			maxvel = { x = 0, y = 0.0, z = 0 },
			minacc = { x = 0, y = -9.81, z = 0 },
			maxacc = { x = 0, y = -9.81, z = 0 },
			minexptime = 2,
			maxexptime = 2,
			minsize = 1,
			maxsize = 3,
			collisiondetection = false,
			texture = "crops_watering.png",
			vertical = true,
		})
	else
		-- withered/rotting (3)
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x + 0.3, y = pos.y - 0.5, z = pos.z - 0.5 },
			maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
			minvel = { x = -0.6, y = -0.1, z = -0.2 },
			maxvel = { x = -0.4, y = 0.1, z = 0.2 },
			minacc = { x = 0.4, y = 0, z = -0.1 },
			maxacc = { x = 0.5, y = 0, z = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x - 0.3, y = pos.y - 0.5, z = pos.z - 0.5 },
			maxpos = { x = pos.x - 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
			minvel = { x = 0.6, y = -0.1, z = -0.2 },
			maxvel = { x = 0.4, y = 0.1, z = 0.2 },
			minacc = { x = -0.4, y = 0, z = -0.1 },
			maxacc = { x = -0.5, y = 0, z = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x - 0.5, y = pos.y - 0.5, z = pos.z + 0.3 },
			maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
			minvel = { z = -0.6, y = -0.1, x = -0.2 },
			maxvel = { z = -0.4, y = 0.1, x = 0.2 },
			minacc = { z = 0.4, y = 0, x = -0.1 },
			maxacc = { z = 0.5, y = 0, x = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x - 0.5, y = pos.y - 0.5, z = pos.z - 0.3 },
			maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z - 0.5 },
			minvel = { z = 0.6, y = -0.1, x = -0.2 },
			maxvel = { z = 0.4, y = 0.1, x = 0.2 },
			minacc = { z = -0.4, y = 0, x = -0.1 },
			maxacc = { z = -0.5, y = 0, x = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
	end
end

crops.die = function(pos)
	crops.particles(pos, 3)
	local node = minetest.get_node(pos)
	local plant = crops.find_plant(node)
	plant.properties.die(pos)
	crops.update_infotext(pos)
	minetest.sound_play("crops_flies", {pos=pos, gain=0.8})
end

if crops.settings.hydration then
	dofile(modpath .. "/tools.lua")
end

-- crop nodes, crafts, craftitems
dofile(modpath .. "/melon.lua")
dofile(modpath .. "/pumpkin.lua")
dofile(modpath .. "/corn.lua")
dofile(modpath .. "/tomato.lua")
dofile(modpath .. "/potato.lua")
dofile(modpath .. "/polebean.lua")
dofile(modpath .. "/cotton.lua")
dofile(modpath .. "/sunflower.lua")
dofile(modpath .. "/grains.lua")

-- cooking recipes that mix craftitems
dofile(modpath .. "/cooking.lua")
--dofile(modpath .. "/mapgen.lua")

minetest.log("action", "[crops] "..S("Loaded!"))
