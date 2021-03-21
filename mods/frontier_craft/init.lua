craft = {}
craft.recipes = {}

local mp = minetest.get_modpath("craft")

-- API --
function craft.register_craft(craft_type, output, inputs) 
	--assert(minetest.registered_items[output] or minetest.registered_nodes[output] or minetest.registered_tools[output], "Not a valid craft output")
	if not craft.recipes[craft_type] then
		craft.recipes[craft_type] = {}
		craft.recipes[craft_type]["total"] = 0
	end
	craft.recipes[craft_type][output] = inputs
	craft.recipes[craft_type]["total"] = craft.recipes[craft_type]["total"] + 1
end

function craft.player_has_item(player, itemstring)
	local stack = ItemStack(itemstring)
	local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	if not inv:contains_item("main", stack) then
		return false
	end
	return true
end

function craft.can_craft(player, inputs)
	if type(inputs) == "table" then
		for i, item in ipairs(inputs) do
			if not craft.player_has_item(player, item) then
				return false
			end
		end
	elseif type(inputs) == "string" then
		if not craft:player_has_item(player, item) then
			return false
		end
	end
	return true
end

function craft.load_crafts(pos, player, craft_type)
	local player_name = player:get_player_name()
	local inv = minetest.get_inventory({type = "detached", name = player_name .. "_" .. craft_type})
	local size = craft.recipes[craft_type]["total"]
	if inv:get_size("out") == 0 then
		inv:set_size("out", size)
	end
	-- Clear craft inventory
	for n = 1, inv:get_width("out") do
		local stack = inv:get_stack("out", n)
		stack:take_item(stack:get_count())
		inv:set_stack("out", n, stack)
	end
	-- Add possible crafts
	for output, inputs in pairs(craft.recipes[craft_type]) do
		if craft.can_craft(player, inputs) and output ~= "total" then
			inv:add_item("out", output)
		end
	end
end

function craft.on_fail(player, craft_type)
	minetest.sound_play(craft_type .. "_fail", {
        pos = player:get_pos(),
        gain = 1.0,  -- default
        max_hear_distance = 24,  -- default, uses an euclidean metric
    	},
	true)
end

function craft.on_craft(player, craft_type)
	-- Sound file name must match craft_type
	minetest.sound_play(craft_type, {
        pos = player:get_pos(),
        gain = 1.0,  -- default
        max_hear_distance = 24,  -- default, uses an euclidean metric
    	},
		true
	)
end

function craft.do_craft(player, craft_type, stack)
	local inv = player:get_inventory()
	local craft_name = stack:get_name()
	local recipe = craft.recipes[craft_type][craft_name]
	
	if type(recipe) == "table" then
		for _, item in ipairs(recipe) do
			inv:remove_item("main", ItemStack(item))
		end
	else inv:remove_item("main", ItemStack(recipe))
	end
	
	inv:add_item("main", stack)
	craft.on_craft(player, craft_type)
end

function craft.build_formspec(player, craft_type)
	local formspec = ""
	local formspec_table = {}
	local recipes = craft.recipes[craft_type]
	if recipes == nil then
		return
	end

	local player_name = player:get_player_name()
	local num_recipes = craft.recipes[craft_type]["total"]
	local inv = minetest.create_detached_inventory(player_name.."_"..craft_type , {
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
			local item_name = stack:get_name()
			local inputs = craft.recipes[craft_type][item_name]
			local player_inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
			-- Check for changes in inventory before processing craft
			if not craft.can_craft(player, inputs) then
				return 0
			end
			-- Process craft
			if type(inputs) == "table" then	local item_name = stack:get_name()
				local inputs = craft.recipes[craft_type][item_name]
				local player_inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
				if type(inputs) == "table" then
						for i, item in ipairs(inputs) do
								player_inv:remove_item("main", item)
						end
				elseif type(inputs) == "string" then
						player_inv:remove_item("main", inputs)
				end
				craft.load_crafts(pos, player, craft_type)
				minetest.sound_play({name=craft_type}, {pos=player:get_pos()})
			
					for i, item in ipairs(inputs) do
							player_inv:remove_item("main", item)
					end
			elseif type(inputs) == "string" then
					player_inv:remove_item("main", inputs)
			end
			craft.load_crafts(pos, player, craft_type)
			minetest.sound_play({name=craft_type}, {pos=player:get_pos()})
			--minetest.close_formspec(player:get_player_name(), player:get_player_name()..":anvil", formspec)
		end,
		},
		player:get_player_name()
	)

	craft.load_crafts(pos, player, craft_type)
	table.insert(formspec_table, "label[0,0;Crafts: ".. craft_type .. "]")
	local crafts = "list[detached:" .. player_name.."_"..craft_type..";out;0,1;8,3;]"
	table.insert(formspec_table, crafts)
	if craft_type ~= "hand" then
		local craft_height = math.ceil(num_recipes/8)
		table.insert(formspec_table, 1, "size[8," .. craft_height + 6 .. "]")
		table.insert(formspec_table, "list[current_player;main;0," .. craft_height + 2 ..";8,4;]")
	end
	
	formspec = table.concat(formspec_table)
	return formspec
end

-- Crafting types
dofile(mp .. "/materials.lua")
dofile(mp .. "/hand.lua")
dofile(mp .. "/mill.lua")
dofile(mp .. "/lighting.lua")
dofile(mp .. "/anvil.lua")

-- Handle fields from crafting formspecs
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local craft_type = formname
	local stack
	
	if craft_type == "" then
		craft_type = "hand"
	end

	if not craft.recipes[craft_type] then
		return
	end

	if fields["quit"] or fields["sfinv_nav_tabs"] then
		return
	end
	
	for k, v in pairs(fields) do
		print(k)
		stack = ItemStack(k)
		if stack ~= nil then
			break
		end
	end

	if not stack then
		return
	end

	if not craft.can_craft(player, craft.recipes[craft_type][stack:get_name()]) then
		return craft.on_fail(player, craft_type)
	end
	-- Crafted item goes to player inventory
	craft.do_craft(player, craft_type, stack)
end)