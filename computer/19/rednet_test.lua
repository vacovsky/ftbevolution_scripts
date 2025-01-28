
rednet.open("back")
local PROTOCOL = "whi_index"


rednet.broadcast("index", protocol)
senderId, message, protocol = rednet.receive()

print(senderId, message, protocol)
-- while true do
--     local sender, message = rednet.receive(protocol);
--     rednet.send(sender, INDEX, protocol)
--     print("Served", sender)
-- end
