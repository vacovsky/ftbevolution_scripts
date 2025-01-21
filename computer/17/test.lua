
local whi = require 'lib/whi'
local net = require 'lib/network'

local warehouse = net.ListMultipleMatchingDevices({"functionalstorage:", "sophisticatedstorage:"})

for a, b in pairs(warehouse) do
    print(a, b)
end