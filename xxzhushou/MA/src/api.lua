local module = {file = nil};

local logfile = "log.txt"
module.file = io.open(logfile)

function module.findImageInRegionFuzzy(picname, degree, x1, y1, x2, y2, alpha)
-- picname: the picture to find
-- degree: 1 - 100 
-- x1, y1:  {x1, y1} on screen to start searching
-- x2, y2: {x2, y2} on screen to end searching
-- alpha: 
   x, y = findImageInRegionFuzzy(picname, degree, x1, y1, x2, y2, alpha);
   return {{x, y}};
end

function module.touchPos(x, y)
   sysLog("touch @ x:" .. x .. ", y:" .. y);
   math.randomseed(x/y);
   id = math.random();
   touchDown(id, x, y);
   msleep(80);
   touchUp(id, x, y);
   msleep(80);
end

function module.info(msg)
   module.file:write("[INFO] " .. msg)
end

function module.error(msg)
   module.file:write("[ERR] " .. msg)
end

return module;
