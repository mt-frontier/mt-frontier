frontier_plants.register_flora = function(name, Desc, param2, color, color_name)
    
    minetest.register_node("frontier_plants:"..name, {
        description = Desc,
        drawtype = "plantlike",
        tiles = {"frontier_plants_"..name..".png"},
        inventory_image = "frontier_plants_"..name..".png",
        paramtype = "light",
        walkable = false,
        buildable_to = true,
        groups = {snappy = 3, flower=1, flora=1, plant=1, flammable=2},
        selection_box = {
            type = "fixed",
            fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
        },
         drop = {
            max_items = 2,
            items = {
                { items = {'frontier_plants:'..name}},
                { items = {'frontier_plants:'..name..'_seeds'}, rarity = 8},
            }
        },
		sounds = default.node_sound_leaves_defaults(),
    })
    
    minetest.register_node("frontier_plants:"..name.."_2", {
        description = "Mature".. Desc,
        drawtype = "plantlike",
        tiles = {"frontier_plants_"..name.."_2.png"},
        paramtype = "light",
		paramtype2 = "meshoptions",
        walkable = false,
        buildable_to = true,
        groups = {snappy = 3, flower=1, flora=1, plant=1, flammable=2, not_in_creative_inventory=1},
        selection_box = {
            type = "fixed",
            fixed = {-1/2, -1/2, -1/2, 1/2, -1/4, 1/2},
        },
        drop = {
            max_items = 4,
            items = {
                { items = {'frontier_plants:'..name}},
                { items = {'frontier_plants:'..name}, rarity = 2},
                { items = {'frontier_plants:'..name..'_seeds'}, rarity = 2},
                { items = {'frontier_plants:'..name..'_seeds'}}
            }
        },
		sounds = default.node_sound_leaves_defaults(),
        
    })
    
    minetest.register_node("frontier_plants:"..name.."_seeds", {
        description = Desc.." Seeds",
		tiles = {"frontier_plants_"..name.."_seeds.png"},
		inventory_image = "frontier_plants_"..name.."_seeds.png",
		wield_image = "frontier_plants_"..name.."_seeds.png",
		drawtype = "signlike",
		groups = {snappy=3, flammable=2},
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		sunlight_propagates = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			return farming.place_seed(itemstack, placer, pointed_thing, "frontier_plants:"..name.."_seeds")
		end,
    })
    
    minetest.register_node("frontier_plants:"..name.."_sprout", {
        description = Desc .. " Sprout",
        tiles = {"frontier_plants_"..name.."_sprout.png"},
        drawtype = "plantlike",
        groups = {snappy=3, flammable=2, not_in_creative_inventory=1},
        paramtype = "light",
        walkable = false,
        sunlight_propogates = true,
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
        on_dig = function(pos) 
			minetest.remove_node(pos)
		end
    })
    --fishyWet's abm with different growth process
    minetest.register_abm({
        nodenames = {"frontier_plants:"..name.."_seeds",  "frontier_plants:"..name.."_sprout", "frontier_plants:"..name},
        neighbors = {"group:soil"},
        interval = 66,
        chance = 3,
        action = function(pos, node)
            -- check if on wet soil
            pos.y = pos.y - 1
            local node = minetest.get_node(pos)
            if minetest.get_item_group(node.name, "soil") < 3 then
                return
            end
            pos.y = pos.y + 1

            -- check light
            local light = minetest.get_node_light(pos)
            if not light then
                return
            end
            if light < 11 then
                return
            end

            -- grow
            if minetest.get_node(pos).name== "frontier_plants:"..name.."_seeds" then
                minetest.set_node(pos, {name = "frontier_plants:"..name.."_sprout"})
            elseif minetest.get_node(pos).name == "frontier_plants:"..name.."_sprout" then
                minetest.set_node(pos, {name = "frontier_plants:"..name})
            else
                minetest.set_node(pos, {name = "frontier_plants:"..name.."_2", param2 = param2})
            end
        end
    })
    
    minetest.register_craftitem("frontier_plants:crushed_"..name, {
		description = "Crushed "..Desc,
		inventory_image = "herb.png^[colorize:"..color..":180^herb_leaf.png",
	})

    minetest.register_craft({
        output = "frontier_plants:"..name.."_seeds",
        recipe = {
            {"frontier_plants:"..name},
        },
    })

    frontier_plants.mortar.register_recipe ("frontier_plants:"..name, "frontier_plants:crushed_"..name, 1, 1)
	frontier_plants.mortar.register_recipe ("frontier_plants:crushed_"..name, "dye:"..color_name, 1, 4)
end 


frontier_plants.register_fungi = function(name, Desc) 

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
			spread = {x = 200, y = 200, z = 200},
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
            if #minetest.find_nodes_in_area(pos1, pos2, "group:flora") > 3 then
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
