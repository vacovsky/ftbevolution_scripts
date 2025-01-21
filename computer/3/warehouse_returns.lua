local DROPBOX = 'sophisticatedstorage:chest_3'

local whi = require 'lib/whi'
local var = require 'lib/constants'

function ReturnWares()
    dropbox = peripheral.wrap(DROPBOX)
    count = 0
    for slot, item in pairs(dropbox.list()) do
        for whi, warehouse in pairs(warehouses) do
            count = count + whi.DepositInAnyWarehouse(DROPBOX, slot)
        end
        print('Returned', count, 'items')
    end
    return true
end

print('Starting automated warehouse return system...')
while true do
    pcall(ReturnWares)
    sleep(1)
end