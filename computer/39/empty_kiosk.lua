-- empty_kiosk.lua
local sc = require "lib/sc"
local constants = require "lib/kiosk_const"
local kiosk_storage = constants.kiosk_storage
local idle_fn = "idle"
local idle_timer = constants.idle_timer

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
 
