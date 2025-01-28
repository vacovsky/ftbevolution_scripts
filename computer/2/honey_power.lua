local vars = require "lib/constants"
local net = require 'lib/network'
local whi = require 'lib/whi'

local WAIT_SECONDS = 10

local honey_generator = 'productivebees:honey_generator'
local honeybottle_dest = 'minecraft:chest_83'
local emptybottle_dest = 'minecraft:barrel_1'

function FillGeneratorsFromHoneyStorage()
    local honey_storage = net.ListMatchingDevices(vars.honey_storage)
    local honey_generators = net.ListMatchingDevices(honey_generator)
    local honeyUsed = 0
    local honey_block_used = 0

    for index, attached_peripheral in pairs(honey_generators) do
        local gen = peripheral.wrap(attached_peripheral)
        for _, honeybucket in pairs(honey_storage) do
            honeyUsed = gen.pullFluid(honeybucket, 10000)
            honey_block_used = whi.GetFromAnyWarehouse(false, 'minecraft:honey_block', attached_peripheral, 5)
        end
    end
    print('INPUT mB', honeyUsed, '| honey_block', honey_block_used)
end

function HoneyBottleCubifier()
    local bottle_in = whi.GetFromAnyWarehouse(false, 'minecraft:honey_bottle', honeybottle_dest, 1024)
    local bottle_out = 0
    local out = peripheral.wrap(emptybottle_dest)
    for slot, _ in pairs(out.list()) do
        bottle_out = whi.DepositInAnyWarehouse(emptybottle_dest, slot)
    end
    print('in:', bottle_in, 'out:', bottle_out)
end


print('Starting Turtle Power (HIAHS)')
while true do
    if not pcall(FillGeneratorsFromHoneyStorage) then print('FillGeneratorsFromHoneyStorage() failed to complete') end

    -- pcall(FillGeneratorsFromHoneyStorage)
    -- FillGeneratorsFromHoneyStorage()

    -- if not pcall(HoneyBottleCubifier) then print('HoneyBottleCubifier() failed to complete') end

    -- pcall(HoneyBottleCubifier)
    HoneyBottleCubifier()

    sleep(WAIT_SECONDS)
end
