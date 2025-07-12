lottmusic = {
}
lottmstats = {
}


core.register_on_joinplayer(function(player)
  lottmusic[player] = {current_pid = nil, current_name = nil, priority = nil, ambient = {pid = nil, name = ""}}
  lottmstats[player] = {gametimehit = minetest.get_gametime()}
  --lottmusic.play_music(player, "bree_night")
end)

local ambient_structures = {
  windytrees = {
    "lottplants:alderleaf",
    "default:leaves",
    "lottplants:appleleaf",
    "lottplants:birchleaf",
    "lottplants:beechleaf",
    "lottplants:culumaldaleaf",
    "lottplants:yellowflowers",
    "lottplants:elmleaf",
    "lottplants:firleaf",
    "lottplants:lebethronleaf",
    "lottplants:mallornleaf",
    "lottplants:pineleaf",
    "lottplants:plumleaf",
    "lottplants:rowanleaf",
    "lottplants:whiteleaf",
    "lottplants:yavannamireleaf",
    "lottplants:mirkleaf"

  },
  cavesounds = {
    "default:stone",
    "default:desert_stone",
  },
  watersounds = {
    "default:water_source",
    "default:water_flowing",
    "default:river_water_source",
    "default:river_water_flowing"
  },
}

local ambient_structures_op = {}
local ambient_structures_op_neg = {}

for sound,dlist in pairs(ambient_structures) do
  for _,noden in pairs(dlist) do
    ambient_structures_op[noden] = ambient_structures_op[noden] or {}
    if type(noden) ~= "table" then
      table.insert(ambient_structures_op[noden], sound)
    else
      for _,nodeneg in pairs(noden) do
        ambient_structures_op[nodeneg] = ambient_structures_op[nodeneg] or {}
        table.insert(ambient_structures_op[nodeneg], sound)
        table.insert(ambient_structures_op[noden], sound)
      end
    end
  end
end

local function get_d_names(list, sounds)
  local flist = {}
  for sound,dlist in pairs(list) do
    if sounds then flist[sound] = 0 else
      for _,noden in pairs(dlist) do
        if type(noden) == "string" then
          table.insert(flist, noden)
        else
          for _,nodeneg in pairs(noden) do
            table.insert(flist, nodeneg)
          end
        end
      end
    end
  end
  return flist
end

local function ambient_applied_structure(pos)
  local SEARCHDIST = 10
  local nodes = core.find_nodes_in_area(vector.add(pos, vector.new(-SEARCHDIST,-SEARCHDIST,-SEARCHDIST)), vector.add(pos, vector.new(SEARCHDIST,SEARCHDIST,SEARCHDIST)), get_d_names(ambient_structures), true)
  
  local scorelist = get_d_names(ambient_structures, true)
  
  for nodenames,poslist in pairs(nodes) do
    local listscore = 0
    for _,nodepos in pairs(poslist) do
      local max_dist = SEARCHDIST*1.74
      local dist_inverted = ((-vector.distance(pos, nodepos)+max_dist)/10)^10
      listscore = listscore + dist_inverted
    end
    
    --if ambient_structures_op_neg[nodenames] then
    --  listscore = -listscore
    --end

    
    for _,soundname in pairs(ambient_structures_op[nodenames]) do
      if pos.y < -100 and soundname == "cavesounds" or soundname ~= "cavesounds" then
        scorelist[soundname] = scorelist[soundname] + listscore
      end
    end
  end
  local final_scored = {name=nil, score = 0}
  for name,score in pairs(scorelist) do
    if score > final_scored.score then
      final_scored = {name=name,score=score}
    end
  end
  return final_scored.name
end

function lottmusic.music_stop(player, force, fadespeed, other)
  local pid = lottmusic[player].current_pid
  if force then
    if pid then core.sound_stop(pid) end
  elseif pid then core.sound_fade(pid, fadespeed or 0.1, 0) end
  lottmusic[player] = {current_pid = nil, current_name = nil, priority = nil, ambient = lottmusic[player].ambient}
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

function lottmusic.ambient_stop(player, force, fadespeed)
  local pid = lottmusic[player].ambient.pid
  if force then
    if pid then core.sound_stop(pid) end
  elseif pid then core.sound_fade(pid, fadespeed or 0.1, 0) end
  lottmusic[player].ambient.pid = nil
end

function lottmusic.play_ambient(player, name, def)
  def = def or {}
  local gain = def.gain or 0.2
  local fade = def.fade or 1
  local loop = not def.no_loop
  
  if name == lottmusic[player].ambient.name then return end
  lottmusic.ambient_stop(player, false, 0.3, true)
  lottmusic[player].ambient.name = name
  lottmusic[player].ambient.pid = core.sound_play(name, {
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
    lottadditions.reset_sky(player)
    lottmusic.play_music(player, biome)
  else
    lottadditions.reset_sky(player)
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
local timer = 1
minetest.register_globalstep(function(dtime)
  for _,player in pairs(minetest.get_connected_players()) do
    local pos = player:get_pos()
    
    timer = timer-dtime
    
    if timer < 0 then
      
      
      local applied_ambient = ambient_applied_structure(pos)
      
      lottmusic.play_ambient(player, applied_ambient, {gain = 0.8})
      
      
      timer = math.random(100)/50
      
      if applied_ambient == "cavesounds" then
        lottmusic.play_music(player, "underground")
      end
      
      if (applied_ambient == "windytrees") and math.random(3) == 1 then
        local ppos = pos
        for i=1, math.random(11) do
          minetest.after(i*math.random(100)/100, function()
            lottmusic.play_effect("bird", {
              pos = vector.add(ppos, vector.multiply(vector.random_direction(), math.random(10))),
              max_hear_distance = 14,
              gain = math.random(2),
              loop = false,
            })
          end)
        end
      end
    end
    


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