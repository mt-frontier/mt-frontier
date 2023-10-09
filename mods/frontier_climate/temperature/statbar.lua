local temp_bar_definition = {
	hud_elem_type = "statbar",
	position = {x=0.5, y=1},
	offset = {x = 30, y = -(64 + 24 + 24)},
    text = "therm_stat.png",
	number = 0,
	direction = 0,
	size = {x=24, y=24},
}

local temp_hud_def = {
	hud_elem_type = "text",
	position = {x=0.5, y=1},
	offset = {x = (5 * 24) + 25, y = -(64 + 24 + 32)},
	number = 16777215,
	name = "temp",
	text = ""
}

local function temp_to_stat_number(temp)
    local min_temp = temperature.get_cold_temp()
    local max_temp = temperature.get_hot_temp()
    local unit = math.floor((max_temp-min_temp)/20)
    local stat = (temp-temperature.get_cold_temp())/unit
    if stat < 1 then
        stat = 1
    elseif stat > 20 then
        stat = 20
    end
    return stat
end

local function temp_to_hud_text(temp)
    local far = math.floor(temp)
	local cel = math.floor((far - 32) * (5/9))
    return far .. " F / "..cel .." C"
end

minetest.register_on_joinplayer(function(player)
    -- Add temperature statbar hud
    local temp_bar = table.copy(temp_bar_definition)
    local temp_text = table.copy(temp_hud_def)
    local pos = player:get_pos()
    if pos ~= nil then
        local temp = temperature.get_adjusted_temp(pos)
        temp_bar['number'] = temp_to_stat_number(temp)
        temp_text['text'] = temp_to_hud_text(temp)
    end
    -- Statbar
    local meta = player:get_meta()

    local stat_id = player:hud_add(temp_bar)
    meta:set_int("temp_stat_id", stat_id)
    -- Text Temperature reading
    local temp_text_id = player:hud_add(temp_hud_def)
    meta:set_int("temp_text_id", temp_text_id)
end)

temperature.register_on_temp_tick(function(player, temp)
    local meta = player:get_meta()
    local statbar_id = meta:get_int("temp_stat_id")
    local temp_text_id = meta:get_int("temp_text_id")
    if statbar_id ~= nil then
        player:hud_change(statbar_id, 'number', temp_to_stat_number(temp))
    end
    if temp_text_id ~= nil then
        player:hud_change(temp_text_id, 'text', temp_to_hud_text(temp))
    end
end)