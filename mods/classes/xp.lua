local day_count = {}

local store = minetest.get_mod_storage()
classes.xp = {}

if store:get_string("xp") ~= "" then
	classes.xp = minetest.deserialize(store:get_string("xp"))
end

local function save_xp()
	store:set_string("xp", minetest.serialize(classes.xp))
end

minetest.register_on_shutdown(function()
	save_xp()
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not classes.xp[name] then
		classes.xp[name] = {}
	end
	local today = minetest.get_day_count()
	day_count[name] = today
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	day_count[name] = nil
end)

function classes.get_xp(playername)
	local xp_tbl = classes.xp[playername] or {}
	local total = 0
	for class, xp in pairs(xp_tbl) do
		total = total + xp
	end
	return total, xp_tbl
end

function classes.change_xp(player, xp)
	local name = player:get_player_name()
	local meta = player:get_meta()
	local class = meta:get_string("class")
	if class == ""
		then return
	end
	local class_xp = classes.xp[name][class] or 0
	class_xp = class_xp + xp
	classes.xp[name][class] = class_xp
	minetest.log("info", "[Classes] " .. name .." gains " .. xp .." XP. at position: " .. minetest.pos_to_string(player:get_pos()))
end

local xp_timer = 0
local save_timer = 0
minetest.register_globalstep(function(dt)
	save_timer = save_timer + dt
	xp_timer = xp_timer + dt
	if save_timer >= 11 then
		save_xp()
		save_timer = 0
	end
	if xp_timer >= 1200 then
		xp_timer = 0
		local today = minetest.get_day_count()
		for name, count in pairs(day_count) do
			local xp = today - count
			if xp > 0 then
				player = minetest.get_player_by_name(name)
				classes.change_xp(player, xp)
				day_count[name] = today
			end
		end
	end
end)

minetest.register_chatcommand("xp", {
	params = "<playername>",
	description = "Get Player's XP information",
	func = function(name, params)
		local playername = params
		if playername == "" then
			playername = name
		end
		local total_xp, xp_tbl = classes.get_xp(playername)
		local msg = playername .. "'s XP:\nTotal: " .. total_xp.."\n"
		for k, v in pairs(xp_tbl) do
			msg = msg .. k .. ": " .. v .. "\n"
		end
		minetest.chat_send_player(name, msg)
	end,
})
