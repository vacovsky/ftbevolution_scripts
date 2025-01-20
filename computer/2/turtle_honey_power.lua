local vars = require "lib/constants"
local honey_generator = 'productivebees:honey_generator'
local WAIT_SECONDS = 10
local json = require "json"
local COLONY_NAME = 'Nolins'


function Main()
    local honey_storage = {} --  'fluidTank_16'
    local honeyUsed = 0
    local peripherals = peripheral.getNames()

    for index, attached_peripheral in pairs(peripherals) do
        if string.find(attached_peripheral, vars.honey_storage) then
            honey_storage[#honey_storage + 1] = attached_peripheral
        end
    end

    for index, attached_peripheral in pairs(peripherals) do
        if string.find(attached_peripheral, honey_generator) then
            local gen = peripheral.wrap(attached_peripheral)

            for _, honeybucket in pairs(honey_storage) do
                print(attached_peripheral, honeybucket)

                print(gen.pullFluid(honeybucket))
                -- honeyUsed = honeyUsed + honey_source.pushFluid(attached_peripheral)
            end

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
    pcall(Main)
    -- Main()
    -- else
    --     print('Service Offline - Flip the lever on top!')
    -- end
    sleep(WAIT_SECONDS)
end
