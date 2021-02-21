local mp = minetest.get_modpath("frontier_biomes")

dofile(mp .. "/swamp.lua")
dofile(mp .. "/pine_savanna.lua")
--dofile(mp .. "/deciduous_highland.lua")

minetest.register_alias("default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass")
minetest.register_alias("default:dry_dirt", "default:dirt")

