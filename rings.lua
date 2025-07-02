lottadditions.registered_rings = {}
lottadditions.unregistered_rings = {}

function lottadditions.register_ring(name, def)
	
	def.groups.immortal=1
	def.groups.armor_ring=1
	
	lottadditions.unregistered_rings["lottadditions:ring_"..name] = def
end

lottadditions.register_ring("feather_falling", {
	print_name = "Feather Falling",
	groups = {forbidden = 1},
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
})

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


lottadditions.register_ring("instability", {
	print_name = "Instability Travel",
	groups = {forbidden = 1},
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
})

-- TODO: Hunger, Telep, Lev, Free Action?, Damage, Speed, Naz rings
































local function get_keys(t)
	local keyset={}
	local n=0

	for k,v in pairs(t) do
	  n=n+1
		if t[k] then
		  keyset[n]=k
		end
	end
	return keyset
end



local mstorage = core.get_mod_storage()

if mstorage:get_string("cycled_items") ~= "" then
	local therings = core.deserialize(mstorage:get_string("cycled_items")).rings
	lottadditions.registered_rings = therings	
else
	local used_materials = table.copy(default.materials)
	for name,def in pairs(lottadditions.unregistered_rings) do
		
		local mat = get_keys(used_materials)
		if #mat < 1 then
			used_materials = table.copy(default.materials)
			
			mat = get_keys(used_materials)
		end
		local mat = mat[math.random(#mat)]
		local matprint = used_materials[mat].print_name
		
		def.description = matprint.." Ring of "..def.print_name
		def.inventory_image = "ad_"..mat.."_ring.png"
		
		
		lottadditions.registered_rings[name] = def
		
		local cycled = core.deserialize(mstorage:get_string("cycled_items")) or {}
		cycled.rings = lottadditions.registered_rings
		mstorage:set_string("cycled_items", core.serialize(cycled))
	end
end

for name,def in pairs(lottadditions.registered_rings) do
	core.register_craftitem(name, def)
end

