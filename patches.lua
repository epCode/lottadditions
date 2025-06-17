armor.formspec = armor.formspec..
"]image[2,0;1,1;ad_ring.png]"..
"image[2,1;1,1;ad_ring.png]"..
"list[detached:player_name_armor;armor;2,0;1,2;5]"

local default_intensity = tonumber(core.settings:get("enable_shadows_default_intensity") or 0.33)
local default_strength = tonumber(core.settings:get("volumetric_lighting_default_strength") or 0.1)
local function set_dark(player, boo)
  local llevel = (core.get_node_light(player:get_pos()) or 10) +4
  player:set_lighting()
  player:set_sky()
  if boo then
    player:set_sky({
      fog = {
        fog_distance = 10,
        fog_start = 0,
        fog_color = "#fff"
      },
      clouds = false,
      sky_color = {
        day_sky = "#fff",
        day_horizon = "#fff",
        dawn_sky = "#fff",
        dawn_horizon = "#fff",
        night_sky = "#fff",
        night_horizon = "#fff",
        indoors = "#fff",
        fog_sun_tint = "#fff",
        fog_moon_tint = "#fff",
      }
    })
    player:set_lighting({
      saturation = 0.2,
      shadows = { intensity = 0.5 },
      bloom = {
        intensity = 1,
        strength_factor = 3,
        radius = 7,
      },
      volumetric_light = { strength = 0.1 },
      exposure = {
        luminance_min = ((llevel*0.5) - 11) * 0.7,
        luminance_max = ((llevel*0.5) - 11) * 0.7,
        exposure_correction = -2.5,
        speed_dark_bright = 100.0,
        speed_bright_dark = 100.0,
        center_weight_power = 1.0,
      },
    })
  end
end




minetest.override_item("lottother:one_ring", {
	description = minetest.colorize("black", "The One Ring") ..
		minetest.get_background_escape_sequence("lightgoldenrodyellow"),
	inventory_image = "ad_gold_ring.png",
	wield_image = "ad_gold_ring.png",
	groups = {forbidden = 1, immortal=1, armor_ring=1},
  
  wearing = function(player, stack)
    mana.subtract(player:get_player_name(), 1)
    playereffects.apply_effect_type("invisible", 1 , player)
		set_dark(player, true)
  end,
	removal = function(player, stack)
		set_dark(player)
	end,
	
  wear = 0,
}, {"on_use"})

minetest.register_craftitem("lottadditions:ring_am", {
	description = minetest.colorize("green", "Amythist Ring of feather falling") ..
		minetest.get_background_escape_sequence("lightgoldenrodyellow"),
	inventory_image = "ad_am_ring.png",
	wield_image = "ad_am_ring.png",
	groups = {forbidden = 1, immortal=1, armor_ring=1},
  
  wearing = function(player, stack)
		local vel = player:get_velocity()
		if vel.y < -5 and ((math.random(2) == 1 or mana.subtract(player:get_player_name(), 1))) then
			player:set_physics_override({gravity = -0.1})
		else
			player:set_physics_override({gravity = 1})
		end
  end,
	removal = function(player, stack)
		player:set_physics_override({gravity = 1})
	end,
  wear = 0,
}, {"on_use"})
