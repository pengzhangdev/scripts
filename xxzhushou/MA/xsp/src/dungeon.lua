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

local module = {};
local dungeon = {
   certain_room_search = false,
   screen_width = 0,
   screen_height = 0,
   lcertain_room = nil,
   froom = nil,
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

function dungeon:setCertainRoomSearchList(funclist)
   self.lcertain_room = funclist;
end

function dungeon:setBattleRoomFunc(func)
   self.froom = func;
end

local function checkAndTapDungeonButton()
   local ret = false;
   ret = findImageTap("dungeon_button.png", 60, 9, 501, 149, 688, 0);
   if ret == false then
      return false
   end
   flip(checkImage, "dungeon_quick_button.png", 60, 732, 1308, 819, 1763, 0);
   return ret;
end

local function checkAndTapQuickDungeonButton()
   local ret = false;
   ret = findImageTap("dungeon_quick_button.png", 60, 732, 1308, 819, 1763, 0);
   if ret == false then
      return false;
   end
   connection(checkImage, "dungeon_confirm_player.png", 60, 1099, 1760, 1330, 1987, 0);
   return ret;
end

local function confirmPlayer()
   -- check and select Player, then click button
   local ret = false
   local retry = 10;
   while ret == false do
      touchPos(352, 894);
      ret = checkImage("singer.png", 60, 392, 56, 610, 448, 0);
      api.mSleep(300);
      retry = retry - 1;
      if retry < 0 then
          return false;
      end
   end

   ret = false
   while ret == false do
      touchPos(638, 922);
      ret = checkImage("auto_cardbox.png", 60, 1087, 1112, 1174, 1271, 0);
      api.mSleep(300)
   end

   ret = findImageTap("dungeon_confirm_player.png", 60, 1099, 1760, 1330, 1987, 0);
   if ret == false then
      return false;
   end

   connection(checkImage, "dungeon_room_refresh.png", 60, 1068, 1794, 1296, 2012, 0);
   return true;
end

local function searchAndJoinCertainRoom(funclist)
   local x, y;
   local ret = false;

   if funclist == nil then
      return ret;
   end

   for i, v in pairs(funclist) do
      x, y = v();
      if x ~= -1 and y ~= -1 then
         local ret = true;
         break;
      end
   end
   if ret == true then
      ret = tapJoinButton(x, y)
   end

   return ret;
end

local function tapJoinButton(x, y) -- room pos
   local x1 = x - 400;
   local y1 = y + 800;
   local x2 = x;
   local y2 = y + 1400;
   if x1 < 0 then
      x1 = 1;
   end
   info("touch join room button");
   local ret = findImageTap("dungeon_join.png", 60, x1, y1, x2, y2, 0);
   connection(checkImage, "dungeon_quit_room.png", 60, 0, 1750, 124, 2039, 0);
   return ret;
end

local function searchRoomAndJoin(level, froomname)
   -- level:
   --  3 -- normal
   --  4 -- 特级
   --  5 -- 超级
   --  6 -- 超弩级
   local ret = false;
   room_name = string.format("dungeon_room_level_%d.png", level);
   info("searching room %s", room_name)
   local posN = findImageN(room_name, 50, 371, 366, 1277, 500, 100, 100, 0);
   if next(posN) == nil then
      return false;
   end
   for i, v in pairs(posN) do
      local x = v[1];
      local y = v[2];
      info("find === x %d y %d", x, y);
      if froomname ~= nil then
         ret = froomname(x, y);
      else
         ret = true;
      end
      if ret == true then
         ret = tapJoinButton(x, y);
         return ret;
      end
   end
   return false;
end

local function searchAndJoinRoom(froom, lcertain_room, enable_search)
   local enableCustomSearch = enable_search;
   local ret = false;
   local retry = 5;

   while true do
      if enableCustomSearch == true then
         ret = searchAndJoinCertainRoom(lcertain_room);
         if ret == true then
            break;
         end
      end

      -- ret = searchRoomAndJoin(5, froom);
      -- if ret == true then
      --    break;
      -- end

      -- ret = searchRoomAndJoin(4, froom);
      -- if ret == true then
      --    break;
      -- end
      if froom == nil then
         info("froom == nil");
      end
      ret = searchRoomAndJoin(3, froom);
      if ret == true then
         break;
      end

      ret = findImageTap("dungeon_room_refresh.png", 60, 1068, 1794, 1296, 2012, 0);
      if ret == false then
         retry = retry - 1;
      else
         retry = 5;
      end

      if retry < 0 then
         return false;
      end
      connection();
   end

   ret = checkImage("dungeon_room_full.png", 60, 1099, 863, 1196, 1193, 0);
   if ret == true then
      info("room full, searching");
      findImageTap("dungeon_room_confirm.png", 60, 352, 623, 467, 853, 0);
      api.mSleep(500);
      local retry = 2;
      local found = false;
      while true do
         local r = false;
         r = checkImage("dungeon_searching.png", 60, 984, 894, 1099, 1155, 0);
         if r == false then
            if found == true then
               break;
            end
            retry = retry - 1;
            if retry < 0 then
               break;
            end
         else
            found = true;
         end
         api.mSleep(500);
      end

      ret = checkImage("dungeon_no_room.png", 60, 975, 859, 1087, 1196, 0);
      if ret == true then
         info("no room found");
         findImageTap("dungeon_room_search_back.png", 60, 358, 881, 498, 1143, 0);
         connection();
      end
   end

   return ret;
end

local function waitingInRoom()
   connection(checkImage, "dungeon_quit_room.png", 60, 0, 1750, 124, 2039, 0)
   local ret = false;
   local isInRoom = false
   local retry = 10;
   local total_waiting_time = 0;
   while true do
      ret = checkImage("dungeon_quit_room.png", 60, 0, 1750, 124, 2039, 0);
      if ret == true then
         isInRoom = true;
      else
         if isInRoom == true then
            info("quit game room");
            break;
         else
            info("not in game room");
            break;
         end
      end

      api.mSleep(1000);
      total_waiting_time = total_waiting_time + 1000;
      if total_waiting_time > 300000 then
         local ret = findImageTap("dungeon_quit_room.png", 60, 0, 1750, 124, 2039, 0);
         if ret == true then
            flip(checkImage, "dungeon_confirm_player.png", 60, 461, 622, 602, 862, 0);
            findImageTap("dungeon_confirm_player.png", 60, 461, 622, 602, 862, 0);
            return false;
         end
      end
   end

   ret = connection(checkImage, "dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
   ret = connection(checkImage, "dungeon_in_battle_flag2.png", 60, 1429, 1839, 1514, 2003, 0);
   connection(checkImage, "dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
   connection(checkImage, "dungeon_in_battle_flag2.png", 60, 1429, 1839, 1514, 2003, 0);
   ret = connection(checkImage, "dungeon_in_battle_flag3.png", 60, 0, 1902, 92, 2043, 0);
   if ret == true then
      ret = false
      while ret == false do
         if checkImage("dungeon_in_battle_flag3.png", 60, 0, 1902, 92, 2043, 0) == false then
            break;
         end
         ret = connection(checkImage, "dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
      end
   end

   ret = checkImage("dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
   if ret == true then
      info("In battle, exiting game room");
      return true;
   end

   local x, y = api.findColors(0xffffff,"-3|74|0xffffff,-30|152|0xffffff,7|140|0xffffff,-12|186|0xffffff,20|182|0xffffff,5|238|0xffffff,-16|261|0xffffff,11|287|0xffffff,-7|329|0xffffff", 95, 1476, 1721, 1490, 1947)
   if x ~= -1 then
      info("room not found");
      touchPos(756, 1045);
      return false;
   end

   local x, y = api.findColors(0xffffff,"25|2|0xffffff,25|27|0xffffff,27|49|0xffffff,31|50|0xffffff,12|27|0xffffff,4|23|0xffffff,-3|19|0xffffff,-8|47|0xffffff,40|24|0xffffff", 95, 0, 0, 1535, 2047)
   if x ~= -1 then
      info("room broken");
      touchPos(767, 1005);
      return false;
   end

   return isInRoom;
end

local function isInBattle()
   connection(checkImage, "dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
   local r1, r2;
   r1 = checkImage("dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
   r2 = checkImage("dungeon_quit_room.png", 60, 0, 1750, 124, 2039, 0);
   if r1 == true and r2 == false then
      info("In battle")
      return true;
   end
   info("Not in battle");
   return false;
end

local function startAI()
   while true do
      local ret = checkImage("battle_internal_ai_enabled.png", 60, 79, 1828, 174, 2011, 0);
      if ret == true then
         info("internal AI is already enabled");
         break;
      end
      ret = findImageTap("battle_internal_ai_disabled.png", 60, 79, 1828, 174, 2011, 0);
      if ret == true then
         info("enable internal AI");
         break;
      end
   end

   return ret;
end

local function waitingBattleOver()
   local ret = false;
   local retry = 5
   connection(checkImage, "dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
   while retry > 0 do
      ret = checkImage("dungeon_in_battle_flag1.png", 60, 665, 1984, 749, 2044, 0);
      if ret ~= true then
         ret = checkImage("dungeon_in_battle_flag2.png", 60, 1429, 1839, 1514, 2003, 0);
      end

      if ret == true then
         break;
      end
      retry = retry - 1;
      api.mSleep(500);
   end

   if ret == false then
      err("Not in battle!! return !!");
      return false;
   end

   if ret == true then
      info("start AI");
      startAI();
   end

   ret = false
   info("Waiting Game Over");
   api.mSleep(120000);
   local total_wait_time = 120000;
   local retry = 3;
   while ret == false do
      -- if total_wait_time > 1200000 then
      --    err("Time out waiting battle over!!!!");
      --    return false;
      -- end
      ret = checkImage("dungeon_share_button.png", 60, 1317, 1760, 1426, 2039, 0);
      if ret == false then
         ret = checkImage("dungeon_get_bonus.png", 60, 271, 869, 386, 1162, 0);
      end
      if ret == true then
         break;
      end
      api.mSleep(1500);
      total_wait_time = total_wait_time + 1500;
      if isInBattle() == false then
         retry = retry - 1;
      else
         retry = 3;
      end
      if retry <= 0 then
         return false;
      end
   end
   return true;
end

local function exitBattle()
   local retry = 2;
   local ret = false;
   while retry > 0 do
      ret = checkImage("dungeon_share_button.png", 60, 1317, 1760, 1426, 2039, 0);
      if ret == true then
         info("tap share button");
         touchPos(59, 1617);
         retry = 2;
      end

      ret = utils.findAndClickXButton(1079, 1847, 1267, 2033);
      if ret == true then
         info("tap x button");
         retry = 2;
      end
      api.mSleep(500);
      retry = retry - 1;

      ret = findImageTap("dungeon_get_bonus.png", 60, 271, 869, 386, 1162, 0);
      if ret == true then
         info("get bonus");
         retry = 2;
      end
   end
end

function dungeon:start()
   local ret = false
   local funclist = {
      checkAndTapDungeonButton,
      checkAndTapQuickDungeonButton,
      confirmPlayer,
   }
   local ret = process("dungeon start", funclist);
   if ret == true then
      ret = searchAndJoinRoom(self.froom, self.lcertain_room, self.certain_room_search);
   end

   ret = waitingInRoom()

   return ret;
end

function dungeon:exit()
   local ret = false
   ret = waitingBattleOver();
   exitBattle();

   return ret;
end

return module
