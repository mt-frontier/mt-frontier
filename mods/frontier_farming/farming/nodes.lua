-- farming/nodes.lua

-- support for MT game translation.
local S = farming.get_translator

minetest.override_item("default:dirt", {
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_grass", {
	soil = {
		base = "default:dirt_with_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_dry_grass", {
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_rainforest_litter", {
	soil = {
		base = "default:dirt_with_rainforest_litter",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_coniferous_litter", {
	soil = {
		base = "default:dirt_with_coniferous_litter",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dry_dirt", {
	soil = {
		base = "default:dry_dirt",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

minetest.override_item("default:dry_dirt_with_dry_grass", {
	soil = {
		base = "default:dry_dirt_with_dry_grass",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

minetest.register_node("farming:soil", {
	description = S("Soil"),
	tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("farming:soil_wet", {
	description = S("Wet Soil"),
	tiles = {"default_dirt.png^farming_soil_wet.png", "default_dirt.png^farming_soil_wet_side.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("farming:dry_soil", {
	description = S("Dry Soil"),
	tiles = {"default_dry_dirt.png^farming_soil.png", "default_dry_dirt.png"},
	drop = "default:dry_dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=2, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dry_dirt",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

minetest.register_node("farming:dry_soil_wet", {
	description = S("Wet Dry Soil"),
	tiles = {"default_dry_dirt.png^farming_soil_wet.png", "default_dry_dirt.png^farming_soil_wet_side.png"},
	drop = "default:dry_dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dry_dirt",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

minetest.override_item("default:desert_sand", {
	groups = {crumbly=3, falling_node=1, sand=1, soil = 1},
	soil = {
		base = "default:desert_sand",
		dry = "farming:desert_sand_soil",
		wet = "farming:desert_sand_soil_wet"
	}
})

minetest.register_node("farming:desert_sand_soil", {
	description = S("Desert Sand Soil"),
	drop = "default:desert_sand",
	tiles = {"farming_desert_sand_soil.png", "default_desert_sand.png"},
	groups = {crumbly=3, not_in_creative_inventory = 1, falling_node=1, sand=1, soil = 2, desert = 1, field = 1},
	sounds = default.node_sound_sand_defaults(),
	soil = {
		base = "default:desert_sand",
		dry = "farming:desert_sand_soil",
		wet = "farming:desert_sand_soil_wet"
	}
})

minetest.register_node("farming:desert_sand_soil_wet", {
	description = S("Wet Desert Sand Soil"),
	drop = "default:desert_sand",
	tiles = {"farming_desert_sand_soil_wet.png", "farming_desert_sand_soil_wet_side.png"},
	groups = {crumbly=3, falling_node=1, sand=1, not_in_creative_inventory=1, soil=3, wet = 1, desert = 1, field = 1},
	sounds = default.node_sound_sand_defaults(),
	soil = {
		base = "default:desert_sand",
		dry = "farming:desert_sand_soil",
		wet = "farming:desert_sand_soil_wet"
	}
})

minetest.register_node("farming:straw", {
	description = S("Straw"),
	tiles = {"farming_straw.png"},
	is_ground_content = false,
	groups = {snappy=3, flammable=4, fall_damage_add_percent=-30},
	sounds = default.node_sound_leaves_defaults(),
})

do
	local recipe = "farming:straw"
	local groups = {snappy = 3, flammable = 4}
	local images = {"farming_straw.png"}
	local sounds = default.node_sound_leaves_defaults()

	stairs.register_stair("straw", recipe, groups, images, S("Straw Stair"),
		sounds, true)
	stairs.register_stair_inner("straw", recipe, groups, images, "",
		sounds, true, S("Inner Straw Stair"))
	stairs.register_stair_outer("straw", recipe, groups, images, "",
		sounds, true, S("Outer Straw Stair"))
	stairs.register_slab("straw", recipe, groups, images, S("Straw Slab"),
		sounds, true)
end

