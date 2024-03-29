ts_furniture = {}

-- If true, you can sit on chairs and benches, when right-click them.
ts_furniture.enable_sitting = true

-- The following code is from "Get Comfortable [cozy]" (by everamzah; published under WTFPL).
-- Thomas S. modified it, so that it can be used in this mod
minetest.register_globalstep(function(dtime)
	local players = minetest.get_connected_players()
	for i = 1, #players do
		local name = players[i]:get_player_name()
		if default.player_attached[name] and not players[i]:get_attach() and
				(players[i]:get_player_control().up == true or
						players[i]:get_player_control().down == true or
						players[i]:get_player_control().left == true or
						players[i]:get_player_control().right == true or
						players[i]:get_player_control().jump == true) then
			players[i]:set_eye_offset({ x = 0, y = 0, z = 0 }, { x = 0, y = 0, z = 0 })
			players[i]:set_physics_override(1, 1, 1)
			default.player_attached[name] = false
			default.player_set_animation(players[i], "stand", 30)
		end
	end
end)


ts_furniture.sit = function(name, pos)
	local player = minetest.get_player_by_name(name)
	if default.player_attached[name] then
		player:set_eye_offset({ x = 0, y = 0, z = 0 }, { x = 0, y = 0, z = 0 })
		player:set_physics_override(1, 1, 1)
		default.player_attached[name] = false
		default.player_set_animation(player, "stand", 30)
	else
		player:moveto(pos)
		player:set_eye_offset({ x = 0, y = -5, z = 2 }, { x = 0, y = 0, z = 0 })
		player:set_physics_override(0, 0, 0)
		default.player_attached[name] = true
		default.player_set_animation(player, "sit", 30)
	end
end
-- end of cozy-code

local furnitures = {
	["chair"] = {
		description = "Chair",
		sitting = true,
		nodebox = {
			{ -1/4, -0.5, 5/16, -5/16, 0.5, 3/16 }, -- foot 1
			{ 5/16, -0.5, 5/16, 1/4, 0.5, 3/16 }, -- foot 2
			{ 5/16, -0.5, -3/16, 1/4, -1/16, -5/16 }, -- foot 3
			{ -1/4, -0.5, -1/4, -5/16, -1/16, -5/16 }, -- foot 4
			{ -5/16, -1/16, -3/8, 5/16, 0, 1/4 }, -- seating
			--{ -3/16, 1/16, 3/16, 3/16, 1/8, 1/4 }, -- conector 1-2
			{ -1/4, 3/8, 3/16, 1/4, 7/16, 1/4 }, -- conector 1-2
			{ -3/16, 0, 3/16, -1/8, 3/8, 1/4 }, -- conector 1-2
			{ 3/16, 0, 3/16, 1/8, 3/8, 1/4 }, -- conector 1-2
			{ -1/16, 0, 3/16, 1/16, 1/2, 1/4 } -- conector 1-2
		},
		craft = function(recipe)
			return {
				{ "", "group:stick" },
				{ recipe, recipe },
				{ "group:stick", "group:stick" }
			}
		end,
		burntime = 17,
	},
	["table"] = {
		description = "Table",
		nodebox = {
			{ -0.4, -0.5, -0.4, -0.3, 0.4, -0.3 }, -- foot 1
			{ 0.3, -0.5, -0.4, 0.4, 0.4, -0.3 }, -- foot 2
			{ -0.4, -0.5, 0.3, -0.3, 0.4, 0.4 }, -- foot 3
			{ 0.3, -0.5, 0.3, 0.4, 0.4, 0.4 }, -- foot 4
			{ -0.5, 0.4, -0.5, 0.5, 0.5, 0.5 }, -- table top
		},
		craft = function(recipe)
			return {
				{ recipe, recipe, recipe },
				{ "group:stick", "", "group:stick" },
				{ "group:stick", "", "group:stick" }
			}
		end,
		burntime = 25,
	},
	["bench"] = {
		description = "Bench",
		sitting = true,
		nodebox = {
			{ -0.5, -0.1, 0, 0.5, 0, 0.5 }, -- seating
			{ -0.4, -0.5, 0, -0.3, -0.1, 0.5 }, -- foot 1
			{ 0.3, -0.5, 0, 0.4, -0.1, 0.5 }, -- foot 2
		},
		craft = function(recipe)
			return {
				{ recipe, recipe },
				{ "group:stick", "group:stick" }
			}
		end,
		burntime = 16,
	},
	["ladder"] = {
		description = "Ladder",
		--inventory_image = "default_ladder_wood.png",
		--walkable = false,
		climbable = true,
		nodebox = {
			-- Rails
			{-1/2, 1/2, 1/2, -7/16, -1/2, 5/16},
			{1/2, 1/2, 1/2, 7/16, -1/2, 5/16},
			-- Rungs
			{ -1/2, 1/4, 7/16, 1/2, 5/16, 3/8},
			{-1/2, -3/16, 7/16, 1/2, -1/4, 3/8},
		},
		groups = {choppy = 3, oddly_breakable_by_hand = 3, flammable = 2},
		craft = function(recipe)
			return {
				{ "group:stick", "", "group:stick"},
				{ "group:stick", recipe, "group:stick"},
				{ "group:stick", "", "group:stick"},
			}
		end,
		burntime = 10,
	},
	["cabinet"] = {
		description = "Cabinet",
		nodebox = {
			{1/2, 1/2, 1/2, -1/2, 7/16, -1/2},
			{1/2, 7/16, 1/2, -1/2, -1/2, -3/8},
			{7/16, 3/8, -3/8, 1/16, -3/8, -7/16},
			{-7/16, 3/8, -3/8, -1/16, -3/8, -7/16},
			{1/8, 1/8, -7/16, 1/16, -1/8, -1/2},
			{-1/8, 1/8, -7/16, -1/16, -1/8, -1/2},

		},
		storage = 32,
		groups = {choppy = 2, flammable = 2},
		toggle = true,
		toggle_nodebox = {
		--	Horizontal Panels
			{1/2, 1/2, 1/2, -1/2, 7/16, -1/2},
			{7/16, -1/16, 7/16, -7/16, 0, -5/16},
			{7/16, -1/2, 7/16, -7/16, -3/8, -3/8},
		-- 	Vertical Panels
			{1/2, 7/16, 1/2, 7/16, -1/2, -3/8},
			{-1/2, 7/16, 1/2, -7/16, -1/2, -3/8},
			{-7/16, 7/16, 7/16, 7/16, -1/2, 1/2},
			{-1/16, 7/16, -3/8, 1/16, -3/8, -5/16},  
		--	Doors
			{3/8, 3/8, -6/16, 7/16, -3/8, -12/16},
			{-3/8, 3/8, -6/16, -7/16, -3/8, -12/16},
			{1/2, 1/8, -11/16, 7/16, -1/8, -3/4},
			{-1/2, 1/8, -11/16, -7/16, -1/8, -3/4},
			
		},
		craft = function(recipe)
			return{
				{recipe, "", recipe},
				{recipe, "", recipe},
				{recipe, "", recipe},
			}
		end,
		burntime = 30
	},
}

local ignore_groups = {
	["wood"] = true,
	["stone"] = true,
}

function ts_furniture.register_defintion(name, def)
	furnitures[name] = def
end

function ts_furniture.register_furniture(recipe, description, texture)
	local recipe_def = minetest.registered_items[recipe]
	if not recipe_def then
		return
	end

	local groups = {}
	for k, v in pairs(recipe_def.groups) do
		if not ignore_groups[k] then
			groups[k] = v
		end
	end

	for furniture, def in pairs(furnitures) do
		local node_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_" .. furniture

		def.on_rightclick = nil
		
		if def.sitting and ts_furniture.enable_sitting then
			def.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				ts_furniture.sit(player:get_player_name(), pos)
			end
		elseif def.storage and def.toggle then
			local slots = def.storage
			if type(slots) ~= "number" then slots = 32 end
			local rows = math.max(slots/8)
			
			def.on_construct = function(pos)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory():set_size("main", slots)
			end
			
			def.can_dig = function(pos)
				local inv = minetest.get_meta(pos):get_inventory()
				if inv:is_empty("main") then
					return true
				end
				return false
			end

			def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				local name = clicker:get_player_name()
				local meta = minetest.get_meta(pos)
				local state = minetest.get_node(pos)
				if minetest.is_protected(pos, name) == true then
					return
				end
				local formspec = 
					"size[".. tostring(4+rows) .. ",9]" ..
					"list[nodemeta:"..pos.x..","..pos.y..","..pos.z .. ";main;0,0;8,".. tostring(rows) ..";]"..
					"list[current_player;main;0,"..tostring(rows + 1) ..";8,4;]"..
					"listring[]"
				if state.name == node_name:gsub("_open","_closed") then
					minetest.swap_node(pos, {name = node_name:gsub("_closed", "_open"), param2 = state.param2})
					minetest.show_formspec(name, "furniture_"..minetest.pos_to_string(pos), formspec)
				else
					minetest.swap_node(pos, {name = node_name:gsub("_open", "_closed"), param2 = state.param2})

					--minetest.show_formspec(name, "furniture_"..minetest.pos_to_string(pos), formspec)
				end
			end
		end
		
		local node_def = {}	
		node_def.description = description .. " " .. def.description
		node_def.drawtype = "nodebox"
		node_def.climbable = def.climbable or nil
		node_def.paramtype = "light"
		node_def.paramtype2 = "facedir"
		node_def.sunlight_propagates = true
		node_def.tiles = { texture }
		node_def.groups = groups
		node_def.node_box = {
			type = "fixed",
			fixed = def.nodebox
		}
		if def.on_construct then 
			node_def.on_construct = def.on_construct
		end

		if def.on_rightclick then
			node_def.on_rightclick = def.on_rightclick
		end

		if def.can_dig then
			node_def.can_dig = def.can_dig
		end
		if def.toggle then
			local nn1 = node_name .."_closed"
			local nn2 = node_name .. "_open"
			minetest.register_node(":" .. nn1, node_def)
			node_def2 = {}
			for k, v in pairs(node_def) do
				if node_def2[k] == nil then
					node_def2[k] = v
				end
			end
			node_def2.drop = nn1
			--node_def2.groups["not_in_creative_inventory"] = 1
			node_def2.node_box.fixed = def.toggle_nodebox
			minetest.register_node(":" .. nn2, node_def2)
			node_name = nn1
		else
			minetest.register_node(":" .. node_name, node_def)
		end


		minetest.register_craft({
			output = node_name,
			recipe = def.craft(recipe)
		})

		if def.burntime then
			minetest.register_craft({
				type = "fuel",
				recipe = node_name,
				burntime = def.burntime
			})
		end
	end
end

ts_furniture.register_furniture("default:pine_wood", "Pine", "default_pine_wood.png")
ts_furniture.register_furniture("frontier_trees:apple_wood", "Apple", "frontier_trees_apple_wood.png")
ts_furniture.register_furniture("frontier_trees:maple_wood", "Maple", "frontier_trees_maple_wood.png")
ts_furniture.register_furniture("frontier_trees:cypress_wood", "Cypress", "frontier_trees_cypress_wood.png")
ts_furniture.register_furniture("frontier_trees:mesquite_wood", "Mesquite", "frontier_trees_mesquite_wood.png")
ts_furniture.register_furniture("frontier_trees:poplar_wood", "Poplar", "frontier_trees_poplar_wood.png")

