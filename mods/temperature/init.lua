temperature = {}
temperature.registered_on_temp_tick = {}
local huds = {}
local temp_tick = 5
local temp_tick = 5
local cold_temp = 40
local hot_temp = 80
-- Api 
function temperature.get_temp_tick()
	return temp_tick
end

function temperature.get_cold_temp()
	return cold_temp
end

function temperature.get_hot_temp()
	return hot_temp
end

function temperature.get_adjusted_temp(pos)
	if pos == nil then
		return
	end
	local biome_data = minetest.get_biome_data(pos)
	local temp = biome_data.heat
	
	--adjust for environmental factors -- time of day, light level, elevation above/below sea level
	local timeofday = minetest.get_timeofday()
	local elevation_diff = math.abs(math.floor(pos.y/4))
	local above = pos
	above.y = above.y + 1
	-- Elevation
	temp = temp - elevation_diff
	-- Time of day
	if timeofday < 0.25 then -- Early morning make it cooler
		temp = temp - math.floor(timeofday*10)
	elseif timeofday > 0.4 and timeofday < 0.75 then -- Afternoon, make it hotter
		temp = temp + math.floor(timeofday*10)
	end
	-- Light level
	local light_level = minetest.get_node_light(above) or 0
	temp = temp + light_level
	-- special nodes in proximity impacting temperature
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

function get_hud_defs(player)
	local pos = player:get_pos()
	local temp = temperature.get_adjusted_temp(pos)
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

function temperature.register_on_temp_tick(func)
	table.insert(temperature.registered_on_temp_tick, func)
end

minetest.register_globalstep(function(dt)
	temp_timer = temp_timer + dt
	if temp_timer >= temp_tick then
		for i, player in ipairs(minetest.get_connected_players()) do
			local pos = player:get_pos()
			local temp = temperature.get_adjusted_temp(pos)
			huds_update(player)
			for _, func in ipairs(temperature.registered_on_temp_tick) do
				func(player, temp)
			end	
		end
		temp_timer = 0
	end
end)

if stamina ~= nil then
	dofile(minetest.get_modpath("temperature") .. "/stamina.lua")
end