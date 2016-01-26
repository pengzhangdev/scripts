local api = require("api")
local utils = require("utils")
local findImageTap = api.findImageInRegionFuzzyTap
local findImageTapN = api.findImageInRegionFuzzyTapN
local touchPos = api.touchPos
local info = api.info
local err = api.error
local process = utils.process
local flip = utils.waitingFlip
local connection = utils.waitingConnection

local module = {}

function checkCardSellButtonAndTap()
   return findImageTap("card_sell_1.png", 60, 458, 1646, 787, 1986, 0);
end

function checkCardButtonAndTap()
   return findImageTap("card_button.png", 60, 30, 1100, 180, 1300, 0);
end

function checkOneClickButtonAndTap()
   return findImageTap("card_onclick.png", 60, 600, 1800, 900, 2000, 0);
end

function checkCheckBoxAndTap()
   local res = false
   local r = false
   r = findImageTapN("card_checkbox.png", 60, 0, 0, 1080, 1080, 0);
   if r == true then
      res = true
   end

   return res
end

function checkSellButtonAndTap()
   
end

function module.sellCards()
   local funclist = {
      ["checkCardButtonAndTap"] = checkCardButtonAndTap,
      ["flip"] = flip,
      ["checkCardSellButtonAndTap"] = checkCardSellButtonAndTap,
      ["connection"] = connection,
      ["checkOneClickButtonAndTap"] = checkOneClickButtonAndTap,
      ["flip"] = flip,
   };
   return process(funclist)
end

return module
