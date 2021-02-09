classes = {}
local base_classes = {"homesteader", "hunter", "prospector"}
local int_classes = {"trader", "rancher", "blacksmith"}
local adv_classes = {"doctor", "sheriff", "inventor"}
local genders = {"female", "male"}
local mp = minetest.get_modpath("classes")

dofile(mp .. "/xp.lua")
dofile(mp .. "/acheivements.lua")
local initial_items = {}

initial_items.homesteader = {"mtcoin:gold 33", "mtcoin:copper 33", "farming:hoe_steel", "farming:seed_cotton 9", "crops:watering_can","default:shovel_bronze", "default:torch 9"}
initial_items.hunter = {"mtcoin:copper 99", "frontier_trees:apple 9", "crops:pumpkin 3", "bows:arrow 9", "bows:bow_wood", "default:dagger_stone", "default:torch 9"}
initial_items.prospector = {"mtcoin:gold 66", "farming:bread", "default:torch 18", "default:pick_steel"}

local new_players = {}

function classes.get_class(player) 
	local meta = player:get_meta()
	local class = meta:get_string("class")
	local gender = meta:get_string("gender")
	return class, gender
end

local function set_skin(player)
	local meta = player:get_meta()
	local gender = meta:get_string("gender")
	local class = meta:get_string("class")

	if class == "" or gender == "" then
		return false
	end
	if class == "homesteader" then
		if gender == "male" then
			player_api.set_textures(player, {"homesteader_m.png"})
		elseif gender == "female" then
			player_api.set_textures(player, {"homesteader_f.png"})
		end
	elseif class == "hunter" then
		if gender == "male" then
			player_api.set_textures(player, {"hunter_m.png"})
		elseif gender == "female" then
			player_api.set_textures(player, {"hunter_f.png"})
		end
	elseif class == "prospector" then
		if gender == "male" then
			player_api.set_textures(player, {"prospector_m.png"})
		elseif gender == "female" then
			player_api.set_textures(player, {"prospector_f.png"})
		end
	end
end

local function set_initial_items(player)
	local name = player:get_player_name()
	local class = classes.get_class(player)
	local xp, class_xps  = classes.get_xp(name)
	class_xp = class_xps[class] or 0
	local initial_items = {}
	local function get_tool_grade(class_xp)
		local xp = class_xp
		if xp <100 then
			return "stone"
		elseif xp < 500 then
			return "tin"
		elseif xp < 1000 then 
			return "bronze"
		elseif xp < 5000 then
			return "steel"
		else
			return "obisidian"
		end
	end

	local function get_tool(class, tool_grade)
		if class == "hunter" then
			return "default:dagger_" .. tool_grade
		elseif class == "homesteader" then
			return "default:axe_" .. tool_grade
		elseif class == "prospector" then 
			return "default:pick_" .. tool_grade
		end
	end
	
	local function get_apples(xp)
		local num = math.ceil(xp/1000)
		if num < 1 then num = 1 end
		if num > 99 then num = 99 end
		return "frontier_trees:apple " .. num
	end

	local function get_gold(xp)
		local amt_gold = math.floor(0.03 * xp)
		if amt_gold < 20 then
			amt_gold = 20
		end
		return "mtcoin:gold " .. amt_gold
	end
	
	local function get_materials(xps)
		local materials = {}
		local num, metal
		for skill, xp in pairs(xps) do
			if xps[skill] > 10000 then
				num = math.min(math.ceil(xps[skill] / 1000), 99)
				if skill == "craftmanship" then
					table.insert(materials, "default:obsidian "..num)
				elseif skill == "self-sufficiency" then
					table.insert(materials, "default:maple_tree " ..num)
					table.insert(materials, "mobs_animal:cow")
				elseif skill == "deadliness" then
					table.insert(materials, "frontier_guns:bullet " .. num)
				end

			elseif xps[skill] > 5000 then
				num = math.min(math.ceil(xps[skill] / 500), 99)
				if skill == "craftmanship" then 
					table.insert(materials, "default:steel_ingot " .. num)
				elseif skill == "self-sufficiency" then
					table.insert(materials, "default:maple_tree " .. num)
					table.insert(materials, "mobs_animal:chicken")
				elseif skill == "deadliness" then
					table.insert(materials, "frontier_guns:shotgun_shell " .. num)
				end
			elseif xps[skill] > 3000 then
				num = math.min(math.ceil(xps[skill] / 300), 99)
				if skill == "craftsmanship" then
					table.insert (materials, "default:bronze_ingot " .. num)
				elseif skill == "self-sufficiency" then
					table.insert(materials, "default:maple_tree " ..num)
				elseif skill == "deadliness" then
					table.insert(materials, "default:arrow_toxic " .. num)
				end
			elseif xps[skill] > 1000 then
				num = math.min(math.ceil(xps[skill] / 100), 99)
				if skill == "craftsmanship" then 
					table.insert(materials, "default:tin_ingot " .. num)
				elseif skill == "self-sufficiency" then
					table.insert(materials, "default:maple_wood " .. num)
				elseif skill == "deadliness" then
					table.insert(materials, "bows:arrow_gold " .. num)
				end
			elseif xps[skill] > 100 then
				num = math.min(math.ceil(xps[skill] / 10), 99)
				if skill == "craftsmanship" then
					table.insert(materials, "default:stone " .. num)
				elseif skill == "self-sufficiency" then
					table.insert(materials, "default:stick " ..num)
				elseif skill == "deadliness" then
					table.insert(materials, "bows:arrow_steel " ..num)
				end
			end
			for i, material in ipairs(materials) do
				table.insert(initial_items, material)
			end
		end
	end

	local function get_bonus(class_xp)
		local xp = class_xp
		if xp == nil then xp = 0 end
		local items = {}
		if class == "hunter" then
			local arrow = "bows:arrow"
			if xp > 10000 then
				arrow = arrow .. "_obsidian"
			elseif xp > 5000 then
				arrow = arrow .. "_toxic"
			elseif xp > 3000 then
				arrow = arrow .. "_gold"
			elseif xp > 1000 then
				arrow = arrow .. "_steel"
			end
			if xp > 100 then
				items[#items + 1] = arrow .. " " .. math.ceil(0.03 * xp)
			end
			
			items[#items + 1] = "bows:bow_wood"

		elseif class == "homesteader" then
			local hoe = "farming:hoe_"
			if xp > 5000 then 
				hoe = hoe .. "steel"
			elseif xp > 1000 then 
				hoe = hoe .. "bronze"
			else
				hoe = hoe .. "wood"
			end
			items[#items + 1] = hoe

			local num = math.ceil(0.01 * xp)
			local num_buckets = num
			if num > 9 then
				num_buckets = 9
			end
			if num >= 1 then
				items[#items + 1] = "bucket:bucket_empty " .. num_buckets
			end

			local num_seeds = num
			if num_seeds > 99 then
				num_seeds = 99
			elseif num_seeds < 3 then
				num_seeds = 3
			end
			items[#items + 1] = "farming:seed_wheat " .. num_seeds
			items[#items + 1] = "farming:seed_cotton " .. num_seeds
			
		elseif class == "prospector" then
			items[#items + 1] = "default:furnace"
			num_torches = math.floor(0.1 * xp)
			if num_torches > 0 then
				if num_torches > 90 then
					num_torches = 90
				end
				items[#items + 1] = "default:torch " .. num_torches
			end
				
		end
		for i, item in ipairs(items) do
			table.insert(initial_items, item)
		end
		
	end
	
	table.insert(initial_items, get_tool(class, get_tool_grade(class_xp)))
	table.insert(initial_items, get_apples(xp))
	table.insert(initial_items, get_gold(xp))
	get_bonus(xp)
	get_materials(class_xps)
	initial_items[#initial_items + 1] = "default:torch 9"

	return initial_items
end

local function give_initial_items(player)
	local name = player:get_player_name()
	local inv = minetest.get_inventory({type="player", name = name})
	local initial_items = set_initial_items(player)
	for _, itemstring in ipairs(initial_items) do
		minetest.chat_send_player(name, itemstring.." added to inv")
		local stack = ItemStack(itemstring)
		if minetest.get_item_group(stack:get_name(), "coin") == 1 then
			if string.match(itemstring, "gold") then
				inv:set_stack("purse", 1, stack)
			elseif string.match(itemstring, "copper") then
				inv:set_stack("purse", 2, stack)
			end
		else
			inv:add_item("main", stack)
		end
	end
end

local function make_formspec(player)
	local formspec = ""
	local meta = player:get_meta()
	local gender = meta:get_string("gender")
	local class = meta:get_string("class")

	if gender == "" or class == "" then
		formspec = "label[0,0.5;Please Choose an identity to receive your initial items.]"
	else
		formspec = "label[0,0.5;Current Identity: Class: "..class.." Gender: "..gender.."]"
	end

	formspec = formspec ..
		"label[1,1;Gender]"..
		"button[1,1.5;3,1;female;Female]"..
		"button[4,1.5;3,1;male;Male]"..
		"label[1,3;Class]"..
		"button[1,3.5;2,1;homesteader;Homesteader]"..
		"button[3,3.5;2,1;hunter;Hunter]"..
		"button[5,3.5;2,1;prospector;Prospector]"

	return formspec
end

local function on_receive_fields(player, fields)
	local meta = player:get_meta()
	local new_player = false
	local class = meta:get_string("class")
	if class == "" then
		new_player = true
	end

	if fields.male then
		meta:set_string("gender", "male")
	end
	if fields.female then
		meta:set_string("gender", "female")
	end
	if fields.homesteader then
		meta:set_string("class", "homesteader")
	end
	if fields.hunter then
		meta:set_string("class", "hunter")
	end
	if fields.prospector then
		meta:set_string("class", "prospector")
	end
	class = meta:get_string("class")
	local gender = meta:get_string("gender")
	if new_player == true and class ~= "" then 
		give_initial_items(player)
	end
	if class ~= "" and gender ~= "" then
		minetest.close_formspec(player:get_player_name(), "identity:initial")
	end
	set_skin(player)
end

minetest.register_on_joinplayer(function(player)
	local identity = set_skin(player)
	if identity ~= false then
		return
	end
	
	minetest.after(1, function() 
		local formspec = "size[8,7.5]" .. make_formspec(player)
		minetest.show_formspec(player:get_player_name(), "identity:initial", formspec)
	end)
end)

minetest.register_on_dieplayer(function(player)
	local meta = player:get_meta()
	local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	
	--for list_name, list in pairs(inv:get_lists()) do
	--	if list_name ~= "badges" then
	--		for i = 1, inv:get_size(list_name) do
	--			local stack = inv:get_stack(list_name, i)
	--			local n = stack:get_count()
	--			stack:take_item(n)
	--			inv:set_stack(list_name, i, stack)
	--		end
	--	end
	--end
	--local storage = meta:get_string("storage")
	--if storage ~= "" then
	--	storage = minetest.deserialize(storage)
	--	for _, pos in ipairs(storage) do
	--		local node = minetest.get_node(pos)
	--		minetest.set_node(pos, {name = node.name, param2 = node.param2})
	--	end
	--	meta:set_string("storage", "")
	--end
	meta:set_string("class", "") 
	meta:set_string("gender", "")
end)

minetest.register_on_respawnplayer(function(player)
	local meta = player:get_meta()
	if meta:get_string("class") ~= "" then
		return
	end
	local formspec = "size[8,7.5]" .. make_formspec(player)
	minetest.show_formspec(player:get_player_name(), "identity:initial", formspec)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "identity:initial" then
		on_receive_fields(player, fields)
	end
	return
end)

sfinv.register_page("identity:inv", {
	title = "Identity",
	get = function(self, player, context)
		local formspec = make_formspec(player)
		return sfinv.make_formspec(player, context, formspec, true)
	end,
	is_in_nav = function(self, player, context)
		local class, gender = classes.get_class(player)
		if class == "" or gender == "" then
			return true
		end
		return false
	end,
	on_player_receive_fields = function(self, player, context, fields)
		on_receive_fields(player, fields)
	end
})
