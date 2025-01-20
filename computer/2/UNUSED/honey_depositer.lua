local json = require "lib/json"
local vars = require "lib/constants"

local honey_source = 'enderstorage:'
local honey_destination = 'basicFluidTank_5'

while true do
    local honeyPushed = 0
    honeyPushed = honeyPushed + peripheral.wrap(honey_source).pushFluid(honey_destination)
    print('Tranferred', honeyPushed, 'honey from ender tank')
    sleep(5)
    honeyPushed = 0
end
