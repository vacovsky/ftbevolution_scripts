local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'


local imbuementChamber = 'ars_nouveau:imbuement_chamber'
local amethysToGemIbuementChambers = {
    "ars_nouveau:imbuement_chamber_26",
    "ars_nouveau:imbuement_chamber_26",
    "ars_nouveau:imbuement_chamber_31",
    "ars_nouveau:imbuement_chamber_30",
    "ars_nouveau:imbuement_chamber_28",
    "ars_nouveau:imbuement_chamber_27",
}

function ImbueGemsToEssences() 
    local stored = 0
    local imbuing = 0

    for _, ic in pairs(net.ListMatchingDevices(imbuementChamber)) do
        local icp = peripheral.wrap(ic)
        
        for slot, item in pairs(icp.list()) do
            if item.name ~= "ars_nouveau:source_gem" then
                stored = stored + whi.DepositInAnyWarehouse(ic, slot)
            end
        end
        imbuing = imbuing + whi.GetFromAnyWarehouse(false, 'ars_nouveau:source_gem', ic, 1)
    end
end

function ImbueShardsToGems()
    local stored = 0
    local imbuing = 0
    for _, ic in pairs(amethysToGemIbuementChambers) do
        local icp = peripheral.wrap(ic)
        for slot, item in pairs(icp.list()) do
            if item.name ~= "minecraft:amethyst_shard" then
                stored = stored + whi.DepositInAnyWarehouse(ic, slot)
            end
        end
        imbuing = imbuing + whi.GetFromAnyWarehouse(false, "minecraft:amethyst_shard", ic, 1)
    end
    print("stored", stored, "imbuing", imbuing)
end


print('Imbuement starting...')
while true do
    ImbueShardsToGems()
    ImbueGemsToEssences()
    -- if not pcall(ImbueShardsToGems) then print('ImbueShardsToGems() failed to complete') end
    -- if not pcall(ImbueGemsToEssences) then print('ImbueGemsToEssences() failed to complete') end
    sleep(30)
end
