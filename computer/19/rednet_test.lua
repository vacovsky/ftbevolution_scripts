
rednet.open("back")
local PROTOCOL = "whi_index"


rednet.broadcast("index", protocol)
senderId, message, protocol = rednet.receive(1)

for i, n in pairs(message) do print(i, n) end




-- print(senderId, message, protocol)
-- while true do
--     local sender, message = rednet.receive(protocol);
--     rednet.send(sender, INDEX, protocol)
--     print("Served", sender)
-- end
