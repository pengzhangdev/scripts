appName = "com.netease.glxbwysw"

local utils = require("utils");
local api = require("api");
local checkImage = api.checkImageInRegionFuzzy
local tapImage = api.findImageInRegionFuzzyTap
local info = api.info;
local err = api.err;
local touch = api.touchPos
local connection = utils.waitingConnection

local function gotoHome()
   local ret = false;
   if checkImage("rewards_task.png", 60, 689, 1355, 867, 1529, 0) == false then
      connection(checkImage, "go_home.png", 60, 0, 1769, 121, 2004, 0);
   end

   ret = tapImage("go_home.png", 60, 0, 1769, 121, 2004, 0);
   if ret == true then
      connection(checkImage, "rewards_task.png", 60, 689, 1355, 867, 1529, 0);
      return true;
   end
   return ret;
end

function checkAndSkipStartScreen()
   local ret = true
   while ret == true do
      api.mSleep(1000);
      ret = checkImage("start_splash.png", 60, 489, 713, 996, 1788, 0);
   end

   local ret = checkImage("start_screen.png", 60, 34, 52, 168, 352, 0);
   if ret ~= true then
      return ret;
   end

   touch(457, 984);
   api.mSleep(1000);
   touch(457, 984);
   ret = connection(checkImage, "rewards_task.png", 60, 689, 1355, 867, 1529, 0);
   if ret == true then
      return ret;
   end
   ret = connection(checkImage, "rewards_friends.png", 60, 787, 828, 1081, 1215, 0);
   if ret == true then
      return ret;
   end
   ret = connection(checkImage, "bind_phone_num.png", 60, 1102, 863, 1190, 1177, 0);
   if ret == true then
      return ret;
   end

   ret = connection(checkImage, "rewards_task.png", 60, 689, 1355, 867, 1529, 0);
   if ret == true then
      return ret;
   end
   ret = connection(checkImage, "rewards_friends.png", 60, 787, 828, 1081, 1215, 0);
   if ret == true then
      return ret;
   end
   ret = connection(checkImage, "bind_phone_num.png", 60, 1102, 863, 1190, 1177, 0);
   if ret == true then
      return ret;
   end

   return ret;
end

function checkAndExit()
   local ret = false
   ret = checkImage("ma_maintaining.png", 60, 990, 875, 1078, 1168, 0);
   if ret == true then
      closeApp(appName);
      lua_exit();
   end

   ret = checkImage("card_full_alert.png", 60, 973, 661, 1075, 1390, 0);
   if ret == true then
      info("Card Full Alert");
      closeApp(appName);
      lua_exit();
   end
end

function recvTaskRewards()
   local ret = tapImage("rewards_task.png", 60, 689, 1355, 867, 1529, 0);
   connection(checkImage, "rewards_recv_all.png", 60, 1079, 1755, 1338, 2005, 0);
   if ret == true then
      if checkImage("rewards_recv_all.png", 60, 1079, 1755, 1338, 2005, 0) then
         tapImage("rewards_recv_all.png", 60, 1079, 1755, 1338, 2005, 0);
         api.mSleep(2000);
      end
      gotoHome();
      ret = tapImage("rewards_mail.png", 60, 671, 1837, 862, 2019, 0);
      connection(checkImage, "rewards_recv.png", 60, 928, 1403, 1042, 1594, 0);
      if checkImage("rewards_recv1.png", 60, 677, 1397, 794, 1610, 0) then
         tapImage("rewards_recv_all.png", 60, 1079, 1755, 1338, 2005, 0);
         api.mSleep(2000);
      end
      gotoHome();
   end
end

function checkAndRecvRewards()
   local ret = false;
   local retry = 1;
   while retry > 0 do
      -- ret = checkImage("notification_upgrade.png", 60, 1174, 934, 1261, 1115, 0);
      -- if  ret == true then
      --    utils.findAndClickXButton(1127, 1735, 1327, 1928);
      -- end

      ret = checkImage("bind_phone_num.png", 60, 1102, 863, 1190, 1177, 0);
      if ret == true then
         utils.findAndClickXButton(1059, 1507, 1283, 1735);
         api.mSleep(500);
         retry = 2;
      end

      ret = checkImage("rewards_daily.png", 60, 336, 800, 451, 1118, 0);
      if ret == true then
         touch(180, 1006);
         api.mSleep(500);
         retry = 2;
      end

      ret = checkImage("rewards_friends.png", 60, 787, 828, 1081, 1215, 0);
      if ret == true then
         utils.findAndClickOkButton(457, 881, 601, 1146);
         api.mSleep(500);
         retry = 2;
      end

      retry = retry - 1;
   end
end

function catchException()
   local ret = false;
   retry = 3
   while retry > 0 do
      ret = tapImage("go_home.png", 60, 0, 1769, 121, 2004, 0);
      if ret == true then
         connection(checkImage, "rewards_task.png", 60, 689, 1355, 867, 1529, 0);
         return true;
      end

      ret = tapImage("global_menu.png", 60, 1432, 1824, 1515, 1987, 0);
      if ret == true then
         api.mSleep(500);
         tapImage("home_button.png", 60, 18, 202, 171, 408, 0);
         connection(checkImage, "home_button.png", 60, 18, 202, 171, 408,0);
         return true;
      end

      ret = utils.findAndClickBackButton()
      if ret == true then
         retry = 2;
      end

      checkAndRecvRewards();

      local x, y = api.findColors(0xffffff,"-3|74|0xffffff,-30|152|0xffffff,7|140|0xffffff,-12|186|0xffffff,20|182|0xffffff,5|238|0xffffff,-16|261|0xffffff,11|287|0xffffff,-7|329|0xffffff", 95, 1476, 1721, 1490, 1947)
      if x ~= -1 then
         info("room not found");
         touch(756, 1045);
         connection();
         return true;
      end

      x, y = api.findColors(0xffffff,"-13|89|0xffffff,-35|90|0xffffff,3|128|0xffffff,-26|171|0xffffff,-18|195|0xffffff,-24|235|0xffffff,-3|282|0xffffff,-13|322|0xffffff,-6|416|0xffffff", 95, 0, 0, 1535, 2047)
      if x ~= -1 then
         info("room broken");
         touch(767, 1005);
         connection();
         return true;
      end

      x, y = findMultiColorInRegionFuzzy(0xffffff,"19|0|0xffffff,21|7|0xffffff,11|15|0xffffff,0|14|0xffffff,-18|15|0xffffff,15|44|0xffffff,-2|28|0xffffff,-25|44|0xffffff,17|25|0xffffff", 95, 0, 0, 1535, 2047)
      if x > -1 then
         info("Time out sending request");
         touch(767, 1005);
         connection();
         return true;
      end

      connection();
      retry = retry - 1;
   end
end

function main()
   local ret = false;
   api.runApp(appName);
   api.mSleep(1000);
   init("0", 0);

   local retry = 3;
   local last_rewards = 0;
   -- HOME : 4
   -- SELLCARDS : 3
   -- DUNGEON_START : 2
   -- DUNGEON_EXIT : 1
   local STAGE = 4;
   local dungeonManager = require("dungeon");
   local dungeon_room = require("dungeon_room");
   local dungeon = dungeonManager.dungeon();
   dungeon:switchCertainRoomSearch(true);
   dungeon:setBattleRoomFunc(dungeon_room.froom);
   dungeon:setCertainRoomSearchList(dungeon_room.fcertain_room());
   while retry > 0 do
      if ret == false then
         info("Not Start Screen, skip");
      end
      info("STAGE = %d", STAGE);

      checkAndSkipStartScreen();
      checkAndExit();

      if STAGE >= 4 then
         gotoHome();
         checkAndRecvRewards();
         api.mSleep(1000);

         local hour = os.date("%H")
         if hour == "12" or hour == "13" or hour == "18" or hour == "19" then
            if hour - last_rewards > 2 then
               recvTaskRewards();
               last_rewards = hour;
            end
         end

         if last_rewards == 0 then
            recvTaskRewards();
            last_rewards = 1;
         end
      end

      if STAGE >= 3 then
         local cardManager = require("card_manager");
         cardManager.sellCards();
      end

      if STAGE >= 2 then
         ret = dungeon:start();
         if  ret == true then
            retry = 3;
            ret = dungeon:exit();
            if ret == false then
               STAGE = 1;
            end
         end
      end

      if STAGE >= 1 then
         if STAGE == 1 then
            ret = dungeon:exit();
            ret = true;
         end

         if ret == true then
            ret = gotoHome();
            STAGE = 4;
         end
      end
      if ret == false then
         catchException();
         retry = retry - 1;
      end
   end

   local width, height = getScreenSize();
   snapshot("errors_" .. os.date("%Y-%m-%d") .. ".png", 0, 0, width - 1, height - 1);
   closeApp(appName);
end

main();
