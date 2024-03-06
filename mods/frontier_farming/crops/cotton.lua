-- Port farming cotton to crops

local S = crops.intllib

minetest.register_node("crops:cotton_seed", {
    description = S("Cotton seed"),
    tiles = {"farming_cotton_seed.png"},
    inventory_image = "farming_cotton_seed.png",
    wield_image = "farming_cotton_seed.png",
    drawtype = "signlike",
    paramtype2 = "wallmounted",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = crops.selection_boxes.seed
	},
	on_place = function(itemstack, placer, pointed_thing)
		local under = minetest.get_node(pointed_thing.under)
		if minetest.get_item_group(under.name, "soil") <= 1 then
			return
		end
		crops.plant(pointed_thing.above, {name="crops:cotton_seed", param2 = 1})

		if not minetest.settings:get_bool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end
})

for n = 1, 9 do
    minetest.register_node("crops:cotton_plant_"..n, {
        description = S("Cotton plant"),
        tiles= {"farming_cotton_" .. n .. ".png"},
        drawtype = "plantlike",
        waving = 1,
        sunlight_propagates = true,
        use_texture_alpha = true,
        walkable = false,
        paramtype = "light",
        groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
        drop = {},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
            type = "fixed",
            fixed = crops.selection_boxes.base
        }
    })
end

minetest.override_item("crops:cotton_plant_8", {
    on_dig = function(pos, node, digger)
            local drops = {}
            local damage = minetest.get_meta(pos):get_int("crops_damage")
            local n = 1
            if damage < 10 then
                n = n + 4
            elseif damage < 30 then
                n = n + 3
            elseif damage < 70 then
                n = n + 2
            else
                n = n + math.random(0,1)
            end

            for i = 1, n do
                table.insert(drops, "farming:cotton")
            end
            core.handle_node_drops(pos, drops, digger)
    end
})

crops.cotton_grow = function(pos)
    local node = minetest.get_node(pos)
    local n = string.gsub(node.name, "7", "8")
	n = string.gsub(n, "6", "7")
    n = string.gsub(n, "5", "6")
    n = string.gsub(n, "4", "5")
    n = string.gsub(n, "3", "4")
	n = string.gsub(n, "2", "3")
	n = string.gsub(n, "1", "2")
    if n == "crops:cotton_seed" then
        n = "crops:cotton_plant_1"
    end
    minetest.swap_node(pos, {name = n, param2 = 1})
end

crops.cotton_die = function(pos)
    minetest.set_node(pos, {name="crops:cotton_plant_9"})
end

local properties = {
	die = crops.cotton_die,
	grow = crops.cotton_grow,
	waterstart = 15,
	wateruse = 1,
	night = 5,
	soak = 55,
	soak_damage = 65,
	wither = 12,
	wither_damage = 2,
    cold = 52,
    cold_damage = 42,
    time_to_grow = 800,
}

crops.register({ name = "crops:cotton_seed", properties = properties})
crops.register({ name = "crops:cotton_plant_1", properties = properties})
crops.register({ name = "crops:cotton_plant_2", properties = properties})
crops.register({ name = "crops:cotton_plant_3", properties = properties})
crops.register({ name = "crops:cotton_plant_4", properties = properties})
crops.register({ name = "crops:cotton_plant_5", properties = properties})
crops.register({ name = "crops:cotton_plant_6", properties = properties})
crops.register({ name = "crops:cotton_plant_7", properties = properties})
crops.register({ name = "crops:cotton_plant_8", properties = properties})
