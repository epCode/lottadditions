lottmusic = {
}
lottmstats = {
  
}


core.register_on_joinplayer(function(player)
  lottmusic[player] = {current_pid = nil, current_name = nil, priority = nil}
  lottmstats[player] = {gametimehit = minetest.get_gametime()}
  --lottmusic.play_music(player, "bree_night")
end)

function lottmusic.music_stop(player, force, fadespeed, other)
  local pid = lottmusic[player].current_pid
  if force then
    if pid then core.sound_stop(pid) end
  elseif pid then core.sound_fade(pid, fadespeed or 0.1, 0) end
  lottmusic[player] = {current_pid = nil, current_name = nil, priority = nil}
  if not other then
    lottmusic.next_music_check(player)
  end
  return lottmusic[player].current_name
end


-- priority, 1 = backround music, 2 = targeted music, 3 = long sound effects; if priority is the same, it will replace.
function lottmusic.play_music(player, name, def)
  def = def or {}
  local gain = def.gain or 0.2
  local fade = def.fade or 1
  local loop = not def.no_loop
  local priority = def.priority or 1
  
  if name == lottmusic[player].current_name or not lottadditions.patches[player].music or lottmusic[player].priority and lottmusic[player].priority > priority then return end
  if lottmusic[player].priority and priority > lottmusic[player].priority then
    lottmusic.music_stop(player, false, 0.3, true)
  else
    lottmusic.music_stop(player, false, 0.1, true)
  end
  lottmusic[player].current_name = name
  lottmusic[player].priority = priority
  lottmusic[player].current_pid = core.sound_play(name, {
    gain = gain,
    fade = fade,
    loop = loop,
    to_player = player:get_player_name(),
  })
end

local blockbiomes = {
  ["default:snowblock"] = "angmar",
  ["lottmapgen:angsnowblock"] = "angmar",
  ["lottmapgen:mordor_stone"] = "mordor",
  ["lottmapgen:blacksource"] = "mordor",
  ["lottmapgen:shire_grass"] = "shire",
  ["lottmapgen:lorien_grass"] = "lorien",
  ["lottmapgen:dunland_grass"] = "dunland",
  ["lottmapgen:ironhill_grass"] = "ironhill",
  ["lottmapgen:gondor_grass"] = "gondor",
  ["lottmapgen:fangorn_grass"] = "fangorn",
  ["lottmapgen:mirkwood_grass"] = "mirkwood",
  ["lottmapgen:rohan_grass"] = "rohan",
  ["lottmapgen:ithilien_grass"] = "ithilien",
  [""] = "ambient",
}


local function block_ratio(pos, radius)
  radius = radius or 10
  
  local nodenames = {}

  for key in pairs(blockbiomes) do
    table.insert(nodenames, key)
  end

  

  local nodes = core.find_nodes_in_area(
    vector.add(pos, vector.new(-radius, -radius, -radius)),
    vector.add(pos, vector.new(radius, radius, radius)),
    nodenames,
    true
  )
  local longest_list = {"", 0}
  
  for nname,lis in pairs(nodes) do
    if #lis > longest_list[2] then
      longest_list = {nname, #lis}
    end
  end
  
  return longest_list[1]
end


function lottmusic.next_music_check(player)
  local pos = player:get_pos()
  local biome = blockbiomes[block_ratio(pos, 10)]
  if pos.y > -50 then
    lottadditions.reset_sky(player, true)
    lottmusic.play_music(player, biome)
  else
    lottadditions.reset_sky(player)
    lottmusic.play_music(player, "underground")
  end
end

function lottmusic.play_effect(name, def)
  def = def or {}

  core.sound_play(name, {
    gain = def.gain or 0.2,
    fade = def.fade or 1,
    loop = def.loop or false,
    max_hear_distance = def.max_hear_distance,
    to_player = def.to_player,
  }, true)
end

core.register_on_player_receive_fields(function(player, formname, fields)
  if fields.toggle_sound then
    if lottadditions.patches[player].music then
      lottadditions.patches[player].music = false
      lottmusic.music_stop(player)
    else
      lottadditions.patches[player].music = true
    end
    core.show_formspec(player:get_player_name(), formname, "")
  end
end)

--[[
core.register_on_player_hpchange(function(player, hp_change, reason)
  if hp_change < -1 then
    lottmusic.play_music(player, "extremedanger", {priority = 2})
  end
end)]]

local ttimer = 0.5
minetest.register_globalstep(function(dtime)
  for _,player in pairs(minetest.get_connected_players()) do
    
    --[[
    local witem = player:get_wielded_item()
    loadweapons.set_stack_upgrade(witem, {
      dam = 5,
      aff = 2,
      Health = "add",
      Speed = "add",
      sharp = "Sharp",
    })
    player:set_wielded_item(witem)]]


    ttimer = ttimer-dtime
    
    if ttimer < 0 then
      ttimer = 20
      
      lottmusic.next_music_check(player)
    end

    
    
    for player,stats in pairs(lottmstats) do
      if lottmusic[player].current_name == "extremedanger" and core.get_gametime()-lottmstats[player].gametimehit > 9 then
        lottmusic.music_stop(player)
      end
    end
  end
end)