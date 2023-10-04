
-- Register light and dark gradients of biome nodes
biomes.register_node_gradients = function(base_name, base_mod, current_mod, light_color, dark_color, shared_group)
    assert(minetest.get_modpath(base_mod), "[biomes] Error: Missing base mod")
    local base_def = minetest.registered_nodes(base_mod .. ":" .. base_name)
    assert(base_def ~= nil, "[biomes] Error: base node not found")
    -- Define light and dark gradients of base node
    local light_def = {}
    local dark_def = {}
    for key, val in pairs(base_def) do
        if key == "groups" then
            if not val[shared_group] then
                key[shared_group] = 1
            end
        end
    end

    minetest.register_node(current_mod .. ":" .. base_name .. "_light", {
        description = base_def.description,
        tiles = {"default_grass.png^[colorize:#6cb928:035", "default_dirt.png",
            {name = "default_dirt.png^default_grass_side.png^[colorize:#6cb928:020",
                tileable_vertical = false}},
        groups = {crumbly = 3, soil = 1},
        drop = 'default:dirt',
        sounds = default.node_sound_dirt_defaults({
            footstep = {name = "default_grass_footstep", gain = 0.25},
        }),
    })
    
    minetest.register_node("frontier_biomes:dirt_with_grass_dark", {
        description = "Dirt with Grass",
        tiles = {"default_grass.png^[colorize:#2f2400:035", "default_dirt.png",
            {name = "default_dirt.png^default_grass_side.png^[colorize:#2f2400:020",
                tileable_vertical = false}},
        groups = {crumbly = 3, soil = 1},
        drop = 'default:dirt',
        sounds = default.node_sound_dirt_defaults({
            footstep = {name = "default_grass_footstep", gain = 0.25},
        }),
    })
    
    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 4,
        fill_ratio = 0.3,
        biomes = {"grasslands"},
        y_max = 31000,
        y_min = 2,
        decoration = "frontier_biomes:dirt_with_grass_light",
        place_offset_y = -1,
        flags = "force_placement",
    })
    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 4,
        fill_ratio = 0.25,
        biomes = {"grasslands"},
        y_max = 31000,
        y_min = 1,
        decoration = "frontier_biomes:dirt_with_grass_dark",
        place_offset_y = -1,
        flags = "force_placement",
    })
 
end