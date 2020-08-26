if true then
	return
end

cs_herbs = {}

dofile(minetest.get_modpath("cs_herbs").."/api.lua")
dofile(minetest.get_modpath("cs_herbs").."/mortar.lua")

--Registrations --See api.lua for functions handling registration.
    
cs_herbs.register_flora ("rose", "Rose", 0, "#990000", "red")
cs_herbs.register_gen ("rose", {"default:dirt_with_grass"}, {"grassland"})

cs_herbs.register_flora ("dandelion", "Dandelion", 0, "#ffcc00", "yellow")
cs_herbs.register_gen ("dandelion", {"default:dirt_with_grass"}, {"grassland", "deciduous_forest"})

cs_herbs.register_flora ("echinacea", "Echinacea", 3, "#ff77e1", "magenta")
cs_herbs.register_gen ("echinacea", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, {"grassland", "deciduous_forest", "coniferous_forest"})

cs_herbs.register_flora ("viola", "Viola", 0, "#9933ff", "violet")    
cs_herbs.register_gen ("viola", {"default:dirt_with_grass", "default:dirt_with_rainforest_litter", "default:dirt_with_coniferous_litter"}, {"deciduous_forest", "rainforest", "coniferous_forest"})

cs_herbs.register_flora ("white_sage", "White Sage", 3, "#cccccc", "grey")
cs_herbs.register_gen ("white_sage", {"default:sand", "default:dirt_with_dry_grass"}, {"sandstone_desert", "savanna"})

cs_herbs.register_flora ("indigo", "Indigo", 0, "#3041cc", "blue")
cs_herbs.register_gen ("indigo", {"default:dirt_with_grass"}, {"grassland"})

cs_herbs.register_flora ("lily", "Lily", 3, "#ff7766", "pink")
cs_herbs.register_gen ("lily", {"default:dirt_with_rainforest_litter"}, {"rainforest"})

minetest.override_item("cs_herbs:indigo", {
	visual_scale = 1.25,
})

minetest.override_item("cs_herbs:indigo_2", {
	visual_scale = 1.25
})

minetest.override_item("cs_herbs:lily", {
	visual_scale = 1.5,
})

minetest.override_item("cs_herbs:lily_2",{
	visual_scale=1.5
})

dofile(minetest.get_modpath("cs_herbs").."/effects.lua")

--[[

minetest.override_item("flowers:dandelion_yellow", {
	tiles = {"flowers_dandelion_yellow.png"},
})

minetest.override_item("flowers:rose", {
	tiles = {"flowers_rose.png"},
	selection_box = {-1/2, -1/2, -1/2, 1/2, -1/4, 1/2}
})

minetest.register_node("cs_herbs:white_sage", {
	description = "White Sage",
	drawtype = "plantlike",
	tiles = {"white_sage.png"},
	inventory_image = "white_sage.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3},
	selection_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/2, 1/4, 1/2}
	}
})

minetest.register_node("cs_herbs:echinacea", {
	description = "Echinacea",
	drawtype = "plantlike",
	tiles = {"echinacea.png"},
	inventory_image = "echinacea.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3},
	selection_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4}
	}
})

minetest.register_node("cs_herbs:angel_mushroom", {
	description = "Angel Mushroom",
	drawtype = "plantlike",
	tiles = {"cs_herbs_angel_shroom.png"},
	inventory_image = "cs_herbs_angel_shroom.png",
	paramtype = "light",
	light_source = 3,
	walkable = false,
	groups = {snappy = 3},
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, 0, 1/2}
	},
    on_use = function(itemstack, user, pointed_thing)
        itemstack:take_item(1)
        local hp = user:get_hp()
        hp = hp - 11
        user:set_hp(hp)
        return itemstack
    end,
})

minetest.register_node("cs_herbs:prickly_pear", {
	description = "Prickly Pear Cactus",
	drawtype = "plantlike",
	tiles = {"cs_herbs_prickly_pear.png"},
	inventory_image = "cs_herbs_prickly_pear.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3},
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, 0, 1/2}
	},
	drop = "cs_herbs:prickly_pear_fruit",
})

minetest.register_craftitem("cs_herbs:prickly_pear_fruit", {
	description = "Prickly Pear Fruit",
	inventory_image = "cs_herbs_prickly_pear_fruit.png",
	on_use = function(itemstack, user, pointed_thing)
		local hp = user:get_hp()
		hp = hp + 2
		user:set_hp(hp)
		itemstack:take_item()
		return itemstack
	end,
})


minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},	
	sidelen = 16,
	noise_params = {
			offset = 0.009,
			scale = 0.006,
			spread = {x = 250, y = 250, z = 250},
			seed = 257,
			octaves = 3,
			persist = 0.66
	},
	biomes = {"deciduous_forest", "coniferous_forest", "floatland_coniferous_forest"},
	decoration = "cs_herbs:angel_mushroom",
	y_max = 31000,
	y_min = -10,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_dry_grass", "default:desert_sand", "default:sand",},
	sidelen = 16,
	noise_params = {
			offset = -0.01,
			scale = 0.006,
			spread = {x = 250, y = 250, z = 250},
			seed = 257,
			octaves = 3,
			persist = 0.66
	},
	biomes = {"desert", "savanna", "sandstone_desert", "grassland_dunes",},
	decoration = "cs_herbs:prickly_pear",
	y_min = 1,
	y_max = 30000,
	
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:sand"},
	sidelen = 16,
	noise_params = {
			offset = -0.011,
			scale = 0.04,
			spread = {x = 200, y = 200, z = 200},
			seed = 13894,
			octaves = 3,
			persist = 0.6
		},
	biomes =  {"sandstone_desert"},
	decoration = "cs_herbs:white_sage",
	height = 1,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
			offset = -0.015,
			scale = 0.04,
			spread = {x = 200, y = 200, z = 200},
			seed = 24389,
			octaves = 3,
			persist = 0.6
		},
	biomes =  {"grassland"},
	decoration = "cs_herbs:echinacea",
	height = 1.2,
})
]]--
