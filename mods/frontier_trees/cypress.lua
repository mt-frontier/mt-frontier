
----------
-- Nodes
----------
minetest.register_node("frontier_trees:cypress_tree", {
	description = "Cypress Tree",
	tiles = {
		"frontier_trees_cypress_tree_top.png", "frontier_trees_cypress_tree_top.png", 
		"frontier_trees_cypress_tree.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
})

minetest.register_node("frontier_trees:cypress_needles", {
		description = "Cypress Tree Leaves",
	drawtype = "allfaces",
	waving = 1,
	tiles = {"frontier_trees_cypress_needles.png"},
	special_tiles = {"frontier_trees_cypress_needles.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'frontier_trees:cypress_tree_sapling'}, rarity = 20},
			{items = {'frontier_trees:cypress_needles'},}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,

})

minetest.register_node("frontier_trees:cypress_tree_mossy", {
	description = "Mossy Log",
	tiles = {
		"frontier_trees_cypress_tree_top.png",
		"frontier_trees_cypress_tree_top.png",
		"frontier_trees_cypress_tree_mossy.png",
		"frontier_trees_cypress_tree_mossy.png",
		"frontier_trees_cypress_tree_mossy.png",
		"frontier_trees_cypress_tree_mossy.png",
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, crumbly = 2 },
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
	on_place = minetest.rotate_node,
})

minetest.register_craftitem("frontier_trees:moss_item", {
	description = "Moss",
	inventory_image = "frontier_trees_hanging_moss.png",
	wield_image = "frontier_trees_hanging_moss.png",
	on_use = minetest.item_eat(1)
})

minetest.register_node("frontier_trees:moss", {
	description = "Moss",
	drawtype = "plantlike",
	tiles = {"frontier_trees_hanging_moss.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
--	on_place = function(itemstack, placer, pointed_thing)
--		minetest.rotate_and_place(itemstack, placer, pointed_thing, false, {force_ceiling = true})
--	end,
	drop = "frontier_trees:moss_item", 
	sounds = default.node_sound_leaves_defaults(),
	groups = {snappy = 3, attached_node = 1},
})

minetest.register_node("frontier_trees:cypress_wood", {
	description = "Cypress Wood Planks",
	tiles = {"frontier_trees_cypress_wood.png"},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

frontier_trees.register_stairs("cypress")

frontier_trees.register_fence("cypress", "Cypress")

default.register_leafdecay({
	trunks = {"frontier_trees:cypress_tree"},
	leaves = {"frontier_trees:cypress_needles"},
	radius = 3,
})
-- Generate Schematic

local gen_cypress_tree = function ()
	local schem = {}

	local needle_indices = {}
	schem.size = {x = 5, y = 11, z = 5}
	schem.yslice_prob = {}
	schem.yslice_prob[1] = {}
	schem.yslice_prob[1].ypos = 3 
	schem.yslice_prob[1].prob = 0.75 * 255
	schem.data = {}
	local ignore = {name = "ignore"}
	local tree = {name = "frontier_trees:cypress_tree", force_place = true}
	local maybe_tree = {name = "frontier_trees:cypress_tree", param1 = 100}
	local needles = {name = "frontier_trees:cypress_needles", param1 = 255}
	local edge_needles = {name = "frontier_trees:cypress_needles", param1 = 190}
	local corner_needles = {name = "frontier_trees:cypress_needles", param1 = 100}
	local moss = {name = "frontier_trees:moss", param1 = 160}
	local index = 0	
	for z = 1, schem.size.z do
		for y = 1, schem.size.y do
			for x = 1, schem.size.x do
				index = index + 1
				if y < 9 and x == math.ceil(1/2*schem.size.x) and z == math.ceil(1/2*schem.size.z) then
					table.insert(schem.data, tree) 
				elseif y == 11 then
					if x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, edge_needles)
					else
						table.insert(schem.data, ignore)
					end
				elseif (y < 11 and y > 8) or (y < 7 and y > 4) then
					if (x == 1 and z == 1) or (x == 5 and z == 5) or (x == 1 and z == 5) or (x == 5 and z ==1) then
						table.insert(schem.data, corner_needles)
					else
						table.insert(schem.data, edge_needles)	
					end
				elseif y == 8 or y == 4 then
					if math.random() < 0.15 then
						table.insert(schem.data, moss)
						local index_above = index+ schem.size.z
						table.insert(needle_indices, index_above)
					else
						table.insert(schem.data, ignore)
					end
				elseif y == 1	
				and x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, tree)
				elseif y == 2  
				and x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, maybe_tree)
				else
					table.insert(schem.data, ignore)
				end
			end
		end
	end
	local num = #needle_indices
	for n, index in ipairs(needle_indices) do
		schem.data[index] = needles
	end
	return schem
end

local cypress_tree_schematic = gen_cypress_tree()
local cypress_log_schematic = {
	size = {x = 3, y =1, z = 1},
	data = {
		{name = "frontier_trees:cypress_tree_mossy", param1=255, param2 = 48},
		{name = "frontier_trees:cypress_tree_mossy", param1=255, param2 = 48, force_place = true},
		{name = "frontier_trees:cypress_tree_mossy", param1=255, param2 = 48}
	}
}

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt", "default:dirt_with_rainforest_litter"},
	sidelen = 8,
	fill_ratio = 0.02,
	y_min = 0,
	y_max = 6,
	rotation = "random",
	biomes = {"swamp", "swamp_forest"},
	schematic = cypress_tree_schematic,
	flags = "place_center_x,place_center_z",
})	

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_rainforest_litter"},
	sidelen = 8,
	fill_ratio = 0.01,
	y_min = 1,
	y_max = 6,
	rotation = "random",
	place_offset_y = 1,
	biomes = {"swamp_forest"},
	schematic = cypress_log_schematic,
	flags = "place_center_x,place_center_z",
})	

for length = 1, 5 do
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_rainforest_litter"},
		fill_ratio = 0.03,
		sidelen = 16,
		y_max = 30,
		y_min = 1,
		sidelen = 16,
		decoration = "default:grass_"..length,
	})
end

minetest.register_node("frontier_trees:cypress_tree_sapling", {
	description = "Cypress Tree Sapling",
	drawtype = "plantlike",
	tiles = {"frontier_trees_cypress_sapling.png"},
	inventory_image = "frontier_trees_cypress_sapling.png",
	wield_image = "frontier_trees_cypress_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = function(pos, elapsed)
		if not default.can_grow(pos) then
			return minetest:get_node_timer(pos):start(120)
		end
		pos.y = pos.y - 1
		minetest.place_schematic(pos, cypress_tree_schematic, "random", nil, false, "place_center_x,place_center_z")
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

-- Crafts
minetest.register_craft({
	type = "shapeless",
	output = "frontier_trees:cypress_wood 4",
	recipe = {"frontier_trees:cypress_tree"}
})

-- Write data output of gen_cypress_tree to file for debugging
local function read_schema(schema) 
	local schema_readable = {}
	for i, v in ipairs(schema.data) do
		table.insert(schema_readable, minetest.serialize(v))
	end

	local schema_file = io.open(minetest.get_worldpath().."/cypress_tree_schema.txt", "w")
	schema_file:write(minetest.serialize(schema_readable))
	schema_file:flush()
	schema_file:close()
end

--read_schema(cypress_tree_schematic)

