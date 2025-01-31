local sc = require 'lib/sc'
local net = require 'lib/network'


local chests = net.ListMatchingDevices("sophisticatedstorage:chest_")

for _, chest in pairs(chests) do
    local moved = sc.push_all(chest)
    print(moved, "from", chest)
end