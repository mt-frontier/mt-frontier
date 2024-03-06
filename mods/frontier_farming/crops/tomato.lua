
--[[

Copyright (C) 2015 - Auke Kok <sofar@foo-projects.org>

"crops" is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1
of the license, or (at your option) any later version.

--]]

-- Intllib
local S = crops.intllib

minetest.register_node("crops:tomato_seed", {
	description = S("Tomato seed"),
	inventory_image = "crops_tomato_seed.png",
	wield_image = "crops_tomato_seed.png",
    tiles = {"crops_tomato_seed.png"},
	drawtype = "signlike",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.seed
	},
	on_place = function(itemstack, placer, pointed_thing)
		local under = minetest.get_node(pointed_thing.under)
		if minetest.get_item_group(under.name, "soil") <= 1 then
			return
		end
		crops.plant(pointed_thing.above, {name="crops:tomato_seed", param2 = 1})

		if not minetest.settings:get_bool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end
})

for stage = 1, 4 do
minetest.register_node("crops:tomato_plant_" .. stage , {
	description = S("Tomato plant"),
	tiles = { "crops_tomato_plant_" .. stage .. ".png" },
	drawtype = "plantlike",
	paramtype2 = "meshoptions",
	waving = 1,
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.base
	}
})
end

minetest.register_node("crops:tomato_plant_5" , {
	description = S("Tomato plant"),
	tiles = { "crops_tomato_plant_5.png" },
	drawtype = "plantlike",
	paramtype2 = "meshoptions",
	waving = 1,
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.full
	},
	on_dig = function(pos, node, digger)
		local drops = {}
		local damage = minetest.get_meta(pos):get_int("crops_damage")
		local n = 1

		if damage < 25 then
			n = n + 2
		elseif damage < 70 then
			n = n + 1
		else
			n = n + math.random(0,1)
		end

		for i = 1, n do
			table.insert(drops, "crops:tomato")
		end
		core.handle_node_drops(pos, drops, digger)

		local meta = minetest.get_meta(pos)
		local ttl = meta:get_int("crops_tomato_ttl")
		if ttl > 1 then
			minetest.swap_node(pos, { name = "crops:tomato_plant_3", param2 = 1})
			meta:set_int("crops_tomato_ttl", ttl - 1)
			crops.update_infotext(pos)
		else
			crops.die(pos)
		end
	end
})

minetest.register_node("crops:tomato_plant_6", {
	description = S("Tomato plant"),
	tiles = { "crops_tomato_plant_6.png" },
	drawtype = "plantlike",
	paramtype2 = "meshoptions",
	waving = 1,
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.full
	},
})

minetest.register_node("crops:tomato", {
    drawtype = "plantlike",
    tiles = {"crops_tomato.png"},
    visual_scale= 0.5,
	description = S("Tomato"),
	inventory_image = "crops_tomato.png",
    paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16},
    },
	on_use = minetest.item_eat(1, "crops:tomato_seed"),
    groups = {fleshy=3, snappy=3, dig_immediate=3, food_tomato=1}
})

-- handle tomato crop growth
crops.tomato_grow = function(pos)
	local node = minetest.get_node(pos)
	local n = string.gsub(node.name, "4", "5")
	n = string.gsub(n, "3", "4")
	n = string.gsub(n, "2", "3")
	n = string.gsub(n, "1", "2")
	if n == "crops:tomato_seed" then
		n = "crops:tomato_plant_1"
	elseif n == "crops:tomato_plant_4" then
		local meta = minetest.get_meta(pos)
		local ttl = meta:get_int("crops_tomato_ttl")
		local damage = meta:get_int("crops_damage")
		if ttl == 0 then
			-- damage 0   - drops 4-6
			-- damage 50  - drops 2-3
			-- damage 100 - drops 0-1
			ttl = math.random(4 - (4 * (damage / 100)), 6 - (5 * (damage / 100)))
		end
		if ttl > 1 then
			--minetest.swap_node(pos, { name = "crops:tomato_plant_5", param2 = 1 })
			meta:set_int("crops_tomato_ttl", ttl)
		else
			crops.die(pos)
			return
		end
	end

	minetest.swap_node(pos, { name = n, param2 = 1 })
	end

crops.tomato_die = function(pos)
	minetest.set_node(pos, { name = "crops:tomato_plant_6", param2 = 1 })
end

local properties = {
	die = crops.tomato_die,
	grow = crops.tomato_grow,
	waterstart = 15,
	wateruse = 2,
	night = 5,
	soak = 80,
	soak_damage = 90,
	wither = 20,
	wither_damage = 10,
    cold = 52,
    cold_damage = 42,
    time_to_grow = 1200,
}

crops.register({ name = "crops:tomato_plant_1", properties = properties })
crops.register({ name = "crops:tomato_plant_2", properties = properties })
crops.register({ name = "crops:tomato_plant_3", properties = properties })
crops.register({ name = "crops:tomato_plant_4", properties = properties })
crops.register({ name = "crops:tomato_plant_5", properties = properties })

properties.soak = 90
properties.soak_damage = 101 -- Out of range, no damage to seeds for soaking
crops.register({ name = "crops:tomato_seed", properties = properties })
