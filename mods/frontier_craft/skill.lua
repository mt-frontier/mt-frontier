frontier_craft.registered_acheivements = {}

function frontier_craft.register_acheivement(name, def)
	assert(type(def) == "table", "def must be a table")
	assert(def.description, "Provide a description of the Acheivment")
	if def.storage then
		def.storage = {}
	end
	frontier_craft.registered_acheivements[name] = def
end

function frontier_craft.has_badge(player, badgename)
	local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	if inv:contains_item("badges", ItemStack(badgename)) then
		return true
	end
	return false
end

function frontier_craft.award_badge(player, badgename, badge_desc, announce)
	local name = player:get_player_name()
	local inv = minetest.get_inventory({type = "player", name = name})
	inv:add_item("badges", ItemStack(badgename))
	if announce then
		local msg = minetest.colorize("#009900", "Acheivement! ")..
		name .. " earned a badge: \"" .. badge_desc .."\"."
		minetest.chat_send_all(msg)
	end
end
------
-- Handle Class specific xp gains Hunters xp is handled in mobs_redo damage calculation
-- -------

frontier_craft.register_acheivement("harvest_crops", {
	description = "Homesteader gains XP from harvesting crops",
	func = function()
		local crop_nodes = {}
		for k, v in pairs(minetest.registered_nodes) do
			if (string.match(k, "crops:") or string.match(k, "farming:")) and (minetest.get_item_group(k, "plant") > 0 or minetest.get_item_group(k, "flora") > 0) then
				minetest.override_item(k, {
					after_dig_node = function(pos, oldnode, oldmetadata, digger)
						
					end
			})
			end
		end
	end,
})

frontier_craft.register_acheivement("dig_ores", {
	description = "Prospector gains XP by mining ores.",
	storage = false,
	func = function()
		local ores = {
			-- Ore name, xp points
			{"default:stone_with_coal",1},
			{"default:stone_with_tin",1},
			{"default:stone_with_copper",1},
			{"default:stone_with_iron", 2},
			{"default:stone_with_gold", 2}
		}
		for i, ore in ipairs(ores) do
			minetest.override_item(ore[1], {
				after_dig_node = function(pos, oldnode, oldmetadata, digger)
					
				end,
			})
		end
	end,
})

frontier_craft.register_acheivement("struck_gold", {
	description = "Struck Gold!",
	badge = "badge_frame.png^[colorize:#aa8800^default_gold_lump.png",
	func = function()
		local badgename = "frontier_craft:badge_struck_gold"
		minetest.override_item("default:stone_with_gold", {
			on_punch = function(pos, node, puncher, pt)
				if not frontier_craft.has_badge(puncher, badgename) then
					frontier_craft.award_badge(puncher, badgename, "Struck Gold!", true)
                    mtcoin.give_coins(puncher, "mtcoin:gold 5")
				end
			end
		})
	end,
})

frontier_craft.register_acheivement("brave_or_dumb", {
	description = "Either Brave or Dumb (Died in first day of a life)",
	badge = "badge_brave_or_dumb.png",
	func = function()
		minetest.register_on_respawnplayer(function(player)
			local meta = player:get_meta()
			meta:set_int("day_one", minetest.get_day_count())
		end)
		minetest.register_on_dieplayer(function(player)
			local meta = player:get_meta()
			local first_day = meta:get_int("day_one")
			local today = minetest.get_day_count()
			if today ~= first_day then
				print (today .."/"..first_day)
				return
			end
			local badgename = "frontier_craft:badge_brave_or_dumb"
			if not frontier_craft.has_badge(player, badgename) then
				frontier_craft.award_badge(player, badgename, "Either Brave or Dumb (Died in first day of a life)", true)
                mtcoin.give_coins(player, "mtcoin:gold 10")
			end
		end)
	end

})

local num_badges = 0
for name, def in pairs(frontier_craft.registered_acheivements) do
	if def.badge ~= nil then
		num_badges = num_badges + 1
		minetest.register_craftitem("frontier_craft:badge_"..name, {
	
			description = def.description,
			inventory_image = def.badge
		})
	end
	def.func()
end

minetest.register_on_joinplayer(function(player)
	local inv = minetest.get_inventory({type = "player", name = player:get_player_name()})
	inv:set_size("badges", num_badges)
end)

minetest.register_allow_player_inventory_action(function(player, action, inv, inv_info)
	if inv_info.listname == "badges" or inv_info.from_list == "badges" or inv_info.to_list == "badges" then
		return 0
	end
end)

sfinv.register_page("frontier_craft:badges", {
	title = "Badges",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, "list[current_player;badges;0,0;8,4]",true)
	end,
	
})

minetest.register_chatcommand("badges", {
	param = "<playername>",
	description = "See acheivement badges of a given player",
	func = function(name, params)
		local playername = params
		if params == "" then
			playername = name
		end
		local inv = minetest.get_inventory({type = "player", name = playername})
		local list = inv:get_list("badges")
		local size = inv:get_size("badges")
		local temp_inv = minetest.create_detached_inventory("badges")
		temp_inv:set_list("badges", list)
		local formspec = "size[8,5]"..
			"label[1,0;"..playername .."'s Badges]"..
			"list[detached:badges;badges;0,1;8,4]"
		minetest.show_formspec(name, "frontier_craft:badges_"..playername, formspec)
		minetest.remove_detached_inventory("badges")
	end,
})
