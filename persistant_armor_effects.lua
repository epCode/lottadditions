

core.register_globalstep(function(dtime)
  for _,player in pairs(minetest.get_connected_players()) do
    lottadditions.persistant_armor[player] = lottadditions.persistant_armor[player] or {
      [1] = "",
      [2] = "",
      [3] = "",
      [4] = "",
      [5] = "",
      [6] = "",
      [7] = "",
    }
    local old_armor = lottadditions.persistant_armor[player]
    local inv = player:get_inventory()
    local new_armor = {}
    for i = 1, 7 do

      local stack = inv:get_stack("armor", i)

      local item = stack:get_name()

      new_armor[i] = item

      if item ~= "" then
        if minetest.registered_items[item] and minetest.registered_items[item].wearing then
          local wear = minetest.registered_items[item].wearing(player, stack)
          if wear then
            stack:add_wear((wear or 1))
          end
        end
      elseif old_armor[i] ~= "" and minetest.registered_items[old_armor[i]] and minetest.registered_items[old_armor[i]].removal then
        minetest.registered_items[old_armor[i]].removal(player, stack)
      end
    end
    lottadditions.persistant_armor[player] = new_armor
  end
end)