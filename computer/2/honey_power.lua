local vars = require "lib/constants"
local net = require 'lib/network'

local honey_generator = 'productivebees:honey_generator'
local WAIT_SECONDS = 10
local json = require "json"
local honeybottle_dest = 'minecraft:barrel_3'

function FillGeneratorsFromHoneyStorage()
    local honey_storage = net.ListMatchingDevices(vars.honey_storage)
    local honey_generators = net.ListMatchingDevices(honey_generator)
    local honeyUsed = 0

    for index, attached_peripheral in pairs(honey_generator) do
        local gen = peripheral.wrap(attached_peripheral)
        for _, honeybucket in pairs(honey_storage) do
            print(attached_peripheral, honeybucket)
            print(gen.pullFluid(honeybucket))
        end
    end

    print(honeyUsed)
end

function WriteToFile(input, fileName, mode)
    local file = io.open(fileName, mode)
    io.output(file)
    io.write(input)
    io.close(file)
end

print('Starting Turtle Power (HIAHS)')
while true do
    -- if redstone.getInput('top') then
    -- pcall(FillGeneratorsFromHoneyStorage)
    FillGeneratorsFromHoneyStorage()
    -- else
    --     print('Service Offline - Flip the lever on top!')
    -- end
    sleep(WAIT_SECONDS)
end
