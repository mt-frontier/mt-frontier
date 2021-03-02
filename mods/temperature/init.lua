local huds = {}
local temp_tick = 5
local freezing_temp = 40
local overheating_temp = 80
local base_exhaust_level = 5

local function get_temp(player)
	local pos = player:get_pos()
	local biome_data = minetest.get_biome_data(pos)
	local temp = biome_data.heat
	
	--adjust for environmental factors
	local timeofday = minetest.get_timeofday()
	local above = pos
	above.y = above.y + 1
	local ll = minetest.get_node_light(above) or 0
	if timeofday < 0.25 then
		temp = temp - 10
	elseif timeofday > 0.5 and timeofday < 0.7 then
		temp = temp + 5
	end
	
	temp = temp + ll

	local heat_nodes = minetest.find_nodes_in_area(
		vector.subtract(pos, 2), 
		vector.add(pos, 2), 
		{
			"group:igniter", 
			"default:furnace_active", 
			"fake_fire:embers", 
			"fake_fire:fake_fire", 
			"fake_fire:fake_fire_d", 
			"fake_fire:smokeless_fire",
		}
	)
	
	local cool_nodes = minetest.find_nodes_in_area(
		vector.subtract(pos, 0.5),
		vector.add(pos, 0.5), 
		{"group:cools_lava"}
	)
	
	local heat = 10 * #heat_nodes
	local cool = #cool_nodes
	temp = temp + heat - cool	
	return temp
end

local function get_exhaustion_level(temp)
	local exhaust_level = base_exhaust_level
	local diff = 0
	if temp <= freezing_temp then
		diff = math.ceil((freezing_temp - temp)/10)
	elseif temp >= overheating_temp then
		diff = math.ceil((overheating_temp - temp)/10)
	else
		exhaust_level = 0
	end
	return exhaust_level
end

function get_hud_defs(player)
	local temp = get_temp(player)
	local far = math.floor(temp)
	local cel = math.floor((far - 32) * (5/9))
	local percent = 0
	-- Assumes temperatures are around a scale of 0-100
	if temp > 100 then
		percent = 100
	elseif temp > 0 then
		percent = temp
	end 

local therm_hud_def = {
	hud_elem_type  = "image",
	position = {x = 0.02, y = 0.5},
	name = "thermometer",
	text = "therm.png^[lowpart:"
                        ..percent ..":temp.png",
	scale = {x = 4, y = 4},
}

local temp_hud_def = {
	hud_elem_type = "text",
	position = {x = 0.024, y = 0.51},
	number = 16777215,
	name = "temp",
	text = far .. " F \n\n\n\n\n\n "..cel .." C"
}

return therm_hud_def, temp_hud_def

end
local function add_temp_huds(player)
	--local therm_id = player:hud_add(temp_hud_def)
	--if id ~= nil then
	--	huds[player:get_player_name()][1] = id
	--end
	local hud1, hud2 = get_hud_defs(player)
	local name = player:get_player_name()
	huds[name][1] = player:hud_add(hud1)
	huds[name][2] = player:hud_add(hud2)
end

local function huds_update(player)
	local hud1, hud2 = get_hud_defs(player)
	local name = player:get_player_name()
	player:hud_change(huds[name][1], "text", hud1["text"])
	player:hud_change(huds[name][2], "text", hud2["text"])
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	huds[name] = {}
	add_temp_huds(player)
end)

minetest.register_on_leaveplayer(function(player)
	huds[player:get_player_name()] = nil
end)

local temp_timer = 0

minetest.register_globalstep(function(dt)
	temp_timer = temp_timer + dt
	if temp_timer >= temp_tick then
		for i, player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			local temp = get_temp(player)
			huds_update(player)	
			if minetest.get_modpath("stamina") then
				local exhaust_level = get_exhaustion_level(temp)
				stamina.exhaust_player(player, exhaust_level, "temperature")
			end
		end	
		temp_timer = 0
	end
end)
