-- shell.openTab("kiosk_api")
-- shell.openTab("warehouse_index_api")



local local_modem = "top"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))


shell.openTab("migrate")
