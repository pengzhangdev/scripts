local module = {file = nil};

local logfile = "log.txt"
module.file = io.open(logfile)

function module.info(fmt, ...)
   sysLog("[INFO] " .. string.format(fmt, unpack(arg)))
end

function module.error(fmt, ...)
   sysLog("[ERR] " .. string.format(fmt, unpack(arg)))
end

function module.findImageInRegionFuzzy(picname, degree, x1, y1, x2, y2, alpha)
   -- picname: the picture to find
   -- degree: 1 - 100
   -- x1, y1:  {x1, y1} on screen to start searching
   -- x2, y2: {x2, y2} on screen to end searching
   -- alpha:
   local x, y = findImageInRegionFuzzy(picname, degree, x1, y1, x2, y2, alpha);
   if x == -1 and y == -1 then
      module.error("findImageInRegionFuzzy failed")
   end
   return {{x, y}};
end

function module.findImageInRegionFuzzyN(picname, degree, x1, y1, x2, y2, width, height, alpha)
   local ret = {}
   local x = 0
   local y = 0
   while true do
      if x == 0 and y == 0 then
         x = x1 - width
         y = y1 - height
      end
      x = x + width
      y = y + height
      x, y = module.findImageInRegionFuzzy(picname, degree, x, y, x2, y2, alpha)
      if x == -1 and y == -1 then
         break
      end
      table.insert(ret, {x, y})
   end
   return ret
end

function module.findImageInRegionFuzzyTapN(picname, degree, x1, y1, x2, y2, width, height, alpha)
   local ret = module.findImageInRegionFuzzyN(picname, degree, x1, y1, x2, y2, width, height, alpha)
   if next(ret) == nil then
      return false
   end

   for i, v in pairs(ret) do
      module.touchPos(v[1] + width / 2, v[2] + height / 2)
   end

   return true
end

function module.findImageInRegionFuzzyTap(picname, degree, x1, y1, x2, y2, alpha)
   local res = module.findImageInRegionFuzzy(picname, degree, x1, y1, x2, y2, alpha)
   for i, v in pairs(res) do
      if v[1] == -1 and v[2] == -1 then
         module.error("find " .. picname .. " failed ")
         return false
      else
         module.touchPos(v[1], v[2])
         return true
      end
   end
end

function module.touchPos(x, y)
   module.info("touch @ x:" .. x .. ", y:" .. y);
   math.randomseed(x/y);
   id = math.random();
   touchDown(id, x, y);
   module.mSleep(80);
   touchUp(id, x, y);
   module.mSleep(80);
end

function module.getScreenSize()
   return getScreenSize()
end

function module.mSleep(sec)
   mSleep(sec)
end

function module.runApp(appId)
   if appIsRunning(appName) == 0 or isFrontApp(appName) == 0 then
      module.info("start app(%s)", appId);
      runApp(appId)
   end
end

return module;
