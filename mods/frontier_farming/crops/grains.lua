-- Port farming wheat, barley to crops
local S = crops.intllib


local grains = {
    -- Crop steps including dead form
    wheat = 9,
    barley = 8
}


crops.grain_grow = function(pos)
    local node = minetest.get_node(pos)
    local grain_name = ""
    local grain_steps = 0
    -- get number of steps for grain
    for name, steps in pairs(grains) do
        if string.match(node.name, name) then
            grain_name = name
            grain_steps = steps-1 -- last step is dead plant
        end
    end
    if grain_name == "" then
        minetest.log("error", "Grain cannot grow. Missing grain definitions for " .. node.name .. " at " .. minetest.pos_to_string(pos))
        return
    end
    local n = node.name
    for num = 0, grain_steps do
        n = string.gsub(n, grain_steps-1-num, grain_steps-num)
    end
    if n == "crops:" .. grain_name .. "_seed" then
        n = "crops:" .. grain_name .. "_plant_1"
    end
    minetest.swap_node(pos, {name = n, param2 = 1})
end

crops.grain_die = function(pos)
    local n = minetst.get_node(pos).name:gsub()
    local grain_name = ""
    local grain_steps = 0
    -- get number of steps for grain
    for name, steps in pairs(grains) do
        if string.match(node.name, name) then
            grain_name = node.name
            grain_steps = steps-1 -- last step is dead plant
        end
    end
    if grain_name == "" then
        minetest.log("error", "Crop cannot die. Missing grain definitions for " .. node.name .. " at " .. minetest.pos_to_string(pos))
        return
    end
    minetest.set_node(pos, {name = "crops:" .. grain_name .. "_" .. grain_steps})
end

local properties = {
    wheat= {
        die = crops.grain_die,
        grow = crops.grain_grow,
        waterstart = 15,
        wateruse = 1,
        night = 5,
        soak = 80,
        soak_damage = 90,
        wither = 20,
        wither_damage = 10,
        cold = 38,
        cold_damage = 28,
        time_to_grow = 800,
    },
    barley = {
        die = crops.grain_die,
        grow = crops.grain_grow,
        waterstart = 15,
        wateruse = 2,
        night = 5,
        soak = 70,
        soak_damage = 80,
        wither = 20,
        wither_damage = 10,
        cold = 52,
        cold_damage = 42,
        time_to_grow = 900,
    }
}

for grain_name, steps in pairs(grains) do
    -- Register grain seeds
    minetest.register_node("crops:"..grain_name.."_seed", {
        description = S(grain_name:gsub("^%l", string.upper) .. " seed"),
        tiles = {"farming_" .. grain_name .. "_seed.png"},
        inventory_image = "farming_" .. grain_name .. "_seed.png",
        wield_image = "farming_" .. grain_name .. "_seed.png",
        drawtype = "signlike",
        paramtype2 = "wallmounted",
        sunlight_propagates = true,
        use_texture_alpha = true,
        walkable = false,
        paramtype = "light",
        groups = { snappy=3,flammable=3,flora=1,attached_node=1 },
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
            type = "fixed",
            fixed = crops.selection_boxes.seed
        },
        on_place = function(itemstack, placer, pointed_thing)
            local under = minetest.get_node(pointed_thing.under)
            if minetest.get_item_group(under.name, "soil") <= 1 then
                return
            end
            crops.plant(pointed_thing.above, {name="crops:" .. grain_name .. "_seed", param2 = 1})

            if not minetest.settings:get_bool("creative_mode") then
                itemstack:take_item()
            end
            return itemstack
        end
    })

    crops.register({ name="crops:" .. grain_name .. "_seed", properties=properties[grain_name] })
    -- Crop steps
    for step = 1, steps do
        local nodename = "crops:" .. grain_name .. "_plant_"..step

        minetest.register_node(nodename, {
            description = S("" .. grain_name:gsub("^%l", string.upper) .. " plant"),
            tiles= {"farming_" .. grain_name .. "_" .. step .. ".png"},
            drawtype = "plantlike",
            waving = 1,
            sunlight_propagates = true,
            use_texture_alpha = true,
            walkable = false,
            paramtype = "light",
            groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
            drop = {},
            sounds = default.node_sound_leaves_defaults(),
            selection_box = {
                type = "fixed",
                fixed = crops.selection_boxes.base
            }
        })

        if step == steps - 1 then
            minetest.override_item(nodename, {
                on_dig = function(pos, node, digger)
                    local drops = {}
                    local damage = minetest.get_meta(pos):get_int("crops_damage")
                    local n = 1
                    if damage < 10 then
                        n = n + 4
                    elseif damage < 30 then
                        n = n + 3
                    elseif damage < 70 then
                        n = n + 2
                    else
                        n = n + math.random(0,1)
                    end
        
                    for i = 1, n do
                        table.insert(drops, "farming:" .. grain_name)
                    end
                    minetest.remove_node(pos)
                    core.handle_node_drops(pos, drops, digger)
                end
            })
        end
        -- Don't register dead form as crop
        if step ~= steps then
            crops.register({name = nodename, properties=properties[grain_name]})
        end
    end
end

