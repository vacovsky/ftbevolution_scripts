
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'


while true do
    local data = {
        heartbeat = 1,
    }
    print(os.epoch("utc"))
    tsdb.WriteOutput("FTBEvolution", "computer:25", data, "heartbeat.json")
    sleep(60)
end