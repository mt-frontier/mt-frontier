frontier_stairs = {}

local step_nodeboxes = {
	["step"] = {
		{-1/2, -1/2, 1/2, 1/2, 0, 0},	
	},
	["corner"] = {
		{-1/2, -1/2, 1/2, 0, 0, 0},
	},
	["inner_edge"] = {
		{-1/2, -1/2, 1/2, 1/2, 0, 0},	
		{0, -1/2, 0, 1/2, 1/2, -1/2}
	}
}

local slab_nodeboxes = {
	["slab"] = {
		{-1/2, -1/2, -1/2, 1/2, 0, 1/2}
	},
	["quarter_slab"] = {
		{-1/2, -1/2, -1/2, 1/2, 1/4, 1/2}
	},
	["eigth_slab"] = {
		{-1/2, -1/2, -1/2, 1/2, 1/8, 1/2}
	},
	["sixteenth_slab"] = {
		{-1/2, -1/2, -1/2, 1/2, 1/16, 1/2}
	}
}

local stair_nodeboxes = {
	["stair"] = {	
		{-1/2, -1/2, -1/2, 1/2, 0, 1/2},
		{-1/2, 0, 1/2, 1/2, 1/2, 0},	
	},
	["outer_stair"] = {
		{-1/2, -1/2, -1/2, 1/2, 0, 1/2},
		{-1/2, 0, 1/2, 0, 1/2, 0},
	},
	["inner_stair"] = {
		{-1/2, -1/2, -1/2, 1/2, 0, 1/2},
		{-1/2, 0, 1/2, 1/2, 1/2, 0},	
		{-1/2, 0, 0, 0, 1/2, -1/2}
	},
	["y_stair"] = {
		{-1/2, -1/2, 1/2, 1/2, 0, 0},	
		{-1/2, -1/2, 0, 0, 0, -1/2},
		{-1/2, 0, 1/2, 0, 1/2, 0}
	}
}

function frontier_stairs.register_stairs(material_name, material_desc, textures, groups, sounds)
	local new_groups = groups
	new_groups.stair = 1

	for name, nodebox in pairs(stair_nodeboxes) do
		local node_def = {
			description = material_desc .." Stairs",
			tiles = textures,
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",

			node_box = {
				type = "fixed",
				fixed = nodebox
			},
			on_place = minetest.rotate_and_place,
			groups = new_groups,
			sounds = sounds
		}

		if name == "y_stair" then
			node_def.sunlight_propogates = true
		end

		minetest.register_node(":frontier_stairs:" .. material_name .."_" .. name, node_def)
	end
end
