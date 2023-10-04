minetest.register_node("frontier_trees:dead_pine_wood", {
	description = "Dead Pine Wood",
	tiles = {
		"frontier_trees_dead_pine_wood_top.png", "frontier_trees_dead_pine_wood_top.png", 
		"frontier_trees_dead_pine_wood_side.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
})

-- Stems drop sticks

local stems = {
	"default:bush_stem",
	"default:pine_bush_stem",
--"frontier_trees:holly_stem"
}

for _, stem in ipairs(stems) do
	minetest.override_item(stem, {
		drop = {
			max_items = 1,
			items = {
				{rarity = 4, items = {"default:stick 4"}},
				{rarity = 1, items = {"default:stick 3"}},
			}
		}
	})
end