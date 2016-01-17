local module = { }

function module.process(funclist)
   for i, v in pairs(funclist)
   local result = false
   result = v()
   if result ~= true then
      return false
   end
end
return true
end

function module.waitingFlip()
   mSleep(200)
end

function module.waitingConnection()

end

return module
