local store = minetest.get_mod_storage()
local effects = minetest.deserialize(store:get_string("effects")) or {}
local registered_effects = {}
local huds = {}
local function store_effects()
	store:set_string("effects", minetest.serialize(effects))
end

minetest.register_on_shutdown(function()
	store_effects()
end)

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	local pname = player:get_player_name()
	local p_effects = effects[pname]
	if p_effects ~= nil then
	if effects[pname]["protection"] then
		local hp = hitter:get_hp()
		hp = hp - damage
		hitter:set_hp(hp)
		return true
	end
	end
end)

local function init_hud(playername, effect, effect_time)
	local player = minetest.get_player_by_name(playername)
	local i = function()
		local index = 0
		for k, v in pairs(effects[playername]) do
			index = index + 1
			if k == effect then
				return index
			end
		end
		index = index + 1
		return index
	end
	local color = 0xFFFFFF
	if effect_time <= 3 then
		color = 0xFF0000
	end
	local posy = i() * 0.04
	local id = player:hud_add({
		position = {x = 0.90, y = 0.90 - posy},
		hud_elem_type = "text",
		text =  effect..": "..effect_time,
		number = color,
	})		
	return id
end

local function change_hud(playername, hudID, effect, time_left, index)
	local player = minetest.get_player_by_name(playername)
	if time_left <= 3 then
		player:hud_change(hudID, "number", 0xFF1100)
	else player:hud_change(hudID, "number", 0xFFFFFF)
	end
	player:hud_change(hudID, "text", effect..": "..time_left)
end

local function remove_hud(playername, hudID)
	local player = minetest.get_player_by_name(playername)
	player:hud_remove(hudID)
end

local function refresh_huds(playername)
	for k, v in pairs(effects[playername]) do
		remove_hud(playername, v[3])
		if effects[playername][k][2] > 1 then
			local id = init_hud(playername, k, effects[playername][k][2]-1)
			effects[playername][k][3] = id
		end
	end
end

local function countdown()
	for n, t in pairs(effects) do
		if minetest.get_player_by_name(n) then
		local player = minetest.get_player_by_name(n)
			local i = 0
			for k, v in pairs(t) do
				if v[2] > 0 then
					effects[n][k][2] = v[2] - 1
					change_hud(n, effects[n][k][3], v[1], effects[n][k][2], i)
					i = i + 1
				else
					local effect = v[1]
					registered_effects[effect].end_func(n)
					remove_hud(n, effects[n][k][3])
					effects[n][k] = nil
					refresh_huds(n)
				end
			end
		end
	if t == {} then 
		effects[n] = nil
	end
	end
end

local count_timer = 0
local save_timer = 0
local effect_timer = 0
minetest.register_globalstep(function(dtime)
	count_timer = count_timer + dtime
	if count_timer >= 1 then
		countdown()
		count_timer = 0
	end

	save_timer = save_timer + dtime
	if save_timer >= 11 then
		store_effects()
--		minetest.log("[CS_MAGIC] Effects stored!")
		save_timer = 0
	end
	
	effect_timer = effect_timer + dtime
	if effect_timer >= 5 then		
		for n, fx in pairs(effects) do
			for k, v in pairs(fx) do
				if k == "healing" then
					local effect = v[1]
					registered_effects[effect].start_func(n)
				end
			end
		end
		effect_timer = 0
	end
end)


-------------------------------------------------------------------
--Give player affect or cumulatively add to existing effect's time
-------------------------------------------------------------------
function cs_herbs.add_effect(name, effect, effect_time)
	local effect_type = registered_effects[effect].effect_type
	if effects[name] == nil then
		effects[name] = {}
	end
	if effects[name][effect_type] == nil then
		local id = init_hud(name, effect, effect_time)
		effects[name][effect_type] = {effect, effect_time, id}
		return registered_effects[effect].start_func(name)
	elseif effects[name][effect_type][1] == effect then
		effects[name][effect_type][2] = effects[name][effect_type][2] + effect_time
	else
		cancel(name, effect)
		local id = init_hud(name, effect, effect_time)
		effects[name][effect_type] = {effect, effect_time, id}
		return registered_effects[effect].start_func (name)
	end
	minetest.log("[CS_MAGIC] "..name.." invoked "..effect)
end

local function cancel(name, effect)
	for k, v in pairs(effects) do
		if v[2] == effect then
			remove_hud(name, effects[name][k][3])
			registered_effects[param].end_func(name)
			effects[name][k] = nil
		end
	end
end

local function cancel_effects(name)
	if effects[name] == nil then
		return
	end
	for k, v in pairs(effects[name]) do
		remove_hud(name, effects[name][k][3])
		registered_effects[k].end_func(name)
	end
	effects[name] = nil
end
--players loose effects on death.
minetest.register_on_dieplayer(function(player)
	local pname = player:get_player_name()
	cancel_effects(pname)
end)
--load saved effects and initialize huds
minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
	if effects[pname] ~= nil then
		for k, v in pairs(effects[pname]) do
			local effect = v[1]
			local id = init_hud(pname, k, v[2])
			effects[pname][k][3] = id
			registered_effects[effect].start_func(pname)
		end
	end
end)
--allow players to cancel effect
minetest.register_chatcommand("cancel_effect", {
params = "<Effect Name>",
description = "Cancels named effect",
func = function(name, param)
	local msg = ""
	if param == "" then
		 msg = "No effect cancelled."
	elseif effects[name][param] == nil then
		msg = "Invalid effect name."
	else
		cancel(name, param)
		msg = "Effect cancelled."
	end
	minetest.chat_send_player(name, msg)
end
})
--allow players to cancel all of their effects
minetest.register_chatcommand("cancel_all", {
	params = "",
	description = "Cancels all effects",
	func = function(name, param)
		cancel_effects(name)
		minetest.chat_send_player(name, "All effects cancelled.")
	end
})

function cs_herbs.register_effect(effect_name, effect_def) 
	registered_effects[effect_name] = effect_def
end 
--------------------
--Register Effects
--------------------
cs_herbs.register_effect("flight", {
	effect_type = "flight",
	start_func = function(playername)
	local privs = minetest.get_player_privs(playername)
	privs.fly = true
	minetest.set_player_privs(playername, privs)
	end,
	end_func = function(playername)
		local privs = minetest.get_player_privs(playername)
		privs.fly = nil
		minetest.set_player_privs(playername, privs)
	end,
})

cs_herbs.register_effect("speed", {
	effect_type = "velocity",
	start_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		player:set_physics_override({speed = 3})
	end,
	end_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		player:set_physics_override({speed=1})
	end
})

cs_herbs.register_effect("antigravity", {
	effect_type = "gravity",
	start_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		player:set_physics_override({gravity=0.4})
	end,
	end_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		player:set_physics_override({gravity=1})
	end,
})

cs_herbs.register_effect("jump", {
	effect_type = "jump",
	start_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		player:set_physics_override({jump=2})
	end,
	end_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		player:set_physics_override({jump=1})
	end,
})

cs_herbs.register_effect("protection", {
	effect_type = "protection",
	start_func = function(playername)
		local player = minetest.get_player_by_name(playername)	
		local armor_groups = player:get_armor_groups()
		print (armor_groups.fleshy)
		armor_groups.fleshy = armor_groups.fleshy + 50
		player:set_armor_groups(armor_groups)
		print(armor_groups.fleshy)
	end,
	end_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		local armor_groups = player:get_armor_groups()
		print(armor_groups.fleshy)
		armor_groups.fleshy = armor_groups.fleshy - 50
		player:set_armor_groups(armor_groups)
		print(armor_groups.fleshy)

	end,
})

cs_herbs.register_effect("noclip", {
	effect_type = "noclip",
	start_func = function(playername)
		local privs = minetest.get_player_privs(playername)
		privs.noclip = true
		minetest.set_player_privs(playername, privs)
	end,
	end_func = function(playername)
		local privs = minetest.get_player_privs(playername)
		privs.noclip = false
		minetest.set_player_privs(playername, privs)
	end,
})

cs_herbs.register_effect("slow_heal", {
	effect_type = "healing",
	start_func = function(playername)
		local player = minetest.get_player_by_name(playername)
		if player == nil then
			return
		end
		local hp = player:get_hp()
		if hp < 20 then
			hp = hp + 1
			player:set_hp(hp)
		end
	end,
	end_func = function(playername)
	end,
})
------------
--Test Uses
-------------

--[[
minetest.override_item("cs_herbs:geranium", {
	on_use = function(itemstack, user, pointed_thing)
		cs_herbs.add_effect(user:get_player_name(), "flight", 10)
		itemstack:take_item()
		return itemstack
	end,
})

minetest.override_item("cs_herbs:rose", {
	on_use = function(itemstack, user, pointed_thing)
		cs_herbs.add_effect(user:get_player_name(), "slow_heal", 10)
		itemstack:take_item()
		return itemstack
	end,
})

minetest.override_item("flowers:flower_dandelion_yellow", {
	on_use = function(itemstack, user, pointed_thing)
		cs_herbs.add_effect(user:get_player_name(), "antigravity", 10)
		itemstack:take_item()
		return itemstack
	end,	
})

minetest.override_item("default:cactus", {
	on_use = function(itemstack, user, pointed_thing)
		cs_herbs.add_effect(user:get_player_name(), "protection", 10)
		itemstack:take_item()
		return itemstack
	end
})

minetest.override_item("flowers:flower_viola", {
	on_use = function(itemstack, user, pointed_thing)
		cs_herbs.add_effect(user:get_player_name(), "jump", 10)
		itemstack:take_item()
		return itemstack
	end,
})

]]--
