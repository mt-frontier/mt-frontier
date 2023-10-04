frontier_plants = {}
local mp = minetest.get_modpath("frontier_plants")
dofile(mp .. "/api.lua")
dofile(mp .. "/mortar.lua")
dofile(mp .. "/cattail.lua")
dofile(mp .. "/prickly_pear.lua")
dofile(mp .. "/saw_palmetto.lua")
dofile(mp .. "/marsh_grass.lua")
dofile(mp .. "/mushrooms.lua")

--Registrations --See api.lua for functions handling registration.
    
frontier_plants.register_flora ("rose", "Rose", 0, "#990000", "red")
frontier_plants.register_gen ("rose", {"default:dirt_with_grass"}, {"grassland"})

frontier_plants.register_flora ("dandelion", "Dandelion", 0, "#ffcc00", "yellow")
frontier_plants.register_gen ("dandelion", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, {"grassland", "deciduous_forest", "pine_savanna"})

frontier_plants.register_flora ("echinacea", "Echinacea", 3, "#ff77e1", "magenta")
frontier_plants.register_gen ("echinacea", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, {"grassland", "deciduous_forest", "coniferous_forest"})

frontier_plants.register_flora ("viola", "Viola", 0, "#9933ff", "violet")    
frontier_plants.register_gen ("viola", {"default:dirt_with_grass", "default:dirt_with_rainforest_litter", "default:dirt_with_coniferous_litter"}, {"deciduous_forest", "rainforest", "coniferous_forest"})

frontier_plants.register_flora ("white_sage", "White Sage", 3, "#cccccc", "grey")
frontier_plants.register_gen ("white_sage", {"default:sand", "default:desert_sand", "default:silver_sand"}, {"desert", "cold_desert"})

frontier_plants.register_flora ("indigo", "Indigo", 0, "#3041cc", "blue")
frontier_plants.register_gen ("indigo", {"default:dirt_with_grass"}, {"grassland"})

frontier_plants.register_flora ("lily", "Lily", 3, "#ff7766", "pink")
frontier_plants.register_gen ("lily", {"default:dirt_with_rainforest_litter"}, {"swamp"})

minetest.override_item("frontier_plants:indigo", {
	visual_scale = 1.25,
})

minetest.override_item("frontier_plants:indigo_2", {
	visual_scale = 1.25
})

minetest.override_item("frontier_plants:lily", {
	visual_scale = 1.5,
})

minetest.override_item("frontier_plants:lily_2",{
	visual_scale=1.5
})


------
-- Odd plants and fungus that do not follow flowering behavior
------

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},	
	sidelen = 16,
	noise_params = {
			offset = 0.009,
			scale = 0.06,
			spread = {x = 250, y = 250, z = 250},
			seed = 257,
			octaves = 3,
			persist = 0.66
	},
	biomes = {"deciduous_forest", "coniferous_forest", "floatland_coniferous_forest"},
	decoration = "frontier_plants:angel_mushroom",
	y_max = 31000,
	y_min = -10,
})


-- Waterlily

minetest.register_node("frontier_plants:waterlily", {
	description = "Waterlily",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"frontier_plants_waterlily.png", "frontier_plants_waterlily_bottom.png"},
	inventory_image = "frontier_plants_waterlily.png",
	wield_image = "frontier_plants_waterlily.png",
	liquids_pointable = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {snappy = 3, flower = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -31 / 64, -0.5, 0.5, -15 / 32, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
	},

	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local node = minetest.get_node(pointed_thing.under)
		local def = minetest.registered_nodes[node.name]
		local player_name = placer and placer:get_player_name() or ""

		if def and def.on_rightclick then
			return def.on_rightclick(pointed_thing.under, node, placer, itemstack,
					pointed_thing)
		end

		if def and def.liquidtype == "source" and
				minetest.get_item_group(node.name, "water") > 0 then
			if not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "frontier_plants:waterlily",
					param2 = math.random(0, 3)})
				if not (creative and creative.is_enabled_for
						and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, "Node is protected")
				minetest.record_protection_violation(pos, player_name)
			end
		end

		return itemstack
	end
})


minetest.register_decoration({
	name = "frontier_plants:waterlily",
	deco_type = "simple",
	place_on = {"default:dirt", "default:sand"},
	sidelen = 16,
	noise_params = {
		offset = -0.1,
		scale = 0.3,
		spread = {x = 200, y = 200, z = 200},
		seed = 133,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"swamp", "swamp_ocean", "savanna_shore", "deciduous_forest_shore"},
	y_max = 0,
	y_min = 0,
	decoration = "frontier_plants:waterlily",
	param2 = 0,
	param2_max = 3,
	place_offset_y = 1,
})

minetest.register_decoration({
	name = "frontier_plants:waterlily",
	deco_type = "simple",
	place_on = {"default:sand", "default:dirt"},
	sidelen = 16,
	noise_params = {
		offset = 0.1,
		scale = 0.3,
		spread = {x = 200, y = 200, z = 200},
		seed = 133,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"swamp"},
	y_max = 0,
	y_min = 0,
	decoration = "frontier_plants:waterlily",
	param2 = 0,
	param2_max = 3,
	place_offset_y = 1,
})
