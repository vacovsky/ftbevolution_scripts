local_modem = "bottom"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))

local controller_id = rednet.lookup("storage_controller")
rednet.send(controller_id, "get bananas 51", "storage_controller")
a,b,c = rednet.receive("storage_client", 10)
if a == nil then
    print("timed out")
end
print(a)
print(b)
if b ~= nil then
    print(b[1], b[2], b[3], b[4])
end
print(c)
