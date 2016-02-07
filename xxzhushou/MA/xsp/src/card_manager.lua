local api = require("api")
local utils = require("utils")
local findImageTap = api.findImageInRegionFuzzyTap
local findImageTapN = api.findImageInRegionFuzzyTapN
local checkImage = api.checkImageInRegionFuzzy
local touchPos = api.touchPos
local info = api.info
local err = api.error
local process = utils.process
local flip = utils.waitingFlip
local connection = utils.waitingConnection

local module = {}

local function checkCardSellButtonAndTap()
   local ret = false;
   ret = findImageTap("card_sell_1.png", 60, 458, 1646, 787, 1986, 0);
   connection(checkImage, "card_onclick.png", 60, 600, 1800, 900, 2000, 0);
   return ret;
end

local function checkCardButtonAndTap()
   local ret = false
   ret = findImageTap("card_button.png", 60, 30, 1100, 180, 1300, 0);
   flip(checkImage, "card_sell_1.png", 60, 458, 1646, 787, 1986, 0);
   return ret;
end

local function checkOneClickButtonAndTap()
   local ret = false;
   ret = findImageTap("card_onclick.png", 60, 600, 1800, 900, 2000, 0);
   flip(checkImage, "card_sell_onclick.png", 60, 237, 851, 362, 1189, 0);
   return ret;
end

local function checkCheckBoxAndTap()
   local ret = true;
   findImageTapN("card_checkbox.png", 70, 434, 251, 994, 422, 90, 112, 0);
   findImageTapN("card_checkbox.png", 70, 428, 792, 607, 958, 90, 112, 0);
   findImageTapN("card_checkbox.png", 70, 612, 1320, 982, 1490, 90, 112, 0);

   return ret;
end

local function checkSellButtonAndTap()
   local ret = false;
   ret = findImageTap("card_sell_onclick.png", 60, 237, 851, 362, 1189, 0);
   if ret == true then
      flip(checkImage, "card_confirm_sell.png", 60, 485, 610, 585, 911, 0);
      if checkImage("card_confirm_sell.png", 60, 485, 610, 585, 911, 0) == true then
         ret = findImageTap("card_confirm_sell.png", 60, 485, 610, 585, 911, 0);
      else
         ret = utils.findAndClickXButton(1089, 1720, 1249, 1882);
      end
   end
   return ret;
end

local function gotoHome()
   local ret = false;
   api.mSleep(1000);
   if checkImage("rewards_task.png", 60, 689, 1355, 867, 1529, 0) == false then
      connection(checkImage, "go_home.png", 60, 0, 1769, 121, 2004, 0);
   end

   ret = findImageTap("go_home.png", 60, 0, 1769, 121, 2004, 0);
   if ret == true then
      connection(checkImage, "rewards_task.png", 60, 689, 1355, 867, 1529, 0);
      return true;
   end
   return ret;
end

function module.sellCards()
   local funclist = {
      checkCardButtonAndTap,
      checkCardSellButtonAndTap,
      checkOneClickButtonAndTap,
      checkCheckBoxAndTap,
      checkSellButtonAndTap,
      gotoHome,
   };
   return process("sellCards", funclist);
end

return module
