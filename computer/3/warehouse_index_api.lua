
rednet.open("back")


local PROTOCOL = "warehouse_index"
print("Warehouse Inventory Index")

local INDEX = {
    ["minecraft:sand"] = {
        ["sophisticated_storage:chest_30"] = {
            2, 3, 65, 34, 87
        },
        ["sophisticated_storage:chest_17"] = {
            3,7,23
        }
    }
}



while true do
    local sender, message = rednet.receive(protocol)
    if message == "index" then
        rednet.send(sender, INDEX, protocol)
        print("Served", sender, message)
    end
    if message == "refresh" then
        rednet.send(sender, INDEX, protocol)
    end
end

