minetest.override_item("lottother:one_ring", {
	description = minetest.colorize("black", "The One Ring") ..
		minetest.get_background_escape_sequence("lightgoldenrodyellow"),
	inventory_image = "ad_gold_ring.png",
	wield_image = "ad_gold_ring.png",
	groups = {forbidden = 1, immortal=1, armor_shield=1},
  
  wearing = function(player, stack)
    mana.subtract(player:get_player_name(), 1)
    playereffects.apply_effect_type("invisible", 1 , player)
  end,
  wear = 0,
}, {"on_use"})

minetest.register_craftitem("lottadditions:ring_am", {
	description = minetest.colorize("green", "Amythist Ring of feather falling") ..
		minetest.get_background_escape_sequence("lightgoldenrodyellow"),
	inventory_image = "ad_am_ring.png",
	wield_image = "ad_am_ring.png",
	groups = {forbidden = 1, immortal=1, armor_shield=1},
  
  wearing = function(player, stack)
		local vel = player:get_velocity()
		if vel.y < -5 and (math.random(6) == 1 or mana.subtract(player:get_player_name(), 1)) then
			
			player:set_physics_override({gravity = -0.1})
		else
			player:set_physics_override({gravity = 1})
		end
  end,
  wear = 0,
}, {"on_use"})