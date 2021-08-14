local hypothermic_temp = 22
local heat_stroke_temp = 96
local temp_tick = temperature.get_temp_tick()
local waterskin_uses = 5

minetest.register_craftitem("affliction:fatigue", {
    description = "Fatigue from environmental extremes. Heals in moderate temperatures",
    inventory_image = "affliction:fatigue.png",
    stack_max = 1,
    groups = {affliction = 1}
})

minetest.register_tool("affliction:waterskin", {
    description = "Waterskin. Fill with potable water ",
    inventory_image = "affliction_waterskin.png",
	liquids_pointable = true,
	range = 2.5,
	stack_max = 1,
	wear = 65535,
	tool_capabilities = {},
	on_use = function(itemstack, user, pointed_thing)
		local pos = pointed_thing.under
		-- filling it up?
		local wear = itemstack:get_wear()
        if pos ~= nil then
            if minetest.get_item_group(minetest.get_node(pos).name, "water") >= 3 then
                if wear ~= 1 then
                    minetest.sound_play("crops_watercan_entering", {pos=pos, gain=0.8})
                    minetest.after(math.random()/2, function(p)
                        minetest.sound_play("crops_watercan_splash_quiet", {pos=p, gain=0.1})
                    end)	
                    itemstack:set_wear(1)
                end
                return itemstack
            end
        end
        if wear == 65534 then
			return itemstack
		end
        affliction.treat(user, itemstack:get_name())
        print(wear)
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:set_wear(math.min(65534, wear + (65535 / waterskin_uses)))
		end
		return itemstack
	end,
})

minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
	local info = inventory_info
	if info.stack then
		local stackname = info.stack:get_name()
		if stackname == "affliction:fatigue" then
            return 0
        end
    end
end)

affliction.register_affliction("hypothermia_risk", {cold = temp_tick})
affliction.register_affliction("heat_stroke_risk", {hot = temp_tick})
affliction.register_treatment("moderate_temp", {cold = 2*temp_tick, hot = 2*temp_tick})
affliction.register_treatment("hot_temp", {cold= 3*temp_tick})
affliction.register_treatment("cold_temp", {hot=3*temp_tick})
affliction.register_treatment("affliction:waterskin", {hot=100})



local function get_factor(a,b)
    local diff = math.abs(a-b)
    local factor = diff/10 + 1
    return factor
end
-- Increase risk of hypothermia/heat_stroke
affliction.register_on_affliction_tick(function(player)
    if player == nil then
        return
    end
    
    local temp = temperature.get_adjusted_temp(player:get_pos())
    if temp > hypothermic_temp and temp < heat_stroke_temp then
        affliction.treat(player, "moderate_temp")
    elseif temp < hypothermic_temp then
        affliction.treat(player, "cold_temp")
        affliction.afflict(player, "hypothermia_risk")
    elseif temp > heat_stroke_temp then
        affliction.treat(player, "hot_temp")
        affliction.afflict(player, "heat_stroke_risk")
    end
end)
-- Exhaust faster under extreme conditions
stamina.register_on_exhaust_player(function(player, change, cause)
    if player == nil then
        return
    end
    
    local temp = temperature.get_adjusted_temp(player:get_pos())
    local ambient_exhaustion_factor = 0
    if temp > hypothermic_temp and temp < heat_stroke_temp then
        return false
    end
    -- Increase exhaustion by factor of temperture extremes
    if temp <= hypothermic_temp then
        ambient_exhaustion_factor = get_factor(temp, hypothermic_temp)
    else
        ambient_exhaustion_factor = get_factor(temp, heat_stroke_temp)
    end
    change = change * ambient_exhaustion_factor
    change = math.floor(change*10)/10

    local exhaustion = stamina.get_exhaustion(player) or 0
	exhaustion = exhaustion + change
	if exhaustion >= stamina.settings.exhaust_lvl then
		exhaustion = exhaustion - stamina.settings.exhaust_lvl
		stamina.change(player, -1)
	end
	stamina.set_exhaustion(player, exhaustion)
    return true
end)