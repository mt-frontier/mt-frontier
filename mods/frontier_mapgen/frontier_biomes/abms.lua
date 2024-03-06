-- local freezing_temp = 32
-- local thawing_temp = temperature.get_cold_temp() + 1


-- minetest.register_abm({
--     label = "seasons:thawing_snow",
--     nodenames = {"default:snow", "default:snow_block"},
--     neighbors = {"air", "group:water"},
--     interval = 27,
--     chance = 16,
--     max_y = 800,
--     catch_up = true,
--     action = function(pos, node, active_object_count)
--         if minetest.is_protected(pos) then
--             return
--         end

--         local temp = temperature.get_adjusted_temp(pos)
--         if temp < thawing_temp then
--             return
--         end

--         local light_level = minetest.get_node_light(pos, 0.5)
--         if light_level < 3/4*default.LIGHT_MAX then
--             print(light_level)
--             return
--         end
--         pos.y = pos.y-1
--         minetest.set_node(pos, {name="air"})
--     end
-- })

-- minetest.register_abm({
--     label = "seasons:thawing_dirt",
--     nodenames = {"default:dirt_with_snow"},
--     neighbors = {"air"},
--     interval = 29,
--     chance = 16,
--     max_y = 496,
--     catch_up = true,
--     action = function(pos)
--         if minetest.is_protected(pos) then
--             return
--         end
--         local above = {x=pos.x, y = pos.y + 1, z=pos.z}
--         local light_level = minetest.get_node_light(above)
--         local temp = temperature.get_adjusted_temp(pos)
--         if temp < thawing_temp then
--             return
--         end

--         if light_level < 3/4*default.LIGHT_MAX then
--             return
--         end
--         minetest.set_node(pos, {name="default:dirt"})
--     end

-- })


-- minetest.register_abm({
--     label = "seasons:grass_spread_on_dirt_and_snow_melt",
--     nodenames = {"default:dirt"},
--     neighbors = {"air", "default:dirt_with_grass"},
--     interval = 11,
--     chance = 48 ,
--     catch_up = false,
--     action = function(pos)
--         local above = {x=pos.x, y= pos.y+1, z=pos.z}
--         local ll = minetest.get_node_light(above)
--         if ll == nil then -- ignore nodes without light value 
--             return
--         end
--         -- disable at night and dark places
--         if ll < 13 then
--             return
--         end
--         -- Check temp
--         if temperature.get_adjusted_temp(pos) > thawing_temp then
--             -- Convert dirt or dirt with snow with dirt_with_grass when it is significantly warmer than freezing
--             minetest.set_node(pos, {name = "default:dirt_with_grass"})
--         end
--     end
-- })



-- -- minetest.register_abm({
-- -- 	label = "Grass spread",
-- -- 	nodenames = {"default:dirt"},
-- -- 	neighbors = {
-- -- 		"air",
-- -- 		"group:grass",
-- -- 		"group:dry_grass",
-- -- 		"default:snow",
-- -- 	},
-- -- 	interval = 7,
-- -- 	chance = 48,
-- -- 	catch_up = false,
-- -- 	action = function(pos, node)
-- -- 		-- Check for darkness: night, shadow or under a light-blocking node
-- -- 		-- Returns if ignore above
-- -- 		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
-- -- 		if (minetest.get_node_light(above) or 0) < 13 then
-- -- 			return
-- -- 		end

-- -- 		-- Look for spreading dirt-type neighbours
-- -- 		local p2 = minetest.find_node_near(pos, 1, "group:spreading_dirt_type")
-- -- 		if p2 then
-- -- 			local n3 = minetest.get_node(p2)
-- --             if minetest.get_item_group(n3.name, "snowy") > 0 then
-- --                 if temperature.get_adjusted_temp(p2) > freezing_temp then -- too warm for snow to spread check for coniferous forest
-- --                     if minetest.find_node_near(p2, 1, {"default:pine_needles", "default:pine_bush_needles", "default:dirt_with_coniferous_litter"}) then
-- --                         minetest.set_node(pos, {name = "default:dirt_with_coniferous_litter"})
-- --                         return
-- --                     end
-- --                 end
-- --             end
-- -- 			minetest.set_node(pos, {name = n3.name})
-- -- 			return
-- -- 		end

-- -- 		-- any seeding nodes on top?
-- -- 		local name = minetest.get_node(above).name
-- -- 		-- Snow check is cheapest, so comes first
-- -- 		if name == "default:snow" then
-- -- 			minetest.set_node(pos, {name = "default:dirt_with_snow"})
-- -- 		-- Most likely case first
-- -- 		elseif minetest.get_item_group(name, "grass") ~= 0 then
-- -- 			minetest.set_node(pos, {name = "default:dirt_with_grass"})
-- -- 		elseif minetest.get_item_group(name, "dry_grass") ~= 0 then
-- -- 			minetest.set_node(pos, {name = "default:dirt_with_dry_grass"})
-- --         end
-- -- 	end
-- -- })
