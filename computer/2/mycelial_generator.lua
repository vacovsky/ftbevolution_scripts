local whi = require 'lib/whi'
local net = require 'lib/network'
local sc = require "lib/sc"

local fuelName = 'mysticalagradditions:insanium_apple'
local fuelEssence = 'mysticalagradditions:insanium_essence'
local fuelSource = 'enderio:crafter_1'
local goldenAppleCrafter = 'enderio:crafter_0'
local insaniumAppleCrafter = 'enderio:crafter_1'

local genNames = 'industrialforegoing:mycelial_culinary'

local raw_items = {
}

function AppleCrafterSupply()
    print(sc.pull("minecraft:gold_ingot", 8, true, goldenAppleCrafter, nil), "crafter: input gold_ingot")
    print(sc.pull(fuelEssence, 4, true, insaniumAppleCrafter, nil), "crafter: input insanium")
    --print(whi.GetFromAnyWarehouse(false, 'minecraft:gold_ingot', goldenAppleCrafter, 8), 'crafter: input gold_ingot')
    --print(whi.GetFromAnyWarehouse(false, fuelEssence, insaniumAppleCrafter, 4), 'crafter: input insanium')
end


function FuelGenerators()
    local gens = net.ListMatchingDevices(genNames)
    local stored = sc.push(fuelSource, 11)

    for _, gen in pairs(gens) do
        local w_gen = peripheral.wrap(gen)
        if w_gen.list()[1]["count"] <= 32 then
            local transferred = sc.pull(fuelName, 32, true, gen, nil)
            print(gen.." fueled: "..transferred)
        end
    end
end

while true do
    --print("calling applecraftersupply")
    if not pcall(AppleCrafterSupply) then print('GoldenAppleCrafterSupply() failed to complete') end
    --print("calling fuelgenerators")
    if not pcall(FuelGenerators) then print('FuelGenerators() failed to complete') end
    --print("end of loop")
    -- pcall(GoldenAppleCrafterSupply)
    -- AppleCrafterSupply()

    
    -- pcall(FuelGenerators)
    -- FuelGenerators()
    sleep(15)
end
