-- Nodes

minetest.register_node("frontier_trees:mesquite_tree", {
	description = "Mesquite Tree",
	tiles = {
		"frontier_trees_mesquite_tree_top.png", "frontier_trees_mesquite_tree_top.png", 
		"frontier_trees_mesquite_tree.png"
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
		local blossoms = minetest.find_nodes_in_area(pos1, pos2, {"frontier_trees:mesquite_blossom"})
		for _, pos in ipairs(blossoms) do
			minetest.dig_node(pos)
		end
	end
})

minetest.register_node("frontier_trees:mesquite_leaves", {
	description = "Mesquite Tree Leaves",
	drawtype = "allfaces",
	waving = 1,
	tiles = {"frontier_trees_mesquite_leaves.png"},
	special_tiles = {"frontier_trees_mesquite_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'frontier_trees:mesquite_sapling'}, rarity = 20},
			{items = {'frontier_trees:mesquite_leaves'},}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

minetest.register_node("frontier_trees:mesquite_pods", {
	description = "Mesquite Pods",
	drawtype = "plantlike",
	tiles = {"frontier_trees_mesquite_pods.png"},
	inventory_image = "frontier_trees_mesquite_pods.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
	--	fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
		fixed = {-3/8, 0.5, -3/8, 3/8, -1/4, 3/8}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_mesquite = 1},
	on_use = minetest.item_eat(2),
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local above = pos
		above.y = above.y + 1
		if minetest.get_node(above).name == "frontier_trees:mesquite_leaves" then
			minetest.place_node(pos, {name = "frontier_trees:mesquite_blossoms"})
		end
	end,
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("frontier_trees:mesquite_blossoms", {
	description = "Mesquite Blossoms",
	drawtype = "plantlike",
	tiles = {"frontier_trees_mesquite_blossoms.png"},
	inventory_image = "frontier_trees_mesquite_blossoms.png",
	prarmtype = "light",
	sunlight_propogates = true,
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3/8, 0.5, -3/8, 3/8, -1/4, 3/8}
	},
	groups = {snappy = 3, flammable = 2, dig_immediate = 2},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, oldnode, oldmeta, drops)
		local timeout = math.random(600, 1200)
		minetest.get_node_timer(pos):set(timeout, 0)
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name = "frontier_trees:mesquite_pods"})
	end,
})

minetest.register_node("frontier_trees:mesquite_wood", {
	description = "Mesquite Wood Planks",
	tiles = {"frontier_trees_mesquite_wood.png"},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

frontier_trees.register_stairs("mesquite")

frontier_trees.register_fence("mesquite", "Mesquite")

default.register_leafdecay({
	trunks = {"frontier_trees:mesquite_tree"},
	leaves = {"frontier_trees:mesquite_leaves", "frontier_trees:mesquite_pods"},
	radius = 2,
})
-- Generate Schematic

local gen_mesquite_tree = function ()
	local schem = {}
	schem.size = {x = 5, y = 7, z = 5}
	schem.yslice_prob = {}
	schem.yslice_prob[1] = {}
	schem.yslice_prob[1].ypos = 2 
	schem.yslice_prob[1].prob = 0.75 * 255
	schem.data = {}
	local ignore = {name = "ignore"}
	local tree = {name = "frontier_trees:mesquite_tree", force_place = true}
	local leaves = {name = "frontier_trees:mesquite_leaves", param1 = 255}
	local edge_leaves = {name = "frontier_trees:mesquite_leaves", param1 = 190}
	local corner_leaves = {name = "frontier_trees:mesquite_leaves", param1 = 130}
	local mesquite = {name = "frontier_trees:mesquite_pods", param1 = 90}

	for z = 1, schem.size.z do
		for y = 1, schem.size.y do
			for x = 1, schem.size.x do
			--	leaves.param1 = 255
				if y == 7 then
					if x == 1 or x == 5 or z == 1 or z == 5 then
						table.insert(schem.data, ignore)
					else
						table.insert(schem.data, edge_leaves)
					end
				elseif x == math.ceil(1/2*schem.size.x) and z == math.ceil(1/2*schem.size.z) then
					table.insert(schem.data, tree) 
				elseif y == 6 then
					if(x == 1 and z == 1) or (x == 5 and z == 1) or (x == 1 and z == 5) or (x == 5 and z == 5) then
						table.insert(schem.data, corner_leaves)
					else
						table.insert(schem.data, leaves)	
					end
				elseif y < 6 and y > 3 then
					if(x == 1 and z == 1) or (x == 5 and z == 1) or (x == 1 and z == 5) or (x == 5 and z == 5) then
						table.insert(schem.data, corner_leaves)
					elseif x == 1 or x == 5 or z == 1 or z == 5 then
						if math.random() < 0.14 then
							table.insert(schem.data, mesquite)
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

local mesquite_tree_schematic = gen_mesquite_tree()
local mesquite_log_schematic = {
	size = {x = 3, y =1, z = 1},
	data = {
		{name = "frontier_trees:mesquite_tree", param1=255, param2 = 48},
		{name = "frontier_trees:mesquite_tree", param1=255, param2 = 48, force_place = true},
		{name = "frontier_trees:mesquite_tree", param1=255, param2 = 48},
	}
}

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_dry_grass"},
	sidelen = 16,
	--fill_ratio = 0.01,
	noise_params = {
		offset = -0.02,
		scale = 0.025,
		spread = {x = 40, y = 40, z = 40},
		seed = 31,
		octaves = 3,
		persist = 0.6
	},
	y_min = 1,
	y_max = 1000,
	rotation = "random",
	place_offset_y = 1,
	biomes = {"savanna, savanna_shore"},
	schematic = mesquite_log_schematic,
	flags = "place_center_x, place_center_z",
})
minetest.register_decoration({
	deco_type = "schematic",
	place_on = "default:dirt_with_dry_grass",
	sidelen = 16,
	--fill_ratio = 0.001,
	noise_params = {
		offset = -0.01,
		scale = -0.015,
		spread = {x = 250, y = 250, z = 250},
		seed = 29,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"savanna", "savanna_shore"},
	schematic = mesquite_tree_schematic,
	flags = "place_center_x, place_center_z",
})

minetest.register_node("frontier_trees:mesquite_sapling", {
	description = "Mesquite Tree Sapling",
	drawtype = "plantlike",
	tiles = {"frontier_trees_mesquite_sapling.png"},
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
		minetest.place_schematic(pos, mesquite_tree_schematic, "random", nil, false, "place_center_x, place_center_z")
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
minetest.register_craft({
	type = "shapeless",
	output = "frontier_trees:mesquite_wood 4",
	recipe = {"frontier_trees:mesquite_tree"}
})

-- Write data output of gen_mesquite_tree to file for debugging
local function read_schema(schema) 
	local schema_readable = {}
	for i, v in ipairs(schema.data) do
		table.insert(schema_readable, minetest.serialize(v))
	end

	local schema_file = io.open(minetest.get_worldpath().."/mesquite_tree_schema.txt", "w")
	schema_file:write(minetest.serialize(schema_readable))
	schema_file:flush()
	schema_file:close()
end

--read_schema(mesquite_tree_schematic)

