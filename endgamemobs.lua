mobs:register_mob("lottadditions:gollum", {
	type = "npc",
	race = "GAMEorc",
	hp_min = 16,
	hp_max = 16,
	
	collisionbox = {-0.45, 0, -0.45, 0.45, 0.9, 0.45},
  visual = "mesh",
	mesh = "mobs_mc_golum.b3d",
	textures = {
		{"mobs_mc_golum.png"},
	},
	
	visual_size = {x=5, y=5},	
	makes_footstep_sound = true,
	view_range = 40,
	walk_velocity = 2,
	run_velocity = 6,
	armor = 20,
  pathfinding = 2,
	damage = 6,
	reach = 2,
	
	drops = {
		{name = "lottadditions:ring_am",
		chance = 30,
		min = 1,
		max = 1,},
		{name = "lottarmor:boots_ranger", chance = 40, min = 1, max = 1,},
	},
	
	attack_type = "dogfight",
	do_custom = function(self, dtime, moveresult)
    if self.attack then
      if math.random(20) == 1 and moveresult.touching_ground then
        local yaw = self.object:get_yaw()
        self.object:add_velocity(vector.add(vector.multiply(core.yaw_to_dir(yaw), 4.5), vector.new(0,7,0)))
      end
    end
    self._looktimer = self._looktimer or dtime
    self._looktimer = self._looktimer + dtime
    if self._looktimer > 1 then
      self._looktimer = 0
      local mobs_around = core.objects_inside_radius(self.object:get_pos(), 10)
      for obj in mobs_around do
        if obj:get_hp() and obj:get_hp() > 10 and obj ~= self.object and not self.attack or self.object:get_hp() < 6 then
          self.state = "runaway"
          self.runaway_timer = 0.5
          self:set_yaw(core.dir_to_yaw(vector.direction(obj:get_pos(), self.object:get_pos())))
          break
        end
      end
    end
  end,
	_looktimer = 0,
	light_resistant = true,
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	
  --fear_height = 4,
	animation = {
		stand_speed = 25,
		walk_speed = 30,
		run_speed = 70,
		stand_start = 1,
		stand_end = 40,
		walk_start = 41,
		walk_end = 70,
		run_start = 41,
		run_end = 70,
		jump_start = 72,
		jump_end = 107,
		jump_loop = false,
	},
	jump = true,
	
	sounds = {

	},
	
	on_rightclick = function(self, clicker)
	end,
	
	
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
	
})
mobs:register_spawn("lottadditions:gollum", {"default:stone"}, 20, -1, 100000, 2, -7000)

mobs:register_mob("lottadditions:ogre", {
	type = "npc",
    race = "GAMEorc",
	
	hp_min = 220,
	hp_max = 230,
	
	collisionbox = {-1, -2.1, -1, 1, 2.3, 1},
	visual = "mesh",
	mesh = "ogre.b3d",
	textures = {
		{"ad_ogre.png"},
	},
	visual_size = {x = 5.5, y = 5.5},
	rotate = 180,
	do_custom = function(self, dtime, moveresult)
		if self.attack then
			local cols = moveresult.collisions
			for _,def in pairs(cols) do
				if def.axis ~= "y" and def.node_pos and math.random(1) == 1 then
					local node = minetest.get_node(def.node_pos)
					local drops = core.get_node_drops(node)
					for _,stack in pairs(drops) do
						core.add_item(def.node_pos, stack)
					end
					core.dig_node(def.node_pos)
				end
			end
		end
	end,
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 4,
	damage = 22,
	reach = 8,
	armor = 100,
	light_resistant = true,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	on_rightclick = nil,
	attack_type = "dogfight",
	
	drops = {
      {name = "dmobs:dragon_gem_poison", chance = 100, min = 1, max = 1},
	  {name = "dmobs:dragon_gem_lightning", chance = 100, min = 1, max = 1},
	  {name = "dmobs:dragon_gem_fire", chance = 100, min = 1, max = 1},
	  {name = "dmobs:dragon_gem_ice", chance = 100, min = 1, max = 1},
   },
	
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 189,
		punch_end = 198,
	},
	jump = true,
	sounds = {
		war_cry = {"ogre_war"},
		death = "ogre_death",
		attack = {"ogre_attack"},
	},
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
})
mobs:spawn_specific("lottadditions:ogre", {"default:stone"}, {"air"}, -1, 10, 60, 80000, 3, -30000, -6000)
