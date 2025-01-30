-- get_api.lua
-- storage_controller
local args = {...}
local client_id = tonumber(args[1])
local item_name = args[2]
local item_quantity = tonumber(args[3])
local stb = { ["true"]=true, ["false"]=false }
local strict = stb[args[4]]
local modem_name = args[5]

local max_quantity = 1024
if item_quantity > max_quantity then item_quantity = max_quantity end

local bm = require "lib/bm"
local net = require "lib/net"

local buffer_timeout = 5
local buffer_names = {}



local current_buffer = bm.allocate()
if current_buffer == nil then goto messageclient end
if current_buffer ~= nil then table.insert(buffer_names, current_buffer) end



::messageclient::
rednet.send(client_id, buffer_names, "storage_client")

-- give client buffer_timeout seconds to get their stuff
sleep(buffer_timeout)
print("starting release loop")
for _, b in pairs(buffer_names) do
    print(b)
    bm.release(b)
end
print("debug sleep")
sleep(20)
print("debug end")
