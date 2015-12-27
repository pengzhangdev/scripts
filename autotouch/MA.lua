CREATETIME="2015-12-10 10:58:09";

adaptResolution(1536, 2048);
adaptOrientation(ORIENTATION_TYPE.LANDSCAPE_LEFT);

function touchPos(x, y) 
  log("touch @ x:" .. x .. ", y:" .. y)
  math.randomseed(x/y);
  id = math.random();
  touchDown(id, x, y);
  usleep(59973.29);
  touchUp(id, x, y);
  usleep(59973.29);
end

function touchPairs(result)
  for i, v in pairs(result) do
    touchPos(v[1], v[2])
  end
end

function keyPress(keyType)
    keyDown(keyType);
    usleep(10000);
    keyUp(keyType);
end

function waitingConnection()
  usleep(1549973.29)
  local retry = 5
  while true
  do
  	local waiting = 0
    --[[find connecting flag on screen left top]]
  	local result = findColors({{0,0,0}, {0,11,77}, {0,-15,133}, {0,-67,157}, {789517,-163,140}, {921102,-173,36}, {0,-96,165}, {0,-30,156}}, 0, {45, 5, 202, 191});
  	if next(result) ~= nil then
       log("[INFO] waiing screen left top")
       waiting = 1
       retry = 5
    end
  
    --[[  find connecting flag on screen right buttom  ]]
  	local result = findColors({{16777215,0,0}, {16777215,0,9}, {16777215,-31,1}, {16777215,-32,8}, {16777215,-14,98}, {16777215,-10,109}, {0,-17,90}, {16250871,-18,169}, {16777215,-17,180}, {0,-17,215}, {16777215,-19,233}, {16777215,-20,255}, {16777215,-19,267}, {0,-18,302}, {16777215,-19,309}, {16777215,-18,318}, {17,-18,328}, {16777215,-18,381}, {16777215,-17,390}, {16777215,-18,406}, {16777215,-17,413}, {16711422,-17,429}, {16777215,-15,462}, {16777215,-14,502}, {16777215,-13,511}, {16514043,-16,526}, {16777215,-16,533}}, 0, {9, 1313, 112, 689});
  	if next(result) ~= nil then
      	log("[INFO] waiing screen right buttom")
    	waiting = 1
        retry = 5
    end
  
    --[[  find connecting flag on screen left bottom  ]]
    local result = findColors({{16777215,0,0}, {16579836,-5,0}, {16777215,0,-38}, {16711422,-5,-38}, {16711422,-3,-45}, {16777215,-7,-41}, {16777215,0,-40}, {16777215,-7,-47}, {16777215,-9,-43}, {16053484,-26,-47}, {16711164,-26,0}, {16579836,-26,-35}, {16579836,-5,-12}, {16777215,0,-12}, {16777215,0,-24}, {16579836,-5,-25}, {16777215,0,-32}, {16579836,-5,-33}}, 0, {1464, 1478, 40, 112});
  	if next(result) ~= nil then
      	log("[INFO] waiing screen left bottom")
    	waiting = 1
        retry = 5
    end
  
  	if waiting == 0 then
    	if retry > 0 then
      		retry = retry - 1
      	else
      		break
        end
    end
    usleep(549973.29)
  end
end

function waitingFlip()
  usleep(259973.29)
end
  
function quickGame()
  log("quickGame")
  --[[ click game button ]]
  local result = findColors({{16645527,0,0}, {14210427,4,-2}, {16645527,-10,0}, {16777113,-10,3}, {16777113,-1,2}, {16711320,-1,3}, {16777113,-6,1}, {16645527,-10,16}, {16777113,-10,18}, {16777112,-1,18}, {16777113,-1,16}, {16777113,-6,17}, {16777132,-12,28}, {16777132,-12,30}, {15987344,-1,27}, {16777113,-2,30}, {16448186,-13,36}, {16777151,-13,39}, {16448149,6,36}, {16777113,6,39}, {16777113,-5,38}, {16777113,0,38}, {16777122,-11,71}, {16711320,-6,72}, {16777113,-7,76}, {16777132,-12,79}, {16777132,-12,81}, {16777113,5,80}, {16777113,7,78}, {16777113,-2,78}, {16777113,-5,80}, {16777113,-2,96}, {16777113,-2,97}}, 0, {30, 483, 98, 193});
  touchPairs(result)
  waitingFlip()
  
  --[[ click quick game button ]]
  local result = findColors({{16448233,0,0}, {16711678,15,20}, {16447733,7,27}, {15526627,-20,52}, {16777215,5,67}, {16250869,2,85}, {16776179,-15,80}, {15461347,-10,114}, {16777215,4,128}, {16579571,1,141}, {16775925,2,162}, {16381933,1,200}, {16579823,-23,214}, {16514040,-21,256}, {16382450,7,252}, {16711413,4,288}, {15724510,-21,285}, {16645629,-20,315}, {16645617,12,312}, {16580601,4,334}, {16382450,-20,371}}, 0, {724, 1248, 138, 744});
  if next(result) == nil then
    return nil
  else
    touchPairs(result)
    waitingFlip()
    waitingConnection()
    return true
  end
  waitingFlip()
end

function gotoHome()
  log("gotoHome")
  local result = findColors({{16645629,0,0}, {16777215,0,7}, {16579836,-15,0}, {16777215,-15,7}, {16514043,-33,0}, {16777215,-33,7}, {16711422,11,0}, {16777215,8,7}, {16777215,5,3}, {16448507,-14,19}, {16448507,-14,25}, {16777215,-11,20}, {16579833,-33,21}, {16777215,-33,27}, {16514300,-30,23}, {16777215,1,20}, {16711418,1,26}, {16777215,4,23}, {16777215,2,46}, {16777215,0,50}, {16448250,-25,46}, {16777215,-24,50}, {16514299,-32,49}, {16777215,-5,58}, {16777215,-5,64}, {16777215,2,73}, {16777215,0,79}, {16777215,-23,73}, {16316665,-23,78}, {16777215,-34,77}, {16777215,-31,79}, {16777215,-28,72}, {16777215,10,80}, {16579836,10,82}, {16777215,1,57}, {16382714,8,62}}, 0, {34, 1760, 100, 250});
  if next(result) ~= nil then
  	touchPairs(result)
    waitingFlip()
  	waitingConnection()
    return true
  end

  local result = findColors({{16777215,0,0}, {16777215,28,1}, {16777215,28,4}, {16777215,1,5}, {16777215,38,4}, {15988213,42,-2}, {16514043,8,44}, {16777215,8,48}, {16777215,31,45}, {16777215,24,48}, {16777215,10,72}, {16777215,9,75}, {16777215,30,74}, {16777215,25,76}, {16777215,22,61}, {16183800,0,50}, {16777215,-3,75}, {16777215,3,70}, {16777215,34,57}, {16777215,38,59}}, 0, {34, 1760, 100, 250});
  if next(result) ~= nil then
  	touchPairs(result)
    waitingFlip()
  	waitingConnection()
    return true
  end
  
  local result = findColors({{16777215,0,0}, {16777215,31,0}, {16777215,30,5}, {16777215,1,5}, {16777215,38,4}, {16316921,42,-1}, {16777215,34,22}, {16777215,19,20}, {16777215,-1,22}, {16777215,9,45}, {16777215,32,45}, {16777215,32,73}, {16711422,9,76}, {16777215,-2,75}, {16777215,2,51}, {16777215,26,60}, {16777215,14,59}, {16777215,34,57}, {16448250,40,60}}, 0, {34, 1760, 100, 250});
  if next(result) ~= nil then
  	touchPairs(result)
    waitingFlip()
  	waitingConnection()
    return true
  end
end

function confirmPlayer()
  waitingConnection()
  local result = findColors({{16777211,0,0}, {16777201,8,14}, {16645115,-22,25}, {16776958,-21,25}, {16777215,-8,23}, {16777215,-8,24}, {16316116,39,61}, {16709338,12,53}, {16777215,-51,-36}, {16773085,-66,-36}, {16777207,-51,-28}, {16777205,-49,-24}, {16645115,-49,-17}, {16579579,-45,-22}, {16777215,-46,-23}, {16777213,-49,-25}, {16776170,-60,-32}, {16707034,-69,-25}, {16180427,-69,-19}, {16379596,-72,-25}, {15387014,-103,-25}, {15653012,-101,-20}, {16772829,-64,-16}, {16777215,-44,-9}, {16777198,-55,-12}, {16777215,-44,0}, {16777213,-51,-2}, {16777207,-51,-1}, {16777202,-51,5}, {16114130,-63,86}, {16574936,-69,74}, {16777198,-53,67}, {16776444,-44,63}, {16777213,-51,94}, {16775405,-58,102}, {16772829,-67,92}, {16641756,-67,84}, {16117452,-72,65}, {15390100,-100,101}, {15653526,-100,98}, {15256709,-106,39}, {16248507,-78,46}, {16641210,-78,54}}, 0, {1091, 1751, 228, 242});
  if next(result) == nil then
    log("[CRITICAL] No player page found")
    return false
  else
    touchPairs(result)
    waitingFlip()
    waitingConnection()
    return true
  end
end

function isInRoom()
  local result = findColors({{16777215,0,0}, {16777215,-5,2}, {16777215,-13,1}, {16579836,-13,3}, {16776958,-38,-2}, {16777215,-32,4}, {16777215,-36,9}, {16777215,-36,31}, {16777215,-26,15}, {16645885,1,12}, {16711422,1,26}, {16382457,-19,31}, {16777215,-30,30}, {16777215,-22,25}, {16777215,-2,40}, {16777215,-40,39}, {16777215,-37,53}, {16777215,2,53}, {16777215,-2,67}, {16777215,-17,68}, {16777215,-24,67}, {16777215,-41,68}, {16777215,-4,81}, {16777215,-35,79}, {16777215,-16,97}, {16777215,-22,93}, {16777215,-35,91}, {16777215,-38,104}, {16777215,-40,107}, {16777215,-27,108}, {16777215,-3,108}, {16777215,-12,108}, {16777215,-4,120}, {16777215,-41,120}, {16316920,-31,129}, {16711422,-9,129}, {16777215,-3,129}, {16711422,2,127}, {16645629,1,148}, {16777215,-41,146}, {16777215,-36,145}}, 0, {15, 1754, 118, 291});
  --[[ findColors({{16448251,0,0}, {16777215,-5,2}, {16185078,-5,4}, {16777215,0,2}, {16777215,-13,2}, {16711422,-14,5}, {16579836,-36,-2}, {16776187,-38,0}, {16777215,-32,5}, {16777215,-32,2}, {16711422,-36,9}, {16777215,-36,32}, {16777215,-41,32}, {16777215,-30,32}, {16579836,-28,32}, {16777215,-22,26}, {16777215,-14,26}, {16777215,-14,29}, {16777215,0,26}, {16316664,2,28}, {16777215,0,29}, {16645885,-16,40}, {16777215,-16,43}, {16777215,-2,43}, {16777215,-2,40}, {16777215,-24,67}, {16777215,-24,70}, {16777215,-41,70}, {16777215,-41,67}, {16777215,2,96}, {16777215,2,99}, {15856113,-3,99}, {16774131,-3,96}, {16777215,-4,84}, {16316923,-2,81}, {16777215,-35,80}, {16777215,-32,82}, {15857137,-39,89}, {16777215,-22,96}, {16579836,-22,92}, {16645629,-32,92}, {16777215,-32,95}, {16711422,-42,105}, {16645115,-40,109}, {16777215,-28,111}, {16777215,-27,107}, {16777215,-14,107}, {16777215,-14,109}, {16777215,-2,110}, {16777215,-2,109}, {16777215,-4,107}, {16777215,-4,120}, {16777215,-4,122}, {16777215,-41,120}, {16777215,-41,122}, {16777215,-30,139}, {16777215,-30,142}, {16777215,-9,139}, {16777215,-11,142}, {16777215,-9,129}, {16448250,-10,131}, {16579836,-31,129}, {16777215,-30,131}, {16777215,-36,145}, {16777215,-41,147}, {16777215,0,151}}, 0, {15, 1754, 118, 291}); ]]
  if next(result) == nil then
    return false
  else
    return result
  end

end

function isInBattle(inGameRoom)
  if inGameRoom then
    return false
  end

  local result = findColors({{16445166,0,0}, {16777198,7,-10}, {16777198,9,-9}, {15658734,6,18}, {15856110,9,19}, {16777198,31,18}, {16777198,27,18}, {12307660,32,-10}, {13424588,23,-10}, {15658721,16,-10}, {16777198,15,17}, {16645614,24,17}}, 0, {656, 1951, 74, 91});
  if next(result) == nil then
    return false
  else
    return true
  end

end

function networkError()
  --[[  the boss is exceed time limit  ]]
  local result = findColors({{16777215,0,0}, {16777215,-8,17}, {16777215,-5,30}, {16777215,-9,44}, {16777215,-11,71}, {16777215,-11,112}, {16777215,-12,130}, {16777215,6,141}, {16382457,5,152}, {16777215,-36,169}, {1446682,-15,165}, {1905438,-18,186}, {16777215,-18,192}, {1446689,-14,199}, {16711422,-15,204}, {16777215,-14,227}, {1381402,-15,235}, {16382458,-10,262}, {16777215,-13,304}, {16777215,-31,525}, {16645629,-30,843}, {15921907,-3,821}, {16777215,-6,789}, {16777215,-12,774}, {16777215,-37,786}, {16053236,-37,819}, {2233373,-29,813}, {1446682,3,813}}, 0, {693, 533, 146, 932});
  if next(result) ~= nil then
    log("[INFO] exceed time limit")
    touchPair(result)
    waitingFlip()
    waitingConnection()
    return false
  end
end

function findRoomLevel5()
  
end

function findRoomLevel4()
  local rect = {355, 379, 900, 114}
  local result
  --[[ 特级 ]]
  result = findColors({{16777215,0,0}, {16777215,-15,-2}, {16777215,-6,0}, {16777215,-6,6}, {16777215,2,6}, {16777215,-35,6}, {16777215,-20,6}, {16777215,-24,-1}, {16777215,-18,9}, {16777215,-6,10}, {16777215,-3,14}, {16777215,-3,35}, {16777215,2,24}, {16777215,-11,25}, {16711422,-10,36}, {16711422,-10,31}, {16777215,-32,31}, {16777215,-35,26}, {16777215,-35,23}, {16777214,-24,16}, {16777215,-28,19}, {16777215,-18,13}, {16777215,-18,37}, {16777215,-19,31}, {16777215,-18,20}}, 0, rect);
  if next(result) ~= nil then
    log("[INFO] Found level 4 room")
    return result
  end
  result = findColors({{16777215,0,0}, {16777215,-14,-2}, {16777215,-6,0}, {16777215,-5,7}, {16777215,3,6}, {16777215,-20,6}, {16777215,-35,6}, {16777215,-23,-1}, {16777215,-18,31}, {16777215,-18,14}, {16777215,-24,16}, {16777215,-34,19}, {16777215,-35,29}, {16777215,-27,31}, {16777215,-18,36}, {16777215,-10,24}, {16777215,-10,36}, {16777215,-2,24}, {16777215,-2,34}, {16777215,-2,14}, {16777215,3,24}, {16777215,-10,14}}, 0, rect);
  if next(result) ~= nil then
    log("[INFO] Found level 4 room")
    return result
  end
  result = findColors({{16777215,0,0}, {16777215,-13,-2}, {16777215,-6,0}, {16777215,-6,6}, {16777215,2,6}, {16777215,-20,6}, {16777215,-35,6}, {16777215,-24,-1}, {16777215,-18,13}, {16777215,-18,31}, {16777215,-33,31}, {16777215,-35,23}, {16777215,-11,31}, {16777215,-10,24}, {16777215,-10,13}, {16777215,-10,36}, {16777215,-18,35}, {16777215,-18,19}, {16711422,-26,17}, {16777215,-3,24}, {16777215,-2,15}, {16777215,-3,33}, {16777215,2,24}}, 0, rect);
  if next(result) ~= nil then
    log("[INFO] Found level 4 room")
    return result
  end

  return result
end

function findRoomLevel3()
  local rect = {355, 379, 900, 114}
  local result
  --[[ 上级 ]]
  result = findColors({{16777215,0,0}, {16777215,-10,0}, {16777215,-18,0}, {16777215,-35,0}, {16777215,-35,-16}, {16777215,-35,21}, {3750191,-31,6}, {3555119,-16,6}, {16777215,-11,17}, {3226672,-7,6}, {3289392,2,6}, {16777215,-1,36}, {16777215,-14,29}, {16777215,-14,37}, {16777215,-23,32}, {16777215,-19,50}, {16777215,-1,46}, {16777215,-1,60}, {16777215,-12,64}, {16777215,-12,60}, {16777215,-29,58}, {16777215,-30,58}, {16777215,-28,58}}, 1, rect);
  if next(result) ~= nil then
    log("[INFO] Found level 3 room")
    return result
  end
  result = findColors({{16777215,0,0}, {16777215,-11,0}, {16777215,-35,0}, {16777215,-36,-16}, {16777215,-36,22}, {3750191,-31,7}, {3686704,-17,7}, {3226672,-7,7}, {16777215,-11,8}, {16777215,-11,17}, {16777215,0,36}, {16777215,-14,30}, {16777215,-14,37}, {16777215,-24,32}, {16777215,-1,46}, {16777215,-1,59}, {16777215,-12,60}, {16777215,-29,58}, {16711422,-36,49}, {16777215,-36,67}, {16777215,-19,50}, {3292720,-9,55}, {3817520,-19,58}}, 1, rect);
  if next(result) ~= nil then
    log("[INFO] Found level 3 room")
    return result
  end
  result = findColors({{16777215,0,0}, {16777215,-12,0}, {16777215,-36,0}, {16777215,-36,-16}, {16777215,-36,22}, {16777215,-12,3}, {16777215,-11,17}, {3815983,-31,7}, {3686704,-18,7}, {3292208,-7,7}, {16777215,-1,36}, {16777215,-15,29}, {16777215,-15,37}, {16777215,-24,32}, {16777215,-19,50}, {16777215,-2,49}, {16645629,-1,45}, {16777215,-2,60}, {16777215,-12,60}, {16777215,-14,65}, {16777215,-30,58}, {16777215,-37,49}, {16777215,-36,65}, {3227184,-9,55}, {3751984,-19,58}}, 1, rect);
  if next(result) ~= nil then
    log("[INFO] Found level 3 room")
    return result
  end

  return result
end

function findCertainRoom()
  local result
  local retry = 3

  local hour = os.date("%H")
  if hour == "10" or hour == "15" or hour == "19" or hour == "22" then
    retry = 6
  end

  while true
  do
    while true
    do
      result = findColors({{16777215,0,0}, {16777215,-17,-1}, {2839910,-2,-11}, {2381153,-18,-11}, {16777215,4,15}, {16777215,-23,14}, {16777215,-29,10}, {16777215,-34,31}, {16777215,-17,29}, {16777215,0,29}, {16777215,-34,60}, {16777215,-12,60}, {16777215,11,59}, {16777215,6,60}, {16777215,4,77}, {16777215,-23,76}, {16777215,-10,89}, {16777215,-35,90}, {16777215,8,90}, {16711679,54,71}, {12316381,76,46}, {14680052,64,11}, {16777215,38,35}, {3364214,22,18}}, 0, {1121, 1812, 163, 165});
      if next(result) ~= nil then
        log("[INFO] refresh room list")
        touchPairs(result)
        waitingFlip()
        waitingConnection()
      end

      result = findRoomLevel4()
      if next(result) ~= nil then
        return result
      end
      
      if retry > 3 then
        break
      end
      
      result = findRoomLevel3()
      if next(result) ~= nil then
        return result
      end
      break
    end
    
    if retry > 0 then
      retry = retry - 1
    else
      break
    end
  end
  
  return result
end

function joinCertainRoom(retry)
    --[[  find join button and tap  ]]
  if retry == 0 then
  	local result = findColors({{16250871,0,0}, {16777215,-3,-1}, {16645371,-7,1}, {16777215,-5,10}, {16777215,-6,11}, {16777215,-11,8}, {16711164,-21,-1}, {16645629,-2,20}, {16777215,0,12}, {16777215,4,12}, {16710908,7,20}, {16777215,-5,33}, {16777215,-15,27}, {16777215,-24,39}, {16777215,-18,42}, {16777215,-35,39}, {16777215,-40,11}, {16777215,-30,32}, {16777215,-25,29}, {16777215,-31,13}, {16776958,-22,25}, {16711165,-17,22}, {16711422,-14,18}, {16777215,-26,6}, {16777215,7,57}, {16777215,7,63}, {16711422,-37,55}, {16579579,-25,61}, {16777215,-19,57}, {16777215,-2,69}, {16776444,-4,75}, {16777215,-35,74}, {16777215,-42,66}, {16776187,-36,64}, {16777215,-31,69}, {16777215,-40,80}, {16447736,-40,85}, {16777215,0,84}, {16777215,2,80}, {16775935,3,94}, {16448250,1,92}, {16777215,0,98}, {16777215,-39,98}, {16777215,-40,92}}, 0, {1013, 1399, 125, 177});
  	if next(result) == nil then
    	log("[INFO] No game room found")
  	else
    	touchPairs(result)
        waitingFlip()
    	waitingConnection()
    	return true
  	end
  else
  	local result = findCertainRoom()
    if next(result) ~= nil then
      for i, v in pairs(result) do
        touchPos(v[1] - 161, v[2] + 1084)
        waitingFlip()
    	waitingConnection()
        break
      end
      return true
    else
      return false
    end
  end
end

function isGameRoomBroken(inGameRoom, last_inRoom)
  --[[ 
  if inGameRoom == false and last_inRoom == true then
  	touchPos(776, 1030);
    waitingFlip()
    waitingConnection()
    return true
  else
    return false
  end
  ]]
  --[[  room is broken by the owner, tap and waiting  ]]
  local result = findColors({{16777215,0,0}, {16777215,-41,-2}, {16777215,-46,5}, {16777215,-31,21}, {16777215,-34,47}, {16777215,-44,45}, {16777215,-21,28}, {16777215,3,24}, {16777215,1,48}, {16777215,-8,48}, {16777215,-8,30}, {16777215,-21,9}, {16777215,-22,48}}, 0, {733, 792, 74, 71});
  if next(result) ~= nil then
    log("[INFO] Game room is broken")
    touchPos(776, 1030);
  	waitingFlip()
	waitingConnection()
    return true
  end
  local result = findColors({{1775131,0,0}, {1775131,0,9}, {1316373,-1,26}, {1840925,0,40}, {1316376,-12,32}, {1249812,-11,-1}, {1315863,-23,0}, {1316377,-23,33}, {1315867,-45,32}, {1316121,-36,5}, {1316372,-44,0}, {1579031,-55,13}, {2691874,-42,65}, {1250071,-47,75}, {1905953,-20,74}, {1578525,-2,71}, {1447452,-16,63}, {1249812,-15,91}, {1250585,-40,92}, {1512468,-44,99}, {1972250,-18,99}, {1381910,-1,95}, {1381923,8,77}}, 0, {714, 776, 102, 208});
  if next(result) ~= nil then
    log("[INFO] Game room is broken")
    touchPos(776, 1030);
  	waitingFlip()
	waitingConnection()
    return true
  end
  local result = findColors({{1774622,0,0}, {1513750,-345,2}, {1905946,4,135}, {1775641,-351,153}, {1644834,11,288}, {1644823,-346,310}, {12759623,-366,308}, {12496711,29,291}, {1775137,-276,527}, {1644567,-52,530}, {12759620,-366,539}, {12496708,29,519}, {1250079,-276,664}, {1906470,-97,663}}, 0, {558, 227, 444, 1603});
  if next(result) ~= nil then
    log("[INFO] Game room is broken")
    touchPos(776, 1030);
  	waitingFlip()
	waitingConnection()
    return true
  end
  
  local result = findColors({{16777215,0,0}, {16777215,-25,0}, {1315349,1,22}, {16777215,6,6}, {16777215,5,48}, {16777215,11,23}, {16777215,-4,48}, {16777215,-5,0}, {16777215,-17,9}, {16777215,-18,51}, {16777215,-12,27}, {16777215,-17,29}, {1381142,-11,18}, {1512471,-11,37}}, 0, {726,784,100,100});
  if next(result) ~= nil then
    log("[INFO] Game room is broken")
    touchPairs(result)
  	waitingFlip()
	waitingConnection()
    return true
  end
  local result = findColors({{16777215,0,0}, {16777215,-2,9}, {16777215,-2,51}, {16777215,12,49}, {16777215,19,64}, {16777215,-2,68}, {16777215,-9,88}, {16777215,21,89}, {16777215,12,129}, {16777215,1,140}, {16711422,12,150}, {16777215,-1,169}, {16777215,11,197}, {16777215,10,211}, {16777215,-7,213}, {16777215,7,226}, {16777215,-7,291}, {16777215,23,304}, {16777215,22,322}, {16777215,-6,338}, {16777215,4,358}, {2170145,-3,370}, {16777215,-6,413}}, 0, {712, 773,  146, 501});
  if next(result) ~= nil then
    log("[INFO] Game room is broken")
    touchPairs(result)
  	waitingFlip()
	waitingConnection()
    return true
  end
  local result = findColors({{16777215,0,0}, {16777215,0,25}, {16777215,10,2}, {16777215,10,25}, {16777215,15,6}, {16777215,0,6}, {16777215,15,19}, {16777215,0,19}, {1315349,5,13}, {16777215,-11,3}, {16777215,-37,3}, {16777215,-9,22}, {16777215,-35,22}, {16579836,-38,15}, {16777215,-27,12}, {16448250,-17,12}, {1249812,-12,12}, {1249814,-22,13}, {16777215,15,36}, {16777215,-10,30}, {16777215,9,55}, {16777215,-22,44}, {16777215,-37,31}, {16777215,-37,56}, {1513241,1,44}, {1250079,-23,33}}, 0, {728, 969, 94, 100});
  if next(result) ~= nil then
    log("[INFO] Game room is broken")
    touchPairs(result)
  	waitingFlip()
	waitingConnection()
    return true
  end
  return false
end

function joinRoom()
  local retry = 3
  local last_inRoom = false
  local room_broken_quit = false
  while true
  do
    local wait = 0
    local inGameRoom = false
  	waitingConnection()
    
    if joinCertainRoom(retry) == true then
      retry = 3
    end
    
    --[[  if got the message No Room Found, tap and waiting to conformPlayer()  ]]
    local result = findColors({{16777215,0,0}, {16777215,1,0}, {16777215,0,44}, {16777215,1,44}, {16777215,-17,19}, {16777215,-17,23}, {16645629,-40,47}, {16777215,-40,49}, {16777215,-49,-4}, {16777215,-49,-3}, {16513787,-17,48}, {16777215,-17,-5}, {16382457,4,60}, {16777215,-2,68}, {16448251,-13,58}, {16645629,-19,66}, {16777215,-49,59}, {16316664,-29,70}, {16777215,-50,113}, {16777215,-33,104}, {16777215,-49,77}, {16777215,-20,74}, {16777215,-21,112}, {16777215,-3,77}, {16777215,-3,110}, {16777215,4,92}, {16777215,4,135}, {16777215,-8,125}, {16777215,-8,144}, {16777215,-32,124}, {16777215,-23,145}, {16777215,-48,123}, {16777215,-48,135}, {16777215,-44,147}, {16777215,-19,173}, {16777215,-36,177}, {16777215,-11,159}, {16777215,2,171}, {16777215,2,191}, {16777215,3,219}, {16316664,-32,358}, {16250871,-13,358}, {16777215,-36,370}, {16448250,-12,371}, {16382457,-32,333}, {16777215,-18,334}, {16777215,-39,321}, {16777215,-17,321}}, 0, {726, 828, 82, 403});
    if next(result) ~= nil then
      touchPairs(result)
      waitingFlip()
      waitingConnection()
      confirmPlayer()
    end
  
    --[[  got room full alert, and tap OK to search room  ]]
  	local result = findColors({{15787491,0,0}, {15985385,0,35}, {16777215,-15,37}, {16777215,-18,1}, {16579322,-9,2}, {15259861,-8,33}, {8662814,-14,32}, {9124395,-12,3}, {13607071,-26,-10}, {16777215,-26,43}, {16777215,-37,39}, {16777215,-38,18}, {16777215,-50,43}, {16777215,-49,15}, {15985384,-51,-8}, {16777215,-34,2}, {16777215,-26,18}, {8068621,-32,24}, {8134670,-44,23}}, 0, {395, 689, 95, 122});
  	if next(result) ~= nil then
    	log("[INFO] Room Full Alert")
    	touchPairs(result)
        waitingFlip()
    	waitingConnection()
    end
    
    --[[  check the in room flag  ]]
    local result = isInRoom()
    if result then
      log("[INFO] in Room")
      inGameRoom = true
      wait = wait + 1
      if wait > 20 then
        touchPairs(result)
       	waitingFlip()
        touchPos(541, 753);
        return false
      end
    end
    
    --[[  check the in battle flag  ]]
  	if isInBattle(inGameRoom) then
    	log("[INFO] in battle")
    	return true
    end
    
    if room_broken_quit then
      return false
    end
    
    if room_broken_quit == false and isGameRoomBroken(inGameRoom, last_inRoom) then
      room_broken_quit = true
    end
    
    --[[  the boss is exceed time limit  ]]
    local result = findColors({{16777215,0,0}, {16777215,0,12}, {16777215,-5,30}, {16777215,-11,61}, {16777215,-11,80}, {16777215,-11,96}, {16777215,-12,128}, {16777215,-6,142}, {16777215,-21,165}, {16777215,-23,176}, {16777215,-12,192}, {16777215,-14,217}, {16777215,-8,227}, {16777215,-4,261}, {16777215,-23,266}, {16777215,-18,287}, {16777215,-17,322}, {16777215,-12,347}, {16777215,-9,359}, {16777215,-10,378}, {16777215,-11,396}}, 0, {718, 790, 114, 459});
  	if next(result) ~= nil then
    	log("[INFO] exceed time limit")
      	touchPairs(result)
      	waitingFlip()
      	waitingConnection()
    	return false
    end
  
    --[[  searching room, just wait  ]]
    local result = findColors({{7804185,0,0}, {16777215,22,4}, {8131609,49,0}, {16777215,45,23}, {16710908,9,12}, {16777215,26,56}, {16777215,26,55}, {16777215,13,38}, {16579836,47,37}, {16579065,50,57}, {16777215,0,58}, {16183279,51,69}, {16777215,51,99}, {16777215,37,71}, {16645629,37,98}, {16777215,-2,96}, {16776958,-2,71}, {16777215,9,71}, {16777215,8,98}, {16777215,20,95}, {16777215,35,89}, {16777215,50,88}, {16777215,49,79}, {16777215,36,80}, {16777215,20,72}, {16776958,0,106}, {16777215,0,125}, {16579065,11,126}, {16777215,29,125}, {16777215,26,107}, {16777215,50,124}, {16777215,51,105}, {16777215,40,142}, {16777215,40,192}, {16777215,15,192}, {16777215,15,142}, {16777215,-6,167}, {16579322,54,167}, {16777215,41,167}, {16777215,14,167}}, 0, {992, 912, 82, 218});
  	if next(result) ~= nil then
    	log("[INFO] Searching Game room")
        wait = 1
    end
  
    --[[  search room failed, tap ok and refresh  ]]
  	local result = findColors({{10893103,0,0}, {16777215,2,6}, {16777215,2,14}, {16777215,-26,13}, {16710908,-31,5}, {16777215,-31,58}, {16777215,-20,21}, {16777215,-12,26}, {16711165,14,26}, {16777215,17,30}, {16777214,19,56}, {16777215,7,29}, {16777215,7,54}, {16777215,-14,43}, {16777215,-22,30}, {16777215,-22,58}, {16776958,19,9}, {16777215,14,14}, {16711165,18,70}, {16777215,6,82}, {16777215,-28,70}, {16777215,-16,82}, {16777215,-16,105}, {16711164,-28,117}, {16777215,18,116}, {16711165,6,106}}, 0, {395, 955, 82, 138});
  	if next(result) ~= nil then
    	log("[INFO] No room matched")
    	touchPairs(result)
    	waitingFlip()
    	waitingConnection()
    end
    if wait == 0 then
      if retry > 0 then
        log("Waiting joinRoom()")
        retry = retry - 1
      else
        return false
      end
    end
    last_inRoom = inGameRoom
    waitingConnection()
  end
end

function waitingGameOver()
  local retry = 3
  local first_time = 1
  while true
  do
    local wait = 0
    if isInBattle() then
      log("[INFO] waitingGameOver in Battle")
      
      wait = 1
      retry = 3
      if first_time == 1 then
        first_time = 0
        log("[INFO] usleep(30000000)")
        usleep(30000000)
      else
        usleep(5000000)
      end
    end
    
    --[[ get bonus ]]
    local result = findColors({{15395305,0,0}, {15461355,18,14}, {15461355,4,25}, {15461355,1,13}, {15461355,-5,16}, {15328997,-13,2}, {15461355,-14,24}, {15461098,-30,16}, {15461355,-28,6}, {15461355,-37,19}, {15461355,-27,31}, {15461355,2,32}, {15461355,3,55}, {15461355,-26,56}, {15461355,16,30}, {15461355,16,57}, {15461355,4,41}, {15461355,16,44}, {15461355,-5,44}, {15461355,-39,29}, {15461355,-31,50}, {15461355,-38,58}, {15329512,16,68}, {15395304,17,100}, {15395305,17,94}, {15461355,-38,94}, {15461355,13,75}, {15461355,-31,74}, {15461355,-13,75}, {15461355,-13,92}, {15461355,2,92}, {15461355,2,76}, {15461355,-25,93}, {15461355,-24,98}, {15461355,13,105}, {15461355,13,124}, {15461355,-23,116}, {15461355,3,105}, {15461355,-38,102}, {15461355,-38,128}}, 0, {286, 953, 91, 155});
    if next(result) ~= nil then
      log("[INFO] get bonus")
      touchPairs(result)
      waitingConnection()
    end
    
    --[[ skip share button ]]
    local result = findColors({{16178585,0,0}, {16777212,-13,-9}, {15846519,-19,2}, {15658609,-38,-8}, {13545031,-36,12}, {12364341,-38,19}, {16764282,-18,23}, {16771499,-3,17}, {16774862,-11,29}, {16773583,-10,49}, {16772795,-6,49}, {16175235,5,61}, {16699272,2,62}, {16703376,2,83}, {16772812,-9,76}, {16043118,-21,75}, {16175991,-19,78}, {15651435,-26,83}, {14597212,-27,61}, {12297268,-40,61}}, 0, {1310, 1749, 127, 291});
    if next(result) ~= nil then
      log("[INFO] found shar button")
      touchPos(92, 1724)
      wait = 1
      retry = 3
    end
    
    --[[ skip frends ]]
    local result = findColors({{16777215,0,0}, {16711422,-3,3}, {16777215,17,22}, {16777215,20,18}, {16579838,28,26}, {16777215,25,30}, {16579836,48,45}, {16777215,43,49}, {16777215,44,-1}, {15395573,48,4}, {16777215,-4,44}, {16777215,0,48}, {677546,23,35}, {1004970,10,23}, {939434,34,24}, {1073066,22,12}}, 0, {1127, 1860, 113, 126});
    if next(result) ~= nil then
      log("[INFO] skip friends")
      touchPairs(result)
    end
    
    --[[ skip die info ]]
    local result = findColors({{16316667,0,0}, {16448252,4,6}, {16383228,-14,23}, {16777215,-20,20}, {16777215,-45,4}, {16777215,-41,2}, {16777215,-24,20}, {16777215,-27,29}, {16777215,-45,44}, {16777215,-42,48}, {16580350,-24,32}, {16777215,-27,22}, {16580350,-27,23}, {16777215,-15,29}, {16777215,-16,32}, {16777215,3,45}, {16777215,2,49}, {21930,-9,26}, {1136042,-21,12}, {21930,-33,24}, {21930,-21,36}}, 0, {997, 1827, 83, 84});
    if next(result) ~= nil then
      log("[INFO] skip die info")
      touchPairs(result)
      waitingConnection()
      return true
    end
    
    --[[ kick by server ]]
    local result = findColors({{16645629,0,0}, {16777215,17,8}, {16777215,-15,5}, {16777215,-34,0}, {16777215,-25,6}, {15527149,-21,14}, {16250871,-31,44}, {16777215,-2,34}, {15790321,11,34}, {16777215,10,19}, {16777215,11,53}, {16777215,-5,48}, {16777215,-14,34}, {16053492,-9,66}, {16777215,-8,117}, {16777215,-9,131}, {16777215,-9,146}, {16777215,-9,159}, {16711422,-10,175}, {16316664,-9,196}, {16711422,-12,209}, {16579836,-11,231}, {13421772,-9,244}, {1446942,-10,254}, {1315608,-12,274}, {16777215,-9,285}, {16711422,-10,306}, {1249566,-11,318}, {16777215,-11,337}, {11578800,-8,359}, {12895429,-10,377}, {1907997,-9,385}, {16777215,-9,396}, {16711422,-10,411}, {15395562,-9,435}, {1249812,-10,446}, {16777215,-6,460}, {1709858,-7,478}, {16777215,-7,487}, {1973543,-8,526}, {16777215,-9,586}, {16777215,-10,602}, {16777215,-9,621}, {16777215,-10,635}, {16777215,-10,656}, {16777215,-6,688}, {15658735,-7,715}, {16777215,-7,741}, {16777215,-6,766}}, 0, {715, 556, 120, 895});
    if next(result) ~= nil then
      log("[INFO] kick by server")
      touchPairs(result)
      waitingConnection()
      return false
    end
    
    if wait == 0 then
      if retry > 0 then
        log("Waiting waitingGameOver")
        retry = retry - 1
      else
        return false
      end
    else
      retry = 3
    end
  waitingConnection()
  end
end

function recvRewards()
  local result = findColors({{7804185,0,0}, {16777215,-1,17}, {16777215,13,13}, {16777215,5,26}, {16777215,5,41}, {7804435,7,67}, {16777215,3,75}, {7803161,-17,85}, {16777215,-4,95}, {16777215,-4,119}, {7803415,5,138}, {16777215,2,149}, {7804953,3,174}, {16776958,1,185}, {16777215,4,215}, {7803161,1,224}, {16777215,-3,261}}, 0, {993, 842, 75, 373});
  if next(result) ~= nil then
    log("Got friend rewards")
	touchPos(542, 1013);
    waitingFlip()
  end
  
  local result = findColors({{2236945,0,0}, {1117953,-13,17}, {12360516,-5,44}, {11176021,-1,64}, {11180373,45,87}, {13150805,94,33}, {16777158,-41,124}, {16777177,-43,118}, {15196084,-38,79}, {16777169,-42,63}, {16777164,-42,46}, {16777163,-41,20}, {16777169,-43,3}, {16777164,-44,-21}}, 0, {688, 1342, 185, 218});
  if next(result) ~= nil then
    log("[INFO] click daily task")
    touchPairs(result)
    waitingConnection()
  end
  
  local result = findColors({{2236945,0,0}, {1117953,-13,17}, {12360516,-5,44}, {11176021,-1,64}, {11180373,45,87}, {13150805,94,33}, {16777158,-41,124}, {16777177,-43,118}, {15196084,-38,79}, {16777169,-42,63}, {16777164,-42,46}, {16777163,-41,20}, {16777169,-43,3}, {16777164,-44,-21}}, 0, {688, 1342, 185, 218});
  if next(result) ~= nil then
    log("[INFO] click daily task")
    touchPairs(result)
    waitingConnection()
  end
  
  local result = findColors({{16777204,0,0}, {16775389,-13,20}, {16772812,-17,29}, {16707293,-13,42}, {16774382,-3,55}, {16245432,-28,70}, {16775406,-5,95}, {16775150,-6,119}, {16774622,-9,149}, {15785386,-31,164}, {16776427,-8,194}, {16777200,1,210}, {10031376,-11,129}, {10162432,-26,108}, {8848640,-25,139}, {16777214,59,104}, {15404800,45,87}, {13370368,47,121}, {16777215,31,127}, {16777215,31,73}}, 0, {1078, 1747, 262, 270});
  if next(result) ~= nil then
    log("[INFO] click task recv all")
    touchPairs(result)
    waitingConnection()
  end
  
  gotoHome()
  
  local result = findColors({{3351074,0,0}, {16777171,-19,28}, {16777165,-18,36}, {16777181,-20,44}, {16777181,-20,51}, {16777179,-22,76}, {16777169,-19,96}, {12408372,61,49}, {10320691,34,61}, {12292147,49,57}, {12881928,94,55}}, 0, {685, 1836, 182, 188});
  if next(result) ~= nil then
    log("[INFO] click mail")
    touchPairs(result)
    waitingConnection()
  end
  
  local result = findColors({{16772812,0,0}, {16117195,-1,21}, {16774880,11,35}, {16507837,-2,48}, {16576204,3,72}, {16777207,22,104}, {16644317,10,129}, {16379596,-1,173}, {16777192,85,81}, {16777212,47,67}, {16777215,53,107}, {15606272,49,-6}}, 0, {1079, 1743, 266, 274});
  if next(result) ~= nil then
    log("[INFO] click mail")
    touchPairs(result)
    waitingConnection()
	touchPos(612, 866);
    waitingFlip()
  end
  
  gotoHome()
  
end

MANAME="com.netease.glxbwysw"
function startMA()
  local state = appState(MANAME);
  if state == "ACTIVATED" then
    log("[INFO] MA is running")
    return true
  else
    log("[INFO] start MA")
    appRun(MANAME);
    usleep(10000000)
    touchPos(612, 866);
    waitingFlip()
    waitingConnection()
    waitingFlip()
    waitingConnection()
  end
end

function killMA()
  local state = appState(MANAME);
  if state == "ACTIVATED" then
    log("[INFO] kill MA")
    appKill(MANAME);
    usleep(3000000)
  end
end

function captureErrorPage()
  image=os.date("%Y-%m-%d-%H:%M:%S")..".bmp"
  screenshot (image, nil);
end

--[[ return skip button ]]
function skip_button()
  local retry = 20
  while retry > 0
  do
  	local result = findColors({{2193305,0,0}, {2263218,31,17}, {2264502,35,47}, {1539487,15,75}, {2263210,27,100}, {1603481,-2,133}, {16772827,-4,84}, {16773084,-3,52}, {16774363,-4,40}, {16509644,-7,20}, {16777198,-6,9}}, 0, {225, 1817, 171, 181});
  	if next(result) ~= nil then
      log("[INFO] FIND SKIP BUTTON")
      return result
    else
      retry = retry - 1
    end
  end
  return false
end

function battle_timer()
  findColors({{16777215,0,0}, {16777215,13,5}, {16777215,0,24}, {16777215,13,25}, {16777215,-2,85}, {16777215,10,95}, {16777215,51,-32}, {16777215,52,2}, {16777215,53,11}, {16777215,53,14}, {16777215,51,26}, {16777215,52,30}, {16777215,51,55}, {16777215,51,59}, {16777215,52,75}, {16777215,52,105}}, 0, nil);
end

--[[ return battle button ]]
function battle_button()
  local result = findColors({{14505269,0,0}, {14505275,0,20}, {14439476,2,44}, {14504255,9,80}, {14505268,-1,97}, {14504243,10,133}, {12255232,-23,142}, {15603733,90,59}}, 0, {203, 1785, 210, 227});
  if next(result) ~= nil then
    return result
  end
  
  local result = findColors({{16644572,0,0}, {13412898,-21,1}, {13412894,-19,18}, {16773088,0,17}, {15645525,24,9}, {16314069,0,34}, {13412898,-20,41}, {16576217,-66,32}, {16117459,-67,7}, {14527009,-78,32}, {13378082,-108,31}}, 0, {225, 1817, 171, 181});
  if next(result) ~= nil then
    return result
  end
  log("[INFO] Failed to find battle button")
  return result
end


function share_button()
    --[[ skip share button ]]
  local result = findColors({{16178585,0,0}, {16777212,-13,-9}, {15846519,-19,2}, {15658609,-38,-8}, {13545031,-36,12}, {12364341,-38,19}, {16764282,-18,23}, {16771499,-3,17}, {16774862,-11,29}, {16773583,-10,49}, {16772795,-6,49}, {16175235,5,61}, {16699272,2,62}, {16703376,2,83}, {16772812,-9,76}, {16043118,-21,75}, {16175991,-19,78}, {15651435,-26,83}, {14597212,-27,61}, {12297268,-40,61}}, 0, {1310, 1749, 127, 291});
  if next(result) ~= nil then
    log("[INFO] found share button")
    return true
  end
  
  return false
end

--[[ get life ]]
function get_life(pos, scope, split)
  local start = scope[1]
  local endt = scope[2]
  local step = math.floor((endt - start) * 0.04)
  local life = 0
  while start <= endt
  do
    local rgb = getColor(pos, start)
    if rgb > split then
      life = start
      start = start + step
      if start - endt < step - 1 and start - endt > 0 then
        start = endt - 1
      end
    else
      break
    end
  end
  log("[INFO] life " .. life .. " endt " .. endt .. " scope[1] " .. scope[1] .. " color @(" .. pos .. "," .. (start + step) .. ") is " .. getColor(pos, start + step))
  return math.floor((life - scope[1]) / (endt - scope[1]) * 100)
end

--[[ test pass ]]
function find_single(partner)
  --[[ find single partner with less life ]]
  --[[ or return total lost life for all partner ]]
  --[[ -1 : return most less one partner position ]]
  --[[ 0  : return total lost life for all partner ]]
  --[[ 1  : return the life of partner 1 ]]
  --[[ 2  : return the life of partner 2 ]]
  --[[ 3  : return the life of partner 3 ]]
  --[[ 4  : return the life of self ]]
  local partner_life_scope = {21, 251}
  local self_life_scope = {95, 395}
  local split = 5000000
  local partner1_pos = 1342
  local partner2_pos = 1117
  local partner3_pos = 889
  local self_pos = 41
  local partner1 = get_life(partner1_pos, partner_life_scope, split)
  local partner2 = get_life(partner2_pos, partner_life_scope, split)
  local partner3 = get_life(partner3_pos, partner_life_scope, split)
  local self_life = get_life(self_pos, self_life_scope, split)
  log("[INFO] 1: " .. partner1 .. " 2: " .. partner2 .. " 3: " .. partner3 .. " 4: "..self_life)
  
  if partner == 0 then
    return (100 - partner1),(100 - partner2), (100 - partner3), (100 - self_life)
  end
  
  if partner == 1 then
    return partner1
  end
  
  if partner == 2 then
    return partner2
  end
  
  if partner == 3 then
    return partner3
  end
  
  if partner == 4 then
    return slef_life
  end
  
  local m = 0
  m = math.min(partner1, partner2, partner3, self_life)
  if m == partner1 then
    return {partner1_pos + 100, partner_life_scope[1]}
  end
  
  if m == partner2 then
    return {partner2_pos + 100, partner_life_scope[1]}
  end
    
  if m == partner3 then
    return {partner3_pos + 100, partner_life_scope[1]}
  end
  
  if m == self_life then
    return {self_pos + 100, self_life_scope[1]}
  end
end

function find_all()
  --[[ find all partner ]]
  return {771, 321}
end

function color_compare(colorA, colorB)
  local absR = colorA[1] - colorB[1]
  local absG = colorA[2] - colorB[2]
  local absB = colorA[3] - colorB[3]
  
  return math.floor(math.sqrt(absR * absR + absG * absG + absB * absB))
end

function color2name(color)
  local c2n = {["red"] = {255, 0, 0}, ["blue"] = {0, 0, 255}, ["green"] = {0, 255, 0}, ["black"] = {255, 0, 255}, ["yellow"] = {255, 255, 0}}
  local name = ""
  local min = 255
  for i, v in pairs(c2n) do
    local distance = color_compare(color, v)
    min = math.min(min, distance)
    if min == distance then
      name = i
    end
  end
  return name
end

--[[ test pass ]]
function get_cost_total()
  local pos_x = 33
  local step = 52
  local start = 935
  local endt = 1426
  local pos_y = start
  local count = 0
  while pos_y < endt do
    local color = getColor(pos_x, pos_y)
    if color > 8000000 then
      count = count + 1
      pos_y = pos_y + step
    else
      break
    end
  end
  
  return count
end

--[[ class card ]]
Card = {name = '0', cost = 0, selects = false, single = false, onlyself = false, pos = nil, color = "", target={{771, 321}, {1442, 40}, {141, 105}} --[[1: full cure 2: single 3: onlyself ]]}
Card.__index = Card

function Card:new(name, pos)
  local self = {}
  setmetatable(self, Card)
  self.pos = pos
  self.name = name
  return self
end

function Card:update()
  if self.cost == 0 then
    local cost_total = get_cost_total()
    touchPos(self.pos[1], self.pos[2])
    for i, v in pairs(self.target) do
      touchPos(v[1], v[2])
      local cost_rest = get_cost_total()
      if cost_total - cost_rest > 0 then
        touchPos(self.pos[1], self.pos[2])
        self.cost = cost_total - cost_rest
        self.selects = false
        if i == 1 then
          self.single = false
          self.onlyself = false
        end
        if i == 2 then
          self.single = true
          self.onlyself = false
        end
        if i == 3 then
          self.single = false
          self.onlyself = true
        end
        local c = getColor(self.pos[1] + 125, self.pos[2] - 104)
        local r, g, b = intToRgb(c)
        self.color = color2name({r, g, b})
        log(string.format("[INFO] %s ==> cost %d == index %d color = %s", self.name, self.cost, i, self.color))
      end
    end
  end
end

function Card:play()
  if self.cost == 0 then
    return false
  else
    log("[INFO] play " .. self.name)
    touchPos(self.pos[1], self.pos[2])
    if self.onlyself then
      touchPos(self.target[3][1], self.target[3][2])
    end
    if self.single then
      local pos = find_single(-1)
      touchPos(pos[1], pos[2])
    end
    if self.single == false and self.onlyself == false then
      touchPos(self.target[1][1], self.target[1][2])
    end
    self.cost = 0
  end
end

function Card:getCost()
  return self.cost
end

function Card:getSingle()
  return self.single
end

function Card:isSelected()
  return self.selects
end

function Card:selected()
  self.selects = true
end

function Card:getColor()
  return self.color
end

card1 = Card:new("Card1", {260, 534})
card2 = Card:new("Card2", {255, 809})
card3 = Card:new("Card3", {271, 1081})
card4 = Card:new("Card4", {218, 1345})
card5 = Card:new("Card5", {254, 1603})
CARD_LIST = {card1, card2, card3, card4, card5}
function search_card(cost, single, color)
  --[[ search card with cost ]]
  log("[INFO]search cost " .. cost .. " color " .. color)
  for i, v in pairs(CARD_LIST) do
    if v:getCost() == cost and v:getSingle() == single and v:isSelected() == false and v:getColor() == color then
      v:selected()
      return v
    end
  end
  for i, v in pairs(CARD_LIST) do
    if v:getCost() == cost and v:getSingle() == single and v:isSelected() == false then
      v:selected()
      return v
    end
  end
  return nil
end

function get_cure_level()
  --[[ 治疗级别 ]]
  local player1
  local player2
  local player3
  local player4
  player1, player2, player3, player4 = find_single(0)
  local total_lost = player1 + player2 + player3 + player4
  local average_lost = total_lost / 4
  local max = math.max(player1, player2, player3, player4)
  local cure = 0
  if total_lost < 20 then
    return cure
  end
  while total_lost > 0
  do
    total_lost = total_lost - 100
    cure = cure + 1
  end

  if max >= 2 * average_lost then
    cure = cure + 1
  end

  return cure
end

function sort_card(chain_color)
  --[[ sort the card and return the table to play ]]
  --[[ check all player life whether we should play more than 1 card ]]
  --[[ calculate the cost rest every time we selected one ]]
  --[[ life not full list: 3C > 4C > 1C > 2C ]]
  --[[ life full     list: 5C > 1C > 2C > 3C ]]
  local card_to_play = {}
  local cost_total = get_cost_total()
  local cure = get_cure_level()
  local chain = false
  if cure == 0 then
    chain = true
  end
  log("[INFO] cure " .. cure .. " cost total " .. cost_total)
  while true
  do
    local last_cost = cost_total
    while true do
      if cost_total >= 5 and cure == 0 then
        local card = search_card(5, false, chain_color)
        if card ~= nil then
          table.insert(card_to_play, card)
          cost_total = cost_total - card:getCost()
          break
        end
      end
      if cure == 0 then
        local card = search_card(1, false, chain_color)
        if card ~= nil then
          table.insert(card_to_play, card)
          cost_total = cost_total - card:getCost()
          break
        end
      end
    
      if cure == 0 and cost_total <= 3 and cost_total > 0 then
        local card = search_card(2, true, chain_color)
        if card ~= nil then
          table.insert(card_to_play, card)
          cost_total = cost_total - card:getCost()
          break
        end
      end
      
      if cure == 0 and chain == true then
        local card = search_card(3, false, chain_color)
        if card ~= nil then
          table.insert(card_to_play, card)
          cost_total = cost_total - card:getCost()
          break
        end
      end
    
      if cure > 0 then
        if cost_total >= 4 then
          local card = search_card(4, false, chain_color)
          if card ~= nil then
            table.insert(card_to_play, card)
            cost_total = cost_total - card:getCost()
            cure = cure - 1
            break
          end
        end
        if cost_total >= 3 then
          local card = search_card(3, false, chain_color)
          if card ~= nil then
            table.insert(card_to_play, card)
            cost_total = cost_total - card:getCost()
            cure = cure - 1
            break
          end
        end
        if cost_total >= 2 then
          local card = search_card(2, false, chain_color)
          if card ~= nil then
            table.insert(card_to_play, card)
            cost_total = cost_total - card:getCost()
            cure = cure -1
            break
          end
        end
        if cost_total >= 2 then
          local card = search_card(2, true, chain_color)
          if card ~= nil then
            table.insert(card_to_play, card)
            cost_total = cost_total - card:getCost()
            cure = cure -1
            break
          end
        end
        if cost_total >= 1 then
          local card = search_card(2, false, chain_color)
          if card ~= nil then
            table.insert(card_to_play, card)
            cost_total = cost_total - card:getCost()
            cure = cure -1
            break
          end
        end
      end
      break
      chain = false
    end
    if last_cost == cost_total then
      break
    end
  end
  return card_to_play
end

function skip_this_turn()
  touchPairs(skip_button())
  touchPos(327, 1905);
  usleep(500000)
  touchPos(552, 740);
end

function is_internal_autobattle_enable()
  local result = findColors({{16777037,0,0}, {16777035,-17,0}, {16711241,-18,21}, {16644934,1,21}, {16777038,3,9}, {16579916,-6,11}, {16053322,-12,11}, {16777045,-6,33}, {15397189,1,34}, {16777036,-17,31}, {16776782,-18,44}, {16777045,-16,39}, {16777039,-2,47}, {16777036,-3,54}, {16579663,-19,53}, {948007,-14,51}}, 0, {88, 1829, 77, 186});
  if next(result) ~= nil then
    log("[INFO] internal autobattle enabled")
    return true
  end
  
  local result = findColors({{14535228,0,0}, {14469952,0,21}, {13416497,-6,21}, {14928963,3,9}, {13877822,2,32}, {14535731,0,48}, {14467891,-6,33}, {1909282,-14,51}, {14403635,-2,55}, {2236962,-13,67}, {14535738,1,67}, {14535742,0,80}, {2236962,-4,71}}, 0, {88, 1829, 77, 186});
  if next(result) ~= nil then
    touchPairs(result)
    log("[INFO] enable internal autobattle")
    return true
  end
    
  return false
end

function get_chain_color()
  local color_tbl = {["red"] = "blue", ["blue"] = "green", ["green"] = "red", ["black"] = "yellow", ["yellow"] = "black"}
  local color = getColor(1290, 719);
  local r, g, b = intToRgb(color)
  local name = color2name({r, g, b})
  return color_tbl[name]
end

function auto_battle()
  local turn = 0
  local retry = 60
  local chain_color = nil
  while retry > 0 do

    if skip_button() then
      if is_internal_autobattle_enable() then
        return false
      end
      if chain_color == nil then
        chain_color = get_chain_color()
      end
      for i, v in pairs(CARD_LIST) do
        v:update()
      end
      local rule = sort_card(chain_color)
      if next(rule) ~= nil then
        for i, v in pairs(rule) do
          v:play()
        end
        usleep(500000)
        touchPairs(battle_button())
		touchPos(316, 1907);
      else
        skip_this_turn()
      end
    end

    if isInRoom() then
      usleep(1000000)
    else
      retry = retry - 1
      usleep(1000000)
    end

    if share_button() then
      return false
    end

  end
end


--[[ main start here ]]
log("[INFO] script start @ "..os.date("%c"))
startMA()
recvRewards()
local last_rewards = 0
while true
do
  local quit = 0
  local retry = 0
  while quickGame() == nil
  do
    gotoHome()
  	retry = retry + 1
  	if retry == 5 then
   	  quit = 1
      break
    end
  end

  if quit == 1 then
    log("Script exit")
    break
  end

  if confirmPlayer() == false then
    break
  end
  
  if joinRoom() == true then
    auto_battle()
    waitingGameOver()
  end
  networkError()
  local hour = os.date("%H")
  if hour == "12" or hour == "13" or hour == "14" or hour == "18" or hour == "19" or hour == "20" then
    if hour - last_rewards > 2 then
      recvRewards()
      last_rewards = hour
    end
  end
end
log("[INFO] script stop @ "..os.date("%c"))
captureErrorPage()
killMA()
