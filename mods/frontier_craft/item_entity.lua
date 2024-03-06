-- From Sokomine's Anvil mod 


local tmp = {}

minetest.register_entity("frontier_craft:craft_item", {
	hp_max = 1,
	visual = "wielditem",
	visual_size = {x = .33, y = .33},
	collisionbox = {0, 0, 0, 0, 0, 0},
	physical = false,
	textures = {"air"},
	on_activate = function(self, staticdata)
		if tmp.nodename ~= nil and tmp.texture ~= nil then
			self.nodename = tmp.nodename
			tmp.nodename = nil
			self.texture = tmp.texture
			tmp.texture = nil
		else
			if staticdata ~= nil and staticdata ~= "" then
				local data = staticdata:split(";")
				if data and data[1] and data[2] then
					self.nodename = data[1]
					self.texture = data[2]
				end
			end
		end
		if self.texture ~= nil then
			self.object:set_properties({textures = {self.texture}})
		end
	end,
	get_staticdata = function(self)
		if self.nodename ~= nil and self.texture ~= nil then
			return self.nodename .. ";" .. self.texture
		end
		return ""
	end,
})

-- Handle craft item entities such as placed on Anvil
frontier_craft.remove_item_entity = function(pos)
	local npos = vector.new(pos.x, pos.y + frontier_craft.settings.item_entity_offset, pos.z)
	local objs = minetest.get_objects_inside_radius(npos, .5)
	if objs then
		for _, obj in ipairs(objs) do
			if obj and obj:get_luaentity() and obj:get_luaentity().name == "frontier_craft:craft_item" then
				obj:remove()
			end
		end
	end
end

frontier_craft.update_item_entity = function(pos, node, offset)
	if node == nil then
		node = minetest.get_node(pos)
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if not inv:is_empty("input") then
		local offset = offset or frontier_craft.settings.item_entity_offset
		item_pos = table.copy(pos)
		item_pos.y = pos.y + offset
		tmp.nodename = node.name
		tmp.texture = inv:get_stack("input", 1):get_name()
		local e = minetest.add_entity(item_pos, "frontier_craft:craft_item")
		local yaw = math.pi * 2 - node.param2 * math.pi / 2
		e:set_rotation({x = -1.5708, y = yaw, z = 0}) -- x is pitch, 1.5708 is 90 degrees.
	end
end


function frontier_craft.has_access(pos, player)
	local name = player:get_player_name()
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	local shared = meta:get_int("shared") == 1
	if shared or name == owner then
		return true
	else
		minetest.log('warning', "Frontier Craft: Access denied to " .. player:get_player_name().. " at ".. minetest.pos_to_string(pos))
		return false
	end
end