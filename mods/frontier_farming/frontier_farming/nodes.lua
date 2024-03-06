local bread_block_def = {
    description = "Bread Loaves",
    tiles = {
        "frontier_farming_bread_block_top.png",
        "frontier_farming_bread_block_bottom.png",
        "frontier_farming_bread_block_front.png",
        "frontier_farming_bread_block_front.png",
        "frontier_farming_bread_block_side.png",
        "frontier_farming_bread_block_side.png"

    },
    paramtype = "light",
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {oddly_breakable_by_hand=3, dig_immediate=3},
    sounds = default.node_sound_defaults(),
    drop = "frontier_farming:bread",
    after_dig_node = function(pos, oldnode)
        local param2 = oldnode.param2
        if oldnode.name == "frontier_farming:bread_block" then
            minetest.set_node(pos, {name="stairs:stair_bread_block", param2=param2})
        elseif oldnode.name == "stairs:stair_bread_block" then
            minetest.set_node(pos, {name="stairs:slab_bread_block", param2=param2})
        elseif oldnode.name == "stairs:slab_bread_block" then
            minetest.set_node(pos, {name="frontier_farming:bread", param2=param2})
        end
    end,
}

minetest.register_node("frontier_farming:bread_block", bread_block_def)

minetest.register_node("frontier_farming:bread", {
    description = "Loaf of Bread",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.25, 0.5, 0, 0.25}
        }
    },
    paramtype = "light",
    paramtype2 = bread_block_def.paramtype2,
    inventory_image = "frontier_farming_bread_loaf_inv.png",
    tiles = {
        "frontier_farming_bread_loaf_top.png",
        "frontier_farming_bread_loaf_bottom.png",
        "frontier_farming_bread_loaf_front.png",
        "frontier_farming_bread_loaf_front.png",
        "frontier_farming_bread_block_side.png",
        "frontier_farming_bread_block_side.png"
    },
    on_use = minetest.item_eat(6),
    is_ground_content = false,
    groups = bread_block_def.groups,
    sounds = bread_block_def.sounds,
    on_place = function(itemstack, placer, pointed_thing)
        local pointed_node = minetest.get_node(pointed_thing.under)
        if pointed_node.name == "frontier_farming:bread" then
            minetest.set_node(pointed_thing.under, {name="stairs:slab_bread_block", param2=pointed_node.param2})
        elseif pointed_node.name == "stairs:slab_bread_block" then
            minetest.set_node(pointed_thing.under, {name="stairs:stair_bread_block", param2=pointed_node.param2})
        elseif pointed_node.name == "stairs:stair_bread_block" then
            minetest.set_node(pointed_thing.under, {name="frontier_farming:bread_block", param2=pointed_node.param2})
        else
            minetest.item_place(itemstack, placer, pointed_thing)
        end
        if not minetest.check_player_privs(placer:get_player_name(), {creative=true}) then
            placer:get_inventory():remove_item("main", ItemStack(itemstack:get_name()))
        end
    end
})

stairs.register_stair(
    "bread_block",
    "frontier_farming:bread_block",
    bread_block_def.groups,
    bread_block_def.tiles,
    bread_block_def.description,
    bread_block_def.sounds,
    false
)

stairs.register_slab(
    "bread_block",
    "frontier_farming:bread_block",
    bread_block_def.groups,
    bread_block_def.tiles,
    bread_block_def.description,
    bread_block_def.sounds,
    false
)

minetest.override_item("stairs:stair_bread_block", {
    after_dig_node = bread_block_def.after_dig_node,
    drop = bread_block_def.drop
})

minetest.override_item("stairs:slab_bread_block", {
    after_dig_node = bread_block_def.after_dig_node,
    drop = bread_block_def.drop
})