print("pulsing baby")
redstone.setOutput("back", true)
redstone.setOutput("left", true)
redstone.setOutput("right", true)
sleep(0)
redstone.setOutput("back", false)
redstone.setOutput("left", false)
redstone.setOutput("right", false)
print("pulsed")
