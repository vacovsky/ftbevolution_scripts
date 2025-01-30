-- net.lua
-- storage_controller
local net = { _version = '0.0.1' }

local constants = require "lib/constants"

function net.get_storages(storageStrings, wrapped, blacklist, modem_name)
    local modem = peripheral.wrap(modem_name)
    local remote_names = modem.getNamesRemote()
    local storages = {}

    for _, remote_name in pairs(remote_names) do
        -- black list
        if blacklist == false then goto skip end
        for _, internal_buffer in pairs(constants.storage_buffers) do
            if string.find(remote_name, internal_buffer) then goto continue end
        end
        for _, inbound_storage in pairs(constants.inbound_storages) do
            if string.find(remote_name, inbound_storage) then goto continue end
        end
        ::skip::
        -- wrap_storages
        for _, storage_string in pairs(storageStrings) do
            if string.find(remote_name, storage_string) then
                if wrapped == true then
                    storages[#storages + 1] = peripheral.wrap(remote_name)
                end
                if wrapped == false then
                    storages[#storages + 1] = remote_name
                end
                goto continue
            end
        end

        ::continue::
    end
    return storages
end

return net
