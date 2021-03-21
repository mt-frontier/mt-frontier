
minetest.register_node("craft:anvil", {
	description = "Anvil for crafting and repairing tools",
	drawtype = "nodebox",
	tiles = {"default_coal_block.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
        	type = "fixed",
        	fixed = {
                        {-0.5,-0.5,-0.3,0.5,-0.4,0.3},
                        {-0.35,-0.4,-0.25,0.35,-0.3,0.25},
                        {-0.3,-0.3,-0.15,0.3,-0.1,0.15},
                        {-0.35,-0.1,-0.2,0.35,0.1,0.2},
                },
        },
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.5,-0.5,-0.3,0.5,-0.4,0.3},
                        {-0.35,-0.4,-0.25,0.35,-0.3,0.25},
                        {-0.3,-0.3,-0.15,0.3,-0.1,0.15},
                        {-0.35,-0.1,-0.2,0.35,0.1,0.2},
                }
        },
	groups = {cracky = 2},
	on_rightclick = function(pos, node, clicker)
		minetest.show_formspec(clicker:get_player_name(), "anvil", craft.build_formspec(clicker, "anvil"))
	end,
})
