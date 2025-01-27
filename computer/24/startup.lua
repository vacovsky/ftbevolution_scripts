shell.openTab("source_stone_imbuer")

local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'
local enchants = require 'lib/ars_enchanter_recipes'

local ITEM_INPUT = 'minecraft:barrel_5'
local ITEM_OUTPUT = 'minecraft:barrel_6'
local arcanePedestals = 'ars_nouveau:arcane_pedestal'
local enchanter = 'ars_nouveau:enchanting_apparatus_0'



function UnloadAllPedestals() 
    local peds = net.ListMatchingDevices(arcanePedestals)
    for _, ped in pairs(peds) do
        local p = peripheral.wrap(ped)
        for slot, item in pairs(p.list()) do 
            whi.DepositInAnyWarehouse(ped, slot)
        end
    end
end

function ReturnTargetItemToUser()
    local ea = peripheral.wrap(enchanter)
    for slot, item in pairs(ea.list()) do
        ea.pushItems(ITEM_OUTPUT, slot)
    end
end

function PlaceTargetItemInEnchanter()
    local input = peripheral.wrap(ITEM_INPUT)
    local ea = peripheral.wrap(enchanter)
    for slot, item in pairs(input.list()) do
        ea.pullItems(ITEM_INPUT, slot)
    end
end

function LoadPedestalsWithMaterials(recipe)
    local peds = net.ListMatchingDevices(arcanePedestals)
    for _, mat in pairs(recipe) do
        local moved = 0
        for _, ped in pairs(peds) do
            moved = whi.GetFromAnyWarehouse(false, mat, ped, 1)
            if moved > 0 then goto next end
        end
        ::next::
    end
end

function EnchantItem(recipe)
    term.clear()
    print("\n\n             Enchanting", recipe, 
    "\n\n             This may take a while")
    print("\n \n \n \n \n")
    UnloadAllPedestals()
    LoadPedestalsWithMaterials(enchants[recipe])
    PlaceTargetItemInEnchanter()
    sleep(15)
    ReturnTargetItemToUser()
end

while true do
    term.clear()
    term.setBackgroundColor(colors.black)

    print("Enter enchant name from the list below. Item in the left storage will be enchanted, if possible.\n\n")
    for name, _ in pairs(enchants) do
        print(name)
    end
    write("\n\nENCH_UI> ")
    local msg = read()
    if msg == nil then goto continue end
    local words = {}
    for word in msg:gmatch("%S+") do
        pcall(table.insert, words, word)
    end
    if not pcall(EnchantItem, words[1]) then print('EnchantItem() failed to complete') end
    ::continue::
end


-- while true do
--     if not pcall(EnchantItem, enchants.soulbound) then print('EnchantItem() failed to complete') end
--     -- EnchantItem(enchants.soulbound)
--     sleep(1)
-- end