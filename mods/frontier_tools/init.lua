local S = minetest.get_translator(minetest.get_current_modname())


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
			oddly_breakable_by_hand = {times={[1]=1.0,[2]=0.85,[3]=0.70}, uses=0}
		},
		damage_groups = {fleshy=1},
	}
})

local mp = minetest.get_modpath("frontier_tools")
dofile(mp .. "/hoe.lua")
dofile(mp .. "/bows.lua")
--
-- Tools
--
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
		damage_groups = {fleshy=4},
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
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=40, maxlevel=2},
		},
		damage_groups = {fleshy=5},
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
			choppy={times={[1]=2.0, [2]=1.40, [3]=1.00}, uses=40, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
})

-- Knives
minetest.register_tool("frontier_tools:stone_knife", {
	description = "Stone Knife",
	inventory_image = "frontier_tools_stone_knife.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times={[1]=4.0, [2]=3.2, [3]=2.4}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy = 3},
	},
	groups = {knife=1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("frontier_tools:steel_knife", {
	description = "Steel Knife",
	inventory_image = "frontier_tools_steel_knife.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times={[1]=3.2, [2]=2.4, [3]=1.6}, uses = 80, maxlevel=3},
		},
		damage_groups = {fleshy = 4},
	},
	groups = {knife=1},
	sound = {breaks = "default_tool_breaks"},
})

-- Scythe
minetest.register_tool("frontier_tools:steel_scythe", {
	description = "Scythe",
	inventory_image = "frontier_tools_steel_scythe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times={[1]=0.7, [2]=0.6, [3]=0.5}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy = 4},
	},
	groups = {scythe=1},
	sound = {breaks = "default_tool_breaks"}
})

-- Hoes
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

-- Blacksmith hammer from Sokomine's Anvil mod
minetest.register_tool("frontier_tools:forge_hammer", {
	description = S("Hammer"),
	image = "frontier_tools_forge_hammer.png",
	inventory_image = "frontier_tools_forge_hammer.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		groupcaps = {
			cracky = {times = {[2] = 2.20, [3] = 1.10}, uses = 30, maxlevel = 1},
		},
		damage_groups = {fleshy = 5},
	}
})

-- Flint and steel, friction bow adapted from minetest game fire mod
minetest.register_tool("frontier_tools:friction_bow", {
	description = "Friction Bow",
	inventory_image = "frontier_tools_friction_bow.png",
	sound = {breaks = "default_tool_breaks"},

	on_use = function(itemstack, user, pointed_thing)
		local sound_pos = pointed_thing.above or user:get_pos()
		minetest.sound_play(
			"fire_flint_and_steel",
			{pos = sound_pos, gain = 0.5, max_hear_distance = 8}
		)
		local player_name = user:get_player_name()
		if pointed_thing.type == "node" then
			local node_under = minetest.get_node(pointed_thing.under).name
			local nodedef = minetest.registered_nodes[node_under]
			if not nodedef then
				return
			end
			if minetest.is_protected(pointed_thing.under, player_name) then
				minetest.chat_send_player(player_name, "This area is protected")
				return
			end
			if not (creative and creative.is_enabled_for
				and creative.is_enabled_for(player_name)) then
				-- Wear tool
				local wdef = itemstack:get_definition()
				itemstack:add_wear(4000)
				-- Tool break sound
				if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
					minetest.sound_play(wdef.sound.breaks, {pos = sound_pos, gain = 0.5})
				end
			end
			if temperature and minetest.get_node(pointed_thing.under).name ~= "frontier_craft:firewood" then
				if temperature.get_adjusted_temp(pointed_thing.under)<temperature.get_cold_temp() then
					if math.random(0,8) ~= 8 then
						return itemstack
					end
				elseif temperature.get_adjusted_temp(pointed_thing.under) < temperature.get_hot_temp() then
					if math.random(0,3) ~= 3 then
						return itemstack
					end
				end
			end
			if nodedef.on_ignite then
				nodedef.on_ignite(pointed_thing.under, user)
			elseif minetest.get_item_group(node_under, "flammable") >= 1
			and minetest.get_node(pointed_thing.above).name == "air" then
				local node_def = minetest.registered_nodes[node_under]
				if node_def.drawtype ~= "normal" then
					fire.place(pointed_thing.under)
				else
					fire.place(pointed_thing.above)
				end
			end
			return itemstack
		end
	end
})

minetest.register_tool("frontier_tools:flint_and_steel", {
	description = "Flint and Steel",
	inventory_image = "fire_flint_steel.png",
	sound = {breaks = "default_tool_breaks"},

	on_use = function(itemstack, user, pointed_thing)
		local sound_pos = pointed_thing.above or user:get_pos()
		minetest.sound_play(
			"fire_flint_and_steel",
			{pos = sound_pos, gain = 0.5, max_hear_distance = 8}
		)
		local player_name = user:get_player_name()
		if pointed_thing.type == "node" then
			local node_under = minetest.get_node(pointed_thing.under).name
			local nodedef = minetest.registered_nodes[node_under]
			if not nodedef then
				return
			end
			if minetest.is_protected(pointed_thing.under, player_name) then
				minetest.chat_send_player(player_name, "This area is protected")
				return
			end
			if not (creative and creative.is_enabled_for
				and creative.is_enabled_for(player_name)) then
				-- Wear tool
				local wdef = itemstack:get_definition()
				itemstack:add_wear(2000)
				-- Tool break sound
				if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
					minetest.sound_play(wdef.sound.breaks, {pos = sound_pos, gain = 0.5})
				end
			end
			if nodedef.on_ignite then
				nodedef.on_ignite(pointed_thing.under, user)
			elseif minetest.get_item_group(node_under, "flammable") >= 1
			and minetest.get_node(pointed_thing.above).name == "air" then
				local node_def = minetest.registered_nodes[node_under]
				if node_def.drawtype ~= "normal" then
					fire.place(pointed_thing.under)
				else
					fire.place(pointed_thing.above)
				end
			end
			return itemstack
		end
	end
})

-- Bows and Arrows

bows.register_bow("poplar_bow",{
	description = "poplar bow",
	texture = "bows_bow_poplar.png",
	texture_loaded = "bows_bow_poplar_loaded.png",
	uses = 70,
	level = 5,
})

bows.register_bow("bow_maple",{
	description = "Wooden bow",
	texture = "bows_bow.png",
	texture_loaded = "bows_bow_loaded.png",
	uses = 60,
	level = 4,
})

bows.register_bow("bow_mesquite",{
	description = "Wooden bow",
	texture = "bows_bow.png",
	texture_loaded = "bows_bow_loaded.png",
	uses = 50,
	level = 3,
})

bows.register_bow("bow_apple",{
	description = "Wooden bow",
	texture = "bows_bow.png",
	texture_loaded = "bows_bow_loaded.png",
	uses = 50,
	level = 2,
})

bows.register_bow("bow_pine",{
	description = "Wooden bow",
	texture = "bows_bow.png",
	texture_loaded = "bows_bow_loaded.png",
	uses = 50,
	level = 1,
})

-- 
bows.register_arrow("arrow",{
	description = "Arrow",
	texture = "bows_arrow_wood.png",
	damage = 8,
	drop_chance = 8,
})

bows.register_arrow("steel_arrow",{
	description = "Steel arrow",
	texture = "bows_arrow_wood.png^[colorize:#FFFFFFcc",
	damage = 12,
	drop_chance = 3,
})

bows.register_arrow("fire_arrow",{
    description = "Fire arrow",
    texture = "bows_arrow_wood.png^[colorize:#ffb400cc",
    damage = 8,
	light_source = default.LIGHT_MAX,
    drop_chance = -1,
    on_hit_node = function(self, pos, user, arrow_pos)
        bows.arrow_fire(self, pos, user, arrow_pos)
    end,
    on_hit_object=bows.arrow_fire_object,
})

bows.register_arrow("tnt_arrow", {
	description = "TNT arrow",
    texture="bows_arrow_wood.png^[colorize:#ff2000cc",
    damage = 8,
	light_source = default.LIGHT_MAX,
    drop_chance = -1,
    on_hit_node = function(self, pos, user, arrow_pos)
        tnt.boom(arrow_pos)
    end,
    on_hit_object=function(self,target,hp,user,lastpos)
		tnt.boom(lastpos)
	end,
})


dofile(minetest.get_modpath("frontier_tools") .. "/crafts.lua")