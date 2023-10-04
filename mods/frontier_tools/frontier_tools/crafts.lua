
-- Craft Groups
frontier_craft.register_craft_group("axe", "tool", "default_tool_steelaxe.png", {"frontier_tools:steel_axe", "frontier_tools:stone_axe"})

-- Hand crafts

-- Tools
frontier_craft.register_craft("hand", "frontier_tools:wood_hoe", {inputs = {"group:wood 2", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_pick", {inputs={"group:stone 3", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_hoe", {inputs={"group:stone 2", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_shovel", {inputs={"group:stone 1", "group:stick 2"}})
frontier_craft.register_craft("hand", "frontier_tools:stone_axe", {inputs={"group:stone 2", "group:stick 2"}})

-- Misc Items
frontier_craft.register_craft("hand", "default:torch 4", {inputs={"default:coal_lump", "group:stick"}, required_item="fire:flint_and_steel"})
--frontier_craft.register_craft("hand", "bows:arrow", {inputs={"default:flint", "group:stick", "group:feather"}})
frontier_craft.register_craft("hand", "fire:flint_and_steel", {inputs={"default:flint", "default:steel_ingot"}})

