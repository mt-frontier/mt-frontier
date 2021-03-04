for n = 1, 5 do
    minetest.override_item("default:grass_" .. n, {
        visual_scale = 1.4
    })
end

minetest.register_node("frontier_biomes:dirt_with_patchy_grass", {
	description = "Dirt with Deciduous Litter",
	tiles = {"frontier_biomes_patchy_grass.png", "default_dirt.png",
		{name = "default_dirt.png^frontier_biomes_patchy_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

biomes.on_generated_functions["add_patchy_grass"] = function(minp, maxp, seed)
    if maxp.y < -15 then
        return
    end

    local positions = minetest.find_nodes_in_area(minp, maxp, {"default:dirt_with_grass"})
    math.randomseed(seed)
    for _, pos in ipairs(positions) do
        local biome_name = minetest.get_biome_name(minetest.get_biome_data(pos).biome)
        local chances = 5
        local grass_positions = minetest.find_nodes_in_area(
            pos,
            vector.add(pos, {x = 0, y = 5, z = 0}),
            {"group:leaves", "group:tree"}
        )
        if #grass_positions > 0 then
            chances = 2
        end
        if math.random(chances) <= 1 then
            minetest.set_node(pos, {name = "frontier_biomes:dirt_with_patchy_grass"})
        end
    end
end
