function x()
    print("start")
    --print("delay", delay)
    redstone.setOutput("right", true)
    redstone.setOutput("left", true)
    redstone.setOutput("back", true)
    sleep(0)
    redstone.setOutput("right", false)
    redstone.setOutput("left", false)
    redstone.setOutput("back", false)
    print("end")
end
loop = true
if loop == false then
    print("loop false")
    sleep(5)
    x()
end

while loop do
    print("loop start")
    x()
    sleep(1.5)
end
