---@diagnostic disable: need-check-nil
----------------------------------
local whi = require 'lib/whi'

-- CONFIGURATION SECTION
local REFRESH_TIME = 60

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
    local whpercent_used = whi.InventoryUsedPercentage()
    for _, x in pairs(item_freq) do table.insert(tempTbl, x) end

    table.sort(tempTbl, function(a, b) return  a.count > b.count end)

    -- BEGING DISPLAY STUFF
    monitor.clear()

    local line = 1
    monitor.setTextScale(1)
    monitor.setCursorPos(1, line)
    monitor.setTextColor(8)
    monitor.write("TOP INVENTORY:", tostring(whpercent_used))
    -- RightJustify(tostring(whpercent_used), '% full', line)
    -- monitor.write(tostring(whpercent_used), '% full')


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
    Main()
    -- pcall(Main)
    sleep(REFRESH_TIME)
end
