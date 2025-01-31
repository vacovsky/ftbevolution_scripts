-- return_api.lua
-- storage_controller
local args = {...}
local client_id = tonumber(args[1])
local client_protocol = args[2]

local constants = require "lib/constants"
local return_storages = constants.return_storages

--local head = table.remove(return_storages, 1)

rednet.send(client_id, return_storages, client_protocol)

print("debug sleep")
sleep(20)
print("debug end")
