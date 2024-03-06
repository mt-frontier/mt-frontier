temperature = {}
temperature.registered_on_temp_tick = {}
local temp_tick = minetest.settings:get("temperature.tick") or 6
local cold_temp = minetest.settings:get("temperature.cold_temp") or 40
local hot_temp = minetest.settings:get("temperature.hot_temp") or 90

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
	
	--Adjust for environmental factors
	-- Seasons
	if seasons then
		
		local season_temp_delta = 20
		local season = seasons.get_season()
		local day , days_per_season = seasons.get_day()
		local season_percent = day/days_per_season

		if season == "spring" then
			temp = temp - math.floor((1-season_percent)*season_temp_delta)

			-- if season_percent < 0.5 then
			-- 	temp = temp - math.floor((1-season_percent)*season_temp_delta/2)
			-- else
			-- 	temp = temp + math.floor(season_percent*season_temp_delta/2)
			-- end

		elseif season == "summer" then
			if season_percent < 0.5 then
				temp = temp + math.floor((1-season_percent)*season_temp_delta/2)
			--temp = temp + math.floor(season_percent*season_temp_delta)
			elseif season_percent < 0.8 then -- Heatwave
				temp = temp + season_temp_delta/2
			else
				temp = temp + math.floor((1-season_percent)*season_temp_delta/2)
			end
		elseif season == "fall" then
			temp = temp - math.floor((season_percent)*season_temp_delta)

			-- if season_percent < 0.5 then
			-- 	temp = temp + math.floor((1-season_percent)*season_temp_delta/2)
			-- else
			-- 	temp = temp - math.floor((season_percent)*season_temp_delta/2)
			-- end
		elseif season == "winter" then
			
			temp = temp - season_temp_delta/2
			if season_percent < 0.5 then
				temp = temp - math.floor(season_percent*season_temp_delta)
			elseif season_percent < 0.75 then
				temp = temp - season_temp_delta
			else
				temp = temp - math.floor((1-season_percent)*season_temp_delta)
			end
		end
	end
	-- Elevation
	local elevation_diff = math.abs(math.floor(pos.y/4))
	temp = temp - elevation_diff
	
	-- Time of day
	local timeofday = minetest.get_timeofday()
	-- Early morning make it cooler
	if timeofday < 0.25 then
		temp = temp - math.floor(timeofday*10)
	elseif timeofday > 0.4 and timeofday < 0.75 then -- Afternoon, make it hotter
		temp = temp + math.floor(timeofday*10)
	end
	
	-- Light level
	local above = table.copy(pos)
	above.y = above.y + 1
	local light_level = minetest.get_node_light(above) or 0
	temp = temp + light_level
	-- special nodes in proximity impacting temperature
	local heat_nodes = minetest.find_nodes_in_area(
		vector.subtract(pos, 2),
		vector.add(pos, 2),
		{
			"group:igniter",
			"default:furnace_active",
			"frontier_craft:forge_active",
			"frontier_craft:embers",
			"frontier_craft:basic_fire",
		}
	)

	local cool_nodes = minetest.find_nodes_in_area(
		vector.subtract(pos, 0.5),
		vector.add(pos, 0.5),
		{"group:cools_lava"}
	)
	
	local heat = 8 * #heat_nodes
	local cool = #cool_nodes
	temp = temp + heat - cool
	return temp
end

-- Temp update timer

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
			for _, func in ipairs(temperature.registered_on_temp_tick) do
				func(player, temp)
			end
		end
		temp_timer = 0
	end
end)


local mp = minetest.get_modpath("temperature")
dofile(mp .. "/statbar.lua")
if stamina ~= nil then
	dofile(mp .. "/stamina.lua")
end