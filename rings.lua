
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

local function unstable_pos(pos, v) -- works for non straight vectors if needed
  local nodes = minetest.registered_nodes
  for i = 1, 30 do
    local headpos = vector.add((vector.add(pos, vector.new(0,1,0))), vector.multiply(v, i))
    local feetpos = vector.add(pos, vector.multiply(v, i))
    local node1 = minetest.get_node_or_nil(feetpos)
    local node2 = minetest.get_node_or_nil(feetpos)
    if node1 and node2 and nodes[node1.name] and nodes[node2.name] and not nodes[node1.name].walkable and not nodes[node2.name].walkable then
      return vector.round(feetpos)
    end
  end
  return nil
end
  
local last_vel = {}


minetest.register_craftitem("lottadditions:ring_thorium", {
	description = minetest.colorize("green", "Thorium Ring of Instability Travel") ..
		minetest.get_background_escape_sequence("lightgoldenrodyellow"),
	inventory_image = "ad_thorium_ring.png",
	groups = {forbidden = 1, immortal=1, armor_ring=1},
  
  wearing = function(player, stack)
    local name = player:get_player_name()
    
    local vel = player:get_velocity()
    if last_vel[name] then
      local lvel = last_vel[name]
      local pos = nil
      if math.abs(vel.x) < 0.01 and math.abs(lvel.x) > 3 then
        pos = unstable_pos(player:get_pos(), vector.normalize(vector.new(lvel.x,0,0)))
      elseif math.abs(vel.z) < 0.01 and math.abs(lvel.z) > 3 then
        pos = unstable_pos(player:get_pos(), vector.normalize(vector.new(0,0,lvel.z)))
      end
      if pos and mana.subtract(name, 120) then
        player:punch(player, 1, {damage_groups = {fleshy = math.random(6)}}, vector.zero())
        player:set_pos(pos)
      end
    end
    
    last_vel[name] = vel
  end,
	removal = function(player, stack)
		player:set_physics_override({gravity = 1})
	end,
  wear = 0,
}, {"on_use"})


-- TODO: Hunger, Telep, Lev, Free Action?, Damage, Speed, Naz rings