local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"
local sc = require "lib/sc"

-- local combs_source = 'enderstorage:ender_chest_5'
local combs_dest = 'enderstorage:ender_chest_8'
-- local combs_dest = 'sophisticatedstorage:chest_2'
-- local combs_dest = 'pneumaticcraft:reinforced_chest_1'

function ListHives()
    local list = {}
    local peripherals = peripheral.getNames()
    for _, attached_peripheral in pairs(peripherals) do
        if string.find(attached_peripheral, vars.hives) then
            list[#list + 1] = attached_peripheral
        end
    end
    return list
end

function CollectFromHives()
    local combsMoved = 0
    for _, hive in pairs(ListHives()) do
        local phive = peripheral.wrap(hive)
        local pcombdest = peripheral.wrap(combs_dest)
        for slot, item in pairs(phive.list()) do
            if slot == 1 or slot == 2 then goto skip end
            if not string.find(item.name, 'minecraft:') and
                string.find(item.name, 'comb') and not string.find(item.name, 'sugarbag') then
                combsMoved = combsMoved + pcombdest.pullItems(hive, slot)
            else
                combsMoved = combsMoved + sc.push(hive, slot)
            end
            ::skip::
        end
    end
    if combsMoved > 0 then print('Transferred', combsMoved, 'combs') end
end


print("Starting hive collector...")
while true do
    -- if not pcall(CollectFromHives) then print('CollectFromHives() failed to complete') end
    CollectFromHives()
    sleep(.1)
end
