local games = {}

local function register_card(Value, Suit)
	local item_name = "poker:"..tostring(Value):lower().."_"..Suit:lower()
	minetest.register_craftitem(item_name, {
		description = Value .. " of " ..Suit,
		inventory_image = Suit:lower() .. ".png^" .. tostring(Value):lower() .. ".png",
		groups = {[Suit:lower()] = 1,[tostring(Value):lower()] = 1, not_in_creative_inventory = 1}
	})
	return item_name
end

local function get_deck()
	local full_deck = {}
	local suits = {"Clubs", "Hearts", "Spades", "Diamonds"}
	local highs = {"Jack", "Queen", "King", "Ace"}

	for _, suit in ipairs(suits) do
		for value = 2, 10 do
			local card_name = register_card(value, suit)
			table.insert(full_deck, card_name)
		end
		for i, value in ipairs(highs) do
			local card_name = register_card(value, suit)
			table.insert(full_deck, card_name)
		end
	end
	return full_deck
end

local full_deck = get_deck()

local function shuffle(inv)
	
	for i, card in ipairs(full_deck) do
		inv:add_item("deck", ItemStack(card))
	end
end

local function draw_card(inv, playername)
	if inv:is_empty("deck") then
		shuffle(inv)
	end
	local card = ItemStack("")
	while card:is_empty() do
		card = inv:get_stack("deck", math.random(1,52))
	end
	inv:remove_item("deck", card)
	inv:add_item(playername,card)
end
	
local function get_formspec(pos, playername)
	local meta = minetest.get_meta(pos)
	local game = minetest.deserialize(meta:get_string("game"))
	local name = playername

	local form_tbl = {
		"size[8,4]",
		"position[0.5,0.7]",
	}
	local append = {}
	if not game.players[name] then
		table.insert(append, "button[3,3;2,1;join;Join]")
	else
		table.insert(append, 
			"label[0.5,2;Your Funds]"..	
			"list[current_player;purse;0,0;2,1;]"..
			"button[0,1;1,1;left;<]button[1,1;1,1;right;>]"..
			"list[detached:poker:"..minetest.pos_to_string(pos)..";"..name..";0,3;5,2;]"..
			"button[6,0;2,1;leave;Leave]"..
			"textarea[3,0;3,3;nil;;" .. table.concat(game.log, "\n")  .."]"
				
		)
		if game.state == "ready" then
			
			if game.dealer == name then	
				table.insert(append, 
					"button[6,3;2,1;deal;Deal]"		
				)
			end
		end
		if game.players[name] == "discard" then
			table.insert(append,
				"list[detached:poker:"..minetest.pos_to_string(pos)..":dc_slot;7,3;1,1;]"
			)
		end
		if game.players[name] == "betting" then
			table.insert(append,
					
				"item_image_button[6,0.5;1,1;mtcoin:gold;gold;]"..
				"item_image_button[7,0.5;1,1;mtcoin:copper;copper;]"
			)
		end
	end
	for _, add_on in ipairs(append) do
		form_tbl[#form_tbl + 1] = add_on
	end
	local formspec = table.concat(form_tbl)
	return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if not string.match(formname, "poker:") then
		return
	end
	local name = player:get_player_name()
	local pos = minetest.string_to_pos(formname:gsub("poker:"..name..":", ""))
	local player_inv = minetest.get_inventory({type = "player", name = name})
	local meta = minetest.get_meta(pos)
	local game = minetest.deserialize(meta:get_string("game"))
	local game_inv = minetest.get_inventory({type = "detached", name = "poker:"..minetest.pos_to_string(pos)})
	local gold = "mtcoin:gold 1"
	local copper = "mtcoin:copper 3"
	if fields.quit then
		return
	end
	if fields.leave then
	--	local pos = minetest.string_to_pos(field:gsub("leave_", ""))
		if game.players[name] then
			game.players[name] = nil
		end
			
		game_inv:set_list(name, nil)
		for i = 1, 5 do
			local stack = game_inv:get_stack(name, i)
			game_inv:remove_item(name, stack)
		end
		if game.players == {} then
			game = nil
		end
		for k, v in pairs(game.players) do
			print(k)
		end
	elseif fields.join then
		if not game.players[name] then
			game_inv:set_size(name, 5)
		end
		if #game.players == 0 then
			game.dealer = name
			print(game.dealer)
		end
		game.players[name] = "waiting"
		table.insert(game.log, name .." joins the table")
	elseif fields.deal then
		for n = 1, 5 do
			for name, state in pairs(game.players) do
				if n == 1 then
					if state == "waiting" then
						game.players[name] = "playing"
					end
				end
				if state ~= "watching" then
					draw_card(game_inv, name)
				end
			end
			print(next(game.players, game.dealer))
		end
		game.state = "betting"
	elseif fields.left then
		if player_inv:contains_item("purse", copper) then	
			player_inv:remove_item("purse", copper)
			player_inv:add_item("purse", gold)
		end
	elseif fields.right then
		if player_inv:contains_item("purse", gold) then
			player_inv:remove_item("purse", gold)
			player_inv:add_item("purse", copper)
		end
	end
	meta:set_string("game", minetest.serialize(game))
	if game == nil then
		return minetest.close_formspec(name, formname)
	end
	local formspec = get_formspec(pos, name)
	minetest.show_formspec(name, formname, formspec)
end)

--Table with deck,
minetest.register_node("poker:table", {
	description = "Poker Table",
	drawtype = "nodebox",
	tiles = {
		"frontier_trees_apple_wood.png^poker_table_top.png",
		"frontier_trees_apple_wood.png",
		"frontier_trees_apple_wood.png^poker_table_side.png"
	},
	groups = {choppy = 2},
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.4, -0.5, -0.4, -0.3, 0.1, -0.3 }, -- foot 1
			{ 0.3, -0.5, -0.4, 0.4, 0.1, -0.3 }, -- foot 2
			{ -0.4, -0.5, 0.3, -0.3, 0.1, 0.4 }, -- foot 3
			{ 0.3, -0.5, 0.3, 0.4, 0.1, 0.4 }, -- foot 4
			{ -0.5, 0.1, -0.5, 0.5, 3/16, 0.5 }, -- table top
			{ -1/8, 1/4, -3/16, 1/8, 3/16, 3/16} --deck
		}
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local game = {
			state = "ready",
			players = {},
			log = {"New Game"}
		}
		local gamestr = meta:get_string("game")
		if gamestr ~= "" then
			game = minetest.deserialize(gamestr)
		end
		
		meta:set_string("game", minetest.serialize(game))
		local inv = minetest.get_inventory({type = "detached", name = "poker:"..minetest.pos_to_string(pos)})
		if inv == nil then
			inv = minetest.create_detached_inventory("poker:"..minetest.pos_to_string(pos))
			inv:set_size("deck", 52)
			inv:set_size("discard", 1)
			inv:set_size("pot", 2)
			shuffle(inv)		
		end	
		local name = clicker:get_player_name()
		local form = get_formspec(pos, name)
		minetest.show_formspec(name, "poker:"..name..":"..minetest.pos_to_string(pos), form)
	end,
})
