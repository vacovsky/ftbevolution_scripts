local net = require 'lib/network'
local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"

local combs_dest = 'enderstorage:ender_chest_3'
local fluid_dest = 'enderstorage:ender_tank_0'


function UnloadFuges()
    local items = 0
    for _, fuge in pairs(net.ListMatchingDevices(vars.fuges)) do
        local pfuge = peripheral.wrap(fuge)
        local pcombdest = peripheral.wrap(combs_dest)
        local pfluiddest = peripheral.wrap(fluid_dest)

        for slot, item in pairs(pfuge.list()) do
            if not string.find(item.name, 'comb') then
                items = items + pcombdest.pullItems(fuge, slot)
            end
        end
        pfluiddest.pullFluid(fuge)
    end
    print('xfer', items, 'items')
end

while true do
    -- UnloadFuges()
    if not pcall(UnloadFuges) then print('UnloadFuges() exited with error') end


    sleep(5)
end
