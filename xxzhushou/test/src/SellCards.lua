SellCards = {}

local cardboxButton = "cardbox.png"
local sellButton = "sell.png"
local onclickButton = "sell_onclick.png"
local selectCardsCombo = "sell_select.png"
local sellClickButton = "sell_click_button.png"
local confirmSellButton = "sell_confirm.png"

function SellCards.sell()
   local x, y = findImageInRegionFuzzy(cardboxButton, 80, , , , , 0);
   if x == -1 or y == -1 then
      return false
   end
end
