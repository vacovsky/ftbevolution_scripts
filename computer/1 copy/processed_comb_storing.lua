local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"

local processed_outputs = 'enderstorage:ender_chest_5'

function CollectProcessedItems()
    local itemsMoved = 0
    local src = peripheral.wrap(processed_outputs) 
    for slot, item in pairs(src.list()) do
        itemsMoved = itemsMoved + whi.DepositInAnyWarehouse(processed_outputs, slot)
    end
    print(itemsMoved, 'xferred')
end

while true do
    if not pcall(CollectProcessedItems) then print('CollectProcessedItems() failed to complete') end
    -- pcall(CollectProcessedItems)
    sleep(1)
end
