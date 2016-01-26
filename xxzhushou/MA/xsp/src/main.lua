appName = "com.netease.glxbwysw"

local utils = require("utils");
local api = require("api");
local info = api.info;
local err = api.err;

api.runApp(appName);
api.mSleep(1000)
init("0", 0);

local cardManager = require("card_manager")
cardManager.sellCards()
