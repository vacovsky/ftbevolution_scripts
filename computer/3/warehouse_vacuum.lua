local whi = require 'lib/whi'
local json = require "lib/json"

local COLONY_NAME = 'Nolins'


local source_inventories = {
    'sophisticatedstorage:chest_3',
    'sophisticatedstorage:chest_6',
    'pneumaticcraft:reinforced_chest_5'
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
                    -- if not item.name == 'create:experience_nugget' then
                        -- print('Moving', item.name, 'to warehouse')
                        deposited = deposited + whi.DepositInAnyWarehouse(inventory, slot)
                    -- end
                end
            end
        end
    end

    local data = {
        timeStamp = os.epoch("utc"),
        turtlePower = {
            name = COLONY_NAME,
            vacuumedItems = deposited
        }
    }
    WriteToFile(json.encode(data), "warehouseVacuum.json", "w")
    print(deposited, 'xfer')
end

print('Starting warehouse vacuum...')
while true do
    if not pcall(Vacuum) then print('Vacuum() failed to complete') end
    -- Vacuum()
    sleep(600)
end
