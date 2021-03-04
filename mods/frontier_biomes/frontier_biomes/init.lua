local mp = minetest.get_modpath("frontier_biomes")

biomes = {}
biomes.on_generated_functions = {}

dofile(mp .. "/swamp.lua")
dofile(mp .. "/pine_savanna.lua")
dofile(mp .. "/grasslands.lua")


minetest.register_on_generated(function(minp, maxp, seed)
    for name, func in pairs(biomes.on_generated_functions) do
        func(minp, maxp, seed)
    end
end)

minetest.register_alias("default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass")
minetest.register_alias("default:dry_dirt", "default:dirt")

