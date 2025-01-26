local net = require 'lib/network'
local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"

local combs_source = 'enderstorage:ender_chest_0'

function LoadFugesWithCombs()
    local combsMoved = 0
    for _, fuge in pairs(net.ListMultipleMatchingDevices({vars.fuges, vars.powered_fuges, vars.heated_fuges})) do
        local pfuge = peripheral.wrap(fuge)
        local pcombsrc = peripheral.wrap(combs_source)
        for slot, item in pairs(pcombsrc.list()) do
            if string.find(item.name, 'productivebees:configurable_honeycomb') then
                combsMoved = combsMoved + pfuge.pullItems(combs_source, slot)
            end

        end
    end
    print('Transferred', combsMoved, 'combs')
end

function LoadFugesWithCombBlocks()
    local combsMoved = 0
    for _, fuge in pairs(net.ListMatchingDevices(vars.heated_fuges)) do
        local pfuge = peripheral.wrap(fuge)
        local pcombsrc = peripheral.wrap(combs_source)
        for slot, item in pairs(pcombsrc.list()) do
            if string.find(item.name, 'productivebees:configurable_comb') then
                combsMoved = combsMoved + pfuge.pullItems(combs_source, slot)
            end
        end
    end
    print('Transferred', combsMoved, 'blocks')
end

while true do
    if not pcall(LoadFugesWithCombBlocks) then print('LoadFugesWithCombBlocks() exited with error') end    
    if not pcall(LoadFugesWithCombs) then print('LoadFugesWithCombs() exited with error') end
    sleep(5)
end
