-- lumberJack 2021
-- MIT license 
affliction = {}
affliction.tick = 4
affliction.max_affliction = 1000
affliction.registered_afflictions = {} -- Dictionary of affliction names, and table definition including types, duration and 
affliction.registered_treatments = {}  -- Dict of treatments. 
affliction.registered_on_affliction_tick = {} -- List of functions called with player as argument every affliction.tick
local huds = {}
affliction.types = {
    "digestive", -- cannot raise satiation > 6
    "fatigue", -- exhaustion penalty like extreme temps
    "blindness", -- sepia mod
    "poison",  -- handled by stamina
    "sprain", -- cannot run
    "bleeding", -- Attracts wolves
    "intoxication", -- direction/yaw of player is randomly adjusted to impair walking
    "cold",
    "hot",
}

-- API/open functionsshock
function affliction.register_affliction(affliction_name, affliction_table)
    -- affliction_table is a dictionary of types/symptoms and their duration in seconds
    affliction.registered_afflictions[affliction_name] = affliction_table
end

function affliction.register_treatment(itemname, affliction_table)
    affliction.registered_treatments[itemname] = affliction_table
end

function affliction.register_on_affliction_tick(func)
    table.insert(affliction.registered_on_affliction_tick, func)
end

local function num_active_huds(player)
    local player_name = player:get_player_name()
    local count = 0
    if huds[player_name] ~= nil then
        for symptom, duration in pairs(huds[player_name]) do
            if duration > 0 then
                count = count + 1    
            end
        end
    end
    return count
end

function affliction.add_hud(player, symptom)
    local player_name = player:get_player_name()
    if huds[player_name] == nil then
        huds[player_name] = {}
    end
    if huds[player_name][symptom] ~= nil then
        return
    end
    local index = num_active_huds(player) + 1
    local hud_def = {
        hud_elem_type  = "image",
        position = {x = 0.96, y = 0.1 * index},
        text = "affliction_"..symptom..".png",
        name = symptom,
        scale = {x = 2, y = 2},
    }
    local id = player:hud_add(hud_def)

    huds[player_name][symptom] = id
    minetest.chat_send_player(player:get_player_name(), "Affliction: " .. symptom .. "!")
end

function affliction.get_hud_id(player, symptom)
    local player_name = player:get_player_name()
    if huds[player_name] == nil then
        return nil
    end
    if huds[player_name][symptom] == nil then
        return nil
    end
    return huds[player_name][symptom]
end

function affliction.remove_hud(player, symptom)
    local player_name = player:get_player_name()
    local id = affliction.get_hud_id(player, symptom)
    if huds[player_name] ~= nil then
        huds[player_name][symptom] = nil
    end
    if id == nil then
        return
    end
    player:hud_remove(id)
    minetest.chat_send_player(player:get_player_name(), "Affliction healed: " .. symptom)
end

function affliction.afflict(player, affliction_name)
    local symptoms = affliction.registered_afflictions[affliction_name]
    for symptom, duration in pairs(symptoms) do
        local meta = player:get_meta()
        local current_duration = meta:get_int(symptom) or 0
        current_duration = current_duration + duration
        meta:set_int(symptom, current_duration)
        local id = affliction.get_hud_id(player, symptom)
        if id == nil then
            affliction.add_hud(player, symptom)
        end
    end
    
end

function affliction.heal(player, affliction_type)
    local player_name = player:get_player_name()
    local meta = player:get_meta()
    if meta:get_int(affliction_type) ~= 0 then
           meta:set_int(affliction_type, 0)
    end
    local id = affliction.get_hud_id(player, affliction_type)
    if id then
        affliction.remove_hud(player, affliction_type)
    end
end

function affliction.treat(player, treatment_name)
    local meta = player:get_meta()
    local treatment = affliction.registered_treatments[treatment_name]
    for symptom, time_removed in pairs(treatment) do
        local heal_time = affliction.get_affliction_total(player, symptom)
        heal_time = heal_time - time_removed
        if heal_time > 0 then
            meta:set_int(symptom, heal_time)
        end
        if heal_time <= 0 then
            affliction.heal(player, symptom)
        end
    end
end

function affliction.get_affliction_total(player, symptom)
    local meta = player:get_meta()
    local symptom_total = meta:get_int(symptom)
    return symptom_total
end

function affliction.chance_damage(player, symptom)
    local player_name = player:get_player_name()
    local affliction_total = affliction.get_affliction_total(player, symptom)
    local chance = affliction_total/affliction.max_affliction
    if chance > math.random() then
        local hp = player:get_hp()
        local damage = math.floor(chance*10)
        hp = hp - damage
        player:set_hp(hp, symptom)
        minetest.chat_send_player(player_name, "Affliction! Critical " .. symptom)
    end
end
-- Globalstep
local timer = 0
minetest.register_globalstep(function(dt)
    timer = timer + dt
    if timer < affliction.tick then
        return
    end
    for _, player in ipairs(minetest.get_connected_players()) do
        for _, func in ipairs(affliction.registered_on_affliction_tick) do
            func(player)
        end
    end
    timer = 0
end)

affliction.register_on_affliction_tick(function(player)
    local meta = player:get_meta()
    local name = player:get_player_name()
    for _, symptom in ipairs(affliction.types) do
        local symptom_value = meta:get_int(symptom) or 0
        --print(name, symptom, ": ", symptom_value)
        affliction.chance_damage(player, symptom_value)
    end
end)
-------------
-- Implement affliction type effects
---------------

-- Injury/sprain
stamina.register_on_sprinting(function(player, sprinting)
    local meta = player:get_meta()
    local cannot_sprint = meta:get_int("sprain") > 0 
        or meta:get_int("hot") > 300 or meta:get_int("cold") > 300
    if cannot_sprint then
        return true
    end
end)

affliction.registered_on_player_hpchange = {}

function affliction.register_on_player_hpchange(func)
    table.insert(affliction.registered_on_player_hpchange, func)
end
--[[
minetest.register_on_player_hpchange(function(player, hpchange, reason)
    for _, func in ipairs(affliction.registered_on_player_hpchange) do
        hpchange = func(player, hpchange, reason)
    end
    
    local hp = player:get_hp()
    local meta = player:get_meta()
    local cannot_heal = meta:get_int("bleeding") > 0 
    if cannot_heal then
        if math.random() > 0.05 then
            local player_pos = player:get_pos()
            if player_pos == nil then
                return hpchange
            end 
            local wolf_nodes = {
                "default:snow", "default:snowblock", "default:stone", 
                "default:cave_ice", "default:dirt_with_coniferous_litter"
            }
            local spawn_nodes = minetest.find_nodes_in_area_under_air(
                vector.subtract(player_pos, 18),
                vector.add(player_pos, 18), wolf_nodes
            )
            if #spawn_nodes < 1 then
                return hpchange 
            end
            local spawn_pos = spawn_nodes[math.random(1, #spawn_nodes)]
            spawn_pos.y = spawn_pos.y + 1 
            local mob = minetest.add_entity(spawn_pos, "mobs_wolf:wolf")
        end
    end
end, true)

]]--
minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
    local item_name = itemstack:get_name()
    if affliction.registered_treatments[item_name] == nil then
        return 
    end
    affliction.treat(user, item_name)
end)

minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    local meta = player:get_meta()
    for _, symptom in ipairs(affliction.types) do
        local has_symptom = meta:get_int(symptom) > 0
        if has_symptom then
            affliction.add_hud(player, symptom)
        end
    end
end)

minetest.register_on_dieplayer(function(player, reason)
    local meta = player:get_meta()
    for _, symptom in ipairs(affliction.types) do
        affliction.heal(player, symptom)
    end
end)

--affliction.register_affliction("affliction:food_poisoning", {"digestive"=300})
--affliction.register_affliction("affliction:parasite", {"digestive"=600})
--affliction.register_affliction("affliction:hypothermia", {"exhaustion"=300})

dofile(minetest.get_modpath("affliction").."/wound.lua")
dofile(minetest.get_modpath("affliction").."/fatigue.lua")
--dofile(minetest.get_modpath("affliction") .. "/food_poison.lua")


