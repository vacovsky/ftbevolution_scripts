local local_modem = "left"
rednet.open(local_modem)
rednet.host("right_computer", ("%s"):format(os.getComputerID()))

rednet.send(30, "potato", "left_computer------------------------------------------------------------")
