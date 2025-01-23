local whi = require 'lib/whi'
local net = require 'lib/network'

local fuelName = 'mysticalagradditions:insanium_apple'
local fuelEssence = 'mysticalagradditions:insanium_essence'
local fuelSource = 'enderio:crafter_1'
local goldenAppleCrafter = 'enderio:crafter_0'
local insaniumAppleCrafter = 'enderio:crafter_1'

local genNames = 'industrialforegoing:mycelial_culinary'

local raw_items = {
}

function AppleCrafterSupply()

    print(whi.GetFromAnyWarehouse(false, 'minecraft:gold_ingot', goldenAppleCrafter, 8), 'crafter: input gold_ingot')
    print(whi.GetFromAnyWarehouse(false, fuelEssence, insaniumAppleCrafter, 4), 'crafter: input insanium')
end


function FuelGenerators()
    local gens = net.ListMatchingDevices(genNames)
    local apple_crafter = peripheral.wrap(fuelSource)
    for slot, item in pairs(apple_crafter.list()) do
        if item.name == fuelName then
            local stored = 0
            stored = whi.DepositInAnyWarehouse(fuelSource, slot)
            -- local pushed = apple_crafter.pushItem(gen, slot)
            -- if pushed > 0 then print('pushed', pushed, 'apples') goto breakout end
        end
    end

    for _, gen in pairs(gens) do
        print(whi.GetFromAnyWarehouse(false, fuelName, gen, 1), gen .. ' fueled')
    end
end

while true do
    if not pcall(AppleCrafterSupply) then print('GoldenAppleCrafterSupply() failed to complete') end
    if not pcall(FuelGenerators) then print('FuelGenerators() failed to complete') end
    
    -- pcall(GoldenAppleCrafterSupply)
    -- AppleCrafterSupply()

    
    -- pcall(FuelGenerators)
    -- FuelGenerators()
    sleep(15)
end
