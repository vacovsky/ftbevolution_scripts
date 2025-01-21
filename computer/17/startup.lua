
local whi = require 'lib/whi'
local xxx_whi = require 'lib/xxx_whi'
local vars = require 'lib/constants'

local buffer = 'minecraft:barrel_0'

print("drawer stackables warehouse audit")


function Reshuffle()
    moved = 0
    items = whi.ItemCountMap()

    for item, _ in pairs(items) do
        moved = moved + xxx_whi.GetFromAnyWarehouse(false, item, buffer, 64)
        sleep(.1)

        local shuffled = 0
        for slot, item in pairs(peripheral.wrap(buffer).list()) do
            shuffled = whi.DepositInAnyWarehouse(buffer, slot)
            sleep(.1)
        end
        
        if shuffled == 0 then
            print(item, "sent back")
            xxx_whi.DepositInAnyWarehouse(buffer, slot)
        else
            print(item, "relocated")
        end
        print(moved, "moved")
    end
end

local LOOPS = 0
while true do
    if redstone.getInput('top') then
        -- pcall(Reshuffle)
        Reshuffle()
    end
    -- Main()
    if LOOPS >= vars.REBOOT_AFTER_LOOPS then os.reboot() end
    LOOPS = LOOPS + 1
end