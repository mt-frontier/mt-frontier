local sepia = {
	hud_elem_type = "image",
	position = {x = 0.5,  y = 0.5},
	text = "sepia.png",
	scale = {x = 4, y = 4},
}

minetest.register_chatcommand("sepia", {
	params = "",
	description = "Set sepia view",
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		local meta = player:get_meta()
		local id = meta:get_int("sepia")
		if id == 0 then
			local id = player:hud_add(sepia)
			meta:set_int("sepia", id)
			print("Sepia mode")
		else
			player:hud_remove(id)
			meta:set_int("sepia", 0)
			print("Sepia mode deactivate")
		end
	end
})

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	local id = meta:get_int("sepia")
	if id ~= 0 then
		local id = player:hud_add(sepia)
		meta:set_int("sepia", id)
	end
end)
