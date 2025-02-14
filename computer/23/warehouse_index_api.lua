
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'

rednet.open("back")
local PROTOCOL = "whi_index"
print("Warehouse Inventory Index")
rednet.host(PROTOCOL, "INDEX")

local INDEX_REFRESH_DELAY = 30000 -- 30 seconds
local INDEX = {}
local LAST_INDEX_UPDATE = 0

function PopulateIndex()
    INDEX = whi.ItemLocationMap()
    LAST_INDEX_UPDATE = os.epoch('utc')
    tsdb.WriteOutput("ftb", "cache", INDEX, "index_cache.json")
end

print("Populating index...")
PopulateIndex()
print("Populating index complete. Now serving!")

while true do
    local sender, message = rednet.receive()
    rednet.send(sender, INDEX)
    print("Served", sender, PROTOCOL)


    if os.epoch('utc') - LAST_INDEX_UPDATE > INDEX_REFRESH_DELAY then
        print(os.epoch('utc'), LAST_INDEX_UPDATE, os.epoch('utc') - LAST_INDEX_UPDATE)
        if not pcall(PopulateIndex) then print('PopulateIndex() failed to complete') end
        print("Index refreshed...")
    end
end

