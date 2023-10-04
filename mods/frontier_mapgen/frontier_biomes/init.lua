biomes = {}
local mp = minetest.get_modpath("frontier_biomes")

minetest.clear_registered_biomes()
--minetest.clear_registered_ores()
minetest.clear_registered_decorations()

dofile(mp .. "/nodes.lua")
dofile(mp .. "/functions.lua")
dofile(mp .. "/biomes.lua")
dofile(mp .. "/ores.lua")
dofile(mp .. "/grasses.lua")
dofile(mp .. "/decorations.lua")

--dofile(mp .. "/swamp.lua")
--dofile(mp .. "/pine_savanna.lua")

--dofile(mp .. "/deciduous.lua")
