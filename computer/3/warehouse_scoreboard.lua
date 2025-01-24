---@diagnostic disable: need-check-nil
----------------------------------
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'

-- CONFIGURATION SECTION
local REFRESH_TIME = 300

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

function DisplayLatestInfo()
    local item_freq = whi.ItemCountMap()
    local tempTbl = {}
    local wh_used, wh_total = whi.InventoryUsedPercentage()

    local data = {}
    for _, x in pairs(item_freq) do 
        table.insert(tempTbl, x)
        data[x.name] = x.count
    end
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


function Main()
    DisplayLatestInfo()
end

print('Starting colony stats board...')
while true do
    -- Main()
    pcall(Main)
    sleep(REFRESH_TIME)
end
