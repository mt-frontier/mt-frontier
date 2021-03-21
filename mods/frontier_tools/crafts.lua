
function frontier_tools.register_toolset_craft(material)
	local craft_material = "default:"..material.."_ingot"
	if material == "stone" then
		craft_material = "default:stone"
	end
	
	local tools = {
		--{toolname, number of craft material required}
		{"frontier_tools:" .. material .. "_knife", 1},
		{"frontier_tools:" .. material .. "_pick", 3},
		{"frontier_tools:" .. material .. "_axe", 3},
		{"frontier_tools:" .. material .. "_shovel", 1},
		{"frontier_tools:" .. material .. "_hoe", 2},
	}
	for n = 1, #tools do
		craft.register_craft(
			"anvil",
			tools[n][1], 
			{"default:stick", craft_material .. " " .. tools[n][2]}
		)
	end
end

-- Toolsets
frontier_tools.register_toolset_craft("tin", "anvil")
frontier_tools.register_toolset_craft("steel", "anvil")
frontier_tools.register_toolset_craft("stone", "hand")
-- Misc crafts
craft.register_craft("anvil","bucket:bucket_empty", {"default:tin_ingot 3"})
craft.register_craft("anvil", "crops:watering_can", {"default:tin_ingot 5"})