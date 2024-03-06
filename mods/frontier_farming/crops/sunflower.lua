
local S = crops.intllib

minetest.register_node("crops:sunflower", {
	description = S("Sunflower"),
	inventory_image = "crops_sunflower.png",
	wield_image = "crops_sunflower.png",
	tiles = { "crops_sunflower.png" },
	drawtype = "signlike",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	paramtype2 = "wallmounted",
	groups = { snappy=3,flammable=3 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.seed
	}
})

minetest.register_node("crops:sunflower_seed", {
	description = S("Sunflower_seeds"),
	inventory_image = "crops_sunflower_seed.png",
	wield_image = "crops_sunflower_seed.png",
	tiles = { "crops_sunflower_seed.png" },
	drawtype = "signlike",
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
	on_use = minetest.item_eat(1),
	on_place = function(itemstack, placer, pointed_thing)
		local under = minetest.get_node(pointed_thing.under)
		if minetest.get_item_group(under.name, "soil") <= 1 then
			return
		end
		crops.plant(pointed_thing.above, {name="crops:sunflower_seed"})
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end
})

minetest.register_node("crops:sunflower_base_1", {
	description = S("Sunflower plant"),
	drawtype = "plantlike",
	tiles = { "crops_sunflower_base_1.png" },
	waving = 1,
	use_texture_alpha = true,
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.base
	}
})

minetest.register_node("crops:sunflower_base_2", {
	description = S("Sunflower plant"),
	drawtype = "plantlike",
	tiles = { "crops_sunflower_base_2.png" },
	waving = 1,
	use_texture_alpha = true,
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.base
	}
})

minetest.register_node("crops:sunflower_base_3", {
	description = S("Sunflower plant"),
	drawtype = "plantlike",
	tiles = { "crops_sunflower_base_3.png" },
	waving = 1,
	use_texture_alpha = true,
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.full
	},
	on_dig = function(pos, node, digger)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(above).name == "crops:sunflower_top_1" then
			minetest.remove_node(above)
			minetest.remove_node(pos)
			return
		end
		if  minetest.get_node(above).name ~= "crops:sunflower_top_2" then
			return
		end
		local meta = minetest.get_meta(pos)
		local damage = meta:get_int("crops_damage")
		local drops = {}
		--   0 - 3-7
		--  50 - 2-3
		-- 100 - 1-1
		if damage < 10 then
			print(damage)
			table.insert(drops, ('crops:sunflower'))
		end

		for i = 1,math.random(2 - (damage / 100), 4 - (3 * (damage / 100))) do
			table.insert(drops, ('crops:sunflower_seed'))
		end

		minetest.set_node(pos, { name = "crops:sunflower_base_4", param2 = 3 })
		minetest.set_node(above, { name = "crops:sunflower_top_3", param2 = 3 })
		core.handle_node_drops(above, drops, digger)
	end,
})

minetest.register_node("crops:sunflower_base_4", {
	description = S("Sunflower plant"),
	drawtype = "plantlike",
	tiles = { "crops_sunflower_base_4.png" },
	use_texture_alpha = true,
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	on_dig = function(pos, node, digger)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(above).name == "crops:sunflower_top_3" then
			minetest.remove_node(above)
		end
		minetest.remove_node(pos)
	end,
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.double
	}
})

minetest.register_node("crops:sunflower_top_1", {
	description = S("Sunflower plant"),
	drawtype = "plantlike",
	tiles = { "crops_sunflower_top_1.png" },
	waving = 1,
	use_texture_alpha = true,
	walkable = false,
	pointable = false,
	sunlight_propagates = true,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	on_dig = function(pos, node, digger)
		local below = {x = pos.x, y = pos.y - 1, z = pos.z}
		if not minetest.get_node(below).name == "crops:sunflower_base_2" then
			return
		end
		minetest.remove_node(below)
		minetest.remove_node(pos)
	end
})

minetest.register_node("crops:sunflower_top_2", {
	description = S("Sunflower plant"),
	drawtype = "plantlike",
	tiles = { "crops_sunflower_top_2.png" },
	waving = 1,
	use_texture_alpha = true,
	walkable = false,
	pointable = false,
	sunlight_propagates = true,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	on_dig = function(pos, node, digger)
		local below = {x = pos.x, y = pos.y - 1, z = pos.z}
		if not minetest.get_node(below).name == "crops:sunflower_base_2" then
			return
		end
		minetest.remove_node(below)
		minetest.remove_node(pos)
		local meta = minetest.get_meta(pos)
		local damage = meta:get_int("crops_damage")
		local drops = {}
		--   0 - 3-7
		--  50 - 2-3
		-- 100 - 1-1
		for i = 1,math.random(3 - (damage / 100), 7 - (6 * (damage / 100))) do
			table.insert(drops, ('crops:sunflower_seed'))
		end
		minetest.set_node(pos, { name = "crops:sunflower_base_4", param2 = 3 })
		minetest.set_node(above, { name = "crops:sunflower_top_3", param2 = 3 })
		core.handle_node_drops(above, drops, digger)
	end
})

minetest.register_node("crops:sunflower_top_3", {
	description = S("Sunflower plant"),
	drawtype = "plantlike",
	tiles = { "crops_sunflower_top_3.png" },
	waving = 1,
	use_texture_alpha = true,
	walkable = false,
	pointable = false,
	sunlight_propagates = true,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,not_in_creative_inventory=1 },
	drop = {},
	sounds = default.node_sound_leaves_defaults(),
	on_dig = function(pos, node, digger)
		local below = {x = pos.x, y = pos.y - 1, z = pos.z}
		if not minetest.get_node(below).name == "crops:sunflower_base_4" then
			return
		end
		minetest.remove_node(below)
		minetest.remove_node(pos)
	end
})

crops.sunflower_grow = function(pos)
	local node = minetest.get_node(pos)
	if node.name == "crops:sunflower_seed" then
		minetest.swap_node(pos, {name = "crops:sunflower_base_1"})
	elseif node.name == "crops:sunflower_base_1" then
		minetest.swap_node(pos, {name = "crops:sunflower_base_2"})
	elseif node.name == "crops:sunflower_base_2" then
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(above).name ~= "air" then
			return
		end
		minetest.swap_node(pos, {name = "crops:sunflower_base_3"})
		minetest.set_node(above , { name = "crops:sunflower_top_1"})
		minetest.get_meta(above):set_int("crops_top_half", 1)
	elseif node.name == "crops:sunflower_base_3" then
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		minetest.swap_node(above , { name = "crops:sunflower_top_2"})
	end
end

crops.sunflower_die = function(pos)
	minetest.set_node(pos, { name = "crops:sunflower_base_4", param2 = 3 })
	local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	minetest.set_node(above, { name = "crops:sunflower_top_3", param2 = 3 })
end

local properties = {
	die = crops.sunflower_die,
	grow = crops.sunflower_grow,
	waterstart = 15,
	wateruse = 2,
	night = 5,
	soak = 75,
	soak_damage = 85,
	wither = 20,
	wither_damage = 10,
	doublesize = true,
	cold = 50,
    cold_damage = 40,
    time_to_grow = 800,
}

crops.register({name = "crops:sunflower_seed", properties = properties})
crops.register({name = "crops:sunflower_base_1", properties = properties})
crops.register({name = "crops:sunflower_base_2", properties = properties})
crops.register({name = "crops:sunflower_base_3", properties = properties})
