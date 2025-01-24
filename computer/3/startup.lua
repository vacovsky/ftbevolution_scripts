

local whi = require 'lib/whi'
local var = require 'lib/constants'


shell.openTab("warehouse_vacuum")
shell.openTab("warehouse_returns")
shell.openTab("warehouse_scoreboard")


local LAST_SELECTION = ''

local WAREHOUSE = 'minecraft:chest'
local MAX_ITEM_COUNT = 9999
local DESTINATION_STORAGE = 'sophisticatedstorage:barrel_1'
local ITEM_NAME_MIN = 4

function DeliverItem(itemName, itemCount, exact)
    exact = exact == "x"
    if itemName == nil then return true end
    -- ENFORCE MINIMUM ITEM NAME
    if string.len(itemName) < 4 then print('Supplied item name must be at least', ITEM_NAME_MIN, 'letters.') return true end

    if itemCount == nil then itemCount = 64 end
    -- ENFORCE ITEM LIMITS
    if itemCount > MAX_ITEM_COUNT then print('Max item count allowed is', MAX_ITEM_COUNT)
        itemCount = MAX_ITEM_COUNT
    end
    foundCount = 0
    if exact then
        foundCount = foundCount + whi.GetFromAnyWarehouse(false, itemName, DESTINATION_STORAGE, itemCount, slot)
    else
        foundCount = foundCount + whi.GetFromAnyWarehouse(true, itemName, DESTINATION_STORAGE, itemCount, slot)
    end    
    print('delivered', foundCount, itemName)
    return true
end

print('Type an item name and count - if we have any, items will be delivered instantly to the attached chest.\n\nUse format: <itemname> <count>\nexample:  iron_ingot 32')
while true do
    write("\n\nWARES_UI> ")
    local msg = read()
    if msg == nil then goto continue end
    local words = {}
    for word in msg:gmatch("%S+") do
        pcall(table.insert, words, word)
    end
    pcall(DeliverItem(words[1], tonumber(words[2]), words[3]))
    ::continue::
end