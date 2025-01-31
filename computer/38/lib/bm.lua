-- lib/bm.lua
-- storage_controller
local kv = require "lib/kv"
local constants = require "lib/constants"
local buffer_state_fn = "buffer_state"

local bm = { _version = '0.0.1' }

function move_to_return(bufferName)
    local return_storages = constants.buffer_returns
    for _, return_storage in pairs(constants.return_storages) do
        table.insert(return_storages, return_storage)
    end
    local buffer = peripheral.wrap(bufferName)
    ::retry::
    for _, return_storage in pairs(return_storages) do
        for slot, item in pairs(buffer.list()) do
            local transferred = buffer.pushItems(return_storage, slot)
            if transferred == 0 then goto continue end
        end
        ::continue::
    end
    if next(buffer.list()) ~= nil then
        sleep(5)
        goto retry
    end
end

function update_buffer(bufferName, status)
    local current_state = kv.read(buffer_state_fn)
    current_state[bufferName] = status
    kv.write(current_state, buffer_state_fn)
end

function bm.init()
    local initial_state = {}
    for buffer_name, _ in pairs(constants.storage_buffers) do
        move_to_return(buffer_name)
        initial_state[buffer_name] = "unlocked"
    end
    kv.write(initial_state, buffer_state_fn)
end

function bm.allocate()
    local current_state = kv.read(buffer_state_fn)
    for buffer_name, state in pairs(current_state) do
        if state == "unlocked" then
            update_buffer(buffer_name, "locked")
            return buffer_name
        end
    end
end

function bm.release(bufferName)
    move_to_return(bufferName)
    update_buffer(bufferName, "unlocked")
end

return bm

