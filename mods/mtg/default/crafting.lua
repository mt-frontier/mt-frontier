-- mods/default/crafting.lua

minetest.register_craft({
	output = 'default:wood 4',
	recipe = {
		{'default:tree'},
	}
})

minetest.register_craft({
	output = 'default:junglewood 4',
	recipe = {
		{'default:jungletree'},
	}
})

minetest.register_craft({
	output = 'default:pine_wood 4',
	recipe = {
		{'default:pine_tree'},
	}
})

minetest.register_craft({
	output = 'default:acacia_wood 4',
	recipe = {
		{'default:acacia_tree'},
	}
})

minetest.register_craft({
	output = 'default:aspen_wood 4',
	recipe = {
		{'default:aspen_tree'},
	}
})

minetest.register_craft({
	output = 'default:wood',
	recipe = {
		{'default:bush_stem'},
	}
})

minetest.register_craft({
	output = 'default:acacia_wood',
	recipe = {
		{'default:acacia_bush_stem'},
	}
})

minetest.register_craft({
	output = "default:pine_wood",
	recipe = {
		{"default:pine_bush_stem"},
	}
})

minetest.register_craft({
	output = 'default:stick 4',
	recipe = {
		{'group:wood'},
	}
})

minetest.register_craft({
	output = 'default:sign_wall_steel 3',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'default:sign_wall_wood 3',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'default:torch 4',
	recipe = {
		{'default:coal_lump'},
		{'group:stick'},
	}
})


minetest.register_craft({
	output = 'default:pick_stone',
	recipe = {
		{'group:stone', 'group:stone', 'group:stone'},
		{'', 'group:stick', ''},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'default:pick_steel',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'', 'group:stick', ''},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'default:shovel_wood',
	recipe = {
		{'group:wood'},
		{'group:stick'},
		{'group:stick'},
	}
})

minetest.register_craft({
	output = 'default:shovel_stone',
	recipe = {
		{'group:stone'},
		{'group:stick'},
		{'group:stick'},
	}
})

minetest.register_craft({
	output = 'default:shovel_steel',
	recipe = {
		{'default:steel_ingot'},
		{'group:stick'},
		{'group:stick'},
	}
})

-- Axes
-- Recipes face left to match appearence in textures and inventory

minetest.register_craft({
	output = 'default:axe_wood',
	recipe = {
		{'group:wood', 'group:wood'},
		{'group:wood', 'group:stick'},
		{'', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'default:axe_stone',
	recipe = {
		{'group:stone', 'group:stone'},
		{'group:stone', 'group:stick'},
		{'', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'default:axe_steel',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'group:stick'},
		{'', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'default:dagger_stone',
	recipe = {
		{'group:stone'},
		{'group:stick'},
	}
})
minetest.register_craft({
	output = 'default:skeleton_key',
	recipe = {
		{'default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'default:chest',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', '', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

minetest.register_craft({
	output = 'default:chest_locked',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'default:steel_ingot', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

minetest.register_craft( {
	type = "shapeless",
	output = "default:chest_locked",
	recipe = {"default:chest", "default:steel_ingot"},
})

minetest.register_craft({
	output = 'default:furnace',
	recipe = {
		{'group:stone', 'group:stone', 'group:stone'},
		{'group:stone', '', 'group:stone'},
		{'group:stone', 'group:stone', 'group:stone'},
	}
})

minetest.register_craft({
	output = 'default:coalblock',
	recipe = {
		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
	}
})

minetest.register_craft({
	output = 'default:coal_lump 9',
	recipe = {
		{'default:coalblock'},
	}
})

minetest.register_craft({
	output = 'default:steelblock',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'default:steel_ingot 9',
	recipe = {
		{'default:steelblock'},
	}
})

minetest.register_craft({
	output = 'default:goldblock',
	recipe = {
		{'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
		{'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
		{'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'default:gold_ingot 9',
	recipe = {
		{'default:goldblock'},
	}
})

minetest.register_craft({
	output = "default:sandstone",
	recipe = {
		{"default:sand", "default:sand"},
		{"default:sand", "default:sand"},
	}
})

minetest.register_craft({
	output = "default:sand 4",
	recipe = {
		{"default:sandstone"},
	}
})

minetest.register_craft({
	output = "default:sandstonebrick 4",
	recipe = {
		{"default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone"},
	}
})

minetest.register_craft({
	output = "default:sandstone_block 9",
	recipe = {
		{"default:sandstone", "default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone", "default:sandstone"},
	}
})

minetest.register_craft({
	output = "default:desert_sandstone",
	recipe = {
		{"default:desert_sand", "default:desert_sand"},
		{"default:desert_sand", "default:desert_sand"},
	}
})

minetest.register_craft({
	output = "default:desert_sand 4",
	recipe = {
		{"default:desert_sandstone"},
	}
})

minetest.register_craft({
	output = "default:desert_sandstone_brick 4",
	recipe = {
		{"default:desert_sandstone", "default:desert_sandstone"},
		{"default:desert_sandstone", "default:desert_sandstone"},
	}
})

minetest.register_craft({
	output = "default:desert_sandstone_block 9",
	recipe = {
		{"default:desert_sandstone", "default:desert_sandstone", "default:desert_sandstone"},
		{"default:desert_sandstone", "default:desert_sandstone", "default:desert_sandstone"},
		{"default:desert_sandstone", "default:desert_sandstone", "default:desert_sandstone"},
	}
})

minetest.register_craft({
	output = "default:silver_sandstone",
	recipe = {
		{"default:silver_sand", "default:silver_sand"},
		{"default:silver_sand", "default:silver_sand"},
	}
})

minetest.register_craft({
	output = "default:silver_sand 4",
	recipe = {
		{"default:silver_sandstone"},
	}
})

minetest.register_craft({
	output = "default:silver_sandstone_brick 4",
	recipe = {
		{"default:silver_sandstone", "default:silver_sandstone"},
		{"default:silver_sandstone", "default:silver_sandstone"},
	}
})

minetest.register_craft({
	output = "default:silver_sandstone_block 9",
	recipe = {
		{"default:silver_sandstone", "default:silver_sandstone", "default:silver_sandstone"},
		{"default:silver_sandstone", "default:silver_sandstone", "default:silver_sandstone"},
		{"default:silver_sandstone", "default:silver_sandstone", "default:silver_sandstone"},
	}
})

minetest.register_craft({
	output = 'default:clay',
	recipe = {
		{'default:clay_lump', 'default:clay_lump'},
		{'default:clay_lump', 'default:clay_lump'},
	}
})

minetest.register_craft({
	output = 'default:clay_lump 4',
	recipe = {
		{'default:clay'},
	}
})

minetest.register_craft({
	output = 'default:brick',
	recipe = {
		{'default:clay_brick', 'default:clay_brick'},
		{'default:clay_brick', 'default:clay_brick'},
	}
})

minetest.register_craft({
	output = 'default:clay_brick 4',
	recipe = {
		{'default:brick'},
	}
})

minetest.register_craft({
	output = 'default:paper',
	recipe = {
		{'default:papyrus', 'default:papyrus', 'default:papyrus'},
	}
})

minetest.register_craft({
	output = 'default:book',
	recipe = {
		{'default:paper'},
		{'default:paper'},
		{'default:paper'},
	}
})

minetest.register_craft({
	output = 'default:bookshelf',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'default:book', 'default:book', 'default:book'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

minetest.register_craft({
	output = "default:ladder_wood 5",
	recipe = {
		{"group:stick", "", "group:stick"},
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "", "group:stick"},
	}
})

minetest.register_craft({
	output = 'default:ladder_steel 15',
	recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'default:stonebrick 4',
	recipe = {
		{'default:stone', 'default:stone'},
		{'default:stone', 'default:stone'},
	}
})

minetest.register_craft({
	output = 'default:stone_block 9',
	recipe = {
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:stone', 'default:stone', 'default:stone'},
	}
})

minetest.register_craft({
	output = 'default:desert_stonebrick 4',
	recipe = {
		{'default:desert_stone', 'default:desert_stone'},
		{'default:desert_stone', 'default:desert_stone'},
	}
})

minetest.register_craft({
	output = 'default:desert_stone_block 9',
	recipe = {
		{'default:desert_stone', 'default:desert_stone', 'default:desert_stone'},
		{'default:desert_stone', 'default:desert_stone', 'default:desert_stone'},
		{'default:desert_stone', 'default:desert_stone', 'default:desert_stone'},
	}
})

minetest.register_craft({
	output = 'default:snowblock',
	recipe = {
		{'default:snow', 'default:snow', 'default:snow'},
		{'default:snow', 'default:snow', 'default:snow'},
		{'default:snow', 'default:snow', 'default:snow'},
	}
})

minetest.register_craft({
	output = 'default:snow 9',
	recipe = {
		{'default:snowblock'},
	}
})

minetest.register_craft({
	output = "default:emergent_jungle_sapling",
	recipe = {
		{"default:junglesapling", "default:junglesapling", "default:junglesapling"},
		{"default:junglesapling", "default:junglesapling", "default:junglesapling"},
		{"default:junglesapling", "default:junglesapling", "default:junglesapling"},
	}
})

minetest.register_craft({
	output = "default:large_cactus_seedling",
	recipe = {
		{"", "default:cactus", ""},
		{"default:cactus", "default:cactus", "default:cactus"},
		{"", "default:cactus", ""},
	}
})


--
-- Crafting (tool repair)
--

minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})


--
-- Cooking recipes
--

minetest.register_craft({
	type = "cooking",
	output = "default:glass",
	recipe = "group:sand",
})

minetest.register_craft({
	type = "cooking",
	output = "default:obsidian_glass",
	recipe = "default:obsidian_shard",
})

minetest.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:cobble",
})

minetest.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:mossycobble",
})

minetest.register_craft({
	type = "cooking",
	output = "default:desert_stone",
	recipe = "default:desert_cobble",
})

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "default:iron_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "default:gold_ingot",
	recipe = "default:gold_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "default:clay_brick",
	recipe = "default:clay_lump",
})

minetest.register_craft({
	type = 'cooking',
	output = 'default:gold_ingot',
	recipe = 'default:skeleton_key',
	cooktime = 5,
})

minetest.register_craft({
	type = 'cooking',
	output = 'default:gold_ingot',
	recipe = 'default:key',
	cooktime = 5,
})


--
-- Fuels
--

-- Support use of group:tree, includes default:tree which has the same burn time


-- Burn time for all woods are in order of wood density,
-- which is also the order of wood colour darkness:
-- aspen, pine, apple, acacia, jungle

minetest.register_craft({
	type = "fuel",
	recipe = "default:aspen_tree",
	burntime = 22,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:pine_tree",
	burntime = 26,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:acacia_tree",
	burntime = 34,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:jungletree",
	burntime = 38,
})


-- Support use of group:wood, includes default:wood which has the same burn time


minetest.register_craft({
	type = "fuel",
	recipe = "default:aspen_wood",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:pine_wood",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:acacia_wood",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:junglewood",
	burntime = 9,
})


-- Support use of group:sapling, includes default:sapling which has the same burn time


minetest.register_craft({
	type = "fuel",
	recipe = "default:bush_sapling",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:acacia_bush_sapling",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:pine_bush_sapling",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:aspen_sapling",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:pine_sapling",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:acacia_sapling",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:junglesapling",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:emergent_jungle_sapling",
	burntime = 7,
})


minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_aspen_wood",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_pine_wood",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_wood",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_acacia_wood",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_junglewood",
	burntime = 9,
})


minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_aspen_wood",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_pine_wood",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_wood",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_acacia_wood",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_junglewood",
	burntime = 7,
})


minetest.register_craft({
	type = "fuel",
	recipe = "default:bush_stem",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:acacia_bush_stem",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:pine_bush_stem",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:junglegrass",
	burntime = 3,
})



minetest.register_craft({
	type = "fuel",
	recipe = "default:cactus",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:large_cactus_seedling",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:papyrus",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bookshelf",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:ladder_wood",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:lava_source",
	burntime = 60,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:torch",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:sign_wall_wood",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:chest",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:chest_locked",
	burntime = 30,
})


minetest.register_craft({
	type = "fuel",
	recipe = "default:grass_1",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:dry_grass_1",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fern_1",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:marram_grass_1",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:paper",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:book",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:book_written",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:dry_shrub",
	burntime = 2,
})


minetest.register_craft({
	type = "fuel",
	recipe = "default:pick_wood",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:shovel_wood",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:axe_wood",
	burntime = 6,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:sword_wood",
	burntime = 5,
})
