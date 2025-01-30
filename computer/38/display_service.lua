-- display_service.lua
-- storage_controller
local args = {...}
local display_name = args[1]

local kv = require "lib/kv"
local buffer_state_fn = "buffer_state" 


local display = peripheral.wrap(display_name)
display.setTextScale(2)
local ul = {["unlocked"]="U", ["locked"]="L"}
while true do
    local buffer_state = kv.read(buffer_state_fn)
    local row = 1
    for buffer_name, state in pairs(buffer_state) do
        display.setCursorPos(1, row)
        display.clearLine()
        display.write(string.format("%s - %s", string.match(buffer_name, ":(.*)"), ul[state]))
        row = row + 1
    end
    sleep(1)
end

