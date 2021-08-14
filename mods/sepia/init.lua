sepia = {}
local sepia_timer = 0
local sepia_blind = {
	hud_elem_type = "image",
	position = {x = 0.5,  y = 0.5},
	text = "sepia.png",
	scale = {x = 4, y = 4},
}

function sepia.set_sepia_blind(player)
	local meta = player:get_meta()
	local id = player:hud_add(sepia_blind)
	meta:set_int("sepia", id)
end

function sepia.remove_sepia_blind(player, hudid)
	local meta = player:get_meta()
	local id = meta:get_int("sepia")
	player:hud_remove(id)
	meta:set_int("sepia", 0)
end

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	local id = meta:get_int("sepia")
	if id ~= 0 then
		local id = player:hud_add(sepia_blind)
		meta:set_int("sepia", id)
	end
end)

minetest.register_globalstep(function(dtime)
	sepia_timer = sepia_timer+dtime
	if sepia_timer > 1.3 then
		for _, player in ipairs(minetest.get_connected_players()) do
			local satiation = stamina.get_saturation(player)
			local meta = player:get_meta()
			local id = meta:get_int("sepia")
			if satiation <= 1 then
				if id == 0 then
					sepia.set_sepia_blind(player)
				end
			elseif id ~= 0 then
				sepia.remove_sepia_blind(player, id)
			end
		end
		sepia_timer = 0
	end
end)