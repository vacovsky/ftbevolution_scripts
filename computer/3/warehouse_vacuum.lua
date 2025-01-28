local whi = require 'lib/whi'
local json = require "lib/json"

local COLONY_NAME = 'Nolins'


local source_inventories = {
    'sophisticatedstorage:barrel_1',
    'sophisticatedstorage:barrel_0',
    'sophisticatedstorage:barrel_4',
    'enderstorage:ender_chest_2'
}

function WriteToFile(input, fileName, mode)
    local file = io.open(fileName, mode)
    io.output(file)
    io.write(input)
    io.close(file)
end

function Vacuum()
    local deposited = 0
    for _, inventory in pairs(source_inventories) do
        for _, p in pairs(peripheral.getNames()) do
            if string.find(p, inventory) then
                local inv = peripheral.wrap(inventory)
                for slot, item in pairs(inv.list()) do
                    print(slot, item.name)
                    deposited = deposited + whi.DepositInAnyWarehouse(inventory, slot)
                end
            end
        end
    end
    print(deposited, 'xfer')
end

print('Starting warehouse vacuum...')
while true do
    -- Vacuum()
    if not pcall(Vacuum) then print('Vacuum() failed to complete') end
    sleep(60)
end
