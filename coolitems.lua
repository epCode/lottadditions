local dropslists = {
  regrings = {
    ["lottadditions:ring_am"] = 2,
    ["lottadditions:ring_thorium"] = 1,
  },
  rareweapons = {
    ["lottadditions:ring_am"] = 2,
    ["lottadditions:ring_thorium"] = 1,
  },
  regarmor = {
    ["lottarmor:leggings_dwarf"] = 2,
    ["lottarmor:boots_dwarf"] = 2,
    ["lottarmor:helmet_dwarf"] = 2,
    ["lottarmor:boots_ranger"] = 3,
    ["lottarmor:helmet_wood"] = 4,
    ["lottarmor:chestplate_wood"] = 4,
    ["lottarmor:leggings_wood"] = 4,
    ["lottarmor:boots_wood"] = 4,
    ["lottarmor:helmet_tin"] = 4,
    ["lottarmor:chestplate_tin"] = 4,
    ["lottarmor:leggings_tin"] = 4,
    ["lottarmor:boots_tin"] = 4,
    ["lottarmor:helmet_copper"] = 4,
    ["lottarmor:chestplate_copper"] = 4,
    ["lottarmor:leggings_copper"] = 4,
    ["lottarmor:boots_copper"] = 4,
    ["lottarmor:helmet_steel"] = 4,
    ["lottarmor:chestplate_steel"] = 4,
    ["lottarmor:leggings_steel"] = 4,
    ["lottarmor:boots_steel"] = 4,
    ["lottarmor:helmet_bronze"] = 4,
    ["lottarmor:chestplate_bronze"] = 4,
    ["lottarmor:leggings_bronze"] = 4,
    ["lottarmor:boots_bronze"] = 4,
    ["lottarmor:helmet_silver"] = 3,
    ["lottarmor:chestplate_silver"] = 3,
    ["lottarmor:leggings_silver"] = 3,
    ["lottarmor:boots_silver"] = 3,
    ["lottarmor:helmet_gold"] = 3,
    ["lottarmor:chestplate_gold"] = 3,
    ["lottarmor:leggings_gold"] = 3,
    ["lottarmor:boots_gold"] = 3,
    ["lottarmor:helmet_galvorn"] = 3,
    ["lottarmor:chestplate_galvorn"] = 2,
    ["lottarmor:leggings_galvorn"] = 2,
    ["lottarmor:boots_galvorn"] = 2,
    ["lottarmor:helmet_mithril"] = 2,
    ["lottarmor:chestplate_mithril"] = 2,
    ["lottarmor:leggings_mithril"] = 2,
    ["lottarmor:boots_mithril"] = 2,
    ["lottarmor:helmet_thorium"] = 1,
    ["lottarmor:chestplate_thorium"] = 1,
    ["lottarmor:leggings_thorium"] = 1,
    ["lottarmor:boots_thorium"] = 1,
    ["lottarmor:shield_wood"] = 4,
    ["lottarmor:shield_tin"] = 4,
    ["lottarmor:shield_copper"] = 4,
    ["lottarmor:shield_steel"] = 4,
    ["lottarmor:shield_bronze"] = 4,
    ["lottarmor:shield_silver"] = 3,
    ["lottarmor:shield_gold"] = 3,
    ["lottarmor:shield_galvorn"] = 2,
    ["lottarmor:shield_mithril"] = 2,
    ["lottarmor:shield_thorium"] = 1,
  },
  regweapons = {
    ["lottthrowing:arrow_fire_blue"] = {4, 16},
    ["lottthrowing:arrow_fire"] = {4, 24},
    ["lottthrowing:arrow_fire"] = {4, 16},
    ["lottthrowing:bolt_fire"] = {4, 1},
    ["lottthrowing:arrow_mithril"] = {1, 12},
    ["lottthrowing:bolt_mithril"] = {1, 12},

    ["default:sword_wood"] = 5,
    ["default:sword_stone"] = 5,
    ["default:sword_steel"] = 4,
    ["default:sword_bronze"] = 4,

    
    
    
    
    
    ["lottweapons:wood_battleaxe"] = 5,
    ["lottweapons:wood_warhammer"] = 5,
    ["lottweapons:wood_spear"] = 5,
    ["lottweapons:wood_dagger"] = 5,
    ["lottweapons:stone_battleaxe"] = 5,
    ["lottweapons:stone_warhammer"] = 5,
    ["lottweapons:stone_spear"] = 5,
    ["lottweapons:stone_dagger"] = 5,
    ["lottweapons:copper_battleaxe"] = 5,
    ["lottweapons:copper_warhammer"] = 5,
    ["lottweapons:copper_spear"] = 5,
    ["lottweapons:copper_dagger"] = 5,
    ["lottweapons:tin_battleaxe"] = 4,
    ["lottweapons:tin_warhammer"] = 4,
    ["lottweapons:tin_spear"] = 4,
    ["lottweapons:tin_dagger"] = 4,
    ["lottweapons:steel_battleaxe"] = 4,
    ["lottweapons:steel_warhammer"] = 4,
    ["lottweapons:steel_spear"] = 4,
    ["lottweapons:steel_dagger"] = 4,
    ["lottweapons:bronze_battleaxe"] = 4,
    ["lottweapons:bronze_warhammer"] = 4,
    ["lottweapons:bronze_spear"] = 4,
    ["lottweapons:bronze_dagger"] = 4,
    ["lottweapons:silver_battleaxe"] = 4,
    ["lottweapons:silver_warhammer"] = 4,
    ["lottweapons:silver_spear"] = 4,
    ["lottweapons:silver_dagger"] = 4,
    ["lottweapons:gold_battleaxe"] = 4,
    ["lottweapons:gold_warhammer"] = 4,
    ["lottweapons:gold_spear"] = 4,
    ["lottweapons:gold_dagger"] = 4,
    ["lottweapons:galvorn_battleaxe"] = 3,
    ["lottweapons:galvorn_warhammer"] = 3,
    ["lottweapons:galvorn_spear"] = 3,
    ["lottweapons:galvorn_dagger"] = 3,
    ["lottweapons:mithril_battleaxe"] = 2,
    ["lottweapons:mithril_warhammer"] = 2,
    ["lottweapons:mithril_spear"] = 2,
    ["lottweapons:mithril_dagger"] = 2,
  }
  
}


function lottadditions.drops(lists)
  local all = {}
  for name,mul in pairs(lists) do
    olist = dropslists[name]
    dlist = {}
    for name,amount in pairs(olist) do
      local am = amount
      local ct = 1
      if type(am) == "table" then
        ct = amount[2]
        am = am[1]
      end
      for i=1,am do
        table.insert(dlist, {name, ct})
      end
    end
    all[name] = {l=dlist, chance = mul}
  end
  return all
end