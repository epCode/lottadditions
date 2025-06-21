lottadditions = {
  patches = {},
  persistant_armor = {}
}

core.register_on_joinplayer(function(player)
  lottadditions.patches[player] = {dark = false, music = true}
end)
-- each file should corrispond to one genre of changes, loosely.
-- DF = Do file
local function df(filename) dofile(core.get_modpath("lottadditions").."/"..filename) end

df("weapons.lua")

df("endgamemobs.lua")

df("patches.lua")

df("persistant_armor_effects.lua")

df("music.lua")








