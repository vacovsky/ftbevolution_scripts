
local whi = require 'lib/whi'
local var = require 'lib/constants'

local buffer = 'minecraft:barrel_0'

print("drawer stackables warehouse audit")


while true do
    moved = 0
    items = whi.ItemCountMap()

    for item, _ in pairs(items) do
        moved = moved + whi.GetFromAnyWarehouse(true, item, buffer)
    end

    for slot, item in pairs(peripheral.wrap(buffer).list()) do
        whi.DepositInAnyWarehouse(buffer, slot)
        sleep(.5)
    end
    print("- moved", moved, "items")
    sleep(30)
end
