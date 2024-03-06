minetest.register_node("frontier_craft:barrel", {
    description = "Barrel",
    tiles = {"frontier_craft_barrel_end.png", "frontier_craft_barrel_side.png", "frontier_craft_barrel_side.png"},
    groups = {choppy=3, oddly_breakable_by_hand=3},
    paramtype2 = "facedir"
})