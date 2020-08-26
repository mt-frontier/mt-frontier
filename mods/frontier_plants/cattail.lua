
-------------
-- Cattails
-------------
minetest.register_craftitem("frontier_plants:cattail_tuber", {
	description = "Cattail Tuber",
	inventory_image = "frontier_plants_cattail_tuber.png",
	wield_image = "frontier_plants_cattail_tuber.png",
	on_use = minetest.item_eat(2),
	on_place = function(itemstack, placer, pointed_thing)
		local above = pointed_thing.above
		local above2 = {x = above.x, y = above.y + 1, z = above.z}
		local under = pointed_thing.under
		if minetest.get_node(under).name == "default:dirt"
		and minetest.get_item_group(minetest.get_node(above).name, "water") > 0 
		and minetest.get_node(above2).name == "air" then	
			minetest.set_node(under, {name="frontier_plants:planted_cattail", param2 = 16})
			itemstack:take_item(1)
			return itemstack
		end
	end
})

minetest.register_craftitem("frontier_plants:cattail_tuber_roasted", {
	description = "Roasted Cattail Tuber",
	inventory_image = "frontier_plants_cattail_tuber_roasted.png",
	wield_image = "frontier_plants_cattail_tuber_roasted.png",
	on_use = minetest.item_eat(4)
})

minetest.register_craft({
	type = "cooking",
	output = "frontier_plants:cattail_tuber_roasted",
	recipe = "frontier_plants:cattail_tuber",
	cooktime = 2
})

minetest.register_node("frontier_plants:planted_cattail", {
	description = "Planted Cattail",
	drawtype = "plantlike_rooted",
	waving = 1,
	tiles = {"default_dirt.png"},
	special_tiles = {{name = "frontier_plants_planted_cattail.png", tileable_vertical= true}},
	visual_scale = 2,
	paramtype = "light",
	paramtype2 = "leveled",
	groups = {crumbly = 3, not_in_creative_inventory=1},
	drop = "default:dirt",
	node_placement_prediction = "",
	node_dig_prediction = "default:dirt",
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.75, 0.5},
		},
	},
	sounds = default.node_sound_sand_defaults({
		dig = {name = "default_dig_snappy", gain = 0.2},
		dug = {name = "default_grass_footstep", gain = 0.25},
	}),
	on_construct = function(pos)
		minetest.get_node_timer(pos):set(math.random(600, 1500), 0)
	end,
	on_timer = function(pos)
		local ll = minetest.get_node_light(pos)
		if ll > 4 then
			minetest.set_node(pos, {name="frontier_plants:dirt_with_cattail", param2 = 16})
		else
			minetest.get_node_timer(pos):set(math.random(300, 600), 0)
		end
	end,
})

minetest.register_node("frontier_plants:dirt_with_cattail", {
	description = "Cattail",
	drawtype = "plantlike_rooted",
	waving = 1,
	tiles = {"default_dirt.png"},
	special_tiles = {{name = "frontier_plants_cattail.png", tileable_vertical= true}},
	visual_scale = 2,
	inventory_image = "frontier_plants_cattail.png",
	paramtype = "light",
	paramtype2 = "leveled",
	groups = {crumbly = 3},
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 1.75, 0.5},
		},
	},
	node_dig_prediction = "default:dirt",
	node_placement_prediction = "",
	drop = {
		max_items = 2,
		items = {
			{items = {"frontier_plants:cattail_tuber 2"}, rarity = 3},
			{items = {"frontier_plants:cattail_tuber"}, rarity = 2},
		}
	},
	after_dig_node = function(pos)
		minetest.set_node(pos, {name = "default:dirt"})
	end,
	sounds = default.node_sound_sand_defaults({
		dig = {name = "default_dig_snappy", gain = 0.2},
		dug = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_decoration({
	name = "frontier_plants:dirt_with_cattail",
	deco_type = "simple",
	place_on = {"default:dirt"},
	sidelen = 16,
	noise_params = {
		offset = 0.1,
		scale = 0.3,
		spread = {x = 200, y = 200, z = 200},
		seed = 84,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"swamp"},
	y_max = 1,
	y_min = 0,
	decoration = "frontier_plants:dirt_with_cattail",
	param2_max = 16,
	param2 = 16,
	place_offset_y = -1,
	flags = "force_placement",
})
