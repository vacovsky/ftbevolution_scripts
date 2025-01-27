---@diagnostic disable: need-check-nil
----------------------------------
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'

-- CONFIGURATION SECTION
local REFRESH_TIME = 60
local POWER_BANK = 'enderio:vibrant_capacitor_bank'
-- END CONFIGURATION SECTION
----------------------------------
local monitor = peripheral.find("monitor")

if monitor ~= nil then
    monitor.clear()
end

--------------------MONITOR---------------------
function RightJustify(input, line)
    monitor.setCursorPos(monitor.getSize() - string.len(input), line)
end

function WarehouseStats()
    local item_freq = whi.ItemCountMap()
    local tempTbl = {}
    local wh_used, wh_total = whi.InventoryUsedPercentage()

    local data = {
        ["minecraft:gold_ingot"] = 0,
        ["mysticalagradditions:insanium_essence"] = 0
    }
    for _, x in pairs(item_freq) do 
        table.insert(tempTbl, x)
        data[x.name] = x.count
    end

    data["warehouse_slots_total"] = wh_total
    data["warehouse_slots_used"] = wh_used

    print(wh_used, wh_total)
    table.sort(tempTbl, function(a, b) return  a.count > b.count end)

    tsdb.WriteOutput("FTBEvolution", "warehouse", data, "warehouse.json")

    -- BEGING DISPLAY STUFF
    monitor.clear()

    local line = 1
    monitor.setTextScale(1)
    monitor.setCursorPos(1, line)
    monitor.setTextColor(5)
    monitor.write("TOP INVENTORY - " .. tostring(wh_used) .. '/' .. tostring(wh_total))


    for _, entry in pairs(tempTbl) do
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(1)
        monitor.write(string.match(entry.name, ":(.*)"))
        RightJustify(entry.count, line)
        monitor.write(entry.count)
    end
end

function PowerStats() 
    local data = {
        energy_capacity = 0,
        energy_stored = 0
    }
    for _, batt in pairs(net.ListMatchingDevices(POWER_BANK)) do
        local powerPeripheral = peripheral.wrap(batt)
        data.energy_capacity = data.energy_capacity + powerPeripheral.getEnergyCapacity()
        data.energy_stored = data.energy_stored + powerPeripheral.getEnergy()
    end
    tsdb.WriteOutput("FTBEvolution", "power", data, "power.json")
end


print('Starting stats collection...')
while true do
    if not pcall(WarehouseStats) then print('WarehouseStats() failed to complete') end
    if not pcall(PowerStats) then print('PowerStats() failed to complete') end
    -- PowerStats()
    sleep(REFRESH_TIME)
end
