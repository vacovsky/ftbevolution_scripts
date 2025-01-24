local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'


local imbuementChamber = 'ars_nouveau:imbuement_chamber'

function ImbueStuff() 
    local stored = 0
    local imbuing = 0

    for _, ic in pairs(net.ListMatchingDevices(imbuementChamber)) do
        local icp = peripheral.wrap(ic)
        
        for slot, _ in pairs(icp.list()) do
            stored = stored + whi.DepositInAnyWarehouse(ic, slot)
        end
        imbuing = imbuing + whi.GetFromAnyWarehouse(false, 'minecraft:amethyst_shard', ic, 1)
    end
    print("stored", stored, "imbuing", imbuing)
end



print('Starting stats collection...')
while true do
    if not pcall(ImbueStuff) then print('ImbueStuff() failed to complete') end
    -- ImbueStuff()
    sleep(45)
end
