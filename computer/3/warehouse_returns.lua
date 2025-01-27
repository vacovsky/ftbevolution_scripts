local DROPBOX = 'sophisticatedstorage:barrel_0'

local whi = require 'lib/whi'
local var = require 'lib/constants'

function ReturnWares()
    dropbox = peripheral.wrap(DROPBOX)
    count = 0
    for slot, item in pairs(dropbox.list()) do
        count = count + whi.DepositInAnyWarehouse(DROPBOX, slot)
        print('Returned', count, 'items')
    end
    return true
end

print('Starting automated warehouse return system...')
while true do
    -- if not pcall(ReturnWares) then print('ReturnWares() failed to complete') end
    ReturnWares()
    sleep(1800)
end