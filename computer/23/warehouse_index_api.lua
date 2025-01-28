
rednet.open("top")
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'

local PROTOCOL = "whi_index"
print("Warehouse Inventory Index")


local INDEX = {}
local LAST_INDEX_UPDATE = os.epoch('utc')

function PopulateIndex()
    INDEX = whi.ItemLocationMap()
    tsdb.WriteOutput("ftb", "cache", INDEX, "index_cache.json")
end

print("Populating index...")
PopulateIndex()
LAST_INDEX_UPDATE = os.epoch('utc')
print("Populating index complete. Now serving!")

while true do
    local sender, message = rednet.receive(PROTOCOL)
    if message == "index" then
        rednet.send(sender, INDEX, PROTOCOL)
        print("Served", sender, PROTOCOL)
    end

    if os.epoch('utc') - LAST_INDEX_UPDATE > 10 then
        pcall(PopulateIndex)
        print("Index refreshed...")
    end
end

