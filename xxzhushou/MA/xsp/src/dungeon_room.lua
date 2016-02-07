local api = require("api");
local utils = require("utils");
local findImageTap = api.findImageInRegionFuzzyTap;
local touchPos = api.touchPos;
local findImage = api.findImageInRegionFuzzy;
local findImageN = api.findImageInRegionFuzzyN;
local checkImage = api.checkImageInRegionFuzzy;
local info = api.info;
local err = api.error;
local flip = utils.waitingFlip
local connection = utils.waitingConnection
local process = utils.process

local module = {}

function module.froom(x, y)
   local ret = false;
   local index = 1;

   while true do
      if index > 3 then
         break;
      end

      local room_name = string.format("dungeon_room_%d.png", index);
      ret = checkImage(room_name, 60, x, y - 10, x + 150, y + 1000, 0);
      if ret == true then
         return ret;
      end
      index = index + 1;
   end

   return false;
end

function module.fcertain_room()
   local list = {};
   return list;
end

return module;
