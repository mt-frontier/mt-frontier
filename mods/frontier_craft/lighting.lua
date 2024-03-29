minetest.register_node("frontier_craft:candle", {
	description = "Candle",
	drawtype = "plantlike",
	inventory_image = "frontier_craft_candle_inv.png",
	wield_image = "frontier_craft_candle_inv.png",
	tiles = {{
		    name = "frontier_craft_candle.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-3/16, -1/2, -3/16, 3/16, 1/4, 3/16}
	},
	paramtype = "light",
	light_source = 11,
	sounds = default.node_sound_wood_defaults(),
	groups = {snappy = 3, oddly_breakable_by_hand = 3, attached_node = 1},
})

minetest.register_craft({
	output = "frontier_craft:candle 3",
	recipe = {
		{"farming:string", "farming:string", "farming:string"},
		{"mobs:beeswax", "mobs:beeswax", "mobs:beeswax"},
		{"", "default:steel_ingot", ""},
	}
})

minetest.register_node("frontier_craft:lantern", {
	description = "Lantern",
	drawtype = "plantlike",
	inventory_image = "frontier_craft_lantern_inv.png",
	wield_image = "frontier_craft_lantern_inv.png",
	tiles = {{
		    name = "frontier_craft_lantern.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-3/16, -1/2, -3/16, 3/16, 1/2, 3/16}
	},
	sounds = default.node_sound_glass_defaults(),
	paramtype = "light",
	paramtype2 = "wallmounted",
	light_source = 13,
	groups = {snappy = 3, cracky = 3, oddly_breakable_by_hand = 3, attached_node = 1},
})

minetest.register_craft({
	output = "frontier_craft:lantern",
	recipe = {
		{"vessels:glass_jar"},
		{"frontier_craft:candle"}
	}
})
