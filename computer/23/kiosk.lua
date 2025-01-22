rednet.open('top')

while true do
    local sender, message = rednet.receive('ender_orders_cyan');
    print(sender, message)
end