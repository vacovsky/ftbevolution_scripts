
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'

rednet.open("back")
local PROTOCOL = "whi_index"
print("Warehouse Inventory Index")
rednet.host(PROTOCOL, "INDEX")


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
    rednet.send(sender, INDEX, PROTOCOL)
    print("Served", sender, PROTOCOL)

    if os.epoch('utc') - LAST_INDEX_UPDATE > 30 then
        if not pcall(PopulateIndex) then print('PopulateIndex() failed to complete') end
        print("Index refreshed...")
    end
end

