frontier_craft.mill = {}
frontier_craft.mill.recipes = {}

minetest.register_craftitem("frontier_craft:mill_wheel", {
	description = "Stone Mill Wheel",
	inventory_image = "frontier_craft_mill_wheel.png",
	wield_iamge = "frontier_craft_mill_wheel.png"
})

function frontier_craft.register_mill_recipe(input, output)
	local input_stack = ItemStack(input)
	local output_stack = ItemStack(output)
	frontier_craft.mill.recipes[input_stack:get_name()] = {
		input = input_stack,
		output = output_stack,
	}
end

function frontier_craft.predict_mill_craft(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack("src", 1)
	if not stack then
		inv:set_stack("out", 1, ItemStack(""))
		return
	end
	local craft = frontier_craft.mill.recipes[stack:get_name()]
	if craft == nil then
		return
	end
	if inv:contains_item("src", craft.input) then
		return inv:set_stack("out", 1, craft.output)
	end
	inv:set_stack("out", 1, ItemStack(""))

end

minetest.register_node("frontier_craft:mill", {
	description = "Stone Mill",
	drawtype = "nodebox",
	tiles = {"frontier_craft_mill_top.png", "frontier_craft_mill_top.png", "frontier_craft_mill_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-1/16, -1/2, -1/16, 1/16, 1/2, 1/16},
			{-1/2, 1/2, -3/8, 1/2, 1/16, 3/8},
			{-3/8, 1/2, -1/2, 3/8, 1/16, 1/2},
			{-1/2, -1/2, -3/8, 1/2, -1/16, 3/8},
			{-3/8, -1/2, -1/2, 3/8, -1/16, 1/2}
		},
	},
	groups = {cracky=2, oddly_breakable_by_hand=2},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("out", 1)
		meta:set_string("formspec",
			"size[8,9]" ..
			"list[context;src;2,1;1,1;]" ..
			"label[2.1,2;Input]" ..
			"list[context;out;5,1;1,1;]" ..
			"label[5.1,2;Output]" ..
			"list[current_player;main;0,5;8,4;]" ..
			"listring[context;out]" ..
			"listring[current_player;main]"..
			"listring[context;src]"..
			"listring[current_player;main]"
		)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "out" then
			return 0
		end
		return 99
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		frontier_craft.predict_mill_craft(pos)
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "src" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local output = inv:get_stack("out", 1)
			print(output:get_name())
			inv:remove_item("out", output)
			--inv:set_stack("out", 1, nil)
			frontier_craft.predict_mill_craft(pos)
		elseif listname == "out" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local input = inv:get_stack("src", 1)
			local craft = frontier_craft.mill.recipes[input:get_name()]
			if craft and craft.output:get_name() == stack:get_name() then
				inv:remove_item("src", craft.input)
			end
			if inv:is_empty(listname, index) then
				frontier_craft.predict_mill_craft(pos)
			end
		end
	end,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "frontier_craft:mill_wheel",
	recipe = {
		{"", "default:stone", ""},
		{"default:stone", "", "default:stone"},
		{"", "default:stone", ""},
	},
})

minetest.register_craft({
	output = "frontier_craft:mill",
	recipe = {
		{"frontier_craft:mill_wheel"},
		{"group:wood"},
		{"frontier_craft:mill_wheel"}
	},
})
frontier_craft.register_mill_recipe("farming:seed_wheat 4", "farming:flour")
frontier_craft.register_mill_recipe("frontier_trees:apple 1", "frontier_craft:apple_sauce")

