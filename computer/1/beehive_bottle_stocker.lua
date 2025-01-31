local json = require "lib/json"
local vars = require "lib/constants"
local net = require "lib/network"
local whi = require "lib/whi"

function StockBottles()
    for _, hive in pairs(net.ListMatchingDevices(vars.hives)) do
        -- local bottles_replenished = whi.GetFromAnyWarehouse(false, 'minecraft:glass_bottle', hive, 4)
        local bottles_replenished = sc.pull('minecraft:glass_bottle', 8, true, hive, 4)
        print('Stocked', bottles_replenished, '->', hive)
    end
end

while true do
    -- StockBottles()
    pcall(StockBottles)
    sleep(1)
end
