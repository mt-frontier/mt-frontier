minetest.register_craftitem("affliction:bandage", {
    description = "Bandage",
    inventory_image = "affliction_bandage.png",
    groups = {medicine=1, flammable=1},
    on_use = minetest.item_eat(5),
})

minetest.register_craftitem("affliction:wound_powder", {
    description = "Wound Powder",
    inventory_image = "affliction_wound_powder.png",
    groups = {medicine=1},
    on_use = minetest.item_eat(8),
})

adv_craft.register_mill_recipe("frontier_plants:ganoderma", "affliction:wound_powder")

affliction.register_affliction("affliction:gash", {bleeding=50})
affliction.register_affliction("affliction:cut", {bleeding=30})
affliction.register_treatment("affliction:bandage", {bleeding=300})
affliction.register_treatment("affliction:wound_powder", {bleeding=500})
affliction.register_treatment("affliction:heal_time", {bleeding=affliction.tick})


minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    if minetest.is_player(hitter) and tool_capabilities ~= nil then
        affliction.afflict(player, "affliction:gash")
    end
    if not minetest.is_player(hitter) then
        affliction.afflict(player, "affliction:cut")
    end
end)

affliction.register_on_affliction_tick(function(player)
    local bleeding = affliction.get_affliction_total(player, "bleeding")
    local chance = bleeding/affliction.max_affliction
    if bleeding <= 0 then
        affliction.heal(player, "bleeding")
        return
    end
    if chance > math.random() then
        local player_pos = player:get_pos()
        local wolf_nodes = {
            "default:snow", "default:snowblock", 
            "default:cave_ice", "default:dirt_with_coniferous_litter"
        }
        local spawn_nodes = minetest.find_nodes_in_area_under_air(
            vector.subtract(player_pos, 24),
            vector.add(player_pos, 24), wolf_nodes
        )
        if #spawn_nodes >= 1 then
            local spawn_pos = spawn_nodes[math.random(1, #spawn_nodes)]
            spawn_pos.y = spawn_pos.y + 1 
            local mob = minetest.add_entity(spawn_pos, "mobs_wolf:wolf")
        end
    end
    affliction.treat(player, "affliction:heal_time")
end)