seasons = {}
local mod_storage = minetest.get_mod_storage()
local default_time_speed = minetest.settings:get("time_speed")
local base_time_speed = default_time_speed or 60
local days_per_season = minetest.settings:get("seasons.days_per_season") or 30
local time_speed_delta_divisor = minetest.settings:get("seasons.time_speed_delta_divisor") or 5
local season_update_tick = minetest.settings:get("seasons.season_update_tick") or 20

-- API
seasons.set_season = function(season_name)
    assert(season_name == "spring" or season_name == "summer" or season_name == "fall" or season_name == "winter",
        "Valid season names are spring, summer, fall, winter"
    )
    mod_storage:set_string("season", season_name)
end

seasons.get_season = function()
    return mod_storage:get_string("season")
end

seasons.set_day_number = function(day_number)
    assert(type(day_number) == "number", "day_number must be an integer")
    mod_storage:set_int("day_number", day_number)
end

seasons.get_day = function()
    return mod_storage:get_int("day_number"), days_per_season
end

seasons.get_time_speed = function()
    return tonumber(minetest.settings:get("time_speed"))
end

seasons.get_base_time_speed = function ()
    return base_time_speed
end

seasons.change_season = function()
    seasons.set_day_number(1)
    local season = seasons.get_season()
    if season == "spring" then
        seasons.set_season("summer")
    elseif season == "summer" then
        seasons.set_season("fall")
    elseif season == "fall" then
        seasons.set_season("winter")
    else
        seasons.set_season("spring")
    end
end

-- local functions
local set_time_speed = function(time_speed)
    minetest.settings:set("time_speed", time_speed)
end

local update_time_speed = function()
    local season = seasons.get_season()
    local day, days_per_season = seasons.get_day()
    local time = minetest.get_timeofday()
    local time_speed_delta = 0
    -- Determine incremental amount to increase or decrease time speed to shorten or lengthen days/nights according to season
    if season == "spring" or season == "fall" then
        time_speed_delta = math.floor((day/days_per_season)*(base_time_speed/time_speed_delta_divisor))
    elseif season == "summer" or season == "winter" then
        time_speed_delta = math.floor(((days_per_season-(day-1))/days_per_season)*(base_time_speed/time_speed_delta_divisor))
    end
    -- Determine whether to increase or decrease time speed according to season and time of day
    if time >= 0.25 and time < 0.75 then -- Daytime
        if season == "spring" or season == "summer" then
            set_time_speed(base_time_speed-time_speed_delta) -- Longer days
        else -- Fall or winter
            set_time_speed(base_time_speed+time_speed_delta) -- Shorter days
        end
    else -- Night
        if season == "fall" or season == "winter" then
            set_time_speed(base_time_speed-time_speed_delta) -- Longer nights
        else -- Spring or summer
            set_time_speed(base_time_speed+time_speed_delta) -- Shorter nights
        end
    end
end

-- Initiate seasons on game start up.
if seasons.get_season() == "" then
    seasons.change_season()
end
--set time speed for current season and day
minetest.after(3, function()
    update_time_speed()
end)



-- Timer to handle updates to day, season and time speed
local season_timer = 0

minetest.register_globalstep(function(dtime)
    season_timer = season_timer+dtime
    if season_timer < season_update_tick then
        return
    end
    season_timer = 0
    local time = minetest.get_timeofday()*24000
    local tick_window = 1200*season_update_tick/60 -- leave a window to update slightly longer than tick incase of lag
    -- Update day number first tick after midnight
    if time <= tick_window then
        local day_number, days_per_season = seasons.get_day()
        day_number = day_number + 1
        if day_number > days_per_season then
            seasons.change_season()
        else
            seasons.set_day_number(day_number)
        end
    end
    -- Update time on first tick after dusk/dawn
    if (time >= 6000 and time < 6000+tick_window)
    or (time >= 18000 and time < 18000+tick_window) then
        update_time_speed()
    end
end)

-- Restore time speed in minetest.conf to default_time_speed on shutdown
minetest.register_on_shutdown(function()
    set_time_speed(default_time_speed)
end)

-- Chat command to get season info in game
minetest.register_chatcommand("season", {
    params = "",
    description = "Get current season information",
    func = function (name, param)
        local day, days_per_season = seasons.get_day()
        local info = "Day " .. day .. " of " .. days_per_season .. " of " .. seasons.get_season()
            .."\nTime: " .. math.floor(minetest.get_timeofday()*24000)
            .. "\nTime Speed: " .. seasons.get_time_speed()
        minetest.chat_send_player(name, info)
    end
})
-- Admin command to set season
minetest.register_chatcommand("set_season", {
    params = "season_name",
    description = "Set current season",
    privs = {settime=true},
    func = function(name, param)
        if param ~= "spring" and param ~= "summer" and param ~= "fall" and param ~= "winter" then
            minetest.chat_send_player(name, "Valid season names are spring, summer, fall or winter")
            return false
        end
        seasons.set_season(param)
        update_time_speed()
        minetest.chat_send_player(name, "Season set to ".. param)
    end
})

-- Admin command to set day of season
minetest.register_chatcommand("set_day", {
    params = "day_number",
    description = "Set season's day number",
    privs = {settime=true},
    func = function(name, param)
        day_number = tonumber(param)
        if day_number <= 0 or day_number > days_per_season then
            minetest.chat_send_player(name, "day_number must be between 1 and " .. days_per_season)
            return false
        else
            seasons.set_day_number(day_number)
            update_time_speed()
            minetest.chat_send_player(name, "Day number set to " .. day_number)
        end
    end
})
