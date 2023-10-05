frontier_trees = {}

-- Wrapper function to easily register tree and wood nodes as stairs and slabs
function frontier_trees.register_stairs(tree_name)

	local wood_def = minetest.registered_nodes["frontier_trees:" .. tree_name .. "_wood"]
	local tree_def = minetest.registered_nodes["frontier_trees:" .. tree_name .. "_tree"]
	local tree_tiles = tree_def.tiles

	stairs.register_stair_and_slab(
		tree_name .. "_wood", 
		"frontier_trees:" .. tree_name .. "_wood",
		wood_def.groups,
		wood_def.tiles,
		wood_def.description .. " Stairs",
		wood_def.description .. " Slab",
		wood_def.sounds,
		false
	)

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
end
-- Wrapper function to quickly register tree wood as fences material.

function frontier_trees.register_fence(tree_name, tree_desc)
	default.register_fence("frontier_trees:" .. tree_name .."_fence", {
		description = tree_desc .. " Wood Fence",
		texture = "frontier_trees_" .. tree_name .."_wood.png",
		material = "frontier_trees:".. tree_name.."_wood",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
	})
end

local mp = minetest.get_modpath("frontier_trees")

dofile(mp .. "/nodes.lua")
dofile(mp .. "/apple.lua")
dofile(mp .. "/maple.lua")
dofile(mp .. "/cypress.lua")
dofile(mp .. "/mesquite.lua")
dofile(mp .. "/holly.lua")
dofile(mp .. "/longleaf.lua")
dofile(mp .. "/poplar.lua")
dofile(mp .. "/laurel.lua")
dofile(mp .. "/crafting.lua")
