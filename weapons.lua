loadweapons = {}

--[[
core.register_on_mods_loaded(function()
  for name,def in pairs(core.registered_tools) do
    core.override_item(name, {
      description = (def.description or "").. "\n "..core.colorize("#f44", "(+0)")
    })
  end
end)]]

function loadweapons.set_stack_upgrade(stack, upgrades)
  local description = core.registered_items[stack:get_name()].description
  local tack_onfirst = ""
  local tack_on = ""
  local meta = stack:get_meta()
  for key,value in pairs(upgrades) do
    meta:set_string(key, core.serialize(value))
    if key == "dam" then
      description = description .. "\n "..core.colorize("#f44", "[+"..value.."]")
    elseif key == "aff" then
      tack_onfirst = tack_onfirst .. "  "..core.colorize("#4f4", "(+"..value..")")
    elseif value == "aff" then
      tack_on = tack_on .. "\nAffects your " .. key .. "."
    else
      tack_on = tack_on .. "\n"..value
    end
  end
  meta:set_string("description", description..tack_onfirst..tack_on)
  meta:set_string("upgrades", core.serialize(upgrades))
end

--[[
local witem = player:get_wielded_item()
loadweapons.set_stack_upgrade(witem, {
  dam = 5,
  aff = 2,
  Health = "aff",
  Speed = "aff",
  sharp = "Sharp",
})
player:set_wielded_item(witem)]]
-- aff's are effected by the aff value. EG speed = 2, and health = 2