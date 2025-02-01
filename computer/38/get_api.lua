-- get_api.lua
-- storage_controller
local args = {...}
local client_id = tonumber(args[1])
local client_protocol = args[2]
local item_name = args[3]
local item_quantity = tonumber(args[4])
local stb = { ["true"]=true, ["false"]=false }
local strict = stb[args[5]]
local modem_name = args[6]

local max_quantity = 1728
--local max_quantity = 3456
if item_quantity > max_quantity then item_quantity = max_quantity end

local bm = require "lib/bm"
local net = require "lib/net"
local constants = require "lib/constants"


local buffer_timeout = 3
local buffer_names = {}

local p1_storages = net.get_storages(constants.p1_storage_strings, true, true, modem_name)
local p2_storages = net.get_storages(constants.p2_storage_strings, true, true, modem_name)

function match_item(itemName, matchString, strict)
    if strict == false then
        return string.find(itemName, matchString)
    end
    if strict == true then
        return itemName == matchString
    end
end

::newcurrentbuffer::
if item_quantity == 0 then goto messageclient end
current_buffer = bm.allocate()
print("current_buffer", current_buffer)
if current_buffer == nil then goto messageclient end
if current_buffer ~= nil then table.insert(buffer_names, current_buffer) end
w_current_buffer = peripheral.wrap(current_buffer)

for _, p2_storage in pairs(p2_storages) do
    for slot, item in pairs(p2_storage.list()) do
        if match_item(item["name"], item_name, strict) then
            local transferred = p2_storage.pushItems(constants.storage_buffers[current_buffer], slot, item_quantity)
            item_quantity = item_quantity - transferred
            if #w_current_buffer.list() == w_current_buffer.size() then goto newcurrentbuffer end
        end
        if item_quantity == 0 then goto messageclient end
    end
end

for _, p1_storage in pairs(p1_storages) do
    for slot, item in pairs(p1_storage.list()) do
        if match_item(item["name"], item_name, strict) then
            local transferred = p1_storage.pushItems(constants.storage_buffers[current_buffer], slot, item_quantity)
            item_quantity = item_quantity - transferred
            if #w_current_buffer.list() == w_current_buffer.size() then goto newcurrentbuffer end
        end
        if item_quantity == 0 then goto messageclient end
    end
end

::messageclient::
rednet.send(client_id, buffer_names, client_protocol)

-- give client 'buffer_timeout' seconds to get their stuff
sleep(buffer_timeout)
for _, b in pairs(buffer_names) do
    bm.release(b)
end

print("debug sleep")
sleep(20)
print("debug end")
