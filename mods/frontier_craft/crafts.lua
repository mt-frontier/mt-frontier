-- Handcrafts
frontier_craft.register_craft("hand", "frontier_craft:firewood", {inputs={"group:stick 9", "farming:string 2"}})
frontier_craft.register_craft("hand", "default:coalblock", {inputs={"default:coal_lump 9"}})
frontier_craft.register_craft("hand", "default:brick", {inputs={"default:clay_brick 4"}})
frontier_craft.register_craft("hand", "frontier_craft:forge", {inputs={"default:brick 4"}})


-- Forge
frontier_craft.register_craft("forge", "default:glass", {inputs={"group:sand"}})

frontier_craft.register_craft("forge", "default:steel_ingot", {inputs={"default:iron_lump"}})
frontier_craft.register_craft("forge", "default:steel_ingot 9", {inputs={"default:steelblock"}})
frontier_craft.register_craft("forge", "default:steelblock", {inputs={"default:steel_ingot 9"}})


frontier_craft.register_craft("forge", "default:gold_ingot", {inputs={"default:gold_lump"}})
frontier_craft.register_craft("forge", "default:gold_ingot 9", {inputs={"default:goldblock"}})
frontier_craft.register_craft("forge", "default:goldblock", {inputs={"default:gold_ingot 9"}})

frontier_craft.register_craft("forge", "frontier_craft:anvil", {inputs={"default:steelblock"}})


-- Fuels
minetest.register_craft({
	type = "fuel",
	recipe = "frontier_craft:firewood",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:coal_lump",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:coalblock",
	burntime = 370,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 36,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:stick",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:sapling",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 2,
})