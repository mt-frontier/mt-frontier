
----------
-- Nodes
----------
minetest.register_node("frontier_trees:longleaf_pine_tree", {
	description = "Longleaf Pine Tree",
	tiles = {
		"frontier_trees_longleaf_pine_tree_top.png", "frontier_trees_longleaf_pine_tree_top.png", 
		"frontier_trees_longleaf_pine_tree.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, flammable = 1},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local dir = {x = 2, y = 2, z = 2}
		local pos1 = vector.subtract(pos, dir)
		local pos2 = vector.add(pos, dir)
		local cones = minetest.find_nodes_in_area(pos1, pos2, {"frontier_trees:pine_cone"})
		for _, pos in ipairs(cones) do
			minetest.dig_node(pos)
		end
	end
})

minetest.register_node("frontier_trees:longleaf_pine_needles", {
		description = "Longleaf Pine Tree Leaves",
	drawtype = "allfaces",
	waving = 1,
	tiles = {"frontier_trees_longleaf_pine_needles.png"},
	special_tiles = {"frontier_trees_longleaf_pine_needles.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 1, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'frontier_trees:longleaf_pine_tree_sapling'}, rarity = 20},
			{items = {'frontier_trees:longleaf_pine_needles'},}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,

})

minetest.register_craftitem("frontier_trees:pine_nuts", {
	description = "Pine Nuts",
	inventory_image = "frontier_trees_pine_nuts.png",
	on_use = minetest.item_eat(1)
})

minetest.register_node("frontier_trees:pine_cone", {
	description = "Pine Cone",
	drawtype = "plantlike",
	tiles = {"frontier_trees_pine_cone.png"},
	inventory_image = "frontier_trees_pine_cone.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	walkable = false,
	groups = {snappy = 3, dig_immediate = 2, flammable = 1},
	drop = {
		max_items = 2,
		items = {
			{items = {"frontier_trees:pine_nuts"}, rarity = 3},
			{items = {"frontier_trees:pine_cone"}},
		}
	},
	after_place_node = function(pos)
		minetest.set_node(pos, {name = "frontier_trees:pine_cone", param2 = 2})
	end,
})
local tree_name = "longleaf_pine"
local tree_def = minetest.registered_nodes["frontier_trees:longleaf_pine_tree"]
local tree_tiles = {tree_def.tiles[1]}
stairs.register_stair_and_slab(
	tree_name .. "_tree", 
	"frontier_trees:" .. tree_name .. "_tree", 
	tree_def.groups, 
	tree_tiles, 
	tree_def.description .. " Stairs", 
	tree_def.description .. " Slab", 
	tree_def.sounds, 
	false
)

default.register_leafdecay({
	trunks = {"frontier_trees:longleaf_pine_tree"},
	leaves = {"frontier_trees:longleaf_pine_needles"},
	radius = 3,
})
-- Generate Schematic

local gen_longleaf_pine_tree = function ()
	local schem = {}
	schem.size = {x = 5, y = 13, z = 5}
	schem.yslice_prob = {}
	schem.yslice_prob[1] = {}
	schem.yslice_prob[1].ypos = 3 
	schem.yslice_prob[1].prob = 0.75 * 255
	schem.data = {}
	local ignore = {name = "ignore"}
	local tree = {name = "frontier_trees:longleaf_pine_tree", force_place = true}
	local needles = {name = "frontier_trees:longleaf_pine_needles", param1 = 255}
	local edge_needles = {name = "frontier_trees:longleaf_pine_needles", param1 = 190}
	local corner_needles = {name = "frontier_trees:longleaf_pine_needles", param1 = 100}
	local cone = {name = "frontier_trees:pine_cone", param1 = 30, param2 = 24}
	for z = 1, schem.size.z do
		for y = 1, schem.size.y do
			for x = 1, schem.size.x do
				if y < 11 and x == math.ceil(1/2*schem.size.x) and z == math.ceil(1/2*schem.size.z) then
					table.insert(schem.data, tree) 
				elseif y == 13 then
					if x == 3 and z == 3 then
						table.insert(schem.data, needles)
					elseif (x == 2 and z == 3) or (x == 4 and z == 3) 
					or (x == 3 and z == 2) or (x == 3 and z == 4)  then
						table.insert(schem.data, edge_needles)
					else
						table.insert(schem.data, ignore)
					end
				elseif y == 12 or y == 7 then
					if x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, edge_needles)
					elseif (x == 1 and z == 1) or (x == 1 and z == 5)
					or (x == 5 and z == 1) or (x == 5 and z == 5) then
						table.insert(schem.data, ignore)
					else
						table.insert(schem.data, cone)
					end
				elseif y == 11 then
					if x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, edge_needles)
					else
						table.insert(schem.data, corner_needles)
					end
				elseif y == 10 or y == 6 then
					if x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, edge_needles)
					else
						table.insert(schem.data, corner_needles)
					end
				elseif y == 9 then
					if x > 1 and x < 5 and z > 1 and z < 5 then
						table.insert(schem.data, edge_needles)
					elseif math.random() < 0.2 then
						table.insert(schem.data, cone)
					else
						table.insert(schem.data, corner_needles)
					end
				else
					table.insert(schem.data, ignore)
				end
			end
		end
	end
	return schem
end

local longleaf_pine_tree_schematic = gen_longleaf_pine_tree()
local longleaf_pine_log_schematic = {
	size = {x = 3, y =1, z = 1},
	data = {
		{name = "frontier_trees:longleaf_pine_tree", param1=255, param2 = 48},
		{name = "frontier_trees:longleaf_pine_tree", param1=255, param2 = 48, force_place = true},
		{name = "frontier_trees:longleaf_pine_tree", param1=255, param2 = 48}
	}
}

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt", "default:dirt_with_coniferous_litter"},
	sidelen = 8,
	fill_ratio = 0.003,
	y_min = 1,
	y_max = 26,
	rotation = "random",
	biomes = {"pine_savanna"},
	schematic = longleaf_pine_tree_schematic,
	flags = "place_center_x, place_center_z",
})	

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_coniferous_litter"},
	sidelen = 8,
	fill_ratio = 0.001,
	y_min = 1,
	y_max = 6,
	rotation = "random",
	place_offset_y = 1,
	biomes = {"pine_savanna"},
	schematic = longleaf_pine_log_schematic,
	flags = "place_center_x, place_center_z",
})	


minetest.register_node("frontier_trees:longleaf_pine_tree_sapling", {
	description = "Longleaf Pine Tree Sapling",
	drawtype = "plantlike",
	tiles = {"frontier_trees_longleaf_pine_sapling.png"},
	inventory_image = "frontier_trees_longleaf_pine_sapling.png",
	wield_image = "frontier_trees_longleaf_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = function(pos, elapsed)
		if not default.can_grow(pos) then
			return minetest:get_node_timer(pos):start(300)
		end
		pos.y = pos.y - 1
		minetest.place_schematic(pos, longleaf_pine_tree_schematic, "random", nil, false, "place_center_x, place_center_z")
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

-- Crafts
minetest.register_craft({
	type = "shapeless",
	output = "default:pine_wood 4",
	recipe = {"frontier_trees:longleaf_pine_tree"}
})

-- Write data output of gen_longleaf_pine_tree to file for debugging
local function read_schema(schema) 
	local schema_readable = {}
	for i, v in ipairs(schema.data) do
		table.insert(schema_readable, minetest.serialize(v))
	end

	local schema_file = io.open(minetest.get_worldpath().."/longleaf_pine_tree_schema.txt", "w")
	schema_file:write(minetest.serialize(schema_readable))
	schema_file:flush()
	schema_file:close()
end

--read_schema(longleaf_pine_tree_schematic)

