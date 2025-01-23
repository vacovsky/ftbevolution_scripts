local net = require 'lib/network'
local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"

local combs_source = 'enderstorage:ender_chest_0'

function LoadFuges()
    local combsMoved = 0
    for _, fuge in pairs(net.ListMatchingDevices(vars.fuges)) do
        local pfuge = peripheral.wrap(fuge)
        local pcombsrc = peripheral.wrap(combs_source)
        for slot, item in pairs(pcombsrc.list()) do
            if string.find(item.name, 'productivebees:') then
                pfuge.pullItems(combs_source, slot)
            end
        end
    end
    print('Tranferred', combsMoved, 'combs')
end
while true do
    -- LoadFuges()
    if not pcall(LoadFuges) then print('LoadFuges() exited with error') end
    sleep(5)
end
