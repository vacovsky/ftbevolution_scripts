-- rednet.open("bottom")
local PROTOCOL = "whi_index"

local warehouse_interface = { _version = '0.0.10' }

local net = require "lib/network"

local warehouses_list = {'functionalstorage:storage_controller', 'sophisticatedstorage:chest'} -- "pneumaticcraft:reinforced_chest"

function warehouse_interface.InventoryUsedPercentage()
    local total_slots = 0
    local total_used_slots = 0
    local warehouses = net.ListMultipleMatchingDevices(warehouses_list)
    for _, wh in pairs(warehouses) do
        w = peripheral.wrap(wh)
        total_slots = total_slots + w.size()
        
        for _, elem in pairs(w.list()) do
            if elem ~= nil then
                total_used_slots = total_used_slots + 1
            end
        end
    end
    return total_used_slots, total_slots
end

function warehouse_interface.ItemLocationMap()
    local itemLocationIndex = {}
    local warehouses = {}
    warehouses = net.ListMultipleMatchingDevices(warehouses_list)

    for _, warehouse in pairs(warehouses) do
        local whp = peripheral.wrap(warehouse)
        for slot, item in pairs(whp.list()) do
            if itemLocationIndex[item.name] == nil then
                itemLocationIndex[item.name] = {
                    name = item.name,
                    warehouses = {}
                }
            end
            if itemLocationIndex[item.name].warehouses[warehouse] == nil then
                itemLocationIndex[item.name].warehouses[warehouse] = {
                    name = warehouse,
                    slots = {}
                }
            end
            table.insert(itemLocationIndex[item.name].warehouses[warehouse].slots, slot)
        end
    end
    return itemLocationIndex
end

function warehouse_interface.ItemCountMap()
    local itemCountMap = {}
    local warehouses = net.ListMultipleMatchingDevices(warehouses_list)

    for _, warehouse in pairs(warehouses) do
        local whp = peripheral.wrap(warehouse)
        for _, item in pairs(whp.list()) do
            if itemCountMap[item.name] then
                itemCountMap[item.name] = {
                    name = item.name,
                    count = itemCountMap[item.name].count + item.count,
                    slots = itemCountMap[item.name].slots + 1
                }
            else
                itemCountMap[item.name] = {
                    name = item.name,
                    count = 0 + item.count,
                    slots = 1
                }
            end
        end
    end
    return itemCountMap
end

function warehouse_interface.DepositInAnyWarehouse(sourceStorage, sourceSlot)
    local movedItemCount = 0
    local warehouses = net.ListMultipleMatchingDevices(warehouses_list)
    local source = peripheral.wrap(sourceStorage)
    for whi, warehouse in pairs(warehouses) do
        local w = peripheral.wrap(warehouse)
        if w.size() - #w.list() == 0 then goto skip_chest end
        movedItemCount = movedItemCount + w.pullItems(sourceStorage, sourceSlot)
        if source.list()[sourceSlot] == nil then goto done end
        ::skip_chest::
    end
    ::done::
    return movedItemCount
end


function warehouse_interface.GetFromAnyWarehouse(guess, itemName, destination, itemCount, toSlot)
    if not itemCount then itemCount = 64 end
    -- COLLECT WAREHOUSE NAMES
    local peripherals = peripheral.getNames()
    table.sort(peripherals)
    warehouses = net.ListMultipleMatchingDevices(warehouses_list)

    
    rednet.broadcast("index", PROTOCOL)
    local _, itemLocationsIndex, _ = rednet.receive(1)

    -- SEARCH EACH WAREHOUSE FOR ITEM
    local pushedCount = 0

    for itemKey, itemLocs in pairs(itemLocationsIndex) do
        if not guess and itemKey == itemName then
            for _, warehouse in pairs(itemLocs.warehouses) do
                local whp = peripheral.wrap(warehouse.name)
                for _, slot in pairs(warehouse.slots) do
                    pushedCount = pushedCount + whp.pushItems(destination, slot, itemCount - foundCount, toSlot)
                    if pushedCount >= itemCount then goto found end
                end
            end
        else 
            if string.find(itemKey, itemName) then
                for _, warehouse in pairs(itemLocs.warehouses) do
                    local whp = peripheral.wrap(warehouse.name)
                    for _, slot in pairs(warehouse.slots) do
                        pushedCount = pushedCount + whp.pushItems(destination, slot, itemCount - foundCount, toSlot)
                        if pushedCount >= itemCount then goto found end
                    end
                end
            end
        end
        if itemCount < pushedCount then print('Only located', pushedCount, 'of', itemCount) end
    end
    ::found::
    return pushedCount
end

-- function warehouse_interface.GetFromAnyWarehouse(guess, itemName, destination, itemCount, toSlot)
--     if not itemCount then itemCount = 64 end
--     -- COLLECT WAREHOUSE NAMES
--     local peripherals = peripheral.getNames()
--     table.sort(peripherals)
--     warehouses = net.ListMultipleMatchingDevices(warehouses_list)

--     -- SEARCH EACH WAREHOUSE FOR ITEM
--     local foundCount = 0
--     for whi, warehouse in pairs(warehouses) do
--         local whp = peripheral.wrap(warehouse)
--         for slot, item in pairs(whp.list()) do
--             -- must be exact name match
--             if not guess then
--                 if item.name == itemName then
--                     local pushedCount = whp.pushItems(destination, slot, itemCount - foundCount, toSlot)
--                     if pushedCount ~= nil then
--                         foundCount = foundCount + pushedCount
--                     end                    
--                     if foundCount >= itemCount then
--                         -- print('Order successfully filled!')
--                         -- EXIT WHEN WE HAVE DELIVERED ENOUGH
--                         print('OK', itemCount, itemName)
--                         goto found
--                     end
--                 end
--             else
--                 if string.find(item.name, itemName) then
--                     local pushedCount = whp.pushItems(destination, slot, itemCount - foundCount, toSlot)
--                     if pushedCount ~= nil then
--                         foundCount = foundCount + pushedCount
--                     end
--                     if foundCount >= itemCount then
--                         -- print('Order successfully filled!')
--                         -- EXIT WHEN WE HAVE DELIVERED ENOUGH
--                         print('OK', itemCount, itemName)
--                         goto found
--                     end
--                 end
--             end
--             -- TODO fuzzy match here
--             -- end fuzzy
--         end
--         if itemCount < foundCount then print('Only located', foundCount, 'of', itemCount) end
--     end
--     ::found::
--     return foundCount
-- end

function warehouse_interface.tprint(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint .. k .. "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent - 2) .. "}"
    print(toprint)
    return toprint
end



return warehouse_interface
