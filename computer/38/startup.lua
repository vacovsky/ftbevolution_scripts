-- startup.lua
-- storage_controller
local constants = require "lib/constants"
local bm = require "lib/bm"

local local_modem = "right"
local internal_modem = "left"
local display_name = "monitor_2"

-- initialize buffer states
print("bm.init() start")
bm.init()
print("bm.init() end")

-- start rednet
rednet.host("storage_controller", ("%s"):format(os.getComputerID()))
rednet.open(local_modem)

-- start services
print("starting returns_service")
shell.openTab("returns_service", internal_modem)
shell.openTab("request_router", internal_modem)
shell.openTab("display_service", display_name)
