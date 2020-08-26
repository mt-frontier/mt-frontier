minetest.register_craftitem("frontier_guns:shotgun_shell", {
	description = "Shotgun Shell",
	inventory_image = "frontier_guns_shotgun_shell.png",
	groups = {ammo = 1},
})

minetest.register_craftitem("frontier_guns:bullet", {
	description = "Revolver Round",
	inventory_image = "frontier_guns_357.png",
	groups = {ammo = 1},
})

shooter.register_weapon("frontier_guns:shotgun", {
	description = "Shotgun",
	inventory_image = "frontier_guns_shotgun.png",
	reload_item = "frontier_guns:shotgun_shell",
	spec = {
		rounds = 2,
		range = 75,
		step = 30,
		shots = 12,
		spread = 10,
		tool_caps = {full_punch_interval=0.5, damage_groups={fleshy=6}},
		groups = {snappy=3, fleshy=3, oddly_breakable_by_hand=3},
		sounds = {
			shot = "shooter_shotgun",
		},
		bullet_image = "shooter_cap.png",
		particles = {
			amount = 8,
			minsize = 0.25,
			maxsize = 0.75,
		},

	},
})

shooter.register_weapon("frontier_guns:revolver", {
	description = "Revolver",
	inventory_image = "frontier_guns_revolver.png",
	reload_item = "frontier_guns:bullet",
	spec = {
		rounds = 6,
		range = 100,
		step = 40,
		shots = 1,
		tool_caps = {full_punch_interval=0.3, damage_groups={fleshy=11}},
		groups = {snappy=3, crumbly=3, choppy=3, fleshy=2, oddly_breakable_by_hand=2},
		sounds = {
			shot = "shooter_rifle",
		},
		bullet_image = "shooter_bullet.png",
		particles = {
			amount = 12,
			minsize = 0.75,
			maxsize = 1.5,
		},
	}
})
