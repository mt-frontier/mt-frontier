minetest.register_node("frontier_plants:prickly_pear_fruiting", {
	description = "Prickly Pear Cactus with Fruit",
	drawtype = "plantlike",
	tiles = {"frontier_plants_prickly_pear_fruiting.png"},
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3},
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, 0, 1/2}
	},
	drop = {
		max_items = 2,
		items = {
			{items = {"frontier_plants:prickly_pear"}, rarity = 2},
			{items = {"frontier_plants:prickly_pear_pad 2"}, rarity = 2}
		}
	},
	on_punch = function(pos, node, puncher)
		local wield_name = puncher:get_wielded_item():get_name()
		if wield_name == "" then
			puncher:punch(puncher, 1, {
				full_punch_interval = 1,
				damage_groups = {fleshy = 1},
			})
		end
	end,
})

minetest.register_node("frontier_plants:prickly_pear_flowering", {
	description = "Flowering Prickly Pear Cactus",
	drawtype = "plantlike",
	tiles = {"frontier_plants_prickly_pear_flowering.png"},
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3},
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, 0, 1/2}
	},
	drop = "frontier_plants:prickly_pear_pad 2",
	on_punch = function(pos, node, puncher)
		local wield_name = puncher:get_wielded_item():get_name()
		if wield_name == "" then
			puncher:punch(puncher, 1, {
				full_punch_interval = 1,
				damage_groups = {fleshy = 1},
			})
		end
	end,
})

minetest.register_node("frontier_plants:prickly_pear_plant", {
	description = "Prickly Pear Cactus",
       	drawtype = "plantlike",
        tiles = {"frontier_plants_prickly_pear_plant.png"},
        paramtype = "light",
        walkable = false,
        groups = {snappy = 3},
        selection_box = {
                type = "fixed",
                fixed = {-1/2, -1/2, -1/2, 1/2, 0, 1/2}
        },
        drop = "frontier_plants:prickly_pear_pad 2",
        on_punch = function(pos, node, puncher)
                local wield_name = puncher:get_wielded_item():get_name()
                if wield_name == "" then
                        puncher:punch(puncher, 1, {
                                full_punch_interval = 1,
                                damage_groups = {fleshy = 1},
                        })
                end
        end,
})

minetest.register_node("frontier_plants:prickly_pear_cutting", {
        description = "Prickly Pear Cactus Cutting",
        drawtype = "plantlike",
        tiles = {"frontier_plants_prickly_pear_cutting.png"},
        paramtype = "light",
        walkable = false,
        groups = {snappy = 3},
        selection_box = {
                type = "fixed",
                fixed = {-1/2, -1/2, -1/2, 1/2, -1/4, 1/2}
        },
        drop = "frontier_plants:prickly_pear_pad",
})


minetest.register_craftitem("frontier_plants:prickly_pear", {
	description = "Prickly Pear Fruit",
	inventory_image = "frontier_plants_prickly_pear.png",
	wield_image = "frontier_plants_prickly_pear.png",
	on_use = minetest.item_eat(2),
})


minetest.register_craftitem("frontier_plants:prickly_pear_pad", {
	description = "Prickly Pear Pad",
	inventory_image = "frontier_plants_prickly_pear_pad.png",
	wield_image = "frontier_plants_prickly_pear_pad.png",
	on_use = minetest.item_eat(1),
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_dry_grass", "default:desert_sand", "default:silver_sand", "default:sand",},
	sidelen = 16,
	noise_params = {
			offset = -0.05,
			scale = 0.06,
			spread = {x = 20, y = 20, z = 20},
			seed = 252,
			octaves = 3,
			persist = 0.66
	},
	biomes = {"desert", "savanna", "cold_desert", "deciduous_dunes"},
	decoration = "frontier_plants:prickly_pear_fruiting",
	y_min = 3,
	y_max = 1000,
})
