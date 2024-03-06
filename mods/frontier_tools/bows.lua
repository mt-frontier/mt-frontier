
-- Bows Mod by UjEdwin

bows = {
	pvp = minetest.settings:get_bool("enable_pvp"),
	registered_arrows = {},
	registered_bows = {}
}


local creative_mode_cache = minetest.settings:get_bool("creative_mode")

function bows.is_creative(name)
	return creative_mode_cache or minetest.check_player_privs(name, {creative = true})
end


bows.register_arrow = function(name, def)

	if name == nil or name == "" then
		return false
	end

	def.damage = def.damage or 0
	def.name = "bows:" .. name
	def.level = def.level or 1
	def.on_hit_object = def.on_hit_object
	def.on_hit_node = def.on_hit_node
	def.on_hit_sound = def.on_hit_sound or "default_dig_dig_immediate"

	bows.registered_arrows[def.name] = def

	minetest.register_craftitem(":bows:" .. name, {
		description = def.description or name,
		inventory_image = def.texture or "bows_arrow_wooden.png",
		groups = {arrow = 1},
		drop_chance = def.drop_chance
	})

	if def.craft then
		minetest.register_craft({
			output = def.name .." " .. (def.craft_count or 4),
			recipe = def.craft
		})
	end
end


bows.register_bow = function(name, def)

	if name == nil or name == "" then
		return false
	end

	def.replace = "bows:" .. name .. "_loaded"
	def.name = "bows:" .. name
	def.uses = def.uses - 1 or 49

	bows.registered_bows[def.replace] = def

	minetest.register_tool(":" .. def.name, {
		description = def.description or name,
		inventory_image = def.texture or "bows_bow.png",
		on_use = bows.load,
		groups = {bow = 1},
	})

	minetest.register_tool(":" .. def.replace, {
		description = def.description or name,
		inventory_image = def.texture_loaded or "bows_bow_loaded.png",
		on_use = bows.shoot,
		groups = {bow = 1, not_in_creative_inventory = 1},
	})

	if def.craft then
		minetest.register_craft({output = def.name,recipe = def.craft})
	end
end


bows.load = function(itemstack, user, pointed_thing)

	local inv = user:get_inventory()
	local index = user:get_wield_index() - 1
	local arrow = inv:get_stack("main", index)

	if minetest.get_item_group(arrow:get_name(), "arrow") == 0 then
		return itemstack
	end

	local item = itemstack:to_table()
	local meta = minetest.deserialize(item.metadata)

	meta = {arrow = arrow:get_name()}

	item.metadata = minetest.serialize(meta)
	item.name = item.name .. "_loaded"

	itemstack:replace(item)

	if not bows.is_creative(user:get_player_name()) then
		inv:set_stack("main", index,
				ItemStack(arrow:get_name() .. " " .. (arrow:get_count() - 1)))
	end

	return itemstack
end


bows.shoot = function(itemstack, user, pointed_thing)

	local item = itemstack:to_table()
	local meta = minetest.deserialize(item.metadata)

	if (not (meta and meta.arrow))
	or (not bows.registered_arrows[meta.arrow]) then
		return itemstack
	end

	local name = itemstack:get_name()
	local replace = bows.registered_bows[name].name
	local ar = bows.registered_bows[name].uses
	local wear = bows.registered_bows[name].uses
	local level = 19 + bows.registered_bows[name].level

	bows.tmp = {}
	bows.tmp.arrow = meta.arrow
	bows.tmp.user = user
	bows.tmp.name = meta.arrow

	item.arrow = ""
	item.metadata = minetest.serialize(meta)
	item.name = replace
	itemstack:replace(item)

	local prop = user:get_properties()
	local pos = user:get_pos() ; pos.y = pos.y + (prop.eye_height or 1.23)
	local dir = user:get_look_dir()
	local e = minetest.add_entity({
		x = pos.x,
		y = pos.y,
		z = pos.z
	}, "bows:arrow")

	e:set_velocity({x = dir.x * level, y = dir.y * level, z = dir.z * level})
	e:set_acceleration({x = dir.x * -3, y = -10, z = dir.z * -3})
	e:set_yaw(user:get_look_horizontal() - math.pi/2)

	if not bows.is_creative(user:get_player_name()) then
		itemstack:add_wear(65535 / wear)
	end

	minetest.sound_play("bows_shoot", {pos = pos}, true)

	return itemstack
end

-- Arrow functions

local on_hit_remove = function(self)

	minetest.sound_play(
		bows.registered_arrows[self.name].on_hit_sound, {
			pos = self.object:get_pos(),
			gain = 1.0,
			max_hear_distance = 7
		}, true)

	-- chance of dropping arrow
	local chance = minetest.registered_items[self.name].drop_chance
	local pos = self.object:get_pos()

	if pos and math.random(chance) == 1 then

		pos.y = pos.y + 0.5

		minetest.add_item(pos, self.name)
	end

	self.object:remove()

	return self
end


local on_hit_object = function(self, target, hp, user, lastpos)

	target:punch(user, 0.1, {
		full_punch_interval = 0.1,
		damage_groups = {fleshy = hp},
	}, nil)

	if bows.registered_arrows[self.name].on_hit_object then

		bows.registered_arrows[self.name].on_hit_object(
			self, target, hp, user, lastpos)
	end

	on_hit_remove(self)

	return self
end

--Fire Arrow Function
bows.arrow_fire_object=function(self,target,hp,user,lastpos)
    bows.arrow_fire(self,lastpos,user,target:get_pos())
    return self
end

bows.arrow_fire=function(self,pos,user,lastpos)
    lastpos = lastpos or pos
    local name=user:get_player_name()
    local node=minetest.get_node(lastpos).name
    if minetest.is_protected(lastpos, name) then
        minetest.chat_send_player(name, minetest.pos_to_string(lastpos) .." is protected")
    elseif minetest.registered_nodes[node].buildable_to then
        fire.place(lastpos)
	else
		fire.place(minetest.find_node_near(lastpos, 1, {"group:flammable"}, true) or lastpos)
    end
    --bows.arrow_remove(self)
    return self
end

-- Arrow entity
minetest.register_entity(":bows:arrow",{

	initial_properties = {
		hp_max = 10,
		visual = "wielditem",
		visual_size = {x = .20, y = .20},
		collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
		physical = false,
		textures = {"air"}
	},

	_is_arrow = true,
	timer = 10,

	on_activate = function(self, staticdata)

		if not self then
			self.object:remove()
			return
		end

		if bows.tmp and bows.tmp.arrow ~= nil then

			self.arrow = bows.tmp.arrow
			self.user = bows.tmp.user
			self.name = bows.tmp.name
			self.dmg = bows.registered_arrows[self.name].damage

			bows.tmp = nil

			self.object:set_properties({textures = {self.arrow}})
		else
			self.object:remove()
		end
	end,

	on_step = function(self, dtime, ...)

		self.timer = self.timer - dtime

		if self.timer < 0 then
			self.object:remove()
			return
		end

		local pos = self.object:get_pos() ; self.oldpos = self.oldpos or pos
		local cast = minetest.raycast(self.oldpos, pos, true, true)
		local thing = cast:next()
		local ok = true

		-- loop through things
		while thing do

			-- ignore the object that is the arrow
			if thing.type == "object" and thing.ref ~= self.object then

				-- add entity name to thing table (if not player)
				thing.name = not thing.ref:is_player() and thing.ref:get_luaentity().name

				-- check if dropped item or yourself
				if thing.name == "__builtin:item"
				or (not thing.name
				and thing.ref:get_player_name() == self.user:get_player_name()) then
					ok = false
				end

				-- can we hit entity ?
				if ok then

--print("-- hit entity", thing.name)

					on_hit_object(self, thing.ref, self.dmg, self.user, pos)

					return self
				end

			-- are we inside a node ?
			elseif thing.type == "node" then

				self.node = minetest.get_node(pos)

				local def = minetest.registered_nodes[self.node.name]

				if def and def.walkable then

--print("-- hit node", self.node.name)

					if bows.registered_arrows[self.name].on_hit_node then

						bows.registered_arrows[self.name].on_hit_node(
								self, pos, self.user, self.oldpos)
					end

					on_hit_remove(self)

					return self
				end
			end

			thing = cast:next()
		end

		self.oldpos = pos
	end
})

