local api = require("api");
local findImageTap = api.findImageRegionFuzzyTap;
local touchPos = api.touchPos;
local findImage = api.findImageRegionFuzzy;
local info = api.info;
local err = api.error;

local module = {};
local dungeon = {
   certain_room_search = false,
   screen_width = 0,
   screen_height = 0,
};

dungeon.__index = dungeon;

function module.dungeon()
   return dungeon:new();
end

function dungeon:new()
   local self = {};
   setmetatable(self, dungeon);
   return self;
end

function dungeon:switchCertainRoomSearch(enable)
   self.certain_room_search = enable;
end

function dungeon:addToCertainRoomSearchList(funclist)
   
end

local function checkAndTapDungeonButton()
   return findImageTap("dungeon_button.png", 60, 0, 0, width - 1, height - 1, 0);
end

local function checkAndTapQuickDungeonButton()
   return findImageTap("dungeon_quick_button.png", 60, 0, 0, width - 1, height - 1, 0);
end

local function confirmPlayer()
   -- check and select Player, then click button
   return findImageTap("dungeon_confirm_button.png", 60, 0, 0, width - 1, height - 1, 0);
end

local function checkAndRefreshGameRoom()
   return findImageTap("dungeon_refresh.png", 60, 0, 0, width - 1, height - 1, 0);
end

function dungeon:start()
   local res = false
   
end


