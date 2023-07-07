-- Minetest 0.4 mod: vessels
-- See README.txt for licensing and other information.

local vessels_shelf_formspec =
	"size[8,7;]" ..
	"list[context;vessels;0,0.3;8,2;]" ..
	"list[current_player;main;0,2.85;8,1;]" ..
	"list[current_player;main;0,4.08;8,3;8]" ..
	"listring[context;vessels]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0, 2.85)

local function get_vessels_shelf_formspec(inv)
	local formspec = vessels_shelf_formspec
	local invlist = inv and inv:get_list("vessels")
	-- Inventory slots overlay
	local vx, vy = 0, 0.3
	for i = 1, 16 do
		if i == 9 then
			vx = 0
			vy = vy + 1
		end
		if not invlist or invlist[i]:is_empty() then
			formspec = formspec ..
				"image[" .. vx .. "," .. vy .. ";1,1;vessels_shelf_slot.png]"
		end
		vx = vx + 1
	end
	return formspec
end

local function register_vessel_shelf(material_name, material_desc, material_image, material_node)
	local name = "vessels:"..material_name .."_shelf"
	local desc = material_desc
	local img = material_image
	local material = material_node
	

	minetest.register_node(name, {
		description = desc .." Vessels Shelf",
		tiles = {img, img, img, img, img, img .."^vessel_shelf_overlay.png"},
		use_texture_alpha = true,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-1/2, -1/2, -1/2, -7/16, 1/2, 1/2},
				{1/2, -1/2, -1/2, 7/16, 1/2, 1/2},
				{-7/16, -1/2, -1/2, 7/16, -3/8, 1/2}, 
				{-7/16, 1/2, -1/2, 7/16, 7/16, 1/2}, 
				{-7/16, 0, -1/2, 7/16, 1/16, 1/2},
				{-7/16, -3/8, 1/2, 7/16, 0, -7/16},
				{-7/16, 7/16, 1/2, 7/16, 1/16, -7/16},
			}
		},
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults(),
		
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", get_vessels_shelf_formspec(nil))
			local inv = meta:get_inventory()
			inv:set_size("vessels", 8 * 2)
		end,
		can_dig = function(pos,player)
			local inv = minetest.get_meta(pos):get_inventory()
			return inv:is_empty("vessels")
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			if minetest.get_item_group(stack:get_name(), "vessel") ~= 0 then
				return stack:get_count()
			end
			return 0
		end,
		on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			minetest.log("action", player:get_player_name() ..
				   " moves stuff in vessels shelf at ".. minetest.pos_to_string(pos))
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", get_vessels_shelf_formspec(meta:get_inventory()))
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name() ..
				   " moves stuff to vessels shelf at ".. minetest.pos_to_string(pos))
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", get_vessels_shelf_formspec(meta:get_inventory()))
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name() ..
				   " takes stuff from vessels shelf at ".. minetest.pos_to_string(pos))
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", get_vessels_shelf_formspec(meta:get_inventory()))
		end,
		on_blast = function(pos)
			local drops = {}
			default.get_inventory_drops(pos, "vessels", drops)
			drops[#drops + 1] = name
			minetest.remove_node(pos)
			return drops
		end,
	})

	minetest.register_craft({
		output = name,
		recipe = {
			{ material, material, material},
			{"group:vessel", "group:vessel", "group:vessel"},
			{ material, material, material}
		}
	})

	minetest.register_craft({
		type = "fuel",
		recipe = name,
		burntime = 30,
	})
end

local materials = {"Apple", "Cypress", "Maple", "Mesquite", "Poplar"}

for i = 1, #materials do
	local mat_name = materials[i]:lower()
	local desc = materials[i] .. " Wood "
	local image = "frontier_trees_" .. mat_name .. "_wood.png"
	local material = "frontier_trees:" .. mat_name .. "_wood"

	register_vessel_shelf(mat_name, desc, image, material)
end
	register_vessel_shelf("pine", "Pine", "default_pine_wood.png", "default:pine_wood")

minetest.register_node("vessels:glass_bottle", {
	description = "Empty Glass Bottle",
	drawtype = "plantlike",
	tiles = {"vessels_glass_bottle.png"},
	inventory_image = "vessels_glass_bottle.png",
	wield_image = "vessels_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft( {
	output = "vessels:glass_bottle 10",
	recipe = {
		{"default:glass", "", "default:glass"},
		{"default:glass", "", "default:glass"},
		{"", "default:glass", ""}
	}
})

minetest.register_node("vessels:glass_jar", {
	description = "Empty Glass Jar",
	drawtype = "plantlike",
	tiles = {"vessels_glass_jar.png"},
	inventory_image = "vessels_glass_jar.png",
	wield_image = "vessels_glass_jar.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft( {
	output = "vessels:glass_jar 14",
	recipe = {
		{"default:glass", "", "default:glass"},
		{"default:glass", "", "default:glass"},
		{"default:glass", "default:glass", "default:glass"}
	}
})

minetest.register_node("vessels:apple_butter_jar", {
	description = "Apple Sauce Jar",
	drawtype = "plantlike",
	tiles = {"vessels_apple_glass_jar.png"},
	inventory_image = "vessels_apple_glass_jar.png",
	wield_image = "vessels_apple_glass_jar.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
	on_use = minetest.item_eat(10, "vessels:glass_jar")
})

minetest.register_craft({
	output = "vessels:apple_butter_jar",
	recipe = {
		{"", "default:tin_ingot", ""},
		{"adv_craft:apple_sauce", "adv_craft:apple_sauce", "adv_craft:apple_sauce",},
		{"", "vessels:glass_jar", ""}
	}
})

minetest.register_node("vessels:blueberry_jam_jar", {
	description = "Blueberry Jam Jar",
	drawtype = "plantlike",
	tiles = {"vessels_blueberry_glass_jar.png"},
	inventory_image = "vessels_blueberry_glass_jar.png",
	wield_image = "vessels_blueberry_glass_jar.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
	on_use = minetest.item_eat(6, "vessels:glass_jar"),
})

minetest.register_craft({
	output = "vessels:blueberry_jam_jar",
	recipe = {
		{"", "default:tin_ingot", ""},
		{"default:blueberries", "default:blueberries", "default:blueberries",},
		{"", "vessels:glass_jar", ""}
	}
})

minetest.register_node("vessels:maple_syrup_jar", {
	description = "Maple Syrup Jar",
	drawtype = "plantlike",
	tiles = {"vessels_maple_glass_jar.png"},
	inventory_image = "vessels_maple_glass_jar.png",
	wield_image = "vessels_maple_glass_jar.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
	on_use = minetest.item_eat(4, "vessels:glass_jar"),
})

minetest.register_craft({
	output = "vessels:maple_syrup_jar 3",
	recipe = {
		{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"},
		{"", "frontier_trees:syrup_bucket", "" },
		{"vessels:glass_jar", "vessels:glass_jar", "vessels:glass_jar"}
	}
})

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if itemstack:get_name() == "vessels:maple_syrup_jar" then
		local stack = ItemStack("bucket:bucket_empty")
		local pos = player:get_pos()
		minetest.item_drop(stack, player, pos)
	end
end)

--[[
minetest.register_node("vessels:drinking_glass", {
	description = "Empty Drinking Glass",
	drawtype = "plantlike",
	tiles = {"vessels_drinking_glass.png"},
	inventory_image = "vessels_drinking_glass_inv.png",
	wield_image = "vessels_drinking_glass.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft( {
	output = "vessels:drinking_glass 14",
	recipe = {
		{"default:glass", "", "default:glass"},
		{"default:glass", "", "default:glass"},
		{"default:glass", "default:glass", "default:glass"}
	}
})

minetest.register_node("vessels:steel_bottle", {
	description = "Empty Heavy Steel Bottle",
	drawtype = "plantlike",
	tiles = {"vessels_steel_bottle.png"},
	inventory_image = "vessels_steel_bottle.png",
	wield_image = "vessels_steel_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_defaults(),
})

minetest.register_craft( {
	output = "vessels:steel_bottle 5",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"", "default:steel_ingot", ""}
	}
})

]]--
-- Glass and steel recycling

minetest.register_craftitem("vessels:glass_fragments", {
	description = "Glass Fragments",
	inventory_image = "vessels_glass_fragments.png",
})

minetest.register_craft( {
	type = "shapeless",
	output = "vessels:glass_fragments",
	recipe = {
		"vessels:glass_bottle",
		"vessels:glass_bottle",
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "vessels:glass_fragments",
	recipe = {
		"vessels:glass_jar",
		"vessels:glass_jar",
	},
})

minetest.register_craft({
	type = "cooking",
	output = "default:glass",
	recipe = "vessels:glass_fragments",
})
--[[
minetest.register_craft( {
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "vessels:steel_bottle",
})
]]--