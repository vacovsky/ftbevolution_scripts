
rednet.open("top")
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'

local PROTOCOL = "whi_index"
print("Warehouse Inventory Index")

-- local INDEX = {
--     ["minecraft:sand"] = {
--         ["sophisticated_storage:chest_30"] = {
--             2, 3, 65, 34, 87
--         },
--         ["sophisticated_storage:chest_17"] = {
--             3,7,23
--         }
--     }
-- }



local INDEX = {}
local LAST_INDEX_UPDATE = os.epoch('utc')

function PopulateIndex()
    INDEX = whi.ItemLocationMap()
    -- for i, s in pairs(INDEX) do print(i, s) end
    tsdb.WriteOutput("ftb", "cache", INDEX, "index_cache.json")
end

print("Populating index...")
PopulateIndex()
print("Populating index complete. Now serving!")

while true do
    local sender, message = rednet.receive(PROTOCOL)
    if message == "index" then
        rednet.send(sender, INDEX, PROTOCOL)
        print("Served", sender, PROTOCOL)
    end
    if message == "refresh" then
        rednet.send(sender, INDEX, PROTOCOL)
    end
end

