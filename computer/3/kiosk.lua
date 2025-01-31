-- kiosk.lua
local sc = require "lib/sc"
local constants = require "lib/kiosk_const"

local kiosk_storage = constants.kiosk_storage
local idle_fn = "idle"

function write_idle()
    local open_file = io.open(idle_fn, "w")
    io.output(open_file)
    io.write("idle")
    io.close(open_file)
end

write_idle()
while true do
    write("\nenter <item> <quantity> <strict?>\n>>> ")
    local msg = read()
    local parts = string.gmatch(msg, "%S+")
    local item = parts(1)
    local quantity = parts(2)
    if item == nil or quantity == nil then goto inputend end
    local strict = parts(3) ~= nil
    local transferred = sc.pull(item, quantity, strict, kiosk_storage, nil)
    if transferred > 0 then
        write_idle()
    end
    print(string.format("transferred: %s", transferred))
    ::inputend::
end
