
local S = mobs.intllib


-- Warthog originally by KrupnoPavel, B3D model by sirrobzeroone

mobs:register_mob("mobs_animal:pumba", {
	stepheight = 0.6,
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	owner_loyal = true,
	attack_npcs = true,
	attack_players = true,
	attack_npcs = true,
	attacks_monsters = true,
	attack_chance = 12,
	group_attack = true,
	reach = 1,
	damage = 5,
	hp_min = 12,
	hp_max = 25,
	armor = 80,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	visual = "mesh",
	mesh = "mobs_pumba.b3d",
	textures = {
		{"mobs_pumba.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_pig",
		attack = "mobs_pig_angry",
	},
	walk_velocity = 2,
	run_velocity = 4,
	jump = true,
	jump_height = 6,
	pushable = true,
	follow = {"frontier_trees:apple", "crops:potato"},
	view_range = 4,
	drops = {
		{name = "mobs:pork_raw", chance = 1, min = 3, max = 6},
	},
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	fear_height = 2,
	animation = {
		speed_normal = 25,
		stand_start = 25,
		stand_end = 55,
		walk_start = 70,
		walk_end = 100,
		punch_start = 70,
		punch_end = 100,
	},
	on_rightclick = function(self, clicker)

		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 5, 50, false, nil) then return end
	end,
})

local spawn_on = {"default:dirt_with_grass"}
local spawn_by = {"group:grass", "group:mushroom"}

if minetest.get_mapgen_setting("mg_name") ~= "v6" then
	spawn_on = {"default:dirt_with_rainforest_litter", "default:dirt_with_dry_grass", "default:dirt_with_grass", "default:desert_sand",}
	spawn_by = {"air"}
end

if minetest.get_modpath("ethereal") then
	spawn_on = {"ethereal:mushroom_dirt"}
	spawn_by = {"flowers:mushroom_brown", "flowers:mushroom_brown"}
end

mobs:spawn({
	name = "mobs_animal:pumba",
	nodes = spawn_on,
	neighbors = spawn_by,
	--min_light = 14,
	interval = 63,
	chance = 37500,
	min_height = 0,
	max_height = 200,
	--day_toggle = true,
})


mobs:register_egg("mobs_animal:pumba", S("Warthog"), "mobs_pumba_inv.png")


mobs:alias_mob("mobs:pumba", "mobs_animal:pumba") -- compatibility


-- raw porkchop
minetest.register_craftitem(":mobs:pork_raw", {
	description = S("Raw Porkchop"),
	inventory_image = "mobs_pork_raw.png",
	on_use = minetest.item_eat(4),
	groups = {food_meat_raw = 1, food_pork_raw = 1, flammable = 2},
})

-- cooked porkchop
minetest.register_craftitem(":mobs:pork_cooked", {
	description = S("Cooked Porkchop"),
	inventory_image = "mobs_pork_cooked.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, food_pork = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:pork_cooked",
	recipe = "mobs:pork_raw",
	cooktime = 5,
})
