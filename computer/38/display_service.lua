-- display_service.lua
-- storage_controller
local args = {...}
local display_name = args[1]

local kv = require "lib/kv"
local buffer_state_fn = "buffer_state" 


local display = peripheral.wrap(display_name)
display.setTextScale(2)
local ul = {["unlocked"]="U", ["locked"]="L"}


function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
            else return a[i], t[a[i]]
        end
    end
    return iter
end


while true do
    local buffer_state = kv.read(buffer_state_fn)
    local row = 1

    local sortedBuffer = {}
    for buffer, state in pairsByKeys(buffer_state) do
        -- table.insert(sortedBuffer, buffer, state)
        -- print(name, line)
        sortedBuffer[buffer] = state
    end

    -- table.sort(buffer_state, function(a, b) return  a > b end)
    for buffer_name, state in pairs(sortedBuffer) do
        display.setCursorPos(1, row)
        display.clearLine()
        display.write(string.format("%s - %s", string.match(buffer_name, ":(.*)"), ul[state]))
        row = row + 1
    end
    sleep(1)
end

