# Affliction

Lightweight affliction framework for registering afflictions, treatments and managing players' affliction states. Works with Stamina and Temperature mod to implement basic environmental/temperature-related afflictions.

Afflictions are stored as an key/integer in players' metadata. Callbacks on the affliction timer may be called increasing or decreasing the total integer value for a given affliction. Players have a chance to take damage that increases in probability and severity as the affliction's stored value increases every affliction timer tick. Similarly treatments can decrease this value and a call to cure the affliction clears it from the players metadata. Afflictions can be registered as needed and referenced in order for mods to implement any additional desired buffs/debuffs.

Depends on stamina, temperature

### API
`affliction.register_affliction(affliction_name, affliction_table)`
`affliction.register_treatment(itemname, affliction_table)`

function affliction.afflict(player, affliction_name)
    local symptoms = affliction.registered_afflictions[affliction_name]
    for symptom, duration in pairs(symptoms) do
        local meta = player:get_meta()
        local current_duration = meta:get_int(symptom) or 0
        current_duration = current_duration + duration
        meta:set_int(symptom, current_duration)
    end
    minetest.chat_send_player(player:get_player_name(), "Affliction: " .. affliction_name .. "!")
    
end

function affliction.cure(player, affliction_type)
    local meta = player:get_meta()
    if meta:get_int(affliction_type) ~= nil then
           meta:set_int(affliction_type, nil)
    end
end

function affliction.treat(player, affliction_type, treatment_time)
    local meta = player:get_meta()
    local duration = meta:get_int(affliction_type)
    if duration > treatment_time then
        duration = duration - treatment_time
    else
        affliction.cure(player, affliction_type)
    end
end


lumberJack 2021

MIT license