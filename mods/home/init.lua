local function add_waypoint_hud(player, pos)
	local id = player:hud_add({
		hud_elem_type = "waypoint",
		name = "Home",
		text = " m",
		number = 16777215,
		world_pos = pos
	})
	local meta = player:get_meta()
	meta:set_int("home_hud", id)
end

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	local pos_str = meta:get_string("home")
	if pos_str == "" then
		return
	end
	local pos = minetest.string_to_pos(pos_str)
	add_waypoint_hud(player, pos)
end)

minetest.register_chatcommand("sethome", {
	params = "",
	description = "Set home waypoint",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local pos_str = minetest.pos_to_string(pos, 1)
		local meta = player:get_meta()
		meta:set_string("home", pos_str)
		local hud_id = meta:get_int("home_hud")
		if hud_id ~= 0 then
			player:hud_remove(hud_id)
		end
		add_waypoint_hud(player, pos)
	end
})

minetest.register_chatcommand("home", {
	params = "",
	description = "Toggle home waypoint HUD",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local meta = player:get_meta()
		local pos_str = meta:get_string("home")
		if pos_str == "" then
			return minetest.chat_send_player(name, "You must first /sethome")
		end
		local hud = meta:get_int("home_hud")
		if hud == 0 then
			local pos = minetest.string_to_pos(pos_str)
			add_waypoint_hud(player, pos)
		else
			meta:set_int("home_hud", 0)
			player:hud_remove(hud)
		end
	end

})
