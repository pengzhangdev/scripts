dialog("选取截图起点位置", 3)
local x1, y1 = catchTouchPoint()
dialog("选取截图终点位置", 3)
local x2, y2 = catchTouchPoint()
local pic = os.date("%Y-%m-%d-%H-%M-%S") .. ".png"
sysLog(string.format("capture {%d, %d, %d, %d} to %s", x1, y1, x2, y2, pic))
snapshot(pic, x1, y1, x2, y2)
