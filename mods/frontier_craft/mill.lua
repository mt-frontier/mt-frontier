craft.mill = {}
craft.mill.recipes = {}

minetest.register_craftitem("craft:mill_wheel", {
	description = "Stone Mill Wheel",
	inventory_image = "craft_mill_wheel.png",
	wield_iamge = "craft_mill_wheel.png"
})

function craft.register_mill_recipe(input, output)
	local input_stack = ItemStack(input)
	local output_stack = ItemStack(output)
	craft.mill.recipes[input_stack:get_name()] = {
		input = input_stack,
		output = output_stack,
	}
end

function craft.predict_mill_craft(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack("src", 1)
	if not stack then
		inv:set_stack("out", 1, ItemStack(""))
		return
	end
	local craft = craft.mill.recipes[stack:get_name()]
	if craft == nil then
		return
	end
	if inv:contains_item("src", craft.input) then
		return inv:set_stack("out", 1, craft.output)
	end
	inv:set_stack("out", 1, ItemStack(""))

end

minetest.register_node("craft:mill", {
	description = "Stone Mill",
	drawtype = "nodebox",
	tiles = {"craft_mill_top.png", "craft_mill_top.png", "craft_mill_side.png"},
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
	groups = {cracky = 2, },
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
		craft.predict_mill_craft(pos)
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "src" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local output = inv:get_stack("out", 1)
			print(output:get_name())
			inv:remove_item("out", output)
			--inv:set_stack("out", 1, nil)
			craft.predict_mill_craft(pos)
		elseif listname == "out" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local input = inv:get_stack("src", 1)
			local craft = craft.mill.recipes[input:get_name()]
			if craft and craft.output:get_name() == stack:get_name() then
				inv:remove_item("src", craft.input)
			end
			if inv:is_empty(listname, index) then
				craft.predict_mill_craft(pos)
			end
		end
	end,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "craft:mill_wheel",
	recipe = {
		{"", "default:stone", ""},
		{"default:stone", "", "default:stone"},
		{"", "default:stone", ""},
	},
})

minetest.register_craft({
	output = "craft:mill",
	recipe = {
		{"craft:mill_wheel"},
		{"group:wood"},
		{"craft:mill_wheel"}
	},
})

craft.register_mill_recipe("farming:seed_wheat 4", "farming:flour")
craft.register_mill_recipe("frontier_trees:apple 1", "adv_craft:apple_sauce")

