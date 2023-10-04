
minetest.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 3,
})

frontier_craft.register_craft("hand", "default:pine_wood 4", {inputs={"default:pine_tree"}, required_item="group:axe"})
frontier_craft.register_craft("hand", "frontier_trees:apple_wood 4", {inputs={"frontier_trees:apple_tree"}, required_item="group:axe"})
frontier_craft.register_craft("hand", "frontier_trees:maple_wood 4", {inputs={"frontier_trees:maple_tree"}, required_item="group:axe"})
frontier_craft.register_craft("hand", "frontier_trees:cypress_wood 4", {inputs={"frontier_trees:cypress_tree"}, required_item="group:axe"})
frontier_craft.register_craft("hand", "frontier_trees:mesquite_wood 4", {inputs={"frontier_trees:mesquite_tree"}, required_item="group:axe"})

frontier_craft.register_craft("hand", "default:stick 4", {inputs = {"group:wood"},required_item="group:axe"})
frontier_craft.register_craft("hand", "frontier_trees:holly_wreath", {inputs={"frontier_trees:holly_leaves 4"}})

