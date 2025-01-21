local warehouse_interface = { _version = '0.0.6' }

local warehouses = {'functionalstorage:storage_controller', 'sophisticatedstorage:chest'} -- "pneumaticcraft:reinforced_chest"

function warehouse_interface.ItemCountMap()
    local itemCountMap = {}

    -- COLLECT WAREHOUSE NAMES
    local peripherals = peripheral.getNames()
    table.sort(peripherals)

    local warehouses_list = {}
    for index, attached_peripheral in pairs(peripherals) do
        for _, vessel in pairs(warehouses) do
            if string.find(attached_peripheral, vessel) then
                warehouses_list[#warehouses_list + 1] = attached_peripheral
            end
        end
    end

    for _, warehouse in pairs(warehouses_list) do
        local whp = peripheral.wrap(warehouse)
        for _, item in pairs(whp.list()) do
            if itemCountMap[item.name] then
                itemCountMap[item.name] = {
                    count = itemCountMap[item.name].count + item.count,
                    slots = itemCountMap[item.name].slots + 1
                }
            else
                itemCountMap[item.name] = {
                    count = 0 + item.count,
                    slots = 1
                }
            end
        end
    end
    return itemCountMap
end

function warehouse_interface.DepositInAnyWarehouse(sourceStorage, sourceSlot)
    -- print(sourceStorage, sourceSlot)
    local movedItemCount = 0
    local peripherals = peripheral.getNames()
    table.sort(peripherals)

    local warehouses_list = {}

    for index, attached_peripheral in pairs(peripherals) do
        for _, vessel in pairs(warehouses) do
            if string.find(attached_peripheral, vessel) then
                warehouses_list[#warehouses_list + 1] = attached_peripheral
            end
        end
    end

    for whi, warehouse in pairs(warehouses_list) do
        movedItemCount = movedItemCount + peripheral.wrap(warehouse).pullItems(sourceStorage, sourceSlot)
    end
    return movedItemCount
end

function warehouse_interface.GetFromAnyWarehouse(guess, itemName, destination, itemCount, toSlot)
    if not itemCount then itemCount = 64 end
    -- COLLECT WAREHOUSE NAMES
    local peripherals = peripheral.getNames()
    table.sort(peripherals)

    local warehouses_list = {}

    for index, attached_peripheral in pairs(peripherals) do
        for _, vessel in pairs(warehouses) do
            if string.find(attached_peripheral, vessel) then
                warehouses_list[#warehouses_list + 1] = attached_peripheral
            end
        end
    end

    -- SEARCH EACH WAREHOUSE FOR ITEM
    local foundCount = 0
    for whi, warehouse in pairs(warehouses_list) do
        local whp = peripheral.wrap(warehouse)
        for slot, item in pairs(whp.list()) do
            -- must be exact name match
            if not guess then
                if item.name == itemName then
                    local pushedCount = whp.pushItems(destination, slot, itemCount - foundCount, toSlot)
                    if pushedCount ~= nil then
                        foundCount = foundCount + pushedCount
                    end                    
                    if foundCount >= itemCount then
                        print('Order successfully filled!')
                        -- EXIT WHEN WE HAVE DELIVERED ENOUGH
                        print('Returned', itemCount, itemName)
                        goto found
                    end
                end
            else
                if string.find(item.name, itemName) then
                    local pushedCount = whp.pushItems(destination, slot, itemCount - foundCount, toSlot)
                    if pushedCount ~= nil then
                        foundCount = foundCount + pushedCount
                    end
                    if foundCount >= itemCount then
                        print('Order successfully filled!')
                        -- EXIT WHEN WE HAVE DELIVERED ENOUGH
                        print('Returned', itemCount, item.name)
                        goto found
                    end
                end
            end
            -- TODO fuzzy match here
            -- end fuzzy
        end
        if itemCount < foundCount then print('Only located', foundCount, 'of', itemCount) end
    end
    ::found::
    return foundCount
end


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
