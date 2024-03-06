
-- Waterlily from mintest_game
minetest.register_node("frontier_plants:waterlily", {
	description = "Waterlily",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"frontier_plants_waterlily.png", "frontier_plants_waterlily_bottom.png"},
	inventory_image = "frontier_plants_waterlily.png",
	wield_image = "frontier_plants_waterlily.png",
	liquids_pointable = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {snappy = 3, flower = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -31 / 64, -0.5, 0.5, -15 / 32, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
	},

	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local node = minetest.get_node(pointed_thing.under)
		local def = minetest.registered_nodes[node.name]
		local player_name = placer and placer:get_player_name() or ""

		if def and def.on_rightclick then
			return def.on_rightclick(pointed_thing.under, node, placer, itemstack,
					pointed_thing)
		end

		if def and def.liquidtype == "source" and
				minetest.get_item_group(node.name, "water") > 0 then
			if not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "frontier_plants:waterlily",
					param2 = math.random(0, 3)})
				if not (creative and creative.is_enabled_for
						and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, "Node is protected")
				minetest.record_protection_violation(pos, player_name)
			end
		end

		return itemstack
	end
})


minetest.register_decoration({
	name = "frontier_plants:waterlily",
	deco_type = "simple",
	place_on = {"default:dirt", "default:sand"},
	sidelen = 16,
	noise_params = {
		offset = -0.1,
		scale = 0.3,
		spread = {x = 200, y = 200, z = 200},
		seed = 133,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"swamp", "swamp_ocean", "savanna_shore", "deciduous_forest_shore"},
	y_max = 0,
	y_min = 0,
	decoration = "frontier_plants:waterlily",
	param2 = 0,
	param2_max = 3,
	place_offset_y = 1,
})
