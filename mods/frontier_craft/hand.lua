craft.register_craft("hand", "default:torch", {"default:coal_lump", "default:stick"})

if minetest.global_exists("sfinv") then
    sfinv.override_page("sfinv:crafting", {
        title = "Crafting",
        get = function(self, player, context)
            return sfinv.make_formspec(player, context, 
                craft.build_formspec(player, "hand"), true
            )
        end
    })
end