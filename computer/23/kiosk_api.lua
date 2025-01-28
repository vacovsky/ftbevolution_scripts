rednet.open('top')

local DON_API = 'dons_bag'
local JOE_API = 'joes_bag'

while true do
    local sender, message = rednet.receive('ender_orders_cyan');
    local sender, message = rednet.receive('ender_orders_cyan');
    print(sender, message)
end