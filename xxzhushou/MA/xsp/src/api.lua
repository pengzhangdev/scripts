local module = {file = nil};

local logfile = "log.txt"
module.file = io.open(logfile)

function module.info(msg)
   sysLog("[INFO] " .. msg)
end

function module.error(msg)
   toast("[ERR] " .. msg)
end

function module.findImageInRegionFuzzy(picname, degree, x1, y1, x2, y2, alpha)
-- picname: the picture to find
-- degree: 1 - 100 
-- x1, y1:  {x1, y1} on screen to start searching
-- x2, y2: {x2, y2} on screen to end searching
-- alpha: 
   x, y = findImageInRegionFuzzy(picname, degree, x1, y1, x2, y2, alpha);
   if x == -1 and y == -1 then
		module.error("findImageInRegionFuzzy failed")
   end
   return {{x, y}};
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
   sysLog("touch @ x:" .. x .. ", y:" .. y);
   math.randomseed(x/y);
   id = math.random();
   touchDown(id, x, y);
   mSleep(80);
   touchUp(id, x, y);
   mSleep(80);
end

return module;