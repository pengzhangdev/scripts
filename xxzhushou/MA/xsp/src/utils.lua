local api = require("api")

local mSleep = api.mSleep

local module = { }

function module.process(name, funclist)
   local wait = nil;
   for i, v in pairs(funclist) do
      api.info("%s : func %s", name, i);
      local result = false;
      if i == "waiting" then
         wait = v;
      else
         if wait ~= nil then
            result = wait(v);
            wait = nil;
         else
            result = v();
         end
         if result == false then
            return false;
         end
      end
   end
   return true;
end

function module.waitingFlip(func, ...)
   local retry = 5
   local sleep_mtime = 200
   while retry > 0 do
      if func ~= nil then
         if func(unpack(arg)) == true then
            return true
         end
      end
      mSleep(sleep_mtime)
      retry = retry - 1
   end
end

function module.waitingConnection(func, ...)
   local retry = 8
   local sleep_mtime = 200
   while retry > 0 do
      if func ~= nil then
         if func(unpack(arg)) == true then
            return true;
         end
      end
      if api.checkImageInRegionFuzzy("waiting_loading.png", 50, 0, 1280, 121, 1972, 0) then
         retry = 8
      end

      local x, y = api.findColors(0xfffaee,"1|-55|0xf7f7e9,12|57|0xffffff,11|115|0xffffff,-1|225|0xffffee,11|299|0xffffff,11|352|0xffffff,3|410|0xfefefe,2|440|0xfffffb,1|198|0xfffff1", 95, 1476, 1721, 1490, 1947)
      if x > -1 then
         retry = 8;
      end

      retry = retry - 1;
      api.mSleep(sleep_mtime);
   end
   return false;
end

function module.findAndClickXButton(x1, y1, x2, y2)
   local ret = false;
   ret = api.findImageInRegionFuzzyTap("button_x.png", 50, x1, y1, x2, y2, 0);
   return ret;
end

function module.findAndClickOkButton(x1, y1, x2, y2)
   local ret = false;
   ret = api.findImageInRegionFuzzyTap("button_ok.png", 50, x1, y1, x2, y2, 0);
   return ret;
end

function module.findAndClickBackButton()
   local ret = false;
   ret = api.findImageInRegionFuzzyTap("button_back.png", 50, 3, 1788, 109, 2009, 0);
   return ret;
end

return module
