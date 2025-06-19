armor.formspec = armor.formspec..
"]image[2,0;1,1;ad_ring.png]"..
"image[2,1;1,1;ad_ring.png]"..
"list[detached:player_name_armor;armor;2,0;1,2;5]"..
"image_button[2,3;1,1;ad_sound.png;toggle_sound;]"


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
        fog_color = "#999"
      },
      clouds = false,
      sky_color = {
        day_sky = "#999",
        day_horizon = "#999",
        dawn_sky = "#999",
        dawn_horizon = "#999",
        night_sky = "#999",
        night_horizon = "#999",
        indoors = "#999",
        fog_sun_tint = "#999",
        fog_moon_tint = "#999",
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
  equip = function(player, stack)
    lottadditions.patches[player].ring_equp = 1
    lottmusic.play_effect("take_off_ring", {
      pos = player:get_pos(),
      max_hear_distance = 9,
      gain = 0.5,
      loop = false,
    })
  end,
  wearing = function(player, stack, dtime)
    local equipdt = lottadditions.patches[player].ring_equp
    equipdt = (equipdt or 1) - dtime
    lottadditions.patches[player].ring_equp = equipdt
    if equipdt > 0 then return else
      lottmusic.play_music(player, "ring_on", {priority = 3, gain = 0.4})
      mana.subtract(player:get_player_name(), 1)
      playereffects.apply_effect_type("invisible", 1 , player)
  		set_dark(player, true)
    end
  end,
	removal = function(player, stack)
    lottadditions.patches[player].ring_equp = 1
    lottmusic.play_effect("take_off_ring", {
      pos = player:get_pos(),
      max_hear_distance = 9,
      gain = 0.5,
      loop = false,
    })
    minetest.after(1, function()
      if player and player:get_pos() then
        lottmusic.music_stop(player, false, 0.4)
    		set_dark(player)
      end
    end)
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
    local name = player:get_player_name()
		local vel = player:get_velocity()
		if vel.y < -5 and mana.get(name) > 5 then
      if math.random(2) == 1 then
        mana.subtract(name, 1)
      end
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
