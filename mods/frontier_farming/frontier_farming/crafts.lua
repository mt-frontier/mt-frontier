-- Craft groups
--frontier_craft.register_craft_group("food_bowl", "item", "crops_clay_bowl.png", {"crops:clay_bowl"})

-- Seeds
frontier_craft.register_craft("hand", "crops:wheat_seed 3", {inputs={"farming:wheat"}})
frontier_craft.register_craft("hand", "crops:barley_seed 3", {inputs={"farming:barley"}})
frontier_craft.register_craft("hand", "crops:cotton_seed 2", {inputs={"farming:cotton"}, replacements={"farming:string"}})

frontier_craft.register_craft("hand", "crops:tomato_seed 2", {inputs={"crops:tomato"}})
frontier_craft.register_craft("hand", "crops:potato_eyes 4", {inputs={"crops:potato"}})
frontier_craft.register_craft("hand", "crops:green_bean_seed 3", {inputs={"crops:green_bean"}})
frontier_craft.register_craft("hand", "crops:corn 8", {inputs = {"crops:corn_cob"}})
frontier_craft.register_craft("hand", "crops:pumpkin_seed 8", {inputs = {"crops:pumpkin"}})
frontier_craft.register_craft("hand", "crops:sunflower_seed 8", {inputs= {"crops:sunflower"}})

-- Crops
frontier_craft.register_craft("hand", "crops:beanpoles", {inputs={"group:stick 4"}})
frontier_craft.register_craft("hand", "crops:unbaked_clay_bowl", {inputs={"default:clay_lump 2"}})
frontier_craft.register_craft("hand", "crops:unbaked_watering_jug", {inputs={"default:clay_lump 4"}})

-- Cooking

frontier_craft.register_craft("pot", "crops:corn_on_the_cob", {inputs={"crops:corn_cob"}})
frontier_craft.register_craft("pot", "crops:vegetable_stew", {inputs={"crops:green_bean", "crops:potato", "crops:tomato"}})

-- Farming products
frontier_craft.register_craft("hand", "farming:straw", {inputs={"farming:wheat 4"}})
frontier_craft.register_craft("hand", "farming:string 2", {inputs={"farming:cotton"}, replacements = {"crops:cotton_seed"}})
frontier_craft.register_craft("hand", "wool:white", {inputs={"farming:string 8"}})
frontier_craft.register_craft("hand", "farming:string 8", {inputs={"group:wool"}})
frontier_craft.register_craft("hand", "frontier_farming:bread_block", {inputs={"frontier_farming:bread 4"}})
