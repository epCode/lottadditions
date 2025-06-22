ch = {
  last_message = {}
}




--[[
local colors = {
  ["@R"] = "red",
  ["@B"] = "blue",
  ["@G"] = "green",
  ["@Y"] = "yellow",
  ["@O"] = "orange",
  ["@V"] = "violet",
  ["@D"] = "black",
}
function ch.chat(message)
  local matches = {}
  
  for annote,color in pairs(colors) do

  end
  
  minetest.chat_send_player(final_message)
end


ch.chat("Lol when @R is @R and @B is @B")]]

local colors = {
  ["@R"] = "red",
  ["@B"] = "blue",
  ["@G"] = "green",
  ["@Y"] = "yellow",
  ["@O"] = "orange",
  ["@V"] = "violet",
  ["@D"] = "black",
}


function ch.chat(player, message)
  if type(player) == "userdata" then
    player = player:get_player_name()
  end
  local final_message = message
  
  -- Iterate through the colors to find and replace annotations
  for annote, color in pairs(colors) do
    -- Create a pattern to match the annotation and everything until the next annotation
    local pattern = annote .. "(.-)@" -- Match the annotation and capture everything until the next '@'
    
    -- Replace the matched pattern with the colorized text
    final_message = final_message:gsub(pattern, function(text)
      return minetest.colorize(color, text) -- Colorize the captured text
    end)
  end
  
  
  if ch.last_message[player] and final_message == ch.last_message[player] then
    return
  end
  
  ch.last_message[player] = final_message
  -- Send the final colored message to the player
  minetest.chat_send_player(player, final_message) -- Replace "player_name" with the actual player's name
end

-- Example usage
