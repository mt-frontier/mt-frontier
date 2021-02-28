minetest.register_craftitem("adv_craft:bits_and_bobs", {
	Description = "Mechanical Bits and Bobs",
	inventory_image = "bits_and_bobs.png",
	wield_image = "bits_and_bobs.png"
})

minetest.register_craftitem("adv_craft:apple_sauce", {
	description = "Apple Sauce",
	inventory_image = "adv_craft_apple_sauce.png",
	wield_image = "adv_craft_apple_sauce.png",
	groups = {food_apple_sauce = 1},
	on_use = minetest.item_eat(3)
})
