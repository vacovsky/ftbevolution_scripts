args = {...}
local client_id = tonumber(args[1])
local item_name = args[2]
local item_quantity = tonumber(args[3])
local strict = args[4]

local bm = require "lib/bm"

local buffer_names = {}

table.insert(buffer_names, bm.allocate())
table.insert(buffer_names, bm.allocate())

rednet.send(client_id, buffer_names, "storage_client")

-- give client 5 seconds to get their stuff
sleep(5)
for _, b in buffer_names do
    print(b)
    bm.release(b)
end

--max_request = 1024
--if item_quantity > max_request then
--    item_quantity = max_request
--end
