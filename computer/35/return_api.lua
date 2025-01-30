-- return_api.lua
-- storage_controller
local args = {...}
local client_id = tonumber(args[1])

local constants = require "lib/constants"
local return_storages = constants.return_storages

rednet.send(client_id, return_storages, "storage_client")

print("debug sleep")
sleep(20)
print("debug end")
