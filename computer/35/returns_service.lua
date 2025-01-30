-- returns_service.lua
-- storage_controller
local args = {...}
local internal_modem_name = args[1]

local constants = require "lib/constants"
local net = require "lib/net"

local p1_storages = net.get_storages(constants.p1_storage_strings, false, true, internal_modem_name)
local p2_storages = net.get_storages(constants.p2_storage_strings, false, true, internal_modem_name)
local inbound_storages = net.get_storages(constants.inbound_storages, true, false, internal_modem_name)


print("debug")
print("p1 storages")
for _, s in pairs(p1_storages) do
    print(s)
end
print("p2 storages")
for _, s in pairs(p2_storages) do
    print(s)
end
print("inbound storages")
for _, s in pairs(inbound_storages) do
    print(peripheral.getName(s))
end

print("starting returns loop")
while true do
    for _, i_storage in pairs(inbound_storages) do
        for slot, item in pairs(i_storage.list()) do
            for _, p1_storage in pairs(p1_storages) do
                local transferred = i_storage.pushItems(p1_storage, slot)
                if i_storage.list()[slot] == nil then goto continue end
            end
            for _, p2_storage in pairs(p2_storages) do
                local transferred = i_storage.pushItems(p2_storage, slot)
                if i_storage.list()[slot] == nil then goto continue end
            end
            ::continue::
        end
    end
    sleep(1)
end

print("debug sleep")
sleep(20)
print("debug end")
