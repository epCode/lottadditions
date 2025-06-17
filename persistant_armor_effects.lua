core.register_globalstep(function(dtime)
  for _,player in pairs(minetest.get_connected_players()) do
    local inv = player:get_inventory()
    for i = 1, 5 do
  		
  		local stack = inv:get_stack("armor", i)
      
  		local item = stack:get_name()
      
      if item ~= "" then
        if minetest.registered_items[item].wearing then
          local wear = minetest.registered_items[item].wearing(player, stack)
          if wear then
            stack:add_wear((wear or 1))
          end
        end
      end
    end
  end
end)