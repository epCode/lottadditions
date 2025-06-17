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
		{name = "lottblocks:palantir",
		chance = 20,
		min = 1,
		max = 1,},
		{name = "lottother:saruman_staff_bottom",
		chance = 3,
		min = 1,
		max = 1,},
		{name = "lottother:saruman_staff_top",
		chance = 3,
		min = 1,
		max = 1,},
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
        if obj:get_hp() and obj:get_hp() > 10 and obj ~= self.object and not self.attack then
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
		random = "saruman_laugh",
		death = "saruman_death",
	},
	
	on_rightclick = function(self, clicker)
	end,
	
	
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
	
})
mobs:register_spawn("lottadditions:gollum", {"default:stone"}, 20, -1, 100000, 2, -7000)
