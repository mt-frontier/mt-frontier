-- Increase exhaustion in extreme temperatures
temperature.register_on_temp_tick(function(player,temp)
    local hot = temperature.get_hot_temp()
    local cold = temperature.get_cold_temp()
    if temp >= cold and temp <= hot then
        return
    elseif temp > hot then
        stamina.exhaust_player(player, (temp-hot)*2, "heat")
    elseif temp < cold then
        stamina.exhaust_player(player, (cold-temp)*2, "cold")
    end
end)