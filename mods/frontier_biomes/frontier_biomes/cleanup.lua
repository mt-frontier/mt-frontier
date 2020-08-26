-- Clean up snow from bug caused by removing tundra biomes
minetest.register_abm({
	label = "Remove out of place snow",
	name = "biome_tester:snow_cleanup",
	nodenames = {"default:snow"},
	neighbors = {"group:stone"},
	interval = 4.1,
	chance = 1,
	action = function(pos, node)
		local temp = minetest.get_biome_data(pos).heat
		if temp < 36 then
			return
		end
		minetest.set_node(pos, {name = "default:water_flowing"})
	end
})
