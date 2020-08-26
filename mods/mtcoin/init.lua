mtcoin = {}
local materials = {["gold"] = "#F7D827", ["copper"] = "#C98949"}

for k, v in pairs(materials) do 
	minetest.register_craftitem("mtcoin:"..k, {
		description = k.. " coin",
		inventory_image = "mtcoin_inv.png^[colorize:" .. v .. ":120",
		wield_image = "mtcoin.png^[colorize:"..v..":120",
		stack_max = 99999,
		groups = {coin = 1},
		wield_scale = {x = 0.5, y=0.5, z = 0.25}
	})
end

local gold_img = minetest.registered_items["mtcoin:gold"].inventory_image
local copper_img = minetest.registered_items["mtcoin:copper"].inventory_image

local function create_purse(player)
	local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	inv:set_size("purse", 2)
	inv:set_size("to_trade", 1)
	inv:set_size("price", 1)
	inv:set_size("for_trade", 8)
	inv:set_size("price_list", 8)
end

minetest.register_on_newplayer(function(player)
	create_purse(player)
end)

function mtcoin.coin_to_xp(coin_stack)
	local stack = coin_stack
	local xp = 0
	if stack:get_name() == "mtcoin:gold" then
		xp = 3 * stack:get_count()
	elseif stack:get_name() == "mtcoin:copper" then
		xp = stack:get_count()
	end
	return xp
end

local function refresh_trade_inventory(player,buyer)
	local meta = player:get_meta()
	local trade_list = minetest.deserialize(meta:get_string("trade_list"))
	local inv = minetest.create_detached_inventory("temp",nil, player:get_player_name())
	inv:set_size("trade_list", 8)
	inv:set_size("price_list", 8)
	local n = 1
	for _, trade in ipairs(trade_list) do
		local stack = ItemStack(trade.stack)
		local price = ItemStack(trade.price)
		inv:set_stack("trade_list", n, stack)
		inv:set_stack("price_list", n, price)
		n = n + 1
	end
	local new_trade_list = inv:get_list("trade_list")
	local new_price_list = inv:get_list("price_list")
	local player_inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	player_inv:set_list("for_trade", new_trade_list)
	player_inv:set_list("price_list", new_price_list)
	if buyer then
		local buyer_inv = minetest.get_inventory({type = "player", name = buyer:get_player_name()})
		buyer_inv:set_list("to_buy", new_trade_list)
		buyer_inv:set_list("to_pay", new_price_list)
	end
	minetest.remove_detached_inventory("temp")
end

minetest.register_on_respawnplayer(function(player)
	local meta = player:get_meta()
	meta:set_string("trade_list", "")
end)

minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
	local info = inventory_info
	if info.stack then
		local stackname = info.stack:get_name()
		if action == "take" then
			if info.listname == "for_trade" then
				return 0
			end
			if minetest.get_item_group(stackname, "coin") == 1 then
				return 0
			end
		end
	elseif action == "move" then
		if info.from_list == "purse"
		or info.from_list == "price" or info.to_list == "price"
		or info.from_list == "price_list" or info.to_list == "price_list"
		or info.from_list == "to_pay" or info.to_list == "to_pay"
		or info.from_list == "to_buy" or info.to_list == "to_buy"
		or info.to_list == "for_trade" then 
			return 0
		elseif info.from_list == "main" and info.to_list == "purse" then
			local i = info.from_index
			local stackname = inventory:get_stack("main", i):get_name()
			if minetest.get_item_group(stackname, "coin") == 0 then
				return 0
			end
		elseif info.from_list == "for_trade" then
			if info.to_list == "main" then
				local from_stack = inventory:get_stack("for_trade", info.from_index)
				local to_stack = inventory:get_stack("main", info.to_index)
				if from_stack:get_name() ~= to_stack:get_name() and not to_stack:is_empty() and not info.count == from_stack:get_count() then
					return 0
				else
					return 99 
				end
			elseif info.to_list ~= "to_trade" then
				return 0
			end
		end
	end
end)

minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
	local info = inventory_info
	if info.stack then
		local stackname = info.stack:get_name()
		if minetest.get_item_group(stackname, "coin") == 1 then
			inventory:remove_item("main", info.stack)
			inventory:add_item("purse", info.stack)
		end
	elseif action == "move" and info.from_list == "for_trade" then
		local inv = inventory
		local from_stack = inv:get_stack(info.from_list, info.from_index)
		inv:add_item("main", from_stack)	
		local meta = player:get_meta()
		local trade_list = minetest.deserialize(meta:get_string("trade_list"))
		table.remove(trade_list, info.from_index)
		meta:set_string("trade_list", minetest.serialize(trade_list))
		refresh_trade_inventory(player)
	end
end)

sfinv.register_page("mtcoin:purse", {
	title = "Trade",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context,
			"label[0,0;Your Funds]"..	
			"list[current_player;purse;0,0.5;2,1;]"..
			"button[0,1.25;1,1;left;<]button[1,1.25;1,1;right;>]"..
			"label[4,0;Add Item for Trade]"..
			"button[3,2;2,1;add;Add]"..
			"button[5,2;2,1;cancel;Cancel]"..
			"label[2.65,1.5;Place Stack Here]label[5,1.5;Click Buttons to Set Price]"..
			"list[current_player;to_trade;3,0.5;1,1]"..
			"list[current_player;price;5,0.5;1,1]"..
			"item_image_button[6,0.5;1,1;mtcoin:gold;gold;]"..
			"item_image_button[7,0.5;1,1;mtcoin:copper;copper;]"..
			"label[0,2.5;Items for Trade]"..
			"list[current_player;for_trade;0,3;8,1]"..
			"label[0,4;Move items out to remove them from your trade list]",
			true
		)
	end,
	on_player_receive_fields = function(self, player, context, fields)
		local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
		local gold = "mtcoin:gold 1"
		local copper = "mtcoin:copper 3"
		if fields.left then
			if inv:contains_item("purse", copper) then	
				inv:remove_item("purse", copper)
				inv:add_item("purse", gold)
			end
		elseif fields.right then
			if inv:contains_item("purse", gold) then
				inv:remove_item("purse", gold)
				inv:add_item("purse", copper)
			end
		elseif fields.gold or fields.copper then
			copper = "mtcoin:copper 1"
			if fields.gold then
				inv:add_item("price", gold)
			elseif fields.copper then
				inv:add_item("price",copper)
			end
		elseif fields.cancel then
			local stack = inv:get_stack("to_trade", 1)
			local price = inv:get_stack("price", 1)
			inv:remove_item("price", price)
			inv:remove_item("to_trade", stack)
			inv:add_item("main", stack)
			
		elseif fields.add then
			local stack = inv:get_stack("to_trade", 1)
			local price = inv:get_stack("price", 1)
			if stack:get_name() == "" or price:get_name() == "" then
				return
			end
			local trade_list = {}
			local meta = player:get_meta()
			local trade_list_string = meta:get_string("trade_list")
			if trade_list_string ~= "" then
				trade_list = minetest.deserialize(trade_list_string)
			end
			if #trade_list == 8 then
				return
			end
			local trade = {["stack"] = stack:to_string(), ["price"] = price:to_string()}
			table.insert(trade_list, trade)
			meta:set_string("trade_list", minetest.serialize(trade_list))
			inv:remove_item("to_trade", stack)
			inv:remove_item("price", price)
			refresh_trade_inventory(player)
		end
	end,
})

minetest.register_chatcommand("trade", {
	params = "<player name>",
	description = "Open interface to trade with nearby players.",
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		local trader_name = params
		if trader_name == "" then
			trader_name = name
		end
--		TODO replace player_is_online with is_nearby
		local player_is_online = false
		for _, player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			if trader_name == name then
				player_is_online = true
				break
			end
		end
		if not player_is_online then
			return
		end
		--local obs = minetest.get_objects_inside_radius(player:get_pos(), 5)
		--[[for _, obj in ipairs(obs) do
			if minetest.is_player(obj) then
				local obj_name = obj:get_player_name()
				if obj_name == trader_name then
					break
				end
			end
			return
		end]]--
		local trader = minetest.get_player_by_name(trader_name)
		local meta = trader:get_meta()
		local trade_list = minetest.deserialize(meta:get_string("trade_list"))
		local buyer_inv = minetest.get_inventory({type="player", name = name})
		local trader_inv = minetest.get_inventory({type="player", name = trader_name})
		local to_buy_list = trader_inv:get_list("for_trade")
		local price_list = trader_inv:get_list("price_list")
		buyer_inv:set_list("to_buy", to_buy_list)
		buyer_inv:set_list("to_pay", price_list)
		local formspec = 
			"size[8,9]" ..
			"label[1.5,0.25;Your Funds]"..	
			"list[current_player;purse;3,0;2,1;]"..
			"button[3,1;1,1;left;<]button[4,1;1,1;right;>]"..
			"label[0,1.5;"..trader_name.."'s items for trade:]"..
			"list[current_player;to_buy;0,2;8,1]"..
			"list[current_player;to_pay;0,3;8,1]"..
			"list[current_player;main;0,5;8,4]"
		local x,y = 0, 4
		for n = 1, 8 do
			local append = 
				"button["..x..","..y..";1,1;buy"..n..";buy]"
			formspec = formspec .. append
			x = x + 1
		end
		minetest.show_formspec(name, trader_name, formspec)
	end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if not minetest.player_exists(formname) then
		return
	end
	local trader = minetest.get_player_by_name(formname)
	local trader_meta = trader:get_meta()
	local trade_list = minetest.deserialize(trader_meta:get_string("trade_list"))
	local trader_inv = minetest.get_inventory({type = "player", name = trader:get_player_name()})
	local buyer_inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	local gold = "mtcoin:gold 1"
	local copper = "mtcoin:copper 3"
	if fields.left then
		if buyer_inv:contains_item("purse", copper) then	
			buyer_inv:remove_item("purse", copper)
			buyer_inv:add_item("purse", gold)
		end
	elseif fields.right then
		if buyer_inv:contains_item("purse", gold) then
			buyer_inv:remove_item("purse", gold)
			buyer_inv:add_item("purse", copper)
		end
	end
	for i = 1, 8 do
		if fields["buy"..i] then
			local trade = trade_list[i]
			if not trade then
				return
			end
			local stack = ItemStack(trade.stack)
			local price = ItemStack(trade.price)
			if not buyer_inv:contains_item("purse", price) then
				return
			end
			if not buyer_inv:room_for_item("main", stack) then
				return
			end
			buyer_inv:remove_item("purse", price)
			buyer_inv:add_item("main", stack)
			trader_inv:add_item("purse", price)
			table.remove(trade_list, i)
			trader_meta:set_string("trade_list", minetest.serialize(trade_list))
			refresh_trade_inventory(trader, player)
			minetest.chat_send_player(trader:get_player_name(), player:get_player_name() .. " bought ".. stack:get_name() .. " from you.")
			if trader:get_player_name() ~= player:get_player_name() then
				local class = classes.get_class(trader)
				if class ~= "trader" then
					return
				end
				classes.change_xp(trader, mtcoin.coin_to_xp(price))
			end
		end	
	end
	
end)
