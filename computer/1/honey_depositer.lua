local json = require "lib/json"
local vars = require "lib/constants"
local net = require "lib/network"

local fluid_source = 'enderstorage:ender_tank_1'

while true do
    local fluidPushed = 0
    local fluid_dests = net.ListMatchingDevices(vars.honey_storage)

    for _, fluid_dest in pairs(fluid_dests) do
        fluidPushed = fluidPushed + peripheral.wrap(fluid_source).pushFluid(fluid_dest)
    end

    print('xfer', fluidPushed, 'mb from ender tank')
    sleep(.5)
    fluidPushed = 0
end
