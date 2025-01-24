local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'


local imbuementChamber = 'ars_nouveau:imbuement_chamber'

function ImbueStuff() 
    local stored = 0
    local imbuing = 0

    for _, ic in pairs(net.ListMatchingDevices(imbuementChamber)) do
        local icp = peripheral.wrap(ic)
        
        for slot, item in pairs(icp.list()) do
            if item.name == "ars_nouveau:source_gem" then
                stored = stored + whi.DepositInAnyWarehouse(ic, slot)
            end
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
