mobs:register_mob('scorpion:little', {
   type = 'monster',
   passive = false,
   attack_type = 'dogfight',
   damage = 2,
   hp_min = 10, hp_max = 20,
   collisionbox = {-0.3, -0.35, -0.3, 0.3, 0.3, 0.5},
   visual = 'mesh',
   mesh = 'scorpion_small.b3d',
   textures = {
      {'default_desert_sandstone.png'},
   },
   blood_texture = 'mobs_blood.png',
   visual_size = {x=7, y=7},
   makes_footstep_sound = true,
   sounds = {
      war_cry = 'scorpion_squeak2',
   },
   walk_velocity = 2,
   run_velocity = 5,
   jump = true,
   stepheight = 1.7,
   reach = 1.5,
   view_range = 5,
   fear_height = 2,
   drops = {
      --{name = 'mobs:meat_raw', chance = 1, min = 2, max = 8},
      --{name = 'scorpion:shell', chance = 1, min = 1, max = 10},
   },
   water_damage = 2,
   lava_damage = 60,
   light_damage = 0,
   animation = {
      speed_normal = 22,   speed_run = 45,
      stand_start = 0,     stand_end = 30,
      walk_start = 75,    walk_end = 105,
      run_start = 75,     run_end = 105,
      punch_start = 110,   punch_end = 130,
      punch2_start = 132,  punch2_end = 152,
      punch3_start = 35,   punch3_end = 70,
   },
})

mobs:spawn({
   name = 'scorpion:little',
   nodes = {'default:desert_sand', 'default:desert_stone', "default:sandstone", "default:dirt_with_dry_grass"},
   biomes = {"desert", "sandstone_desert", "savanna"},
   min_height = -20,
   max_height = 200,
   max_light = 13,
   interval = 37,
   chance = 7000,
   active_object_count = 5,
})
