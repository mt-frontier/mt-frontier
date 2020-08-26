--nodes

minetest.register_node("frontier_trees:maple_tree", {
	description = "Maple Tree",
	tiles = {
		"frontier_trees_maple_tree_top.png", "frontier_trees_maple_tree_top.png", 
		"frontier_trees_maple_tree.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local dir = {x = 1, y = 0, z = 1}
		local pos1 = vector.subtract(pos, dir)
		local pos2 = vector.add(pos, dir)
		local buckets = minetest.find_nodes_in_area(pos1, pos2, {"group:bucket"})
		for _, pos in ipairs(buckets) do
			minetest.dig_node(pos)
		end
	end
})

minetest.register_node("frontier_trees:maple_leaves", {
	description = "Maple Tree Leaves",
	drawtype = "allfaces",
	waving = 1,
	tiles = {"frontier_trees_maple_leaves.png"},
	special_tiles = {"frontier_trees_maple_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, eeafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'frontier_trees:maple_sapling'}, rarity = 20},
			{items = {'frontier_trees:maple_leaves'},}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,

})

minetest.register_node("frontier_trees:maple_wood", {
	description = "Maple Wood Planks",
	tiles = {"frontier_trees_maple_wood.png"},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

frontier_trees.register_stairs("maple")

frontier_trees.register_fence("maple", "Maple")

-- Generate Schematic

local gen_maple_tree = function ()
	local schem = {}
	schem.size = {x = 5, y = 10, z = 5}
	schem.yslice_prob = {}
	schem.yslice_prob[1] = {}
	schem.yslice_prob[1].ypos = 2 
	schem.yslice_prob[1].prob = 0.75 * 255
	schem.data = {}
	local ignore = {name = "ignore"}
	local tree = {name = "frontier_trees:maple_tree", force_place = true}
	local leaves = {name = "frontier_trees:maple_leaves", param1 = 255}
	local edge_leaves = {name = "frontier_trees:maple_leaves", param1 = 190}
	local corner_leaves = {name = "frontier_trees:maple_leaves", param1 = 130}

	for z = 1, schem.size.z do
		for y = 1, schem.size.y do
			for x = 1, schem.size.x do
			--	leaves.param1 = 255
				if y < 9 and x == math.ceil(1/2*schem.size.x) and z == math.ceil(1/2*schem.size.z) then
					table.insert(schem.data, tree) 
				elseif y == 10 then
					if x == 3 and z == 3 then
						table.insert(schem.data, leaves)
					else
						table.insert(schem.data, ignore)
					end
				elseif y == 9 or y == 4 then
					if x == 1 or x == 5 or z == 1 or z == 5 then
						table.insert(schem.data, ignore)
					else
						table.insert(schem.data, edge_leaves)
					end
				elseif y == 8 then
					if (x == 1 and z == 1) or (x == 5 and z == 5) or (x == 1 and z == 5) or (x == 5 and z ==1) then
						table.insert(schem.data, ignore)
					else
						table.insert(schem.data, leaves)	
					end
				elseif y < 8 and y > 4 then
					if(x == 1 and z == 1) or (x == 5 and z == 1) or (x == 1 and z == 5) or (x == 5 and z == 5) then
						table.insert(schem.data, corner_leaves)
					elseif x == 1 or x == 5 or z == 1 or z == 5 then
						table.insert(schem.data, edge_leaves)
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

local maple_tree_schematic = gen_maple_tree()
local maple_log_schematic = {
	size = {x = 3, y =1, z = 1},
	data = {
		{name = "frontier_trees:maple_tree", param1=255, param2 = 48},
		{name = "frontier_trees:maple_tree", param1=255, param2 = 48, force_place = true},
		{name = "frontier_trees:maple_tree", param1=255, param2 = 48},
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
	schematic = maple_log_schematic,
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
		seed = 414,
		octaves = 3,
		persists = 0.6,
	},
	biomes = {"deciduous_forest"},
	schematic = maple_tree_schematic,
	flags = "place_center_x, place_center_z",
})

minetest.register_node("frontier_trees:maple_sapling", {
	description = "Maple Tree Sapling",
	drawtype = "plantlike",
	tiles = {"frontier_trees_maple_sapling.png"},
	inventory_image = "frontier_trees_maple_sapling.png",
	wield_image = "frontier_trees_maple_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = function(pos, elapsed)
		if not default.can_grow(pos) then
			return minetest:get_node_timer(pos):start(120)
		end
		pos.y = pos.y - 1
		minetest.place_schematic(pos, maple_tree_schematic, "random", nil, false, "place_center_x, place_center_z")
	end,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,
})

minetest.register_node("frontier_trees:syrup_bucket_empty", {
	description = "Empty Syrup Bucket",
	drawtype = "plantlike",
	tiles = {"bucket.png"},
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {
			{-3/8, -3/8, -3/8, 3/8, 3/8, 3/8}
		}
	},
	groups = {bucket = 1, dig_immediate = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	drop = "bucket:bucket_empty",
	paramtype2 = "wallmounted",
	on_place = minetest.rotate_and_place,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name = "frontier_trees:syrup_bucket_full"})
	end,
})

minetest.register_node("frontier_trees:syrup_bucket_full", {
	description = "Full Syrup Bucket",
	drawtype = "plantlike",
	tiles = {"syrup_bucket.png"},
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {
			{-3/8, -3/8, -3/8, 3/8, 3/8, 3/8}
		}
	},
	groups = {bucket = 1, dig_immediate = 3, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
	drop = "frontier_trees:syrup_bucket"
})

minetest.register_craftitem("frontier_trees:syrup_bucket", {
	description = "Syrup Bucket",
	inventory_image = "syrup_bucket.png",
	on_use = minetest.item_eat(4, "bucket:bucket_empty")
})

minetest.override_item("bucket:bucket_empty", {
	on_place = function(itemstack, placer, pointed_thing)
		if minetest.get_node(pointed_thing.under).name ~= "frontier_trees:maple_tree" then
			return
		end
		local nn = "frontier_trees:syrup_bucket_empty"
		local pos = pointed_thing.above
		minetest.set_node(pos, {name=nn})	
		itemstack:take_item(1)
		return itemstack
	end
})

default.register_leafdecay({
	trunks = {"frontier_trees:maple_tree"},
	leaves = {"frontier_trees:maple_leaves"},
	radius = 2,
})

-- Crafts
minetest.register_craft({
	type = "shapeless",
	output = "frontier_trees:maple_wood 4",
	recipe = {"frontier_trees:maple_tree"}
})

-- Write data output of gen_maple_tree to file for debugging
local function read_schema(schema) 
	local schema_readable = {}
	for i, v in ipairs(schema.data) do
		table.insert(schema_readable, minetest.serialize(v))
	end

	local schema_file = io.open(minetest.get_worldpath().."/maple_tree_schema.txt", "w")
	schema_file:write(minetest.serialize(schema_readable))
	schema_file:flush()
	schema_file:close()
end

--read_schema(maple_tree_schematic)

