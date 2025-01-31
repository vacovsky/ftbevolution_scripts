-- turn on rednet
local local_modem = "bottom"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))

-- run service
shell.openTab("ender_empty")
