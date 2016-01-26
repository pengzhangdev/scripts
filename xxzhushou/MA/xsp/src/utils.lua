local api = require("api")

local mSleep = api.mSleep

local module = { }

function module.process(funclist)
   for i, v in pairs(funclist) do
      api.info("func %s", i);
      local result = false
      result = v()
      if result == false then
         return false
      end
   end
   return true
end

function module.waitingFlip(func, ...)
   local retry = 3
   local sleep_mtime = 200
   while retry > 0 do
      if func ~= nil then
         if func(unpack(arg)) == true then
            break
         end
      end
      mSleep(sleep_mtime)
      retry = retry - 1
   end
end

function module.waitingConnection()

end

return module
