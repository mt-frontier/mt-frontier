
-- Mushrooms
--

minetest.register_craftitem("frontier_plants:ganoderma", {
	description = "Ganoderma Mushroom",
	inventory_image = "frontier_plants_ganoderma.png",
	groups = {mushroom=1}
})

minetest.register_node("frontier_plants:amanita", {
	description = "Innocent-looking Brown Mushroom",
	tiles = {"frontier_plants_amanita.png"},
	inventory_image = "frontier_plants_amanita.png",
	wield_image = "frontier_plants_amanita.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {poison=1, mushroom = 1, snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(-14),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16}	}
})

minetest.register_node("frontier_plants:angel_death", {
	description = "Angel Mushroom",
	tiles = {"frontier_plants_angel_death.png"},
	inventory_image = "frontier_plants_angel_death.png",
	wield_image = "frontier_plants_angel_death.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {poison=1, mushroom = 1, snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(-18),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16}	}
})

minetest.register_node("frontier_plants:morel", {
	description = "Morel Mushroom",
	tiles = {"frontier_plants_morel.png"},
	inventory_image = "frontier_plants_morel.png",
	wield_image = "frontier_plants_morel.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {mushroom = 1, food_mushroom = 1, snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(3),
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -2 / 16, 3 / 16},
	}
})

minetest.register_node("frontier_plants:chantrelle", {
	description = "Chantrelle Mushroom",
	tiles = {"frontier_plants_chantrelle.png"},
	inventory_image = "frontier_plants_chantrelle.png",
	wield_image = "frontier_plants_chantrelle.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {mushroom = 1, food_mushroom = 1, snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(2),
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -2 / 16, 3 / 16},
	}
})

minetest.register_decoration({
	name = "frontier_plants:morel",
	deco_type = "simple",
	place_on = {"default:dirt_with_coniferous_litter"},
	spawn_by = {"group:tree", "group:leaves"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.006,
		spread = {x = 25, y = 25, z = 25},
		seed = 15,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"pine_savanna", "coniferous_forest"},
	y_max = 31000,
	y_min = 20,
	decoration = "frontier_plants:morel",
})

minetest.register_decoration({
	name = "frontier_plants:chantrelle",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	spawn_by = {"group:tree", "group:leaves"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.006,
		spread = {x = 25, y = 25, z = 25},
		seed = 17,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"deciduous_forest"},
	y_max = 31000,
	y_min = 2,
	decoration = "frontier_plants:chantrelle",
})

minetest.register_decoration({
	name = "frontier_plants:amanita",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	spawn_by = {"group:tree", "group:leaves"},

	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.006,
		spread = {x = 25, y = 25, z = 25},
		seed = 17,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"deciduous_forest"},
	y_max = 31000,
	y_min = 1,
	decoration = "frontier_plants:amanita",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
	spawn_by = {"group:tree", "group:leaves"},
	sidelen = 16,
	noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x = 25, y = 25, z = 25},
			seed = 257,
			octaves = 3,
			persist = 0.66
	},
	biomes = {"deciduous_forest", "coniferous_forest"},
	decoration = "frontier_plants:angel_death",
	y_max = 31000,
	y_min = -10,
})

-- Mushroom spread and death

function frontier_plants.mushroom_spread(pos, node)
	if minetest.get_node_light(pos, 0.5) > 3 then
		if minetest.get_node_light(pos, nil) > 13 then
			minetest.remove_node(pos)
		end
		return
	end
	local positions = minetest.find_nodes_in_area_under_air(
		{x = pos.x - 1, y = pos.y - 2, z = pos.z - 1},
		{x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
		{"group:soil"})
	if #positions == 0 then
		return
	end
	local pos2 = positions[math.random(#positions)]
	pos2.y = pos2.y + 1
	if minetest.get_node_light(pos2, 0.5) <= 3 then
		minetest.set_node(pos2, {name = node.name})
	end
end

minetest.register_abm({
	label = "Mushroom spread",
	nodenames = {"frontier_plants:morel", "frontier_plants:amanita", "frontier_plants:chantrelle", "frontier_plants:angel_death"},
	interval = 501,
	chance = 36,
	action = function(...)
		frontier_plants.mushroom_spread(...)
	end,
})

