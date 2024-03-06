
-- Hand crafts

-- Tools
frontier_craft.register_craft("hand", "frontier_tools:wood_hoe", {inputs = {"group:wood 2", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_pick", {inputs={"group:stone 3", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_hoe", {inputs={"group:stone 2", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_shovel", {inputs={"group:stone 1", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_axe", {inputs={"group:stone 2", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:forge_hammer", {inputs={"default:steel_ingot", "group:stick 2"}})

-- Fire
frontier_craft.register_craft("hand", "default:torch 4", {inputs={"default:coal_lump", "group:stick"}, required_item="frontier_craft:flint_and_steel"})
frontier_craft.register_craft("hand", "default:flint", {inputs={"default:gravel"}})
frontier_craft.register_craft("hand", "frontier_tools:flint_and_steel", {inputs={"default:flint", "default:steel_ingot"}})
frontier_craft.register_craft("hand", "frontier_tools:friction_bow", {inputs={"group:stick 3", "farming:string 3"}})

-- Bows
frontier_craft.register_craft("hand", "bows:poplar_bow", {inputs={"frontier_trees:poplar_wood", "farming:string 3"}})
frontier_craft.register_craft("hand", "bows:arrow", {inputs={"default:flint", "group:stick", "group:feather"}})
frontier_craft.register_craft("hand", "bows:fire_arrow", {inputs={"default:torch", "bows:arrow"}})
frontier_craft.register_craft("hand", "bows:tnt_arrow", {inputs={"tnt:tnt_stick", "bows:arrow"}})

-- TNT
frontier_craft.register_craft("hand", "tnt:gunpowder", {inputs={"default:coal_lump", "default:gravel"}})
frontier_craft.register_craft("hand", "tnt:tnt_stick", {inputs={"default:paper", "farming:string", "tnt:gunpowder 3"}})
frontier_craft.register_craft("hand", "tnt:tnt", {inputs={"tnt:tnt_stick 9"}})

-- Forge
frontier_craft.register_craft("forge", "bows:steel_arrow 9", {inputs={"default:steel_ingot", "group:stick 9", "group:feather 9"}})
frontier_craft.register_craft("forge", "frontier_tools:steel_pick", {inputs={"default:steel_ingot 3", "group:stick 2"}})
frontier_craft.register_craft("forge", "frontier_tools:steel_hoe", {inputs={"default:steel_ingot 2", "group:stick 2"}})
frontier_craft.register_craft("forge", "frontier_tools:steel_shovel", {inputs={"default:steel_ingot 1", "group:stick 2"}})
frontier_craft.register_craft("forge", "frontier_tools:steel_axe", {inputs={"default:steel_ingot 2", "group:stick 2"}})
frontier_craft.register_craft("forge", "frontier_tools:forge_hammer", {inputs={"default:steel_ingot", "group:stick 2"}})
frontier_craft.register_craft("forge", "frontier_tools:steel_scythe", {inputs={"default:steel_ingot 2", "group:stick 2"}})

