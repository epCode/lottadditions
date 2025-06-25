local pameffecrs = {}

core.register_globalstep(function(dtime)
  for _,player in pairs(minetest.get_connected_players()) do
    local name = player:get_player_name()
    pameffecrs[name] = pameffecrs[name] or {}
    lottadditions.persistant_armor[player] = lottadditions.persistant_armor[player] or {
      [1] = "",
      [2] = "",
      [3] = "",
      [4] = "",
      [5] = "",
      [6] = "",
      [7] = "",
    }
    local old_armor = lottadditions.persistant_armor[player] or ""
    local inv = player:get_inventory()
    local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})
    local new_armor = {}
    for i = 1, 10 do

      local stack = inv:get_stack("armor", i)


      if i > 5 then
        if pameffecrs[name].oldinv then
          local pinv = pameffecrs[name].oldinv
          local parmorinv = pameffecrs[name].oldarmorinv
          local relstack = parmorinv[i]
          --print(inv:get_stack("main", i-5):get_name())
          local stop
          if pinv[i-5]:get_name() ~= inv:get_stack("main", i-5):get_name() then
            relstack = inv:get_stack("main", i-5)
          elseif armor_inv:get_stack("armor", i):get_name() ~= parmorinv[i]:get_name() then
            relstack = armor_inv:get_stack("armor", i)
          else
            stop = true
          end
          if not stop then
            if relstack:get_name() == "" then
              relstack = ItemStack("lottarmor:placeholder")
            end
            local armstack = relstack
            if relstack:get_name() == "lottarmor:placeholder" then
              armstack = ItemStack("")
            end
            
            pameffecrs[name].oldinv[i-5] = relstack
            pameffecrs[name].oldarmorinv[i] = armstack
            inv:set_stack("main", i-5, relstack)
            inv:set_stack("armor", i, armstack)
            armor_inv:set_stack("armor", i, armstack)
          end
        end
      end


      local item = stack:get_name()

      new_armor[i] = item

      if item ~= "" then
        if minetest.registered_items[item] and minetest.registered_items[item].wearing then
          local wear = minetest.registered_items[item].wearing(player, stack, dtime)
          if wear then
            stack:add_wear((wear or 1))
          end
        end
      end
      if old_armor[i] ~= "" and old_armor[i] ~= new_armor[i] and minetest.registered_items[old_armor[i]] and minetest.registered_items[old_armor[i]].removal then
        minetest.registered_items[old_armor[i]].removal(player, stack)
      end
      if new_armor[i] ~= "" and old_armor[i] ~= new_armor[i] and minetest.registered_items[new_armor[i]] and minetest.registered_items[new_armor[i]].equip then
        minetest.registered_items[new_armor[i]].equip(player, stack)
      end
    end
    pameffecrs[name].oldinv = {}
    pameffecrs[name].oldarmorinv = {}
    for i = 1, 10 do
      pameffecrs[name].oldinv[i] = inv:get_stack("main", i)
      pameffecrs[name].oldarmorinv[i] = armor_inv:get_stack("armor", i)
    end
    lottadditions.persistant_armor[player] = new_armor
  end
end)