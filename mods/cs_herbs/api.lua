cs_herbs.register_flora = function(name, Desc, param2, color, color_name)
    
    minetest.register_node("cs_herbs:"..name, {
        description = Desc,
        drawtype = "plantlike",
        tiles = {"cs_herbs_"..name..".png"},
        inventory_image = "cs_herbs_"..name..".png",
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
                { items = {'cs_herbs:'..name}},
                { items = {'cs_herbs:'..name..'_seeds'}, rarity = 8},
            }
        },
		sounds = default.node_sound_leaves_defaults(),
    })
    
    minetest.register_node("cs_herbs:"..name.."_2", {
        description = "Mature".. Desc,
        drawtype = "plantlike",
        tiles = {"cs_herbs_"..name.."_2.png"},
        paramtype = "light",
		paramtype2 = "meshoptions",
        walkable = false,
        buildable_to = true,
        groups = {snappy = 3, flora=1, plant=1, flammable=2, not_in_creative_inventory=1},
        selection_box = {
            type = "fixed",
            fixed = {-1/2, -1/2, -1/2, 1/2, -1/4, 1/2},
        },
        drop = {
            max_items = 4,
            items = {
                { items = {'cs_herbs:'..name}},
                { items = {'cs_herbs:'..name}, rarity = 2},
                { items = {'cs_herbs:'..name..'_seeds'}, rarity = 2},
                { items = {'cs_herbs:'..name..'_seeds'}}
            }
        },
		sounds = default.node_sound_leaves_defaults(),
        
    })
    
    minetest.register_node("cs_herbs:"..name.."_seeds", {
        description = Desc.." Seeds",
		tiles = {"cs_herbs_"..name.."_seeds.png"},
		inventory_image = "cs_herbs_"..name.."_seeds.png",
		wield_image = "cs_herbs_"..name.."_seeds.png",
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
			return farming.place_seed(itemstack, placer, pointed_thing, "cs_herbs:"..name.."_seeds")
		end,
    })
    
    minetest.register_node("cs_herbs:"..name.."_sprout", {
        description = Desc .. " Sprout",
        tiles = {"cs_herbs_"..name.."_sprout.png"},
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
        nodenames = {"cs_herbs:"..name.."_seeds",  "cs_herbs:"..name.."_sprout", "cs_herbs:"..name},
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
            if minetest.get_node(pos).name== "cs_herbs:"..name.."_seeds" then
                minetest.set_node(pos, {name = "cs_herbs:"..name.."_sprout"})
            elseif minetest.get_node(pos).name == "cs_herbs:"..name.."_sprout" then
                minetest.set_node(pos, {name = "cs_herbs:"..name})
            else
                minetest.set_node(pos, {name = "cs_herbs:"..name.."_2", param2 = param2})
            end
        end
    })
    
    minetest.register_craftitem("cs_herbs:crushed_"..name, {
		description = "Crushed "..Desc,
		inventory_image = "herb.png^[colorize:"..color..":180^herb_leaf.png",
	})

    minetest.register_craft({
        output = "cs_herbs:"..name.."_seeds",
        recipe = {
            {"cs_herbs:"..name},
        },
    })

    cs_herbs.mortar.register_recipe ("cs_herbs:"..name, "cs_herbs:crushed_"..name, 1, 1)
	cs_herbs.mortar.register_recipe ("cs_herbs:crushed_"..name, "dye:"..color_name, 1, 4)
end 


cs_herbs.register_fungi = function(name, Desc) 

end

cs_herbs.register_gen = function(name, grow_media, biomes, y_min, y_max, offset, seed)
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
		decoration = "cs_herbs:"..name,
	})
    
    minetest.register_abm({
        label = "cs_herbs:"..name.."_spread",
        nodenames = {"cs_herbs:"..name, "cs_herbs:"..name.."_2"},
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
                    return minetest.set_node(new_pos, {name = "cs_herbs:"..name.."_sprout"})
                else
                    minetest.log(nn)
                end
            end
        end
    })
    
    minetest.register_abm({ 
        label = "cs_herbs:grow_"..name.."_sprout",
        nodenames = {"cs_herbs:"..name.."_sprout"},
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
                    minetest.set_node(pos, {name="cs_herbs:"..name})
                end
            end
        end,
    })
end
