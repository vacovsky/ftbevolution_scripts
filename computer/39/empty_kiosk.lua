-- empty_kiosk.lua
local sc = require "lib/sc"
local kiosk_storage = "sophisticatedstorage:chest_103"
local idle_fn = "idle"
local idle_timer = 60

local loops = -1
print("monitoring kiosk idleness")
while true do
    if fs.exists(idle_fn) then
        fs.delete(idle_fn)
        loops = idle_timer
    end
    if loops == 0 then
        local transferred = sc.push_all(kiosk_storage)
        print(string.format("returned: %s", transferred))
    end
    if loops >= 0 then loops = loops -1 end
    sleep(1)
end
 
