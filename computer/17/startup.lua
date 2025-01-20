
local whi = require 'lib/whi'
local var = require 'lib/constants'


print("drawer stackables warehouse audit")


while true do
    -- local moved = 0
    -- local storage_controllers = {}
    -- local warehouses = {}

    -- local peripherals = peripheral.getNames()
    -- for _, attached_peripheral in pairs(peripherals) do

    --     if string.find(attached_peripheral, vars.storage_controllers) then
    --         storage_controllers[#storage_controllers + 1] = attached_peripheral
    --     end

    --     if string.find(attached_peripheral, vars.warehouses) then
    --         warehouse[#warehouse + 1] = attached_peripheral
    --     end
    -- end

    
    items = whi.ItemCountMap()

    for item, _ in pairs(items) do
        moved = moved + whi.DepositInAnyWarehouse(item)
    end

    -- for _, wh in pairs(warehouses) do
    --     for _, sc in pairs(storage_controllers) do
    --         for item, _ in pairs(items) do
    --             moved = moved + peripheral.wrap(wh).push()
    --         end
        
    --     end
    -- end
    sleep(30000)
end
