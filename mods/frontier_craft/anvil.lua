adv_craft.anvil = {}
adv_craft.anvil.recipes = {}
		local formspec = "size[8,9]" ..
			"label[1.5,0;Available crafts based on player's skill and inventory]" ..
			--"list[detached:anvil;in;3.5,1;1,1;]" ..
			--"label[3.35,2;Place ingots]" ..
			"list[detached:anvil;out;1.5,1;5,3;]" ..
			"list[current_player;main;0,5;8,4;]"

function adv_craft.anvil.register_craft(output, inputs)
	adv_craft.anvil.recipes[output] = inputs
end

local function can_craft(player, inputs)
	if type(inputs) == "table" then
		for i, item in ipairs(inputs) do
			if not adv_craft.player_has_item(player, item) then
				return false
			end
		end
	elseif type(inputs) == "string" then
		if not adv_craft:player_has_item(player, item) then
			return false
		end
	end
	return true
end

local function clear_anvil()
	local anv_inv = minetest.get_inventory({type = "detached", name = "anvil"})
	for n = 1, anv_inv:get_width("out") do
		local stack = anv_inv:get_stack("out", n)
		stack:take_item(stack:get_count())
		anv_inv:set_stack("out", n, stack)
	end
end

function adv_craft.anvil.predict_craft(pos, clicker)
	local anv_inv = minetest.get_inventory({type = "detached", name = "anvil"})
	clear_anvil()
	for k,v in pairs(adv_craft.anvil.recipes) do
		if can_craft(clicker, v) then	
			anv_inv:add_item("out", k)
		end
	end
end

minetest.register_node("adv_craft:anvil", {
	description = "Anvil for crafting and repairing tools",
	drawtype = "nodebox",
	tiles = {"default_steel_block.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
        	type = "fixed",
        	fixed = {
                        {-0.5,-0.5,-0.3,0.5,-0.4,0.3},
                        {-0.35,-0.4,-0.25,0.35,-0.3,0.25},
                        {-0.3,-0.3,-0.15,0.3,-0.1,0.15},
                        {-0.35,-0.1,-0.2,0.35,0.1,0.2},
                },
        },
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.5,-0.5,-0.3,0.5,-0.4,0.3},
                        {-0.35,-0.4,-0.25,0.35,-0.3,0.25},
                        {-0.3,-0.3,-0.15,0.3,-0.1,0.15},
                        {-0.35,-0.1,-0.2,0.35,0.1,0.2},
                }
        },
	groups = {cracky = 2},
	on_rightclick = function(pos, node, clicker)
		anvil_inv = minetest.create_detached_inventory("anvil", {
				allow_move = function()
					return 0
				end,
				allow_put = function(inv, listname, index, stack, player)
					return 0
				end,
				allow_take = function()
					return 1
				end,
				on_take = function(inv, listname, index, stack, player)
				--remove inputs from player inv and reload outputs	
					local key = stack:get_name()
					local inputs = adv_craft.anvil.recipes[key]
					local player_inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
					if type(inputs) == "table" then
						for i, item in ipairs(inputs) do
							player_inv:remove_item("main", item)
						end
					elseif type(inputs) == "string" then
						player_inv:remove_item("main", inputs)
					end
					adv_craft.anvil.predict_craft(pos, player)
					minetest.sound_play({name="anvil_clang"}, {pos=player:get_pos()})
					minetest.close_formspec(player:get_player_name(), player:get_player_name()..":anvil", formspec)
				end,
			}, 
			clicker:get_player_name()
		)
		anvil_inv:set_size("out", 15)
		adv_craft.anvil.predict_craft(pos,clicker)
		minetest.show_formspec(clicker:get_player_name(), clicker:get_player_name()..":anvil", formspec)
	end,
})

function adv_craft.anvil.register_toolset_craft(material)
	local craft_material = "default:"..material.."_ingot"
	local tools = {
		--{toolname, number of craft material required}
		{"frontier_tools:" .. material .. "_knife", 1},
		{"frontier_tools:" .. material .. "_pick", 3},
		{"frontier_tools:" .. material .. "_axe", 3},
		{"frontier_tools:" .. material .. "_shovel", 1},
		{"frontier_tools:" .. material .. "_hoe", 2},
	}
	for n = 1, #tools do
		adv_craft.anvil.register_craft(
			tools[n][1], 
			{"default:stick", craft_material .. " " .. tools[n][2]}
		)
	end
end

--adv_craft.anvil.register_toolset("tin")
--adv_craft.anvil.register_toolset("bronze")
--adv_craft.anvil.register_toolset("steel")

--adv_craft.anvil.register_craft("default:pick_steel", {"default:steel_ingot 3", "default:stick"})


