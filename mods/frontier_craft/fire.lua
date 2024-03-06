-- Adapted from minetest game fire mod 
-- Include embers which can be used as a basic cooking crafting station

fire = {}
fire.settings = {
    max_burntime = minetest.settings:get("fire.max_burntime") or 400,
     -- item entity offset for entities of items placed on crafting stations
     item_entity_offset = 0.625
}

fire.update_infotext = function(pos)
    local meta = minetest.get_meta(pos)
    local burntime = meta:get_int("burntime")
    local infotext = "Remaining burn time: " .. burntime .."\nAdd fuel for more time"
    local inv = meta:get_inventory()
    if not inv:is_empty('input') then
        local cook_time = meta:get_int('cook_time')
        if fire.get_cooking_result(inv:get_stack('input',1)):get_count() ~= 0 then
            infotext = infotext .. "\nCooking: "
        else
            infotext = infotext .. "\nBurning: "
        end
        infotext = infotext .. meta:get_inventory():get_stack('input', 1):get_description()
        .. " in " .. cook_time .. " seconds"
    end
    meta:set_string('infotext', infotext)
end
-- Get fuel burntime
fire.fuel_burntime = function(itemstring)
    return minetest.get_craft_result({
        method = "fuel",
        items = {itemstring}
    }).time
end

-- Look up cooking recipe results. return cooked item and cooking time
fire.get_cooking_result = function(itemstring)
    local result = minetest.get_craft_result({
        method = "cooking",
        width = 1,
        items = {itemstring}
    })
    return result.item, result.time
end

-- Place basic fire such as with flint and steel
fire.place = function(pos, burntime)
    burntime = burntime or 0
    local node = minetest.get_node(pos)
    if node.name == "air" then
        minetest.set_node(pos, {name="frontier_craft:basic_fire"})
    end

    local drops = minetest.get_node_drops(node)
    for _, item in ipairs(drops) do
        burntime = burntime + fire.fuel_burntime(item)
    end
    local meta = minetest.get_meta(pos)
    meta:set_int("burntime", burntime)

    minetest.swap_node(pos, {name = "frontier_craft:basic_fire"})
    minetest.get_node_timer(pos):start(1)
    fire.update_infotext(pos)
end

-- Place embers and transfer burntime to fire
fire.place_embers = function(pos, node, burntime)
    burntime = burntime or 0
    local above_meta = minetest.get_meta({x=pos.x, y=pos.y+1, z=pos.z})
    local above_burntime = above_meta:get_int("burntime")
    if above_burntime > 0 then
        burntime = burntime + above_burntime
    end
    local meta = minetest.get_meta(pos)
    if minetest.get_item_group(node.name, "flammable") > 0 then
        burntime = burntime + fire.fuel_burntime(node.name)
    elseif minetest.get_item_group(node.name, "soil") > 0 then
        meta:set_string("embers_old_node", node.name)
    end
    if burntime > 0 then
        meta:set_int("burntime", burntime)
        above_meta:set_int("burntime", burntime)
    end
    minetest.swap_node(pos, {name="frontier_craft:embers"})
    meta:get_inventory(pos):set_size('input', 1)
    minetest.get_node_timer(pos):start(1)
    fire.update_infotext(pos)
end

fire.dig_embers = function(pos, node, digger)
    local meta = minetest.get_meta(pos)
    local burntime = meta:get_int("burntime")
    local drops = {}
    -- Return any inputs/cooked items in inventory
    table.insert(drops, meta:get_inventory():get_stack('input', 1))
    frontier_craft.remove_item_entity(pos, node)

    -- Coal can be salvaged as drops from embers with significant burn time left
    for n = 1, math.floor(burntime/fire.fuel_burntime("default:coal_lump")) do
        table.insert(drops, "default:coal_lump")
    end
    -- replace old node if not cosumed as fuel
    if meta:get_string("embers_old_node") ~= "" then
        minetest.set_node({name=meta:get_string("embers_old_node")})
    else
        local above = {x=pos.x, y=pos.y+1, z=pos.z}
        minetest.remove_node(pos)
        if minetest.get_node(above).name == "frontier_craft:basic_fire" then
            minetest.dig_node(above)
        end
    end
    -- drops
    core.handle_node_drops(pos, drops, digger)
    return true
end
-- Add fuel to fire or embers
fire.add_fuel = function(pos, itemstack)
    local burntime = fire.fuel_burntime(itemstack:get_name())
    local meta = minetest.get_meta(pos)

    if burntime == 0 then
        local droplist = minetest.get_node_drops({name=itemstack})
        for _, item in ipairs(droplist) do
            burntime = burntime + fire.fuel_burntime(item)
        end
    end
    if burntime > 0 then
        if meta:get_int("burntime") < fire.settings.max_burntime then
            itemstack:take_item()
            burntime = math.min(fire.settings.max_burntime, meta:get_int("burntime")+burntime)
        end
    elseif minetest.get_item_group(itemstack:get_name(), "flammable") > 1 then
        burntime = meta:get_int("burntime")+2
        itemstack:take_item()
    end

    meta:set_int("burntime", burntime)
    -- Update embers below fire if fuel is added to fire
    if minetest.get_node(pos).name == "frontier_craft:basic_fire" then
        local below = {x=pos.x, y=pos.y-1, z=pos.z}
        if minetest.get_node(below).name == "frontier_craft:embers" then
            local below_meta = minetest.get_meta(below)
            below_meta:set_int("burntime", burntime)
        end
    end



    return itemstack
end

--place item to be cooked on embers
fire.take_item = function(pos, placer, itemstack)
    if minetest.is_protected(pos, placer:get_player_name()) then
        return itemstack
    end

    if minetest.get_item_group(itemstack:get_name(), "cooking_pot") > 0 then
        -- place pots
        if minetest.get_node(pos).name == "frontier_craft:embers" then
            pos.y = pos.y + 1
        end
        return pot.place(pos, placer, itemstack)
    end

    local cooked_item, cook_time = fire.get_cooking_result(itemstack:get_name())
    if cook_time == 0 then
        return itemstack
    end
    if minetest.get_node(pos).name ~= "frontier_craft:embers" then
        pos.y = pos.y-1
        if minetest.get_node(pos).name ~= "frontier_craft:embers" then
            return itemstack
        end
    end
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local stack = itemstack:take_item()
    inv:set_stack('input', 1, stack)
    meta:set_int('cook_time', cook_time)
    frontier_craft.update_item_entity(pos, node, fire.settings.item_entity_offset)
    pos.y = pos.y+1
    if minetest.get_node(pos).name == "frontier_craft:basic_fire" then
        minetest.remove_node(pos)
    end
    return itemstack
end


-- Fire sound from minetest game fire mod
local flame_sound = minetest.settings:get_bool("flame_sound")
if flame_sound == nil then
	-- Enable if no setting present
	flame_sound = true
end

if flame_sound then

	local handles = {}
	local timer = 0

	-- Parameters

	local radius = 8 -- Flame node search radius around player
	local cycle = 3 -- Cycle time for sound updates

	-- Update sound for player

	function fire.update_player_sound(player)
		local player_name = player:get_player_name()
		-- Search for flame nodes in radius around player
		local ppos = player:get_pos()
		local areamin = vector.subtract(ppos, radius)
		local areamax = vector.add(ppos, radius)
		local fpos, num = minetest.find_nodes_in_area(
			areamin,
			areamax,
			{"frontier_craft:basic_fire"}
		)
		-- Total number of flames in radius
		local flames = (num["frontier_craft:basic_fire"] or 0)
		-- Stop previous sound
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
		end
		-- If flames
		if flames > 0 then
			-- Find centre of flame positions
			local fposmid = fpos[1]
			-- If more than 1 flame
			if #fpos > 1 then
				local fposmin = areamax
				local fposmax = areamin
				for i = 1, #fpos do
					local fposi = fpos[i]
					if fposi.x > fposmax.x then
						fposmax.x = fposi.x
					end
					if fposi.y > fposmax.y then
						fposmax.y = fposi.y
					end
					if fposi.z > fposmax.z then
						fposmax.z = fposi.z
					end
					if fposi.x < fposmin.x then
						fposmin.x = fposi.x
					end
					if fposi.y < fposmin.y then
						fposmin.y = fposi.y
					end
					if fposi.z < fposmin.z then
						fposmin.z = fposi.z
					end
				end
				fposmid = vector.divide(vector.add(fposmin, fposmax), 2)
			end
			-- Play sound
			local handle = minetest.sound_play(
				"fire_fire",
				{
					pos = fposmid,
					to_player = player_name,
					gain = math.min(0.06 * (1 + flames * 0.125), 0.18),
					max_hear_distance = 32,
					loop = true, -- In case of lag
				}
			)
			-- Store sound handle for this player
			if handle then
				handles[player_name] = handle
			end
		end
	end

	-- Cycle for updating players sounds

	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer < cycle then
			return
		end

		timer = 0
		local players = minetest.get_connected_players()
		for n = 1, #players do
			fire.update_player_sound(players[n])
		end
	end)

	-- Stop sound and clear handle on player leave

	minetest.register_on_leaveplayer(function(player)
		local player_name = player:get_player_name()
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
		end
	end)
end

-- Flood flame function
local function flood_flame(pos, oldnode, newnode)
	-- Play flame extinguish sound if liquid is not an 'igniter'
	local nodedef = minetest.registered_items[newnode.name]
	if not (nodedef and nodedef.groups and
			nodedef.groups.igniter and nodedef.groups.igniter > 0) then
		minetest.sound_play("fire_extinguish_flame",
			{pos = pos, max_hear_distance = 16, gain = 0.15})
	end
	-- Remove the flame
	return false
end

-- Fire wood
minetest.register_node("frontier_craft:firewood", {
    description = "Firewood Bundle",
    drawtype = "plantlike",
    tiles = {"frontier_craft_firewood.png"},
    inventory_image = "frontier_craft_firewood_bundle.png",
    wield_image = "frontier_craft_firewood_bundle.png",
    paramtype = "light",
	paramtype2 = "meshoptions",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed ={
			{-1/2, -1/4 , -1/2, 1/2, -1/2, 1/2}
		}
	},
    groups = {choppy=3, oddly_breakable_by_hand=2, flammable=1, attached_node=1},
    after_place_node = function(pos)
		minetest.set_node(pos, {name = "frontier_craft:firewood", param2 = 2})
	end,
    on_ignite = function(pos, user)
        local under = {x=pos.x, y=pos.y-1, z=pos.z}
        fire.place(pos)
        fire.place_embers(under, minetest.get_node(under))
    end,
})

-- Flame nodes
minetest.register_node("frontier_craft:basic_fire", {
    description = "Fire",
	drawtype = "firelike",
	tiles = {
		{
			name = "fire_basic_flame_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1
			},
		},
	},
	inventory_image = "fire_basic_flame.png",
	paramtype = "light",
	light_source = 13,
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	floodable = true,
	damage_per_second = 4,
	groups = {attached_node = 1, igniter = 2, dig_immediate = 3, not_in_creative_inventory = 1},
	drop = "",
	on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local burntime = meta:get_int("burntime")-elapsed
        local below = {x=pos.x, y=pos.y-1, z=pos.z}
        local node_below = minetest.get_node(below)
        local below_meta = minetest.get_meta(below)

        fire.update_infotext(pos)
        -- Extinguish fire if not sustained by embers being fueled
        if burntime < 1 then
            local near_node_pos = minetest.find_node_near(pos, 1, {"group:flammable"})
            if node_below.name == "frontier_craft:embers"
            and below_meta:get_int("burntime") > 10 then
                return true
            -- higher temperatures and low fuel create risk of fire spread to nearby flammables
            elseif near_node_pos and math.random(20,120) < temperature.get_adjusted_temp(near_node_pos) then
                if minetest.registered_nodes[minetest.get_node(near_node_pos).name].drawtype ~= "normal" then
                    fire.place(near_node_pos)
                else
                    local above = {x=near_node_pos.x, y=near_node_pos.y+1, z=near_node_pos.z}
                    if minetest.get_node(above).name == "air" then
                        fire.place(above)
                    end
                end
            end
            minetest.remove_node(pos)
            return
        -- Fueled fires can place embers below on soil or other flammable nodes
        elseif burntime > 20 and math.random(0,3) == 3
        and node_below.name ~= "frontier_craft:embers" then
            fire.place_embers(below, node_below, burntime)
        end
        meta:set_int("burntime", burntime)
		-- Restart timer
		return true
	end,

	on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local burntime = meta:get_int("burntime")
        minetest.get_node_timer(pos):start(1)
        meta:set_int("burntime", math.min(0, burntime-1))
        fire.update_infotext(pos)
    end,

    -- Fuel, cooking items are added to fire by right clicking
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        print(itemstack:get_name())
        if fire.fuel_burntime(itemstack:get_name()) > 0 then
            return fire.add_fuel(pos, itemstack)
        elseif itemstack:get_count() > 0 then
            return fire.take_item(pos, clicker, itemstack)
        end
        return itemstack
    end,

    -- on_dig = function(pos, node, digger)
    --     local burntime = minetest.get_meta(pos):get_int("burntime")
    --     local below = {x=pos.x, y=pos.y-1, z=pos.z}
    --     if burntime > 0 and minetest.get_node(below).name == "frontier_craft:embers" then
    --         local meta = minetest.get_meta(below)
    --         local ember_burntime = meta:get_int("burntime")
    --         meta:set_int("burntime", ember_burntime+burntime)
    --     end
    --     minetest.remove_node(pos)
    --     return true
    -- end,

	on_flood = flood_flame,
})

-- Embers adapted from fake_fire mod 
    -- Spawn under fires with sufficient fuel, 
    -- sustain flame above and can be used for cooking

minetest.register_node("frontier_craft:embers", {
    description = "Glowing Embers",
    tiles = {
        {
			name = "embers_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0
			},
		},
	},
    is_ground_content = false,
    light_source = 8,
	paramtype = "light",
    groups = {not_in_creative_inventory=1, igniter=2, choppy=3, crumbly=3, oddly_breakable_by_hand=3},
    drop = {},
    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local burntime = meta:get_int("burntime")-elapsed
        local above = {x=pos.x, y=pos.y+1, z=pos.z}
        local inv = meta:get_inventory()
        if minetest.get_node(above).name == "frontier_craft:basic_fire" then
            local above_meta = minetest.get_meta(above)
            above_meta:set_int("burntime", burntime)
        end
        -- Embers die
        if burntime < 1 then
            if minetest.get_node(above).name == "frontier_craft:basic_fire" then
                local above_meta = minetest.get_meta(above)
                local above_burntime = above_meta:get_int("burntime")
                -- check above meta so embers never burn out before a fueled flame above
                if above_burntime > 1 then
                    fire.update_infotext(pos)
                    -- Restart timer
                    return true
                end
            end
            local old_node_name = meta:get_string("embers_old_node")
            if old_node_name == "" then
                old_node_name = "air"
            end

            -- Drop input when embers burn out
            if not inv:is_empty('input') then
                minetest.item_drop(inv:get_stack('input', 1), nil, pos)
                frontier_craft.remove_item_entity(pos)
            end
            minetest.set_node(pos, {name=old_node_name})
            return
        -- Cook input
        elseif not inv:is_empty('input') then
            local cook_time = meta:get_int('cook_time')-elapsed
            meta:set_int('cook_time', cook_time)
            if cook_time <= 0 then
                -- Convert to cooked item if cooktime is 0
                local cooked_item, time_to_burn = fire.get_cooking_result(inv:get_stack('input',1):get_name())
                inv:set_stack('input', 1, cooked_item)
                meta:set_int('cook_time', time_to_burn+3)
                if not inv:is_empty('input') then
                    frontier_craft.remove_item_entity(pos)
                    frontier_craft.update_item_entity(pos, node, fire.settings.item_entity_offset)
                else
                   frontier_craft.remove_item_entity(pos)
                end
            end
        end
        if minetest.get_node(above).name == "air" and burntime > 10 and inv:is_empty('input') then
            if math.random(0,3) == 3 then
                fire.place(above, burntime)
            end
        end
        meta:set_int("burntime", burntime)
        fire.update_infotext(pos)
		-- Restart timer
		return true
	end,
    -- Add inventory for inputs for cooking
    on_construct = function(pos)
        local meta = minetest.get_inventory(pos)
        local inv = meta:get_inventory()
        inv:set_size('input', 1)
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname ~= "input" then
			return 0
		end
		if not frontier_craft.has_access(pos, player) then
            return 0
		end
		return 1
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if not frontier_craft.has_access(pos, player) then
			return 0
		end
		if listname ~= "input" then
			return 0
		end
		return 1
	end,
    -- Add fuel or cook foods
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if fire.fuel_burntime(itemstack:get_name()) > 0 then
            return fire.add_fuel(pos, itemstack)
        else
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local stack = inv:get_stack('input',1)
            if stack:get_count() == 0 then
                itemstack = fire.take_item(pos, clicker, itemstack)
            elseif itemstack:get_count() == 0 or (itemstack:get_name() == stack:get_name() and itemstack:get_free_space() > 0) then
                --clicker:get_inventory():set_stack("main", clicker:get_wield_index(), stack)
                itemstack:add_item(stack)
                inv:set_stack('input', 1, ItemStack(""))
                meta:set_int('cook_time', 0)
                frontier_craft.remove_item_entity(pos, node)

            elseif minetest.registered_nodes[itemstack:get_name()] ~= nil then
                if pointed_thing.above.y == pos.y then
                    -- allow nodes to be placed against sides of embers
                    minetest.place_node(pointed_thing.above, {name=itemstack:get_name()})
                    itemstack:take_item()
                end
            end
        end

        return itemstack
    end,

    on_dig = function(pos, node, digger)
        fire.dig_embers(pos, node, digger)
    end
})
