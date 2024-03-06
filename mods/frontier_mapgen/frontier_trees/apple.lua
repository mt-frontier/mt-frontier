--nodes

minetest.register_node("frontier_trees:apple_tree", {
	description = "Apple Tree",
	tiles = {
		"frontier_trees_apple_tree_top.png", "frontier_trees_apple_tree_top.png", 
		"frontier_trees_apple_tree.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local dir = {x = 2, y = 1, z = 2}
		local pos1 = vector.subtract(pos, dir)
		local pos2 = vector.add(pos, dir)
		local blossoms = minetest.find_nodes_in_area(pos1, pos2, {"frontier_trees:apple_blossom"})
		for _, pos in ipairs(blossoms) do
			minetest.dig_node(pos)
		end
	end
})

minetest.register_node("frontier_trees:apple_leaves", {
	description = "Apple Tree Leaves",
	drawtype = "allfaces",
	waving = 1,
	tiles = {"frontier_trees_apple_leaves.png"},
	special_tiles = {"frontier_trees_apple_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'frontier_trees:apple_tree_sapling'}, rarity = 20},
			{items = {'frontier_trees:apple_leaves'},}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

minetest.register_node("frontier_trees:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"frontier_trees_apple.png"},
	inventory_image = "frontier_trees_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2, leafdecay = 3, leafdecay_drop = 1, food_apple = 1},
	on_use = minetest.item_eat(2),
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local above = table.copy(pos)
		above.y = above.y + 1
		if minetest.get_node(above).name == "frontier_trees:apple_leaves" then
			minetest.set_node(pos, {name = "frontier_trees:apple_blossom"})
		end
	end,
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("frontier_trees:apple_blossom", {
	description = "Apple Blossom",
	drawtype = "plantlike",
	tiles = {"frontier_trees_apple_blossom.png"},
	inventory_image = "frontier_trees_apple_blossom.png",
	paramtype = "light",
	sunlight_propogates = true,
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, 0.5, -0.5, 0.5, 0, 0.5}
	},
	groups = {snappy = 3, fleshy = 3, flammable = 2, leafdecay = 3, dig_immediate = 2, leaves=1},
	sounds = default.node_sound_leaves_defaults(),
	on_construct = function(pos)
		local timeout = math.random(1200, 3600)
		minetest.get_node_timer(pos):set(timeout, 0)
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name = "frontier_trees:apple"})
	end
})

minetest.register_node("frontier_trees:apple_wood", {
	description = "Apple Wood Planks",
	tiles = {"frontier_trees_apple_wood.png"},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

frontier_trees.register_stairs("apple")
frontier_trees.register_fence("apple", "Apple")

-- stairs.register_stairs("apple_wood", "Apple Wood", {"frontier_trees_apple_wood.png"}, 
-- 	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
-- 	default.node_sound_wood_defaults()
-- )

default.register_leafdecay({
	trunks = {"frontier_trees:apple_tree"},
	leaves = {"frontier_trees:apple_leaves", "frontier_trees:apple", "frontier_trees:apple_blossom"},
	radius = 2,
})
-- Generate Schematic

local gen_apple_tree = function ()
	local schem = {}
	schem.size = {x = 5, y = 8, z = 5}
	schem.yslice_prob = {}
	schem.yslice_prob[1] = {}
	schem.yslice_prob[1].ypos = 2 
	schem.yslice_prob[1].prob = 0.75 * 255
	schem.data = {}
	local ignore = {name = "ignore"}
	local tree = {name = "frontier_trees:apple_tree", force_place = true}
	local leaves = {name = "frontier_trees:apple_leaves", param1 = 255}
	local edge_leaves = {name = "frontier_trees:apple_leaves", param1 = 190}
	local corner_leaves = {name = "frontier_trees:apple_leaves", param1 = 130}
	local apple = {name = "frontier_trees:apple", param1 = 110}

	for z = 1, schem.size.z do
		for y = 1, schem.size.y do
			for x = 1, schem.size.x do
			--	leaves.param1 = 255
				if y == 8 then
					if x == 1 or x == 5 or z == 1 or z == 5 then
						table.insert(schem.data, ignore)
					else
						table.insert(schem.data, edge_leaves)
					end
				elseif x == math.ceil(1/2*schem.size.x) and z == math.ceil(1/2*schem.size.z) then
					table.insert(schem.data, tree) 
				elseif y == 7 then
					if(x == 1 and z == 1) or (x == 5 and z == 1) or (x == 1 and z == 5) or (x == 5 and z == 5) then
						table.insert(schem.data, corner_leaves)
					else
						table.insert(schem.data, leaves)	
					end
				elseif y < 7 and y > 3 then
					if(x == 1 and z == 1) or (x == 5 and z == 1) or (x == 1 and z == 5) or (x == 5 and z == 5) then
						table.insert(schem.data, corner_leaves)
					elseif x == 1 or x == 5 or z == 1 or z == 5 then
						if math.random() < 0.2 then
							table.insert(schem.data, apple)
						else
							table.insert(schem.data, edge_leaves)
						end
					else
						table.insert(schem.data, leaves)
					end
				else
					table.insert(schem.data, ignore)
				end
			end
		end
	end
	return schem
end

local apple_tree_schematic = gen_apple_tree()
local apple_tree_log_schematic = { 
	size = {x = 3, y =1, z = 1},
	data = {
		{name = "frontier_trees:apple_tree", param1=255, param2 = 48},
		{name = "frontier_trees:apple_tree", param1=255, param2 = 48, force_place = true},
		{name = "frontier_trees:apple_tree", param1=255, param2 = 48},
	}
}

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"group:soil"},
	sidelen = 8,
	fill_ratio = 0.0003,
	y_min = 1,
	y_max = 1000,
	rotation = "random",
	place_offset_y = 1,
	biomes = {"deciduous_forest"},
	schematic = apple_tree_log_schematic,
	flags = "place_center_x, place_center_z",
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = "group:soil",
	sidelen = 8,
	fill_ratio = 0.001,
	biomes = {"deciduous_forest"},
	schematic = apple_tree_schematic,
	flags = "place_center_x, place_center_z",
})

minetest.register_node("frontier_trees:apple_tree_sapling", {
	description = "Apple Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = function(pos, elapsed)
		if not default.can_grow(pos) then
			return minetest:get_node_timer(pos):start(300)
		end
		pos.y = pos.y - 1
		minetest.place_schematic(pos, apple_tree_schematic, "random", nil, false, "place_center_x, place_center_z")
	end,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 500))
	end,

	--[[on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -3, y = 1, z = -3},
			{x = 3, y = 6, z = 3},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,]]--
})

-- Crafts
-- minetest.register_craft({
-- 	type = "shapeless",
-- 	output = "frontier_trees:apple_wood 4",
-- 	recipe = {"frontier_trees:apple_tree"}
-- })

-- Write data output of gen_apple_tree to file for debugging
local function read_schema(schema) 
	local schema_readable = {}
	for i, v in ipairs(schema.data) do
		table.insert(schema_readable, minetest.serialize(v))
	end

	local schema_file = io.open(minetest.get_worldpath().."/apple_tree_schema.txt", "w")
	schema_file:write(minetest.serialize(schema_readable))
	schema_file:flush()
	schema_file:close()
end

--read_schema(apple_tree_schematic)

