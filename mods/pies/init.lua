pies = {}

local pie_nodebox = {
	type = "fixed",
	fixed = {
		{-1/4, -3/8, -1/4, 1/4, -7/16, 1/4},
		{-3/16, -5/16, -3/16, 3/16, -1/2, 3/16},
	}
}

local pie_groups = {food_pie = 1, attached_node = 1, dig_immediate = 2, crumbly = 3}

function pies.register_pie(flavor, Flavor, filling, hp)
	minetest.register_node("pies:" .. flavor .. "_pie", {
		description = Flavor .. " Pie (Unbaked)",
		drawtype = "nodebox",
		tiles = {
			"pies_"..flavor.."_pie_top.png", 
			"pies_pie_bottom.png",
			"pies_"..flavor.."_pie_side.png",
			"pies_"..flavor.."_pie_side.png",
			"pies_"..flavor.."_pie_side.png",
			"pies_"..flavor.."_pie_side.png",
		},
		node_box = pie_nodebox,
		groups = pie_groups,	
	})

	minetest.register_node("pies:baked_"..flavor.."_pie", {
		description = Flavor .. " Pie",
		drawtype = "nodebox",
		tiles = {
			"pies_baked_"..flavor.."_pie_top.png", 
			"pies_baked_pie_bottom.png",
			"pies_baked_"..flavor.."_pie_side.png",
			"pies_baked_"..flavor.."_pie_side.png",
			"pies_baked_"..flavor.."_pie_side.png",
			"pies_baked_"..flavor.."_pie_side.png",
		},
		node_box = pie_nodebox,
		groups = pie_groups,
		on_use = minetest.item_eat(hp)
	})

	minetest.register_craft({
		output = "pies:"..flavor.."_pie",
		recipe = {
			{"", "farming:flour", ""},
			filling,
			{"", "default:tin_ingot", ""}
		},
	})

	minetest.register_craft({
		type = "cooking",
		output = "pies:baked_"..flavor.."_pie",
		recipe = "pies:"..flavor.."_pie",
		cooktime = 5,

	})
end

pies.register_pie("apple", "Apple", {"frontier_trees:apple", "frontier_trees:apple", "frontier_trees:apple"}, 10)
pies.register_pie("blueberry", "Blueberry", {"default:blueberries", "default:blueberries", "default:blueberries"}, 10)
pies.register_pie("pumpkin", "Pumpkin", {"crops:roasted_pumpkin", "crops:roasted_pumpkin", "crops:roasted_pumpkin"}, 16)
pies.register_pie("chicken", "Chicken Pot", {"mobs:chicken_cooked", "crops:potato", "mobs:chicken_cooked"}, 20)
