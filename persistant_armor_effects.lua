local default_intensity = tonumber(core.settings:get("enable_shadows_default_intensity") or 0.33)
local default_strength = tonumber(core.settings:get("volumetric_lighting_default_strength") or 0.1)
local function set_dark(player, boo)
  local llevel = core.get_node_light(player:get_pos()) or 10
  player:set_lighting()
  player:set_sky()
  if boo then
    player:set_sky({
      fog = {
        fog_distance = 30,
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
      shadows = { intensity = 0.1 },
      bloom = {
        intensity = 1,
        strength_factor = 1,
        radius = 10,
      },
      volumetric_light = { strength = 0.1 },
      exposure = {
        luminance_min = ((llevel*0.5) - 13) * 0.7,
        luminance_max = ((llevel*0.5) - 13) * 0.7,
        exposure_correction = -3,
        speed_dark_bright = 100.0,
        speed_bright_dark = 100.0,
        center_weight_power = 1.0,
      },
    })
  end
end


core.register_globalstep(function(dtime)
  for _,player in pairs(minetest.get_connected_players()) do
    local inv = player:get_inventory()
    for i = 1, 5 do

      local stack = inv:get_stack("armor", i)

      local item = stack:get_name()

      if item ~= "" then
        if minetest.registered_items[item] and minetest.registered_items[item].wearing then
          local wear = minetest.registered_items[item].wearing(player, stack)
          if wear then
            stack:add_wear((wear or 1))
          end
        end
      end
      if i == 5 and item ~= "lottother:one_ring" and lottadditions.patches[player].dark == true then
        lottadditions.patches[player].dark = false
        set_dark(player)
        print(math.random(100))
      elseif i == 5 and item == "lottother:one_ring" then
        set_dark(player, true)
        lottadditions.patches[player].dark = true
      end
    end
  end
end)