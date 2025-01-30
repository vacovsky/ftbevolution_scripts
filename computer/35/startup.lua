-- startup.lua
-- storage_controller
local constants = require "lib/constants"
local bm = require "lib/bm"

local local_modem = "left"
local internal_modem = "right"
local display_name = "monitor_1"

-- initialize buffer states
bm.init()

-- start rednet
rednet.host("storage_controller", ("%s"):format(os.getComputerID()))
rednet.open(local_modem)

-- start services
shell.openTab("returns_service", internal_modem)
shell.openTab("request_router", internal_modem)
shell.openTab("display_service", display_name)
