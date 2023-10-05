frontier_plants.mortar = {}
frontier_plants.mortar.recipes = {}

local herbs = {
	{"rose","#990000", "red"}, 
	{"tulip","#ff6600", "orange"},
	{"dandelion_yellow","#ffcc00", "yellow"},
	{"dandelion_white", "#ffffff", "white"},
	{"geranium","#3041cc", "blue"},
	{"viola","#9933ff", "violet"}, 
	{"chrysanthemum_green","#8fc028", "green"}, 
	{"tulip_black","#2e1a25", "black"},
}

frontier_plants.mortar.register_recipe = function(input, output, num_in, num_out)
    local tbl = {output, num_in, num_out}
    frontier_plants.mortar.recipes[input] = tbl
end

--Recipe Registrations

for i = 1, #herbs do
	local herb = herbs[i][1]
	local color = herbs[i][2]
    local color_name = herbs[i][3]
        
	minetest.register_craftitem("frontier_plants:dried_"..herb, {
		description = "Dried "..herb,
		inventory_image = "herb.png^[colorize:"..color..":180^herb_leaf.png",
	})
    frontier_plants.mortar.register_recipe ("frontier_plants:"..herb, "cs_herb:dried_"..herb, 1, 1)
    frontier_plants.mortar.register_recipe ("frontier_plants:dried_"..herb, "dye:"..color_name, 1, 4)
end

frontier_plants.mortar.register_recipe("farming:seed_wheat", "farming:flour", 9, 1)



for i = 0, 3 do
	minetest.register_entity("frontier_plants:meter"..tostring(i), {
		initial_properties = {
			textures = {"meter"..tostring(i)..".png"},
			visual = "sprite",
			physical = false,
			pointable = false,
			collide_with_objects = false,
			visual_size = {x=0.5, y=0.5},
			glow = 5,
		}
	})
end

minetest.register_node("frontier_plants:mortar", {
	description = "Mortar and Pestle",
	drawtype = "nodebox",
	tiles = {"default_stone.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	groups = {cracky=3, snappy = 3},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		for k, v in pairs(frontier_plants.mortar.recipes) do
            if itemstack:get_name() == k and itemstack:get_count() >= v[2] then
                local meta = minetest.get_meta(pos)
                if meta:get_string("contents") ~= "" then
					minetest.chat_send_player(clicker:get_player_name(), "Contains "..meta:get_string("contents"))
					return itemstack
				else
					local ent = minetest.add_entity(pos, "frontier_plants:meter0")
					local inv = minetest.get_inventory({type="player", name=clicker:get_player_name()})
					meta:set_string("contents", k)
					meta:set_int("punches", 0)
					itemstack:take_item(v[2])
					inv:set_stack("main", clicker:get_wield_index(), itemstack)		
					return itemstack
				end
            
            end
        end
	end,
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		local meta = minetest.get_meta(self)
		local contents = meta:get_string("contents")
		local punches = meta:get_int("punches")
		local pos = self
		--pos.y = pos.y + 1
		if contents == "" then
			return
		end
		local ents = minetest.get_objects_inside_radius(pos, 1)		
		for i, ent in ipairs(ents) do
			if ent:get_luaentity() == nil then
				return
			end
			local ent_name = ent:get_luaentity().name
			if string.match(ent_name, "meter") then 
				ent:remove() 
			end
		end
		if punches >= 3 then
            local output = ItemStack(frontier_plants.mortar.recipes[contents][1])
            output:set_count(frontier_plants.mortar.recipes[contents][3])
            --minetest.chat_send_all(output)
			--local itemstack = ItemStack({name = output, count=1, wear=0, metatdata=""})
			minetest.item_drop(output, nil, pos)
			meta:set_string("contents", "")
			meta:set_int("punches", 0)
			meta:set_string("meter", "")
		else
			punches = punches + 1
			minetest.add_entity(pos, "frontier_plants:meter"..tostring(punches))
			meta:set_int("punches", punches)
		end
	end,
	node_box = {
		type = "fixed",	
		fixed = {
--base
			{-0.1875, -0.5, -0.1875, 0.1875, -0.4326, 0.1875,}, 
--stem
			{-0.125, -0.4326, -0.125, 0.125, -0.375, 0.125},
--bowl
			{-0.1875, -0.375, -0.1875, 0.1875, -0.3075, -0.125},
			{-0.1875, -0.375, -0.1875, -0.125, -0.3075, 0.1875},
			{-0.1875, -0.376, 0.1875, 0.1875, -0.3075, 0.125},
			{0.1875, -0.376, 0.1875, 0.125, -0.3075, -0.1875},
--bowl wall
			{-0.1875, -0.3075, -0.25, 0.1875, -0.1875, -0.1875},
			{-0.25, -0.3075, -0.1875, -0.1875, -0.1875, 0.1875},
			{-0.1875, -0.3075, 0.25, 0.1875, -0.1875, 0.1875},
			{0.25, -0.3075, 0.1875, 0.1875, -0.1875, -0.1875},
    
--Pestle
			{0, -0.375,  0, 0.09375, 0, 0.09375,},
		}
  },
})
-- Craft
minetest.register_craft({
    output = "frontier_plants:mortar",
    recipe = {
        {"default:stone", "default:stone", "default:stone"},
        {"", "default:stone", ""},
    }
})
