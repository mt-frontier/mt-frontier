minetest.register_node("frontier_trees:holly_leaves", {
	description = "Holly Leaves",
	drawtype = "allfaces_optional",
	tiles = {"frontier_trees_holly_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 1, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"frontier_trees:holly_sapling"}, rarity = 20},
			{items = {"frontier_trees:holly_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("frontier_trees:holly_stem", {
	description = "Holly Stem",
	drawtype = "plantlike",
	tiles = {"frontier_trees_holly_stem.png"},
	visual_scale = 1.2,
	inventory_image = "frontier_trees_holly_stem.png",
	wield_image = "frontier_trees_holly_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
	drop = {
		max_items = 1,
		items = {
			{rarity = 4, items = {"default:stick 4"}},
			{rarity = 1, items = {"default:stick 3"}},
		}
	}
})

minetest.register_node("frontier_trees:holly_wreath", {
	description = "Holly Wreath",
	drawtype = "signlike",
	tiles = {"frontier_trees_holly_wreath.png"},
	inventory_image = "frontier_trees_holly_wreath.png",
	wield_image = "frontier_trees_holly_wreath.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	groups = {snappy = 3, dig_immediate = 3,},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -7/16, 1/2},
	}
})

minetest.register_craft({
	output = "frontier_trees:holly_wreath",
	recipe = {
		{"", "frontier_trees:holly_leaves", ""},
		{"frontier_trees:holly_leaves", "", "frontier_trees:holly_leaves",},
		{"", "frontier_trees:holly_leaves", ""},
	},
})
default.register_leafdecay({
	trunks = {"frontier_trees:holly_stem"},
	leaves = {"frontier_trees:holly_leaves"},
	radius = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "frontier_trees:holly_stem",
	burntime = 5
})

minetest.register_craft({
	output = "default:stick 4",
	recipe = {{"frontier_trees:holly_stem"}},
})

local function gen_holly_schematic()
	local schem = {}
	schem.size = {x = 3, y = 2, z = 3}
	schem.data = {}
	local leaves = {name = "frontier_trees:holly_leaves", param1 = 255}
	local stem = {name = "frontier_trees:holly_stem", param1 = 255, force_place = true}
	local chance_leaves = {name = "frontier_trees:holly_leaves", param1 = 190}
	for z = 1, 3 do
		for y = 1, 2 do
			for x = 1, 3 do
				if x == 2 and z == 2 then
					if y == 1 then
						table.insert(schem.data, stem)
					elseif y == 2 then
						table.insert(schem.data, leaves)
					end
				else
					table.insert(schem.data, chance_leaves)
				end
			end
		end
	end
	return schem
end
local holly_bush_schematic = gen_holly_schematic()

minetest.register_node("frontier_trees:holly_sapling", {
	description = "Holly Sapling",
	drawtype = "plantlike",
	tiles = {"frontier_trees_holly_sapling.png"},
	inventory_image = "frontier_trees_holly_sapling.png",
	paramtype = "light",
	groups = {sapling = 1, flammable = 1, snappy = 3, oddly_breakable_by_hand = 1},
	on_construct = function(pos)
		minetest.get_node_timer(pos):set(math.random(300, 500), 0)
	end,
	on_timer = function(pos, elapsed)
		if not default.can_grow(pos) then
			return minetest:get_node_timer(pos):start(300)
		end
		minetest.place_schematic(pos, holly_bush_schematic, "random", nil, nil, "place_center_x, place_center_z")
	end,
})

minetest.register_decoration({
	name = "frontier_trees:holly_bush",
	deco_type = "schematic",
	place_on = {"default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 139,
			octaves = 3,
			persist = 0.7,
		},
		place_offset_y = 1,
		biomes = {"pine_savanna"},
		y_max = 40,
		y_min = 1,
	schematic = holly_bush_schematic,
	flags = "place_center_x, place_center_z",
})


