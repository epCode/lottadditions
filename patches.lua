minetest.override_item("lottother:one_ring", {
	description = minetest.colorize("black", "The One Ring") ..
		minetest.get_background_escape_sequence("lightgoldenrodyellow"),
	inventory_image = "one_ring.png",
	wield_image = "lottother_ring.png",
	groups = {forbidden = 1, immortal=1, armor_shield=1},
  
  wearing = function(player, stack)
    mana.subtract(player:get_player_name(), 1)
    playereffects.apply_effect_type("invisible", 1 , player)
  end,
  wear = 0,
}, {"on_use"})

minetest.register_craftitem("lottother:ring_of_feather", {
	description = minetest.colorize("green", "Amythist Ring of feather falling") ..
		minetest.get_background_escape_sequence("lightgoldenrodyellow"),
	inventory_image = "one_ring.png",
	wield_image = "lottother_ring.png",
	groups = {forbidden = 1, immortal=1, armor_shield=1},
  
  wearing = function(player, stack)
    mana.subtract(player:get_player_name(), 1)
    playereffects.apply_effect_type("invisible", 1 , player)
  end,
  wear = 0,
}, {"on_use"})