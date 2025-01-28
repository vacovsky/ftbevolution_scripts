
rednet.open("back")
local PROTOCOL = "joe_api"


-- rednet.broadcast("index", protocol)
-- senderId, message, protocol = rednet.receive(1)

for i, n in pairs(message) do print(i, n) end


-- print(senderId, message, protocol)
-- while true do
--     local sender, message = rednet.receive(protocol);
--     rednet.send(sender, INDEX, protocol)
--     print("Served", sender)
-- end




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
