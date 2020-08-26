minetest.register_node("frontier_trees:laurel_leaves", {
	description = "Laurel Leaves",
	drawtype = "allfaces_optional",
	tiles = {"frontier_trees_laurel_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 1, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"frontier_trees:laurel_sapling"}, rarity = 20},
			{items = {"frontier_trees:laurel_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("frontier_trees:laurel_stem", {
	description = "Laurel Stem",
	drawtype = "plantlike",
	tiles = {"frontier_trees_laurel_stem.png"},
	visual_scale = 1.2,
	inventory_image = "frontier_trees_laurel_stem.png",
	wield_image = "frontier_trees_laurel_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
})

default.register_leafdecay({
	trunks = {"frontier_trees:laurel_stem"},
	leaves = {"frontier_trees:laurel_leaves"},
	radius = 2.5,
})

local function gen_laurel_schematic()
	local schem = {}
	schem.size = {x = 3, y = 4, z = 3}
	schem.data = {}
	local leaves = {name = "frontier_trees:laurel_leaves", param1 = 255}
	local stem = {name = "frontier_trees:laurel_stem", param1 = 255, force_place = true}
	local mid_chance_leaves = {name = "frontier_trees:laurel_leaves", param1 = 190}
	local ignore = {name = "ignore"}
	for z = 1, schem.size.z do
		for y = 1, schem.size.y  do
			for x = 1, schem.size.x do
				if x == 2 and z == 2 then
					if y == 1 then
						table.insert(schem.data, stem)
					else
						table.insert(schem.data, leaves)
					end
				elseif y == 2 then
					if (x == 1 and z == 1) or (x == 3 and z == 3) then
						table.insert(schem.data, ignore)
					else
						table.insert(schem.data, mid_chance_leaves)
					end
				elseif y == 3 then
					if x <= 2 and z <= 2 then
						table.insert(schem.data, mid_chance_leaves)
					elseif x == 2 or z == 2 then
						table.insert(schem.data, leaves)
					else
						table.insert(schem.data, ignore)
					end
				elseif y == 4 then
					if x == 1 or z == 1 then
						table.insert(schem.data, ignore)
					else
						table.insert(schem.data, mid_chance_leaves)
					end
				else
					table.insert(schem.data, ignore)
				end
			end
		end
	end
	return schem
end
local laurel_bush_schematic = gen_laurel_schematic()

minetest.register_node("frontier_trees:laurel_sapling", {
	description = "Laurel Sapling",
	drawtype = "plantlike",
	tiles = {"frontier_trees_laurel_sapling.png"},
	inventory_image = "frontier_trees_laurel_sapling.png",
	paramtype = "light",
	groups = {sapling = 1, flammable = 1, snappy = 3, oddly_breakable_by_hand = 1},
	on_construct = function(pos)
		minetest.get_node_timer(pos):set(math.random(300, 1500), 0)
	end,
	on_timer = function(pos, elapsed)
		if not default.can_grow(pos) then
			return minetest:get_node_timer(pos):start(120)
		end
		minetest.place_schematic(pos, laurel_bush_schematic, "random", nil, nil, "place_center_x, place_center_z")
	end,
})

minetest.register_decoration({
	name = "frontier_trees:laurel_bush",	
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass"},
		sidelen = 8,
		noise_params = {
			offset = 0.01,
			scale = 0.03,
			spread = {x = 100, y = 100, z = 100},
			seed = 409,
			octaves = 5,
			persist = 0.7,
		},
		place_offset_y = 1,
		biomes = {"deciduous_highland"},
		y_max = 300,
		y_min = 48,
	schematic = laurel_bush_schematic,
	flags = "place_center_x, place_center_z",
})

minetest.register_craft({
	output = "default:stick 4",
	recipe = {{"frontier_trees:laurel_stem"}},
})

minetest.register_craft({
	type = "fuel",
	recipe = "frontier_trees:laurel_stem",
	burntime = 6
})
