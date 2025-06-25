local function on_flood(pos, oldnode, newnode)
  core.set_node(pos, {name="lottadditions:lantern_basic_out"})
  return true
end

minetest.register_node("lottadditions:lantern_basic", {
	description = "Brass Lantern",
	drawtype = "plantlike",
	inventory_image = "ad_lantern_inv.png",
	wield_image = "ad_lantern_inv.png",
	tiles = {{
			name = "ad_lantern.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3}
	}},
  selection_box = {
    type = "fixed",
    fixed = {-1/8, -1/2, -1/8, 1/8, 2/16, 1/8},
  },
  paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	liquids_pointable = false,
	light_source = 12,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1, lantern=1},
	floodable = true,
	on_flood = on_flood,
})

minetest.register_node("lottadditions:lantern_basic_out", {
	description = "Brass Lantern (out of fuel)",
	drawtype = "plantlike",
  inventory_image = "ad_lantern_out_inv.png",
  wield_image = "ad_lantern_out_inv.png",
	tiles = {"ad_lantern_out_inv.png"},
  selection_box = {
    type = "fixed",
    fixed = {-1/8, -1/2, -1/8, 1/8, 2/16, 1/8},
  },
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	liquids_pointable = false,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1, lantern=1},
})
