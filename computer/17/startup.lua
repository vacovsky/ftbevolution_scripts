
local whi = require 'lib/whi'
local xxxwhi = require 'lib/xxx_whi'
local vars = require 'lib/constants'

local buffer = 'minecraft:barrel_0'

print("drawer stackables warehouse audit")


function Reshuffle()
    moved = 0
    items = whi.ItemCountMap()

    for item, _ in pairs(items) do
        moved = moved + xxx_whi.GetFromAnyWarehouse(true, item, buffer)
        sleep(.2)

        for slot, item in pairs(peripheral.wrap(buffer).list()) do
            whi.DepositInAnyWarehouse(buffer, slot)
            sleep(.2)
        end
        print(moved, "moved")
    end
    sleep(30)
end

local LOOPS = 0
while true do
    -- if redstone.getInput('top') then
    pcall(Reshuffle)
    -- Main()
    if LOOPS >= vars.REBOOT_AFTER_LOOPS then os.reboot() end
    LOOPS = LOOPS + 1
end