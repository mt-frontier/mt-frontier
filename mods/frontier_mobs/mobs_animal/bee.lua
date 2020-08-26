
local S = mobs.intllib

-- Bee by KrupnoPavel (.b3d model by sirrobzeroone)

mobs:register_mob("mobs_animal:bee", {
	type = "monster",
	passive = false,
	hp_min = 1,
	hp_max = 2,
	attack_type = "dogfight",
	reach = 1,
	view_range = 5,
	damage = 1,
	attack_npcs = true,
	attack_players = true,
	attack_chance = 5,
	group_attack = true,
	armor = 200,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.5, 0.2},
	visual = "mesh",
	mesh = "mobs_bee.b3d",
	textures = {
		{"mobs_bee.png"},
	},
	blood_texture = "mobs_bee_inv.png",
	blood_amount = 1,
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_bee",
	},
	walk_velocity = 1,
	jump = true,
	drops = {
		{name = "mobs:honey", chance = 2, min = 1, max = 2},
	},
	water_damage = 1,
	lava_damage = 2,
	light_damage = 0,
	fall_damage = 0,
	fall_speed = -3,
	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 30,
		walk_start = 35,
		walk_end = 65,
	},
	on_rightclick = function(self, clicker)
		mobs:capture_mob(self, clicker, 50, 90, 0, true, "mobs_animal:bee")
	end,
--	after_activate = function(self, staticdata, def, dtime)
--		print ("------", self.name, dtime, self.health)
--	end,
})

mobs:spawn({
	name = "mobs_animal:bee",
	nodes = {"group:flora","group:flower", "mobs:beehive"},
	min_light = 14,
	interval = 60,
	chance = 7000,
	min_height = 3,
	max_height = 200,
	day_toggle = true,
})

mobs:register_egg("mobs_animal:bee", S("Bee"), "mobs_bee_inv.png")

-- compatibility
mobs:alias_mob("mobs:bee", "mobs_animal:bee")

-- honey
minetest.register_craftitem(":mobs:honey", {
	description = S("Honey"),
	inventory_image = "mobs_honey_inv.png",
	on_use = minetest.item_eat(4),
	groups = {food_honey = 1, food_sugar = 1, flammable = 1},
})

minetest.register_craftitem(":mobs:beeswax", {
	description = S("Beeswax"),
	inventory_image = "mobs_beeswax_inv.png",
})

-- beehive (when placed spawns bee)
minetest.register_node(":mobs:beehive", {
	description = S("Beehive"),
	drawtype = "nodebox",
	tiles = {"frontier_trees_apple_wood.png"},
--	inventory_image = "mobs_beehive.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	groups = {oddly_breakable_by_hand = 3, flammable = 1},
	sounds = default.node_sound_defaults(),
	node_box = { 
		type = "fixed",
		fixed = {
			{-1/2, 1/2, -1/2, 1/2, 7/16, 1/2},
			{-7/16, 7/16, -7/16, -3/8, -1/2, 7/16},
			{7/16, 7/16, -7/16, 3/8, -1/2, 7/16},
			{-3/8, 3/8, -3/8, 3/8, 0, 3/8},
			{-3/8, -1/16, -3/8, 3/8, -1/2, 3/8},
			{-1/8, 1/4, -3/8, 1/8, 1/8, -7/16},
			{-1/8, 1/4, 3/8, 1/8, 1/8, 7/16},
			{-1/8, -5/16, -3/8, 1/8, -3/16, -7/16},
			{-1/8, -5/16, 3/8, 1/8, -3/16, 7/16},
		}
	},

	on_construct = function(pos)
		local timer = minetest.get_node_timer(pos):start(math.random(300, 600))
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("honey", 1)
		inv:set_size("beeswax", 1)
		
		meta:set_string("formspec", "size[8,6]"
			..default.gui_bg..default.gui_bg_img..default.gui_slots
			.. "image[3.5,0.8;0.8,0.8;mobs_bee_inv.png]"
			.. "list[context;honey;2,0.5;1,1;]"
			.. "list[context;beeswax;5,0.5;1,1;]"
			.. "list[current_player;main;0,2.35;8,4;]"
			.. "listring[context;honey]"
			.. "listring[current_player;main]"
			.. "listring[context;beeswax]"
			.. "listring[current_player;main]")

	end,

	after_place_node = function(pos, placer, itemstack)

		if placer and placer:is_player() then

			--minetest.set_node(pos, {name = "mobs:beehive", param2 = 1})

			if math.random(1, 10) == 1 then
				minetest.add_entity(pos, "mobs_animal:bee")
			end
		end
	end,
	
	on_timer = function(pos, elapsed)
		local timer = minetest.get_node_timer(pos)
		local t = minetest.get_timeofday()
		if t < 0.25 or t > 0.75 then
			return timer:start(math.random(300))
		end
		if #minetest.find_nodes_in_area_under_air(
			{x = pos.x - 4, y = pos.y - 3, z = pos.z - 4},
			{x = pos.x + 4, y = pos.y + 3, z = pos.z + 4},
			"group:flower") > 3 then
		local inv = minetest.get_meta(pos):get_inventory()	
		inv:add_item("honey", "mobs:honey")
		inv:add_item("beeswax", "mobs:beeswax")
		minetest.sound_play("mobs_bee", {
			pos = pos,
			gain = 0.25,
		})
		end
		
		timer:start(math.random(120, 300))
	end,

	on_punch = function(pos, node, puncher)
			if math.random(1, 10) == 1 then
				minetest.add_entity(pos, "mobs_animal:bee")
			end

	end,

	allow_metadata_inventory_move = function()
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)

		if listname == "honey" or listname == "beeswax" then
			return 0
		end

		return stack:get_count()
	end,

	can_dig = function(pos,player)

		local meta = minetest.get_meta(pos)

		-- only dig beehive if no honey inside
		return meta:get_inventory():is_empty("beehive")
	end,

})

minetest.register_craft({
	output = "mobs:beehive",
	recipe = {
		{"mobs_animal:bee","mobs_animal:bee","mobs_animal:bee"},
		{"group:wood","mobs:honey","group:wood"},
		{"mobs_animal:bee","mobs_animal:bee","mobs_animal:bee"},
	}
})

-- honey block
minetest.register_node(":mobs:honey_block", {
	description = S("Honey Block"),
	tiles = {"mobs_honey_block.png"},
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	output = "mobs:honey_block",
	recipe = {
		{"mobs:honey", "mobs:honey", "mobs:honey"},
		{"mobs:honey", "mobs:honey", "mobs:honey"},
		{"mobs:honey", "mobs:honey", "mobs:honey"},
	}
})

minetest.register_craft({
	output = "mobs:honey 9",
	recipe = {
		{"mobs:honey_block"},
	}
})

--[[ beehive workings
minetest.register_abm({
	nodenames = {"mobs:beehive"},
	interval = 12,
	chance = 6,
	catch_up = false,
	action = function(pos, node)

		-- bee's only make honey during the day
		local tod = (minetest.get_timeofday() or 0) * 24000

		if tod < 5500 or tod > 18500 then
			return
		end

		-- is hive full?
		local meta = minetest.get_meta(pos)
		if not meta then return end -- for older beehives
		local inv = meta:get_inventory()
		local honey = inv:get_stack("beehive", 1):get_count()

		-- is hive full?
		if honey > 11 then
			return
		end

		-- no flowers no honey, nuff said!
		if #minetest.find_nodes_in_area_under_air(
			{x = pos.x - 4, y = pos.y - 3, z = pos.z - 4},
			{x = pos.x + 4, y = pos.y + 3, z = pos.z + 4},
			"group:flower") > 3 then

			inv:add_item("beehive", "mobs:honey")
		end
	end
})
]]--
