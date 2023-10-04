--nodes

minetest.register_node("frontier_trees:poplar_tree", {
	description = "Poplar Tree",
	tiles = {
		"frontier_trees_poplar_tree_top.png", "frontier_trees_poplar_tree_top.png", 
		"frontier_trees_poplar_tree.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
})

minetest.register_node("frontier_trees:poplar_leaves", {
		description = "Poplar Tree Leaves",
	drawtype = "allfaces",
	waving = 1,
	tiles = {"frontier_trees_poplar_leaves.png"},
	special_tiles = {"frontier_trees_poplar_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'frontier_trees:poplar_sapling'}, rarity = 20},
			{items = {'frontier_trees:poplar_leaves'},}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,

})

minetest.register_node("frontier_trees:poplar_wood", {
	description = "Poplar Wood Planks",
	tiles = {"frontier_trees_poplar_wood.png"},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

frontier_trees.register_stairs("poplar")
frontier_trees.register_fence("poplar", "Poplar")
-- Generate Schematic

local gen_poplar_tree = function ()
	local schem = {}
	schem.size = {x = 5, y = 11, z = 5}
	schem.yslice_prob = {}
	schem.yslice_prob[1] = {}
	schem.yslice_prob[1].ypos = 2 
	schem.yslice_prob[1].prob = 0.75 * 255
	schem.data = {}
	local ignore = {name = "ignore"}
	local tree = {name = "frontier_trees:poplar_tree", force_place = true}
	local leaves = {name = "frontier_trees:poplar_leaves", param1 = 255}
	local edge_leaves = {name = "frontier_trees:poplar_leaves", param1 = 230}
	local corner_leaves = {name = "frontier_trees:poplar_leaves", param1 = 130}

	for z = 1, schem.size.z do
		for y = 1, schem.size.y do
			for x = 1, schem.size.x do
			--	leaves.param1 = 255
				if y < 10 and x == math.ceil(1/2*schem.size.x) and z == math.ceil(1/2*schem.size.z) then
					table.insert(schem.data, tree)
				elseif y == 11 then
					if x == 3 and z == 3 then
						table.insert(schem.data, leaves)
					else
						table.insert(schem.data, ignore)
					end
				elseif y == 10 then
					if x == 3 and z == 3 then
						table.insert(schem.data, leaves)
					elseif x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, edge_leaves)
					else
						table.insert(schem.data, ignore)
					end
				elseif y == 7 then
					if (x == 2 and z == 3) or (x == 4 and z == 3) 
					or (x == 3 and z == 2) or (x == 3 and z == 4)  then
						table.insert(schem.data, edge_leaves)
					else
						table.insert(schem.data, ignore)
					end
				elseif y == 8 then
					if x == 1 or x == 5 or z == 1 or z == 5 then
						table.insert(schem.data, edge_leaves)
					else
						table.insert(schem.data, leaves)
					end
				elseif y == 9 or y == 6 or y == 5 then
					if (x == 1 and z == 1) or (x == 5 and z == 5) or (x == 1 and z == 5) or (x == 5 and z ==1) then
						table.insert(schem.data, ignore)
					elseif y == 6 then 
						if x == 3 or z == 3 then
							table.insert(schem.data, edge_leaves)	
						elseif (x == 2 and z == 2) or (x == 2 and z == 4)
						or (x == 4 and z == 2) or (x == 4 and z == 4) then
							table.insert(schem.data, ignore)
						else
							table.insert(schem.data, edge_leaves)
						end
					else
						table.insert(schem.data, edge_leaves)
					end
				else
					table.insert(schem.data, ignore)
				end
			end
		end
	end
	return schem
end

local poplar_tree_schematic = gen_poplar_tree()
local poplar_log_schematic = {
	size = {x = 3, y =1, z = 1},
	data = {
		{name = "frontier_trees:poplar_tree", param1=255, param2 = 48},
		{name = "frontier_trees:poplar_tree", param1=255, param2 = 48, force_place = true},
		{name = "frontier_trees:poplar_tree", param1=255, param2 = 48},
	}
}


minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.1,
		scale = 0.025,
		spread = {x = 200, y = 200, z = 200},
		seed = 411,
		octaves = 3,
		persists = 0.6,
	},
	y_min = 1,
	y_max = 1000,
	rotation = "random",
	place_offset_y = 1,
	biomes = {"deciduous_forest"},
	schematic = poplar_log_schematic,
	flags = "place_center_x, place_center_z",
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = "default:dirt_with_grass",
	sidelen = 8,
	--fill_ratio = 0.004,
	sidelen = 16,
	noise_params = {
		offset = -0.01,
		scale = 0.025,
		spread = {x = 200, y = 200, z = 200},
		seed = 531,
		octaves = 3,
		persists = 0.6,
	},
	y_min = 11,
	biomes = {"deciduous_forest", "deciduous_highland"},
	schematic = poplar_tree_schematic,
	flags = "place_center_x, place_center_z",
})

minetest.register_node("frontier_trees:poplar_sapling", {
	description = "Poplar Tree Sapling",
	drawtype = "plantlike",
	tiles = {"frontier_trees_poplar_sapling.png"},
	inventory_image = "frontier_trees_poplar_sapling.png",
	wield_image = "frontier_trees_poplar_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = function(pos, elapsed)
		if not default.can_grow(pos) then
			return minetest:get_node_timer(pos):start(300)
		end
		pos.y = pos.y - 1
		minetest.place_schematic(pos, poplar_tree_schematic, "random", nil, false, "place_center_x, place_center_z")
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
})

default.register_leafdecay({
	trunks = {"frontier_trees:poplar_tree"},
	leaves = {"frontier_trees:poplar_leaves"},
	radius = 2,
})

-- Crafts
minetest.register_craft({
	type = "shapeless",
	output = "frontier_trees:poplar_wood 4",
	recipe = {"frontier_trees:poplar_tree"}
})

-- Write data output of gen_poplar_tree to file for debugging
local function read_schema(schema) 
	local schema_readable = {}
	for i, v in ipairs(schema.data) do
		table.insert(schema_readable, minetest.serialize(v))
	end

	local schema_file = io.open(minetest.get_worldpath().."/poplar_tree_schema.txt", "w")
	schema_file:write(minetest.serialize(schema_readable))
	schema_file:flush()
	schema_file:close()
end

--read_schema(poplar_tree_schematic)


