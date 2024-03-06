frontier_plants.register_flower = function(name, desc, param2, cultivated_drop, edibility)
    if not edibility or type(edibility) ~= "number" then
        edibility = 0.1 -- <=0 triggers poisoning effect, <1 no effect
    end

    local flower_def = {
        description = desc,
        drawtype = "plantlike",
        tiles = {"frontier_plants_"..name..".png"},
        inventory_image = "frontier_plants_"..name..".png",
        paramtype = "light",
        sunlight_propogates = true,
        walkable = false,
        buildable_to = true,
        groups = {attached_node=1, snappy = 3, flower=1, plant=1, flammable=2},
        selection_box = {
            type = "fixed",
            fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
        },
        sounds = default.node_sound_leaves_defaults(),
        on_use = minetest.item_eat(edibility)
    }

    minetest.register_node("frontier_plants:" .. name, flower_def)

    -- Sprout stage
    flower_def.description = desc .. " Sprout"
    flower_def.tiles = {"frontier_plants_"..name.."_sprout.png"}
    flower_def.groups = {attached_node=1, snappy=3, flammable=2, not_in_creative_inventory=1}
    flower_def.drop = "",

    minetest.register_node("frontier_plants:" .. name .. "_sprout", flower_def)

    -- Cultivated version of flower is meant for farming and appears more dense
    flower_def.description = "Cultivated ".. desc
    flower_def.tiles = {"frontier_plants_" .. name .. "_2.png"}
    flower_def.paramtype2 = "meshoptions"
    flower_def.groups = {attached_node=1, snappy = 3, flower=1, plant=1, flammable=2, not_in_creative_inventory=1}
    flower_def.drop = cultivated_drop

    minetest.register_node("frontier_plants:"..name.."_2", flower_def)
    
end

frontier_plants.register_gen = function(name, grow_media, biomes, y_min, y_max, offset, seed)
    local offset = offset or -0.015
    local y_min = y_min or 1
    local y_max = y_max or 31000
    local seed = seed or math.random(11, 9999)
    
    minetest.register_decoration({
		deco_type = "simple",
		place_on = grow_media,
		sidelen = 16,
		noise_params = {
			offset = offset,
			scale = 0.025,
			spread = {x = 12, y = 12, z = 12},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		biomes = biomes,
		y_min = y_min,
		y_max = y_max,
		decoration = "frontier_plants:"..name,
	})
    
    minetest.register_abm({
        label = "frontier_plants:"..name.."_spread",
        nodenames = {"frontier_plants:"..name, "frontier_plants:"..name.."_2"},
        neighbors = grow_media,
        interval = 23,
        chance = 240,
        action = function(pos)
            if minetest.get_node_light(pos) < 12 then
                return --minetest.log("too dark")
            end
            local pos1 = vector.subtract(pos, 3)
            local pos2 = vector.add(pos, 3)
            if #minetest.find_nodes_in_area(pos1, pos2, "group:flower") > 3 then
                return --minetest.log("too many flowers")
            end
            
            for _, nn in ipairs(grow_media) do
                local surface = minetest.find_nodes_in_area_under_air(pos1, pos2, nn)
                if #surface > 0 then
                    local new_pos = surface[math.random(1, #surface)]
                    new_pos.y = new_pos.y+1
                    --minetest.log("placing "..name.." at "..minetest.serialize(new_pos))
                    return minetest.set_node(new_pos, {name = "frontier_plants:"..name.."_sprout"})
                else
                    minetest.log(nn)
                end
            end
        end
    })
    
    minetest.register_abm({ 
        label = "frontier_plants:grow_"..name.."_sprout",
        nodenames = {"frontier_plants:"..name.."_sprout"},
        interval = 71,
        chance = 4,
        action = function(pos)
            if minetest.get_node_light(pos) < 13 then
                return
            end
            pos.y = pos.y - 1
            local node_below = minetest.get_node(pos)
            pos.y = pos.y + 1 
            for _, nn in ipairs(grow_media) do
                if node_below.name == nn then
                    minetest.set_node(pos, {name="frontier_plants:"..name})
                end
            end
        end,
    })
end



frontier_plants.register_flower ("rose", "Rose", 0, {"frontier_plants:rose 4"}, 0.1)
frontier_plants.register_gen ("rose", {"default:dirt_with_grass"}, {"grassland"})

frontier_plants.register_flower ("dandelion", "Dandelion", 0, {"frontier_plants:dandelion 4"}, 1)
frontier_plants.register_gen ("dandelion", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, {"grassland", "deciduous_forest", "pine_savanna"})

frontier_plants.register_flower ("echinacea", "Echinacea", 3, "#ff77e1", "magenta")
frontier_plants.register_gen ("echinacea", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, {"grassland", "deciduous_forest", "coniferous_forest"})

frontier_plants.register_flower ("viola", "Viola", 0, "#9933ff", "violet")
frontier_plants.register_gen ("viola", {"default:dirt_with_grass", "default:dirt_with_rainforest_litter", "default:dirt_with_coniferous_litter"}, {"deciduous_forest", "rainforest", "coniferous_forest"})

frontier_plants.register_flower ("white_sage", "White Sage", 3, "#cccccc", "grey")
frontier_plants.register_gen ("white_sage", {"default:sand", "default:desert_sand", "default:silver_sand"}, {"desert", "cold_desert"})

frontier_plants.register_flower ("indigo", "Indigo", 0, "#3041cc", "blue")
frontier_plants.register_gen ("indigo", {"default:dirt_with_grass"}, {"grassland"})

frontier_plants.register_flower ("lily", "Lily", 3, "#ff7766", "pink")
frontier_plants.register_gen ("lily", {"default:dirt_with_rainforest_litter"}, {"swamp", "swamp_forest"})

minetest.override_item("frontier_plants:indigo", {
	visual_scale = 1.25,
})

minetest.override_item("frontier_plants:indigo_2", {
	visual_scale = 1.25
})

minetest.override_item("frontier_plants:lily", {
	visual_scale = 1.5,
})

minetest.override_item("frontier_plants:lily_2",{
	visual_scale=1.5
})