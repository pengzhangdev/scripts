local api = require("api")
local findImageTap = api.findImageInRegionFuzzyTap
local touchPos = api.touchPos
local info = api.info
local err = api.error

local module = {}

function module.findCardButton()
   --local res = findImage("card_button.png", 90, 30, 1100, 180, 1300, 0)
   width,height = getScreenSize()
   --keepScreen(true); 
   local res = findImageTap("card_button.png", 60, 30, 1100, 180, 1300, 0)
   res = findImageTap("card_sell_1.png", 60, 0, 0, width - 1, height - 1, 0)
   --local res = findImage("card_button.png", 60, 0, 0, width - 1, height - 1, 0)
   --snapshot("1.png", 35, 1110, 165, 1250); --全屏截图（分辨率1080*1920）
   --keepScreen(false); 
   --[[
   for i, v in pairs(res) do
      if v[1] == -1 and v[2] == -1 then
         err("Failed to find card button")
         return false
      else
         touchPos(v[1], v[2])
         return true
      end
   end
   ]]
   
   return res
end

return module
