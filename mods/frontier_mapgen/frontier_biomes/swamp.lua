--Swamp Biome
local swamp_color =  "^[colorize:#88AA00:150"

minetest.register_node("frontier_biomes:swamp_water_source", {
	description = "Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png"..swamp_color,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_water_source_animated.png"..swamp_color,
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	alpha = 200,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 2,
	liquidtype = "source",
	liquid_alternative_flowing = "frontier_biomes:swamp_water_flowing",
	liquid_alternative_source = "frontier_biomes:swamp_water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 180, r = 30, g = 90, b = 60},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("frontier_biomes:swamp_water_flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png"..swamp_color,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png"..swamp_color,
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 200,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "frontier_biomes:swamp_water_flowing",
	liquid_alternative_source = "frontier_biomes:swamp_water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 180, r = 30, g = 90, b = 60},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

-- Swamp Biome

minetest.register_biome({
	name = "swamp_forest",
	node_top = "default:dirt_with_rainforest_litter",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_water = "frontier_biomes:swamp_water_source",
	y_max = 3,
	y_min = 1,
	heat_point = 86,
	humidity_point = 65,
})

minetest.register_biome({
	name = "swamp",
	node_top = "default:dirt",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_water_top = "frontier_biomes:swamp_water_source",
	y_max = 1,
	y_min = -1,
	heat_point = 86,
	humidity_point = 65,
})

minetest.register_biome({
	name = "swamp_ocean",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	vertical_blend = 1,
--	node_water = "frontier_biomes:swamp_water_source",
	y_max = -1,
	y_min = -112,
	heat_point = 86,
	humidity_point = 65,
})
--Keep swamp water near banks and more shallow water.
local c_swamp_water = minetest.get_content_id("frontier_biomes:swamp_water_source")
local c_water = minetest.get_content_id("default:water_source")

minetest.register_on_generated(function(minp, maxp)
	if minp.y > 1 or maxp.y < 1 then return end
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	for i in area:iter(minp.x, 1, minp.z, maxp.x, 1, maxp.z) do
		if data[i] == c_swamp_water then
			local pos = area:position(i)
			pos.y = pos.y - 4
			local j = area:indexp(pos)
			if data[j] == c_water then
				data[i] = c_water
			end
		end
	end	
	vm:set_data(data)
	vm:set_lighting{day = 0, night = 0}
	vm:calc_lighting()
	vm:write_to_map()
end)

for length = 1, 5 do
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_rainforest_litter"},
		fill_ratio = 0.03,
		sidelen = 16,
		y_max = 30,
		y_min = 1,
		sidelen = 16,
		decoration = "default:grass_"..length,
	})
end
