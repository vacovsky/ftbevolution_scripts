local net = require 'lib/network'
local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"

local combs_dest = 'enderstorage:ender_chest_3'
local fluid_dest = 'enderstorage:ender_tank_0'


function UnloadFuges()
    local items = 0
    for _, fuge in pairs(net.ListMultipleMatchingDevices({vars.fuges, vars.powered_fuges, vars.heated_fuges})) do
        local pfuge = peripheral.wrap(fuge)
        local pcombdest = peripheral.wrap(combs_dest)
        local pfluiddest = peripheral.wrap(fluid_dest)

        for slot, item in pairs(pfuge.list()) do
            -- if not string.find(item.name, 'comb') then
            if slot ~= 2 then
                items = items + pcombdest.pullItems(fuge, slot)
            end
        end
        pfluiddest.pullFluid(fuge)
    end
    print('xfer', items, 'items')
end

while true do
    -- UnloadFuges()
    if not pcall(UnloadFuges) then print('0:UnloadFuges() exited with error') end
    if not pcall(UnloadFuges) then print('1:UnloadFuges() exited with error') end
    if not pcall(UnloadFuges) then print('2:UnloadFuges() exited with error') end
    sleep(0.1)
end
