
local S = mobs.intllib

-- define table containing names for use and shop items for sale
mobs.traders = {}

mobs.traders.hunter = {

	names = {
		"Adahy", "Degataga", "Galegenoh", "Mohe", "Oukonunaka", "Sequoya", "Waya",
		"Tsiyi", "Kanuna"
	},

	items = {
		{"mtcoin:gold 3", "default:gold_ingot 1", 3},
		{"mtcoin:copper 3", "default:copper_ingot 1", 2},
		{"mtcoin:copper 6", "default:steel_ingot 1", 3},
		{"frontier_trees:apple 9", "mtcoin:gold 6", 10},
		{"default:clay 10", "mtcoin:gold 6", 12},
		{"default:sand 9", "mtcoin:gold 6", 17},
		{"farming:wheat 10", "mtcoin:gold 6", 17},
		{"default:stick 4", "mtcoin:gold 1", 20},
		{"default:desert_stone 10", "mtcoin:gold 24", 27},
		{"default:pick_stone 1", "mtcoin:gold 6", 2},
		{"default:dagger_stone 1", "mtcoin:gold 4", 6},
		{"default:shovel_stone 1", "mtcoin:gold 3", 6},
		{"default:axe_stone 1", "mtcoin:gold 6", 3},
		{"default:cactus 2", "mtcoin:gold 3", 40},
		{"bows:bow_wood 1", "mtcoin:gold 15", 2},
		{"bows:arrow 9", "mtcoin:gold 9", 2},
		{"crops:corn 1", "mtcoin:gold 1", 5},
		{"crops:pumpkin 1", "mtcoin:gold 1", 5},
		{"mtcoin:copper 9", "default:stone 99", 6},
		{"mtcoin:copper 3", "mobs:chicken_feather 1", 4},
		{"bows:arrow_toxic 9", "mtcoin:gold 24", 8},
		{"mtcoin:gold 2", "mobs:cheese 1", 5},
		{"mtcoin:gold 10", "vessels:apple_butter_jar 1", 8},
		{"mtcoin:gold 10", "vessels:blueberry_jam_jar 1", 8},
		{"mtcoin:gold 10", "vessels:maple_syrup_jar 1", 8},
	}
}


mobs.traders.homesteader = {

	names = {"Henry", "Fredrick", "Nathaniel", "Samuel", "Solomon", "Robert"},

	items = {
		--{item for sale, price, inverse probability of appearing in trader's inventory}
		{"mtcoin:gold 3", "default:gold_ingot 1", 2},
		{"mtcoin:copper 3", "default:copper_ingot 1", 2},
		{"mtcoin:copper 6", "default:steel_ingot 1", 3},
		{"farming:bread 9", "mtcoin:gold 12", 5},
		--{"default:clay 10", "mtcoin:gold 6", 12},
		{"default:brick 10", "mtcoin:gold 12", 17},
		--{"default:sand 9", "mtcoin:gold 6", 17},
		{"farming:seed_wheat 4", "mtcoin:gold 1", 17},
		{"mtcoin:gold 1", "farming:wheat 9", 4},
		{"default:tree 5", "mtcoin:gold 12", 20},
		{"default:stone 10", "mtcoin:gold 24", 17},
		{"default:desert_stone 10", "mtcoin:gold 24", 27},
		{"default:pick_bronze 1", "mtcoin:gold 8", 2},
		{"default:dagger_bronze 1", "mtcoin:gold 7", 5},
		{"default:shovel_bronze 1", "mtcoin:gold 6", 8},
		{"default:axe_bronze 1", "mtcoin:gold 8", 4},
		{"farming:hoe_steel 1", "mtcoin:gold 6", 3},
		{"crops:tomato 1", "mtcoin:gold 1", 5},
		{"crops:potato 1", "mtcoin:gold 1", 5},
		{"crops:green_bean", "mtcoin:gold 1", 5},
		{"crops:watering_can 1", "mtcoin:gold 12", 3},
		{"crops:hydrometer 1", "mtcoin:gold 9", 6},
		{"farming:seed_cotton 3", "mtcoin:gold 1", 6},
		{"mtcoin:copper 1", "default:dirt 99", 11},
		{"mtcoin:copper 6", "mobs:meat 1", 4},
		{"mtcoin:copper 6", "mobs:pork_cooked 1", 4},
		{"mobs:lasso 1", "mtcoin:gold 9", 6},
		{"mobs:net 1", "mtcoin:gold 3", 6},
		{"mobs:saddle 1", "mtcoin:gold 15", 6},
		{"mobs:nametag 1", "mtcoin:gold 2", 5},
		{"craftguide:book", "mtcoin:gold 10", 5},
		{"frontier_guns:shotgun 1", "mtcoin:gold 198", 20},
		{"frontier_guns:shotgun_shell 1", "mtcoin:gold 5", 10}, 
		{"mtcoin:gold 12", "mobs:leather", 4},
		{"mobs_animal:cow", "mtcoin:gold 99", 9},
		{"mobs_animal:chicken", "mtcoin:gold 18", 7},
		{"mobs:chicken_feather 9","mtcoin:gold 1", 6},
	}
}

mobs.traders.prospector = {

	names = {"William", "Joseph", "Charles", "John", "David", "Adam", "Thomas"},

	items = {
		--{item for sale, price, chance of appearing in trader's inventory}
		{"mtcoin:gold 3", "default:gold_ingot 1", 2},
		{"mtcoin:copper 3", "default:copper_ingot 1", 2},
		{"mtcoin:gold 4", "farming:bread 3", 5},
		{"default:stone 10", "mtcoin:gold 24", 17},
		{"default:desert_stone 10", "mtcoin:gold 24", 27},
		{"default:pick_steel 1", "mtcoin:gold 10", 3},
		{"default:dagger_steel 1", "mtcoin:gold 8", 4},
		{"default:shovel_steel 1", "mtcoin:gold 7", 6},
		{"default:axe_steel 1", "mtcoin:gold 10", 5},
		{"default:coal_lump 9", "mtcoin:gold 9", 8},
		{"default:furnace 1", "mtcoin:gold 9", 5},
		{"default:iron_lump 9", "mtcoin:gold 18", 8},
		{"default:torch 9", "mtcoin:gold 12", 5},
		{"mtcoin:gold 12", "mobs:leather", 4},
		{"default:obsidian 1", "mtcoin:gold 9", 50},
		{"mtcoin:gold 3", "mobs:pork_cooked 1", 6},
		{"mtcoin:gold 3", "mobs:rabbit_hide 1", 12},
		{"mtcoin:copper 1", "crops:melon_slice", 6},
		{"mtcoin:gold 5", "pies:baked_apple_pie 1", 8},
		{"mtcoin:gold 8", "pies:baked_blueberry_pie 1", 8},
		{"mtcoin:gold 13", "pies:baked_pumpkin_pie 1", 8},
		{"mtcoin:gold 16", "pies:baked_chicken_pie 1", 6},
		{"frontier_guns:revolver 1", "mtcoin:gold 496", 27},
		{"frontier_guns:bullet 1", "mtcoin:gold 18", 19},
		{"mtcoin:gold 2", "mobs:cheese 1", 5},
		{"mtcoin:gold 10", "vessels:apple_butter_jar 1", 8},
		{"mtcoin:gold 10", "vessels:blueberry_jam_jar 1", 8},
		{"mtcoin:gold 10", "vessels:maple_syrup_jar 1", 8},
	}
}


-- Trader ( same as NPC but with right-click shop )

local function sort_items(item_table)
	local new_table = {}
	for _, item in ipairs(item_table) do
		if #new_table == 0 then
			table.insert(new_table, item)
		else
			local chance = item[3]
			for i, sorted in ipairs(new_table) do
				local sorted_chance = sorted[3]
				if chance <= sorted_chance then
					table.insert(new_table, i, item)
					break
				elseif i == #new_table then
					table.insert(new_table, i + 1, item)
				end
			end
		end
	end

	return new_table
end

function register_trader(trader_type, trader_textures, trader_names_items, trader_def, spawn_by)

local items = sort_items(trader_names_items.items)
trader_names_items.items = items

--mobs:register_mob("mobs_npc:trader", {
	local default_def = {	
		type = "npc",
		passive = false,
		damage = 5,
		attack_type = "dogfight",
		attacks_monsters = true,
		attack_animals = false,
		attack_npcs = false,
		attack_players = true,
		group_attack = true,
		attack_chance = 2,
		pathfinding = true,
		walk_chance = 20,
		stand_chance = 50,
		hp_min = 16,
		hp_max = 24,
		armor = 100,
		collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
		visual = "mesh",
		mesh = "mobs_character.b3d",
		textures = {
			trader_textures
		--{"mobs_hunter.png"},
		--{"mobs_trader2.png"},
		--{"mobs_trader3.png"},
		},
		makes_footstep_sound = true,
		sounds = {},
		walk_velocity = 2,
		run_velocity = 4,
		jump = true,
		drops = {
			{name = "mtcoin:copper", chance = 2, min = 1, max = 9},
			{name = "mtcoin:gold", chance = 10, min = 1, max = 9}
		},
		water_damage = 0,
		lava_damage = 4,
		light_damage = 0,
		follow = {"mtcoin:gold", "mtcoin:copper"},
		view_range = 15,
		owner = "",
		--order = "stand",
		fear_height = 3,
		animation = {
			speed_normal = 30,
			speed_run = 30,
			stand_start = 0,
			stand_end = 79,
			walk_start = 168,
			walk_end = 187,
			run_start = 168,
			run_end = 187,
			punch_start = 200,
			punch_end = 219,
		},
		on_rightclick = function(self, clicker)
			mobs_trader(self, clicker, entity, trader_names_items)
			if not self.dtimer then	
				self.last_time_check = minetest.get_gametime()
				self.dtimer = math.random(300, 600)
			end
		end,
		on_spawn = function(self)
			self.nametag = S("Trader")
			self.object:set_properties({
				nametag = self.nametag,
				nametag_color = "#FFFFFF"
			})
			return true -- return true so on_spawn is run once only
		end,
		do_custom = function(self)
			if self.dtimer then
				local now = minetest.get_gametime()
				local dt = now - self.last_time_check
				self.last_time_check = now
				self.dtimer = self.dtimer - dt
				if self.dtimer <= 0 then
					self.object:remove()
				end
			end
			local pos = self.object:get_pos()
			if pos == nil then
				return
			end
			local ll = minetest.get_node_light(pos)
			if ll == nil then
				return
			end
			if ll <= 2 then
				local objects = minetest.get_objects_inside_radius(self.object:get_pos(), 9)
				for _, ob_ref in ipairs(objects) do
					if minetest.is_player(ob_ref) then
						print('player')
						return
					end
				end
				self.object:remove()
			end
		end,
	}
	if trader_def ~= nil then	
		for k, v in pairs(trader_def) do
			default_def[k] = v
		end
	end

	mobs:register_mob("mobs_npc:trader_"..trader_type, default_def)

	mobs:register_egg("mobs_npc:trader_"..trader_type, S("Trader"), "default_sandstone.png", 1)

	mobs:spawn({
		name = "mobs_npc:trader_"..trader_type,
		nodes = {"group:soil"},
		neighbors = spawn_by,
		interval = 77,
		chance = 74000,
		active_object_count = 8,
		min_height = 1,
		max_height = 200,
		day_toggle = true,
	})

end

register_trader("prospector", {"mobs_prospector.png"}, mobs.traders.prospector, {}, {"group:cracky", "group:choppy"})
register_trader("homesteader", {"mobs_homesteader.png"}, mobs.traders.homesteader, {}, {"group:choppy", "group:flower", "group:mushroom", "group:flora", "group:plant"})
register_trader("hunter", {"mobs_hunter.png"}, mobs.traders.hunter, {}, {"group:snappy"})


--This code comes almost exclusively from the trader and inventory of mobf, by Sapier.
--The copyright notice below is from mobf:
-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
--
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice.
-- And of course you are NOT allow to pretend you have written it.
--
--! @file inventory.lua
--! @brief component containing mob inventory related functions
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-02
--
--! @defgroup Inventory Inventory subcomponent
--! @brief Component handling mob inventory
--! @ingroup framework_int
--! @{
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

-- This code has been heavily modified by isaiah658.
-- Trades are saved in entity metadata so they always stay the same after
-- initially being chosen.  Also the formspec uses item image buttons instead of
-- inventory slots.
----------------------------
--lumberJack modified trade selection process to sort items by chance 
--before selecting to ensure that probabilities are honored
--(chance of 1 mean 100% chance of item showing up in trade slot)

function mobs.add_goods(self, entity, class)

	local trade_index = 1
	local trades_already_added = {}
	local trader_pool_size = 10
	local item_pool_size = #class.items -- get number of items on list
	local function already_added(n)
		for i = 1, #trades_already_added do
			if n == trades_already_added[i] then
				return true
			end
		end	
		return false
	end
	self.trades = {}

	if item_pool_size < trader_pool_size then
		trader_pool_size = item_pool_size
	end
	local i = 1
	while i <= trader_pool_size do
		local trade = nil
		for n = 1, #class.items do
			if already_added(n) == false then
				if math.random() < 1 / class.items[n][3] then
					self.trades[i] = {
					class.items[n][1],
					class.items[n][2]}
					i = i + 1
					table.insert(trades_already_added, n)
				end
			end
		end
	end
end


function mobs_trader(self, clicker, entity, class)

	if not self.id then
		self.id = (math.random(1, 1000) * math.random(1, 10000))
			.. self.name .. (math.random(1, 1000) ^ 2)
	end

	if not self.game_name then

		self.game_name = tostring(class.names[math.random(1, #class.names)])
		self.nametag = S("Trader @1", self.game_name)

		self.object:set_properties({
			nametag = self.nametag,
			nametag_color = "#00FF00"
		})
	end

	if self.trades == nil then
		mobs.add_goods(self, entity, class)
	end

	local player = clicker:get_player_name()

	minetest.chat_send_player(player,
		S("[NPC] <Trader @1> Hello, @2, can we make a trade?.",
		self.game_name, player))

	-- Make formspec trade list
	local formspec_trade_list = ""
	local x, y

	for i = 1, 10 do

		if self.trades[i] and self.trades[i] ~= "" then

			if i < 6 then
				x = 0.5
				y = i - 0.5
			else
				x = 4.5
				y = i - 5.5
			end

			formspec_trade_list = formspec_trade_list
			.. "item_image_button[".. x ..",".. y ..";1,1;"
				.. self.trades[i][2] .. ";prices#".. i .."#".. self.id ..";]"
			.. "item_image_button[".. x + 2 ..",".. y ..";1,1;"
				.. self.trades[i][1] .. ";goods#".. i .."#".. self.id ..";]"
			.. "image[".. x + 1 ..",".. y ..";1,1;gui_arrow_blank.png]"
		end
	end

	minetest.show_formspec(player, "mobs_npc:trade", "size[8,10]"
		.. default.gui_bg_img
		.. default.gui_slots
		.. "label[0.5,-0.1;" .. S("Trader @1's stock:", self.game_name) .. "]"
		.. formspec_trade_list
		.. "list[current_player;main;0,6;8,4;]"
	)
end


minetest.register_on_player_receive_fields(function(player, formname, fields)

	if formname ~= "mobs_npc:trade" then return end

	if fields then

		local trade = ""

		for k, v in pairs(fields) do
			trade = tostring(k)
		end

		local id = trade:split("#")[3]
		local self = nil

		if id ~= nil then

			for k, v in pairs(minetest.luaentities) do

				if v.object and v.id and v.id == id then
					self = v
					break
				end
			end
		end

		if self ~= nil then

			local trade_number = tonumber(trade:split("#")[2])

			if trade_number ~= nil and self.trades[trade_number] ~= nil then

				local price = self.trades[trade_number][2]
				local goods = self.trades[trade_number][1]
				local inv = player:get_inventory()
				local leftover
				if inv:contains_item("purse", price) then

					inv:remove_item("purse", price)

					leftover = inv:add_item("main", goods)
				
				elseif inv:contains_item("main", price) then
					inv:remove_item("main", price)
					if minetest.get_item_group(ItemStack(goods):get_name(), "coin") == 1 then
						inv:add_item("purse", goods)
						--local class = classes.get_class(player)
						--if class == "trader" then
						--	classes.change_xp(player, mtcoin.coin_to_xp(ItemStack(goods)))
						--end
					else
						leftover = inv:add_item("main", goods)

					end
				end
				if leftover == nil then
					return
				elseif leftover:get_count() > 0 then
					-- drop item(s) in front of player
					local droppos = player:get_pos()
					local dir = player:get_look_dir()
					droppos.x = droppos.x + dir.x
					droppos.z = droppos.z + dir.z
					minetest.add_item(droppos, leftover)
				end
			end
		end
	end
end)
--[[
mobs:register_egg("mobs_npc:trader", S("Trader"), "default_sandstone.png", 1)

mobs:spawn({
	name = "mobs_npc:trader",
	nodes = {"group:soil"},
	neighbors = {"default:aspen_tree", "default:pine_tree"},
	interval = 67,
	chance = 9000,
	active_object_count = 8,
	min_height = 0,
	max_height = 200,
	day_toggle = true,
})
]]--
-- compatibility
mobs:alias_mob("mobs:trader", "mobs_npc:trader")
