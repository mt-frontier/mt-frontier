-- farming/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("farming")

-- Global farming namespace

farming = {}
farming.path = minetest.get_modpath("farming")
farming.get_translator = S

-- Load files

--dofile(farming.path .. "/api.lua")
dofile(farming.path .. "/nodes.lua")


-- WHEAT

minetest.register_craftitem("farming:wheat", {
	description = S("Wheat"),
	inventory_image = "farming_wheat.png",
	groups = {food_wheat=1, flammable = 4},
})

minetest.register_craftitem("farming:flour", {
	description = S("Flour"),
	inventory_image = "farming_flour.png",
	groups = {food_flour = 1, flammable = 1},
})

minetest.register_craftitem("farming:bread", {
	description = S("Bread"),
	inventory_image = "farming_bread.png",
	on_use = minetest.item_eat(5),
	groups = {food_bread = 1, flammable = 2},
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:flour",
	recipe = {"farming:wheat", "farming:wheat", "farming:wheat", "farming:wheat"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:bread",
	recipe = "farming:flour"
})


-- Cotton
minetest.register_craftitem("farming:cotton", {
	description = S("Cotton"),
	inventory_image = "farming_cotton.png",
	groups = {flammable = 2},
})

minetest.register_craftitem("farming:string", {
	description = S("String"),
	inventory_image = "farming_string.png",
	groups = {flammable = 2},
})

-- Fuels
minetest.register_craft({
	type = "fuel",
	recipe = "farming:straw",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:wheat",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:cotton",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:string",
	burntime = 1,
})

-- Barley
minetest.register_craftitem("farming:barley", {
	description = S("Barley"),
	inventory_image = "farming_barley.png",
	groups = {food_barley=1, flammable = 4},
})

minetest.register_abm({
	label = "Farming soil",
	nodenames = {"group:field"},
	interval = 149,
	chance = 4,
	action = function(pos, node)

		local ndef = minetest.registered_nodes[node.name]
		if not ndef or not ndef.soil or not ndef.soil.wet
		or not ndef.soil.base or not ndef.soil.dry then return end

		pos.y = pos.y + 1
		local nn = minetest.get_node_or_nil(pos)
		pos.y = pos.y - 1

		if nn then nn = nn.name else return end

		-- what's on top of soil, if solid/not plant change soil to dirt
		if minetest.registered_nodes[nn]
		and minetest.registered_nodes[nn].walkable
		and minetest.get_item_group(nn, "plant") == 0
		and minetest.get_item_group(nn, "flora") == 0 then
			minetest.set_node(pos, {name = ndef.soil.base})
			return
		end

		-- if map around soil not loaded then skip until loaded
		if minetest.find_node_near(pos, 1, {"ignore"}) then
			return
		end

		-- Revert farming soil to base node gradually when no plants or crops are placed on it
		if minetest.get_item_group(nn, {"group:flora"}) == 0
		and minetest.get_item_group(nn, {"group:plant"}) == 0 then
			if node.name == ndef.soil.wet then
				minetest.set_node(pos, {name = ndef.soil.dry})
			elseif node.name == ndef.soil.dry then
				minetest.set_node(pos, {name = ndef.soil.base})
			end
		end
	end
})