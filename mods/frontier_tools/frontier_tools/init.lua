dofile(minetest.get_modpath("frontier_tools") .. "/hoe.lua")

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
		},
		damage_groups = {fleshy=1},
	}
})

-- Picks
minetest.register_tool("frontier_tools:stone_pick", {
	description = "Stone Pickaxe",
	--inventory_image = "frontier_tools_stone_pick.png",
	inventory_image = "default_tool_stonepick.png",
	groups = {pickaxe=1},
	tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=2.0, [3]=1.00}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("frontier_tools:steel_pick", {
	description = "Steel Pickaxe",
	--inventory_image = "frontier_tools_steel_pick.png",
	inventory_image = "default_tool_steelpick.png",
	groups = {pickaxe=1},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
})

-- Shovels
minetest.register_tool("frontier_tools:stone_shovel", {
	description = "Stone Shovel",
	--inventory_image = "frontier_tools_stone_shovel.png",
	--wield_image = "frontier_tools_stone_shovel.png^[transformR90",
	inventory_image = "default_tool_stoneshovel.png",
	wield_image = "default_tool_stoneshovel.png^[transformR90",
	groups = {shovel=1},
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=1.80, [2]=1.20, [3]=0.50}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("frontier_tools:steel_shovel", {
	description = "Steel Shovel",
	--inventory_image = "frontier_tools_steel_shovel.png",
	--wield_image = "frontier_tools_steelshovel.png^[transformR90",
	inventory_image = "default_tool_steelshovel.png",
	wield_image = "default_tool_steelshovel.png^[transformR90",
	groups = {shovel=1},
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=40, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
	sound = {breaks = "default_tool_breaks"},
})

-- Axes
minetest.register_tool("frontier_tools:stone_axe", {
	description = "Stone Axe",
	inventory_image = "frontier_tools_stone_axe.png",
	groups = {axe=1},
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			choppy={times={[1]=3.00, [2]=2.00, [3]=1.30}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("frontier_tools:steel_axe", {
	description = "Steel Axe",
	--inventory_image = "frontier_tools_steel_axe.png",
	inventory_image = "default_tool_steelaxe.png",
	groups = {axe=1},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.0, [2]=1.40, [3]=1.00}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
})

-- Knives
--
minetest.register_tool("frontier_tools:stone_knife", {
	description = "Stone Knife ",
	inventory_image = "frontier_tools_stone_knife.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times={[1]=4.0, [2]=3.2, [3]=2.4}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy = 3},
	},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("frontier_tools:steel_knife", {
	description = "Steel Knife",
	inventory_image = "frontier_tools_steel_knife.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times={[1]=3.2, [2]=2.4, [3]=1.6}, uses = 40, maxlevel=3},
		},
		damage_groups = {fleshy = 4},
	},
	sound = {breaks = "default_tool_breaks"},
})

-- hoes

farming.register_hoe("frontier_tools:wood_hoe", {
	description = "Wood Hoe",
	inventory_image = "frontier_tools_wood_hoe.png",
	max_uses = 16,
	material = "group:wood",
	groups = {hoe = 1}
})

farming.register_hoe("frontier_tools:stone_hoe", {
	description = "Stone Hoe",
	inventory_image = "frontier_tools_stone_hoe.png",
	max_uses = 40,
	material = "group:stone",
	groups = {hoe = 2}
})

farming.register_hoe("frontier_tools:steel_hoe", {
	description = "Steel Hoe",
	inventory_image = "frontier_tools_steel_hoe_inv.png",
	weild_image = "frontier_tools_steel_hoe.png",
	max_uses = 60,
	material = "default:steel_ingot",
	groups = {hoe = 4}
})
--
-- Misc
-- from minetest_game
minetest.register_tool("frontier_tools:key", {
	description = "Key",
	inventory_image = "default_key.png",
	groups = {key = 1, not_in_creative_inventory = 1},
	stack_max = 1,
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local def = minetest.registered_nodes[node.name]
		if def and def.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local pos = pointed_thing.under
		node = minetest.get_node(pos)

		if not node or node.name == "ignore" then
			return itemstack
		end

		local ndef = minetest.registered_nodes[node.name]
		if not ndef then
			return itemstack
		end

		local on_key_use = ndef.on_key_use
		if on_key_use then
			on_key_use(pos, placer)
		end

		return nil
	end
})


dofile(minetest.get_modpath("frontier_tools") .. "/crafts.lua")