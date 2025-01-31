-- lib/sc.lua
-- storage_client

local sc = { _version = '0.0.2' }

local tsdb = require 'lib/tsdb'

local client_proto = "storage_client"
local contro_proto = "storage_controller"
local timeout = 10

function get_controller_id()
    print("getting the contro_id")
    ::retry::
    controller_id = rednet.lookup(contro_proto)
    if controller_id == nil then
        print("no contro_id")
        sleep(5)
        goto retry
    end
    return controller_id
end

local contro_id = get_controller_id()

function get_return_storages()
    print("getting return_storages")
    rednet.send(contro_id, "return", contro_proto)
    ::retry::
    sender_id, return_names, proto = rednet.receive(storage_client, timeout)
    if sender_id == nil then
        print("timeout getting return storages")
        goto retry
    end
    return return_names
end

local return_storages = get_return_storages()

function sc.pull(itemName, quantity, strict, destStorageName, destSlot)
    local req_start = os.epoch('utc')
    -- from buffer
    local itemName = itemName
    local quantity = tonumber(quantity)
    local strict = strict or false
    local destStorageName = destStorageName
    local destSlot = destSlot or nil
    --print("pulling from buffers")
    --print(itemName)
    --print(quantity)
    --print(strict)
    --print(destStorageName)
    --print(destSlot)
    -- request items from storage
    local request_string = string.format("get %s %s %s", itemName, quantity, strict)
    rednet.send(contro_id, request_string, contro_proto)
    sender_id, buffer_names, proto = rednet.receive(storage_client, timeout)
    if sender_id == nil then
        print("[sc.pull] timeout")
        return 0
    end
    if next(buffer_names) == nil then
        print("[sc.pull] no avail buffers")
        return 0
    end
    local tot_transferred = 0
    for _, buffer_name in pairs(buffer_names) do
        local buffer = peripheral.wrap(buffer_name)
        for slot, item in pairs(buffer.list()) do
            local transferred = buffer.pushItems(destStorageName, slot, quantity, destSlot)
            tot_transferred = tot_transferred + transferred
        end
    end
    logRequestTime("sc.pull", os.epoch('utc') - req_start)
    return tot_transferred
end

function sc.push(srcStorageName, srcSlot)
    -- start timer
    -- to return
    local srcStorageName = srcStorageName
    local srcSlot = srcSlot
    local src_storage = peripheral.wrap(srcStorageName)
    local tot_transferred = 0
    while true do
        for _, return_name in pairs(return_names) do
            local transferred = src_storage.pushItems(return_name, srcSlot)
            tot_transferred = tot_transferred + transferred
        end
        if src_storage.list()[srcSlot] == nil then return tot_transferred end
    end
    return tot_transferred
end

function sc.push_all(srcStorageName)
    -- to return
    local srcStorageName = srcStorageName
    local src_storage = peripheral.wrap(srcStorageName)
    local tot_transferred = 0
    while true do
        for _, return_name in pairs(return_names) do
            for slot, item in pairs(src_storage.list()) do
                local transferred = src_storage.pushItems(return_name, slot)
                tot_transferred = tot_transferred + transferred
                if transferred == 0 then goto continue end
            end
            ::continue::
        end
        if next(src_storage.list()) == nil then return tot_transferred end
    end
end

function logRequestTime(method, time)
    local data = {
        [method] = time,
    }
    tsdb.WriteOutput("FTBEvolution", "storage_controller:"..tostring(os.getComputerID()), data, "storage.json")
end

return sc
