local api = require("api.lua")
local findImage = api.findImageInRegionFuzzy
local touchPos = api.touchPos
local info = api.info
local err = api.error

local module = {}

function module.findCardButton()
   local res = findImage("card_button.png", 90, 37, 1113, 163, 1234, 0)
   for i, v in pairs(res) do
      if v[1] == -1 and v[2] == -1 then
         err("Failed to find card button")
         return false
      else
         touchPos(v[1], v[2])
         return true
      end
   end

   return false
end

return module
